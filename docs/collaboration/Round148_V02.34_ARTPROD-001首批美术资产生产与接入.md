# Round148 V02.34 ARTPROD-001 首批美术资产生产与接入

> 日期：2026-06-07
> 任务：`V02-ARTPROD-001 首批美术资产生产与接入`
> 状态：完成
> 下一轮 Ready：`V02-RUNTIME-ANIM-001 动作操控运行时纵切`

## 本轮交付

本轮将 Round147 的接入规范转为首批可验证 production 资产和工程合同。范围仍限定在资产、metadata、ThemeProfile / AssetResolver、Map Editor story prop marker 和验证测试；不把 production 自动标为 approved，不做 960x540 适配，不重写孩子端主循环。

新增资产：

- `assets/art/story_props/home/apple_welcome_photo_v001.png`
- `assets/art/story_props/school/school_yard_net_robot_yoyo_corner_v001.png`
- `assets/art/story_props/shop/hat_ribbon_window_v001.png`
- `assets/art/story_props/plaza/bear_book_branch_bookmark_v001.png`
- `assets/art/characters/animation/player_p0_motion_v001.png`
- `assets/art/pets/animation/sunny_p0_motion_v001.png`
- `assets/art/ui/feedback/prompt_soft_glow_v001.png`
- `assets/art/ui/feedback/collect_sparkle_soft_v001.png`
- `assets/art/ui/feedback/tap_ripple_soft_v001.png`
- `assets/art/tiles/edges/grass_path_soft_v001.png`

新增 metadata / data：

- `assets/art/characters/animation/metadata/player_p0_motion_v001.json`
- `assets/art/pets/animation/metadata/sunny_p0_motion_v001.json`
- `data/life/story_props.json`

## 2026-06-07 Round141-151 图片来源返修

用户复核要求：核查 Round141-151 生成图片，并全部改为生图脚本重新生成。

核查结论：

- Round141-147 为路线、故事、动作、操控和接入规范文档轮次，未落 bitmap PNG。
- Round148 是 Round141-151 中唯一实际新增 bitmap PNG 的轮次，共 10 张。
- Round149-151 只消费、运行时接入或规划这些资产，未新增 bitmap PNG。

返修动作：

- 已使用本地生图脚本 `/home/xionglei/GameProject/tools/image_generator.js` 对 Round148 的 10 张 PNG 全量重新 text-to-image 生成。
- 源图临时落点：`tmp/imagegen_round148_regen/*_source.png`。
- 透明资产经 chroma-key 后处理并缩回原合同尺寸；`grass_path_soft_v001.png` 保持不透明 tile edge。
- 二次目检接触表：`tmp/imagegen_round148_regen/regen_contact_sheet_v3.png`。
- `player_p0_motion_v001.png` 初次重生后在深色背景不可读，已单独重生并重新后处理。

返修覆盖资产：

- `assets/art/story_props/home/apple_welcome_photo_v001.png` -> 96x96 RGBA
- `assets/art/story_props/school/school_yard_net_robot_yoyo_corner_v001.png` -> 192x128 RGBA
- `assets/art/story_props/shop/hat_ribbon_window_v001.png` -> 128x128 RGBA
- `assets/art/story_props/plaza/bear_book_branch_bookmark_v001.png` -> 160x128 RGBA
- `assets/art/characters/animation/player_p0_motion_v001.png` -> 256x256 RGBA
- `assets/art/pets/animation/sunny_p0_motion_v001.png` -> 256x192 RGBA
- `assets/art/ui/feedback/prompt_soft_glow_v001.png` -> 96x96 RGBA
- `assets/art/ui/feedback/collect_sparkle_soft_v001.png` -> 384x64 RGBA
- `assets/art/ui/feedback/tap_ripple_soft_v001.png` -> 576x96 RGBA
- `assets/art/tiles/edges/grass_path_soft_v001.png` -> 96x32 RGB

补记：本轮返修只替换同名 production PNG，不改 logical asset ID、ThemeProfile / AssetResolver 映射、story prop 数据、motion metadata 或 runtime 行为；production 仍不自动等同 approved。

返修验证：

- `identify -format '%f %wx%h %[channels]\n' ...`：10 张 PNG 尺寸符合原合同；9 张透明资产为 RGBA，tile edge 为 RGB。
- `godot --headless --path . --script tests/test_asset_resolver.gd`
- `godot --headless --path . --script tests/test_v0234_artprod001_asset_integration.gd`
- `godot --headless --path . --script tests/test_v0235_runtime_anim_controls.gd`
- `godot --headless --path . --script tests/test_v0236_storyslice001_runtime.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`
- `git diff --check`

以上均通过。

## 工程接入

- `ThemeProfileResource` 新增 `tile_edge_assets`、`story_prop_assets`、`character_animation_assets`、`pet_animation_assets`、`animation_metadata_assets`、`ui_feedback_assets`。
- `AssetResolver` 新增 `get_tile_edge_asset()`、`get_story_prop_asset()`、`get_character_animation()`、`get_pet_animation()`、`get_animation_metadata()`、`get_ui_feedback()`。
- `theme_sunshine_town_placeholder.json` 新增首批 logical asset ID 映射和 production acceptance 记录。
- `MapEditorSyncService` 新增 `STORY_PROPS_PATH` 与 `validate_story_props()`。
- `TownMapAuthoring` 新增 StoryProp marker layer、`place_story_prop` tool mode、story prop selection、drag validation、`child_label` Inspector 编辑和 `validate_story_props_candidate()`。
- `scenes/map_editor/town_map_authoring.tscn` 新增 `StoryPropMarkerLayer`。

## 验收重点

- 首批 story prop、motion sheet、metadata、UI feedback 和 tile edge 均经 logical asset ID resolve，不在 runtime 脚本硬编码路径。
- story prop marker 绑定现有 `place_id` 和 A-Z `core_anchor_ids`，不新建或替换核心 anchor。
- story prop interaction cell 不覆盖已有 anchor、interaction 或 collision。
- `child_label` 禁用课程、测试、格子、坐标、debug / editor 等术语。
- motion metadata 必填 `metadata_id`、`sheet_asset_id`、`source_png`、`frame_size`、`pivot`、`animations`，且 fallback 可通过旧 standing 类别 resolve。
- production acceptance 保留 `pending_1280_runtime_proof`，不自动提升 approved。

## 验证

- `godot --headless --path . --check-only --script scripts/editor/map_editor_sync_service.gd`
- `godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`
- `godot --headless --path . --check-only --script scripts/data/theme_profile_resource.gd`
- `godot --headless --path . --check-only --script scripts/systems/asset_resolver.gd`
- `godot --headless --path . --check-only --script tests/test_v0234_artprod001_asset_integration.gd`
- `godot --headless --path . --script tests/test_asset_resolver.gd`
- `godot --headless --path . --script tests/test_v0234_artprod001_asset_integration.gd`
- `godot --headless --path . --script tests/headless_runner.gd`

以上均通过。

## 后续输入

`V02-RUNTIME-ANIM-001` 可以直接使用本轮新增 `character_animation_assets` / `pet_animation_assets` / `animation_metadata_assets` / `ui_feedback_assets`，将 player / Sunny 的 4 向基础动作、prompt feedback 和 camera / control proof 接入真实孩子端路径。缺失动作仍必须 fallback 到 standing 资产。
