# Round178 Companion Care Props

Proof-only transparent cozy companion-care prop candidates for the StudyGame V02 Godot visual rebuild.

## Boundary

- Runtime boundary: `proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes`
- Scope: files in `assets/art/visual_rebuild/round178/companion_care_props/`
- Status: `proof_only_transparent_candidates`
- No runtime wiring, no `ThemeProfile`, no `AssetResolver`, no data changes, no shared-test changes.
- These candidates do not grant `art_target_locked` or `runtime_visual_match`.

## Items

- `companion_care_props.sunny_cushion_round`
- `companion_care_props.tiny_food_bowl`
- `companion_care_props.water_bowl_flower`
- `companion_care_props.grooming_brush_soft`
- `companion_care_props.ribbon_collar_charm`
- `companion_care_props.plush_ball_toy`
- `companion_care_props.folded_pet_blanket`
- `companion_care_props.bath_towel_stack`
- `companion_care_props.paw_print_moment_marker`
- `companion_care_props.small_companion_bed`

## Pipeline

Generate transparent PNGs, validate real alpha, write `manifest.json`, and create the contact sheet:

```bash
python3 assets/art/visual_rebuild/round178/companion_care_props/generate_validate_manifest.py
```

Audit with the shared visual candidate manifest checker:

```bash
python3 scripts/tools/audit_visual_candidate_manifests.py assets/art/visual_rebuild/round178/companion_care_props
```

Per LESSON-022, the pass gate is based on actual RGBA alpha and residue checks, not generator flags. This pack uses local transparent RGBA synthesis, so there are no RGB/opaque raw sources to normalize.

## Outputs

- Normalized candidates: `normalized_192x192/*.png`
- Proof sheet: `proof/round178_companion_care_props_contact_sheet.png`
- Manifest and gate data: `manifest.json`

## Visual Risks

- `paw_print_moment_marker` is intentionally subtle and may need contrast review before any runtime or UI-feedback use.
- `ribbon_collar_charm` and `plush_ball_toy` include decorative shapes; they should be reviewed to ensure they do not imply text, logos, or symbols at small scale.
- `small_companion_bed` needs a future composition proof beside the Round174 Sunny companion candidate before scale approval.
