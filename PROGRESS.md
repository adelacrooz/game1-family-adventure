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
| ✅ Advanced movement | Wall slide + wall jump, air dash (double-tap), slide dash (Down+O), side jump with sprite animation |
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
| Migrate outdoor level to tile-based collision | Medium | Outdoor terrain tiles drawn + outdoor map laid out |
| Migrate indoor rooms to tile-based collision | Medium | Indoor tile set drawn + room layouts done |
| Procedural decoration pass (outdoor) | Low | Outdoor map laid out |
| Critter/firefly spawn variation via seeded RNG | Low | Critter system |

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
| **Outdoor terrain tiles** | Sprite editor, slots 32–47 | Grass top, dirt, trail, mountain rock, lake edge, platform top/side. Set **flag 0** on every solid tile type in the Flags tab. |
| **Indoor tile set** | Sprite editor, slots 48–55 | Floor, wall, door — designed to tile cleanly; reused across all rooms. Set **flag 0** on wall tiles only. |
| **Outdoor map layout** | Map editor, rows 0–31, cols 0–119 | Full 960 px trail using outdoor terrain tiles. Place platforms, landmarks, and resource node locations at intended spots. |
| **Indoor room layouts** | Map editor, rows 32–63 | Floor 1 (kitchen, living room, dining), Floor 2 (hall + doors), Bedroom — all using indoor tile set. Leave door/stair tiles non-solid. |
| **Song 1 — Lullaby** | SFX editor, slot 0 | Then uncomment `sfx(0)` in `update_piano()` |
| **Song 2 — March** | SFX editor, slot 1 | Then uncomment `sfx(1)` |
| **Song 3 — Family Theme** | SFX editor, slot 2 | Then uncomment `sfx(2)` |
| **Collect chime SFX** | SFX editor, slot 3 | Short rising tone; add `sfx(3)` in `collect_notes()` |

### 🤝 Needs coordination

| Task | What you do | What Claude does |
|------|------------|-----------------|
| Replace player circle with sprite | Draw sprite in slot 1 | Swap `circfill` → `spr(1,p.x,p.y)` |
| Replace NPC circles with sprites | Draw sprites in slots 2–4 | Swap `circfill` → `spr(n.spr,n.x,n.y)` |
| Outdoor map migration | Draw terrain tiles (flag 0 = solid) + lay out outdoor map in editor | Replace `platforms` array with `fget(mget())` tile collision + `map()` rendering |
| Indoor room migration | Design rooms in PICO-8 Map editor, set flag 0 on solid tiles | Switch from hardcoded wall rects to `map()`-based collision |

---

## `dset` Slot Map
*(PICO-8 persistent save — 256 slots total, 0-indexed)*

| Slots | Used for |
|-------|---------|
| 0–7 | Red music notes (8 total) |
| 8–15 | Blue music notes |
| 16–23 | Yellow music notes |
| 24–29 | Critter catches (6 critters) |
| 30–39 | Task/objective flags — *reserved* |
| 40+ | Available |

---

## Suggested Next Steps

**For you (art + audio):**
1. Draw the player sprite (slot 1) — even a rough 5-color character makes playtesting much more satisfying; see [SPRITES.md](SPRITES.md) for slot plan and art guidance
2. Compose the 3 piano songs in the SFX editor (slots 0–2); collect chime in slot 3

**For Claude next:**
1. Critter display interaction (indoors) — pick up / talk menu when approaching a displayed critter
2. Free-roam critters (placed off a stand, wanders the room)
3. NPC task integration — critter delivery triggers special dialogue + advances task flag
4. Replace placeholder circles with `spr()` calls once sprites are drawn (see SPRITES.md → "Replacing Placeholder Circles")

---

## PICO-8 Budget & Technical Health

Periodic housekeeping tasks to stay within PICO-8's hard limits. Run a budget check before starting any major new system.

### 🔨 Token Budget

| Task | Notes |
|------|-------|
| **Periodic token audit** | Check live token count in PICO-8 editor footer (bottom-right of code tab). Target: stay under ~7000/8192 before adding large systems. |
| **Refactor: extract helper functions** | Deduplicating repeated logic (collision checks, UI drawing, menu loops) gives the biggest token savings. Do this whenever a pattern appears 3+ times. |
| **Shorten verbose variable names** | Low-priority but useful if tight — e.g. `on_ground` → `og`, `jump_buffer` → `jbuf`. Only do this if within ~500 tokens of the limit. |
| **Remove dead/debug code** | Strip commented-out blocks and debug `print()` calls before each major release. |
| **Plan multi-cart split** | If token count approaches ~7500, evaluate splitting outdoor + indoor into two carts sharing the same `cartdata()` ID. See [PICO8-WORKFLOW.md](PICO8-WORKFLOW.md) for the full strategy. |

### 🔨 `dset` Slot Budget

| Task | Notes |
|------|-------|
| **Finalize slot map before new systems** | Current usage: slots 0–29 (30/256). Before adding resource persistence, tool ownership, or NPC task flags, assign and document slots here first. |
| **Reserve a version-check slot** | Consider slot 255 = save-format version number. Lets future cart updates detect and reset stale saves cleanly. |

### 🎨 Sprite Slot Budget

| Task | Notes |
|------|-------|
| **Track slot usage as art is added** | 256 slots total. Player, NPCs, critters, tools, furniture, tiles all consume slots. Update the slot plan in [SPRITES.md](SPRITES.md) as each group is drawn. |
| **Share/reuse tiles where possible** | Terrain tiles (floor, wall, door) can be reused across rooms via the map editor rather than unique sprites per room. |
