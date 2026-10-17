#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
bash scripts/compose.sh exec -T minio sh -ec \
  'mc alias set practice http://localhost:9000 practice-admin practice-local-password >/dev/null; mc ls --recursive --json practice/warehouse' \
  > results/s3_objects.jsonl
