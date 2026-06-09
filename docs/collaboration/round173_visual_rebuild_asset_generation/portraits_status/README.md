# Round173 Portraits / Status Proof Pack

Proof-only character and pet portrait/status candidates for the V02.39 visual rebuild.

## Scope

- Category: `character_pet_portrait_status`
- Runtime boundary: `candidate_only_no_asset_resolver_or_themeprofile_mapping`
- Basis: `docs/10_美术风格与换肤预留.md` V02-ART-003 character and Sunny list
- Write scope used: `assets/art/visual_rebuild/round173/portraits_status/` and `docs/collaboration/round173_visual_rebuild_asset_generation/portraits_status/`
- No runtime, ThemeProfile, AssetResolver, data, or tests were modified.

## Deliverables

- Manifest: `assets/art/visual_rebuild/round173/portraits_status/round173_portraits_status_manifest.json`
- Atlas: `assets/art/visual_rebuild/round173/portraits_status/round173_portraits_status_atlas_192x192.png`
- Proof: `assets/art/visual_rebuild/round173/portraits_status/round173_portraits_status_proof_192x192.png`
- Normalized PNGs: `assets/art/visual_rebuild/round173/portraits_status/normalized_png/`
- Raw chroma-key sheet: `docs/collaboration/round173_visual_rebuild_asset_generation/portraits_status/round173_portraits_status_raw_chroma_ff00ff_sheet.png`
- Validation report: `docs/collaboration/round173_visual_rebuild_asset_generation/portraits_status/round173_portraits_status_validation_report.json`
- Build/validation script: `docs/collaboration/round173_visual_rebuild_asset_generation/portraits_status/tools/build_portraits_status_pack.py`

## Candidates

1. `player_portrait` -> `character.player.portrait`
2. `mina_portrait` -> `character.mina.portrait`
3. `mina_happy` -> `character.mina.happy`
4. `shopkeeper_portrait` -> `character.shopkeeper.portrait`
5. `sunny_portrait` -> `pet.sunny.portrait`
6. `sunny_happy` -> `pet.sunny.happy`
7. `sunny_waiting` -> `pet.sunny.waiting`
8. `story_bear_portrait` -> `character.story_bear.portrait`

## Generation And Processing

Raw candidates were generated with:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "<candidate prompt>" docs/collaboration/round173_visual_rebuild_asset_generation/portraits_status/raw/<candidate>_raw.png 512x512
```

The prompts requested a flat `#ff00ff` chroma-key background, no text, no watermark, no shadows, and no magenta in the subject. One earlier 1024x1024 request and one Sunny waiting retry returned empty API data; the successful final raw set uses 512x512 source PNGs.

Final processing command:

```bash
python3 docs/collaboration/round173_visual_rebuild_asset_generation/portraits_status/tools/build_portraits_status_pack.py
```

## Gate

Overall gate: `pass`

Gate criteria: every normalized PNG must be fixed `192x192`, have an alpha channel, have a non-empty alpha bbox, and have `visible_key_pixels=0`.

Identity risk: `sunny_waiting` has a slight pointy-ear fox/cat read compared with Sunny portrait/happy. It remains a proof candidate only and should be regenerated or cleaned up before any production mapping.
