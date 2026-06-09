# Round169 Tree Prompt-to-Landing Pipeline

Date: 2026-06-08

Scope: tree-only production pipeline test. This run treats AI output as a raw draft, then normalizes it into a fixed-cell Godot-friendly object atlas.

## Goal

Create a repeatable pipeline for same-type tree sprites:

1. Generate a controlled raw AI source sheet.
2. Remove chroma-key background into alpha.
3. Extract each subject from its cell.
4. Normalize into fixed `256x320` canvases.
5. Pack a regular 3x2 sheet for batch slicing.
6. Verify transparency, margins, connected components, and category consistency before scale/pivot review.

## Prompt Lessons

### v001 Result

`round169_tree_ai_raw_sheet_v001.png` produced six good-looking round trees, but the prompt allowed pink variants while the chroma key was `#ff00ff`.

Failure:

- The pink tree conflicted with the magenta key color.
- Chroma cleanup damaged the pink canopy.
- Conclusion: if using chroma-key cleanup, subject color constraints must exclude the key color family.

### v002 Prompt

Use this prompt pattern for the next same-type tree batch:

```text
Use case: stylized-concept.
Asset type: Godot 2D cozy town tree sprite source sheet, raw AI draft for automated cleanup and fixed-cell atlas packing.

Create a controlled 3 columns by 2 rows sprite source sheet containing exactly six isolated complete round broadleaf tree variants for a warm Animal Crossing-like cozy town game for children.

Style: polished hand-painted 2D game sprite, soft rounded leaves, friendly cozy town mood, consistent lighting from upper left, consistent scale and perspective across all six trees.

Canvas and layout: one perfectly flat solid #ff00ff chroma-key background covering the entire image. Arrange six trees in a clean 3x2 grid with large empty magenta gutters between trees. Each tree must be centered in its own equal cell, full body visible, trunk and roots visible, canopy visible, no cropping. Keep generous empty magenta padding around every tree inside its cell.

Subject constraints: all six trees must be the same category: round broadleaf ornamental town trees. Use only leaf colors in green, yellow-green, lime, olive, golden yellow, and warm orange. Small white or yellow flowers are allowed on at most two trees. Do not use pink, purple, blue, cyan, magenta, red, or #ff00ff anywhere in the trees.

Do not include pine trees, willow trees, palm trees, bushes, houses, rocks, fences, signs, animals, characters, shadows, text, labels, watermarks, UI, frames, or partial neighboring sprites.

Transparency preparation: use only the perfectly flat solid #ff00ff background for removal. No cast shadow, no contact shadow, no ground plane, no gradients, no texture in the background.

Quality gate: each tree should read as a single complete sprite with a clear trunk base suitable for a bottom-center pivot in Godot.
```

## Outputs

- Raw AI source: `round169_tree_ai_raw_sheet_v002.png`
- Alpha cleanup source: `round169_tree_ai_raw_sheet_v002_chroma_alpha.png`
- Normalized atlas: `round169_tree_round_objects_256x320_sheet_v002.png`
- Scale / pivot proof: `round169_tree_round_objects_256x320_pivot_proof_v002.png`
- Scale candidates proof: `round169_tree_scale_candidates_1280x720_proof_v002.png`
- Individual normalized sprites: `normalized_256x320_v002/tree_round_01_256x320_v002.png` through `tree_round_06_256x320_v002.png`
- Manifest: `round169_tree_round_objects_256x320_manifest_v002.json`

## Normalization Contract

- Cell size: `256x320`
- Sheet grid: `3x2`
- Pivot: `(128, 300)`
- Placement: bottom-center
- Fit box: max `224x272`
- Required transparent padding:
  - left: at least `16px`
  - right: at least `16px`
  - bottom: `20px`
  - top: variable, but nonzero and visually safe

## Gate Result

`round169_tree_round_objects_256x320_sheet_v002.png` passes the local landing gate:

| Sprite | Size | Margins L/T/R/B | Edge Touch | Components | Gate |
|---|---:|---:|---:|---:|---|
| tree_round_01 | 256x320 | 16 / 37 / 16 / 20 | 0 | 1 | PASS |
| tree_round_02 | 256x320 | 16 / 42 / 16 / 20 | 0 | 1 | PASS |
| tree_round_03 | 256x320 | 16 / 38 / 16 / 20 | 0 | 1 | PASS |
| tree_round_04 | 256x320 | 16 / 37 / 16 / 20 | 0 | 1 | PASS |
| tree_round_05 | 256x320 | 16 / 50 / 16 / 20 | 0 | 1 | PASS |
| tree_round_06 | 256x320 | 16 / 54 / 16 / 20 | 0 | 1 | PASS |

## Godot Landing Notes

Use `round169_tree_round_objects_256x320_sheet_v002.png` as an object atlas candidate, not as a terrain TileSet.

Recommended Godot setup:

- Import: Filter off, Repeat off, Mipmaps off.
- Atlas cell size: `256x320`.
- Pivot per sprite: `(128, 300)` in source pixels.
- Runtime category: `round_broadleaf_tree`.
- Next review: scale/pivot preview in the visual layout scene before any `AssetResolver` or `ThemeProfile` mapping.

This output is a normalized candidate only. It is not `art_target_locked`, not `runtime_visual_match`, and not final approved.

## Scale / Pivot Precheck

`round169_tree_round_objects_256x320_pivot_proof_v002.png` overlays the atlas cell grid, pivot baseline, and bottom-center pivot point.

Precheck result:

| Sprite | Visual Center Delta X | Pivot To BBox Bottom | Result |
|---|---:|---:|---|
| tree_round_01 | 0px | 0px | PASS |
| tree_round_02 | 0px | 0px | PASS |
| tree_round_03 | 0px | 0px | PASS |
| tree_round_04 | 0px | 0px | PASS |
| tree_round_05 | 0px | 0px | PASS |
| tree_round_06 | 0px | 0px | PASS |

Decision: v002 can enter scale / pivot visual review. It should still remain out of runtime mapping until visual-layout preview confirms in-scene scale and occlusion behavior.

## Scale Candidate Review

`round169_tree_scale_candidates_1280x720_proof_v002.png` places all six normalized trees on a proof-only 1280x720 ground view at three candidate display scales.

| Display Scale | Drawn Cell Size | Read |
|---:|---:|---|
| 0.50 | 128x160 | Clear, but slightly small for plaza / home-side decorative trees |
| 0.60 | 154x192 | Best starting point for town object preview |
| 0.70 | 179x224 | Strong foreground tree size; likely too dominant for dense first-screen placement |

Recommendation: start the next visual-layout preview at display scale `0.60`, then compare `0.55-0.62` once houses, paths, player, and A-Z anchors are visible in the same frame.

## Reusable Tool

The normalization step is now codified as:

```bash
python3 scripts/tools/normalize_chroma_grid_sheet.py \
  docs/collaboration/round169_visual_rebuild_same_type_img2img_batches/tree_pipeline_test_v001/round169_tree_ai_raw_sheet_v002.png \
  --output-dir docs/collaboration/round169_visual_rebuild_same_type_img2img_batches/tree_pipeline_test_v001/tool_normalized_v002 \
  --columns 3 \
  --rows 2 \
  --key-color ff00ff \
  --key-family magenta \
  --cell-width 256 \
  --cell-height 320 \
  --fit-width 224 \
  --fit-height 272 \
  --pivot-x 128 \
  --pivot-y 300 \
  --min-margin 16 \
  --min-bottom-margin 20 \
  --item-prefix tree_round
```

Tool output:

- `tool_normalized_v002/round169_tree_ai_raw_sheet_v002_256x320_atlas.png`
- `tool_normalized_v002/round169_tree_ai_raw_sheet_v002_256x320_pivot_proof.png`
- `tool_normalized_v002/round169_tree_ai_raw_sheet_v002_256x320_manifest.json`
- `tool_normalized_v002/normalized_256x320/tree_round_01_256x320.png` through `tree_round_06_256x320.png`

Validation:

- `python3 -m py_compile scripts/tools/normalize_chroma_grid_sheet.py`
- `git diff --check -- scripts/tools/normalize_chroma_grid_sheet.py docs/collaboration/round169_visual_rebuild_same_type_img2img_batches/tree_pipeline_test_v001/Round169_tree_prompt_to_landing_report.md`

Result: tool-normalized v002 overall gate is `pass`, with all six items marked `pass`.

## Candidate Asset Landing

The passing v002 atlas has been copied into a stable candidate asset directory:

- `assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_sheet_v002.png`
- `assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_pivot_proof_v002.png`
- `assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_manifest_v002.json`
- `assets/art/visual_rebuild/round169/trees/normalized_256x320/tree_round_01_256x320_v002.png` through `tree_round_06_256x320_v002.png`
- `assets/art/visual_rebuild/round169/trees/README.md`

This is an asset-tree landing only. It intentionally does not create an `AssetResolver` mapping, `ThemeProfile` mapping, runtime scene reference, or approval record.

The asset-tree manifest is self-contained for downstream proof tooling:

- `atlas` points to `assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_sheet_v002.png`.
- `pivot_proof` points to `assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_pivot_proof_v002.png`.
- each `normalized_png` points to `assets/art/visual_rebuild/round169/trees/normalized_256x320/`.
- raw source and tool-normalized docs paths are kept only as provenance.

Godot import sidecars were generated with:

```bash
godot --headless --editor --path . --quit
```

Relevant `tree_round_objects_256x320_sheet_v002.png.import` settings:

- `compress/mode=0`
- `mipmaps/generate=false`
- `process/fix_alpha_border=true`
- `process/premult_alpha=false`

## Godot Headless Preview

A standalone proof script now verifies that Godot can load the candidate atlas, crop `256x320` regions, apply display scale `0.60`, and place each sprite by the bottom-center pivot.

Script:

```bash
godot --headless --path . --script tests/capture_round169_tree_candidate_preview.gd
```

Output:

- `docs/collaboration/round169_visual_rebuild_same_type_img2img_batches/tree_pipeline_test_v001/round169_tree_godot_preview_1280x720_v002.png`

Result:

- Godot 4.6.3 loads `assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_sheet_v002.png`.
- Region slicing uses `256x320` cells.
- Display scale is `0.60`.
- Pivot baseline remains visually stable across all six tree variants.
- This is a proof-only capture, not a runtime scene and not an approval gate.
