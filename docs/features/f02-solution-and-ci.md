# F02 — Solution Skeleton & CI/CD

[← Features](README.md)

**Goal:** the repository layout exists, compiles on both toolchains, enforces its own boundaries, and every push produces a deployed server and an installable client.

**Implements:** [Repository Layout](../architecture/code-patterns.md#repository-layout), [Shared Assembly Rules](../architecture/code-patterns.md#shared-assembly-rules), [Tech Stack](../architecture/tech-stack.md#tech-stack), [Operations](../architecture/operations.md#operations).

## Scope

### Solution

| Deliverable | Detail |
|---|---|
| Projects | Exactly the tree in [Repository Layout](../architecture/code-patterns.md#repository-layout): `Game.Shared`, `Server.Host` plus one project per module, `Game.Pipeline`, test projects |
| Build config | `.slnx`, `Directory.Build.props` (nullable, `TreatWarningsAsErrors` in CI), `Directory.Packages.props` (central package versions) |
| `Game.Shared` | `netstandard2.1`, `LangVersion 9`, carrying `.csproj` + `package.json` + `.asmdef` in one folder; contains a `ProtocolVersion` constant and nothing else yet |
| Server host | Generic Host + Kestrel, `/healthz`, `/metrics`, JSON console logging, module registration in the composition root only |
| Pipeline | .NET console app that runs, prints its version, and exits 0 |

### Unity Client

| Deliverable | Detail |
|---|---|
| Project | Unity 6 LTS, URP mobile renderer, IL2CPP + ARM64, Android and iOS targets configured |
| Packages | VContainer, UniTask, R3, Cinemachine 3, Input System, UI Toolkit; NuGet-only libraries via NuGetForUnity, all pinned |
| Shared reference | `Packages/manifest.json` references `../src/Shared` by `file:` — one source, two compilers |
| Assemblies | `Game.Client.Core` with `noEngineReferences: true`, `Game.Client.Unity` on top; `csc.rsp` enables nullable |
| Scene | One bootstrap scene with a `LifetimeScope`, an empty ground plane, and nothing else |

### Enforcement

| Deliverable | Detail |
|---|---|
| NetArchTest suite | Dependencies point at `Game.Shared` only; `Game.Shared` references nothing; persistence types never leak into domain modules |
| Analyzer baseline | `.editorconfig` rules promoted to errors in CI; no baseline-suppression file |
| Codec round-trip test | A placeholder MemoryPack contract serialized by the server project and deserialized by a test compiled against the Unity assembly definition |

### Pipeline (CI/CD)

| Workflow | Does |
|---|---|
| `server.yml` | `scripts/verify.sh`, tests with Testcontainers (PostgreSQL + PostGIS), `dotnet publish /t:PublishContainer` → GHCR, tagged by commit SHA |
| `client.yml` | GameCI `unity-test-runner` (EditMode + PlayMode), then `unity-builder` for an Android APK; artifact attached to the run |
| `docs.yml` | `scripts/check-docs.sh` on every PR touching `docs/**` |
| `deploy.yml` | On `main`: pulls the SHA-tagged image on the VPS over SSH, `docker compose up -d`, waits for `/healthz`, rolls back to the previous tag on failure |

### Observability

| Deliverable | Detail |
|---|---|
| Metrics | OpenTelemetry meters exposed at `/metrics`; one gameplay-independent counter (`app_start_total`) proves the path end to end |
| Errors | Sentry .NET SDK on the server, Sentry Unity SDK on the client, same project, release tagged with the commit SHA |
| Dashboard | One Grafana dashboard: process up, request rate, error rate |

## Out of Scope

| Item | Goes to |
|---|---|
| Any message contract beyond `ProtocolVersion` | F03 |
| Auth, WebSocket endpoint | F03 |
| Store upload lanes (fastlane) | [F06](f06-store-delivery.md#release-lanes) |
| iOS build on a macOS runner | [F06](f06-store-delivery.md#signing-and-accounts); Android proves the pipeline first |
| Database schema, migrations with content | F04 (first table: accepted fixes) |

## Acceptance

| # | Check |
|---|---|
| 1 | A PR runs all four workflows; a failing format, test or docs check blocks the merge |
| 2 | A deliberate bad project reference (`Game.Shared` → `Server.Simulation`) fails the NetArchTest suite |
| 3 | Editing one type in `Game.Shared` changes both the server build and the Unity compile, with no copy step |
| 4 | The Unity build artifact installs on a physical Android device and shows the empty scene |
| 5 | Merging to `main` deploys the image; `/healthz` answers 200 from the VPS and the SHA in `/metrics` matches the commit |
| 6 | A forced failing health check triggers the rollback path and the previous image serves again |
| 7 | A thrown test exception appears in Sentry, tagged with the commit SHA, from both client and server |
| 8 | Full CI wall-clock time stays under 20 minutes (estimate — measure and record in the run summary) |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| GameCI Unity licence activation in CI | Client workflow cannot run | Personal licence secret configured and validated as the first job; documented re-activation procedure |
| IL2CPP or stripping breaks a package only in a device build | Green CI, broken app | The Android build job runs on every PR, not nightly; a smoke PlayMode test asserts DI resolution |
| `netstandard2.1` + C# 9 limits bite late | Rewrites in `Game.Shared` | Language limits enforced by the project file from day one — see [Language Limits](../architecture/code-patterns.md#language-limits) |
| Deploy over SSH is fragile | Broken deploys, manual recovery | Health check plus automatic rollback; the deploy step is idempotent and re-runnable |
| CI minutes cost on the Unity job | Budget | Android build only on PR and `main`; caches for Library and NuGet |
