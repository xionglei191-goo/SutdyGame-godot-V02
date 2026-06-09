# Round162 V02.39 VISUALREBUILD-003 Logic Map / Visual Layout 分层方案

日期：2026-06-07  
Owner：Tech Lead / Godot / Tooling worker  
范围：仅文档方案；不修改 runtime / data / tests / assets  
后续承接：V02-VISUALREBUILD-005 TownStage runtime visual match 纵切

## 1. 当前 world_map / TownStage 驱动画面审计

当前真实入口仍是 `Main._ready()` 加载 `RuntimeMapBuilder.load_world_map()`、A-Z core anchors、story props，再由 `_create_map_canvas()` 实例化 `TownStage`。`TownStage.setup()` 接收 `world_map`、`az_core_data`、`resource_points`、`story_props`、NPC、outdoor items、`map_cell_size`、`map_render_size` 与 `local_camera_scale` 后，在 `RuntimeMapFrame/RuntimeMap` 下绑定固定分层：`GroundLayer`、`RoadVisualLayer`、`PlaceLayer`、`PlazaLifeLayer`、`HotspotLayer`、`StoryPropLayer`、`CollisionDebugLayer`、`AnchorLayer`、`ResourceLayer`、`NPCActorLayer`、`OutdoorDecorLayer`、`PlayerLayer`。

画面来源目前混合了三类驱动：

- 逻辑地图直推：`world_map.roads` 逐 cell 生成 road visual；`world_map.places` 生成 place object；`world_map.interaction_cells` 生成 hotspot；`world_map.collision_cells` 生成隐藏 debug marker；`world_map.memory_anchors` 与 `az_core_data.anchors` 生成 A-Z anchor object。
- 代码内视觉数组：`_render_region_chunks()`、`_render_plaza_life_details()`、`_render_school_life_details()`、`_render_visual_recovery_world_props()` 在 `TownStage` 内硬编码 cell、size、texture key 与 role。
- ThemeProfile / AssetResolver：`data/themes/theme_sunshine_town_placeholder.json` 已有 `terrain_tile_assets`、`terrain_decal_assets`、`region_chunk_assets`、`building_prefab_assets`、`world_prop_assets`、`soft_shadow_assets`、`story_prop_assets` 等模块化 category；`AssetResolver` 可按 logical asset ID 解析资源，并支持 `terrain_edge_assets`、`shadow_assets`、`actor_sprite_assets` 等兼容别名。

现有 V02.38 测试约束已经形成底线：不能使用 `place.world_map.base_1280` 作为 final runtime full-map background；不能恢复单张 legacy `Ground`；必须保留 modular terrain / region / building / world prop 统计；非 prefab place marker 要降噪；A-Z badge 只作辅助；Home / Shop / School Gate 真实入口必须继续可达。

问题不在 AssetResolver 是否能解析素材，而在画面构图仍被逻辑 cell 与 TownStage 内硬编码视觉片段共同牵引。`world_map` 既承担碰撞、互动、保存、A-Z route_order，也间接决定首屏视觉密度、物件位置、景深和遮挡。V02.39 需要把“逻辑事实”和“视觉摆放”拆开。

## 2. Logic Map 与 Visual Layout 边界

### Logic Map 保留职责

`world_map` 继续是可玩性事实源，负责：

- `canvas_size`、`roads`、walkable path、collision cells、interaction cells。
- `places`、place IDs、进入/看看等真实交互入口。
- `memory_anchors` 的 stable anchor ID、letter、route_order、place binding、review path 入口。
- 保存相关的 stable IDs：place、anchor、resource、NPC、story prop、outdoor item instance。
- 服务层输入：NPC routine、resource refresh、outdoor decoration placement、interaction lookup。

Logic Map 不再负责：

- 首屏构图位置是否好看。
- 视觉资产尺寸、pivot、shadow、depth band、occlusion mask。
- place marker 的视觉降噪程度。
- focus state 下哪些视觉层强调或淡出。
- 1280 target frame 的像素级视觉 match。

### Visual Layout 新增职责

Visual Layout 是 Godot 可执行的画面合同，负责：

- visual anchors：每个可见视觉对象在 1280 frame 或 map local space 中的视觉位置、pivot、scale、safe area。
- depth：背景/地面/region/building/prop/actor/UI proxy 的 depth band 与 z order。
- occlusion：遮挡规则、actor 前后关系、可选 occluder sprite / mask / collision-independent visual cover。
- proxy：把 Logic Map 的 place / anchor / story prop / resource / NPC 映射成视觉代理节点；代理可偏移、缩放、隐藏或合并，但不能改 stable ID 和真实交互半径。
- focus state：normal / near_interaction / album_open / home_focus / shop_focus / school_focus 等状态下的 alpha、highlight、prompt anchor、badge visibility。

核心原则：玩家和系统仍走 Logic Map；孩子看到的是 Visual Layout。Visual Layout 可以让 Home 更大、更靠近首屏中心，也可以把 A anchor 的视觉 basket 放在 Home 门口更自然的位置，但 `anchor_a_apple` 的 ID、route_order、card state 与可交互路径不能被视觉摆放覆盖。

## 3. 迁移数据合同草案

建议新增独立 visual layout 数据，不塞进 `world_map`。优先形态可为 JSON，后续可包成 Resource：

```json
{
  "layout_id": "sunshine_town_p0_1280_v001",
  "theme_id": "theme_sunshine_town_placeholder",
  "target_viewport": {"w": 1280, "h": 720},
  "camera": {
    "mode": "fixed_match_first",
    "map_origin_px": {"x": 0, "y": 0},
    "logic_to_visual_scale": {"x": 2.05, "y": 2.05},
    "focus_bounds_px": {"x": 0, "y": 0, "w": 1280, "h": 720}
  },
  "layers": [
    {"layer_id": "terrain", "node": "GroundLayer", "z_base": -80},
    {"layer_id": "regions", "node": "GroundLayer", "z_base": -60},
    {"layer_id": "buildings", "node": "PlaceLayer", "z_base": -20},
    {"layer_id": "props", "node": "PlazaLifeLayer", "z_base": 10},
    {"layer_id": "actors", "node": "NPCActorLayer", "z_base": 30},
    {"layer_id": "player", "node": "PlayerLayer", "z_base": 40},
    {"layer_id": "feedback", "node": "FeedbackLayer", "z_base": 90}
  ],
  "visual_nodes": [
    {
      "visual_id": "vis_home_cottage",
      "bind": {"type": "place", "id": "place_home"},
      "asset": {"category": "building_prefab_assets", "logical_asset_id": "building.home.cottage"},
      "layer_id": "buildings",
      "position_px": {"x": 642, "y": 355},
      "size_px": {"w": 256, "h": 192},
      "pivot": {"x": 0.5, "y": 0.78},
      "depth_band": "midground_home",
      "shadow": {"logical_asset_id": "soft_shadow.oval.default", "offset_px": {"x": 0, "y": 46}},
      "proxy": {"interaction_source": "logic_map", "hit_shape": "place_interaction_radius"}
    }
  ],
  "focus_states": {
    "normal": {"badge_alpha": 0.35, "non_prefab_place_alpha_max": 0.18},
    "near_interaction": {"prompt_anchor": "bound_visual", "glow_asset_id": "ui_feedback.prompt_soft_glow"}
  },
  "fallbacks": {
    "missing_visual_node": "derive_from_logic_cell_quiet_proxy",
    "missing_asset": "resolver_missing_placeholder_hidden_in_child_runtime",
    "missing_layout": "current_town_stage_v0238_compat"
  }
}
```

字段建议：

- `layout_id` 必须 stable，可被截图、测试、acceptance record 引用。
- `bind.type/id` 绑定 Logic Map 对象；允许一个逻辑对象有多个 visual node，但只有一个 primary proxy。
- `asset.category/logical_asset_id` 必须走 `AssetResolver.resolve_asset()` 或现有 typed getter，不在 runtime 硬编码 `res://`。
- `position_px/size_px/pivot` 先服务 1280 静态 match；后续再扩展 responsive variant。
- `depth_band` 是语义合同，运行时映射到 z-index / y-sort；不要让散落节点自由写 z-index。
- `proxy` 记录交互来源。视觉节点不自己发明 save ID，不自己决定 card state。
- `fallbacks` 必须显式，避免缺图时悄悄恢复 full-map background 或大块 debug marker。

ThemeProfile 建议扩展但不立即强改：

- 新 category：`visual_layout_assets` 可指向 visual layout JSON/Resource，如 `layout.sunshine_town.p0_1280`。
- 保留现有 modular asset categories：`terrain_tile_assets`、`region_chunk_assets`、`building_prefab_assets`、`world_prop_assets`、`soft_shadow_assets`、`story_prop_assets`。
- `asset_acceptance` 后续增加 `layout_id`、`visual_node_id`、`target_frame_evidence`、`runtime_match_evidence`，把资产合格与布局合格分开。

Fallback 规则：

1. logical asset ID 缺失：返回 resolver missing result；child runtime 中该 visual node 默认隐藏或用极低 alpha debug-safe proxy，测试记录错误。
2. layout node 缺失但 logic object 存在：生成 quiet proxy，`non_prefab_place_alpha <= 0.18`，只保证可交互，不抢视觉。
3. layout 存在但 logic bind 缺失：不渲染该 proxy，记录 layout error；不得创造新的 gameplay object。
4. layout 整体缺失：走 V02.38 compat renderer，状态仅为 `visual_scaffold`，不能标 `runtime_visual_match`。
5. 禁止 fallback 到 `place.world_map.base_1280` full-map background。

## 4. 运行时接入策略

V02-VISUALREBUILD-005 应按两段纵切推进。

第一段：静态 1280 visual match。

- 新增 VisualLayout loader 与轻量 Resource/Dictionary contract，仅加载 target `layout.sunshine_town.p0_1280`。
- TownStage 优先从 Visual Layout 渲染 terrain / regions / buildings / primary props / shadows / UI-safe prompt anchors。
- 暂时不追求所有逻辑对象视觉化；首屏只覆盖 target frame 必须出现的 Home-centered 构图、Shop / School hint、A-Z 首屏 priority props、道路引导与 actor scale。
- 保持 `RuntimeMapFrame`、`RuntimeMapInput`、`runtime_map_node` facade，以免 Main 的移动、点击、相册、Home/Shop/School smoke 失效。
- 截图只以 1280x720 为验收窗口；当前阶段不做 960x540 或多屏适配。

第二段：恢复必要交互代理。

- 对每个可交互 place / anchor / story prop 建 proxy node：视觉位置可来自 layout，交互判断仍委托 Logic Map。
- Prompt/glow 跟随 `primary_visual_id` 或 layout 中的 `prompt_anchor`，而不是直接跟 cell center。
- Player / NPC 可先继续使用 logic cell 移动，但渲染层按 visual depth band / y-sort 进入 actor layer；如需要视觉偏移，用 display offset，不改保存坐标。
- Story prop 第二批在 V02.39 final gate 前仍保持库存，不把新 prop 堆到未 match 的画面上；005 只恢复已解锁真实入口与必要 P0 代理。

## 5. 测试策略

必须不退化的现有真实入口：

- Home：`move_player_to_cell(Vector2i(31, 19))` + `interact_nearby()` 后 Home view 可见。
- Shop：`move_player_to_cell(Vector2i(41, 11))` + `interact_nearby()` 后 Shop panel 可见。
- School Gate / School line：`move_player_to_cell(Vector2i(21, 12))` + `interact_nearby()` 后 child-facing 文本安全。
- Main facade：`main.runtime_map_node`、`main.player_marker` 继续存在。

A-Z 与保存状态：

- 26 个 anchor stable ID、letter、route_order 不因 visual node 重排而变化。
- Card state / MemoryAlbum / AnchorInteractionService 仍使用 core anchor ID 和 save service，不使用 visual ID。
- 新增 visual node 绑定 anchor 时必须验证 `bind.id` 存在，且不重复覆盖同一 core anchor 的 primary proxy。

视觉防回归：

- `uses_full_map_background == false`。
- `has_legacy_ground_sprite == false`。
- layer ordering 固定：terrain/regions < road/context < buildings/props < anchors/resources/NPC/player < feedback/UI。
- no full-map background：`place.world_map.base_1280` 可留作 reference / old mapping，但 final runtime 不可见。
- non-prefab marker 降噪：没有 prefab 的 place/context proxy alpha 继续上限 `<= 0.18` 或至少不高于现有 `<= 0.22`。
- A-Z badge secondary：badge alpha 保持低位，prop-first 物件优先。
- Visual Layout snapshot 新增建议字段：`layout_id`、`visual_node_count`、`bound_logic_count`、`unbound_visual_count`、`quiet_proxy_count`、`depth_band_order_ok`、`focus_state`。

建议测试组合：

- 更新/新增 focused visual layout contract test：验证 layout JSON schema、logical asset ID 可解析、bind ID 存在、fallback 不指向 full-map background。
- 扩展 `tests/test_town_stage_layered_runtime.gd`：保留现有 layer existence，同时检查 Visual Layout 渲染入口和 depth band 顺序。
- 扩展 `tests/test_v0238_visual_recovery_runtime.gd` 或新增 V02.39 focused test：保留 Home/Shop/School smoke、no background、non-prefab marker、A-Z badge 降噪。
- 截图 gate：导出 target frame 与 Godot runtime 1280 并排 proof，只有 art direction 通过后标 `runtime_visual_match`。

## 6. 风险与 rollback / compat 策略

主要风险：

- 视觉坐标与逻辑 cell 分离后，点击/提示/交互半径看起来错位。
- actor depth 与建筑/prop 遮挡冲突，造成角色穿墙或被不合理盖住。
- fallback 静默生效，让画面看似可运行但又回到 V02.38 `visual_scaffold`。
- A-Z anchor 被视觉代理重命名或多重绑定，导致 route_order / card state / revisit path 不稳定。
- 资产验收状态与布局验收状态混淆，production PNG 被误当 final-approved runtime。

缓解：

- Visual node 与 Logic object 双 ID 并存：`visual_id` 只服务渲染，`bind.id` 才是交互/save/A-Z 事实。
- prompt/glow/click feedback 统一走 proxy adapter，禁止视觉节点直接改 interaction service。
- snapshot 中暴露 `layout_id`、fallback count、quiet proxy count、missing asset count；测试中 fail fast。
- `asset_acceptance.status=production` 不等于 `runtime_visual_match` 或 `final_approved`。
- 005 只做 P0 1280 纵切，不顺手重排全地图、不恢复 StoryBatch 第二批 runtime。

Rollback / compat：

- 保留 V02.38 TownStage compat path 作为 emergency fallback，但状态只能是 `visual_scaffold`。
- Visual Layout loader 失败时不崩溃真实入口；回到 quiet proxy / compat renderer，并在 snapshot 与日志中明确 `layout_status=compat_fallback`。
- 若 runtime match 未过，只回滚 Visual Layout 选择或 node 数据，不动 `world_map`、save schema、A-Z data、ThemeProfile asset mappings。
- 如发现交互错位，优先调整 proxy display/prompt anchor 或 layout node，不移动 logic cell。

## 核心结论

V02.39 的关键不是继续堆 modular assets，而是建立一层可执行 Visual Layout：`world_map` 继续保留 cell / collision / interaction / A-Z / save 事实，Visual Layout 独立管理 visual anchors / depth / occlusion / proxy / focus state。后续 005 应先让一张 1280 runtime frame 与 target frame 静态匹配，再逐步挂回必要交互代理。只有截图、真实入口、A-Z route/card state、no full-map background、layer order 与 marker 降噪同时通过，才能进入 `runtime_visual_match`。
