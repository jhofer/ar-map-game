# Anti-Cheat

[← Technical Architecture](README.md)

*Grundlagen: [GPS in der Praxis](../grundlagen/02-gps.md#2-gps-in-der-praxis) — Plausibilität, Glättung, Hysterese.*

Moved from the design doc; unchanged in substance.

| Vector | Mitigation |
|---|---|
| GPS spoofing | Server-side plausibility: speed between fixes, jump detection, accuracy floor, platform attestation (Play Integrity API, App Attest) |
| Drive-by farming | Speed lock: avatar cannot attack above sustained 30 km/h, derived server-side from the fix sequence |
| Forged placement | Conquest and construct placement checked against the server's own last accepted fix |
| Factory placement abuse | Free-space test run server-side against building footprints and road geometry |
| Forged orders | Server validates ownership, proximity, and point balance on every order |
| Client-computed paths | Client cannot submit paths; routing is server-only |
| Injected combat results | Combat resolved on the server tick; client-asserted results are rejected by protocol design |
| State scraping | Interest scoping plus a server-side vision filter; invisible entities are never serialized; subscription caps and rate limits per session |
| Replay / speed hacks | Server clock authoritative for accrual, build times, movement |
| Loot RNG manipulation | All drop and craft rolls executed server-side |
| Remote drop pickup | Pickup intent validated against the server's own position fix |
| Reroll scumming | Roll committed before the client is told the outcome; disconnect does not undo it |
| Automation / botting | Movement-pattern anomaly detection on the fix stream; per-account rate limits |
| Order spam | `SetStation` limited to 20 per 10 s per player; excess rejected with `RateLimited`. Not a gameplay cooldown — see [Game Design § Station Placement Rules](../design/rts.md#station-placement-rules) |
| Target-switch spam | `SetTarget` rate-limited like `SetStation`; the server validates visibility, stance and range before it takes effect — see [Game Design § Target Selection](../design/combat.md#target-selection) |
| Forged revival | Revival resolves server-side when the accepted fix is within the respawn radius; the client never asserts it |
| Respawn point abuse | Change cooldown (48 h) held server-side per player; a move is a presence-gated action, checked like any placement |
| Respawn point disclosure | Stored per player, never serialized into any other player's stream — a home address, treated like one |
| Ghost bypass | Ghost state is server-side: every presence-gated intent from a ghost is rejected with `Defeated`, whatever the client shows |

## Attestation Strictness

| Stage | Policy |
|---|---|
| 0–1 | Attestation requested and logged; failures never block — the alpha runs on dev devices |
| 2+ | Basic integrity required: rooted or jailbroken devices and emulators are rejected at login; sideloaded builds that pass integrity are allowed |
| Always | A failed attestation is an event with `configVersion`, so the false-positive rate is measurable before enforcement |
