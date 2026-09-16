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
| Target type order | Demons → rival units → aggressor avatar → towers → factories → buildings; then nearest, then lowest ID | [RTS § Target Order](rts.md#target-order) |
| Unit roster before faction design | Three faction-symmetric archetypes (Infantry, Marksman, Siege); skins per faction | [RTS § Launch Roster](rts.md#launch-roster) |
| Reachability of off-street targets | Street route plus one off-road leg ≤ 30 m; buildings further from a street are not conquerable | [RTS § Reachability](rts.md#reachability) |

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
| Avatar defeat penalty | 300 s knockout, no gear or Essence cost | [RPG § Defeat](rpg.md#defeat) |
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

## Technical

Tracked in [Architecture § Open Technical Questions](../architecture/open-questions.md#open-technical-questions).
