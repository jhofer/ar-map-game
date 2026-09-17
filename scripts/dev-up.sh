#!/usr/bin/env bash
# Starts the local stack. Add --observability for Prometheus + Grafana.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

[[ -f .env ]] || { cp .env.example .env; echo "dev-up: created .env from .env.example"; }

profile_args=()
[[ "${1:-}" == "--observability" ]] && profile_args=(--profile observability)

docker compose --env-file .env -f deploy/compose.dev.yaml "${profile_args[@]}" up -d --wait
docker compose --env-file .env -f deploy/compose.dev.yaml ps
echo "dev-up: postgres :${POSTGRES_PORT:-5432}, minio :${MINIO_PORT:-9000} (console :${MINIO_CONSOLE_PORT:-9001})"
