# Transport & Protocol

[← Technical Architecture](README.md)

*Grundlagen: [Snapshot und Delta](../grundlagen/07-streaming.md#7-streaming-und-interest-management).*

| Option | Fit | Verdict |
|---|---|---|
| WebSocket over TLS | Works everywhere, proxy/CDN friendly, mobile-tested | **Chosen** |
| WebTransport / QUIC | Lower latency, better on lossy mobile | Later, if measurements justify it |
| Raw UDP | Twitch games | No — combat is auto-resolved at 2–4 Hz, no aiming |
| HTTP polling | Simple | No — delta push is the whole design |

- Encoding: binary, schema-versioned. MemoryPack or protobuf; C# on both ends makes a shared contract assembly trivial.
- Intents are idempotent and carry a client-generated ID for safe retry.
- Rule from the design doc holds at protocol level: **the client has no message type that asserts an outcome.**
