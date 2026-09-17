#!/usr/bin/env bash
# Stops the local stack; keeps volumes.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
docker compose --env-file .env -f deploy/compose.dev.yaml --profile observability down
