# Game 1 — PICO-8 Family Adventure

## Game Concept

A family-themed adventure game built in [PICO-8](https://www.lexaloffle.com/pico-8.php) (Lua). The player controls a **6-year-old boy** navigating two environments: an outdoor trail and his family's house.

### Core Gameplay Loop

```
[OUTDOORS]  →  Collect resources / critters / music notes  →  [ENTER HOUSE via front door]  →  Craft / Cook / Display critters / Play piano  →  (return outdoors)
```

- **Outdoors:** Exploration and resource gathering (plants, wood, herbs, fish, critters, music notes)
- **Indoors:** Use resources to craft and cook; display caught critters; play unlocked songs on the piano
- **Family NPCs:** Give tasks and react to player progress

---

## Characters

| Character | Location | Movement | Role |
|-----------|----------|----------|------|
| **Player** (6-year-old boy) | Both environments | Full player control | Protagonist |
| **Dad** | Kitchen (Floor 1) | Simple patrol loop | Task giver, dialogue |
| **Mom** | Living room(s) (Floor 1) | Simple patrol/loop with brother | Task giver, dialogue |
| **Younger brother** | Living room(s) (Floor 1) | Plays with Mom | Task giver, dialogue |

NPC dialogue and tasks change based on game-state flags (e.g. `has_collected_berries`, `has_crafted_toy`).

---

## Environments

### 1. Outdoors (Side-Scrolling Platformer) — *current prototype*

- **Style:** Metroidvania — one large map, no loading screens or transitions
- **Movement:** Left/right primary; vertical exploration via platforms, ledges
- **Camera:** Follows player horizontally (and vertically when needed), clamped to level bounds
- **Resources:** Collectible nodes placed at specific map locations
- **Background:** Mountains, lake; foreground: grass, trail
- **Planned map sketch:**
  ```
          [upper area - berries?]
                |
      [lake]----[trail]----[mountain base]
                |
          [lower area - wood? herbs?]
  ```

### 2. Indoors (Top-Down) — *not yet built*

| Area | Contents | Transitions |
|------|----------|-------------|
| **Floor 1** | Kitchen, 2 living rooms, dining area | Stairs up → Floor 2; front door → Outdoors |
| **Floor 2** | Hall with 3 doors (only 1 open) | Stairs down → Floor 1; bedroom door → Bedroom |
| **Bedroom** | Player's room | Door back to Floor 2 |

- **Movement:** 4-directional, no gravity
- **Collision:** Walls and furniture as solid

---

## Progress & Task Tracking

See [PROGRESS.md](PROGRESS.md) for what's built, what's pending, who does what, and the `dset` slot map.

---

## Critter Collection System

Players catch critters found in the outdoor area and bring them home to display, interact with, and use for NPC tasks.

### Critter Roster & Capture Tools

| Critter | Tool Required | Outdoor Location |
|---------|--------------|-----------------|
| Crab | Crab Net | Near the lake |
| Butterfly | Bug Net | Flower/berry area (upper area) |
| Beetle | Bug Net | Lower ground near trail |
| Firefly | Bug Net | Any outdoor area (rare, wanders widely) |
| Snake | Snake Tongs | Mountain base area |
| Frog | Frog Scoop | Near lake edge |

Capture tools are crafted at the workbench (e.g., sticks + cloth → Bug Net). Inventory tracks which tools the player has built.

### Capture Mechanic

1. Critters wander in small bounded areas using random-direction AI (turn at boundary edges)
2. Player walks within ≈12px and presses **O**
3. Correct tool in inventory → critter captured, added to critter inventory, despawns from map
4. No tool → hint displayed: *"You need a [tool name]!"*
5. Critters do not flee — ambient wandering only
6. **One-time catch** — each critter is caught once and never respawns (state persisted via `dset`)

### Display & Placement

- Critters can be placed on **display stands** in two indoor locations:
  - **Bedroom** (Floor 2) — personal collection shelf
  - **Floor 1 living area** — 2–3 designated display spots
- A critter on a display stand plays an **idle sprite animation in place** — it does not move around
- Walk up to a displayed critter → press O to open interaction menu: **[Pick up] / [Talk]**

### Critter Interaction (Indoors)

When the player interacts with a critter (whether on a display stand or roaming freely):

- **Pick up** — critter returns to inventory; removed from its current location
- **Talk** — plays a critter sfx + shows flavour dialogue mimicking the sound:

| Critter | Dialogue |
|---------|---------|
| Frog | "Ribbit!" |
| Snake | "Hisss..." |
| Crab | "Click click!" |
| Beetle | "Bzzt!" |
| Butterfly | "..." *(silent, flutters)* |
| Firefly | "Blink!" |

### Free Roam

- A critter that is **picked up from a display stand and set down freely** (not on a stand) becomes a wandering NPC with its own patrol route in that room
- It can still be interacted with (pick up or talk) while roaming freely
- Placing it back on a display stand returns it to idle animated display mode

### NPC Task Integration

- Family NPCs can request specific critters (e.g., "Can you bring me a frog?")
- Approach the NPC while holding the requested critter → special reaction dialogue plays
- Completing a critter task advances the NPC's task flag

---

## Music Note Collection System

Players collect color-coded music notes scattered across the outdoor area. Completing a full set unlocks a song that can be played on the piano indoors.

### Song Sets

| Song | Note Color | Notes Required | Song Name |
|------|-----------|---------------|-----------|
| Song 1 | Red | 8 | Lullaby |
| Song 2 | Blue | 8 | Adventure March |
| Song 3 | Yellow | 8 | Family Theme |

- **24 notes total** placed across the outdoor map
- Notes distributed at varied heights to reward platforming exploration
- All notes are visible from the start — no unlock required to see them

### Collection Mechanic

- Notes appear as floating/bobbing sprites with their set's PICO-8 palette color
- Player walks into a note → **auto-collected**; a chime sfx plays on pickup
- Notes persist via `dset` — once collected, permanently removed from map
- **HUD** shows collected count per color (e.g., `♪ Red 5/8`)

### Piano (Floor 1 — Living Room)

- Piano is a furniture piece in the living room; requires a sprite + interaction hotspot
- Walk up and press **O** to open the piano menu
- Menu shows three song slots, each displaying: color label · X/8 count · lock status
  - **Complete set (8/8):** press O → plays PICO-8 music sequence + brief screen shimmer/sparkle animation
  - **Incomplete set:** shows *"Find all [color] notes to unlock!"*
- Press **X** to close the piano menu

---

## Current Cart (`game1.p8`)

**Outdoor platformer prototype.** Physics working, no sprites, enemies, or win condition.

### Controls

| Input | Action |
|-------|--------|
| Left / Right arrows | Move |
| O button (`btn(4)`) | Jump |

### Physics Constants

| Variable | Value | Purpose |
|----------|-------|---------|
| `gravity` | 0.35 | Applied each frame when airborne |
| `max_fall` | 4 | Terminal velocity cap |
| `jump_force` | -7 | Vertical velocity on jump |
| `move_speed` | 2.2 | Max horizontal speed |
| `move_accel` | 0.4 | Acceleration per frame |
| `ground_friction` | 0.82 | Velocity multiplier when grounded with no input |
| `coyote_frames` | 6 | Frames after leaving ledge where jump still works |
| `jump_buffer_frames` | 5 | Frames a jump press is remembered before landing |

### Player Object (`p`)

- Position: `p.x`, `p.y` (top-left of hitbox)
- Velocity: `p.vx`, `p.vy`
- Hitbox: 6×8 px
- State: `p.on_ground`

### Collision

- AABB overlap via `rect_overlap()`
- `resolve_x()` — tests prospective position before moving; zeroes `p.vx` on wall hit
- `resolve_y()` — snaps to platform top on landing, sets `p.on_ground`; bounces off ceilings

### Level Layout

- **Width:** 960 px, 4 areas
- **Ground:** full-width platform at y=120
- **Platforms:** hardcoded array `platforms` — each entry is `{x, y, w, h}`
- **Camera:** `cam_x = mid(0, p.x-64, level_width-128)` — centers player, clamped at edges

### Draw

- Sky: two `rectfill` bands (light blue + cyan)
- Platforms: dark green fill + light green outline
- Player: `circfill` placeholder — replace with `spr()` once sprites are drawn

---

## Development Workflow

### Launching the game

**`Cmd+Shift+B`** — runs the "Run Pico-8" VSCode task, opening PICO-8 with `game1.p8` loaded.

Binary path: `/Applications/PICO-8.app/Contents/MacOS/pico8`

### Edit → Test loop

1. Edit `game1.p8` and **save** (`Cmd+S`)
2. In PICO-8, press **`Cmd+R`** to reload the cart
3. Press **`Cmd+Enter`** to run

---

## PICO-8 Constraints

| Constraint | Impact |
|------------|--------|
| 128×128 display, 16 colours | Keep UI minimal |
| ~8192 token limit | Keep logic modular; reuse helpers |
| 128×64 map max | Design levels to fit; reuse tiles |
| 256 sprites (8×8 each) | Share tiles for NPCs, terrain, furniture |
| `dget` / `dset` (256 slots) | Use for save/load of progress |

> **Note:** Cursor chat cited 16K token limit — PICO-8's actual Lua token budget is 8192. Keep code tight.
