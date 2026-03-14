# Character Sprite Design Plan — 16×16 Family Characters

## Status
Sprites handed off to Nana Banana for redraw. See `nana-banana-brief.md` for the full external brief.

---

## Context

The first attempt at mom/dad 16×16 sprites used generic adult proportions without anchoring to the specific visual grammar of this game's 16×16 player sprite. The result looked like it came from a different game. This plan defines a reference-first process to redesign them so they feel like the same family.

**Character scope (updated):** Four characters — Mom, Dad, Player (6yo), and Baby Brother (~3yo, added after initial plan).

**Which sprite system:** The 16×16 sprite is the one system used for all indoor and outdoor2 scenes. The 8×8 outdoor sprites are a separate set for the outdoor platformer scene only. Mom, Dad, and Baby Brother are indoor NPCs, so they must match the 16×16 player idle (slots 16–17 + 32–33) as the visual reference.

---

## Root Cause: What Went Wrong (First Attempt)

1. **Used generic adult proportions** (standard smaller-head realistic body) instead of deriving adults from the specific conventions of this game's existing sprite.
2. **Wrong head structure.** The 16×16 player uses an 8-row head (50% of height). The first adult sprites used a 5-row head (31%) — too small. Adults should be ~6 rows (~37%).
3. **Wrong density and width.** The player sprite uses full 16px width; the parent sprites were narrow/centered with too much dark gray padding.
4. **Didn't carry forward the visual grammar** — dark blue (1) head fill, brown (4) ear detail, pink (14) chin accent — these specific cues are what make the style cohesive.

---

## The 16×16 Player Visual Grammar (ground truth)

Extracted from the actual GFX data of the idle pose (slots 16+17 top, 32+33 bottom):

```
Row  0: _ _ _ _ _ . . . . . . . _ _ _ _   (empty top — 5 bg)
Row  1: _ _ _ _ . 1 1 1 1 1 1 1 . _ _ _   (head top, 7px wide — dark blue fill)
Row  2: _ _ _ . 1 1 1 1 1 1 1 1 1 . _ _   (head, 9px wide)
Row  3: _ _ . 1 1 1 1 1 1 1 1 1 1 . _ _   (head, 10px wide — widest)
Row  4: _ _ . 1 1 1 1 1 1 1 1 1 1 . _ _   (head, 10px)
Row  5: _ _ . 1 1 f f 1 1 1 1 1 1 . _ _   (face top — 2px peach appear)
Row  6: _ _ . 4 f f . f f f f . f . _ _   (eyes: black gaps; 4=brown ear)
Row  7: _ _ . 4 f f . f f f f . f . _ _   (eyes: same row repeated)
Row  8: _ _ _ . e f f f f f f f e . _ _   (chin — pink/14 corners)
Row  9: _ _ _ _ . f f f f f f f . _ _ _   (neck, 7px wide, peach)
Row 10: _ _ _ . d d d d d d d d d . _ _   (shirt top — lavender, 9px)
Row 11: _ _ . f d d d d d d d d d f . _   (arms out, peach sides)
Row 12: _ _ . f f d d d d d d d f f . _   (body)
Row 13: _ _ _ . . 6 6 6 6 6 6 6 . . _ _  (legs — light gray)
Row 14: _ _ _ _ . 2 . . . . . 2 . _ _ _  (shoes — dark purple)
Row 15: _ _ _ _ . . _ _ _ _ _ . . _ _ _  (bottom margin)

Legend:
  _ = dark gray bg (5, transparent in-game)
  . = black outline (0)
  1 = dark blue (hair)
  4 = brown (ear detail)
  6 = light gray (legs)
  f = peach/15 (skin)
  e = pink/14 (chin accent)
  d = lavender/13 (shirt)
  2 = dark purple (shoes)
```

**Structural measurements:**

| Region | Rows | % of 16 |
|--------|------|---------|
| Top margin | 1 row (0) | 6% |
| Head (dark blue fill) | 8 rows (1–8) | 50% |
| Neck | 1 row (9) | 6% |
| Torso/shirt | 3 rows (10–12) | 19% |
| Legs | 1 row (13) | 6% |
| Shoes | 1 row (14) | 6% |
| Bottom margin | 1 row (15) | 6% |

**Head width at widest:** 10px — fills most of the 16px canvas.

---

## Proportion System — All Four Characters

| Region | Baby Brother | Player (6yo) | Mom & Dad |
|--------|-------------|--------------|-----------|
| Head (dark blue fill) | ~10 rows (63%) | 8 rows (50%) | 6 rows (37%) |
| Neck | 0 rows | 1 row | 2 rows |
| Torso | 2 rows | 3 rows | 5 rows |
| Legs | 1 row | 1 row | 2 rows |
| Shoes | 1 row | 1 row | 1 row |
| Top margin | 1–2 rows | 1 row | 0 rows |

**Key rule:** Head width stays ~10px for all characters. Age reads through vertical row count only — do not narrow the head to signal youth.

---

## Visual Grammar — Carry These Across All Characters

| Element | Color | Notes |
|---------|-------|-------|
| Hair | Dark blue (1) `#1D2B53` | Signals "same family" |
| Skin | Peach (15) `#FFCCAA` | Face, neck, arms |
| Eyes | Black (0) `#000000` | Two gap holes — no irises |
| Ear/jaw detail | Brown (4) `#AB5236` | 1–2px on LEFT side at eye level |
| Chin accent | Pink (14) `#FF77A8` | Two corners where face meets outline |
| Shoes | Dark purple (2) `#7E2553` | All four characters |
| Outline | Black (0) `#000000` | 1px clean perimeter |
| Background | Dark gray (5) `#5F574F` | Transparent in-game |

---

## Per-Character Distinguishing Features

### Player (6yo)
- Bowl cut with bangs
- Blue shirt `#29ADFF` (12)
- Light gray legs `#C2C2C2` (6)

### Baby Brother (~3yo)
- Rounder dome of hair than player, even taller
- No visible neck (head connects directly to body)
- Light green shirt `#00E436` (11)
- Eyes slightly further apart

### Dad
- Baseball cap shape (flat-top dark blue with 1–2px brim hint)
- Glasses: light gray `#C2C2C2` (6) frames at eye level, black eye inside each lens
- Denim blue jacket `#29ADFF` (12), widest shoulders of all characters
- Brown pants `#AB5236` (4)

### Mom
- Straight bangs: full-width solid strip of dark blue across entire forehead
- Hair extends down BOTH sides of face and continues flanking the neck rows
- Dark purple jacket `#7E2553` (2)
- Lavender skirt/lower body `#83769C` (13)

---

## Sprite Sheet Positions

| Character | x | y | PICO-8 slots |
|-----------|---|---|--------------|
| Player (idle) | 0–15 | 64–79 | 16–17 (top) + 32–33 (bottom) |
| Dad | 0–15 | 80–95 | TBD after redraw |
| Mom | 0–15 | 96–111 | TBD after redraw |
| Baby Brother | TBD | TBD | TBD |

---

## Verification Checklist

- [ ] Baby Brother has the biggest head-to-body ratio
- [ ] Player has second-biggest head (8/16 rows)
- [ ] Mom and Dad have noticeably smaller heads with longer torsos
- [ ] All four use `#1D2B53` for hair/cap
- [ ] All four use `#FFCCAA` for skin
- [ ] All four have black outline
- [ ] Each character has a distinct shirt/clothing color
- [ ] Mom's hair extends down into the neck area
- [ ] Dad has visible gray glasses frames
- [ ] No code changes until sprites are finalized
