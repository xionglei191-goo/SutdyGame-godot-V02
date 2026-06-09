# Round172 Anchor Props A-M Generation Notes

This folder contains the proof-only raw generation source and local normalization script for the A-M memory-palace anchor prop candidate pack.

Files:

- `round172_anchor_props_a_m_raw_chroma_sheet_v001.png`: RGB chroma-key raw sheet generated with `/home/xionglei/GameProject/tools/image_generator.js`.
- `normalize_round172_anchor_props.py`: converts the raw sheet into transparent fixed-cell candidates under `assets/art/visual_rebuild/round172/anchor_props_a_m/`.

Prompt constraints used:

- 4x4 raw sheet on flat `#00ff00` chroma-key.
- 13 prop-first anchors for A-M, with 3 empty cells.
- Cozy mobile life RPG, 2.5D orthographic visual style.
- No letters, numbers, readable words, labels, UI badges, watermarks, or captions.
- No runtime, ThemeProfile, AssetResolver, data, or test mapping.

The normalization script removes chroma-key background, assigns connected components back to the A-M expected centers to avoid cross-cell fragments, fits each prop into a fixed 128x128 transparent cell, builds the 4x4 atlas and proof, and writes the asset-tree manifest.
