# Server Authority

[← Game Design](README.md)

Full technical architecture — client/server split, map data pipeline, spatial streaming, scaling, framework and cost evaluation — lives in [Architecture](../architecture/README.md).

Background for developers without geodata/game-server experience: [Grundlagen](../grundlagen/README.md) (German).

Design-relevant summary of the technical architecture:

| Concern | Rule |
|---|---|
| Authority | Server simulates; client renders and sends intent |
| Client state | Interest-scoped only — the client never holds global world state |
| Position | All presence checks run against the server's own accepted GPS fix |
| Balance values | Backend configuration, never client-side — see [Balance Parameters](balance.md#balance-parameters) |
| RNG | Loot and craft rolls execute server-side, committed before the client is told |
| Routing | Street-graph pathfinding is server-side; the client cannot submit paths |
| Anti-cheat | See [Architecture § Anti-Cheat](../architecture/anti-cheat.md#anti-cheat) |

Rule: **client sends intent, server sends state.** Any client message asserting an outcome is rejected.
