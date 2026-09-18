# Open Technical Questions & Decision Log

[← Technical Architecture](README.md)

## Open Technical Questions

None. Every question raised so far has a recorded decision below. New questions get a row here with a date; a decision moves the row to the log and the rule to its topic file.

## Measurement Gates

Decisions that stand until a named measurement says otherwise. The decision is made; the number is not final.

| Decision | Gate | Measured in |
|---|---|---|
| r9 interest cells | Cell snapshot ≤ ~30 KB in a dense core, else r10 | P2 |
| `pocketken.H3` managed port | Parity test against H3 v4 reference vectors in CI, else P/Invoke | Before P2 |
| Scale-out thresholds | Replaced by P2 load-test numbers | P2 |
| Camera zoom band 40–400 m | Device-tier profiling | P1 |
| Wire budget estimates | Confirmed against a real region | P2 |
| Render budget on placeholder primitives | Stress fixture at worst-case triangle and material counts | P1, re-checked per authored batch |
| Traverse arcs and turn rates | Share of tick time spent turning, per archetype | P3 |
| Own shard map over Orleans | Handoff reliability in the P2 load test | P2 |

## Decision Log

Decisions made 2026-09-16.

### Map Data and Rendering

| Question | Decision | Recorded in |
|---|---|---|
| Ring simplification tolerance, LOD for dense cores | Douglas-Peucker 0.5 m; one zoom level in data; client LOD by camera distance, small-volume buildings dropped first | [Map Data § Geometry Processing](map-data.md#geometry-processing), [Client § LOD](client.md#lod) |
| Avatar smoothing filter | Exponential moving average, α by accuracy class; no Kalman | [Client § Avatar Position Pipeline](client.md#avatar-position-pipeline) |
| Heading source | Course over ground above 1.0 m/s, compass below, last heading otherwise | [Client § Avatar Position Pipeline](client.md#avatar-position-pipeline) |
| Street layer | Rendered ribbon geometry from polylines, no baked texture | [Client § Client Layers](client.md#client-layers) |
| Building kit | Procedural extrusion for all kinds; authored models for Landmark and Hospital at launch | [Client § Client Layers](client.md#client-layers) |
| Own-building tint path | Per-vertex building index + per-chunk state buffer; no property blocks, no mesh rebuild | [Client § Building Tint](client.md#building-tint) |
| Camera zoom band | 40–400 m provisional; zoom drives LOD and label density | [Client § Camera](client.md#camera), [Client § LOD](client.md#lod) |
| Earcut robustness | Validate and repair in the pipeline; bounding-rectangle fallback on the client | [Map Data § Geometry Processing](map-data.md#geometry-processing), [Tech Stack § Client](tech-stack.md#client) |
| Data refresh: ownership across data versions | Keep by ID; else match by centroid ≤ 5 m and footprint IoU > 0.5; else release | [Map Data § Data Refresh](map-data.md#data-refresh) |
| On-demand region ingest | Manual in P1; automatic per r6 cell on first fix from P2 | [Map Data § Ingest Trigger](map-data.md#ingest-trigger) |
| Tile serving (recorded explicitly 2026-09-18) | No tile server at any stage: immutable files on object storage behind a CDN. Pipeline, format and renderer are own code; serving is not | [Map Data § Delivery](map-data.md#delivery-no-tile-server) |

### Streaming and Simulation

| Question | Decision | Recorded in |
|---|---|---|
| Interest cell resolution | r9, with a measurement gate | [Streaming § Spatial Index](streaming.md#spatial-index) |
| Region resolution | r8 | [Streaming § Spatial Index](streaming.md#spatial-index) |
| Progress resync interval | Fixed 5 s for moving entities | [Streaming § Movement](streaming.md#movement-route--progress) |
| Route quantization | 0.5 m simplification, 2 cm quantization | [Streaming § Movement](streaming.md#movement-route--progress) |
| Vision-filter cost | Cached per-player circle list bucketed by r9 cell | [Streaming § Vision Cache](streaming.md#vision-cache) |
| Wake latency budget | 500 ms p95 to first snapshot | [Streaming § Wake Latency](streaming.md#wake-latency) |
| Routing engine | Valhalla | [Backend § Routing Engine](backend.md#routing-engine) |
| Timer queue durability | PostgreSQL-backed, in-memory heap per node | [Backend § Timer Queue](backend.md#timer-queue) |
| Persistence cadence | Journal 1 s, snapshot 5 min, economy durable-first | [Backend § Persistence Cadence](backend.md#persistence-cadence) |
| Redis introduction point | First multi-node deploy (stage 2) | [Backend § Sharding](backend.md#sharding) |
| Scale-out thresholds | Provisional table; replaced by P2 numbers | [Scaling § Scale-Out Thresholds](scaling.md#scale-out-thresholds) |
| Shard map and handoff protocol | Freeze → transfer → ack → delete; idempotent by `seq`; reload on restart | [Backend § Sharding](backend.md#sharding) |
| Push notifications | FCM + APNs via `FirebaseAdmin`; one push per 10 min, aggregated; opt-in on first attack | [Backend § Push Notifications](backend.md#push-notifications) |
| SpacetimeDB for the live plane | No — custom actor layer stays; vendor and billing risk | [Backend § Framework Evaluation](backend.md#framework-evaluation-backend) |
| Own actor vs. Orleans on scale-out | Own shard map first | [Tech Stack § Actor Choice](tech-stack.md#actor-choice) |
| Order spam | Technical rate limit, 20 orders per 10 s | [Anti-Cheat](anti-cheat.md#anti-cheat) |
| Avatar target selection (2026-09-17) | New `SetTarget` intent, validated server-side for visibility, stance and range; rate-limited like `SetStation` | [Anti-Cheat](anti-cheat.md#anti-cheat) |
| Ghost state and revival (2026-09-17) | Server-side; presence-gated intents from a ghost rejected; revival resolves from the server's own fix | [Anti-Cheat](anti-cheat.md#anti-cheat) |
| Respawn point storage (2026-09-17) | Per-player state, never serialized into another player's stream | [Streaming § Subscription Set](streaming.md#subscription-set) |
| Facing representation (2026-09-17) | Derived on both sides from route, `baseYaw` and `target`; no yaw per tick | [Rotation § Principle](rotation.md#principle) |
| Facing determinism (2026-09-17) | One step function in `Game.Shared`, integrated by `dt`; client divergence is presentation only | [Rotation § Shared Step Function](rotation.md#shared-step-function) |
| Fire gate authority (2026-09-17) | Server-side per tick; the client's angle never decides damage | [Rotation § Server Evaluation](rotation.md#server-evaluation) |

### Security and Operations

| Question | Decision | Recorded in |
|---|---|---|
| Attestation strictness | Log-only in stage 0–1; basic integrity enforced from stage 2 | [Anti-Cheat § Attestation Strictness](anti-cheat.md#attestation-strictness) |
| Admin UI for game config | One static schema-driven page served by the server | [Game Config](live-ops.md#game-config) |
| Event store switch point | Dashboard query > 5 s p95 or > 50 M rows | [Game Config & Metrics § Stages](live-ops.md#stages) |
| Per-region config overrides | Not before stage 2 | [Game Config](live-ops.md#game-config) |
| Event retention | Raw 90 days; daily aggregates 2 years | [Gameplay Metrics § Event Pipeline](live-ops.md#event-pipeline) |

### Toolchain and Assets

| Question | Decision | Recorded in |
|---|---|---|
| `pocketken.H3` parity | Managed port with a CI parity gate | [Tech Stack § Server](tech-stack.md#server) |
| Unity CoreCLR adoption | Only with an LTS that ships it; Shared retargets in the same change | [Tech Stack § Version Matrix](tech-stack.md#version-matrix) |
| Native location plugin | Own thin plugin, foreground only | [Tech Stack § Client](tech-stack.md#client) |
| Image-to-3D service | Rodin on a commercial plan; TRELLIS for experiments only | [Tech Stack § Tooling & Delivery](tech-stack.md#tooling--delivery) |
| Rigging | One humanoid skeleton for all faction units; one per demon body type | [Asset Pipeline § Flow](asset-pipeline.md#flow) |
| glTF vs. FBX | FBX | [Asset Pipeline § Model Conventions](asset-pipeline.md#model-conventions) |
| Art for the build phases (2026-09-17) | Unity built-in primitives per entity kind, final dimensions, no authored meshes | [Placeholder Assets § Primitive Catalogue](placeholder-assets.md#primitive-catalogue) |
| Swapping placeholder for authored asset (2026-09-17) | Prefab contract: transform names bound by name, ± 20 % dimension check in the validator | [Placeholder Assets § Prefab Contract](placeholder-assets.md#prefab-contract) |
| Whether art gates a phase (2026-09-17) | No — a slice ships on primitives; assets land per asset | [Placeholder Assets § Phase Mapping](placeholder-assets.md#phase-mapping) |
