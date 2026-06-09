# Round173 UI Icons Proof Pack

Proof-only Apple-like translucent glass-compatible UI icon candidates.

- Category: `ui_icon`
- Runtime boundary: `candidate_only_no_asset_resolver_or_themeprofile_mapping`
- Atlas: `assets/art/visual_rebuild/round173/ui_icons/round173_ui_icons_atlas_5x2_128.png`
- Proof: `assets/art/visual_rebuild/round173/ui_icons/round173_ui_icons_proof_1280x720.png`
- Manifest: `assets/art/visual_rebuild/round173/ui_icons/round173_ui_icons_manifest.json`
- Raw chroma-key source: `docs/collaboration/round173_visual_rebuild_asset_generation/ui_icons/round173_ui_icons_raw_sheet_chromakey_magenta.png`

The raw sheet uses `#ff00ff` chroma key, not a white background. Normalized icons are transparent 128x128 PNGs and are packed into a fixed 5x2 atlas. These files are candidates only and are not mapped through `ThemeProfile` or `AssetResolver`.

Known risk: glossy icon highlights are preserved after chroma-key cleanup, but final use on real glass HUD/buttons still needs alpha-edge review on gameplay backgrounds before any runtime mapping.
