# Open Questions & Decision Log

[← Game Design](README.md)

## Open

None. Every gameplay question raised so far has a recorded decision below. New questions get a row in [Open](#open) with a date; a decision moves the row to the log and the rule to its topic file.

## Decision Log

Decisions made 2026-09-16 to close the concept for detail specs. Rationale lives with the rule in the topic file; this table is the index.

### Units

| Question | Decision | Recorded in |
|---|---|---|
| Station engagement radius: one value, per type, or upgradable | Per unit type, not upgradable; 40 m for every type at launch | [RTS § Units](rts.md#units) |
| Re-stationing cooldown | None; a new order replaces the route immediately. Order spam is a technical rate limit | [RTS § Station Placement Rules](rts.md#station-placement-rules) |
| Target type order (superseded 2026-09-17) | ~~Demons → rival units → aggressor avatar → towers → factories → buildings~~ — replaced by the rule below |  |
| Target order (2026-09-17) | A legally attackable avatar first, then **nearest, no type ranking**; ties by lowest ID. Shielded buildings are not valid targets | [RTS § Target Order](rts.md#target-order) |
| Avatar targeting (2026-09-17) | Player selects the target; no order for the avatar. Fallback to nearest when nothing is selected | [Combat § Target Selection](combat.md#target-selection) |
| Aggressor rule under the new order (2026-09-17) | Unchanged — rival units and towers still need the aggressor flag to attack an avatar at all | [Combat § Aggressor Rule](combat.md#aggressor-rule) |
| Unit roster before faction design | Three faction-symmetric archetypes (Infantry, Marksman, Siege); skins per faction | [RTS § Launch Roster](rts.md#launch-roster) |
| Reachability of off-street targets | Street route plus one off-road leg ≤ 30 m; buildings further from a street are not conquerable | [RTS § Reachability](rts.md#reachability) |

### Facing & Rotation

Decisions made 2026-09-17.

| Question | Decision | Recorded in |
|---|---|---|
| How a unit is oriented | Two segments: base follows the route, turret follows the target | [Facing § Rules](facing.md#rules) |
| Whether facing gates damage | Yes — an attack resolves only within 5° of the aim | [Facing § Rules](facing.md#rules) |
| Rotation freedom per unit type | Traverse arc per type: ± 45° Infantry, ± 60° Marksman, ± 180° Siege; towers full, demons narrow | [Facing § Traverse Arcs](facing.md#traverse-arcs) |
| Running one way and shooting another | Only inside the arc. A moving limited-arc unit cannot fire behind itself; Siege can | [Facing § Turning to Fire](facing.md#turning-to-fire) |
| Cost of turning | Time (`angle / rate`), never a cooldown; target choice is unaffected by angle | [Facing § Turning to Fire](facing.md#turning-to-fire) |
| Avatar, whose heading the player cannot steer | Base free below 1.0 m/s, course over ground above; ± 90° arc; never blocks a standing avatar | [Facing § Avatar Facing](facing.md#avatar-facing) |
| Facing as a player order | No — the one-order model stands | [Facing § Not Modelled](facing.md#not-modelled) |

### Line of Sight & Indirect Fire

Decisions made 2026-09-18.

| Question | Decision | Recorded in |
|---|---|---|
| Whether buildings block shots | Yes, for direct fire. One 2.5D test: a footprint blocks when its height is above the sight line at the crossing | [Line of Sight](line-of-sight.md#line-of-sight) |
| Ground units vs. towers on roofs | One formula, eye height per entity class — no second rule | [Line of Sight](line-of-sight.md#line-of-sight) |
| Whether sight radius becomes line-of-sight | **No** — fog of war stays a circle. See through a building, shoot around it | [What Line of Sight Does Not Gate](line-of-sight.md#what-line-of-sight-does-not-gate) |
| What a unit does with a blocked target | Routes to the first firing position on its street route, inside the station radius; skips the target if none exists | [Blocked Targets Move Units](line-of-sight.md#blocked-targets-move-units) |
| Whether artillery needs an arc-clearance test | No — a 20 m minimum range expresses it for one comparison | [Indirect Fire](line-of-sight.md#indirect-fire) |
| What artillery hits | A **position**, fixed at fire time; hostiles within 4 m of it when the shell lands | [Indirect Fire](line-of-sight.md#indirect-fire) |
| Delay | Flight time `clamp(distance / 25 m/s, 1 s, 6 s)`, rounded to the tick | [Indirect Fire](line-of-sight.md#indirect-fire) |
| Whether this breaks "always hits" | No — there is no roll. A vacated position is not a miss | [Why This Is Not a Miss Chance](line-of-sight.md#why-this-is-not-a-miss-chance) |
| Friendly fire | None; hostiles only in the impact radius | [Indirect Fire](line-of-sight.md#indirect-fire) |
| What artillery may shoot at | Only what the **owner** can see at fire time — forward units become spotters | [Spotting](line-of-sight.md#spotting) |
| Artillery in the launch roster | No — a second T3 archetype after the P3 metrics | [Artillery Archetype](line-of-sight.md#artillery-archetype) |

### Structures

| Question | Decision | Recorded in |
|---|---|---|
| Tower repair and rebuild | Repair: presence required, half build cost × missing fraction, not within 60 s of damage. Rebuild: full cost, presence | [RTS § Repair and Rebuild](rts.md#repair-and-rebuild) |
| Tower count per building | One slot per 50 m² of roof, 1–4 | [RTS § Towers](rts.md#towers) |
| Factory cap and queue | 5 factories per player, 5 orders per queue | [RTS § Factories](rts.md#factories) |

### Territory

| Question | Decision | Recorded in |
|---|---|---|
| Density constants | `d_ref` 1 000 /km², `a` 0.5, `bonus_max` 3.0 | [World § Density Normalization](world.md#density-normalization) |
| Density classes | City ≥ 1 500, suburb 300–1 500, rural < 300 buildings/km², per H3 r8 cell | [World § Density Classes](world.md#density-classes) |
| Synthetic target value | POI-synthesized 0.5×, junction-synthesized 0.25× | [World § Data Coverage Fallback](world.md#data-coverage-fallback) |
| School and train-station buildings | Conquerable; the safe zone is the 5 m circle around the POI node, membership by centroid | [Territory § Workshop-Site Buildings](territory.md#workshop-site-buildings) |
| Conquest action | Hold-to-conquer 10 s, presence checked at start and end; no minigame | [Territory § Conquest Rules](territory.md#conquest-rules) |
| Building HP and regeneration | Base HP per kind × volume multiplier; 1 %/min regeneration after 60 s | [Territory § Building HP](territory.md#building-hp) |
| Same-faction players | Allied: never attackable, never conquerable, no shared sight | [Factions § Relations](factions.md#relations) |

### Drops

| Question | Decision | Recorded in |
|---|---|---|
| Tap-to-collect range | 15 m by tap, 5 m automatic | [RPG § Ground Drops](rpg.md#ground-drops) |
| Drop ownership | Killer's owner for 120 s, then anyone | [RPG § Ground Drops](rpg.md#ground-drops) |
| Drop lifetime | 600 s | [RPG § Ground Drops](rpg.md#ground-drops) |
| Unit kills with no player nearby | Dropped at the kill position anyway; never credited | [RPG § Ground Drops](rpg.md#ground-drops) |

### Visibility & Presentation

| Question | Decision | Recorded in |
|---|---|---|
| Hellgates under fog of war | Always visible in the streamed area | [Presentation § Visibility](presentation.md#visibility) |
| Extent of free panning | The subscribed interest cells | [Presentation § View & Presentation](presentation.md#view--presentation) |
| Rival vs. neutral tint | Inside sight: rival in rival faction colour desaturated, allied outlined, neutral untinted | [Factions § Relations](factions.md#relations) |
| Sight radius | 75 / 100 / 150 m by density class | [World § Density Classes](world.md#density-classes) |

### Workshops & Duels

| Question | Decision | Recorded in |
|---|---|---|
| Leaderboard metric and win trading | Wins in a rolling 30-day window; at most 3 counted duels per pair per day | [Entities § Avatar Duels](entities.md#avatar-duels) |

### Avatar, Combat, Gear

| Question | Decision | Recorded in |
|---|---|---|
| Hellgate spawn weighting, cadence, escalation, rewards | Director every 5 min; per active player; 1 gate / 6 h; tiers by nearby players; waves every 90 s; escalation every 10 min; reward table | [Factions § Hellgates](factions.md#hellgates) |
| Avatar defeat penalty (superseded 2026-09-17) | ~~300 s knockout~~ — replaced by the ghost state below |  |
| Avatar defeat penalty (2026-09-17) | Ghost until the player physically reaches the respawn point; no timer, no gear or Essence cost; unit orders stay available | [RPG § Defeat](rpg.md#defeat) |
| Respawn point (2026-09-17) | One per player, set by presence at the player's position, movable once per 48 h, revival within 15 m, never visible to anyone else | [RPG § Respawn Point](rpg.md#respawn-point) |
| Level gating hard or soft | Hard; T1/T2/T3 at level 1/5/12 | [RPG § Tech Access](rpg.md#tech-access) |
| Avatar solo gates | T1 stage 0 soloable at level 1 in ~10 min; T2 from level ~5; T3 needs units | [Factions § Hellgates](factions.md#hellgates) |
| Melee and ranged bands | 8 m / 30 m base, no overlap, melee wins inside its range; range is a weapon stat | [Combat § Weapon Range Bands](combat.md#weapon-range-bands) |
| Speed-lock hysteresis | Lock > 30 km/h for 20 s; unlock < 20 km/h for 30 s | [Combat § Speed Lock](combat.md#speed-lock) |
| Speed lock scope | Every presence-gated action | [Combat § Speed Lock](combat.md#speed-lock) |
| Passenger case | Accepted, no mitigation | [Combat § Speed Lock](combat.md#speed-lock) |
| Avatar vs. rival assets | Stance toggle (PvE only default); aggressor rule for return fire; avatars never damage avatars | [Combat § Avatar Targeting](combat.md#avatar-targeting) |
| Rarity tiers and affix counts | 4 tiers, 0–3 affixes, weights per gate tier | [RPG § Roll Model](rpg.md#roll-model) |
| Affix pool | Weapons share one pool; armor has its own; no duplicate affix per item | [RPG § Roll Model](rpg.md#roll-model) |
| Armor re-roll | None; craft a new one | [RPG § Acquisition](rpg.md#acquisition) |
| Crafting inputs | Essence + 5 materials of the tier | [RPG § Acquisition](rpg.md#acquisition) |
| Trading | Bound to player; no trading | [RPG § Inventory and Binding](rpg.md#inventory-and-binding) |
| Power-gap control | Affix sum ≤ 100 % per stat; ≤ 2× base at equal tier | [RPG § Power Gap](rpg.md#power-gap) |
| Faction choice permanence | Permanent, one free change within 24 h | [Factions § Factions](factions.md#factions) |

### Still Deferred by Decision

| Topic | Why | Until |
|---|---|---|
| Faction names, lore, visual style | Art direction work, not a rule | Asset pilot |
| Faction-asymmetric unit stats | Needs data from the symmetric roster first | After P3 metrics |
| Per-type sight radius | Needs more unit and tower types | After the launch roster ships |
| Artillery archetype build-out | Needs direct-fire balance data first | After P3 metrics |

## Technical

Tracked in [Architecture § Open Technical Questions](../architecture/open-questions.md#open-technical-questions).
