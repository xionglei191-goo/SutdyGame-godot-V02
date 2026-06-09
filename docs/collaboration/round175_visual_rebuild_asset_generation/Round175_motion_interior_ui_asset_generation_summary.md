# Round175 Motion / Interior / UI Asset Generation Summary

Date: 2026-06-08

Status: `proof_only / normalized_candidate`

Runtime boundary: no `AssetResolver`, no `ThemeProfile`, no runtime/data mapping, no `art_target_locked`, no `runtime_visual_match`.

## Packs

| Pack | Path | Count | Gate |
|---|---|---:|---|
| Character 4-direction walk motion sheets | `assets/art/visual_rebuild/round175/motion_sheets/` | 6 | pass |
| Home interior shell building blocks | `assets/art/visual_rebuild/round175/home_interior_shells/` | 8 | pass |
| Interaction feedback / glass UI candidates | `assets/art/visual_rebuild/round175/interaction_ui_feedback/` | 10 | pass |

## Proof

- Combined Godot preview: `docs/collaboration/round175_visual_rebuild_asset_generation/round175_motion_interior_ui_godot_preview_1280x720_v001.png`
- Proof capture script: `tests/capture_round175_motion_interior_ui_preview.gd`

## Notes

- Motion sheets are proof-only motion candidates, not animation-ready. The raw generation path could not reliably produce clean transparent sheets, so the final candidate sheets are normalized / synthesized from clean Round174 actor references and recorded as proof-only.
- Home interior shell assets include broad floor / wall region bands. These are explicitly marked as `region_band_not_sprite` and must stay behind furniture and actors in any later composition.
- Interaction feedback / glass UI candidates are subtle by design; they need later review on real HUD/footer and gameplay backgrounds.
- Across all three packs, the fallback generator returned RGB/opaque outputs despite `--transparent`. Final proof candidates therefore rely on local alpha-safe normalization or local asset synthesis, with raw outputs kept as generation evidence.

## Validation

```bash
python3 -m py_compile scripts/tools/audit_visual_candidate_manifests.py
python3 scripts/tools/audit_visual_candidate_manifests.py assets/art/visual_rebuild/round169 assets/art/visual_rebuild/round170 assets/art/visual_rebuild/round171 assets/art/visual_rebuild/round172 assets/art/visual_rebuild/round173 assets/art/visual_rebuild/round174 assets/art/visual_rebuild/round175
godot --headless --path . --script tests/capture_round175_motion_interior_ui_preview.gd
```

Result: `31/31` visual candidate manifests passed after manifest audit support was extended for path-like `main_ref` / `source_ref` fields; Round175 Godot proof capture passed.
