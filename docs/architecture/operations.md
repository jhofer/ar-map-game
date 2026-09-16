# Operations, Phases, Risks

[← Technical Architecture](README.md)

## Operations

| Concern | Stage 0–1 | Stage 2+ |
|---|---|---|
| Deploy | `docker compose` on one host, image from CI | Rolling deploy, multiple nodes |
| Config | Env vars (infrastructure); versioned game config with hot reload — see [Game Config](live-ops.md#game-config) | Per-region overrides |
| Logs | Structured JSON to disk | Shipped to a log service (free tier first) |
| Metrics | Prometheus + Grafana on box; gameplay events in Postgres — see [Gameplay Metrics](live-ops.md#gameplay-metrics) | Grafana Cloud / self-hosted stack; events in ClickHouse |
| Errors | Sentry free tier | Paid tier |
| Backups | `pg_dump` to object storage, nightly | Managed PITR |
| Map data refresh | Manual pipeline run | Scheduled, with coverage diff report |

## Build Phases

| Phase | Deliverable | Stack added |
|---|---|---|
| P0 | Map pipeline for one city; tiles render in Unity; GPS avatar with follow camera | Pipeline, tile format, renderer |
| P1 | Conquest + points, server-authoritative, one region; config versions + first balance dashboard | Gateway, region actor, Postgres, Prometheus, Grafana |
| P2 | Interest streaming across cells; multiple players | Interest manager, deltas, reconnect |
| P3 | RTS: units, routing, stations, combat tick | Routing service, combat |
| P4 | Demons, hellgates, Essence, gear | Demon director, economy service |
| P5 | Scale-out: shards, gateways, monitoring | Redis shard map, multi-node |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Custom renderer underestimated | Schedule | Narrow scope (extrusion + instancing); SDK fallback behind an interface |
| Map data quality per region | Playability | Coverage cascade + per-cell quality score; gate region launch on the score |
| ODbL share-alike interpretation | Legal | Keep derived map data as a separable produced work; attribution screen; avoid mixing game state into distributed map data |
| Region actor hot spots (mass events) | Latency | Per-region tick throttling, participant caps |
| GPS accuracy vs. fixed conquest radius | Frustration | Accuracy-aware validation, snap tolerance, server-side smoothing |
| Vendor free tiers change | Cost | No component depends on a single vendor's free tier; tiles and DB are portable |
| Single-node failure at stage 0–1 | Downtime | Nightly backups, infrastructure as code, accepted for a private alpha |
