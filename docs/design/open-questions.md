# Open Questions

[← Game Design](README.md)

## Gameplay

- Points payout: passive tick vs. manual collection visit.
- Unit cap per building / per player.
- Station engagement radius: fixed, per unit type, or upgradeable.
- Target priority inside a radius: nearest, weakest, or by type (demons vs. players vs. buildings).
- Whether re-stationing has a cooldown.
- Free-space definition: footprint clearance only, or also minimum spacing from roads and other factories.
- Whether factories can be placed on rival-held ground, or only in neutral / own areas.
- Factory placement range from the player, and whether it equals the conquest radius.
- Whether a factory itself can be attacked and destroyed, and what it drops.
- Which POI categories qualify as workshops, and their density per region.
- Workshop fallback where POI data is thin — synthesize, or widen the qualifying categories.
- Whether crafting has a per-workshop cooldown, to stop one site being farmed repeatedly.
- Exact safe-zone radius value (decided: small).
- Snap tolerance: how far outside the radius a fix may sit and still snap in.
- Whether duels are rated or tracked at all, or purely casual.
- Whether duel results feed a leaderboard, and if so scoped per region or global.
- Whether a duel can be declined silently or shows a refusal to the challenger.
- Tower count per building, and whether it scales with building volume.
- Whether towers repair or must be rebuilt after an attack.
- Whether towers block conquest of a Neutral building, or only damage to an Owned one.
- Fixed conquest radius value.
- Density normalization constants: `d_ref`, `a`, `bonus_max`.
- Whether synthetic (non-footprint) targets carry reduced value, and by how much.
- Whether free map panning is limited to subscribed cells or reaches any owned asset.
- Sight radius value, and whether it differs per asset type (a tower sees further than a unit).
- Building-kit size: how many low-poly building variants per kind before repetition shows.
- Whether faction ownership reads as a full retexture, an accent colour, or an overlay.
- Camera zoom band: closest and widest zoom, and whether zoom level changes what is rendered.
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
- Trading: whether gear is bound to the player or tradeable between players.
- Power-gap control: how far random gear may separate two players in RTS hero combat.

## Technical

Tracked in [Architecture § Open Technical Questions](../architecture/open-questions.md#open-technical-questions).
