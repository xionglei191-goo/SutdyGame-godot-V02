# Round174 Character / Place / Weather Asset Generation Summary

Date: 2026-06-08

Status: `proof_only / normalized_candidate`

Runtime boundary: no `AssetResolver`, no `ThemeProfile`, no runtime/data mapping, no `art_target_locked`, no `runtime_visual_match`.

## Packs

| Pack | Path | Count | Gate |
|---|---|---:|---|
| NPC / companion full-body standing sprites | `assets/art/visual_rebuild/round174/npc_fullbody/` | 8 | pass |
| Landmark / place prefabs | `assets/art/visual_rebuild/round174/place_prefabs/` | 8 | pass |
| Weather / environment FX | `assets/art/visual_rebuild/round174/weather_fx/` | 8 | pass |

## Proof

- Combined Godot preview: `docs/collaboration/round174_visual_rebuild_asset_generation/round174_character_place_weather_godot_preview_1280x720_v001.png`
- Proof capture script: `tests/capture_round174_character_place_weather_preview.gd`

## Notes

- NPC candidates were regenerated after the first proof exposed dark rectangular background / halo blocks that passed basic alpha checks. The repaired manifest now includes a stricter visual background-block gate and reports `visual_background_block_count = 0`.
- Place prefabs use `320x320` normalized transparent cells and pivot recommendation `(160, 302)`. They remain proof-only and need later in-scene scale / depth review.
- Weather FX assets passed alpha / dimension / key-residue checks. `soft_cloud_shadow` may be faint and should be reviewed in a real composition.

## Validation

```bash
python3 scripts/tools/audit_visual_candidate_manifests.py assets/art/visual_rebuild/round169 assets/art/visual_rebuild/round170 assets/art/visual_rebuild/round171 assets/art/visual_rebuild/round172 assets/art/visual_rebuild/round173 assets/art/visual_rebuild/round174
godot --headless --path . --script tests/capture_round174_character_place_weather_preview.gd
godot --headless --path . --quit
```

Result: `28/28` visual candidate manifests passed; Godot proof capture and headless startup passed.
