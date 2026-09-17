#!/usr/bin/env bash
# Stops the local stack and deletes all volumes: a clean database and empty buckets.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
docker compose --env-file .env -f deploy/compose.dev.yaml --profile observability down --volumes --remove-orphans
echo "dev-reset: volumes removed"
