# Round177 NPC Feedback Emotes

Proof-only overhead NPC feedback / emote bubble candidates for V02.39 visual rebuild.

## Boundary

- No runtime mapping.
- No ThemeProfile, AssetResolver, data, shared test, todo, lesson, or docs changes.
- No readable text, letters, numbers, or harsh punctuation marks inside the sprites.
- Final PNGs are transparent 192x192 candidates for review only.

## Files

- `raw/`: local generator outputs from `/home/xionglei/GameProject/tools/image_generator.js`.
- `normalized_192x192/`: alpha-safe transparent proof candidates.
- `proof/round177_npc_feedback_emotes_contact_sheet.png`: checkerboard proof sheet.
- `manifest.json`: item metadata, validation checks, risks, UI layer/offset/opacity recommendations.

## Validation

Run from repository root:

```bash
bash assets/art/visual_rebuild/round177/npc_feedback_emotes/generate_assets.sh
python3 assets/art/visual_rebuild/round177/npc_feedback_emotes/normalize_validate_manifest.py
```

Per LESSON-019 and LESSON-022, raw generator transparency is not trusted; the manifest gate is based on local RGBA alpha checks for transparent corners, alpha holes, residue, and background block risk.
