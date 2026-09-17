# F07 — Region Actors & Interest Streaming

[← Features](README.md)

**Goal:** live state exists. The server ticks regions, the client subscribes to the cells around its accepted fix, receives a snapshot and then deltas, and recovers from a gap without reconciling anything.

**Implements:** [Region Actors](../architecture/backend.md#region-actors), [Spatial Index](../architecture/streaming.md#spatial-index), [Subscription Set](../architecture/streaming.md#subscription-set), [Delta Encoding](../architecture/streaming.md#delta-encoding), [Wake Latency](../architecture/streaming.md#wake-latency), [Persistence Cadence](../architecture/backend.md#persistence-cadence), [Client Patterns](../architecture/code-patterns.md#client-patterns).

This is the first feature of **P2**. It carries the live plane, not the gameplay that will run on it: nothing in it lets a player change the world.

## Scope

### Prerequisite Gate

| Deliverable | Detail |
|---|---|
| H3 parity test | `pocketken.H3` checked in CI against the H3 v4 reference vectors — cell ids, `kRing`, `polygonToCells`. A mismatch switches to P/Invoke **before** anything is built on it — see [Measurement Gates](../architecture/open-questions.md#measurement-gates) |

### Region Runtime

| Deliverable | Detail |
|---|---|
| Region registry | Keyed by H3 r8; resolves a cell to its actor, wakes a dormant region on demand, sleeps an idle one after a configured quiet period |
| Actor | `System.Threading.Channels` mailbox, single writer, 2 Hz tick loop; every mutation goes through the mailbox, none through a shared lock |
| Boundary | `IRegionHost` so the scale-out track can swap the host without touching simulation code — see [Actor Choice](../architecture/tech-stack.md#actor-choice) |
| Lifecycle | Wake loads state, sleep flushes it; a region with no subscribers and no timers holds no CPU |
| Metrics | Tick duration histogram per region, live region count, mailbox depth — the numbers the [scale-out triggers](../architecture/operations.md#scale-out-track) read |

### Entity State

| Deliverable | Detail |
|---|---|
| First live class | Building state from F05's PostGIS entity rows: `entityId`, `ownerFaction = Neutral`, `hp = max`. Static-anchored — see [Entity Classes](../architecture/streaming.md#entity-classes) |
| Mutation path | An **admin-only** endpoint changes a building's state, so deltas are observable end to end without a gameplay rule existing |
| Persistence | Write-behind: journal every 1 s, snapshot every 5 min; a region reload replays the journal onto the snapshot |
| Restart | Server restart restores region state; nothing is served from a half-loaded region |

### Interest Management

| Deliverable | Detail |
|---|---|
| Subscription set | `kRing(playerCell, k(densityClass))` from the **accepted** fix of F04, with the density class from F05's table |
| Hysteresis | A cell is released only after 30 s outside its k-ring; hard cap on subscribed cells per session |
| Snapshot | `CellSnapshot(entities, seq)` on cell enter, with cell-local ids assigned there |
| Deltas | `EntityDelta` in the hand-written field-mask bit format, per-cell sequence numbers, explicit spawn and despawn records |
| Gaps | A sequence gap re-snapshots **that cell only** |
| Vision filter | The hook sits in the pipeline and passes everything through — every class in this feature is always-visible. Fog of war arrives with ownership |

### Client

| Deliverable | Detail |
|---|---|
| `WorldStore` | Cells, entities, per-cell `seq`; applies snapshots and deltas only, never invents state; gap → request re-snapshot |
| Presenters | R3 change streams to pooled views; live entities render as placeholder primitives — see [Prefab Contract](../architecture/placeholder-assets.md#prefab-contract) |
| Reconnect | Short gap replays buffered deltas, long gap re-snapshots; background and resume are treated as a long gap |
| Debug overlay | Subscribed cells drawn on the map, per-cell `seq`, last snapshot size, delta rate |

## Out of Scope

| Item | Goes to |
|---|---|
| Faction choice, conquest, ownership, Points | The next P2 features |
| Fog of war and the vision cache | With ownership, when there is something to hide |
| Units, routes, combat | P3 |
| Region handoff across processes, shard map, Redis | The [scale-out track](../architecture/operations.md#scale-out-track) |
| Automatic region ingest on an uncovered fix | A P2 feature of its own — see [Ingest Trigger](../architecture/map-data.md#ingest-trigger) |

## Acceptance

| # | Check |
|---|---|
| 1 | The H3 parity test is green in CI, and fails when a reference vector is corrupted on purpose |
| 2 | A GPX route across r9 boundaries subscribes and releases cells with hysteresis; boundary flapping produces no more subscribe events than crossings |
| 3 | Dormant region, subscribe → first `CellSnapshot` within the **500 ms p95** budget on the dev box |
| 4 | Cell snapshot size in a dense core is measured and recorded — this number decides the **r9 vs. r10** gate; ≤ ~30 KB keeps r9 |
| 5 | An admin state change produces a delta in the 8–24 B band, and the client view updates with no tile reload |
| 6 | An injected dropped delta is caught by the `seq` gap and re-snapshots exactly one cell |
| 7 | Server restart mid-session: state returns from snapshot + journal, and the client's next deltas are consistent with it |
| 8 | Idle session bandwidth stays well under 100 B/s; both this and the p95 tick duration are recorded as the scale-out baseline |
| 9 | A fuzz test over the delta bit format round-trips every field-mask combination |
| 10 | NetArchTest still green: the interest manager reaches simulation only through its interface |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Snapshot size blows the r9 assumption | Interest resolution changes late, touching every consumer | Acceptance row 4 is the decision point, measured before anything else depends on the size |
| One hot region starves the tick | Latency for everyone in it | Per-region tick duration metric from the first day; throttling and participant caps are the documented response |
| Hand-written delta format bugs | Corrupt client state, hard to debug | Fuzz plus golden-file tests; a gap always re-snapshots rather than repairing |
| H3 managed port mismatch | Wrong cells, silently | The parity gate runs before any code depends on it |
| Write-behind loss window | Up to 1 s of state lost on a crash | Accepted and documented — see [Persistence Cadence](../architecture/backend.md#persistence-cadence) |
| Admin mutation endpoint reaching production | A hand-editable world | Behind an environment flag and an admin token; refuses to start in the production environment |
