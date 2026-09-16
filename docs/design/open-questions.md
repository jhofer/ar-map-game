# Open Questions

[← Game Design](README.md)

## Gameplay

### Units

- Station engagement radius: one radius for every unit, a different radius per unit type, or a radius the player can upgrade.
- Re-stationing cooldown: after `SetStation`, must the player wait before moving the **same unit** again — or can a unit be redirected any number of times in a row.
- Target type order for the "by type, then nearest" rule: ranking of demons, rival units, rival towers, rival factories, rival buildings.

### Structures

- Tower repair and rebuild: Points cost, and whether repair requires physical presence like placement.

### Territory

- Density normalization constants — the three numbers in `scarcity_bonus = clamp((d_ref / density)^a, 1.0, bonus_max)`:
  - `d_ref`: building density that counts as "normal"; at or above it the bonus is 1.0.
  - `a`: how steeply the bonus grows as density drops below `d_ref`.
  - `bonus_max`: upper limit, so the emptiest areas are not overpaid.
- Synthetic target value: where no footprint exists, a building is generated from a POI or road junction. Should it pay less than a real building (and by how much) — so players do not prefer regions with poor map data.
- School and train-station buildings: they are workshop sites and ordinary conquerable buildings at once — conquerable, or excluded.

### Drops

- Tap-to-collect range: interaction radius, or anywhere on screen.
- Drop ownership: killer only, or anyone who reaches it first.
- Drop lifetime before it despawns.
- Drops from unit kills where no player is nearby: dropped anyway, or credited.

### Visibility & Presentation

- Hellgates under fog of war: still always visible, or sight-gated like demons.
- Extent of "nearby" for free panning: the streamed area, or a fixed distance.
- Rival vs. Neutral buildings: whether they need a distinct tint once inside sight.
- Sight radius value.

### Workshops & Duels

- Leaderboard metric (wins, win rate, streak) and protection against two players trading wins.

### Deferred and Unanswered

- Faction names, lore, visual style, unit rosters (deferred by decision).
- Hellgate spawn weighting, cadence, escalation curve, and Essence reward scale.
- Avatar defeat penalty: cooldown length, durability or Essence cost.
- Whether avatar level gating of unit tiers is hard (locked) or soft (cost scaling).
- Whether the avatar can solo low-tier gates without units, and at which level.
- Melee and ranged band distances, and whether they overlap.
- Speed-lock hysteresis: sustain window before locking and before unlocking.
- Whether conquest and crafting are also speed-locked, or only attacking.
- Passenger case: a passenger in a car is locked out identically — accepted, or mitigated.
- Rarity tier count and affix count per tier.
- Affix pool: which stats roll on weapons vs. armor, and whether ranged and melee share a pool.
- Whether crafted armor can be re-rolled, and at what Essence cost.
- Crafting inputs: Essence only, or Essence + materials.
- Trading: whether gear is bound to the player or tradeable between players.
- Power-gap control: how far random gear may separate two players in RTS hero combat.

## Technical

Tracked in [Architecture § Open Technical Questions](../architecture/open-questions.md#open-technical-questions).
