# F05 — First Region & Tile Renderer

[← Features](README.md)

**Goal:** one real district exists as own geometry tiles on object storage, and the client renders its buildings, streets and ground from them.

**Implements:** [Map Data Pipeline](../architecture/map-data.md#map-data-pipeline), [Geometry Processing](../architecture/map-data.md#geometry-processing), [Tile Payload](../architecture/map-data.md#tile-payload), [Client Layers](../architecture/client.md#client-layers), [Tile Loading](../architecture/code-patterns.md#tile-loading), [LOD](../architecture/client.md#lod).

## Scope

### Pipeline

| Deliverable | Detail |
|---|---|
| Extract | DuckDB.NET + `spatial` over Overture GeoParquet, clipped to a bounding box in SQL; OSM only where Overture is thin |
| Normalize | Own schema: `entityId` from GERS/OSM, footprint, height, kind, centroid |
| Height | Attribute where present, else estimated from kind and levels; estimates flagged in the coverage report |
| Geometry | Douglas-Peucker 0.5 m, `IsValid` + `Buffer(0)` repair, bounding-rectangle fallback, holes kept |
| Reachability | Buildings more than 30 m from the street network shipped as `kind = Scenery` with no `entityId` |
| Density | Buildings per km² per H3 r8 cell, with the density class fixed per data version |
| Outputs | Geometry tiles (z15, binary, gzip) to MinIO; entity rows to PostGIS via binary `COPY`; a coverage report per cell |
| Idempotence | A re-run for the same region and data version produces byte-identical tiles |

### Tile Codec

| Deliverable | Detail |
|---|---|
| Location | `Game.Shared` — written by the pipeline, read by the client, one implementation |
| Format | Header, building, street, ground and workshop-site records per [Tile Payload](../architecture/map-data.md#tile-payload) |
| Quantization | Tile-local `uint16` per axis (≈ 2 cm at z15), heights `uint16` in decimetres; no doubles on the wire |
| Golden files | Fixture tiles committed; a round-trip test fails on any unintended format change |
| Versioning | `dataVersion` in the header and in the URL path `/v/{dataVersion}/{z}/{x}/{y}.bin` |

### Client Rendering

| Deliverable | Detail |
|---|---|
| Tile source | `ITileSource` over `UnityWebRequest` with a disk cache keyed `dataVersion/z/x/y`; old versions deleted on switch |
| Decode | Worker thread, never the main thread |
| Mesh build | Extrusion plus Earcut triangulation in Burst jobs; `Mesh.MeshDataArray`; upload budgeted per frame |
| Streets | Flat ribbon meshes from polylines; ground flat-coloured by landuse class; no baked basemap texture |
| Batching | One mesh per tile chunk, one material per kit, GPU instancing — no GameObject per building |
| LOD | Full extrusion ≤ 150 m, extrusion only to 400 m, nothing beyond the far plane; small-volume buildings dropped first in a dense core |
| No data | Outside the ingested region: plain ground plus the no-data hint, exactly as in F04 |

## Out of Scope

| Item | Goes to |
|---|---|
| Ownership tint, HP, any live entity state | P2 |
| Automatic ingest on first fix in an uncovered cell | P2 — see [Ingest Trigger](../architecture/map-data.md#ingest-trigger) and [Not Yet Scheduled](README.md#not-yet-scheduled) |
| Routing graph build and the Valhalla container | P3 |
| Authored kit models for Landmark and Hospital | After the asset pilot — see [Placeholder Assets](../architecture/placeholder-assets.md#phase-mapping) |
| CDN in front of object storage | When egress makes it worth it; MinIO and R2 share the S3 API |

## Acceptance

| # | Check |
|---|---|
| 1 | One district ingested end to end by a single documented command, from Overture extract to tiles in MinIO and rows in PostGIS |
| 2 | Urban tile sizes land in the 10–100 KB band; outliers are named in the coverage report |
| 3 | The golden-file round-trip test fails when a field is added without a version bump |
| 4 | A re-run of the pipeline for the same version produces byte-identical tiles |
| 5 | A fixture with an invalid ring renders as its bounding rectangle and is flagged, never missing |
| 6 | The client renders the district on a mid-range device at 30 fps sustained, with draw calls in the low hundreds |
| 7 | Cold start with an empty cache to first buildings visible is recorded; a warm start renders from disk with the network disabled |
| 8 | Walking (via GPX) from covered into uncovered area transitions to plain ground and back without a hitch or a reload |
| 9 | Switching `dataVersion` deletes the old cache and re-downloads, with no torn mix of versions on screen |
| 10 | The coverage report lists unplayable and scenery-only cells for the district |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Overture data quality in the chosen district | The first impression of the game is wrong buildings | Pick a district with known-good coverage for the first run; the coverage report gates any later region |
| Earcut robustness on real footprints | Holes in the world | Rings validated in the pipeline; bounding-rectangle fallback on the client; fixture set from real failures |
| Mesh upload hitches on cell entry | Visible stutter while walking | Per-frame upload budget, measured on device, tuned before the feature closes |
| Burst or Jobs behaving differently under IL2CPP | Editor-only correctness | PlayMode rendering smoke test runs in CI and a device build is checked per PR |
| ODbL obligations on derived data | Legal exposure | Attribution screen ships with this feature; derived tiles kept separable — see [Risks](../architecture/operations.md#risks) |
| Tile format churn after the client caches it | Stale caches, confusing bugs | `dataVersion` in the path; a format change is a version bump, never an in-place edit |
