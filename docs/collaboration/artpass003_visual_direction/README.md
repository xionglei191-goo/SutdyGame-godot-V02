# ARTPASS-003 Visual Direction Manifest

> Last updated: 2026-06-07
> Scope: project-level visual direction references for Sunshine Town.

This directory is the hard visual direction gate for V02.39 and later visual work. It defines the target as an Animal Crossing-like cozy town life-sim feel, without copying any external IP.

`artpass003_main_gameplay_direction_1280.png` is the canonical gameplay style reference for the current VISUALREBUILD retarget. Future target frames, paintovers, blockouts, asset kits, and runtime proofs must translate this image into Sunshine Town's own playable screen language. It is not a runtime background, not a cut-up asset sheet, and not permission to copy external-IP-specific shapes one for one.

## Positive Direction

The target screen must read as a real playable Godot game screen:

- A warm, livable, returnable cozy town, not a lesson map or system index.
- Unified camera, light, scale, material, and shadow language across terrain, buildings, props, actors, and UI.
- Rounded toy-like 2.5D proportions with soft daylight and clear safe boundaries.
- Home-centered first screen with readable roads, doors, interaction spots, and gentle town routines.
- Animal residents, Sunny, player, A-Z props, and UI all sharing one coherent art pass.
- A-Z anchors appear as life props first; letter badges are small support only.
- Apple-like translucent glass UI: light, readable, stable touch targets, no thick course cards.

## Hard Drift Blockers

Any target frame, runtime screenshot, or asset kit must be rejected if it shows these patterns:

- Patchwork collage made from unrelated asset generations.
- Logic-map overlay where place labels, cells, letter badges, boxes, and props compete at equal priority.
- Floating item sprites on flat green ground without coherent terrain, roads, shadows, or depth.
- Mixed camera angles, mixed lighting, mixed rendering styles, or mismatched actor / building scale.
- Full-map background used as the final runtime image rather than a layerable visual system.
- Course UI, test UI, score UI, word-drill panels, big letter cards, debug labels, grid, cell, coordinate, or editor terminology.
- Concept illustration that cannot be split into Godot layers and reproduced as a playable first screen.

## Reference Files

| File | Role | Status |
|---|---|---|
| `artpass003_main_gameplay_direction_1280.png` | Canonical gameplay style reference: unified cozy town camera, rounded toy-like buildings, warm daylight, readable roads, animal-resident life-sim density, and glass HUD placement. | Canonical positive reference for retarget; not runtime asset. |
| `artpass003_glass_ui_direction_1280.png` | Positive glass UI direction reference: HUD, footer, panels, icon + short text rhythm. | Reference only, not runtime asset. |
| `artpass003_character_anchor_direction_1280.png` | Positive character / Sunny / resident / A-Z prop scale direction. | Reference only, not runtime asset. |

## Production Rule

No asset pack may start from a visual reference alone. `V02-VISUALREBUILD-004` requires a newly approved `V02-VISUALREBUILD-002` target gameplay frame that:

- Looks like a real playable game screen.
- Translates `artpass003_main_gameplay_direction_1280.png` into a Sunshine Town first screen instead of copying it.
- Can be decomposed into Godot terrain / region / building / prop / actor / shadow / glass UI layers.
- Has player, Sunny / NPC, A-Z props, prompt, HUD, and footer at final gameplay scale.
- Passes PM / Art Direction review as `art_target_locked`.
