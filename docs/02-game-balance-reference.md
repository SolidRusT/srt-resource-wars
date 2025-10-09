# Game Balance Reference Data from Dune II/Dynasty

## Overview

This document extracts **game balance concepts and ratios** from Dune Dynasty that we can adapt for Resource Wars. These are **principles and relationships**, not exact values to copy.

---

## Unit Categories and Roles

### Infantry (Light, Cheap, Vulnerable)
- **Light Infantry** - Basic melee/anti-infantry
- **Troopers** - Ranged anti-vehicle 
- **Saboteurs** - Special infiltration unit

**Balance Principle:** Infantry should be ~1/3 the cost of vehicles but vulnerable to area weapons

---

### Light Vehicles (Fast Scouts, Harassment)
- **Trike** - Fast scout, anti-infantry
- **Raider Trike** (Ordos) - Even faster, less armor
- **Quad** (Harkonnen) - Slower, more armor, more expensive

**Balance Principle:** Speed vs. armor trade-off. Scout units should reveal ~2-4 tiles of fog.

---

### Main Battle Units (Core Army)
- **Combat Tank** - Balanced main battle unit
- **Siege Tank** - Slower, more expensive, higher damage/range
- **Missile Tank** - Long range, poor accuracy, high damage vs. buildings

**Balance Principle:** Range 4 → Range 5 costs ~2x. Range 9 requires minimum range penalty and accuracy reduction.

---

### Heavy Units (Expensive, Powerful, Slow)
- **Devastator** - Maximum armor/damage, nuclear self-destruct risk
- **Sonic Tank** (Atreides) - Area effect weapon
- **Deviator** (Ordos) - Mind control instead of damage

**Balance Principle:** Faction-specific heavy units should be 2.5-3x cost of main tanks with unique abilities rather than just stat increases.

---

### Support Units (Utility)
- **Harvester** - Resource collection, heavy armor
- **Carryall** - Transport, automated unit recovery
- **MCV** - Mobile Construction Yard

**Balance Principle:** Harvesters should be expensive (relative to light vehicles) to create risk/reward in resource collection.

---

### Air Units (Special Rules)
- **Ornithopter** - Scouting, light attack
- **Carryall** - Transport only

**Balance Principle:** Air units should have limited engagement time or fuel to prevent air-dominance.

---

## Structure Categories and Dependencies

### Tier 0 (Starting)
- **Construction Yard** - Only starting structure

---

### Tier 1 (Basic Economy)
- **Windtrap** - Power generation
- **Refinery** - Resource processing (includes free Harvester)
- **Silo** - Resource storage expansion

**Balance Principle:** Refinery should include 1 free harvester to jumpstart economy.

---

### Tier 2 (Military Production)
- **Barracks** - Infantry production
- **Light Factory** - Light vehicle production
- **Radar Outpost** - Minimap reveal

**Dependency:** Requires Windtrap + adequate power

---

### Tier 3 (Advanced Military)
- **Heavy Factory** - Heavy vehicle production
- **High Tech Facility** - Advanced units (Carryall, Ornithopter)
- **Repair Pad** - Vehicle repair

**Dependency:** Requires Light Factory + Outpost + Refinery

---

### Tier 4 (Elite/Super)
- **Starport** - Instant unit purchase at variable prices
- **House of IX** - Faction-specific advanced units
- **Palace** - Superweapons

**Dependency:** Progressive mission unlocks (6+, 7+, 8+)

---

### Defensive Structures
- **Wall** - Cheap barrier
- **Gun Turret** - Anti-ground defense
- **Rocket Turret** - Anti-air/long range defense

**Balance Principle:** Static defense should be cost-effective against small raids but overwhelmed by massed armies.

---

## Resource Economy Principles

### Harvester Cycle
- **Capacity:** 700 credits (100% load)
- **Cycle Time:** 2-4 minutes depending on distance
- **Risk Factor:** Sandworm attacks create catastrophic unit loss

**Adapted Principle:** Harvester vulnerability should force player attention to economy, not just military.

---

### Credit Flow
- **Starting Credits:** 1000-2500 (mission dependent)
- **Early Game Income:** ~200-300 credits/minute (1-2 harvesters)
- **Mid Game Income:** ~500-800 credits/minute (3-4 harvesters)
- **Late Game Income:** ~1000+ credits/minute (5+ harvesters, multiple refineries)

**Adapted Principle:** Income should scale 2-5x from early to late game through multiple harvester optimization.

---

### Build Times (at 15 ticks/second)
- **Infantry:** 32 ticks (~2 seconds) - Very fast
- **Light Vehicle:** 64 ticks (~4 seconds) - Fast
- **Heavy Vehicle:** 96-144 ticks (~6-10 seconds) - Moderate
- **Buildings:** Variable, 100-300 ticks (~7-20 seconds)

**Adapted Principle:** Production time should be roughly proportional to unit cost, creating strategic queue management.

---

## Faction Asymmetry Patterns

### Atreides (Balanced, Honorable)
- **Advantage:** No vehicle degradation, minimal building decay
- **Special Unit:** Sonic Tank (area effect)
- **Special Power:** Fremen warriors (uncontrollable allies)
- **Balance:** Middle-of-road stats, precision weapons

---

### Harkonnen (Brutal, Expensive)
- **Advantage:** Maximum firepower and armor
- **Disadvantage:** 78% mental weakness, 33% vehicle degradation, 3x building decay
- **Special Unit:** Devastator (nuclear self-destruct)
- **Special Power:** Death Hand missile (inaccurate but devastating)
- **Balance:** High cost, high power, high maintenance

---

### Ordos (Cunning, Tactical)
- **Advantage:** Speed and trickery
- **Special Unit:** Raider Trike (speed 60 vs 45), Deviator (mind control)
- **Special Power:** Saboteur (instant building destruction)
- **Balance:** No heavy firepower equivalent, requires tactical finesse

---

## Combat Mechanics Insights

### Weapon Ranges
- **Melee:** Range 0 (touch)
- **Short:** Range 2-3 (infantry, light vehicles)
- **Medium:** Range 4 (main battle tanks)
- **Long:** Range 5-6 (siege weapons)
- **Artillery:** Range 9 (missile tanks, turrets)

**Adapted Principle:** Each range category should cost ~1.5-2x the previous.

---

### Damage Types
- **Direct Fire:** Instant hit, high accuracy
- **Ballistic:** Travel time, lower accuracy, high damage
- **Area Effect:** Fixed damage over radius
- **Special:** Mind control, instant kill (saboteur)

**Adapted Principle:** Area effect and special weapons should have significant cost/cooldown/risk.

---

### Hit Points Scaling
- **Infantry Squad:** 30-50 HP (3 soldiers × 10-15 HP each)
- **Light Vehicle:** 80-130 HP
- **Main Tank:** 200-300 HP
- **Heavy Unit:** 300-400+ HP
- **Harvester:** 200 HP (armored for safety)

**Adapted Principle:** HP should roughly correlate with cost, with harvesters having "bonus" armor.

---

## Sandworm Mechanics (Environmental Threat)

### Stats
- **HP:** 1000 (effectively unkillable)
- **Speed:** 35
- **Behavior:** Attacks rhythmic vibrations, attracted to harvesters
- **Movement:** Fast through sand, cannot cross rock

**Adapted Principle:** An environmental threat that cannot be defeated forces player adaptation and creates tension without artificial timers.

---

## Tech Tree Progression

### Early Game (Minutes 0-5)
- **Goal:** Establish economy
- **Buildings:** Windtraps → Refinery → Silo
- **Units:** Harvesters, basic scouts

---

### Mid Game (Minutes 5-15)
- **Goal:** Build military production
- **Buildings:** Barracks → Light Factory → Outpost
- **Units:** Infantry, light vehicles

---

### Late Game (Minutes 15-30+)
- **Goal:** Advanced units and dominance
- **Buildings:** Heavy Factory → Hi-Tech → House of IX → Palace
- **Units:** Heavy tanks, special weapons

**Adapted Principle:** Tech unlocks should pace the game naturally, preventing early rushes but allowing late-game variety.

---

## Unit Caps and Limits

### Original Dune II Caps
- **Per House (Scenario):** 20-25 units
- **Overall Hard Cap:** 102 total units
- **Ground Units:** 80 maximum
- **Air Units:** 11 maximum
- **Saboteurs:** 3 maximum

### Dynasty Enhancement
- **Per House:** 50 units
- **Overall Cap:** 322 units
- **Ground Units:** 300 maximum

**Adapted Principle:** Higher caps enable larger battles, but require more efficient pathfinding and spatial partitioning. Start with 100-200 unit cap for MVP, expand later.

---

## Key Ratios for Balance

### Cost Relationships
- Infantry : Light Vehicle : Main Tank : Heavy Unit = **1 : 1.5 : 3 : 8**
- Example: Infantry 100 → Trike 150 → Tank 300 → Devastator 800

---

### Speed Relationships
- Heavy : Main : Light : Scout = **1 : 1.25 : 1.67 : 2**
- Example: Devastator 30 → Tank 40 → Trike 45 → Raider 60

---

### Range vs. Cost
- Range 2 (cost 1x) → Range 4 (cost 2x) → Range 6 (cost 3x) → Range 9 (cost 4.5x)

---

### Production Time vs. Cost
- Roughly **linear relationship**: 1 tick per 10 credits
- Example: 300-credit tank = ~30 ticks (~2 seconds)

---

## Power Management

### Power Production
- **Windtrap:** 100 power, 300 credits

### Power Consumption
- **Refinery:** 30 power
- **Factory:** 30 power
- **Heavy Factory:** 60 power
- **Hi-Tech:** 40 power

**Adapted Principle:** Power deficit should degrade ALL structures equally by deficit percentage, forcing economic planning.

---

## Adapted for Resource Wars

### Simplified Resource System
Instead of single "spice" resource, we'll have **customizable resource types**:
- **Spice** (classic mode)
- **Metals** (industrial mode)
- **Fuel** (energy mode)

All follow same gathering mechanics but thematic differences.

---

### Three-Faction System
Using Dune II's proven asymmetry:

**Faction A (Balanced):**
- Even stats
- Precision weapons
- Defensive superweapon

**Faction B (Aggressive):**
- High cost, high power
- Vulnerability to special weapons
- Offensive superweapon

**Faction C (Tactical):**
- Speed and tricks
- Special abilities over raw power
- Infiltration superweapon

---

## Implementation Priority for MVP

### Must-Have Balance (Day 1-2)
- [ ] 2 unit types minimum (worker, soldier)
- [ ] 1 building type (base/factory)
- [ ] 1 resource type
- [ ] Simple combat (HP, attack, death)
- [ ] Basic harvesting cycle

### Nice-to-Have Balance (Post-MVP)
- [ ] 5-6 unit types
- [ ] 3-4 building types
- [ ] Tech tree (2-3 tiers)
- [ ] Faction differences
- [ ] Advanced combat mechanics

---

## Balance Testing Approach

### Phase 1: Single-Player Testing
1. Can player afford military after economy setup? (Minutes 3-5)
2. Does combat feel decisive but not instant? (5-10 second battles)
3. Can player defend against first enemy wave? (Minute 7-10)

### Phase 2: AI Testing
1. Does AI expand economy reasonably? (2-3 harvesters)
2. Does AI attack at appropriate timing? (When 5-10 units)
3. Can player win without exploits? (20-30 minute games)

### Phase 3: Balance Iteration
1. Identify dominant strategies
2. Adjust costs/times by 10-20% increments
3. Retest and repeat

**Golden Rule:** If something feels too strong, increase cost by 20% OR increase build time by 20% OR reduce effectiveness by 20%. Never adjust multiple variables simultaneously.

---

## Conclusion

These ratios and relationships have been battle-tested over 30+ years of RTS evolution. While we'll adapt them to our Godot/SVG implementation and potentially simplified resource system, the **fundamental relationships** provide a proven foundation.

**Remember:** Good RTS balance creates:
- Meaningful choices (not dominant strategies)
- Tactical depth (counters and positioning matter)
- Economic tension (expansion vs. military trade-off)
- Comeback potential (losing one battle ≠ losing game)
