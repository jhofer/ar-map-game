# Client Presentation

[← Technical Architecture](README.md)

*Grundlagen: [Rendering im Unity-Client](../grundlagen/09-rendering.md#9-rendering-im-unity-client), [GPS in der Praxis](../grundlagen/02-gps.md#2-gps-in-der-praxis).*

One view: a 3D world map with the player avatar at the GPS position. **AR Foundation is not a dependency** — no camera feed, no plane detection, no world anchors. Rationale is a design decision, see [Game Design § View & Presentation](../design/presentation.md#view--presentation).

## Client Layers

| Layer | Source | Update |
|---|---|---|
| Tile cache | CDN, immutable per data version | On cell enter, disk-cached |
| Street / ground | Geometry tiles — streets as flat ribbon meshes from the polylines, ground as flat colour by landuse class; **no baked basemap texture** | With tile |
| Buildings | Geometry tiles, extruded; authored kit models for Landmark and Hospital only at launch | With tile; tint state change on ownership delta |
| Live entities (units, towers, gates, drops, avatars) | WebSocket deltas | Per tick |
| Entity meshes | Authored prefab from the kit catalogue, or the kind's placeholder primitive — see [Placeholder Assets](placeholder-assets.md#placeholder-assets) | On spawn, from the pool |
| Entity facing | Derived per frame from route, `baseYaw` and `target` — see [Rotation & Facing](rotation.md#client-rendering) | Per frame |
| Avatar | Local GPS pipeline | 0.2–1 Hz fix, interpolated per frame |
| Interaction ring | Server-sent radius from active game config | On `ConfigUpdate` |
| HUD | Local state cache | Per state change |

Uncovered area (no ingested tiles): avatar, camera and connection work unchanged; ground renders as a plain surface with a no-data hint.

Own-building tint, HP and selection are material/overlay changes on already-loaded meshes — a delta never triggers a tile reload.

## Camera

| Property | Value |
|---|---|
| Type | Follow camera, locked to the avatar |
| Pitch | Tilted top-down, user-adjustable inside a clamped band |
| Yaw | User rotation; snap-to-north control |
| Zoom | Camera distance 40–400 m provisional, limits from device profiling; drives LOD and entity label density — see [LOD](#lod) |
| Free pan | Temporary, clamped to the subscribed area; recentres on the avatar on release or timeout |

Camera state is client-local and never sent to the server. Interest subscription follows the **GPS position**, not the camera — panning does not widen the subscription set.

## Avatar Position Pipeline

```mermaid
flowchart LR
    A[OS location fix] --> B{Accuracy under threshold?}
    B -->|no| A
    B -->|yes| C[Smoothing filter]
    C --> D[Clamp to plausible walk speed]
    D --> E[WGS84 to ENU, local origin]
    E --> F[Interpolate between fixes]
    F --> G[Avatar transform + heading]
    A --> H[PositionFix to server]
```

- Client-side smoothing is **presentation only**. Every presence check runs against the server's own accepted fix ([Anti-Cheat](anti-cheat.md#anti-cheat)).
- Heading comes from course over ground above 1.0 m/s; below that from the compass, low-pass filtered; with neither, the last heading is kept.

| Accuracy class | Smoothing | Effect |
|---|---|---|
| < 10 m | Exponential moving average, α = 0.6 | Follows quickly |
| 10–25 m | Exponential moving average, α = 0.3 | Damped |
| > 25 m | Fix rejected for presentation; still sent to the server, which applies its own floor | Avatar holds |

- Filter choice: a low-pass filter, not a Kalman filter. At walking speed with 0.2–1 Hz fixes a Kalman filter adds tuning surface without visible gain; revisit only if device tests show lag complaints.
- Floating origin: the ENU origin follows the player and is shifted past a distance threshold.

## Render Budget (mobile target)

| Item | Target |
|---|---|
| Draw calls | Low hundreds — GPU instancing per building kind |
| Buildings in view | Hundreds in a dense core, LOD-reduced beyond the near band |
| Live entities in view | Tens |
| Frame rate | 30 fps sustained; the loop has no twitch input |
| Battery | No camera, no continuous tracking; GPS at 0.2–1 Hz is the main draw |

The low-poly art direction is a budget decision as much as a look:

| Choice | Consequence |
|---|---|
| Low triangle counts per asset | Vertex cost stays flat as building density rises |
| Shared texture atlas per kit | Same material → instancing and batching actually apply |
| Baked lighting and AO in the albedo | One directional light; no per-pixel light loops on mobile GPUs |
| Ownership colour as material property | Own-building tint toggles per instance, no mesh or atlas swap |
| No mesh destruction | Damage is a material/decal state — no runtime mesh generation |

## LOD

The tile carries one detail level; the client reduces.

| Camera distance to building | Rendering |
|---|---|
| ≤ 150 m | Full extrusion; authored kit model where one exists for the kind |
| 150–400 m | Extrusion only, kit models swapped out; entity labels hidden beyond 200 m, turret tracking stopped with them |
| Beyond the far plane | Not drawn; tile stays loaded while subscribed |
| Dense core over budget | Buildings with `volume_multiplier < 0.5` dropped from the far band first |

## Building Tint

Buildings are one mesh per tile chunk, not GameObjects, so per-instance material property blocks do not apply.

| Mechanism | Detail |
|---|---|
| Per-vertex building index | Every vertex carries its building's tile-local index in a UV channel |
| State buffer | One small `ComputeBuffer` (or texture on low-end GPUs) per tile chunk: tint colour + damage level per building |
| Update | An ownership or HP delta writes one entry into the buffer; no mesh rebuild, no material swap |
| Shader | Samples the buffer by index; applies faction tint, outline flag, damage darkening — see [Game Design § Relations](../design/factions.md#relations) |

Background and foreground churn is a streaming case, not a rendering case — see [Reconnect & Offline](streaming.md#reconnect--offline).
