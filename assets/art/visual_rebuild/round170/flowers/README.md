# Round170 Flower / Grass Candidate Assets

Status: `normalized_candidate`

Proof-only compact flower and grass prop candidates for Godot visual layout preview. These files are stored under the asset tree for stable reference, but they are not wired into runtime.

## Files

- `flowers_grass_props_64x64_atlas_v001.png`
  - Fixed-cell transparent RGBA atlas.
  - Grid: `4x2`.
  - Cell size: `64x64`.
  - Pivot per cell: `(32, 58)`.
- `flowers_grass_props_64x64_pivot_proof_v001.png`
  - Proof-only image showing cell grid, baseline, and bottom-center pivot.
  - Do not use as runtime art.
- `flowers_grass_props_64x64_manifest_v001.json`
  - Normalization manifest and gate result.

## Source

Raw generation, normalization script, alpha source, individual cells, and full report live in:

`docs/collaboration/round170_visual_rebuild_asset_generation/flowers/`

## Gate Result

- All eight props passed fixed-cell normalization.
- Alpha channel present.
- Cell size: `64x64`.
- Edge alpha touch: `0`.
- Visible chroma-key pixels: `0`.
- Bottom-center pivot and baseline proof exported.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
