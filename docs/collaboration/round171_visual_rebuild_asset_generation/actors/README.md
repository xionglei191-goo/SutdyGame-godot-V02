# Round171 Actor Scale Reference Sprites

Status: `normalized_candidate_proof_only`

These actor sprites are proof-only visual layout references for Round171. They are not runtime animation assets, are not mapped through `AssetResolver`, and should not be treated as approved production character art.

## Cell Contract

- Cell size: `160x192` px.
- Atlas layout: `3 columns x 1 row`, total `480x192` px.
- Baseline: `y=176` px in each cell.
- Recommended display scale: `0.72`, or about `115x138` px per full cell in a 1280x720 proof scene.
- Rationale: `160x192` leaves enough vertical room for a child player, a slightly taller friendly resident, and a shorter pet while preserving one consistent baseline and avoiding cramped silhouettes.

## Prompt

```text
Proof-only cozy mobile life RPG actor scale reference sprite sheet, orthographic front-facing 2.5D game sprites, three separate full body characters evenly spaced left to right on a pure solid chroma green background (#00ff00), no shadows touching background, no text, no labels, no borders. Left: friendly child player age 7 wearing warm town clothes, simple rounded silhouette, standing idle. Center: friendly animal resident, small tan rabbit villager with cardigan and gentle expression, standing idle, slightly taller than child. Right: Sunny-like companion pet, tiny sunshine-yellow puppy companion with soft ears and cheerful face, standing idle, much shorter than child. Consistent warm Animal Crossing-like cozy town style, clean edges, simple readable shapes, same camera and lighting, transparent-ready sprite art, proof asset only.
```

Generation command:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "Proof-only cozy mobile life RPG actor scale reference sprite sheet, orthographic front-facing 2.5D game sprites, three separate full body characters evenly spaced left to right on a pure solid chroma green background (#00ff00), no shadows touching background, no text, no labels, no borders. Left: friendly child player age 7 wearing warm town clothes, simple rounded silhouette, standing idle. Center: friendly animal resident, small tan rabbit villager with cardigan and gentle expression, standing idle, slightly taller than child. Right: Sunny-like companion pet, tiny sunshine-yellow puppy companion with soft ears and cheerful face, standing idle, much shorter than child. Consistent warm Animal Crossing-like cozy town style, clean edges, simple readable shapes, same camera and lighting, transparent-ready sprite art, proof asset only." assets/art/visual_rebuild/round171/actors/round171_actors_raw_chroma_sheet.png 1024x1024
```

Normalization command:

```bash
python3 docs/collaboration/round171_visual_rebuild_asset_generation/actors/normalize_round171_actors.py
```

## Files

- `assets/art/visual_rebuild/round171/actors/round171_actors_raw_chroma_sheet.png`: RGB chroma-key source sheet.
- `assets/art/visual_rebuild/round171/actors/round171_actor_child_player_160x192.png`: transparent child player cell.
- `assets/art/visual_rebuild/round171/actors/round171_actor_friendly_resident_160x192.png`: transparent friendly animal resident cell.
- `assets/art/visual_rebuild/round171/actors/round171_actor_sunny_like_pet_160x192.png`: transparent Sunny-like companion cell.
- `assets/art/visual_rebuild/round171/actors/round171_actors_scale_reference_atlas_160x192x3.png`: transparent atlas for Godot layout proof.
- `assets/art/visual_rebuild/round171/actors/round171_actors_scale_reference_proof_checker.png`: checkerboard proof image for visual inspection only.
- `docs/collaboration/round171_visual_rebuild_asset_generation/actors/round171_actors_manifest.json`: numeric manifest and gate data.
- `docs/collaboration/round171_visual_rebuild_asset_generation/actors/normalize_round171_actors.py`: repeatable chroma-key and cell normalization script.

## Gate Result

Pass for proof-only layout use.

- Raw source exists and remains unmapped RGB chroma-key input.
- Normalized output is transparent RGBA.
- Individual cells are fixed `160x192`.
- Atlas is fixed `480x192`.
- Three actors are baseline-aligned at `y=176`.
- No runtime, data, ThemeProfile, AssetResolver, test, todo, or lessons files were changed.

## Risks

- These are single idle reference poses only; no runtime animation, directional turns, or walk-cycle consistency is implied.
- The pet is Sunny-like for scale/layout proof, not final Sunny character approval.
- Chroma-key cleanup was numeric and visually spot-checked, but final production assets should use true transparent generation or tighter matte cleanup.
- The friendly resident species/design may change during art direction; use only for relative actor scale in composition tests.
