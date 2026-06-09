# Round170 Fence Candidate Assets

Status: `normalized_candidate`

These are proof-only cozy town wooden fence segment candidates for visual layout preview. They are not runtime assets and are not mapped through `AssetResolver` or `ThemeProfile`.

## Files

- `fence_segments_64x64_sheet_v001.png`
  - Fixed-cell RGBA prefab atlas.
  - Grid: `3x2`.
  - Cell size: `64x64`.
  - Pivot per cell: `(32, 58)`.
- `fence_segments_64x64_pivot_proof_v001.png`
  - Proof-only image showing cell grid, baseline, and bottom-center pivot.
  - Do not use as runtime art.
- `fence_segments_64x64_manifest_v001.json`
  - Normalization manifest and gate result.

## Prompt Summary

Fresh AI source sheet for six cozy town warm wooden fence segment parts, upper-left lighting, flat `#00ffff` chroma background, no text, no shadows, no non-fence props.

## Gate Result

- All six segments passed fixed-cell normalization.
- Alpha channel present.
- Cell size: `64x64`; no `128x128` fallback needed for this proof set.
- Edge alpha touch: `0`.
- Visible chroma-key pixels: `0`.
- Bottom-center pivot and baseline proof exported.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
