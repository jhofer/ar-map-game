# Hellgate World

Location-based territory-conquest game. Unity client, .NET server. See [docs/README.md](docs/README.md) for design and architecture.

## Setup

Target: ten minutes on a clean machine.

1. Install the tools listed in [`.tool-versions`](.tool-versions):

   | Tool | Install from |
   |---|---|
   | .NET SDK | [dotnet.microsoft.com/download](https://dotnet.microsoft.com/download) |
   | Node.js | [nodejs.org](https://nodejs.org) |
   | Docker Engine or Colima | [docs.docker.com/engine/install](https://docs.docker.com/engine/install/) / [github.com/abiosoft/colima](https://github.com/abiosoft/colima) |
   | Git LFS | [git-lfs.com](https://git-lfs.com) |
   | jq | [jqlang.org/download](https://jqlang.org/download/) |
   | Unity Hub | [unity.com/download](https://unity.com/download) — install the Unity 6 LTS (`6000.x`) editor through the Hub |

2. `scripts/bootstrap.sh` — checks the toolchain, installs git hooks and docs-check dependencies.
3. `scripts/dev-up.sh` — starts PostgreSQL/PostGIS and MinIO.
4. `scripts/verify.sh` — format, build, test, docs. The same entry point CI uses.

## Scripts

| Script | Does | Run it |
|---|---|---|
| `scripts/bootstrap.sh` | Checks tools against `.tool-versions`; installs git hooks and docs-check dependencies | Once per machine, and after `.tool-versions` changes |
| `scripts/check-docs.sh` | Link, anchor and mermaid checks over `docs/**/*.md` | Standalone, or via `verify.sh` / the pre-commit hook |
| `scripts/dev-up.sh` | Starts the local stack (`--observability` adds Prometheus + Grafana) | Before running the server locally |
| `scripts/dev-down.sh` | Stops the local stack; keeps volumes | End of a session |
| `scripts/dev-reset.sh` | Stops the local stack and deletes all volumes | To force a clean database and empty buckets |
| `scripts/verify.sh` | Format → build → test → docs; the CI entry point | Before every commit and PR |

## Local Services

| Service | Port | Credentials | Console |
|---|---|---|---|
| PostgreSQL / PostGIS | `${POSTGRES_PORT}` (`.env`) | `POSTGRES_USER` / `POSTGRES_PASSWORD` (`.env`) | — |
| MinIO | `${MINIO_PORT}` (`.env`) | `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` (`.env`) | http://localhost:9001 |
| Prometheus (`--observability`) | `${PROMETHEUS_PORT}` (`.env`) | — | http://localhost:9090 |
| Grafana (`--observability`) | `${GRAFANA_PORT}` (`.env`) | `admin` / `GRAFANA_ADMIN_PASSWORD` (`.env`) | http://localhost:3000 |

## Windows

Use WSL2 with Docker Engine installed inside WSL; run every script from the WSL shell.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `bootstrap: FAIL (version)` | Installed tool version doesn't match the required prefix in `.tool-versions` | Install the exact major/minor version listed |
| `docker compose … --wait` times out | A service failed its healthcheck | `docker compose -f deploy/compose.dev.yaml logs <service>` |
| Port already in use | Another process holds a port `.env` maps | Change the `*_PORT` variable in `.env`, or stop the other process |
| `postgis_version()` missing after reset | `deploy/postgres/init/` only runs on first volume init | `scripts/dev-reset.sh` first, then `scripts/dev-up.sh` |
| `check-docs` fails on an anchor with `&` | GitHub's slug rule drops the `&` and leaves a double hyphen | Write the anchor as `foo--bar`, not `foo-and-bar` |
| Unity not detected | `bootstrap.sh` only checks Unity Hub's default install folders | Set `UNITY_EDITOR_PATH` to the editor executable |

## Documentation

[docs/design/](docs/design/README.md) · [docs/architecture/](docs/architecture/README.md) · [docs/grundlagen/](docs/grundlagen/README.md) · [docs/features/](docs/features/README.md)
