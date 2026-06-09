# Round173 Furniture Asset Generation Notes

Scope: proof-only furniture / home interior asset pack.

Inputs came from `docs/10_美术风格与换肤预留.md` and `docs/14_内容基线整理与首批内容规划.md`, specifically the cozy home furniture and shop rotation needs for small table, wooden chair, rug, flower pot, pet bowl, Sunny bed, book stack, and wall art.

Generation path:

1. Generated an initial 4x2 raw sheet at `round173_furniture_raw_chroma_ff00ff_4x2_v001.png`.
2. Rejected that first raw sheet for proof use because the generator did not keep objects inside equal cells.
3. Generated eight isolated chroma-key raw item images under `raw_items/`.
4. Ran `normalize_round173_furniture.py` to remove key color, compose `round173_furniture_raw_chroma_ff00ff_4x2_v002.png`, normalize to fixed `128x128` alpha cells, build the atlas, proof image, and manifest.

Final outputs:

- Raw chroma sheet: `docs/collaboration/round173_visual_rebuild_asset_generation/furniture/round173_furniture_raw_chroma_ff00ff_4x2_v002.png`
- Normalized atlas: `assets/art/visual_rebuild/round173/furniture/round173_furniture_128x128_atlas_v001.png`
- Proof: `assets/art/visual_rebuild/round173/furniture/round173_furniture_128x128_proof_v001.png`
- Manifest: `assets/art/visual_rebuild/round173/furniture/round173_furniture_manifest_v001.json`
- Normalized cells: `assets/art/visual_rebuild/round173/furniture/normalized_128x128/`

Boundary:

- Candidate only.
- No runtime changes.
- No `ThemeProfile` changes.
- No `AssetResolver` changes.
- No data or test runner changes.

Current gate: `pass`.
