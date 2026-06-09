# Round169 Flower Candidate Assets

Status: `normalized_candidate`

These files are proof-only flower and garden patch candidates produced during Round169. They are stored under the asset tree for stable preview references, but they are not wired into runtime.

## Files

- `flower_patches_192x160_sheet_v002.png`
  - Fixed-cell RGBA prefab atlas.
  - Grid: `3x2`.
  - Cell size: `192x160`.
  - Pivot per cell: `(96, 148)`.
- `flower_patches_192x160_pivot_proof_v002.png`
  - Proof-only image showing cell grid, baseline, and bottom-center pivot.
  - Do not use as runtime art.
- `flower_patches_192x160_manifest_v002.json`
  - Normalization manifest and gate result.

## Prompt Summary

Fresh same-batch AI source sheet for cozy flower and small garden patches, upper-left lighting, flat `#0000ff` chroma background, no text, no shadows, no non-flower objects.

## Gate Result

- All six patches passed fixed-cell normalization.
- Alpha channel present.
- Cell size: `192x160`.
- Edge alpha touch: `0`.
- Visible chroma-key pixels: `0`.
- Bottom-center pivot and baseline proof exported.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
