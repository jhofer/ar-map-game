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
- Routing engine: Valhalla vs. GraphHopper vs. OSRM; memory footprint per ingested region.
- Wake latency budget: acceptable delay when a dormant region is first subscribed.
- Timer queue durability: in-process vs. Postgres-backed scheduled events.
- Persistence cadence: write-behind interval vs. acceptable loss window on crash.
- Redis introduction point: which stage actually needs it.
- Shard map and handoff protocol details; behaviour under shard restart.
- Push notifications for offline events: provider, batching, opt-in rules.
- Data refresh: how ownership survives a building disappearing or changing ID between data versions.
- Whether to adopt SpacetimeDB for the live plane instead of a custom actor layer.
- Attestation strictness vs. player friction (rooted devices, emulators, sideloads).
