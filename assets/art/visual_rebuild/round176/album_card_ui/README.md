# Round176 Album Card UI Proof Pack

Proof-only Apple-like translucent collection album and card UI candidates.

Runtime boundary: no `AssetResolver`, `ThemeProfile`, data, scene, runtime, shared test, todo, lesson, or docs mapping is included. These files are isolated visual candidates only.

## Commands

```bash
bash assets/art/visual_rebuild/round176/album_card_ui/generate_assets.sh
python3 assets/art/visual_rebuild/round176/album_card_ui/normalize_validate_manifest.py
```

## Outputs

- `manifest.json`: source-of-truth proof ledger and validation report
- `proof/round176_album_card_ui_contact_sheet.png`: checkerboard contact sheet
- `*.png`: normalized transparent candidates
- `raw/*_raw.png`: generator outputs preserved for source proof

Validation covers RGBA alpha, non-empty alpha content, transparent corners, edge alpha, alpha holes, white/glass cleanup damage, chroma-key residue, and dark pinholes.
