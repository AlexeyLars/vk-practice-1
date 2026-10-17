#!/usr/bin/env python3
import json
from urllib.parse import urlparse
from trino_client import RESULTS, query

inventory = [json.loads(line) for line in (RESULTS / 's3_objects.jsonl').read_text().splitlines()]
assert all(row['status'] == 'success' for row in inventory), 'S3 listing failed'
objects = {row['key']: row['size'] for row in inventory if row['type'] == 'file'}
tables = json.loads((RESULTS / 'bronze_tables.json').read_text())
tables += [r for r in json.loads((RESULTS / 'layers.json').read_text()) if r['schema'] != 'bronze']
checked = []
for table in tables:
    schema, name = table['schema'], table['table']
    files = query(f'SELECT file_path, file_size_in_bytes FROM lakehouse.{schema}."{name}$files" '
                  'WHERE content = 0', 's3-verify')['rows']
    for path, size in files:
        key = urlparse(path).path.lstrip('/')
        assert objects[key] == size, f'S3 size differs: {path}'
    assert sum(size for _, size in files) == table['bytes']
    properties = dict(query(f'SELECT key, value FROM lakehouse.{schema}."{name}$properties"',
                            'properties')['rows'])
    assert properties['format-version'] == '2', properties
    expected_codec = table.get('codec', 'ZSTD').lower()
    expected_format = table.get('format', 'PARQUET').lower()
    stored_codec = 'uncompressed' if expected_codec == 'none' else expected_codec
    assert properties[f'write.{expected_format}.compression-codec'] == stored_codec, properties
    checked.append({'table': schema + '.' + name, 'files': len(files), 'bytes': table['bytes'],
                    'matches_actual_s3': True, 'format_version': 2,
                    'format': expected_format, 'codec': expected_codec})
result = {'status': 'passed', 'tables_verified': len(checked),
          'all_bucket_object_bytes': sum(objects.values()), 'tables': checked}
(RESULTS / 'storage_validation.json').write_text(json.dumps(result, indent=2) + '\n')
print(f'S3: all {len(checked)} table sizes, Iceberg versions and compression properties verified')
