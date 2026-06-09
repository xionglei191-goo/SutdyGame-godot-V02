# Round179 School / Shop Daily Props

Proof-only transparent cozy daily-life prop candidates for the StudyGame V02 Godot visual rebuild.

## Boundary

- Runtime boundary: `proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes`
- Scope: files in `assets/art/visual_rebuild/round179/school_shop_daily_props/`
- Status: `proof_only_transparent_candidates`
- No runtime wiring, no `ThemeProfile`, no `AssetResolver`, no data changes, no shared-test changes.
- These candidates do not grant `art_target_locked` or `runtime_visual_match`.

## Items

- `school_shop_daily_props.school_gate_flower_pot`
- `school_shop_daily_props.shoe_cubby_soft`
- `school_shop_daily_props.yard_jump_rope_coil`
- `school_shop_daily_props.yard_ball_basket`
- `school_shop_daily_props.bookshop_window_stack`
- `school_shop_daily_props.bookshop_reading_cushion`
- `school_shop_daily_props.shop_fruit_crate`
- `school_shop_daily_props.shop_bread_tray`
- `school_shop_daily_props.shop_small_price_leaf_blank`
- `school_shop_daily_props.bus_stop_bench_cushion`
- `school_shop_daily_props.bus_stop_timetable_blank_board`
- `school_shop_daily_props.plaza_notice_leaf_blank`

## Pipeline

Generate transparent PNGs, validate real alpha/background-block risk, write `manifest.json`, and create the contact sheet:

```bash
python3 assets/art/visual_rebuild/round179/school_shop_daily_props/generate_validate_manifest.py
```

Audit with the shared visual candidate manifest checker:

```bash
python3 scripts/tools/audit_visual_candidate_manifests.py assets/art/visual_rebuild/round179/school_shop_daily_props
```

Per LESSON-022, the pass gate is based on actual RGBA alpha and residue checks, not generator flags. Per LESSON-021, the manifest includes a large opaque component background-block risk scan.

## Outputs

- Normalized candidates: `normalized_192x192/*.png`
- Proof sheet: `proof/round179_school_shop_daily_props_contact_sheet.png`
- Manifest and gate data: `manifest.json`

## Visual Risks

- Blank leaf and board props must remain blank if promoted later: no numbers, labels, route text, currency, sale symbols, or exclamation cues.
- Book and school-adjacent props should be reviewed in context to preserve cozy daily-life tone without class, test, or homework pressure.
- Rope and small leaf tag details need future mobile-scale readability review before any runtime use.
