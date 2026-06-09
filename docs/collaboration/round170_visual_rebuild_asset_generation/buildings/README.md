# Round170 Worker D Building Prefab Candidate Report

Date: 2026-06-08

Status: `normalized_candidate`

Scope: Worker D generated a small proof-only cozy building prefab candidate set. Writes were limited to:

- `assets/art/visual_rebuild/round170/buildings/`
- `docs/collaboration/round170_visual_rebuild_asset_generation/buildings/`

No runtime mappings, `AssetResolver`, `ThemeProfile`, data, tests, shared ledgers, or Godot scenes were changed.

## Prompt

Text-to-image fallback command:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "<prompt>" "docs/collaboration/round170_visual_rebuild_asset_generation/buildings/raw/round170_building_prefabs_ai_raw_sheet_v001.png" 1024x1024
```

Prompt:

```text
Use case: stylized-concept. Asset type: proof-only Godot cozy town building prefab candidate sheet. Create a clean 2 columns by 2 rows sprite sheet of four separate cozy cottage / small town building prefabs for a warm Animal Crossing-like mobile life RPG for children. Orthographic 3/4 top-down game asset view, soft rounded stylized 3D clay-painterly look, chunky readable silhouettes, consistent camera angle and scale, warm upper-left daylight baked into the object only. Each cell contains exactly one isolated full building prefab centered with generous padding and a clear bottom baseline: 1 small cozy home cottage with red roof and cream walls, 2 tiny shop cottage with green awning and wooden sign shape but no text, 3 garden cottage with blue roof and flower boxes, 4 small community cottage with warm yellow roof and round window. Perfectly flat solid #ff00ff chroma-key magenta background, uniform with no gradients, no floor plane, no texture, no cast shadow, no contact shadow, no reflection. Do not use magenta in the building art. No text, labels, numbers, UI, characters, animals, paths, fences, separate trees, watermarks, or extra loose props.
```

## Files

- `raw/round170_building_prefabs_ai_raw_sheet_v001.png`
  - Controlled AI source sheet, RGB, `1024x1024`, intended `2x2` layout, flat `#ff00ff` chroma-key background.
- `round170_building_prefabs_ai_raw_sheet_v001_chroma_alpha.png`
  - Chroma-key alpha conversion of the raw source.
- `normalized_320x320/building_prefab_01_320x320.png` through `building_prefab_04_320x320.png`
  - Individual normalized transparent cells.
- `round170_building_prefabs_320x320_atlas_v001.png`
  - Fixed-cell transparent RGBA atlas, `2x2`, `640x640`, cell size `320x320`.
- `round170_building_prefabs_320x320_pivot_proof_v001.png`
  - Proof image with cell grid, baseline, and bottom-center pivot markers.
- `round170_building_prefabs_320x320_manifest_v001.json`
  - Numeric crop, alpha, component, edge, and gate report.
- `normalize_round170_buildings.py`
  - Repeatable local normalization and audit script.

Asset-tree copies:

- `assets/art/visual_rebuild/round170/buildings/building_prefabs_320x320_atlas_v001.png`
- `assets/art/visual_rebuild/round170/buildings/building_prefabs_320x320_pivot_proof_v001.png`
- `assets/art/visual_rebuild/round170/buildings/building_prefabs_320x320_manifest_v001.json`
- `assets/art/visual_rebuild/round170/buildings/README.md`

## Cell Size Decision

Chosen cell size: `320x320`.

Reason: these are full building prefabs, not small props or modular home parts. `256x256` and `320x256` risk squeezing roofs, chimneys, doors, and shop awnings into a cramped vertical read. `320x320` preserves a stable bottom pivot and enough top margin for cottage silhouettes while remaining compact for proof-only Godot layout preview.

Recommended proof display scale: start at `0.50x` to `0.60x` in a `1280x720` target frame, using bottom-center pivot `(160, 302)` and a visual footprint around `2x2` to `3x2` logical cells depending on depth band.

## Gate Result

Validation command:

```bash
python3 docs/collaboration/round170_visual_rebuild_asset_generation/buildings/normalize_round170_buildings.py
python3 -m py_compile docs/collaboration/round170_visual_rebuild_asset_generation/buildings/normalize_round170_buildings.py
```

Result: `pass`

- Total items: `4`
- Passing items: `4`
- Cell size: `320x320`
- Pivot: `(160, 302)`
- Atlas mode and size: RGBA `640x640`
- Raw source mode and size: RGB `1024x1024`
- Visible chroma-key pixels per item: `0`
- Edge alpha touch per item: `0`
- Connected components per item: `1`

Numeric fit summary:

| Cell | Status | Placed BBox | Margins L/T/R/B | Visible Key | Edge Touch | Scale |
|---|---|---|---|---:|---|---:|
| 1 | pass | `[24, 20, 297, 302]` | `24/20/23/18` | 0 | `0/0/0/0` | 0.6698 |
| 2 | pass | `[17, 51, 303, 302]` | `17/51/17/18` | 0 | `0/0/0/0` | 0.6485 |
| 3 | pass | `[17, 48, 303, 302]` | `17/48/17/18` | 0 | `0/0/0/0` | 0.6413 |
| 4 | pass | `[17, 37, 303, 302]` | `17/37/17/18` | 0 | `0/0/0/0` | 0.6272 |

## Runtime Boundary

These files are proof-only layout candidates. They are not `art_target_locked`, not `runtime_visual_match`, and not final approved.

Do not map these files into `AssetResolver`, `ThemeProfile`, logical asset registration, data contracts, or live Godot scenes until a later visual-layout gate explicitly approves them.

## Risks

- AI-generated architectural details need art-direction review for style consistency before production use.
- The shop candidate includes an empty sign shape and awning; production should confirm whether signs become separate localized prop layers.
- The buildings are full prefabs, so occlusion, collision, and hidden-grid footprints still need a later layout contract.
- Chroma-key cleanup passed numeric checks and a proof sanity review, but final production should still receive close visual inspection at in-game scale.
