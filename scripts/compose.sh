#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export PATH="/opt/homebrew/bin:$PATH"
if docker compose version >/dev/null 2>&1; then
  exec docker compose "$@"
else
  exec docker-compose "$@"
fi
