# Open Questions

[← Game Design](README.md)

## Gameplay

- Points payout: passive tick vs. manual collection visit.
  - credits = passiv ticks
  - loot & essences - visible on the screen. they drop on the ground. player has to tap on it or walk over it to collect.
- Unit cap per building / per player.
  - hard cap per player (100)
- Station engagement radius: fixed, per unit type, or upgradeable.
  - explain question
- 

Target priority inside a radius: nearest, weakest, or by type (demons vs. players vs. buildings).
-

1. by type

- 
  2. then by nearest
- Whether re-stationing has a cooldown.
  - explain question.what can be re-stationed?
- Free-space definition: footprint clearance only, or also minimum spacing from roads and other factories.
  - easiest implementation.
- Whether factories can be placed on rival-held ground, or only in neutral / own areas.
  - factories can be placed on any free space like land. (no roads or buildings etc)
- Factory placement range from the player, and whether it equals the conquest radius.
  - same radius 5m
- Whether a factory itself can be attacked and destroyed, and what it drops.
  - factories can be destroyed like unkts and towers. drops nothing.
- Which POI categories qualify as workshops, and their density per region.
  - school and trainstations
- Workshop fallback where POI data is thin — synthesize, or widen the qualifying categories.
  - no synthesize. user has to travel
- Whether crafting has a per-workshop cooldown, to stop one site being farmed repeatedly.
  - you can convert essence to gear any time if you have the essence needed
- Exact safe-zone radius value (decided: small).
  - 5m
- Snap tolerance: how far outside the radius a fix may sit and still snap in.
  - 5m
- Whether duels are rated or tracked at all, or purely casual.
  - player stats only
- Whether duel results feed a leaderboard, and if so scoped per region or global.
  - global
- Whether a duel can be declined silently or shows a refusal to the challenger.
  - auto decline setting.
  - show a message to the requester. player has declined request
- Tower count per building, and whether it scales with building volume.
  - must be placable on building footprint on roof
- Whether towers repair or must be rebuilt after an attack.
  - repair and rebuilt option
- Whether towers block conquest of a Neutral building, or only damage to an Owned one.
  - explain question
- Fixed conquest radius value.
  - 5m
- Density normalization constants: `d_ref`, `a`, `bonus_max`.
  - explain
- Whether synthetic (non-footprint) targets carry reduced value, and by how much.
  - explain question
- Whether free map panning is limited to subscribed cells or reaches any owned asset.
  - free mappanning for nearby with fog of war. you can see buildings and workshops and road. etc but not owners or units, towers..daemons
- Sight radius value, and whether it differs per asset type (a tower sees further than a unit).
  - all the same (in a later state more unit and tower types, ranges, damage types etc)
- Building-kit size: how many low-poly building variants per kind before repetition shows.
  - start with 1 per type
- Whether faction ownership reads as a full retexture, an accent colour, or an overlay.
  - simpelst implementation (sperate color for own buildings)
- Camera zoom band: closest and widest zoom, and whether zoom level changes what is rendered.
  - what is phone can handle. 
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
