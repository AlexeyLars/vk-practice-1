import json
import os
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / 'results'


def query(sql, label='', session=None):
    RESULTS.mkdir(exist_ok=True)
    sql = sql.strip().rstrip(';')
    headers = {
        'X-Trino-User': 'proskuryakov',
        'X-Trino-Source': 'vk-practice-1',
        'Content-Type': 'text/plain; charset=utf-8',
    }
    if session:
        headers['X-Trino-Session'] = ','.join(f'{k}={v}' for k, v in session.items())
    url = os.environ.get('TRINO_URL', 'http://127.0.0.1:18080') + '/v1/statement'
    req = urllib.request.Request(url, data=sql.encode(), headers=headers)
    start = time.perf_counter()
    rows, columns = [], []
    while True:
        with urllib.request.urlopen(req, timeout=600) as response:
            result = json.load(response)
        if 'error' in result:
            raise RuntimeError(f"{label}: {result['error'].get('message')}\nSQL: {sql}")
        if 'columns' in result:
            columns = [c['name'] for c in result['columns']]
        rows.extend(result.get('data', []))
        if 'nextUri' not in result:
            break
        req = urllib.request.Request(result['nextUri'], headers=headers)
    record = {
        'label': label, 'query_id': result['id'], 'seconds': time.perf_counter() - start,
        'columns': columns, 'rows': rows, 'stats': result.get('stats', {}),
    }
    with (RESULTS / 'queries.jsonl').open('a') as f:
        f.write(json.dumps(record, ensure_ascii=False) + '\n')
    with (RESULTS / 'executed.sql').open('a') as f:
        f.write(f'{sql};\n\n')
    return record


def statements(path, **params):
    text = Path(path).read_text()
    if params:
        text = text.format(**params)
    text = '\n'.join(line for line in text.splitlines() if not line.lstrip().startswith('--'))
    return [part.strip() for part in text.split(';') if part.strip()]


def execute_file(path, **params):
    return [query(sql, Path(path).name) for sql in statements(path, **params)]


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('sql', help='SQL text or a .sql file path')
    args = parser.parse_args()
    candidate = Path(args.sql)
    text = candidate.read_text() if args.sql.endswith('.sql') and candidate.is_file() else args.sql
    print(json.dumps(query(text), indent=2, ensure_ascii=False))
