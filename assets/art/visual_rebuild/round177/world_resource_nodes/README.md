# Round177 World Resource Nodes

Proof-only cozy town world resource-node candidates for V02.39 visual rebuild review.

## Boundary

- Proof-only asset pack.
- No runtime mapping.
- No `ThemeProfile`, `AssetResolver`, data, shared tests, todo, lessons, or docs changes.
- Candidates are not approval evidence for `art_target_locked` or `runtime_visual_match`.

## Contents

- `raw/`: opaque RGB generator outputs from `/home/xionglei/GameProject/tools/image_generator.js`.
- `normalized_192x192/`: local normalized transparent PNG candidates.
- `round177_world_resource_nodes_atlas_5x2_192.png`: transparent atlas.
- `proof/round177_world_resource_nodes_checker_proof_1120x448.png`: checker proof for visual/background-block review.
- `manifest.json`: item prompts, source paths, dimensions, alpha checks, edge checks, residue checks, pivot/footprint/layer recommendations, risks, and proof-only runtime boundary.
- `normalize_validate_manifest.py`: local normalization, proof, atlas, and manifest helper.

## Items

- `branch_pile_node`
- `pebble_cluster_node`
- `wildflower_collect_patch`
- `orange_tree_small_node`
- `seed_sprout_node`
- `fabric_scrap_basket_node`
- `tiny_book_stack_node`
- `snack_basket_node`
- `coin_sparkle_node`
- `watering_can_pickup_node`

## Validation

```bash
python3 assets/art/visual_rebuild/round177/world_resource_nodes/normalize_validate_manifest.py
jq '.overall_gate, .counts' assets/art/visual_rebuild/round177/world_resource_nodes/manifest.json
```

Latest gate: `pass`, 10 pass / 0 fail.

Alpha policy follows LESSON-022: generator transparency is not trusted. All raw outputs were checked and normalized locally into RGBA PNGs with transparent corners, clean edge residue, chroma/key residue checks, and background-block checks recorded in `manifest.json`.
