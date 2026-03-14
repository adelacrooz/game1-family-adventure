# Pixel Art Brief — Family Adventure Game Characters

## What I Need

Four 16×16 pixel art character sprites for a PICO-8 game. They are a family: a dad, a mom, a 6-year-old boy (the player), and a toddler brother (~3 years old). They need to look like they belong to the same game and the same family, while being clearly distinguishable from each other.

---

## Hard Technical Rules

- **Canvas size:** 16×16 pixels per character, no exceptions
- **Colors:** Strictly the 16 PICO-8 colors listed below — no blending, no additional colors
- **Background pixels:** Use `#5F574F` (dark gray) — this color becomes transparent in-game
- **Outline:** Every character needs a clean 1-pixel black (`#000000`) border around the full silhouette
- **No anti-aliasing** — hard pixel edges only
- **Facing direction:** All sprites face right

---

## The PICO-8 Palette (these 16 colors only)

| # | Hex | Name | Used for |
|---|-----|------|----------|
| 0 | `#000000` | Black | Outlines, eye gaps |
| 1 | `#1D2B53` | Dark Blue | Hair/cap on ALL characters |
| 2 | `#7E2553` | Dark Purple | Shoes (all), Mom's jacket |
| 3 | `#008751` | Dark Green | Unused in characters |
| 4 | `#AB5236` | Brown | Ear detail, Dad's pants |
| 5 | `#5F574F` | Dark Gray | Background (transparent in-game) |
| 6 | `#C2C2C2` | Light Gray | Dad's glasses, Player's legs |
| 7 | `#FFF1E8` | Cream | Accent highlight if needed |
| 8 | `#FF004D` | Red | Unused in characters |
| 9 | `#FFA300` | Orange | Unused in characters |
| 10 | `#FFEC27` | Yellow | Unused in characters |
| 11 | `#00E436` | Light Green | Brother's shirt |
| 12 | `#29ADFF` | Blue | Player's shirt, Dad's jacket |
| 13 | `#83769C` | Lavender | Mom's skirt/legs |
| 14 | `#FF77A8` | Pink | Chin accent (all characters) |
| 15 | `#FFCCAA` | Peach | Skin (all characters) |

---

## Age Differentiation — The Most Important Rule

All four characters are 16×16 pixels. **Age reads through head-to-body ratio, not size.** Bigger head = younger character. This is the primary signal — everything else is secondary.

```
BABY BROTHER    PLAYER (6yo)    MOM / DAD
┌────────────┐  ┌────────────┐  ┌────────────┐
│ ██████████ │  │ ██████████ │  │  ████████  │
│ ██ face ██ │  │ ██ face ██ │  │  ██face██  │
│ ██ face ██ │  │ ██ face ██ │  │  ████████  │
│ ██ face ██ │  │ ██ face ██ │  │   neck     │
│ ██ face ██ │  │ ██ face ██ │  │   neck     │
│ ██ face ██ │  │ ██ chin ██ │  │  ████████  │ ← torso starts here
│ ██ face ██ │  │   neck     │  │  ████████  │   (much lower on adults)
│ ██ face ██ │  │ ████████   │  │  ████████  │
│ ██ chin ██ │  │ ████████   │  │  ████████  │
│  [no neck] │  │ ████████   │  │  ████████  │
│  [body]    │  │  legs      │  │  legs      │
│  [legs]    │  │  shoes     │  │  legs      │
│  [shoes]   │  │            │  │  shoes     │
└────────────┘  └────────────┘  └────────────┘
Head: ~10 rows   Head: ~8 rows   Head: ~6 rows
Body: ~6 rows    Body: ~8 rows   Body: ~10 rows
```

| Region | Baby Brother | Player (6yo) | Mom & Dad |
|--------|-------------|--------------|-----------|
| Head (dark blue fill) | 10 rows (63%) | 8 rows (50%) | 6 rows (37%) |
| Neck | none | 1 row | 2 rows |
| Torso | 2 rows | 3 rows | 5 rows |
| Legs | 1 row | 1 row | 2 rows |
| Shoes | 1 row | 1 row | 1 row |
| Top margin | 1–2 rows | 1 row | 0 rows |

**Head width stays ~10px for all characters.** Don't shrink the head sideways to show age — only shrink it vertically.

---

## Shared Visual Grammar (same on all four characters)

These must match to make them look like the same family and same art style:

- **Hair color:** `#1D2B53` (dark blue) on all four — don't use black for hair
- **Skin:** `#FFCCAA` (peach) on all four — face, neck, arms
- **Eyes:** Two black (`#000000`) gaps/holes in the skin-colored face — do NOT draw filled pupils or irises, just two empty holes
- **Ear/jaw accent:** 1–2 pixel spot of `#AB5236` (brown) on the LEFT side of the face at eye level
- **Chin accent:** `#FF77A8` (pink) at the two lower corners where the face meets the outline
- **Shoes:** `#7E2553` (dark purple) on all four

---

## Character 1 — Player (6-year-old boy)

The protagonist. Simple, plain kid.

**Hair:** Bowl cut — rounded dome of `#1D2B53` (dark blue), with a strip of bangs coming slightly forward and down over the forehead. Not spiky. Flat on sides, round on top.

**Clothing:**
- Shirt: `#29ADFF` (blue)
- Arms: peach skin flanking shirt
- Legs: `#C2C2C2` (light gray), 1 row
- Shoes: `#7E2553` (dark purple)

**No accessories.** Plain kid.

---

## Character 2 — Baby Brother (~3 years old)

Younger than the player. Toddler proportions — almost all head.

**Hair:** Dark blue (`#1D2B53`) rounded dome, even rounder and taller than the player's. Nearly fills the top 10 rows. Very simple round cap shape.

**Key feature:** No visible neck — the head connects directly to the tiny body. This is the #1 age signal for this character.

**Eyes:** Two black holes, placed slightly further apart than the other characters to reinforce the baby/toddler look.

**Clothing:**
- Shirt: `#00E436` (light green)
- Arms: very short, stubby peach stubs flanking shirt
- Legs: `#C2C2C2` (light gray), 1 row
- Shoes: `#7E2553` (dark purple)

**Feel:** Almost comically large head, tiny body. Full chibi baby proportions.

---

## Character 3 — Dad

Adult. Wears a baseball cap, rectangular glasses, and a denim jacket.

**Hair/Cap:** The dark blue fill (`#1D2B53`) represents BOTH the cap AND hair underneath — they read as one shape. Add a subtle hint of a brim: 1–2 pixels of dark blue extending slightly past the black outline at the forehead row, as if the cap brim sticks out slightly.

**Glasses:** At the eye row(s), add `#C2C2C2` (light gray) rectangular frames flanking the face — one lens on each side. Inside each lens, use a black (`#000000`) pixel for the eye. The skin (`#FFCCAA`) bridge connects them at the nose.

**Clothing:**
- Jacket: `#29ADFF` (blue/denim) — wider shoulders than the kids
- Arms: peach skin flanking jacket
- Pants: `#AB5236` (brown), 2 rows
- Shoes: `#7E2553` (dark purple)

**Build:** Widest torso. Shoulders fill the full 16px canvas width.

---

## Character 4 — Mom

Adult. Long straight black hair with straight-cut bangs. Darker jacket.

**Hair — this is her defining feature:**
- **Bangs:** A solid straight horizontal strip of `#1D2B53` (dark blue) across the FULL WIDTH of the forehead — rows 1–2 are all dark blue
- **Sides:** Dark blue continues down BOTH sides of the face past the chin, and continues flanking the neck rows too. The face skin is only visible in the center — the hair frames it on both sides all the way from the forehead to the torso
- This is what distinguishes her silhouette from Dad's — her hair goes DOWN the sides while his cap stays at the top

**Clothing:**
- Jacket: `#7E2553` (dark purple) — darker than Dad's jacket
- Arms: peach skin flanking jacket
- Skirt/lower body: `#83769C` (lavender)
- Shoes: `#7E2553` (dark purple)

---

## Inspiration from Other Games

These games solved similar problems — worth studying before drawing:

### Stardew Valley
The most direct reference. NPCs like Jas (child), Penny, Harvey, and Robin show clear age differences at small sprite sizes using exactly this head-to-body ratio approach. Notice how Jas and Vincent (the kids) have dramatically larger heads relative to their bodies compared to the adult villagers. The art style uses a similar limited palette with strong outlines. Search: "Stardew Valley NPC sprites."

### EarthBound / Mother 2 (SNES)
Ness (the kid protagonist) vs. the adult NPCs. At 16×24 or so, the proportions still follow the same rule — kid heads are massive. Also a good reference for how to make a family of characters using a consistent limited palette while making each one instantly readable. Search: "EarthBound overworld sprites."

### Pokémon Gold/Silver (Game Boy Color)
Trainer sprites in the Pokémon games show age (youngster vs. ace trainer vs. elder) primarily through silhouette and head size. The palette is even more restricted than PICO-8. Good examples of how a single strong silhouette shape communicates character at tiny sizes. Search: "Pokemon GSC trainer sprites."

### Cave Story
Quote and other characters are small, simple, and read instantly from a distance. The eyes-as-dark-holes technique (no irises, just black gaps) is exactly what this project uses. Good reference for how minimal a face can be while still feeling expressive. Search: "Cave Story character sprites."

### Celeste (Classic / PICO-8 version)
Originally made in PICO-8 at this exact pixel scale with this exact palette. Madeline is 8×8 but the style carries over. Good reference for how PICO-8's specific colors look at pixel scale and how much personality you can pack into very small sprites. Search: "Celeste PICO-8 original sprites."

---

## Quick Reference Card

```
ALL CHARACTERS SHARE:
  Hair:    #1D2B53  (dark blue)
  Skin:    #FFCCAA  (peach)
  Eyes:    #000000  (black holes, no pupils)
  Ear:     #AB5236  (brown, left side, 1-2px)
  Chin:    #FF77A8  (pink corners)
  Shoes:   #7E2553  (dark purple)
  BG:      #5F574F  (dark gray = transparent)
  Outline: #000000  (black, 1px perimeter)

PER CHARACTER:
  Baby Brother:  shirt #00E436  no neck  biggest head
  Player (6yo):  shirt #29ADFF  1 neck row
  Dad:           jacket #29ADFF  glasses #C2C2C2  pants #AB5236
  Mom:           jacket #7E2553  skirt #83769C  hair down sides
```
