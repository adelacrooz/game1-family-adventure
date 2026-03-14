# 8×8 Character Art Guide

Guidance for drawing the outdoor platformer versions of the four characters. These are separate from the 16×16 indoor sprites — see `character-sprite-design-plan.md` for that system.

---

## Character Sizes

All characters use the same **8×8** base slot. Age reads through design, not size.

| Character | Sprite call | Slots per pose |
|-----------|-------------|---------------|
| Player (6-year-old) | `spr(n, x, y, 1, 1)` | 1 |
| Brother (younger) | `spr(n, x, y, 1, 1)` | 1 |
| Dad | `spr(n, x, y, 1, 1)` | 1 |
| Mom | `spr(n, x, y, 1, 1)` | 1 |

With 2 walk frames each, all four characters total **8 slots**.

> **Alternative considered:** Using 8×16 for the player, 8×24 for parents to show height differences. Kept at 8×8 to simplify art and keep indoor top-down perspective consistent. Can revisit.

---

## Showing Age Difference at 8×8

Pick **two strong signals per character** — don't try to add all of them.

### Head-to-body ratio
The single biggest age signal. At 8×8, you control this by how many rows you allocate to the head vs the body.

```
Brother     Player      Dad/Mom
########    ########    ########
# OO  #     # OO  #    ##    ##
########    ########    # OO  #
##  ####    ## ####     ########
########    ########    ## ## ##
########    ## ## ##    ########
```
- **Brother:** head fills ~4 rows, very short neck, round body
- **Player:** head fills ~3 rows, slightly defined neck/shoulders
- **Parents:** head fills ~2 rows, visible shoulders, longer torso

### Hair shape
Hair silhouette reads faster than any other detail at small sizes.

| Character | Suggestion |
|-----------|-----------|
| Player | Short with a cowlick or front tuft |
| Brother | Very round head, minimal or no visible neck |
| Dad | Short/flat-top, or a hat to signal role (apron works too) |
| Mom | Hair that extends the silhouette — bun, ponytail, or shoulder-length |

### Color palette
Give each character a **distinct dominant color** for their shirt/clothing. Since characters appear next to each other indoors, contrast between them matters more than each one reading perfectly alone.

Suggested shirt colors (avoid repeating):
- Player: blue (col 12)
- Brother: green (col 11)
- Dad: red (col 8) or orange (col 9)
- Mom: pink (col 14) or peach (col 15)

### Other signals
- **Posture:** Kids are squatter with arms close to body; adults have visible arm separation
- **Accessories:** Apron on dad (kitchen), hair detail on mom; the player and brother are plain
- **Expression:** Even at 8×8, 2–3 pixels of eyebrow angle can suggest personality
