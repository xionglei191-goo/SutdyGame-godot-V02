# Round179 A-Z Story Vignettes N-Z

Proof-only transparent vignette overlay candidates for the stable N-Z memory-palace anchors in `data/maps/world_map.json`.

## Boundary

- Runtime boundary: `proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes`
- No runtime wiring.
- No `ThemeProfile` mapping.
- No `AssetResolver` mapping.
- No data or shared test changes.
- No `art_target_locked` or `runtime_visual_match` claim.

## Contents

- `normalized_256x192/`: 13 transparent RGBA PNG candidates, one each for N through Z.
- `manifest.json`: anchor/core-word/story-hook/revisit-path manifest plus alpha/background gates.
- `proof/round179_az_story_vignettes_n_z_contact_sheet.png`: checkerboard contact sheet for visual background-block review.
- `generate_validate_pack.py`: deterministic local generator and validator.

## Validation

Run from the repository root:

```bash
python3 assets/art/visual_rebuild/round179/az_story_vignettes_n_z/generate_validate_pack.py
python3 scripts/tools/audit_visual_candidate_manifests.py assets/art/visual_rebuild/round179/az_story_vignettes_n_z
```

The generator reads `data/maps/world_map.json` only to verify the N-Z stable `anchor_*` IDs and core words. It validates actual RGBA alpha, transparent corners, visible edge residue, suspicious chroma/key residue, and large rectangular background blocks per LESSON-021 / LESSON-022.
