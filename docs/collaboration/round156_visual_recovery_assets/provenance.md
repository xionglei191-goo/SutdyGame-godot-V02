# Round156 Visual Recovery Asset Pack Provenance

Date: 2026-06-07
Task: V02-VISUALRECOVERY-003 first-screen unified modular asset pack
Worker: Asset / Tech Art

## Scope

This pack is a modular 1280x720 Sunshine Town first-screen asset set. It does not include a full-map background. The original asset-only handoff did not wire runtime data; the parent integration now maps the pack through `ThemeProfile` / `AssetResolver` using the logical IDs below.

The pack follows the V02.38 visual recovery constraints:

- Cozy, child-friendly 2.5D town art inspired by life-sim friendliness without copying external IP.
- Prop-first A-Z anchor expression. The apple, clock, and Sunny corner assets are world props, not naked letter tiles.
- Apple-like translucent glass for HUD and footer surfaces.
- No course panels, score/test/check-in UI, word walls, full-map background, or large letter plaques.

## Generation

Built-in image generation was not exposed in the current Codex tool list, so the project-approved fallback script was used:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "<prompt>" assets/art/visual_recovery/source/round156_generated_style_source_1280.png 1280x720
```

Source image:

- `res://assets/art/visual_recovery/source/round156_generated_style_source_1280.png`
- Dimensions: 1280x720
- Role: visual source sheet for cozy-town shapes, material cues, prefabs, and props.

Post-processing:

- PIL RGBA processing for deterministic asset sizes.
- Generated-source crops for building and prop prefabs.
- Deterministic painted RGBA output for terrain tiles, region chunks, unified shadow, and glass UI.
- Background matte removal plus small disconnected-component cleanup on generated-source cutouts.
- Contact sheet rebuilt from final PNGs after cleanup.

Contact sheet:

- `docs/collaboration/round156_visual_recovery_assets/round156_visual_recovery_contact_sheet_v001.png`
- Dimensions: 864x878
- Contents: 16 final PNGs, including `region.school_line.chunk`.

## Asset Manifest

| Logical asset ID | Path | Dimensions | Notes |
|---|---|---:|---|
| `terrain.grass.soft_tile` | `res://assets/art/visual_recovery/terrain/terrain_grass_tile_v001.png` | 256x256 | RGBA terrain tile, edge-to-edge top surface with alpha canvas. |
| `terrain.path.soft_tile` | `res://assets/art/visual_recovery/terrain/terrain_path_tile_v001.png` | 256x256 | RGBA sandy path terrain tile. |
| `terrain.plaza.warm_tile` | `res://assets/art/visual_recovery/terrain/terrain_plaza_tile_v001.png` | 256x256 | RGBA pale stone plaza tile. |
| `region.town_plaza.chunk` | `res://assets/art/visual_recovery/regions/region_town_plaza_chunk_v001.png` | 640x384 | Modular plaza chunk with circular pavers, bench, lamp, and planters. |
| `region.home.edge_chunk` | `res://assets/art/visual_recovery/regions/region_home_edge_chunk_v001.png` | 560x360 | Home-edge ground chunk with yard path, fence, mailbox, and shrubs. |
| `region.shop_street.chunk` | `res://assets/art/visual_recovery/regions/region_shop_street_chunk_v001.png` | 640x360 | Shop-street ground chunk with pavers, awning pads, crates, and planters. |
| `region.school_line.chunk` | `res://assets/art/visual_recovery/regions/region_school_line_chunk_v001.png` | 640x360 | School-line ground chunk with soft arrival path and child-safe school-yard cues. |
| `building.home.cottage` | `res://assets/art/visual_recovery/buildings/building_home_prefab_v001.png` | 384x300 | Generated-source prefab crop, transparent background. |
| `building.shop.market` | `res://assets/art/visual_recovery/buildings/building_shop_prefab_v001.png` | 420x300 | Generated-source shop prefab crop, transparent background. |
| `building.school.gate` | `res://assets/art/visual_recovery/buildings/building_school_gate_prefab_v001.png` | 512x300 | Generated-source school gate prefab crop, transparent background. |
| `world_prop.anchor.apple_basket` | `res://assets/art/visual_recovery/props/prop_apple_basket_anchor_v001.png` | 256x220 | Prop-first Apple anchor, no letter plaque. |
| `world_prop.anchor.clock_corner` | `res://assets/art/visual_recovery/props/prop_clock_corner_anchor_v001.png` | 220x300 | Prop-first Clock anchor, no letter plaque. |
| `world_prop.home.sunny_corner` | `res://assets/art/visual_recovery/props/prop_sunny_corner_v001.png` | 420x280 | Cozy pet/Sunny corner prop cluster for home-edge layering. |
| `soft_shadow.oval.default` | `res://assets/art/visual_recovery/ui/soft_oval_shadow_v001.png` | 256x128 | Unified soft oval contact shadow for prefabs and actors. |
| `glass_hud_bar` | `res://assets/art/visual_recovery/ui/glass_hud_strip_v001.png` | 1024x144 | Translucent glass top HUD strip through `ui_skin`. |
| `glass_footer_bar` | `res://assets/art/visual_recovery/ui/glass_footer_dock_v001.png` | 1024x176 | Translucent glass footer dock through `ui_skin`. |

## Suggested Integration

Runtime integration remains for a Godot / Tech Art worker with broader write ownership:

- Logical IDs above are mapped in `data/themes/theme_sunshine_town_placeholder.json` and resolved by `AssetResolver`.
- Compose first-screen layers from terrain tiles, region chunks, soft shadows, prefabs, and props instead of `world_map_base_1280.png`.
- Recommended draw order: terrain tiles, region chunk, soft oval shadow, building prefab, prop anchors, actors, HUD glass, footer glass.
- Generate Godot `.import` metadata during integration, not in this asset-only pass.

## Validation

- Final PNGs were checked as RGBA files with fixed dimensions.
- Contact sheet was visually inspected after cleanup.
- `git diff --check` passed.
- Godot headless was not run because this pass is asset-only and current write ownership excludes runtime/data integration and import-cache churn.
