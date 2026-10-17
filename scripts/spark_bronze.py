import json
from decimal import Decimal
from pathlib import Path
from pyspark.sql import SparkSession

spark = (SparkSession.builder.appName('practice-1-bronze-Q10')
    .config('spark.sql.extensions', 'org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions')
    .config('spark.sql.catalog.lakehouse', 'org.apache.iceberg.spark.SparkCatalog')
    .config('spark.sql.catalog.lakehouse.type', 'rest')
    .config('spark.sql.catalog.lakehouse.uri', 'http://lakekeeper:8181/catalog')
    .config('spark.sql.catalog.lakehouse.warehouse', 'practice')
    .config('spark.sql.catalog.lakehouse.io-impl', 'org.apache.iceberg.aws.s3.S3FileIO')
    .config('spark.sql.catalog.lakehouse.s3.endpoint', 'http://minio:9000')
    .config('spark.sql.catalog.lakehouse.s3.path-style-access', 'true')
    .config('spark.sql.catalog.lakehouse.client.region', 'us-east-1')
    .config('spark.sql.shuffle.partitions', '4')
    .getOrCreate())
spark.sparkContext.setLogLevel('WARN')
counts = {}
for table in ['customer', 'orders', 'lineitem', 'nation']:
    counts[table] = spark.table('lakehouse.bronze.' + table).count()
    print(f'BRONZE {table}: {counts[table]} rows')
expected_counts = json.loads(Path('/work/results/source_counts.json').read_text())
assert counts == expected_counts, 'Spark Bronze counts differ from TPC-H source'
spark.sql('SELECT orderkey, linenumber, extendedprice, discount, returnflag '
          'FROM lakehouse.bronze.lineitem ORDER BY orderkey, linenumber LIMIT 5').show(truncate=False)
sql = Path('/work/sql/q10.sql').read_text().format(source='lakehouse.bronze')
frame = spark.sql(sql)
frame.show(20, truncate=False)
rows = [row.asDict() for row in frame.collect()]
gold = json.loads(Path('/work/results/gold_top20.json').read_text())
max_error = Decimal(0)
assert len(rows) == len(gold) == 20
for actual, expected in zip(rows, gold):
    for key, value in actual.items():
        if key in ('revenue', 'acctbal'):
            error = abs(Decimal(str(value)) - Decimal(str(expected[key])))
            max_error = max(max_error, error)
            assert error <= Decimal('0.000001'), (key, value, expected[key])
        else:
            assert value == expected[key], (key, value, expected[key])
result = {'engine': 'Apache Spark ' + spark.version, 'catalog': 'Lakekeeper REST',
          'storage': 'same Bronze objects in Silo S3', 'bronze_counts': counts,
          'q10_matches_gold': True, 'all_columns_compared': True,
          'max_abs_error': str(max_error), 'top20': rows}
Path('/work/results/spark_bronze.json').write_text(json.dumps(result, indent=2, default=str) + '\n')
print('SUCCESS: Spark read Bronze via REST/S3 and independently reproduced Q10')
spark.stop()
