# Round171 Ground Region Candidate Assets

Status: `normalized_candidate`

These files are proof-only larger ground / road region candidates for visual layout tests. They are intended to reduce the visible grid problem observed after Round170 `64x64` terrain/path candidates by using larger irregular overlays.

These assets are not wired into runtime, `AssetResolver`, `ThemeProfile`, data JSON, or tests.

## Files

- `ground_meadow_chunks_256x256_atlas_v002.png`
  - Four transparent RGBA meadow overlay chunks.
  - Cell size: `256x256`.
  - Recommended use: break up repeated grass texture and cover small visible tile seams.
- `ground_soft_path_bands_512x256_atlas_v002.png`
  - Four transparent RGBA soft dirt path / worn-road bands.
  - Cell size: `512x256`.
  - Recommended use: proof longer road strokes and plaza-like worn areas without a visible 64px rhythm.
- `ground_grass_path_edges_256x256_atlas_v002.png`
  - Four transparent RGBA grass-to-path transition chunks.
  - Cell size: `256x256`.
  - Recommended use: soften path edges and corners in visual-layout mockups.
- `*_tile_proof_v002.png`
  - Proof-only checkerboard/contact images with cell bounds and alpha bounding boxes.
- `*_manifest_v002.json`
  - Numeric gate records for alpha, fixed cells, source quadrants, edge alpha, components, chroma-key leakage, magenta fringe, and suspicious alpha-edge residue.

## Cell Choice

`256x256` was chosen for meadow and blended edge chunks because these pieces need to remain easy to layer, rotate, and repeat as proof overlays. `512x256` was chosen for path bands because the road problem is horizontal/flowing and needs longer uninterrupted strokes than square tile chunks can provide.

## Gate Result

- All three atlases passed fixed-cell normalization.
- Alpha channel is present in every atlas.
- Visible `#ff00ff` chroma-key pixels in final atlases: `0`.
- v002 magenta fringe and suspicious alpha-edge residue counts are `0` for every cell.
- Edge alpha touch is `0` for every cell, so these are currently overlay chunks rather than edge-connecting runtime tiles.

## v001 Record

The earlier v001 atlases remain in the asset tree as historical proof output. v001 reduced the full-screen tile rhythm but showed visible magenta / pink chroma residue in the Home-area proof, so v002 is the current proof-only candidate.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, live runtime, data JSON, or tests until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
