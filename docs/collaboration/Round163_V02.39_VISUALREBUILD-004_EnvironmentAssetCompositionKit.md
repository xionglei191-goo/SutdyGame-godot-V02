# Round163 V02.39 VISUALREBUILD-004 Environment Asset Composition Kit

> Date: 2026-06-07
> Task: `V02-VISUALREBUILD-004 首屏统一环境资产包与 composition kit`
> Owner: Art Direction / Asset / Tech Art
> Scope: document-only specification. No runtime, data, test, or asset files were generated or modified in this pass.
> Status note: 2026-06-07 user review rejected the Round161 target PNG as not the desired game screen. This document is retained as a future checklist only; it must not be used to start asset production until `V02-VISUALREBUILD-002` is reworked and `art_target_locked` is explicitly restored.

## 1. Inputs Read

- `todo.md`: `V02-VISUALREBUILD-004` requires a first-screen environment asset kit covering terrain, region, building, prop, shadow, actor scale, and glass UI, with one camera, one light model, one scale system, one perspective, complete logical asset IDs, and no old scene fragment mixing.
- `docs/collaboration/artpass003_visual_direction/`:
  - `artpass003_main_gameplay_direction_1280.png`: home-centered cozy town gameplay frame, with School / Shop / Animal Park / Coast cues, readable paths, and glass HUD relationship.
  - `artpass003_glass_ui_direction_1280.png`: Apple-like translucent glass top HUD, footer, light panels, backpack / album / shop surfaces.
  - `artpass003_character_anchor_direction_1280.png`: actor, Sunny, NPC, and A-Z anchor object scale; anchors are life props first, not letter cards.
- Existing file inventories under:
  - `assets/art/visual_recovery/**`
  - `assets/art/story_props/**`
  - `assets/art/characters/animation/**`
  - `assets/art/pets/animation/**`
- `data/themes/theme_sunshine_town_placeholder.json`: current `terrain_tile_assets`, `region_chunk_assets`, `building_prefab_assets`, `world_prop_assets`, `soft_shadow_assets`, `story_prop_assets`, `character_animation_assets`, `pet_animation_assets`, `animation_metadata_assets`, `ui_skin`, and `asset_acceptance`.

## 2. Target Frame Composition Kit

This kit is for the first 1280x720 runtime frame after `art_target_locked`. It is not a full map. It is a layered composition kit that lets TownStage match the target frame before gameplay binding expands.

Because the Round161 target PNG has been rejected, the concrete asset list below is not yet a production order. It becomes actionable only after a new target gameplay frame is approved.

| Kit part | Required deliverables | First-screen use | Notes |
|---|---|---|---|
| Terrain | grass base, main path, plaza ground, soft grass-path edge, light decals | Establish warm readable ground under Home and town entry | Current IDs may be reference only until target-frame match proves they share the same camera and palette. |
| Depth bands / regions | back skyline / far cues, mid home yard, mid plaza, side shop street, side school line, foreground path edge | Replace data-grid-looking map with staged depth bands | Regions must be composable strips or chunks, not old place screenshots. |
| Home prefab | centered cottage exterior with door, stoop, yard edge, mailbox / welcome detail slot | Main first-viewport signal and navigation anchor | Home is the scale anchor for all other buildings. |
| Shop distant cue | small shop facade or awning cue behind / side of main path | Shows town routine destination without becoming first-screen focus | Must read as reachable but secondary. |
| School distant cue | school gate / soft sign / yard-color cue in upper or side band | Keeps A-Z G/K/N/R/Y route present as distant routine | Must not look like classroom, test gate, or blocked entrance. |
| Paths | main curved path, home door connection, branch to shop, branch to school | Guides child movement without visible grid or arrows | Path edges need soft alpha and no tile seams. |
| Props | A/C/D/W/T home props, low shrubs, mailbox, flowers, bench, small resource cue | Prop-first memory palace and lived-in density | A-Z props must be environment objects before labels. |
| Actor scale | player, Sunny, one optional resident silhouette / idle pose | Confirms walkable scale and friendliness | Actor feet baseline must align with paths and contact shadows. |
| Shadows | shared oval actor shadows, building contact shadows, prop contact shadows | Unifies depth without hard black outlines | Prefer separate shadow assets or metadata-driven shadows, not baked inconsistent shadows. |
| Glass UI slices | top HUD strip, footer dock, prompt bubble, small / large panel slices, icon button states | Keeps UI in artpass003 glass direction while preserving touch paths | Slices need 9-patch margins or equivalent stretch metadata. |

### Layer Order

```text
camera background color
far depth band / distant cues
terrain base
path and terrain edges
region chunks
building shadows
building prefabs
prop shadows
world props / prop-first A-Z anchors
actor shadows
actors / Sunny / NPCs
near foreground accents
prompt feedback
glass HUD / footer
modal glass panels
```

## 3. Unified Production Rules

| Rule | Requirement |
|---|---|
| Same camera | All world assets must be produced for the same light 2.5D orthographic camera. No mixed front-view cutouts, flat map icons, or side-view props in the target frame. |
| Same light source | Use one soft daylight direction, assumed upper-left / front-left unless the locked target frame says otherwise. Highlights and cast shadows must agree. |
| Same scale | Player height is the runtime scale ruler. Home should feel about 3.2-4.0x player height; shop and school cues are slightly secondary unless target frame foregrounds them. |
| Same perspective | Ground ellipses, roof angles, doors, windows, and prop tops must share the same tilt. No top-down tile mixed with frontal building collage. |
| Transparent edges | PNGs need clean RGBA edges, no matte halo, no leftover generated background, no hard crop rectangle. Alpha fringe must be checked on both grass and path backgrounds. |
| Shadow strategy | Contact shadows are separate reusable assets or explicitly documented baked shadows. Do not stack multiple unrelated shadow styles in one frame. |
| Pivot / feet baseline | Every prefab, prop, actor, and pet sheet needs a documented ground contact pivot. Actor and Sunny feet baselines must align to walkable paths, not sprite centers. |
| Naming | File names use lowercase snake_case with role, object, variant, and version, e.g. `building_home_cottage_day_v002.png`. Logical IDs use lowercase dot paths and omit version. |
| Logical asset ID | Every production candidate must have one stable logical ID before runtime binding. Runtime requests IDs through `AssetResolver`; no hardcoded `res://assets/...` in runtime code. |
| Child-safe content | No course panel, score, test, timer, check-in, danger color, strong consumer pressure, debug text, grid, coordinate, or large letter-card visual. |

## 4. Current Asset Classification

`production` in the current theme means "can be integrated or has been integrated before." It does not mean V02.39 approved. The target/runtime side-by-side gate must rejudge all assets.

### 4.1 Keep As Candidate, Recheck In Target Frame

These assets have useful modular roles and logical mappings, but remain `visual_scaffold` candidates until same-camera / same-light / same-scale review passes:

| Group | Current assets / IDs | Reason |
|---|---|---|
| Terrain scaffold | `terrain.grass.soft_tile`, `terrain.path.soft_tile`, `terrain.plaza.warm_tile` | Useful low-level terrain set; must verify tile seams, perspective, and palette against locked target. |
| Region scaffold | `region.home.edge_chunk`, `region.town_plaza.chunk`, `region.shop_street.chunk`, `region.school_line.chunk` | Good modular category shape; must not dictate final composition if target frame changes depth bands. |
| Building scaffold | `building.home.cottage`, `building.shop.market`, `building.school.gate` | Useful prefab candidates; must verify consistent camera and Home-centered scale. |
| World prop scaffold | `world_prop.anchor.apple_basket`, `world_prop.anchor.clock_corner`, `world_prop.home.sunny_corner` | Prop-first direction is correct; needs full A-Z scale and placement review. |
| Shadow scaffold | `soft_shadow.oval.default` | Keep as common shadow candidate; may need size variants and metadata. |
| Glass HUD / footer | `glass_hud_bar`, `glass_footer_bar` | Directionally aligned with translucent UI; needs slice margins and target-frame occlusion check. |
| Motion sheets | `anim_sheet.player.p0_motion`, `anim_sheet.pet.sunny.p0_motion` plus metadata | Keep as actor-scale candidates; must verify feet baseline in the target composition. |

### 4.2 Reference Only

These may inform color, story, or previous validation, but must not become automatic target-frame assets:

| Group | Assets | Use |
|---|---|---|
| Artpass003 images | three PNGs under `docs/collaboration/artpass003_visual_direction/` | Visual direction reference only; not runtime assets and not production. |
| Round156 source sheet | `assets/art/visual_recovery/source/round156_generated_style_source_1280.png` | Provenance / style source only; not a final runtime background. |
| Full-map base | `place.world_map.base_1280` / `assets/art/places/world_map_base_1280.png` | Reference and legacy comparison only; banned as final runtime main image. |
| Old place screenshots | `place.home.yard`, `place.shop_street.day`, `place.school_gate.exterior`, `place.town_plaza.day`, etc. | May preserve old functional routes, but not first-screen visual composition. |
| Earlier approval screenshots | Round95-Round159 proof PNGs | Evidence history only; old `approved` is not V02.39 `final_approved`. |

### 4.3 Needs Redo Or New Production

| Need | Why |
|---|---|
| Final target terrain and edge set | Current tiles exist, but the target frame needs unified path curvature, soft edges, and depth-band color hierarchy. |
| Home-centered depth-band kit | Existing chunks are region chunks, not a locked first-screen composition kit with far / mid / near bands. |
| Distant shop and school cue variants | Current building prefabs may be too foreground-like; first screen needs secondary-distance cues. |
| Full A-Z prop-first scale set | Only a few visual recovery props exist; 26 anchors need consistent prop scale and revisit placement. |
| Shadow size variants | One oval default is not enough for Home, buildings, props, player, Sunny, NPC, and foreground objects. |
| Glass UI 9-slice / state kit | Current HUD/footer PNGs exist; target kit needs documented stretch margins, prompt bubble, panel slices, button states, and disabled / pressed behavior. |
| Story props for first screen | Existing story props are inventory candidates, but style, scale, and perspective vary by batch; do not place them into the target frame until re-authored or explicitly matched. |

### 4.4 Do Not Mix Into First Screen

- Old scene fragments, old place art chunks, or full-map base pieces used as background.
- `world_map_base_1280.png` or any replacement that behaves like a full-map base.
- Style-inconsistent inventory story props from `assets/art/story_props/**` unless a new contact sheet proves same camera, light, scale, and perspective.
- Naked letter cards, large badge boards, lesson panels, word walls, course icons, or test / score UI.

## 5. AssetResolver / ThemeProfile Field Suggestions

Keep current mappings as compatibility fields, but add V02.39-specific composition metadata so runtime can compose a target frame without deriving visuals from `world_map` cells.

```json
{
  "visual_layout_profiles": {
    "sunshine_town.first_screen.v001": {
      "target_frame_id": "target.sunshine_town.first_screen.1280.v001",
      "camera_profile_id": "camera.cozy_2_5d.first_screen.v001",
      "light_profile_id": "light.soft_day_upper_left.v001",
      "composition_size": [1280, 720],
      "safe_area": {
        "hud_top_px": 76,
        "footer_bottom_px": 112
      },
      "layers": []
    }
  },
  "composition_kit_assets": {
    "terrain.first_screen.grass_base": "res://...",
    "depth_band.first_screen.far_town": "res://...",
    "region.first_screen.home_mid": "res://...",
    "building.first_screen.home_cottage": "res://...",
    "cue.first_screen.shop_distant": "res://...",
    "cue.first_screen.school_distant": "res://...",
    "path.first_screen.main_curve": "res://...",
    "shadow.actor.oval_small": "res://...",
    "glass_ui.hud.slice_compact": "res://..."
  },
  "asset_layout_metadata": {
    "building.first_screen.home_cottage": {
      "pivot": "feet_baseline",
      "pivot_px": [192, 286],
      "baseline_y_px": 286,
      "nominal_scale": 1.0,
      "shadow_asset_id": "shadow.building.home_soft",
      "footprint_cells": [[0, 0], [1, 0], [2, 0]],
      "occlusion_policy": "may_occlude_actor_behind_only"
    }
  },
  "glass_ui_slice_metadata": {
    "glass_ui.hud.slice_compact": {
      "nine_patch_margins_px": [36, 24, 36, 24],
      "min_size_px": [520, 64],
      "states": ["normal"]
    }
  }
}
```

Recommended category migration:

| Existing category | V02.39 suggested category | Notes |
|---|---|---|
| `terrain_tile_assets` | keep plus `composition_kit_assets` references | Tiles remain useful, but target frame should bind composed paths / bands by logical ID. |
| `region_chunk_assets` | `depth_band_assets` and `region_composition_assets` | Separate far / mid / near staging from generic chunks. |
| `building_prefab_assets` | keep, add `building_layout_metadata` | Prefab path alone is insufficient; pivot, shadow, footprint, and scale are required. |
| `world_prop_assets` / `story_prop_assets` | `world_prop_assets` plus `prop_layout_metadata` | Story props enter only after style match and provenance. |
| `soft_shadow_assets` | `shadow_assets` | Needs multiple sizes and intended receiver types. |
| `ui_skin` | `glass_ui_assets` plus slice metadata | Backward compatible with existing UI skin. |
| `character_animation_assets` / `pet_animation_assets` | keep, add actor baseline metadata | Metadata must include baseline / contact shadow relation. |

## 6. Acceptance, Contact Sheet, And Provenance Requirements

Every new V02.39 asset batch must submit:

| Evidence | Requirement |
|---|---|
| Contact sheet | One sheet per batch, showing transparent checker or neutral background, asset name, logical ID, dimensions, and baseline / pivot marker for world objects. |
| Target-frame mock | A 1280x720 composed still using only the batch plus approved reference layers; must show HUD/footer safe areas. |
| Runtime proof | Later Godot pass must provide 1280 runtime screenshot side-by-side with target frame before `runtime_visual_match`. |
| Provenance | Prompt or source method, tool used, date, worker, source references, post-processing notes, and whether the asset is generated, painted, cropped, or deterministic. |
| Metadata | Dimensions, pivot, baseline, scale ratio to player, shadow ID, intended layer, safe occlusion rule, logical asset ID, and resource path. |
| Acceptance record | `record_id`, `logical_asset_id`, `category`, `object_id`, `status`, `resource_path_for_mapping`, `replacement_target`, `viewport_evidence`, `screenshot_area`, `acceptance_result`, `notes_child_safety`, `notes_anchor_integrity`, plus V02.39 fields below. |

Suggested V02.39 acceptance additions:

```json
{
  "target_frame_id": "target.sunshine_town.first_screen.1280.v001",
  "composition_kit_id": "composition.sunshine_town.first_screen.v001",
  "camera_profile_id": "camera.cozy_2_5d.first_screen.v001",
  "light_profile_id": "light.soft_day_upper_left.v001",
  "scale_profile_id": "scale.player_baseline.v001",
  "perspective_match_result": "pass|needs_fix",
  "transparent_edge_result": "pass|needs_fix",
  "pivot_baseline_result": "pass|needs_fix",
  "shadow_consistency_result": "pass|needs_fix",
  "provenance_doc": "docs/collaboration/<batch>/provenance.md",
  "contact_sheet": "docs/collaboration/<batch>/<contact_sheet>.png",
  "approval_semantics": "production_is_not_final_approved"
}
```

Status rule:

- `production`: asset can be mapped and tested.
- `visual_scaffold`: layer exists but does not yet match target.
- `art_target_locked`: target frame and layout contract approved, not individual asset approval.
- `runtime_visual_match`: runtime screenshot sufficiently matches target.
- `final_approved`: same-round proof, real entry, child safety, A-Z integrity, and PM / Art Direction approval all pass.

No asset may jump from `production` to `final_approved` without side-by-side evidence.

## 7. First-Screen Forbidden Remnants

The following are explicitly banned from the V02.39 first-screen composition kit:

- Old `scene fragment` pieces cropped from previous maps, panels, or screenshots.
- `place.world_map.base_1280`, `world_map_base_1280.png`, or any full-map base replacement.
- Whole old `place_assets` used as the primary visual ground.
- Style-inconsistent `assets/art/story_props/**` inventory props placed into the target frame without a new contact sheet and perspective proof.
- Big letter boards, word drill cards, curriculum panels, score / test / check-in UI, grid labels, cell coordinates, debug overlays.
- Mixed shadows, mixed camera angles, mixed outline styles, matte halos, and props with incompatible baseline.

## 8. Handoff Conclusion

V02.39 should treat the existing visual recovery pack as a useful modular scaffold, not as final art. The immediate art / tech-art handoff is to produce or select a unified first-screen composition kit from the locked target frame, then map every piece through logical asset IDs with camera, light, scale, perspective, pivot, baseline, shadow, slice, contact sheet, and provenance evidence.

The safest production posture is: keep the current modular categories, re-author the first-screen target kit around Home-centered composition, and block all old full-map / scene-fragment / mismatched story-prop material until side-by-side proof says it belongs.
