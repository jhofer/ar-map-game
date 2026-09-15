# Anti-Cheat

[← Technical Architecture](README.md)

*Grundlagen: [GPS in der Praxis](../grundlagen/02-gps.md#2-gps-in-der-praxis).*

Moved from the design doc; unchanged in substance.

| Vector | Mitigation |
|---|---|
| GPS spoofing | Server-side plausibility: speed between fixes, jump detection, accuracy floor, platform attestation (Play Integrity API, App Attest) |
| Drive-by farming | Speed lock: avatar cannot attack above sustained 30 km/h, derived server-side from the fix sequence |
| Forged placement | Conquest and construct placement checked against the server's own last accepted fix |
| Factory placement abuse | Free-space test run server-side against building footprints |
| Forged orders | Server validates ownership, proximity, and point balance on every order |
| Client-computed paths | Client cannot submit paths; routing is server-only |
| Injected combat results | Combat resolved on the server tick; client-asserted results are rejected by protocol design |
| State scraping | Interest scoping plus a server-side vision filter; invisible entities are never serialized; subscription caps and rate limits per session |
| Replay / speed hacks | Server clock authoritative for accrual, build times, movement |
| Loot RNG manipulation | All drop and craft rolls executed server-side |
| Reroll scumming | Roll committed before the client is told the outcome; disconnect does not undo it |
| Automation / botting | Movement-pattern anomaly detection on the fix stream; per-account rate limits |
