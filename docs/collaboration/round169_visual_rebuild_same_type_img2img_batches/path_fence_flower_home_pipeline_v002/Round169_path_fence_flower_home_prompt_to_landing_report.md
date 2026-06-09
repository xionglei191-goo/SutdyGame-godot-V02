# Round169 Path / Fence / Flower / Home Prompt-to-Landing Pipeline

Date: 2026-06-08

Scope: proof-only same-batch asset pipeline for `path`, `fence`, `flower`, and `home`, using the already passing Round169 tree v002 atlas as the preview reference. This run treats AI output as raw draft material, normalizes it into fixed Godot-friendly atlases, and keeps every output at `normalized_candidate`.

## Goal

1. Generate four fresh raw AI source sheets for path, fence, flower, and home.
2. Remove chroma-key backgrounds into alpha.
3. Normalize each category into fixed-cell atlases.
4. Export pivot / tile proofs and manifests.
5. Land passing atlases under stable asset-tree paths.
6. Compose one `1280x720` Godot proof frame using tree v002 plus the four new categories.

## Prompt Summary

| Category | Raw Source | Chroma | Prompt Notes |
|---|---|---|---|
| path | `raw/round169_path_ai_raw_sheet_v002.png` | `#00ff00` | 4x4 soft dirt / stone path overlay tiles, upper-left lighting, no text, no shadows, no non-path objects |
| fence | `raw/round169_fence_ai_raw_sheet_v002.png` | `#00ffff` | 3x2 warm wooden fence segments, bottom baseline, no text, no shadows, no non-fence objects |
| flower | `raw/round169_flower_ai_raw_sheet_v002.png` | `#0000ff` | 3x2 flower / garden patches, bottom-center placement, no blue flowers, no text, no shadows |
| home | `raw/round169_home_ai_raw_sheet_v002.png` | `#ff00ff` | 3x3 home component sheet so body, roof, door, window, chimney, steps, flower box, and trim can all fit |

## Normalization Contract

| Category | Grid | Cell | Pivot / Rule | Tool |
|---|---:|---:|---|---|
| path | 4x4 | `128x128` | path edge alpha contact allowed and recorded | `scripts/tools/normalize_chroma_path_tile_sheet.py` |
| fence | 3x2 | `256x128` | bottom-center pivot `(128, 118)` | `scripts/tools/normalize_chroma_grid_sheet.py` |
| flower | 3x2 | `192x160` | bottom-center pivot `(96, 148)` | `scripts/tools/normalize_chroma_grid_sheet.py` |
| home | 3x3 | `320x256` | default component pivot `(160, 238)` | `scripts/tools/normalize_chroma_grid_sheet.py` |

## Gate Result

| Category | Items | Gate | Alpha / Cell | Edge Rule | Visible Chroma | Components |
|---|---:|---|---|---|---:|---|
| path | 16 | PASS | RGBA / `128x128` | recorded per tile, not object padding | 0 | 1-2 |
| fence | 6 | PASS | RGBA / `256x128` | object edge touch `0` | 0 | 1-2 |
| flower | 6 | PASS | RGBA / `192x160` | object edge touch `0` | 0 | 1-2 |
| home | 9 | PASS | RGBA / `320x256` | object edge touch `0` | 0 | 1 |

Initial normalization review found resized chroma flecks in path/object atlases and multi-component fence / flower patches. The tools now clear visible key-family pixels after resize and allow category-specific component counts while keeping edge-alpha and padding gates strict. This is a proof tooling adjustment, not a runtime approval.

## Candidate Asset Landing

Stable candidate asset paths:

- `assets/art/visual_rebuild/round169/path/path_overlay_tiles_128x128_sheet_v002.png`
- `assets/art/visual_rebuild/round169/path/path_overlay_tiles_128x128_tile_proof_v002.png`
- `assets/art/visual_rebuild/round169/path/path_overlay_tiles_128x128_manifest_v002.json`
- `assets/art/visual_rebuild/round169/path/README.md`
- `assets/art/visual_rebuild/round169/fence/fence_segments_256x128_sheet_v002.png`
- `assets/art/visual_rebuild/round169/fence/fence_segments_256x128_pivot_proof_v002.png`
- `assets/art/visual_rebuild/round169/fence/fence_segments_256x128_manifest_v002.json`
- `assets/art/visual_rebuild/round169/fence/README.md`
- `assets/art/visual_rebuild/round169/flower/flower_patches_192x160_sheet_v002.png`
- `assets/art/visual_rebuild/round169/flower/flower_patches_192x160_pivot_proof_v002.png`
- `assets/art/visual_rebuild/round169/flower/flower_patches_192x160_manifest_v002.json`
- `assets/art/visual_rebuild/round169/flower/README.md`
- `assets/art/visual_rebuild/round169/home/home_components_320x256_sheet_v002.png`
- `assets/art/visual_rebuild/round169/home/home_components_320x256_pivot_proof_v002.png`
- `assets/art/visual_rebuild/round169/home/home_components_320x256_manifest_v002.json`
- `assets/art/visual_rebuild/round169/home/README.md`

## Godot Headless Preview

Script:

```bash
godot --headless --path . --script tests/capture_round169_path_fence_flower_home_preview.gd
```

Output:

- `docs/collaboration/round169_visual_rebuild_same_type_img2img_batches/path_fence_flower_home_pipeline_v002/round169_path_fence_flower_home_godot_preview_1280x720_v002.png`

Composition notes:

- Uses existing tree v002 atlas plus new path / fence / flower / home atlases.
- Home-centered `1280x720` first-screen proof.
- Path runs from Home door toward upper-right town direction.
- Includes 4 trees, 4 fence segments, several flower patches, modest home scale, and open walkable space.
- Includes proof-only glass HUD/footer placeholders without child-facing system text.

## Validation

Commands run:

```bash
godot --headless --editor --path . --quit
python3 -m py_compile scripts/tools/normalize_chroma_grid_sheet.py scripts/tools/normalize_chroma_path_tile_sheet.py
godot --headless --path . --script tests/capture_round169_path_fence_flower_home_preview.gd
godot --headless --path . --script tests/test_v0239_visual_rebuild_blockout.gd
godot --headless --path . --script tests/headless_runner.gd
```

Results:

- Godot import generation passed.
- Preview PNG saved at `1280x720` and passed nonblank pixel sampling.
- `tests/test_v0239_visual_rebuild_blockout.gd` passed.
- `tests/headless_runner.gd` passed.

## Runtime Boundary

These outputs are `normalized_candidate` only. This run intentionally does not create an `AssetResolver` mapping, `ThemeProfile` mapping, live runtime reference, asset approval record, `art_target_locked`, `runtime_visual_match`, or `final_approved` status.
