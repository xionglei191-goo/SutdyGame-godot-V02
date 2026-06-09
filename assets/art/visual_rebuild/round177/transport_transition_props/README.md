# Round177 Transport / Transition Props

Proof-only transparent cozy town transport and transition prop candidates.

## Boundary

- Runtime boundary: proof-only, no runtime mapping, no `ThemeProfile`, no `AssetResolver`, no data, no shared tests.
- Scope: files in `assets/art/visual_rebuild/round177/transport_transition_props/`.
- Style target: child-friendly Animal Crossing-like 3/4 prop/prefab candidates compatible with Round174 place prefabs and Round170 water/path composition tests.
- Content exclusions: no readable text, letters, numbers, full scenes, symbols, logos, brands, or route markings.

## Items

- `small_bus_side`
- `tiny_taxi_marker_blank`
- `bicycle_rack_empty`
- `wooden_bridge_short`
- `stepping_stone_curve`
- `path_signpost_blank`
- `garden_gate_open`
- `school_crosswalk_soft`
- `plaza_archway_small`
- `ferry_pier_stub`

## Pipeline

Raw sources were generated with:

```bash
python3 assets/art/visual_rebuild/round177/transport_transition_props/generate_raw_from_prompts.py
```

Normalize, validate, create the contact sheet, and write `manifest.json`:

```bash
python3 assets/art/visual_rebuild/round177/transport_transition_props/normalize_validate_manifest.py
```

Per LESSON-022, generator transparency is not trusted. All raw PNGs returned RGB/opaque despite `--transparent`; the pass gate is based on actual RGBA output after local normalization. Three visually risky items (`wooden_bridge_short`, `path_signpost_blank`, `ferry_pier_stub`) use local alpha-safe synthesis in the normalizer to remove generated background/symbol risk while preserving this pack as proof-only candidate evidence.

## Outputs

- Raw generated sources: `raw/*_raw.png`
- Normalized candidates: `normalized_320x320/*.png`
- Proof sheet: `proof/round177_transport_transition_props_contact_sheet.png`
- Audit and recommendations: `manifest.json`

## Gate

Current manifest gate: `overall_gate: pass`.

Checks include RGBA alpha, 320x320 dimensions, non-empty alpha content, transparent corners, edge residue, chroma-key residue, dark pinholes, and large background block risk.
