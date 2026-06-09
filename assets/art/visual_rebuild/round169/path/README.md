# Round169 Path Candidate Assets

Status: `normalized_candidate`

These files are proof-only path overlay tile candidates produced during Round169. They are stored under the asset tree for stable preview references, but they are not wired into runtime.

## Files

- `path_overlay_tiles_128x128_sheet_v002.png`
  - Fixed-cell RGBA tile atlas.
  - Grid: `4x4`.
  - Cell size: `128x128`.
  - Validation mode: path tile edge connections.
- `path_overlay_tiles_128x128_tile_proof_v002.png`
  - Proof-only image showing cell grid and recorded edge-contact markers.
  - Do not use as runtime art.
- `path_overlay_tiles_128x128_manifest_v002.json`
  - Normalization manifest and gate result.

## Prompt Summary

Fresh same-batch AI source sheet for soft dirt and stone cozy-town path overlay tiles, upper-left lighting, flat `#00ff00` chroma background, no text, no shadows, no non-path objects.

## Gate Result

- All sixteen tiles passed fixed-cell normalization.
- Alpha channel present.
- Cell size: `128x128`.
- Visible chroma-key pixels: `0`.
- Edge alpha touch is allowed and recorded for path tile connection review.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
