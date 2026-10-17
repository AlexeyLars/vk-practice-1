#!/usr/bin/env python3
import json
import os
import urllib.error
import urllib.request

BASE = os.environ.get('LAKEKEEPER_URL', 'http://127.0.0.1:18181')


def request(path, data=None):
    req = urllib.request.Request(
        BASE + '/management/v1/' + path,
        data=None if data is None else json.dumps(data).encode(),
        headers={'Content-Type': 'application/json'},
    )
    with urllib.request.urlopen(req, timeout=60) as response:
        body = response.read()
        return json.loads(body) if body else {}


if __name__ == '__main__':
    info = request('info')
    if not info.get('bootstrapped', False):
        request('bootstrap', {'accept-terms-of-use': True})
    project = '00000000-0000-0000-0000-000000000000'
    warehouses = request('warehouse?project-id=' + project).get('warehouses', [])
    if not any(w.get('warehouse-name') == 'practice' for w in warehouses):
        result = request('warehouse', {
            'warehouse-name': 'practice', 'project-id': project,
            'storage-profile': {
                'type': 's3', 'bucket': 'warehouse', 'key-prefix': 'practice-1',
                'endpoint': 'http://minio:9000', 'region': 'us-east-1',
                'path-style-access': True, 'flavor': 'minio', 'sts-enabled': False,
            },
            'storage-credential': {
                'type': 's3', 'credential-type': 'access-key',
                'aws-access-key-id': 'practice-admin',
                'aws-secret-access-key': 'practice-local-password',
            },
        })
        print(json.dumps(result, indent=2))
    else:
        print('Warehouse practice already exists')
