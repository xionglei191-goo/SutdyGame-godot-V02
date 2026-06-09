# Round171 Home-Area Visual Preview Summary

Date: 2026-06-08

Scope: agent-generated proof-only assets for improving the Round170 composition kit. This round focuses on reducing visible tile repetition and adding actor scale references.

## Delegation

| Agent Scope | Asset Category | Result |
|---|---|---|
| Worker F | ground meadow chunks / soft path bands / grass-path edges | PASS |
| Worker G | actor scale reference sprites | PASS |

Both agents wrote only to their assigned asset and collaboration folders.

## Candidate Assets

| Category | Asset Path | Size / Grid | Gate |
|---|---|---:|---|
| meadow chunks | `assets/art/visual_rebuild/round171/ground_regions/ground_meadow_chunks_256x256_atlas_v002.png` | `256x256`, `2x2` | PASS |
| soft path bands | `assets/art/visual_rebuild/round171/ground_regions/ground_soft_path_bands_512x256_atlas_v002.png` | `512x256`, `2x2` | PASS |
| grass-path edges | `assets/art/visual_rebuild/round171/ground_regions/ground_grass_path_edges_256x256_atlas_v002.png` | `256x256`, `2x2` | PASS |
| actor scale refs | `assets/art/visual_rebuild/round171/actors/round171_actors_scale_reference_atlas_160x192x3.png` | `160x192`, `3x1` | PASS |

## Godot Proof

Command:

```bash
godot --headless --path . --script tests/capture_round171_home_area_preview.gd
```

Output:

`docs/collaboration/round171_visual_rebuild_asset_generation/round171_home_area_godot_preview_1280x720_v002.png`

## Read

Improvement:

- The Home-area proof is less grid-like than the Round170 tile-filled proof.
- Larger meadow chunks and soft path bands better support a scene-like composition.
- Actor scale references provide a useful first check against buildings, trees, and path width.
- v002 ground-region normalization removes visible chroma-key residue by adding post-resize magenta despill and alpha-edge color repair.

Risks:

- Some large ground-region silhouettes still read as generated overlay cutouts with a light rim / outline. This is no longer tracked as chroma-key leakage, but it should be improved in the next art-generation pass before visual-layout approval.
- The proof is still a composition test, not a target frame. It does not prove art-direction lock.
- Actor sprites are idle scale references only, not animation-ready production sprites.

## Decision

Continue with region-based ground composition rather than full-screen repeated `64x64` tiles. v002 is acceptable as proof-only evidence for the region-ground direction, but it is not runtime-ready and does not grant `art_target_locked`.
