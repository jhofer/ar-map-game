# F03 — Identity, Session & Transport

[← Features](README.md)

**Goal:** a player signs in on a device and holds a live, binary, versioned WebSocket session that survives backgrounding and network loss.

**Implements:** [Transport & Protocol](../architecture/transport.md#transport--protocol), [Protocol Pattern](../architecture/code-patterns.md#protocol-pattern), [Tech Stack § Server](../architecture/tech-stack.md#server), [Reconnect & Offline](../architecture/streaming.md#reconnect--offline).

## Scope

### Identity

| Deliverable | Detail |
|---|---|
| Providers | Sign in with Apple and Google; the platform SDK returns an ID token, the server verifies it against the provider's keys |
| Session token | Own JWT, short-lived, plus a refresh path; `JwtBearer` on the server, secure storage on the device |
| Player record | `players` table: id, provider subject, created-at, last-seen. No profile, no faction — that is P2 |
| Endpoints | `POST /auth/token`, `POST /auth/refresh`, both minimal APIs, both rate-limited |
| Logging | Provider subject hashed in logs; no tokens, no email, no position — see [Cross-Cutting Rules](../architecture/code-patterns.md#cross-cutting-rules) |

### Transport

| Deliverable | Detail |
|---|---|
| Endpoint | `GET /ws` upgraded to WebSocket, JWT required, one session per player — a second connection displaces the first with a typed reason |
| Framing | Length-prefixed binary frames, MemoryPack contracts; the hand-written delta format is reserved but unused until P2 |
| Handshake | `Hello(protocolVersion, clientBuild)` → `Welcome(serverTime, sessionId)`; a `ProtocolVersion` mismatch is rejected with `UnsupportedProtocol` and a store-update hint |
| Messages in this feature | `Hello`, `Welcome`, `Ping`, `Pong`, `Error(code, detail)` — nothing gameplay-carrying |
| Clock | Server time in `Welcome` and in every `Pong`; the client estimates and re-estimates the offset — see [Client-Side Handling](../architecture/streaming.md#client-side-handling) |
| Backpressure | Per-session send queue with a bound; a slow consumer is disconnected with `Backpressure`, never allowed to grow the server's memory |
| Rate limits | Per-session message budget with a typed `RateLimited` response — the shape later features reuse for intents |

### Client Session Layer

| Deliverable | Detail |
|---|---|
| `IConnection` | In `Game.Client.Core`, no `UnityEngine` types; a real implementation over `ClientWebSocket` and a fake for tests |
| Inbox | Decode on a worker thread, drain on the main thread with a per-frame cap — see [Client Patterns](../architecture/code-patterns.md#client-patterns) |
| Reconnect | Exponential backoff with jitter, cap and cancellation; resume attempted, full re-handshake on failure |
| Lifecycle | Background, resume, airplane-mode and token-expiry paths each produce a defined state, surfaced in a debug HUD |
| Debug HUD | Connection state, round-trip time, server-clock offset, last error code — the tool every later feature debugs with |

## Out of Scope

| Item | Goes to |
|---|---|
| `PositionFix`, interest subscription, cell snapshots | F04 and P2 |
| Entity deltas, the bit-level delta format | P2 |
| Platform attestation | P2 — see [Attestation Strictness](../architecture/anti-cheat.md#attestation-strictness) |
| Account deletion, data export | [F06](f06-store-delivery.md#store-compliance) |

## Acceptance

| # | Check |
|---|---|
| 1 | A real device signs in with both providers and reaches `Welcome`; a tampered ID token is rejected |
| 2 | An expired JWT is refused on the socket upgrade; the client refreshes and reconnects without a user-visible error |
| 3 | A client built with a lower `ProtocolVersion` is rejected with `UnsupportedProtocol`, not a disconnect |
| 4 | Backgrounding the app for 10 minutes and resuming restores a working session within the backoff window |
| 5 | Killing the server drops the client to `Reconnecting` and it recovers within 30 s of the server returning |
| 6 | A client that stops reading is disconnected with `Backpressure`; server memory returns to baseline |
| 7 | 200 idle sessions on the dev box: memory and CPU recorded as the P2 baseline (estimate, to be re-measured) |
| 8 | A log scrape of a full sign-in and session shows no token, no email, no raw provider subject |
| 9 | Round-trip `Ping`/`Pong` over mobile data is recorded; the clock offset stays stable across a reconnect |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Apple review requirements around Sign in with Apple | Store rejection | Implement Apple first, not last; follow the account-deletion requirement when the public release feature lands |
| Mobile networks kill idle sockets | Silent disconnects | Application-level `Ping` at a fixed interval; the server closes on a missed budget rather than holding dead sessions |
| Token handling on device | Credential leak | Platform secure storage only; never in `PlayerPrefs`, never logged |
| Protocol version churn during P1 | Old builds break constantly | `ProtocolVersion` bumped only in a PR that also states the break; dev builds pinned to the deployed server |
| WebSocket behind the future CDN or proxy | Works locally, fails deployed | Verify through the same proxy chain as production as part of the deploy check |
