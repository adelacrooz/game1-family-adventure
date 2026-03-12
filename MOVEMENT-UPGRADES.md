# Movement Upgrade System — Feature Reference

Branch: `claude/movement-upgrade-challenges-5JkWU`

This document captures the design rationale, plan, and implementation details for the movement upgrade gating system added to the outdoor platformer.

---

## Why This Exists

All movement abilities (sprint, dash, wall jump) were available from frame one. The goal was to gate each behind a natural in-world challenge, creating a Metroidvania-style progression arc where the outdoor map opens up as the player earns new abilities — and where the challenge itself *teaches* the mechanic before the player ever needs it in the wild.

---

## Upgrade Progression Arc

```
START: walk + jump only

[Trail, x≈150]    → beat race NPC      → SPRINT unlocked
                    (hurdle mid-race teaches sprint+jump)
                    (washed-out gap after finish requires sprint+jump)

[Trail, x≈680]    → rescue beetle      → DASH unlocked
                    (air dash + double-tap ground dash)

[Pit, x=620–692]  → rescue frog        → WALL JUMP unlocked
                    (pit walls are the only escape)

[Mountain, x≈820] → help snake (opt.)  → SLIDE DASH unlocked
```

Full outdoor traversal (high platforms, pit escape, far reaches) only becomes possible once all upgrades are earned.

---

## Upgrade 1 — Sprint (Trail Race)

### Design

A neighborhood kid NPC stands at x≈150 on the trail. Pressing O opens a race dialogue; the kid runs toward the finish line at x=480. The player wins only by holding X to sprint — natural discovery of the mechanic under pressure.

**Teaching sequence built into the race:**
1. Player learns X = sprint trying to keep up with the NPC
2. A log hurdle at x=386 (near the end of the race) forces the player to jump while sprinting — their first sprint+jump rep
3. After winning, the kid's dialogue mentions the washed-out trail ahead
4. The sprint upgrade flash fires when the win dialogue closes
5. The player walks right and immediately faces a 67 px ditch — sprint+jump required; a red music note bobs visibly on the other side as incentive

### NPC States

| State | Trigger | Dialogue |
|-------|---------|---------|
| `idle` | Default | "hey miles! race me / to the big tree! / first one there wins!" |
| `ready` | O pressed → 45-frame countdown | *(countdown display: 3 / 2 / 1 / go!)* |
| `racing` | Countdown done | NPC moves at 2.4 px/frame toward x=480 |
| `loss` | NPC reaches x=480 first | "so close, miles! / hold x to run / faster. try again?" |
| `win` | Player reaches x=480 first | "nice one, miles! / hey, the trail's / washed out up ahead. / bet you can jump it!" |

On `win` dialogue close → `upgrades.run = true`, `dset(40, 1)`, upgrade flash shown.
NPC hidden once `upgrades.run` is true.

### Washed-Out Trail Gap

| Property | Value |
|----------|-------|
| Location | x=530–597 (67 px wide) |
| Depth | 20 px (ditch floor at y=140; player can jump back out) |
| Visual | Brown dirt ditch; caution sign `!` at left edge |
| Incentive | Red music note at x=606, y=108 (visible from left side) |
| Ground split | `{0,120,530,16}` + `{597,120,23,16}` + `{530,140,67,8}` |

### Race Hurdle

| Property | Value |
|----------|-------|
| Location | x=386, y=112 (8×8 px solid platform) |
| Visual | Brown log drawn over the platform |
| Purpose | Forces a sprint+jump during the race itself |
| NPC behavior | NPC circle passes through visually (no NPC collision) |

---

## Upgrade 2 — Dash (Beetle Rescue)

### Design

A beetle is pinned under a fallen log at x≈680, before rescue state. Approaching and pressing O triggers a rescue interaction. The beetle demonstrates its roll-dash and the player mimics it — `upgrades.dash = true`.

**What unlocks:** air dash (O while airborne) + double-tap ground dash.

| dset | Key | Value |
|------|-----|-------|
| 41 | `upgrades.dash` | 1 when unlocked |
| 44 | `beetle_rescued` | 1 after rescue |

After rescue, beetle spawns normally as a catchable critter in its zone.

---

## Upgrade 3 — Wall Jump (Frog Pit Rescue)

### Design

The frog's pre-rescue spawn is moved to the pit floor (x=655, y=372). The player spots the frog calling from below (or falls in accidentally). The pit walls are the only escape — the geometry forces the player to attempt wall jumps. The frog provides a hint: *"Jump toward the wall, then push off the other way!"*

On first successful escape: `upgrades.wall_jump = true`, frog follows out to its normal outdoor zone and becomes catchable.

**What unlocks:** wall jump (O near wall while airborne) + wall slide (passive, always-on feel).

| dset | Key | Value |
|------|-----|-------|
| 42 | `upgrades.wall_jump` | 1 when unlocked |
| 45 | `frog_rescued` | 1 after rescue |

---

## Upgrade 4 — Slide Dash / Optional

Snake at the mountain base (x≈820) is tangled in vines. Player brings an herb → snake demonstrates slithering under a low obstacle → `upgrades.slide = true`.

This upgrade is scoped as optional — the core arc works without it. Can be cut if token budget is tight.

| dset | Key | Value |
|------|-----|-------|
| 43 | `upgrades.slide` | 1 when unlocked (reserved) |

---

## Gating — Where Each Mechanic Is Blocked

All gates are in `update_outdoor()`:

| Mechanic | Gate condition | Code location |
|----------|---------------|--------------|
| Sprint (`p.air_sprint`) | `upgrades.run` or `race_npc.state=="racing"` | line ~966 |
| Air dash (O while airborne) | `upgrades.dash` | line ~1035 |
| Double-tap ground dash | `upgrades.dash` | line ~1012 |
| Slide dash (down+O) | `upgrades.dash` | line ~1012 |
| Wall jump (O near wall) | `upgrades.wall_jump` | line ~1025 |

Walk, jump, coyote frames, jump buffer, gravity — **always available from the start.**

---

## `dset` Slots Used by This Feature

| Slot | Key | Notes |
|------|-----|-------|
| 40 | `upgrades.run` | Sprint |
| 41 | `upgrades.dash` | Dash |
| 42 | `upgrades.wall_jump` | Wall jump |
| 43 | `upgrades.slide` | Slide dash (reserved) |
| 44 | `beetle_rescued` | Beetle pre-rescue state |
| 45 | `frog_rescued` | Frog pre-rescue state |

---

## Files Changed

- `game1.p8` — all implementation (single-cart project)

Key areas modified:
- `platforms` array: ground split for trail gap, ditch floor, hurdle platform
- `draw_world_bg()`: hurdle log visual, ditch visual, caution sign
- `get_dlg()`: racer win/loss/idle branches; pit frog hint; beetle rescue text
- `on_dlg_close()`: racer win → grant upgrade; beetle/frog → unlock + dset
- `update_outdoor()`: race win condition now triggers dialogue before upgrade
- `note_defs`: red note slot 7 moved from x=500 to x=606 (past the gap)
- `PROGRESS.md`: "What's Built" table + dset slot map updated
