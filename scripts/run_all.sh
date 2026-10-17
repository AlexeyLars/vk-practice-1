#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="/opt/homebrew/bin:$PATH"
mkdir -p results/logs
bash scripts/compose.sh --profile tools pull
bash scripts/compose.sh up -d --wait
python3 scripts/bootstrap.py
bash scripts/compose.sh ps -a > results/docker-ps.txt
docker version > results/docker-version.txt
docker image inspect \
  pgsty/silo:RELEASE.2026-09-03T13-18-01Z postgres:16.10 \
  quay.io/lakekeeper/catalog:v0.10.0 trinodb/trino:481 apache/spark:3.5.7 \
  --format '{{.RepoTags}} {{.Architecture}} {{.RepoDigests}}' > results/images.txt
python3 -u scripts/run.py | tee results/run.log
bash scripts/compose.sh --profile tools run --rm spark 2>&1 | tee results/spark.log
bash scripts/inventory.sh
python3 scripts/verify_storage.py
printf '\nГотово: results/gold_top20.csv, results/benchmark_summary.csv\n'
