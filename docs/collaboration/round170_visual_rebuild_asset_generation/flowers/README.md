# Round170 Worker C Flower / Grass Prop Candidates

Status: `normalized_candidate`

This folder contains a proof-only flower and small grass prop candidate set for visual layout preview. It follows the Round169 raw-sheet -> chroma-alpha -> normalized atlas -> pivot proof -> manifest pattern, but targets compact `64x64` cells.

## Prompt

Text-to-image fallback command:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "Cozy town game prop sprite sheet, 8 separate small flower patches and grass tufts for a warm Animal Crossing-like mobile life RPG for children. Arrange as a clean 4 columns by 2 rows grid on a perfectly flat solid #0000ff chroma-key background. Each cell contains exactly one isolated low garden prop: tiny pink flower clump, yellow daisy patch, white wildflower patch, purple flower patch, short grass tuft, taller grass tuft, mixed meadow sprig, tiny leafy ground cover. Soft rounded stylized 3D clay/painterly look, upper-left warm daylight, consistent scale, crisp silhouette, no cast shadow, no contact shadow, no soil tile, no pots, no characters, no animals, no signs, no text, no watermark, no gradients, no texture in the blue background, generous padding around every prop, do not use blue in the props." docs/collaboration/round170_visual_rebuild_asset_generation/flowers/raw/round170_flowers_grass_ai_raw_sheet_v001.png 1024x1024
```

## Files

- `raw/round170_flowers_grass_ai_raw_sheet_v001.png`
  - Controlled AI source sheet, RGB, `1024x1024`, `4x2` intended layout, flat `#0000ff` chroma-key background.
- `round170_flowers_grass_ai_raw_sheet_v001_chroma_alpha.png`
  - Chroma-key alpha conversion of the raw source.
- `normalized_64x64/flower_grass_patch_01_64x64.png` through `flower_grass_patch_08_64x64.png`
  - Individual normalized transparent cells.
- `round170_flowers_grass_props_64x64_atlas_v001.png`
  - Fixed-cell transparent RGBA atlas, `4x2`, `256x128`, cell size `64x64`.
- `round170_flowers_grass_props_64x64_pivot_proof_v001.png`
  - Proof image with cell grid, baseline, and bottom-center pivot markers.
- `round170_flowers_grass_props_64x64_manifest_v001.json`
  - Numeric crop, alpha, component, edge, and gate report.
- `normalize_round170_flowers.py`
  - Repeatable local normalization and audit script.

Asset-tree copies:

- `assets/art/visual_rebuild/round170/flowers/flowers_grass_props_64x64_atlas_v001.png`
- `assets/art/visual_rebuild/round170/flowers/flowers_grass_props_64x64_pivot_proof_v001.png`
- `assets/art/visual_rebuild/round170/flowers/flowers_grass_props_64x64_manifest_v001.json`

## Gate Result

Validation command:

```bash
python3 docs/collaboration/round170_visual_rebuild_asset_generation/flowers/normalize_round170_flowers.py
```

Result: `pass`

- Total items: `8`
- Passing items: `8`
- Cell size: `64x64`
- Pivot: `(32, 58)`
- Atlas alpha: present
- Atlas visible chroma-key pixels: `0`
- Atlas edge alpha touch: `0`

## Runtime Boundary

These assets are proof-only. No runtime mapping, `AssetResolver`, `ThemeProfile`, logical asset registration, data contract, or Godot scene changes were made.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.

## Risks

- AI sheet contents still need art-direction review for species/readability before any production use.
- `64x64` cells are useful for dense layout proofing, but may be too small for final town prop readability.
- Chroma-key cleanup passed numeric checks, but visual review should still inspect the atlas before reuse.
