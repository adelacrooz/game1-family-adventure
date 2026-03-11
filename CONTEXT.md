# Game 1 — Context & Decisions

This file captures *why* decisions were made and what was learned across sessions.
See CLAUDE.md for design rules, PROGRESS.md for build status.

---

## Architecture Decisions

### Single cart, single file
Decided to ship as one `.p8` cart updated over time (vs. two separate carts).
- Save data stays consistent — `cartdata()` ID persists across updates
- Use git branches for isolation during development (main = stable/released)
- If the cart ever hits token/sprite limits, revisit splitting

### Hardcoded Lua for level and room data (no map editor)
All platforms, walls, and door triggers are plain Lua arrays. This frees all 256 sprite slots for art — the map editor is unused, so there's no sprite/map memory conflict.
- If rooms are later converted to tilemap-based layout, only ~10–20 tile types are needed, so slots 128–255 remain safe

### Scene manager (`goto_scene`)
Outdoor and indoor areas are separate scenes switched via `goto_scene(s)`. Each scene has its own spawn point. This avoids loading screens and keeps transitions instant. State is reset on scene switch (velocity, dash, wall timers, ghost trail, etc.).

---

## Sprite Decisions

### All characters at 8×8
Considered 8×16 for the player and 8×24 for parents to visually signal age difference. Decided against it — 8×8 keeps indoor top-down perspective consistent and simplifies art. Age difference is shown through head-to-body ratio, hair silhouette, and color instead. Can revisit.

### Slot layout
See SPRITES.md for the full slot map. Characters use slots 1–8 (2 frames each), critters 9–20, tools 21–24, resources 25–30, furniture 32–41, tiles 48–52. Estimated ~54 slots used of 256.

---

## Movement System

### Wall jump + air dash added intentionally
The core outdoor area has a wide pit (72 px) that requires skillful movement to cross. Wall jump and air dash were added to give the player expressive movement tools — the pit rewards mastering them. Slide dash (Down+O) was added as a grounded speed option.

### `jump_force` is -4.5, not -7
Early docs cited -7; this was tuned down to -4.5 for a tighter feel. CLAUDE.md now reflects the actual value. If you see -7 anywhere, it's outdated.

---

## Save Data (`dset`) Layout

| Slots | Used for |
|-------|---------|
| 0–7 | Red music notes |
| 8–15 | Blue music notes |
| 16–23 | Yellow music notes |
| 24–29 | Critter catches (6 critters) |
| 30–39 | Task/objective flags |
| 40+ | Available |

---

## PICO-8 Gotchas Learned

- **Token limit is 8192**, not 16K. Cursor chat cited 16K incorrectly. Keep code tight.
- `cartdata()` ID is a global namespace shared across all PICO-8 users on a machine — use a specific string like `"andredelacruz_game1_v1"` to avoid collisions.
- To capture a cart label before HTML export: run the game, press **F7** (or Ctrl+7 on Mac) to capture current screen. Then `export game1.html`. Typing `label` in the command line gives a syntax error — the shortcut is the only way.
- `btn(4)` = O button (Z or C keys). `btn(5)` = X button (X or V keys). Z and C are aliases for the same button — cannot be used independently.

---

## Workflow Notes

- Edit in Cursor/VSCode → save → in PICO-8 press `Cmd+R` to reload → `Cmd+Enter` to run
- `Cmd+Shift+B` launches PICO-8 with game1.p8 via the VSCode build task
- See PICO8-WORKFLOW.md for full workflow, button mapping, and multi-cart strategy reference
