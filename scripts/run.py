#!/usr/bin/env python3
import argparse
import csv
import json
import random
import statistics
from datetime import datetime, timezone
from decimal import Decimal

from trino_client import ROOT, RESULTS, execute_file, query, statements

SQL = ROOT / 'sql'
TABLES = ['customer', 'orders', 'lineitem', 'nation']
CONFIGS = [
    ('bronze_parquet_none', 'PARQUET', 'NONE'),
    ('bronze_parquet_snappy', 'PARQUET', 'SNAPPY'),
    ('bronze_parquet_gzip', 'PARQUET', 'GZIP'),
    ('bronze', 'PARQUET', 'ZSTD'),
    ('bronze_orc_zstd', 'ORC', 'ZSTD'),
]


def save(name, data):
    (RESULTS / name).write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')


def load(name):
    return json.loads((RESULTS / name).read_text())


def csv_file(name, rows):
    if not rows:
        return
    with (RESULTS / name).open('w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def q10(source):
    return (SQL / 'q10.sql').read_text().format(source=source)


def check_result(rows, expected, label, tolerance=Decimal('0.000001')):
    assert len(rows) == len(expected) == 20, f'{label}: expected 20 rows'
    max_error = Decimal(0)
    for actual, reference in zip(rows, expected):
        for index, (a, b) in enumerate(zip(actual, reference)):
            if index in (2, 3):
                error = abs(Decimal(str(a)) - Decimal(str(b)))
                max_error = max(error, max_error)
                assert error <= tolerance, f'{label}: monetary mismatch {a} != {b}'
            else:
                assert a == b, f'{label}: column {index}: {a!r} != {b!r}'
    return float(max_error)


def table_metrics(schema, table):
    name = f'lakehouse.{schema}.{table}'
    rows = query(f'SELECT count(*) FROM {name}', f'count:{schema}.{table}')['rows'][0][0]
    data = query(
        f'SELECT count(*), coalesce(sum(file_size_in_bytes), 0), coalesce(sum(record_count), 0) '
        f'FROM lakehouse.{schema}."{table}$files" WHERE content = 0',
        f'files:{schema}.{table}',
    )['rows'][0]
    assert rows == data[2], f'{name}: file records differ from SQL count'
    return {'schema': schema, 'table': table, 'rows': rows, 'files': data[0],
            'bytes': data[1], 'mb': data[1] / 1_000_000}


def benchmark(args):
    rng = random.Random(20261017)
    baseline = query(q10('tpch.' + args.scale), 'baseline:tpch')
    save('baseline.json', baseline)
    reference = baseline['rows']
    source_counts = {t: query(f'SELECT count(*) FROM tpch.{args.scale}.{t}', 'source:' + t)['rows'][0][0]
                     for t in TABLES}
    save('source_counts.json', source_counts)
    writes = []
    for repeat in range(1, args.write_repeats + 1):
        configs = list(CONFIGS)
        rng.shuffle(configs)
        for schema, fmt, codec in configs:
            print(f'WRITE {repeat}/{args.write_repeats} {fmt}/{codec}', flush=True)
            query(f'CREATE SCHEMA IF NOT EXISTS lakehouse.{schema}', 'create-schema')
            for table in TABLES:
                query(f'DROP TABLE IF EXISTS lakehouse.{schema}.{table}', 'drop:' + table)
            results = execute_file(SQL / '01_bronze.sql', schema=schema, format=fmt,
                                   codec=codec, scale=args.scale)
            ctas = results[1:]
            writes.append({'schema': schema, 'format': fmt, 'codec': codec, 'repeat': repeat,
                           'seconds': sum(r['seconds'] for r in ctas),
                           'engine_ms': sum(r['stats']['elapsedTimeMillis'] for r in ctas),
                           'query_ids': ','.join(r['query_id'] for r in ctas)})
            csv_file('write_runs.csv', writes)
    metrics = []
    for schema, fmt, codec in CONFIGS:
        for table in TABLES:
            metric = table_metrics(schema, table)
            assert metric['rows'] == source_counts[table], f'Incomplete Bronze: {schema}.{table}'
            metric.update(format=fmt, codec=codec)
            metrics.append(metric)
    csv_file('bronze_tables.csv', metrics)
    save('bronze_tables.json', metrics)
    for schema, fmt, codec in CONFIGS:
        result = query(q10('lakehouse.' + schema), 'warmup:' + schema)
        check_result(result['rows'], reference, 'warmup:' + schema)
    reads = []
    for repeat in range(1, args.read_repeats + 1):
        configs = list(CONFIGS)
        rng.shuffle(configs)
        for schema, fmt, codec in configs:
            result = query(q10('lakehouse.' + schema), f'benchmark:{schema}:{repeat}')
            error = check_result(result['rows'], reference, schema)
            reads.append({'schema': schema, 'format': fmt, 'codec': codec, 'repeat': repeat,
                          'seconds': result['seconds'],
                          'engine_ms': result['stats']['elapsedTimeMillis'],
                          'cpu_ms': result['stats']['cpuTimeMillis'],
                          'processed_rows': result['stats']['processedRows'],
                          'processed_bytes': result['stats']['processedBytes'],
                          'query_id': result['query_id'], 'max_abs_error': error})
            print(f'READ {repeat}/{args.read_repeats} {fmt}/{codec}: {result["seconds"]:.3f}s', flush=True)
            csv_file('query_runs.csv', reads)
    summary = []
    for schema, fmt, codec in CONFIGS:
        w = [r['seconds'] for r in writes if r['schema'] == schema]
        r = [r['seconds'] for r in reads if r['schema'] == schema]
        summary.append({'schema': schema, 'format': fmt, 'codec': codec,
                        'bytes': sum(m['bytes'] for m in metrics if m['schema'] == schema),
                        'write_median_s': statistics.median(w), 'write_min_s': min(w), 'write_max_s': max(w),
                        'query_median_s': statistics.median(r), 'query_min_s': min(r), 'query_max_s': max(r),
                        'query_stdev_s': statistics.stdev(r) if len(r) > 1 else 0,
                        'write_repeats': len(w), 'query_repeats': len(r)})
    csv_file('benchmark_summary.csv', summary)
    save('benchmark_summary.json', summary)


def layers(args):
    for schema, tables in [('gold', ['top20_returned_customers']),
                            ('silver', ['returned_items', 'customers'])]:
        query(f'CREATE SCHEMA IF NOT EXISTS lakehouse.{schema}', 'create-schema')
        for table in tables:
            query(f'DROP TABLE IF EXISTS lakehouse.{schema}.{table}', 'drop:' + table)
    execute_file(SQL / '02_silver.sql')
    execute_file(SQL / '03_gold.sql')
    checks = []
    for sql in statements(SQL / '04_quality.sql'):
        result = query(sql, 'quality')
        name, violations = result['rows'][0]
        checks.append({'check': name, 'violations': violations, 'query_id': result['query_id']})
        assert violations == 0, f'{name}: {violations} violations'
    bronze_total = query("""SELECT count(*), CAST(sum(CAST(l.extendedprice AS DECIMAL(15,2)) *
        (DECIMAL '1.00' - CAST(l.discount AS DECIMAL(4,2)))) AS DECIMAL(30,4))
        FROM lakehouse.bronze.orders o JOIN lakehouse.bronze.lineitem l ON o.orderkey=l.orderkey
        WHERE o.orderdate >= DATE '1993-10-01' AND o.orderdate < DATE '1994-01-01'
          AND l.returnflag='R'""", 'bronze:quarter-total')
    silver_total = query('SELECT count(*), CAST(sum(net_revenue) AS DECIMAL(30,4)) '
                         'FROM lakehouse.silver.returned_items', 'silver:quarter-total')
    assert bronze_total['rows'] == silver_total['rows'], 'Silver lost or changed returned items'
    duplicate = query('SELECT count(*) FROM (SELECT orderkey, linenumber FROM '
                      'lakehouse.silver.returned_items GROUP BY 1,2 HAVING count(*) > 1)', 'silver:duplicates')
    assert duplicate['rows'][0][0] == 0
    gold = query('SELECT * FROM lakehouse.gold.top20_returned_customers ORDER BY revenue DESC, custkey', 'gold')
    max_error = check_result(gold['rows'], load('baseline.json')['rows'], 'gold vs TPC-H')
    records = [dict(zip(gold['columns'], row)) for row in gold['rows']]
    csv_file('gold_top20.csv', records)
    save('gold_top20.json', records)
    metrics = [table_metrics('bronze', t) for t in TABLES]
    metrics += [table_metrics('silver', t) for t in ['customers', 'returned_items']]
    metrics += [table_metrics('gold', 'top20_returned_customers')]
    csv_file('layers.csv', metrics)
    save('layers.json', metrics)
    save('validation.json', {'status': 'passed', 'quality_checks': checks,
        'silver_duplicate_keys': 0, 'quarter_count_and_revenue': silver_total['rows'][0],
        'gold_rows': len(records), 'gold_max_abs_error_vs_tpch': max_error,
        'comparison_tolerance': '0.000001', 'all_gold_columns_compared': True})
    print('LAYERS: Gold equals original TPC-H Q10; all quality checks passed', flush=True)


def file_list(schema, table):
    return query(f'SELECT file_path FROM lakehouse.{schema}."{table}$files" ORDER BY 1', 'files')['rows']


def demos(args):
    before_files = file_list('silver', 'customers')
    before_count = query('SELECT count(*) FROM lakehouse.silver.customers', 'evolution:before')['rows'][0][0]
    query('ALTER TABLE lakehouse.silver.customers ADD COLUMN source_system VARCHAR', 'evolution:add')
    query('ALTER TABLE lakehouse.silver.customers RENAME COLUMN source_system TO source_label', 'evolution:rename')
    describe = query('DESCRIBE lakehouse.silver.customers', 'evolution:describe')['rows']
    null_count = query('SELECT count(*) FROM lakehouse.silver.customers WHERE source_label IS NULL', 'evolution:nulls')['rows'][0][0]
    after_files = file_list('silver', 'customers')
    assert before_files == after_files and null_count == before_count
    query('ALTER TABLE lakehouse.silver.customers DROP COLUMN source_label', 'evolution:cleanup')
    save('schema_evolution.json', {'rows_before': before_count, 'new_column_null_rows': null_count,
                                  'data_files_unchanged': True, 'describe_after_rename': describe,
                                  'data_file_paths': before_files, 'demo_column_removed_after_check': True})
    table = 'lakehouse.gold.recovery_demo'
    query(f'DROP TABLE IF EXISTS {table}', 'recovery:drop-demo')
    query(f"CREATE TABLE {table} WITH (format='PARQUET', compression_codec='ZSTD') AS "
          'SELECT * FROM lakehouse.gold.top20_returned_customers', 'recovery:create')
    snapshot = query('SELECT snapshot_id FROM lakehouse.gold."recovery_demo$snapshots" '
                     'ORDER BY committed_at DESC LIMIT 1', 'recovery:snapshot')['rows'][0][0]
    expected = query(f'SELECT * FROM {table} ORDER BY revenue DESC, custkey', 'recovery:before')['rows']
    key = expected[0][0]
    query(f'DELETE FROM {table} WHERE custkey = {key}', 'recovery:delete')
    remaining = query(f'SELECT count(*) FROM {table}', 'recovery:after-delete')['rows'][0][0]
    old = query(f'SELECT * FROM {table} FOR VERSION AS OF {snapshot} ORDER BY revenue DESC, custkey',
                'recovery:time-travel')['rows']
    assert remaining == 19 and old == expected
    rollback = f'ALTER TABLE {table} EXECUTE rollback_to_snapshot({snapshot})'
    query(rollback, 'recovery:rollback')
    restored = query(f'SELECT * FROM {table} ORDER BY revenue DESC, custkey', 'recovery:restored')['rows']
    assert restored == expected
    history = query('SELECT * FROM lakehouse.gold."recovery_demo$history" ORDER BY made_current_at', 'recovery:history')
    save('time_travel.json', {'snapshot_id': snapshot, 'deleted_custkey': key, 'rows_before': 20,
                            'rows_after_delete': remaining, 'time_travel_rows': len(old),
                            'restored_rows': len(restored), 'full_result_restored': True,
                            'history_columns': history['columns'], 'history': history['rows']})
    (RESULTS / 'recovery.sql').write_text(
        f'SELECT * FROM {table} FOR VERSION AS OF {snapshot};\n{rollback};\n')
    print('DEMOS: schema evolution without file rewrite and snapshot rollback passed', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--phase', choices=['all', 'benchmark', 'layers', 'demos'], default='all')
    parser.add_argument('--scale', default='sf1', choices=['sf1'])
    parser.add_argument('--write-repeats', type=int, default=3)
    parser.add_argument('--read-repeats', type=int, default=5)
    args = parser.parse_args()
    if args.write_repeats < 1 or args.read_repeats < 1:
        parser.error('Repeat counts must be positive')
    RESULTS.mkdir(exist_ok=True)
    if args.phase in ('all', 'benchmark'):
        save('run_info.json', {'started_at': datetime.now(timezone.utc).isoformat(),
                               'scale': args.scale, 'seed': 20261017,
                               'write_repeats': args.write_repeats, 'read_repeats': args.read_repeats,
                               'trino_version': query('SELECT version()', 'version')['rows'][0][0]})
        benchmark(args)
    if args.phase in ('all', 'layers'):
        layers(args)
    if args.phase in ('all', 'demos'):
        demos(args)
    print('SUCCESS', flush=True)
