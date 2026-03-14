# Game 1 — Sprite Reference

## Capacity

PICO-8 provides a **128×128 pixel sprite sheet** divided into 256 slots of 8×8 px each.

| Range | Usage |
|-------|-------|
| Slots 0–127 | Always safe — dedicated sprite memory |
| Slots 128–255 | Safe as long as map rows 32–63 are unused |

This game uses **hardcoded Lua** for all level and room data (no map editor), so **all 256 slots are currently available**. Even if indoor rooms are later switched to tilemap-based layout, only a handful of tile types would be needed (≈10–20 tiles), leaving slots 128–255 untouched.

**Estimated usage: ~54 slots out of 256. No capacity concerns.**

> Art guidance for drawing the characters (proportions, age signals, color choices) is in [`sprites/character-art-guide.md`](sprites/character-art-guide.md) (8×8 outdoor) and [`sprites/character-sprite-design-plan.md`](sprites/character-sprite-design-plan.md) (16×16 indoor).

---

## Full Sprite List

### Characters

| Slot(s) | Character | Frames | Notes |
|---------|-----------|--------|-------|
| 1–2 | Player — idle + walk | 2 | Flip horizontally in code for left-facing |
| 3–4 | Brother — idle + walk | 2 | Flip for direction |
| 5–6 | Dad — idle + walk | 2 | Flip for direction |
| 7–8 | Mom — idle + walk | 2 | Flip for direction |

> Walk animation: alternate between idle (slot n) and walk (slot n+1) every 8–10 frames using `spr(n + flr(anim_t/8)%2, x, y)`.

### Critters

| Slot(s) | Critter | Frames | Location |
|---------|---------|--------|----------|
| 9–10 | Frog | 2 | Lake edge |
| 11–12 | Crab | 2 | Lake area |
| 13–14 | Butterfly | 2 | Upper area (berries) |
| 15–16 | Beetle | 2 | Ground trail |
| 17–18 | Firefly | 2 | Any area (rare) |
| 19–20 | Snake | 2 | Mountain base |

### Capture Tools

| Slot | Item |
|------|------|
| 21 | Bug net (catches butterfly, beetle, firefly) |
| 22 | Crab net |
| 23 | Frog scoop |
| 24 | Snake tongs |

### Resources (collectible nodes)

| Slot | Resource | Location |
|------|----------|----------|
| 25 | Berries (on bush) | Upper outdoor area |
| 26 | Wood / stick | Trail ground |
| 27 | Herb | Trail ground |
| 28 | Fish | Lake edge |
| 29 | Resource node — bush | Outdoor decoration + interact point |
| 30 | Resource node — tree | Outdoor |

### Furniture & Indoor Objects

| Slot(s) | Object | Room |
|---------|--------|------|
| 32–33 | Piano (16×8 — 2 wide) | Floor 1, living room |
| 34–35 | Workbench (16×8) | Floor 1 |
| 36–37 | Stove / kitchen counter (16×8) | Floor 1, kitchen |
| 38 | Display stand | Floor 1 + Bedroom |
| 39–40 | Bed (16×8) | Bedroom |
| 41 | Stairs (up indicator) | Floor 1 & 2 |

### Tiles (for future tilemap-based rooms)

| Slot | Tile |
|------|------|
| 48 | Indoor floor |
| 49 | Wall |
| 50 | Door (open) |
| 51 | Door (closed / locked) |
| 52 | Rug / floor detail |

---

## Rendering Multi-Slot Sprites

For 16×8 furniture (2 slots wide):
```lua
spr(32, piano_x, piano_y, 2, 1)  -- draws slots 32 and 33 side by side
```

For a future 8×16 player (if height is added later):
```lua
spr(1, p.x, p.y-8, 1, 2)  -- draws slots 1 and 17 stacked; feet at p.y+8
```

---

## Replacing Placeholder Circles

Once sprites are drawn, swap these lines in `game1.p8`:

| Location | Current | Replace with |
|----------|---------|--------------|
| `draw_outdoor()` | `circfill(p.x+3,p.y+4,4,9)` | `spr(1,p.x,p.y)` |
| `draw_indoor()` | `circfill(p.x+3,p.y+4,4,8)` | `spr(1,p.x,p.y)` |
| NPC draw (not built yet) | — | `spr(n.spr, n.x, n.y)` |
