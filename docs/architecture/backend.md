# Backend & Frameworks

[← Technical Architecture](README.md)

## Backend Architecture

*Grundlagen: [Autoritativer Server und Tick](../grundlagen/08-server-tick.md#8-autoritativer-server-und-tick), [PostGIS](../grundlagen/06-postgis.md#6-räumliche-abfragen-mit-postgis), [Routing](../grundlagen/10-routing.md#10-routing-auf-strassengraphen).*

### Components

| Component | Responsibility | State | Scales by |
|---|---|---|---|
| Gateway | TLS, session auth, attestation, rate limits, WS fan-out | Connection state | Connections |
| Interest manager | Cell subscription sets, delta filtering | Per-session cell set | Connections |
| Region actor | Authoritative tick for one H3 r8 region: combat, movement, accrual, conquest | Hot entity state | Active regions |
| Routing service | Street-graph routes for unit movement | Preprocessed graph | Requests, cacheable |
| Demon director | Hellgate spawn weighting by player presence, wave scheduling | Schedules | Active players |
| Economy / inventory | Points, Essence, loot rolls, crafting, gear | Durable | Players |
| Persistence | Write-behind snapshots + journal to PostgreSQL | Durable | World size |

Deployment shape at stage 0: **one process, all components as modules.** The boundaries above are module boundaries, not network boundaries, until load requires splitting. Region actors are the only component that must eventually shard.

### Region Actors

One logical actor per live H3 r8 region. Single-threaded per region → no locks, deterministic ordering, natural sharding unit.

```mermaid
stateDiagram-v2
    [*] --> Dormant
    Dormant --> Waking: Player subscribes / scheduled event due
    Waking --> Live: Load state, apply analytic catch-up
    Live --> Live: Tick
    Live --> Draining: No subscribers for T
    Draining --> Dormant: Persist snapshot
    Dormant --> [*]
```

| Region state | Ticking | Cost | What still happens |
|---|---|---|---|
| Live | 2–4 Hz units/combat, 1/60 Hz accrual | CPU per region | Everything |
| Draining | Slow tick | Low | Finish in-flight combat, persist |
| Dormant | None | Storage only | Points accrual computed analytically on wake; scheduled events (gate escalation, unit arrival) held in a timer queue |

This is the mechanism that satisfies C3 and C6: **cost is proportional to live regions, which is proportional to active players** — not to how much of the planet is ingested. Five players with five phones wake at most a handful of regions.

Accrual is closed-form (`points = rate × elapsed`), so dormant buildings need no ticks. Anything not closed-form (combat, unit movement) only occurs where an attacker exists, and an attacker is either a player (present → region live) or a demon wave (scheduled → wakes the region on its timer).

### Sharding

| Stage | Shape |
|---|---|
| Single node | All regions in one process |
| Sharded | Consistent-hash H3 r8 cell → shard; gateway routes by cell; shard map in Redis |
| Cross-shard | Rare: unit or player crossing a region boundary. Handoff = serialize entity, transfer, ack. Buildings never move, so most entities are shard-static |

Gateways are stateless with respect to the world and can scale independently of sim shards.

### Loop → Mechanism Mapping

| Game loop | Architectural mechanism |
|---|---|
| Territory (conquest) | Intent validated against server-side position fix; ownership row in PostGIS; delta to subscribers |
| Points economy | Analytic accrual on region wake + periodic materialization; never ticked per building |
| RTS (units, structures) | Region actor tick + routing service; stations are per-unit anchors, engagement is a radius query inside the region; movement streams as route + progress ([Entity Streaming](streaming.md#entity-streaming)) |
| Combat | Deterministic region tick; event-driven when no hostiles present |
| RPG (avatar, gear) | Stateless request/response against economy service; RNG server-side, committed before response |
| Demons (PvE) | Demon director schedules gates weighted by player presence; wakes regions via timer queue |
| Map interaction | Client-side presentation; every consequence is an intent message |

## Framework Evaluation (Backend)

| Framework | Persistent world | Geospatial interest mgmt | Self-host cost floor | Unity SDK | Verdict |
|---|---|---|---|---|---|
| **Custom .NET service** | Yes | Build it (H3 + own filter) | One VPS | Shared C# assembly | **Chosen** |
| **Nakama (OSS, Apache-2.0)** | Partial — matches are session-oriented | No | One VPS | Yes | Optional: auth, friends, chat, leaderboards, storage |
| Heroic Cloud (managed Nakama) | As above | No | Provisioned resources, monthly floor | Yes | No — fixed cost conflicts with C3 |
| Photon Fusion / Quantum | No — room/session model | No | Per CCU / per plan | Yes | No |
| Colyseus | Rooms; a cell could be a room | Manual | One VPS | Yes | Possible, but Node + room model fights the region-actor design |
| SpacetimeDB | Yes — DB + logic, subscription queries ≈ interest management | Via SQL subscriptions | Free tier, then energy-based | Yes | Strong conceptual fit; note vendor/maturity risk and per-operation billing |
| Unity Gaming Services / Netcode | Session-based | No | Per-usage | Native | No |

Rationale for custom over a game backend framework:

- The hard parts here — H3 interest scoping, region lifecycle, GPS validation, street routing — are **not** provided by any of them. What frameworks do provide (rooms, matchmaking, relay) this game does not use.
- C# on both sides means simulation types, validation rules, and math are written once and referenced by the Unity client.
- Cost floor is a VPS, not a plan.

Use OSS Nakama alongside the sim only if social/commodity features are wanted before they are worth writing. Keep it optional and behind the gateway.

Libraries and actor runtime: [Tech Stack § Server](tech-stack.md#server).
