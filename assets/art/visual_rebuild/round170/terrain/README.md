# Round170 Terrain / Path Candidate Assets

Status: `normalized_candidate`

These files are proof-only terrain and path tile candidates produced during Round170. They are stored under the asset tree for stable visual-layout preview references, but they are not wired into runtime.

## Files

- `terrain_path_tiles_64x64_sheet_v001.png`
  - Fixed-cell RGBA tile atlas.
  - Grid: `3x2`.
  - Cell size: `64x64`.
  - Validation mode: path tile edge connections.
- `terrain_path_tiles_64x64_tile_proof_v001.png`
  - Proof-only image showing cell grid and recorded edge-contact markers.
  - Do not use as runtime art.
- `terrain_path_tiles_64x64_manifest_v001.json`
  - Normalization manifest and gate result.

## Prompt Summary

Fresh raw AI source sheet for six cozy town ground/path tile candidates on flat `#00ff00` chroma background: grass base, straight dirt path, path corner, stepping-stone path, worn plaza ground, and grass-to-path edge. The prompt required no text, no props, no characters, no shadows, and generous chroma-key gutters.

## Gate Result

- All six tiles passed fixed-cell normalization.
- Alpha channel present.
- Atlas size: `192x128`.
- Cell size: `64x64`.
- Visible chroma-key pixels in final atlas: `0`.
- Edge alpha touch is allowed and recorded for path tile connection review.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
