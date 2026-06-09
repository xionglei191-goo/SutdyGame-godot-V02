# Round174 NPC Full-Body Standing Candidates

Status: `normalized_candidate_proof_only`

Proof-only full-body standing NPC / companion sprite candidates for visual review. These are not mapped into `AssetResolver`, `ThemeProfile`, runtime, data, or tests.

## Contract

- Cell size: `160x192`
- Baseline: `y=176`
- Pivot: `[80, 176]`
- Pose: soft `3/4` front standing
- Style intent: original cozy town life-sim, warm and child-facing, not storybook/card UI
- Embedded text: none intended

## Files

- `source_prompts.json`
- `raw_chroma/*_raw.png`
- `normalized_160x192/*_160x192.png`
- `round174_npc_fullbody_160x192_atlas_v001.png`
- `proof/round174_npc_fullbody_checker_proof_v001.png`
- `round174_npc_fullbody_manifest_v001.json`

## Validation

Run from repo root:

```bash
python3 assets/art/visual_rebuild/round174/npc_fullbody/normalize_and_manifest.py
python3 -m json.tool assets/art/visual_rebuild/round174/npc_fullbody/round174_npc_fullbody_manifest_v001.json >/dev/null
```

The manifest gate includes `visual_background_block_count`; `overall_gate` must remain `pass` only when this count is `0`.

## Runtime Boundary

Do not map these files into runtime until a later visual-layout gate explicitly approves them. These assets are not `art_target_locked`, not `runtime_visual_match`, and not final approved.
