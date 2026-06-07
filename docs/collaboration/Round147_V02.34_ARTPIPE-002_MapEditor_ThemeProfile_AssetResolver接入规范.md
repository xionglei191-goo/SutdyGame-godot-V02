# Round147 V02.34 ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范

> 日期：2026-06-07
> 任务：`V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范`
> 状态：完成
> 下一轮 Ready：`V02-ARTPROD-001 首批美术资产生产与接入`

## 本轮范围

本轮只输出接入规范，不生成正式资产、不改 runtime、不改 `ThemeProfileResource` / `AssetResolver` / Map Editor 代码、不写正式 JSON。目标是让下一轮首批资产生产与后续 Godot 接入有清晰合同：tile、story prop、sprite sheet、UI feedback、editor marker 和 proof 都能按 logical asset ID 进入现有工具链。

当前代码事实：

- `ThemeProfileResource` 目前支持 `tile_atlas`、`place_assets`、`anchor_assets`、`character_assets`、`pet_assets`、`ui_icon_assets`、`ui_skin` 等旧类别。
- `AssetResolver` 目前通过 `resolve_asset(theme_id, category, logical_asset_id)` 统一查映射，并对缺失映射返回 placeholder。
- `TownMapAuthoring` 已能编辑 Place / resource / NPC routine / A-Z anchor / interaction / collision，但还没有 story prop marker 的正式 asset 字段合同。
- Round146 已定义新 backlog 类别：`story_prop_assets`、`character_animation_assets`、`pet_animation_assets`、`animation_metadata_assets`、`ui_feedback_assets`。

## 新增 ThemeProfile 类别

后续实现应在 `data/themes/theme_sunshine_town_placeholder.json`、`ThemeProfileResource` 和 `AssetResolver` 中新增这些类别：

| Category | 用途 | 示例 logical ID | 值类型 |
|---|---|---|---|
| `story_prop_assets` | Home / School / Shop / Story Bench / Park / Coast 的故事物件 | `story_prop.home.apple_welcome_photo` | `res://assets/art/story_props/home/apple_welcome_photo.png` |
| `tile_edge_assets` | tile edge / transition / decal 独立资源 | `tile_edge.grass_path.soft` | `res://assets/art/tiles/edges/grass_path_soft.png` |
| `character_animation_assets` | player / NPC motion sheet PNG | `anim.player.walk.down` 或 pack ID | `res://assets/art/characters/animation/player_p0_motion_v001.png` |
| `pet_animation_assets` | Sunny motion sheet PNG | `anim.pet.sunny.wag.down` 或 pack ID | `res://assets/art/pets/animation/sunny_p0_motion_v001.png` |
| `animation_metadata_assets` | sprite sheet metadata JSON | `anim_meta.player.p0_motion` | `res://assets/art/characters/animation/metadata/player_p0_motion_v001.json` |
| `ui_feedback_assets` | prompt glow、tap ripple、collect sparkle、joystick | `ui_feedback.prompt_soft_glow` | `res://assets/art/ui/feedback/prompt_soft_glow.png` |

兼容规则：

- 旧 `character_assets` / `pet_assets` standing 图继续作为 fallback。
- 缺 animation sheet 或 metadata 时，不阻断运行时，回退到 standing。
- 旧 `place_assets` 不承载 story prop，避免把地图底图和可编辑故事物件混在一起。
- `tile_atlas` 可继续保留 world / main atlas；边缘、decal 可放入 `tile_edge_assets`，下一阶段再决定是否合并 atlas。

## AssetResolver API 建议

后续实现建议新增：

```gdscript
static func get_story_prop_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary
static func get_tile_edge_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary
static func get_character_animation(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary
static func get_pet_animation(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary
static func get_animation_metadata(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary
static func get_ui_feedback(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary
```

`_validate_profile()` 后续要把新增类别纳入校验，但允许分阶段空类别：

| 类别 | V02.34 最低要求 |
|---|---|
| `story_prop_assets` | 至少 P0 story props 有映射或明确 placeholder 映射 |
| `character_animation_assets` | 首批 motion pack 映射进入 production 时必填 |
| `pet_animation_assets` | Sunny motion pack 映射进入 production 时必填 |
| `animation_metadata_assets` | 每个 motion pack 必须有 metadata；没有 metadata 不得标 production |
| `ui_feedback_assets` | prompt / tap / collect feedback 进入 runtime 前必填 |
| `tile_edge_assets` | 可先 draft / placeholder，进入 tile production 时必填 |

## Sprite Sheet Metadata 合同

每个 motion pack 必须有 JSON metadata。建议 schema：

```json
{
  "metadata_id": "anim_meta.player.p0_motion",
  "sheet_asset_id": "anim_sheet.player.p0_motion",
  "source_png": "res://assets/art/characters/animation/player_p0_motion_v001.png",
  "frame_size": {"w": 64, "h": 64},
  "pivot": {"x": 32, "y": 52},
  "animations": [
    {
      "logical_animation_id": "anim.player.walk.down",
      "row": 1,
      "frames": [0, 1, 2, 3, 4, 5, 6, 7],
      "fps": 10,
      "loop": true,
      "direction": "down",
      "fallback_asset_id": "character.player.standing"
    }
  ]
}
```

Validation rules:

- `metadata_id`、`sheet_asset_id`、`source_png`、`frame_size`、`pivot`、`animations` 必填。
- 每个 `logical_animation_id` 全局唯一。
- `direction` 只能是 `down`、`left`、`right`、`up`；8 向预留但 P0 不必交。
- `fps > 0`，`frames` 非空。
- `fallback_asset_id` 必须能由旧 standing category resolve。
- metadata 不写孩子端可见文本。

## Story Prop Marker 合同

Map Editor 后续应新增 story prop marker 或在 Place candidate 中增加 story prop 子类型。推荐最小字段：

```json
{
  "story_prop_id": "story_prop_marker_school_yard_net_robot_yoyo",
  "place_id": "place_school_yard",
  "logical_asset_id": "story_prop.school.yard_net_robot_yoyo_corner",
  "storyline_id": "story_school_yard_net_chalk_robot_yoyo",
  "core_anchor_ids": ["anchor_n_net", "anchor_r_robot", "anchor_y_yo_yo"],
  "cell": {"x": 18, "y": 15},
  "size": {"w": 2, "h": 1},
  "interaction_cell": {"x": 19, "y": 15},
  "action": "look_story_prop",
  "child_label": "看看操场小角落",
  "priority": "p0",
  "visible_in_child_runtime": true
}
```

Rules:

- `story_prop_id` 稳定，不使用中文、临时文件名或坐标作为 ID。
- `logical_asset_id` 必须来自 `story_prop_assets`。
- `core_anchor_ids` 只能引用现有 A-Z anchor，不能新建替代核心 anchor。
- `interaction_cell` 必须通过现有 collision / protected cell / arrival safety 校验。
- `child_label` 必须生活化，不出现课程、测试、背诵、格子、坐标、editor。
- P0 story prop 不应覆盖 Home / Shop / School / resource / NPC routine 的核心入口。

## Map Editor 接入流程

| 步骤 | 工具行为 | 验证 |
|---|---|---|
| Add Story Prop | 选择 place、logical asset ID、cell、size、storyline / anchor 绑定 | logical ID 存在；cell 在 canvas 内；不覆盖 protected target |
| Move Story Prop | 拖拽 marker，联动 interaction cell | 与 Place move 一样走 candidate validation；非法回退 |
| Edit Inspector | 编辑 child label、action、priority、storyline_id | 禁用核心 anchor 字段误改；儿童文本扫描 |
| Validate | 汇总 map / resource / routine / story prop 候选错误 | 不写正式 JSON |
| Save | 后续 ARTPIPE-002 实现时走 `MapEditorSyncService` 双阶段写回 | 合法才写、非法不写、失败不毁文件 |

Story prop 可以独立保存到未来 `data/life/story_props.json`，也可以先进入 `world_map.interaction_cells` 的扩展字段；本规范建议独立文件，减少 world_map 继续膨胀。

## Asset Import 规则

| 类型 | 路径 | Godot import | 注意 |
|---|---|---|---|
| tile / edge | `assets/art/tiles/**.png` | 2D texture, filter nearest off / project style consistent | 需要 tile metadata 或 atlas notes |
| story prop | `assets/art/story_props/**.png` | 2D texture alpha | 透明边缘，pivot / footprint notes |
| character motion | `assets/art/characters/animation/**.png` | 2D texture alpha | metadata 必填；不烘 shadow |
| pet motion | `assets/art/pets/animation/**.png` | 2D texture alpha | metadata 必填；Sunny fallback |
| UI feedback | `assets/art/ui/feedback/**.png` | 2D texture alpha | 不遮挡 HUD；可做 strip metadata |

文件命名：

- PNG：`<stable_name>_v001.png`
- Metadata：`<stable_name>_v001.json`
- 禁止：`final.png`、`new_new.png`、中文文件名、画师名、屏幕截图名作为 runtime asset。

## Asset Acceptance 流程

| 状态 | 必要证据 |
|---|---|
| `draft` | logical ID、资源路径、尺寸、用途、child safety notes |
| `production` | repo asset、Godot import、ThemeProfile mapping、AssetResolver resolve、metadata validation、focused check |
| `approved` | 同轮 1280 runtime proof、PM / Art Direction 判定、旧路径不退化、A-Z integrity notes |

任何资产不得仅因文件存在或 `AssetResolver` 能 resolve 就标 `approved`。

## Runtime Proof 规则

后续 ART PROD / RUNTIME 任务至少保留以下 proof：

| Proof | 覆盖 |
|---|---|
| `artpipe_story_prop_home_1280` | Home Apple / Clock / Sunny / Watch story props |
| `artpipe_story_prop_school_1280` | School Gate bell、School Yard net / robot / yo-yo |
| `artpipe_story_prop_shop_1280` | Hat / ribbon / shop window |
| `artpipe_story_prop_plaza_1280` | Story Bench Bear book / branch bookmark |
| `artpipe_motion_player_1280` | Player walk / idle / interact |
| `artpipe_motion_sunny_1280` | Sunny wag / greet |
| `artpipe_ui_feedback_1280` | prompt glow / tap ripple / collect sparkle |

Proof 必须是 1280x720 同轮截图或录屏帧；headless 逻辑验证不能替代视觉批准。

## Tests / Validators 建议

后续实现建议新增：

- `tests/test_v0234_theme_profile_extended_assets.gd`
- `tests/test_v0234_animation_metadata_contract.gd`
- `tests/test_v0234_story_prop_marker_contract.gd`
- `tests/test_v0234_asset_resolver_extended_categories.gd`
- `tests/test_v0234_artpipe_import_acceptance.gd`

覆盖：

- 新类别可加载、可 resolve、缺失有 placeholder。
- metadata 必填字段、方向、fps、fallback。
- story prop marker 不覆盖 protected cell，不改核心 anchor。
- child label 无课程 / debug / editor 术语。
- `production` 记录必须有 mapping 和 metadata；`approved` 必须有 proof 字段。

## 禁改边界

- 不改 A-Z 稳定 ID / route_order / core_word。
- 不让 story prop marker 变成课程任务或测试点。
- 不把具体 `res://` 路径写入 gameplay 脚本。
- 不绕过 `MapEditorSyncService` 写正式 JSON。
- 不把 production 自动提升 approved。
- 不要求 V02.34 先解决 960x540；阻塞 proof 仍以 1280x720 为准。

## 交付给后续任务的输入

`V02-ARTPROD-001`：

- 先生产并接入 `art_batch_p0_story_walk_001`。
- 为首批 story prop、motion、UI feedback 创建 PNG + metadata + ThemeProfile mapping。
- 跑 extended AssetResolver / metadata / story prop validator。

`V02-RUNTIME-ANIM-001`：

- 使用 extended AssetResolver 获取 motion sheet / metadata / UI feedback。
- story prop runtime 从 logical ID 解析 sprite，不硬编码路径。
- 缺失资产保持 fallback，不阻断旧可玩路径。

## 验收结论

- 正式素材命名、导入、atlas / sprite sheet、logical asset ID：通过。
- ThemeProfile 新类别和 AssetResolver API 建议：通过。
- editor marker 绑定和 story prop 字段合同：通过。
- asset acceptance、runtime proof 和 testing 规则：通过。
- production 不自动等同 approved：通过。
- 不生成资产、不改 runtime / data / tests：通过。

下一轮 Ready：`V02-ARTPROD-001 首批美术资产生产与接入`。
