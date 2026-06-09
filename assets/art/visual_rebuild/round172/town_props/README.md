# Round172 Town Props Candidate Pack

Proof-only town props asset pack for the V02.39 visual rebuild.

## Boundary

- Runtime boundary: `candidate_only_no_asset_resolver_or_themeprofile_mapping`
- Status: `normalized_candidate`
- No runtime, `ThemeProfile`, `AssetResolver`, data, or test mapping was changed.
- Raw source is kept under `docs/collaboration/round172_visual_rebuild_asset_generation/town_props/`.

## Outputs

- Atlas: `assets/art/visual_rebuild/round172/town_props/round172_town_props_raw_chroma_4x2_v002_128x128_atlas.png`
- Proof: `assets/art/visual_rebuild/round172/town_props/round172_town_props_raw_chroma_4x2_v002_128x128_pivot_proof.png`
- Manifest: `assets/art/visual_rebuild/round172/town_props/round172_town_props_raw_chroma_4x2_v002_128x128_manifest.json`
- Normalized PNGs: `assets/art/visual_rebuild/round172/town_props/normalized_128x128/`

## Contents

1. Mailbox
2. Warm street lamp
3. Wood signpost
4. Wood crate stack
5. Small notice board
6. Round stone
7. Small wooden bench
8. Market basket

## Gate

The generated manifest records `overall_gate: pass`. Each normalized item uses a fixed `128x128` cell, has alpha, has a non-empty placed bbox, has zero visible magenta key pixels, and has no edge-touching alpha pixels.

## Validation

Generated with:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "<prompt>" docs/collaboration/round172_visual_rebuild_asset_generation/town_props/round172_town_props_raw_chroma_4x2_v002.png 1024x512
python3 docs/collaboration/round172_visual_rebuild_asset_generation/town_props/extract_round172_town_props.py
```

The extraction script uses manual source bboxes from the same raw sheet because the generated signpost and bench are wider than the implied raw grid cells. The final atlas remains fixed-cell `4x2`, `128x128`.
