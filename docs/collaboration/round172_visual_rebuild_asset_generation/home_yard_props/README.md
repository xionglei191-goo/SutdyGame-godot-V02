# Round172 Home Yard Props Provenance

Scope: proof-only asset generation for `assets/art/visual_rebuild/round172/home_yard_props/`.

Final selected source:

- `home_yard_props_raw_chroma_ff00ff_flat_v3.png`

Final asset-tree outputs:

- `assets/art/visual_rebuild/round172/home_yard_props/home_yard_props_128x128_atlas.png`
- `assets/art/visual_rebuild/round172/home_yard_props/home_yard_props_128x128_proof.png`
- `assets/art/visual_rebuild/round172/home_yard_props/home_yard_props_manifest.json`
- `assets/art/visual_rebuild/round172/home_yard_props/normalized_128x128/*.png`

Generation command:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "Flat 2D game sprite atlas, 4 columns x 2 rows, eight small cozy home yard prop icons. Pure solid #ff00ff background filling the entire image, absolutely no gradient, no vignette, no spotlight, no floor, no shadows, no ambient occlusion, no glow, no reflections. Simple clean cel-shaded cozy mobile life RPG style, rounded child-friendly shapes, crisp silhouette, thick soft painted edges, consistent scale, slight top-down three-quarter view. Each prop centered in a separate invisible cell with wide empty magenta padding. Exact order: watering can; flower pot cluster; tiny birdhouse on short post; garden bed with seedlings; folded picnic cloth; pet bowl; laundry line post with tiny cloth; stepping stones cluster. Do not use magenta or #ff00ff in any prop. No text, no labels, no grid lines, no watermark." docs/collaboration/round172_visual_rebuild_asset_generation/home_yard_props/home_yard_props_raw_chroma_ff00ff_flat_v3.png 1024x1024
```

Normalization command:

```bash
python3 scripts/tools/normalize_chroma_grid_sheet.py docs/collaboration/round172_visual_rebuild_asset_generation/home_yard_props/home_yard_props_raw_chroma_ff00ff_flat_v3.png --output-dir assets/art/visual_rebuild/round172/home_yard_props --columns 4 --rows 2 --key-color ff00ff --key-family magenta --tolerance 42 --cell-width 128 --cell-height 128 --fit-width 112 --fit-height 104 --pivot-x 64 --pivot-y 118 --min-margin 1 --min-bottom-margin 1 --component-threshold 48 --component-min-area 8 --max-components 20 --item-prefix home_yard_prop
```

Final cleanup/build command:

```bash
python3 docs/collaboration/round172_visual_rebuild_asset_generation/home_yard_props/cleanup_home_yard_props.py
python3 docs/collaboration/round172_visual_rebuild_asset_generation/home_yard_props/build_final_home_yard_props_manifest.py
```

Notes:

- Earlier attempts are retained here as provenance because they had non-flat studio background or extraction damage.
- Final v3 source uses a flat `#ff00ff` chroma key.
- Birdhouse and laundry-line cells had tiny cross-cell spill fragments; the final cleanup script removed only right-edge spill bands.
- No runtime, `ThemeProfile`, `AssetResolver`, data, or test mappings were changed.

