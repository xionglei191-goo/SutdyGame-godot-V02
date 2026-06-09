# Round170 Building Prefab Candidate Assets

Status: `normalized_candidate`

These files are proof-only cozy town building prefab candidates for visual layout preview. They are stored under the asset tree for stable reference, but they are not wired into runtime.

## Files

- `building_prefabs_320x320_atlas_v001.png`
  - Fixed-cell transparent RGBA atlas.
  - Grid: `2x2`.
  - Cell size: `320x320`.
  - Default pivot per cell: `(160, 302)`.
- `building_prefabs_320x320_pivot_proof_v001.png`
  - Proof image showing cell grid, baseline, and default bottom-center pivot.
  - Do not use as runtime art.
- `building_prefabs_320x320_manifest_v001.json`
  - Normalization manifest and gate result.

## Prompt Summary

Controlled local text-to-image fallback generated four separate full building prefabs on flat `#ff00ff` chroma background: red-roof home, green-awning shop, blue-roof garden cottage, and yellow-roof community cottage. The prompt requested 3/4 orthographic cozy town game assets, consistent scale, no text, no shadows, and no loose props.

## Gate Result

- Overall manifest gate: `pass`.
- All four building prefabs passed fixed-cell normalization.
- Alpha channel present.
- Cell size: `320x320`.
- Edge alpha touch: `0`.
- Visible chroma-key pixels: `0`.
- Connected components per cell: `1`.

## Cell Size And Scale

`320x320` was chosen over `256x256` / `320x256` because full buildings need more vertical room for roofs, chimneys, shop awnings, and a stable bottom pivot. Recommended proof display scale is `0.50x` to `0.60x` in a `1280x720` target frame.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
