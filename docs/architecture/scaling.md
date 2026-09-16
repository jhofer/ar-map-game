# Scaling & Cost

[← Technical Architecture](README.md)

## Scaling Model

*Grundlagen: [Grössenordnungen](../grundlagen/11-groessenordnungen.md#11-grössenordnungen).*

| Dimension | Grows with | Mitigation |
|---|---|---|
| Live regions | Active players, geographic spread | Lazy wake/dormancy; region actors |
| Connections | CCU | Stateless gateways behind a load balancer |
| Entity count per region | Player activity (units, structures) | Per-player and per-building caps (design doc) |
| Static data volume | Ingested area | Regional ingest; CDN; immutable versions |
| Durable writes | Active players | Write-behind batching; hot state in memory |
| Routing requests | Unit orders | Cache routes per (origin cell, target cell); precomputed contraction hierarchies |

| Stage | DAU | Peak CCU | Live regions | Shape |
|---|---|---|---|---|
| 0 — Alpha | 5 | ~3 | ≤ 10 | 1 VPS: app + Postgres + tiles for one city |
| 1 — Closed beta | 100 | ~15 | ~50 | 1 larger VPS, Postgres separated, regional tiles |
| 2 — Soft launch | 1 000 | ~150 | ~400 | 2–3 app nodes, managed Postgres, Redis, planet tiles |
| 3 — Launch | 10 000 | ~1 500 | ~3 000 | Sharded sim, gateway tier, read replicas, routing cluster |

Rule of thumb: a region at 2 Hz with ~200 entities costs well under 1 ms of CPU per tick. A single modern core handles hundreds of live regions; players, not the world, set the bill.

### Scale-Out Thresholds

Provisional values until the P2 load test replaces them. Any one sustained for 10 min starts the [scale-out track](operations.md#scale-out-track).

| Signal | Threshold |
|---|---|
| p95 tick duration of the busiest region | > 50 % of the tick period (250 ms at 2 Hz) |
| Connections per node | > 2 000 |
| Live regions per node | > 500 |
| Write-behind queue depth | > 5 s of events |

### Load Shedding

| Pressure | Response |
|---|---|
| Delta backlog per session | Drop to coarse updates (state-only, no interpolation data) |
| Region overloaded (mass event) | Lower tick rate for that region; cap concurrent participants |
| Gateway saturation | Reject new connections with retry-after; existing sessions unaffected |
| Routing saturation | Queue with deadline; fall back to straight-line ETA with penalty |

## Cost Model

Principle: **no fixed vendor floors.** Every component is either a VPS we size ourselves, or usage-billed with a real free tier.

### Recurring

| Stage | Compute | Database | Tiles / CDN | Other | Est. €/month |
|---|---|---|---|---|---|
| 0 — 5 players | Hetzner CX22 ~€4.5 | On the same box | R2 free tier (10 GB, no egress fee) | Domain ~€1 | **~€6** |
| 1 — 100 DAU | CX32/CPX21 ~€10 | Same box or Neon/Supabase free–paid | R2 region extracts ~€1 | Sentry/Grafana free tiers | **~€15–25** |
| 2 — 1 000 DAU | 2–3 nodes ~€40 | Managed Postgres ~€25–50 | Planet tiles ~120 GB ≈ €2 | Monitoring ~€0–20 | **~€80–150** |
| 3 — 10 000 DAU | Sharded, ~8 nodes ~€200 | HA Postgres ~€150 | ~€5 | Monitoring, push, ops ~€50 | **~€400–600** |

Marginal cost per active player at stage 2–3: roughly **€0.05–0.15/month**. Hetzner-class hosting includes generous traffic; R2 charges no egress — so the two metrics that usually explode (bandwidth, map API calls) are flat here.

### One-Off / Annual

| Item | Cost |
|---|---|
| Unity Personal | €0 (free under $200k revenue/funding; Runtime Fee cancelled) |
| Apple Developer Program | $99/year |
| Google Play Developer | $25 once |
| Map data (Overture/OSM) | €0 + attribution obligations |

### Cost Traps to Avoid

| Trap | Impact | Avoided by |
|---|---|---|
| Per-MAU map SDK (Mapbox and similar) | Cost scales with players forever | Own tiles on object storage |
| Photorealistic 3D Tiles (per root-tile request) | Enterprise SKU, request-billed | Own geometry, stylized art |
| Managed game backend plans (e.g. Heroic Cloud, Satori from ~$600/mo) | Four-figure floor at 5 players | OSS or custom on a VPS |
| Hyperscaler egress ($0.08–0.12/GB) | Scales with tile downloads | R2 / B2 / VPS-included traffic |
| Always-on managed Kubernetes / service mesh | Fixed monthly + ops time | Single container; orchestration only at stage 3 |
| Ticking the whole world | CPU proportional to ingested area | Lazy regions |
| Per-seat editor licences | Not applicable at this revenue | Unity Personal |
