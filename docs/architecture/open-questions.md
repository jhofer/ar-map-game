# Open Technical Questions

[← Technical Architecture](README.md)

- Tile encoding details: ring simplification tolerance per zoom, and the LOD strategy for dense cores.
- Avatar smoothing filter: low-pass vs. Kalman; tuning per accuracy class.
- Heading source: GPS course over ground vs. compass fusion at walking speed.
- Whether the street layer is rendered geometry or a baked basemap texture per tile.
- Building kit: procedural extrusion with stylized materials vs. authored low-poly models snapped to footprints.
- Own-building tint path: material property blocks vs. per-kit texture variants.
- Camera zoom band: limits from device-tier profiling; whether zoom level changes what is rendered.
- Interest cell resolution: confirm r9 against real subscription sizes in a dense core.
- Region resolution: r8 vs. r7 — trade-off between actor count and cross-boundary handoffs.
- Progress resync interval: fixed ~5 s vs. derived from the entity's speed and route length.
- Route quantization: how much a simplified route may deviate before units visibly clip building corners.
- Vision-filter cost: recompute per asset change vs. a cached per-player cell mask.
- Routing engine: Valhalla vs. GraphHopper vs. OSRM vs. Itinero (in-process .NET); memory footprint per ingested region.
- Wake latency budget: acceptable delay when a dormant region is first subscribed.
- Timer queue durability: in-process vs. Postgres-backed scheduled events.
- Persistence cadence: write-behind interval vs. acceptable loss window on crash.
- Redis introduction point: which stage actually needs it.
- Scale-out trigger thresholds: concrete tick-duration, connection and region numbers per node, from P2 load tests.
- On-demand region ingest: manual per request vs. automatic on first login in an uncovered area.
- Shard map and handoff protocol details; behaviour under shard restart.
- Push notifications for offline events: provider, batching, opt-in rules.
- Data refresh: how ownership survives a building disappearing or changing ID between data versions.
- Whether to adopt SpacetimeDB for the live plane instead of a custom actor layer.
- Attestation strictness vs. player friction (rooted devices, emulators, sideloads).
- Admin UI for game config: minimal own page vs. generic admin tool.
- Event store switch point: Postgres query latency or event volume that triggers ClickHouse.
- Per-region config overrides: needed for region-split A/B comparison, or before/after per version is enough.
- Gameplay event retention window and aggregate granularity.
- `pocketken.H3` parity with the H3 v4 C library (cell IDs, `kRing`, polygon fill) — decides managed port vs. P/Invoke.
- Own-actor host vs. Orleans on scale-out: shard map and handoff effort vs. Orleans tick jitter.
- Unity CoreCLR scripting runtime: adoption point, and whether `Game.Shared` then moves to a current .NET target.
- Earcut robustness on real footprints with holes and invalid rings: fix in pipeline vs. client fallback.
- Native location plugin: own thin plugin vs. an existing asset; background location policy per store.
