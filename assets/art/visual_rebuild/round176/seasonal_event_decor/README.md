# Round176 Seasonal / Event Decor Proof Pack

Proof-only transparent seasonal and event decor candidates for Sunshine Town.

This pack is intentionally local to `assets/art/visual_rebuild/round176/seasonal_event_decor/`.
It does not change runtime mappings, `ThemeProfile`, `AssetResolver`, data files, tests, docs, `todo.md`, or `lessons.md`.

## Contents

- `raw/`: fallback generator source PNGs from `/home/xionglei/GameProject/tools/image_generator.js`.
- `normalized_256x256/`: final transparent RGBA proof candidates.
- `proof/round176_seasonal_event_decor_contact_sheet.png`: visual contact sheet on checker backgrounds.
- `manifest.json`: provenance, runtime boundary, item recommendations, risks, and validation results.
- `normalize_validate_manifest.py`: local alpha-safe synthesis, validation, contact sheet, and manifest helper.

## Gate

`manifest.json` is the source of truth for this proof pack. `overall_gate` may be treated as pass only when all ten items pass:

- RGBA alpha channel.
- Expected `256x256` normalized dimensions.
- Non-empty alpha content.
- Transparent corner alpha.
- Edge residue / edge-touch scan.
- Green or magenta chroma-key residue scan.
- Dark pinhole residue scan.
- Large opaque background-block risk scan.

The raw generator outputs requested transparency but returned RGB/opaque PNGs in this run, so final candidates are local alpha-safe proof synthesis with raw source files retained for provenance.
