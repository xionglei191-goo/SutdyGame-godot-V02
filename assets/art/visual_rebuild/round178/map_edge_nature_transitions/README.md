# Round178 Map-Edge / Nature Transitions

Proof-only transparent cozy town transition candidates for softening boundaries between meadow, path, home, school, shop, water, and plaza.

## Boundary

- Runtime boundary: proof-only, no runtime mapping, no `ThemeProfile`, no `AssetResolver`, no data, no shared tests.
- Scope: files in `assets/art/visual_rebuild/round178/map_edge_nature_transitions/`.
- Style target: warm Animal Crossing-like cozy town proportions, transparent overlay pieces, no full-map background, no hard grid, no text.

## Items

- `meadow_to_path_corner_soft`
- `grass_to_plaza_pebble_edge`
- `garden_bush_depth_cluster`
- `tiny_flower_depth_strip`
- `pond_grass_reed_corner`
- `home_yard_shadow_patch`
- `school_yard_chalkless_edge`
- `shop_front_planter_edge`
- `tree_shadow_ground_soft`
- `coast_sand_grass_curve`

## Pipeline

Generate, validate, create contact sheet, and write `manifest.json`:

```bash
python3 assets/art/visual_rebuild/round178/map_edge_nature_transitions/generate_validate_pack.py
```

The pack uses deterministic local RGBA synthesis rather than generated raw sheets. Per LESSON-022, the gate checks actual alpha on the output files. Per LESSON-020, the manifest records chroma-key residue, magenta/green fringe, and suspicious alpha-edge residue counts.

## Outputs

- Normalized candidates: `normalized_384x192/*.png`
- Proof sheet: `proof/round178_map_edge_nature_transitions_contact_sheet.png`
- Audit and recommendations: `manifest.json`

## Gate

Current manifest gate: `overall_gate: pass`.
