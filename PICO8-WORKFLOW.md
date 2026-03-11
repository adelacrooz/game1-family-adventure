# Pico-8 Development Workflow in Cursor

This guide explains how to develop Pico-8 games in Cursor with the full edit-run cycle.

---

## 1. Install the Pico-8 Extension

1. Open the Extensions panel (`Cmd+Shift+X` on Mac, `Ctrl+Shift+X` on Windows/Linux).
2. Search for **"Pico-8"** or **"pico8-ls"**.
3. Install one of them for syntax highlighting and autocomplete.

---

## 2. Add a Cart to the Project

A starter cart `game1.p8` is included. It has a movable circle (arrow keys) and the standard `_init`, `_update`, and `_draw` callbacks. The **Run Pico-8** task loads `game1.p8` by default. To use a different file, edit `.vscode/tasks.json` and change the path in the `args` array.

---

## 3. Edit in Cursor

Edit your cartridge code in Cursor and save often. All changes are written to the file immediately, so Pico-8 can reload them.

---

## 4. Launch Pico-8 with the Run Pico-8 Task

Use the built-in task to open Pico-8 with your cart:

1. **Command Palette:** `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
2. Run **Tasks: Run Task**
3. Choose **Run Pico-8**

**Shortcut:** `Cmd+Shift+B` (Mac) or `Ctrl+Shift+B` (Windows/Linux) runs the default build task, which is set to **Run Pico-8**.

Pico-8 starts with your cart loaded and saves go directly to your project folder.

---

## 5. Edit → Save → Reload → Run

1. **Edit** your `.p8` in Cursor.
2. **Save** the file (`Cmd+S` / `Ctrl+S`).
3. In Pico-8, press **`Cmd+R`** (Mac) or **`Ctrl+R`** (Linux/Windows) to **reload** the cart.
4. Press **`Cmd+Enter`** (Mac) or **`Ctrl+Enter`** (Linux/Windows) to **run** the game.

Pico-8 stays open while you iterate; reload after each save to test your latest changes.

---

## 6. Capture a Label (for HTML Export)

Before exporting to HTML (e.g. for itch.io or GitHub Pages), you must capture a **label** — the 128×128 preview image that Pico-8 uses in the web export.

1. **Run** your game (`Cmd+Enter` / `Ctrl+Enter`).
2. Let the game show the screen you want as the preview (gameplay, title, etc.).
3. Press **F7** (or **Ctrl+7** on Mac) to capture the current screen as the label.
4. Press **Esc** to open the command line.
5. Run `export game1.html` (or your cart name) — the export should succeed.

**Note:** Typing `label` in the command line gives a syntax error; the label is captured via the keyboard shortcut, not a command.

---

## Custom Tasks

Tasks are defined in `.vscode/tasks.json`. To run a task: open the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`), choose **Tasks: Run Task**, then pick the task.

### Run Pico-8

| Property | Value |
|----------|-------|
| **Label** | Run Pico-8 |
| **Shortcut** | `Cmd+Shift+B` (Mac) / `Ctrl+Shift+B` (Windows/Linux) |
| **Action** | Launches the Pico-8 app witHa!h `game1.p8` loaded |

**Command:** `/Applications/PICO-8.app/Contents/MacOS/pico8 "${workspaceFolder}/game1.p8"` (macOS)

This task is set as the default build task, so it runs when you use the build shortcut. Pico-8 opens with your cart ready to edit and run. Saves in Pico-8 write directly to `game1.p8` in your project folder.

**To load a different cart:** Edit `.vscode/tasks.json` and change the path in the `args` array, e.g. `"${workspaceFolder}/mygame.p8"`.

---

## 7. Button Mapping Reference

PICO-8 has **6 buttons per player** — no more, no less:

| Index | Keys | PICO-8 name |
|-------|------|-------------|
| `btn(0)` | Left arrow | ← |
| `btn(1)` | Right arrow | → |
| `btn(2)` | Up arrow | ↑ |
| `btn(3)` | Down arrow | ↓ |
| `btn(4)` | Z or C | O button |
| `btn(5)` | X or V | X button |

**Z and C are keyboard aliases for the same button** (`btn(4)`). Same with X and V (`btn(5)`). They cannot be used independently.

### Recommended action button layout

To avoid conflicts between jump and interact, assign each to a separate button:

| Button | Index | Recommended use |
|--------|-------|-----------------|
| O (Z/C) | `btn(4)` | Jump / confirm |
| X (X/V) | `btn(5)` | Interact / open menu |

The conventional PICO-8 pairing is O = confirm/action, X = cancel/back — but since you control the UX, you can define them however you want. Just be consistent and show the binding to the player (e.g. `[X] Interact` near interactive objects or in the HUD).

---

## Multi-Cart Release Strategy & Save Data

When releasing a game in episodes or levels, you have two options for how to structure your carts and share save data between them.

---

### Option A: Single Cart, Updated Over Time (Recommended)

Ship one `.p8` cart. When a new level is ready, publish an updated version of the same file. The player re-downloads or refreshes the itch.io embed and their save data is preserved automatically.

**How save data persists across updates:**
Cartdata is stored **separately from the `.p8` cart file**, in a dedicated folder on the player's machine:

| Platform | Location |
|----------|----------|
| macOS | `~/Library/Application Support/pico-8/cdata/` |
| Windows | `%APPDATA%/pico-8/cdata/` |
| Linux | `~/.lexaloffle/pico-8/cdata/` |

Each cartdata ID gets its own file in that folder. For web/itch.io embeds, cartdata is stored in the browser's localStorage, also keyed by the ID string.

Because the save data is decoupled from the cart file, replacing the `.p8` with a new version has no effect on saves. As long as the `cartdata()` ID string stays the same between versions, PICO-8 finds the existing data automatically. No migration or transfer needed.

```lua
-- in every version of the cart
cartdata("yourname_game1_v1")
```

**Pros:**
- Save data just works — no transfer mechanism required
- One file for players to manage; no hunting for a second cart
- Works across devices if using a web embed (localStorage is keyed to the ID, not the file)
- Simpler slot management — one clear owner of each slot

**Cons:**
- Both levels live in one cart, so a bug introduced while building level 2 could affect the released level 1 experience if you're not careful with branching

**Mitigating the development risk:**
Use git branches. Keep `main` as the stable, released cart. Develop the new level on a feature branch. Merge only when level 2 is ready. This gives you full isolation without splitting the cart.

---

### Option B: Two Separate Carts Sharing a cartdata ID

Both carts declare the same string in `cartdata()`. PICO-8 then maps them to the same 256 persistent slots, so level 1 can write flags that level 2 reads.

```lua
-- level1.p8
cartdata("yourname_game1_v1")
dset(0, 1)  -- mark level 1 completed

-- level2.p8
cartdata("yourname_game1_v1")
if dget(0) == 1 then  -- level 1 was completed
  -- unlock something
end
```

**Pros:**
- Level 2 can be developed and released as a completely separate file, with zero risk of touching level 1's cart
- Each cart's token/sprite/map budget is independent

**Cons:**
- Save data only transfers if both carts are run **on the same machine** — there is no sync between devices
- Player must find and download a second cart; discovery friction is higher
- You must plan a shared slot layout carefully upfront to avoid the two carts overwriting each other's data (e.g. slots 0–49 = level 1, slots 50–99 = level 2)
- If you later change the slot layout, old saves from the released level 1 cart can corrupt level 2's reads — requires a version-check slot (e.g. slot 0 = save format version)

---

### When to use each approach

| Situation | Recommended approach |
|-----------|---------------------|
| Linear episodic game (play level 1, then level 2) | Single cart, updated |
| Levels are independent / playable in any order | Two carts |
| Cart is hitting token, sprite, or map limits | Two carts |
| You want the safest save data transfer | Single cart, updated |
| You want full development isolation without git branching | Two carts |

---

### cartdata() ID naming

The ID is a global namespace shared across all PICO-8 users on a machine. Use a specific name to avoid accidental collisions:

```lua
cartdata("yourname_gamename_v1")
-- e.g. "andredelacruz_game1_v1"
```

The `_v1` suffix lets you introduce a clean save slate in a future version if the slot layout ever needs a breaking change.

---

## 8. Map Tool vs. Code-Generated Maps

### The map tool

PICO-8's built-in map editor gives you a 128×64 grid of tiles (1024×512 px total). Each tile is 8×8 px. You render a region with one call and read tile data with two:

```lua
map(cel_x, cel_y, scr_x, scr_y, cel_w, cel_h)  -- draw a region of the map
mget(tx, ty)                                      -- get the tile ID at map cell (tx,ty)
fget(tile_id, flag_n)                             -- check if flag N is set on a tile
```

For collision, set **flag 0** on solid tiles in the sprite editor's Flags tab, then check it at runtime:

```lua
-- is the tile at pixel position (px, py) solid?
local tx = px \ 8   -- integer divide to get tile column
local ty = py \ 8
if fget(mget(tx, ty), 0) then
  -- solid
end
```

### Map layout for this game

The 128×64 map splits naturally into two halves:

| Region | Rows | Use |
|--------|------|-----|
| Top half | 0–31 | Outdoor level (120 cols × 32 rows = 960×256 px) |
| Bottom half | 32–63 | Indoor rooms (Floor 1, Floor 2, Bedroom) |

### Map tool vs. alternatives — comparison

| Approach | Token cost | Editability | Best for |
|----------|-----------|-------------|----------|
| **Map tool** (recommended) | Near zero — data lives in `__map__` section, outside token budget | Visual editor, easy to iterate | Designed levels with specific layouts |
| **Static arrays** (current `platforms`) | High — every rect is tokens | Tedious to change | Prototyping only; doesn't scale |
| **Procedural (runtime)** | Medium | None — layout changes every run | Roguelikes, infinite runners |

**Use the map tool for all primary terrain.** The current `platforms` array is prototype scaffolding — it will be replaced once terrain tiles are drawn and the outdoor map is laid out.

### Procedural generation on top of the map

Procedural code works well for *decoration* layered on top of a designed map — it never replaces the authored terrain:

- **Scatter decorative tiles** (flowers, rocks, bushes) at `_init` on empty ground-adjacent cells using seeded RNG
- **Vary critter start positions** slightly each session (±8–16 px jitter within their zone)
- **Firefly spawn** — wider roam radius, more position variance fits its "wanders widely" design

Use a fixed session seed (`srand(rnd(1000))` once at `_init`) so the layout is consistent within a session but varies between runs.

### Migration path (platforms array → map-based)

When terrain tiles are drawn and the map is laid out:

1. Set **flag 0** on all solid tile types in the sprite Flags tab
2. Replace `resolve_x` / `resolve_y` platform lookups with `fget(mget(tx, ty), 0)` checks
3. Replace all `rectfill` terrain drawing with `map(0, 0, 0, 0, 120, 32)` (outdoor) or the appropriate indoor region
4. Delete the `platforms` table

---

## PICO-8 Hard Limits Reference

| Limit | Value | Notes |
|-------|-------|-------|
| **Token budget** | 8,192 tokens | Tightest constraint for a full game. Check live count in the code editor footer (bottom-right). Target: stay under ~7,000 before starting a major new system. |
| **Sprite slots** | 256 (8×8 px each) | Shared across all characters, items, terrain, furniture. Plan slot groups early — see SPRITES.md. |
| **Map size** | 128×64 tiles | Enough for a large outdoor area or several indoor rooms; design to fit. |
| **`dset` save slots** | 256 (0-indexed) | Assign and document before adding any new save-dependent system. |
| **Display** | 128×128 px, 16 colours | Keep UI minimal; no room for large overlays. |
| **SFX slots** | 64 | Songs + effects; budget them alongside gameplay SFX. |
| **Music patterns** | 64 | Each pattern chains SFX channels into a musical phrase. |

### Token-saving strategies (in priority order)

1. **Extract helper functions** — biggest win; deduplicating collision, UI, and menu logic pays off fast
2. **Remove dead/debug code** — commented blocks and `print()` debug calls all count
3. **Shorten variable names** — last resort; e.g. `on_ground` → `og` (only when within ~500 of the limit)
4. **Multi-cart split** — if approaching ~7,500 tokens, split outdoor + indoor into two carts sharing the same `cartdata()` ID (see Multi-Cart Release Strategy above)

---

## Status Snapshot

*Last updated: 2026-03-11*

| Budget | Used | Total | Notes |
|--------|------|-------|-------|
| Lines of code | ~1,308 | — | ~38 KB file size |
| Tokens | Well under limit | 8,192 | Check PICO-8 editor footer for live count |
| `dset` slots | 30 (slots 0–29) | 256 | Music notes (0–23), critter catches (24–29) |
| Sprite slots | 0 drawn | 256 | No pixel art yet; all placeholders |
| Map tiles | Not yet used | 128×64 | Indoor rooms not yet map-based |

**Systems in the cart as of this date:** outdoor physics & movement, scene manager (outdoor → floor1 → floor2 → bedroom), indoor top-down, camera, music notes + piano, resource nodes, NPC patrols, dialogue, task flags, crafting, cooking, critter AI + capture + display stands.
