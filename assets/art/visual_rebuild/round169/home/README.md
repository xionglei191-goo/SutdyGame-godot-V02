# Round169 Home Candidate Assets

Status: `normalized_candidate`

These files are proof-only home component candidates produced during Round169. They are stored under the asset tree for stable preview references, but they are not wired into runtime.

## Files

- `home_components_320x256_sheet_v002.png`
  - Fixed-cell RGBA component atlas.
  - Grid: `3x3`.
  - Cell size: `320x256`.
  - Default pivot per cell: `(160, 238)`.
- `home_components_320x256_pivot_proof_v002.png`
  - Proof-only image showing cell grid, baseline, and default bottom-center pivot.
  - Do not use as runtime art.
- `home_components_320x256_manifest_v002.json`
  - Normalization manifest and gate result.

## Prompt Summary

Fresh same-batch AI source sheet for cozy cottage home components, upper-left lighting, flat `#ff00ff` chroma background, no text, no shadows, no non-home objects. The output uses a `3x3` grid so body, roof, door, window, chimney, steps, flower box, and trim components all fit.

## Gate Result

- All nine components passed fixed-cell normalization.
- Alpha channel present.
- Cell size: `320x256`.
- Edge alpha touch: `0`.
- Visible chroma-key pixels: `0`.
- Default pivot and baseline proof exported.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
