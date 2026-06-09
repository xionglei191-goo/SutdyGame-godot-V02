# Round175 Motion Sheets

Proof-only cozy-town character walking sprite sheet candidates.

- Layout: 4 directions (`down`, `left`, `right`, `up`) by 3 frames.
- Cell: 160x192 px.
- Sheet: 480x768 px.
- Baseline: y=176 per cell.
- Pivot: (80, 176).
- Runtime boundary: no `AssetResolver`, `ThemeProfile`, data, scene, or runtime mapping changes.

Run:

```bash
python3 assets/art/visual_rebuild/round175/motion_sheets/generate_raw_from_prompts.py
python3 assets/art/visual_rebuild/round175/motion_sheets/normalize_and_manifest.py
```

Gate output is recorded in `round175_motion_sheets_manifest.json`.
