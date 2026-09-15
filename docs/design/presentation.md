# View & Presentation

[← Game Design](README.md)

One view, always the same: a 3D world map with the player's avatar on it, Pokémon GO-style. **Camera AR is out of scope** — decided, not deferred.

| Element | Rule |
|---|---|
| Camera | Tilted top-down, locked to the avatar; user may rotate, pitch, zoom |
| Avatar | Rendered at the user's live GPS position, facing the direction of travel |
| Buildings | Stylized low-poly models at real coordinates, tinted by owning faction |
| Units, towers, gates | Rendered on the same map from live state |
| Interaction ring | Circle around the avatar showing the current action radius |
| Remote view | Map pans to own assets for orders; conquest-type actions stay radius-gated |
| HUD | Screen-space overlay: currencies, unit orders, alerts |

## Why No Camera AR

| Reason | Effect |
|---|---|
| Battery | Camera + tracking drains a phone in a session; play sessions are long and outdoors |
| Georeferencing error | Compass and anchor drift misplace world-anchored objects by meters — conquest targets would look wrong |
| Play posture | Territory, RTS and RPG loops are read-and-tap, not look-around |
| Safety | Holding a camera up while walking is worse than glancing at a map |
| Scope | One renderer, one camera, one input model |

## Art Direction

Reference point: *League of Legends* — stylized low-poly geometry with hand-painted texture work, read from a tilted top-down camera. Post-apocalyptic subject matter, **not** a gritty photoreal one.

| Property | Direction |
|---|---|
| Geometry | Low-poly; shape carries the read, not mesh density |
| Texturing | Hand-painted, baked lighting and AO into the albedo; few real-time lights |
| Colour | Saturated, high-contrast; faction colour is the strongest signal on the map |
| Silhouette | Readable at map zoom — a unit type is identifiable by outline alone |
| Scale | Exaggerated: units and towers read larger than real-world proportion against buildings |
| Damage states | Colour and decal shift, not mesh destruction |
| Basemap | Stylized ground and streets; never photorealistic imagery |

Why it fits this game:

| Driver | Effect |
|---|---|
| Camera is far and tilted | Detail below silhouette level is never seen — no reason to pay for it |
| Mobile budget | Low poly counts and shared atlases keep draw calls and memory in range |
| Mass instancing | Hundreds of buildings per view; stylized kits repeat without looking wrong |
| Real-world data gaps | Stylized buildings tolerate approximated footprints and estimated heights; photoreal does not |
| Faction readability | Territory ownership must be legible at a glance, at any zoom |

## Map Interaction

```mermaid
flowchart TD
    A[Map view centred on avatar] --> B{Target inside interaction ring?}
    B -->|yes| C[Action buttons enabled: conquer / build / craft / fight]
    B -->|no| D[Target inspectable only]
    C --> E[Client sends intent]
    E --> F[Server validates against its own GPS fix]
    F --> G[State delta → map updates]
    D --> H[Pan / zoom, or walk closer]
    H --> A
```

- The ring is presentation of a server-side radius, never the rule itself — the server re-checks every intent (see [Presence Rules](entities.md#presence-rules)).
- Unit orders work from the panned-away map; placement and conquest do not.

## Visibility

Not everything inside the streamed area is shown. **Vision comes from what you own.**

| Object | Visible when |
|---|---|
| Buildings, streets, workshops | Always, in the streamed area — this is the map itself |
| Building ownership + HP | Always, in the streamed area |
| Own avatar, units, factories, towers | Always, at any distance |
| **Rival units, factories, towers** | Only inside the sight radius of an own asset (avatar, unit, building, factory, tower) |
| **Demons** | Same rule as rival units |
| **Hellgates** | Always, in the streamed area — gates exist to attract players |
| **Rival avatars** | **Never on the open map.** Only at a shared site (workshop, hellgate), inside that site's radius |

- Sight radius is a server constant, derived from the same density normalization as the other constants.
- An unseen attacker is a real outcome: a rival can station units outside your sight and close in. Owning more ground buys more warning.
- The server sends only what is visible — invisible entities are not in the stream at all, so the rule cannot be bypassed by a modified client.

Why rival avatars stay hidden:

| Reason | Effect |
|---|---|
| Safety | An avatar marker is a live GPS position of a real person; broadcasting it enables stalking |
| Consent | At workshops and gates the player chose to travel to a shared site — that is the consent boundary |
| Design | The conflict is over territory and units, not over ambushing people |
