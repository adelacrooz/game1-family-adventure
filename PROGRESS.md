# Game 1 — Progress Tracker

## Legend
- ✅ Done
- 🔨 Claude can build this
- 🎨 Requires PICO-8 editors (you)
- 🤝 Requires both

---

## What's Built

| System | Notes |
|--------|-------|
| ✅ Outdoor physics | Gravity, jump, coyote time, jump buffer, acceleration, friction |
| ✅ Scene manager | outdoor → floor1 → floor2 → bedroom, with spawn points |
| ✅ Indoor top-down | 4-way movement, wall collision, door/stair triggers |
| ✅ Camera | Horizontal scroll (outdoor); fixed 128×128 (indoor) |
| ✅ Music notes | 24 notes (8 red/8 blue/8 yellow), bobbing circles, auto-collect, HUD, `dset` save |
| ✅ Piano (floor1) | 3 song slots, note count display, sparkle animation on unlock |
| ✅ Resource nodes | Berries/fish/herbs/wood outdoor gather spots; O-button collect; HUD counts |
| ✅ Family NPC patrols | Dad, Mom, Brother patrol floor1; colored circles with name labels |
| ✅ Dialogue system | O to talk near NPCs; line-by-line box with name, text, next/close |
| ✅ Task flags | `tasks.fish` (0/1/2); dad's dialogue changes; fish delivery saved to dset |
| ✅ Crafting (workbench) | 2 recipes (net, jam); cost/result from `inv`; menu with affordability display |
| ✅ Cooking (kitchen) | Stove in floor1; soup (fish+herbs) and pie (2 berries); reuses can_craft |
| ✅ Critter wandering AI | 6 critters in outdoor zones; ground + flying movement; timer-based direction changes |
| ✅ Critter capture | O near critter with net → caught, removed from map, saved to dset 24–29 |
| ✅ Critter display stands | Bedroom shows 6 slots; colored circle if caught, "?" if not |

---

## What's Left to Build

### 🔨 Claude builds these

| System | Complexity | Depends on |
|--------|-----------|------------|
| ~~Resource nodes (outdoors)~~ | ✅ | — |
| ~~Family NPC patrols~~ | ✅ | — |
| ~~Dialogue system~~ | ✅ | NPC patrols |
| ~~Crafting (workbench)~~ | ✅ | Inventory, resources |
| ~~Task / objective flags~~ | ✅ | Dialogue, crafting |
| ~~Cooking (kitchen)~~ | ✅ | Crafting pattern |
| ~~Critter wandering AI~~ | ✅ | — |
| ~~Critter capture mechanic~~ | ✅ | Crafting (tools), dialogue |
| ~~Critter display stands~~ | ✅ | Critter capture |

### 🎨 You do these in PICO-8

| Task | Where | Notes |
|------|-------|-------|
| **Player sprite** | Sprite editor, slot 1 | 8×8 or 8×16 px; currently a placeholder circle |
| **Dad sprite** | Sprite editor, slot 2 | 8×8 walking cycle (2–4 frames) |
| **Mom sprite** | Sprite editor, slot 3 | 8×8 walking cycle |
| **Brother sprite** | Sprite editor, slot 4 | 8×8 |
| **Critter sprites** | Sprite editor, slots 5–10 | Crab, butterfly, beetle, firefly, snake, frog — 8×8 each |
| **Item/tool sprites** | Sprite editor, slots 11–16 | Bug net, crab net, snake tongs, frog scoop, etc. |
| **Furniture sprites** | Sprite editor, slots 17–24 | Piano, workbench, stove, display stands, bed |
| **Tile sprites** | Sprite editor, slots 32+ | Floor tile, wall tile, door — for map-based rooms later |
| **Song 1 — Lullaby** | SFX editor, slot 0 | Then uncomment `sfx(0)` in `update_piano()` |
| **Song 2 — March** | SFX editor, slot 1 | Then uncomment `sfx(1)` |
| **Song 3 — Family Theme** | SFX editor, slot 2 | Then uncomment `sfx(2)` |
| **Collect chime SFX** | SFX editor, slot 3 | Short rising tone; add `sfx(3)` in `collect_notes()` |

### 🤝 Needs coordination

| Task | What you do | What Claude does |
|------|------------|-----------------|
| Replace player circle with sprite | Draw sprite in slot 1 | Swap `circfill` → `spr(1,p.x,p.y)` |
| Replace NPC circles with sprites | Draw sprites in slots 2–4 | Swap `circfill` → `spr(n.spr,n.x,n.y)` |
| Indoor room layout | Design rooms in PICO-8 Map editor, set flag 0 on solid tiles | Switch from hardcoded walls to `map()`-based collision |

---

## `dset` Slot Map
*(PICO-8 persistent save — 256 slots total, 0-indexed)*

| Slots | Used for |
|-------|---------|
| 0–7 | Red music notes (8 total) |
| 8–15 | Blue music notes |
| 16–23 | Yellow music notes |
| 24–29 | Critter catches (6 critters) — *reserved, not built yet* |
| 30–39 | Task/objective flags — *reserved* |
| 40+ | Available |

---

## Suggested Next Steps

**For you right now:**
1. Draw the player sprite (slot 1) — even a simple 5-color character makes playtesting much more satisfying
2. Compose the 3 piano songs in the SFX editor (slots 0–2)

**For Claude next:**
1. Dialogue system (needed before tasks and crafting can be wired up)
2. Crafting (workbench) — depends on inventory + dialogue
