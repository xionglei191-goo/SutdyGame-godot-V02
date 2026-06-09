# Round169 Fence Candidate Assets

Status: `normalized_candidate`

These files are proof-only wooden fence segment candidates produced during Round169. They are stored under the asset tree for stable preview references, but they are not wired into runtime.

## Files

- `fence_segments_256x128_sheet_v002.png`
  - Fixed-cell RGBA prefab atlas.
  - Grid: `3x2`.
  - Cell size: `256x128`.
  - Pivot per cell: `(128, 118)`.
- `fence_segments_256x128_pivot_proof_v002.png`
  - Proof-only image showing cell grid, baseline, and bottom-center pivot.
  - Do not use as runtime art.
- `fence_segments_256x128_manifest_v002.json`
  - Normalization manifest and gate result.

## Prompt Summary

Fresh same-batch AI source sheet for warm wooden cozy-town fence segments, upper-left lighting, flat `#00ffff` chroma background, no text, no shadows, no non-fence objects.

## Gate Result

- All six segments passed fixed-cell normalization.
- Alpha channel present.
- Cell size: `256x128`.
- Edge alpha touch: `0`.
- Visible chroma-key pixels: `0`.
- Bottom-center pivot and baseline proof exported.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
