# Round171 Actor Scale Reference Candidates

Status: `normalized_candidate`

These are proof-only actor scale reference sprites for visual layout previews. They are not animation-ready production sprites and are not mapped into runtime.

## Files

- `round171_actors_scale_reference_atlas_160x192x3.png`
  - Fixed-cell RGBA atlas.
  - Grid: `3x1`.
  - Cell size: `160x192`.
  - Baseline: `y=176`.
- `round171_actor_child_player_160x192.png`
- `round171_actor_friendly_resident_160x192.png`
- `round171_actor_sunny_like_pet_160x192.png`
- `round171_actors_scale_reference_proof_checker.png`
  - Proof-only checker preview.
- `round171_actors_manifest.json`
  - Manifest and candidate gate.

## Gate Result

- Raw chroma sheet generated successfully.
- Fixed cell size: `160x192`.
- Atlas size: `480x192`.
- Transparent RGBA output.
- Baseline aligned at `y=176`.
- Recommended visual-layout display scale: `0.72`.

## Runtime Boundary

Do not map these files into `AssetResolver`, `ThemeProfile`, or live runtime until a later visual-layout gate explicitly approves them.

These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
