# F01 — Dev Environment

[← Features](README.md)

Implementation plan: [f01-dev-environment-plan.md](f01-dev-environment-plan.md).

**Goal:** a fresh clone on a fresh machine builds, runs and tests the whole stack with one command, before any project or game code exists.

**Implements:** [Tech Stack § Tooling & Delivery](../architecture/tech-stack.md#tooling--delivery), [Version Matrix](../architecture/tech-stack.md#version-matrix), [Operations](../architecture/operations.md#operations), [CLAUDE.md § Verification Before Commit](../../CLAUDE.md).

## Scope

### Toolchain

| Deliverable | Detail |
|---|---|
| `global.json` | Pins the .NET 10 SDK feature band; a mismatched SDK fails loudly, not silently |
| `.tool-versions` | Declares every required tool and version in one file: .NET SDK, Node 22 (for the docs check), Unity 6 LTS, Docker, Git LFS, `jq` |
| `scripts/bootstrap.sh` | Checks each tool against `.tool-versions`, prints a table of found vs. required, installs Git LFS and the git hooks, exits non-zero on any mismatch |
| Windows | Supported through WSL2 only; documented, not scripted twice |

### Local Services

| Deliverable | Detail |
|---|---|
| `deploy/compose.dev.yaml` | PostgreSQL 18 + PostGIS 3.6, MinIO (S3 API, stands in for R2), Prometheus + Grafana behind an `observability` profile |
| Init SQL | `CREATE EXTENSION postgis;`, the `game` role and database, applied on first start |
| MinIO bootstrap | Creates the `tiles` bucket with a public-read policy, mirroring the CDN's access shape |
| `scripts/dev-up.sh` / `dev-down.sh` / `dev-reset.sh` | Start, stop, and wipe volumes for a clean slate |
| `.env.example` | Every variable the stack reads, with safe local defaults; the real `.env` is git-ignored |

### Repository Hygiene

| Deliverable | Detail |
|---|---|
| `.gitignore` | Unity (`Library/`, `Temp/`, `Logs/`, `Builds/`) and .NET (`bin/`, `obj/`) |
| `.gitattributes` | Git LFS for `.blend`, `.fbx`, `.png`, `.psd`, `.tga`; `* text=auto eol=lf` |
| `.editorconfig` | One file, shared by the .NET analyzers and the Unity editor — see [Cross-Cutting Rules](../architecture/code-patterns.md#cross-cutting-rules) |
| Pre-commit hook | Runs `dotnet format --verify-no-changes` and the docs check on staged files; installed by `bootstrap.sh`, skippable with `--no-verify` |

### Verification Scripts

| Deliverable | Detail |
|---|---|
| `scripts/verify.sh` | Format check → build → test → docs check. The same script CI calls in F02, so "works locally" and "passes CI" cannot diverge |
| `scripts/check-docs.sh` | Resolves every relative link and anchor in `docs/**/*.md` against GitHub slug rules, and parses every mermaid block with the real mermaid parser (`tools/docs-check/`, Node); non-zero exit on any failure |
| `.claude/settings.json` | `SessionStart` hook running `scripts/bootstrap.sh --ci`, so a Claude Code web session can build and test without manual setup |
| Root `README.md` | The ten-minute setup: clone → bootstrap → dev-up → verify, plus a troubleshooting table |

## Out of Scope

| Item | Goes to |
|---|---|
| Any `.csproj`, `.slnx` or Unity project | F02 |
| CI workflows | F02 |
| Valhalla container | The routing feature in P3 |
| Production deployment, secrets management | F02 |

## Acceptance

| # | Check |
|---|---|
| 1 | On a machine with no toolchain, `bootstrap.sh` names every missing tool and its required version, and exits non-zero |
| 2 | `dev-up.sh` reaches healthy: `SELECT postgis_version()` returns 3.6, the MinIO console answers, the `tiles` bucket exists |
| 3 | `dev-reset.sh` followed by `dev-up.sh` yields an empty database with PostGIS present |
| 4 | `verify.sh` is green on the repository as it stands (docs only), and red when a broken link is introduced |
| 5 | `check-docs.sh` catches a deliberately broken anchor and a deliberately malformed mermaid block |
| 6 | The pre-commit hook blocks a commit with unformatted C# once F02 adds C# |
| 7 | A second developer follows the root README on a clean machine and reaches a green `verify.sh` without asking a question |
| 8 | A Claude Code web session starts, the `SessionStart` hook completes, and `verify.sh` runs in that session |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Unity cannot be installed headless from a script | `bootstrap.sh` cannot be fully automatic | Unity is checked, not installed; the README links the Hub install and the exact version |
| Docker Desktop licence or resource limits on the dev machine | Local stack unusable | Compose file works with Docker Engine + Colima; no Desktop-only features |
| PostGIS image tag moves | "Works on my machine" drift | Pin by digest, not by tag |
| Scripts rot because CI has its own copy of the steps | Local and CI diverge | CI calls `verify.sh`; duplicating steps in a workflow is a review blocker |
| MinIO behaves differently from R2 | Surprises at first real upload | Use the S3 API surface only — no MinIO-specific calls; the bucket policy mirrors the CDN's |
