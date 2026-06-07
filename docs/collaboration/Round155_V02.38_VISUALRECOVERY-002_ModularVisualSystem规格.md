# Round155 V02.38 VISUALRECOVERY-002 Modular Visual System 规格

> 日期：2026-06-07
> 任务：`V02-VISUALRECOVERY-002 Modular Visual System 规格`
> 状态：规格完成，供 `V02-VISUALRECOVERY-003` 至 `V02-VISUALRECOVERY-006` 执行
> 写入范围：仅本文档；未改 runtime、data、assets、tests、todo、docs 12-15 或 lessons

## 1. 本轮决策

V02.38 的最终小镇画面必须由 modular visual system 组成，而不是由一张整图底图承载产品观感。后续 `TownStage` final runtime 的目标是：

```text
terrain tile -> region chunk -> road / edge -> building prefab -> world prop / prop-first A-Z anchor -> actor / shadow -> feedback -> glass UI
```

硬门槛沿用并升级 Round92 / artpass003：

- 世界视觉：Animal Crossing-like cozy town，但不复制外部 IP；轻 2.5D、圆润、明亮、可生活、可回访。
- UI 视觉：Apple-like translucent glass UI；轻透明、柔和模糊、清晰边界、图标优先、短文本辅助。
- A-Z 表达：prop-first。孩子第一眼看到的是生活物件、地点装置或环境线索；字母 badge 只是小辅助。
- 状态语义：`production` 只代表可接入；`functional_pass` 只代表可玩可读；`visual_candidate` 才能进入人工视觉复核；`final_approved` 必须通过 V02-VISUALRECOVERY-006 同轮 1280 proof 和 PM / Art Direction 判定。

`place.world_map.base_1280` / `world_map_base_1280.png` 只能作为 reference、迁移对照和缺口说明，不得作为 final runtime 主画面、主背景、截图批准依据或新增内容的承载层。

## 2. 非目标

- 不重排 A-Z anchor，不改 `anchor_id`、`letter`、`route_order`、`core_word`、相册语义或新词故事绑定。
- 不把 V02.37 story batch 继续堆叠到旧 full-map background 上。
- 不生产新图片，不修改 ThemeProfile、AssetResolver、Map Editor、runtime 或测试。
- 不引入课程面板、词表墙、测试、分数、打卡、裸字母牌、绘本内页或厚重卡片方向。
- 不把 960x540 作为本轮阻塞门槛；当前视觉恢复 gate 只看 1280x720。

## 3. ThemeProfile 类别决策

后续实现应新增 V02.38 modular 类别，同时保留 V02.34 已有类别作为兼容输入。

| Category | 用途 | 例子 | 与旧类别关系 |
|---|---|---|---|
| `terrain_tile_assets` | 单格或 atlas 内地面 tile，承载草地、广场、校院、商店街、海边等基础地表 | `terrain_tile.grass.home_day`、`terrain_tile.plaza.warm_day` | 替代旧 `tile_atlas` 中零散 `tile_*` 命名；旧 `tile_atlas` 可作为迁移 fallback |
| `terrain_edge_assets` | 地面过渡、道路边、内外角、软边缘和轻 decal | `terrain_edge.grass_path.soft`、`terrain_decal.flower_dot.soft` | 可兼容现有 `tile_edge_assets` |
| `region_chunk_assets` | 由 tile / edge / decal 组成的可复用区域块，不是整张地图 | `region_chunk.town_plaza.core_day`、`region_chunk.home_yard.core_day` | 替代旧 `place.town_plaza.day` 这类大区域图作为主视觉的用法 |
| `building_prefab_assets` | 可落在地图 cell / footprint 上的建筑 prefab 外观 | `building_prefab.home.cottage_day`、`building_prefab.shop.corner_day`、`building_prefab.school.gate_day` | 旧 `place.home.exterior`、`place.shop.exterior` 可迁移到此类 |
| `world_prop_assets` | 常驻小镇物件、生活装饰、资源物件、story prop 和 prop-first anchor 主体 | `world_prop.anchor.apple_tree`、`world_prop.plaza.bench_soft` | 旧 `anchor_assets`、`story_prop_assets`、部分 `place.resource.*` 可分阶段迁移 |
| `actor_sprite_assets` | player / NPC / Sunny 的站立图、fallback 图和头像 | `actor_sprite.player.standing`、`actor_sprite.pet.sunny.standing` | 兼容旧 `character_assets` / `pet_assets` |
| `actor_animation_assets` | player / NPC / Sunny motion sheet | `actor_anim_sheet.player.p0_motion` | 兼容旧 `character_animation_assets` / `pet_animation_assets` |
| `actor_animation_metadata_assets` | motion metadata、pivot、fps、fallback | `actor_anim_meta.player.p0_motion` | 兼容旧 `animation_metadata_assets` |
| `shadow_assets` | 椭圆软阴影、建筑落影、地面接触影 | `shadow.soft_ellipse.small`、`shadow.building.wide_soft` | 不再每个 runtime 节点随意画不同阴影 |
| `glass_ui_assets` | HUD、footer、panel、button、icon button、tooltip、prompt 承载层 | `glass_ui.hud_bar.compact`、`glass_ui.panel.large` | 兼容旧 `ui_skin` |
| `ui_feedback_assets` | prompt glow、tap ripple、collect sparkle、album discover feedback | `ui_feedback.prompt_soft_glow` | 继续沿用现有类别 |

兼容规则：

- 运行时脚本仍只能通过 logical asset ID 请求资产，不能硬编码 `res://assets/...`。
- `place_assets` 可保留旧功能映射，但不得再新增“整张主地图”作为 final runtime 主画面。
- `world_prop_assets` 是 prop-first anchor 的未来主类别；旧 `anchor_assets` 可保留到迁移完成。
- 每个 production 资产必须有 asset acceptance 记录，字段至少包含 logical ID、category、resource path、replacement target、status、1280 proof 点、child-safety notes 和 anchor-integrity notes。

## 4. Logical Asset ID 命名

V02.38 新增 ID 使用小写点分格式：

```text
<domain>.<place_or_role>.<stable_object>[.<variant>]
```

允许 domain：

| Domain | 例子 | 规则 |
|---|---|---|
| `terrain_tile` | `terrain_tile.grass.home_day` | 单 tile 或 atlas tile；不写尺寸和版本号 |
| `terrain_edge` | `terrain_edge.grass_path.soft_corner` | 地表过渡；方向可用 `north` / `south` / `inner` / `outer` 等 variant |
| `terrain_decal` | `terrain_decal.leaf_scatter.light` | 只做轻地面装饰，不作为可交互物 |
| `region_chunk` | `region_chunk.town_plaza.core_day` | 区域块必须可拼接、可遮挡裁切；不能等同 full-map background |
| `building_prefab` | `building_prefab.home.cottage_day` | 建筑主体；必须有 footprint 和 pivot 说明 |
| `world_prop` | `world_prop.anchor.apple_tree` | 生活物件、资源、story prop、anchor 主体；可交互才绑定 action |
| `actor_sprite` | `actor_sprite.npc.mina.standing` | 站立 / 头像 / fallback 图 |
| `actor_anim_sheet` | `actor_anim_sheet.player.p0_motion` | sprite sheet pack ID |
| `actor_anim_meta` | `actor_anim_meta.player.p0_motion` | metadata ID |
| `shadow` | `shadow.soft_ellipse.medium` | 阴影可复用，不烘进 actor / prop 主贴图 |
| `glass_ui` | `glass_ui.button.icon_normal` | UI skin；图标仍用 `ui_icon.*` |

禁止：

- `final.png`、`new_new.png`、中文文件名、画师名、截图名、坐标、屏幕尺寸或版本号进入 logical asset ID。
- `place.world_map.base_1280` 继续作为新任务的 replacement target。
- 以 `letter_a.big_card`、`anchor.a.letter_board` 等裸字母牌作为 A-Z 主物件。

## 5. Terrain Tile 规格

Terrain tile 是孩子脚底读感和小镇统一感的最底层，不再依赖全图烘焙。

| 项 | 决策 |
|---|---|
| 基础尺寸 | 64x64 源 tile；可提供 128x128 高精源，runtime 仍按 hidden-grid / cell 缩放 |
| 地面类型 | Home grass、Town Plaza warm ground、main path、side path、School Yard soft ground、Shop Street pavement、Animal Park grass、Coast sand / water-edge preview |
| 边缘 | 每种主地表至少有直边、内角、外角、柔和过渡；不得出现硬棋盘格 |
| 材质 | 圆润、干净、明亮，多色平衡；避免单一米色 / 棕橙 / 深蓝 / 紫蓝占满全屏 |
| 可读性 | 玩家脚底必须清楚贴地；道路方向可读但不画成调试路径或格线 |
| 交互 | tile 本身不显示坐标、cell、路径箭头或 debug 高亮 |

P0 tile IDs：

- `terrain_tile.grass.home_day`
- `terrain_tile.path.main_soft`
- `terrain_tile.path.side_soft`
- `terrain_tile.plaza.warm_day`
- `terrain_tile.school_yard.soft_ground`
- `terrain_tile.shop_street.pavement`
- `terrain_edge.grass_path.soft`
- `terrain_edge.plaza_path.soft`
- `terrain_decal.leaf_scatter.light`
- `terrain_decal.flower_dot.soft`

## 6. Region Chunk 规格

Region chunk 是比 tile 大、比整图小的可复用区域块，用于建立地点感，但不能接管整屏。

| Region | Logical ID | 尺寸建议 | 必须包含 | 禁止 |
|---|---|---|---|---|
| Town Plaza core | `region_chunk.town_plaza.core_day` | 8x6 至 14x10 cells | 广场地面、短边界、停留点基底、道路接缝 | 烘焙 Home / Shop / School / A-Z 全部对象 |
| Home yard | `region_chunk.home_yard.core_day` | 8x8 至 12x10 cells | 家门口草地、欢迎垫基底、Sunny 角落空间 | 把 Home 建筑和 A/C/D/W anchor 烘成不可分层整图 |
| Home-School Walk | `region_chunk.walk.safe_path_day` | 6x8 至 10x12 cells | 主路、草边、K kite 路线空间 | 倒计时、迟到、考试路线暗示 |
| School gate | `region_chunk.school_gate.arrival_day` | 6x5 至 9x7 cells | 校门前软地面、铃铛 / welcome 空间 | 封锁门、资格检查、课堂黑板 |
| School yard | `region_chunk.school_yard.play_corner_day` | 10x8 至 14x10 cells | 软网、玩具角和跑动留白 | 比赛排名、竞技压力 |
| Shop street | `region_chunk.shop_street.window_day` | 8x6 至 12x8 cells | 店门口、橱窗、排队 / 等候空间 | 强消费海报、限时售罄 |

每个 region chunk 必须提供：

- `footprint_cells`：占用范围。
- `entry_cells`：玩家可到达入口。
- `occlusion_safe_zone`：不得遮挡玩家、HUD、底栏和核心 prompt 的区域说明。
- `proof_view`：1280 proof 中应出现在哪个真实入口。

## 7. Building Prefab 规格

Building prefab 是可摆放在 PlaceLayer 的建筑主体，不再作为大背景的一部分。

| Prefab | Logical ID | Footprint | 显示比例 | 交互要求 |
|---|---|---|---|---|
| Home cottage | `building_prefab.home.cottage_day` | 4x3 至 5x4 cells | 比 player 高约 3.2 至 4.0 倍 | 门口入口清楚，不能压住 A/C/D/W anchor |
| Shop corner | `building_prefab.shop.corner_day` | 4x3 至 5x4 cells | 比 player 高约 3.0 至 3.8 倍 | 橱窗可读，购买入口不被 NPC / prop 挡住 |
| School gate | `building_prefab.school.gate_day` | 4x2 至 6x3 cells | 门柱和牌子清楚，低压不封闭 | 表达欢迎，不表达考试或迟到 |
| School yard shed / toy corner | `building_prefab.school.yard_shed_day` | 2x2 至 3x2 cells | 低于主建筑，服务玩具收纳 | 不抢 N/R/Y/K anchor 主体 |
| Story bench / book nook | `building_prefab.plaza.story_bench_day` | 3x2 cells | 类设施，不像教室 | 支撑 B Bear / branch story prop |

每个 prefab 必须有：

- pivot：脚底 / 建筑接地点。
- shadow anchor：落影中心和宽度。
- interaction cell：门口或看一眼位置。
- collision footprint：不可走区域。
- visual safe margin：不遮挡临近 anchor badge 和 prompt。

## 8. World Prop 与 Prop-first A-Z Anchor

A-Z anchor 必须作为常驻世界物件存在，且主视觉为 prop，不是字母。

### 8.1 表达优先级

| 层级 | 用途 | 规则 |
|---|---|---|
| 主体 prop | 记忆宫殿真实锚点 | 生活物件、地点装置或环境线索必须先成立 |
| 地点关系 | 让 anchor 绑定 Home / School / Shop / Plaza / Park / Coast | 位置和回访路线比字母更重要 |
| 视觉钩子 | 支持核心词记忆 | Apple 要看得出苹果，Clock 要看得出圆钟，Gate 要看得出温和入口 |
| 小 badge | 辅助识别 | badge 小、低噪、可读即可；不做大牌、课程牌或收集墙 |
| 交互反馈 | `看看` 后落账相册 | 短句生活化，不出现答题、背诵或正确率 |

### 8.2 P0 Anchor Prop 组

| 区域 | Anchors | 主 prop IDs | 绑定说明 |
|---|---|---|---|
| Home | A/C/D/W/T | `world_prop.anchor.apple_tree`、`world_prop.anchor.clock_corner`、`world_prop.anchor.sunny_dog_corner`、`world_prop.anchor.watch_charm`、`world_prop.anchor.taxi_tiny_marker` | 家附近生活物件；不被 Home 建筑和回家按钮遮挡 |
| School line | G/K/N/R/Y | `world_prop.anchor.school_gate_soft`、`world_prop.anchor.kite_ribbon`、`world_prop.anchor.soft_net`、`world_prop.anchor.robot_sign`、`world_prop.anchor.yoyo_basket` | 校门和操场是生活地点，不是课堂 / 考试空间 |
| Shop street | H/I/J/O | `world_prop.anchor.hat_sign`、`world_prop.anchor.ice_cream_cart`、`world_prop.anchor.jacket_window`、`world_prop.anchor.orange_stall` | 橱窗和商品是看一眼也开心，不强制购买 |
| Plaza / Story | B/Q/V/S | `world_prop.anchor.bear_book_corner`、`world_prop.anchor.queen_poster`、`world_prop.anchor.violin_corner`、`world_prop.anchor.sun_flower_patch` | 故事 / 音乐 / 阳光线索，不做测验或表演评分 |
| Optional edge | E/F/L/M/P/U/X/Z | `world_prop.anchor.*` | 可选回访和远景预览，不作为 P0 必到 |

### 8.3 Story Prop 兼容

已存在的 `story_prop_assets` 可作为 `world_prop_assets` 的子类迁移。迁移时：

- 保留 `story_prop_id`、`storyline_id`、`core_anchor_ids`、`interaction_cell` 和 `child_label`。
- `logical_asset_id` 可先保留旧 `story_prop.*`，后续补一个 `world_prop.story.*` alias。
- P0 story prop 必须有 shadow、footprint、interaction cell 和 1280 proof 点。

## 9. Actor Scale 与 Shadow

角色、NPC、Sunny、资源和 props 必须共享比例规则，避免“贴纸漂浮”和“角色像 UI 图标”。

| 对象 | 显示高度建议 | Shadow | 备注 |
|---|---|---|---|
| Player | 40-48 px runtime display height at current 1280 playfield scale | `shadow.soft_ellipse.small`，宽约脚底 1.0-1.2 倍 | 主角最优先可读，但不压过建筑 |
| Sunny | Player 高度的 0.55-0.75 | `shadow.soft_ellipse.tiny` | 跟随 / Home 内都要贴地，不表现病弱或惩罚 |
| Mina / Shopkeeper | Player 高度的 0.95-1.1 | `shadow.soft_ellipse.small` | 与玩家同世界，不像 UI 头像贴图 |
| Story Bear | Player 高度的 1.0-1.25 | `shadow.soft_ellipse.medium` | 若坐姿，脚底 / 座位接地点必须清楚 |
| Resource | Player 高度的 0.35-0.55 | `shadow.soft_ellipse.tiny` 或无阴影但有接地明暗 | 可收集但不抢过 anchor |
| World prop / anchor | 1x1 prop 为 Player 高度 0.8-1.5；大型 prop 最高不超过小建筑 | 按 footprint 选择 tiny/small/medium/wide | anchor 主体必须比 badge 更醒目 |
| Building | Player 高度的 3.0-4.0 | `shadow.building.wide_soft` | 阴影独立层，不烘进地面 |

Shadow 规则：

- 软椭圆、低透明、偏暖灰；不使用硬黑投影。
- 方向一致，默认向右下轻偏移。
- actor / prop sprite 不烘 shadow；shadow 由 runtime 子节点或 `shadow_assets` 统一提供。
- 阴影不得覆盖交互提示、字母 badge 或可收集资源轮廓。

## 10. Glass UI 规格

Glass UI 是 overlay 层，不是大白条或厚卡片。

| UI | Logical ID | 规则 |
|---|---|---|
| Top HUD | `glass_ui.hud_bar.compact` | 轻透明，承载金币、宠物、今日短提示；不超过一行高频信息 |
| Footer | `glass_ui.footer_bar.compact` | 图标按钮优先，短标签辅助；保留 `看看`、小镇、小屋、背包 / 相册路径 |
| Prompt bubble | `glass_ui.prompt_bubble.soft` + `ui_feedback.prompt_soft_glow` | 靠近目标，短句，不像任务箭头 |
| Modal panel | `glass_ui.panel.large` | 背包、相册、商店、设置；关闭按钮固定，文本不溢出 |
| Icon button | `glass_ui.button.icon_normal` / `glass_ui.button.icon_pressed` | 触控态清楚，不使用红色警告或强提醒 |

视觉数值建议：

- 透明容器主色：冷白 / 半透明白，alpha 约 0.72-0.88。
- 边框：1px-2px 高光边。
- 阴影：轻柔、低透明，不把 UI 变成浮雕厚卡。
- 圆角：HUD / footer / panel 不超过既有视觉系统需要；按钮 8px 左右优先。
- 文本：中文短句优先，英文只用于物件名、短标签和相册环境词；不显示课程术语。

## 11. Runtime Layer Order

后续 `TownStage` final runtime 应以当前 scene-native layer 为基础，调整职责如下：

| 顺序 | 当前 / 目标 layer | 内容 | 规则 |
|---|---|---|---|
| 0 | `GroundLayer` -> `TerrainTileLayer` | terrain tile、edge、decal | 不加载 `place.world_map.base_1280` 作为主画面 |
| 1 | `RoadVisualLayer` | 主路、支路、路径 edge | road 从 tile / edge 拼出，不显示格子 |
| 2 | 新增 `RegionChunkLayer` 或并入 `GroundLayer` 子层 | Town Plaza、Home yard、School gate、School yard、Shop Street chunk | chunk 不烘建筑 / actor / anchor |
| 3 | `PlaceLayer` -> `BuildingPrefabLayer` | Home、Shop、School gate、story bench 等 prefab | prefab 有 footprint、pivot、shadow |
| 4 | `PlazaLifeLayer` | 长椅、花篮、公告板、School detail 等生活细节 | 可迁移为 `world_prop_assets`，服务地点感 |
| 5 | `HotspotLayer` | invisible / low-noise interaction target | 孩子端不显示 debug marker |
| 6 | `StoryPropLayer` | story props、storyline props | 兼容现有 story props，未来并入 world prop |
| 7 | `AnchorLayer` -> `WorldPropAnchorLayer` | 26 A-Z prop-first anchors + small badges | anchor 常驻；badge 辅助且降噪 |
| 8 | `ResourceLayer` | branch / pebble / wildflower resources | 低噪、可收集、贴地 |
| 9 | `NPCActorLayer` | Mina、Shopkeeper、Story Bear、Bus Helper、Sunny routine actor | 与 actor scale / shadow 统一 |
| 10 | `OutdoorDecorLayer` | 玩家户外装饰 | 不覆盖 protected cells、A-Z 和入口 |
| 11 | `PlayerLayer` | player actor | 始终可读，按 y / cell 排序预留 |
| 12 | `FeedbackLayer` | tap ripple、prompt glow、collect sparkle | 短时显示，不遮挡 HUD / footer |
| 13 | UI overlay | TownHUD、TownFooter、Backpack、Album、Shop、Settings | glass UI，独立于 map composition |

Layer order 验收：

- `CollisionDebugLayer` 默认不可见，不能进入孩子端 proof。
- 地图构图不能依赖 `Ground` Sprite 加载整图底图。
- 如果仍保留旧 `Ground` 节点，必须改为 tile / chunk container，而不是 `place.world_map.base_1280`。
- 1280 proof 中应能单独关掉 building / prop / actor 层仍看出 tile / chunk 基底成立。

## 12. No Full-map Background Final Runtime

以下用法允许：

- 在 docs 或 art direction 中引用 `world_map_base_1280.png` 作为旧问题说明。
- 在迁移工具中用它对照位置、色彩和缺口。
- 在非 final debug / editor preview 中短期显示，并清楚标记为 reference。

以下用法禁止：

- `TownStage` final runtime 的 `GroundLayer` 直接加载 `place.world_map.base_1280`。
- 以 `world_map_base_1280.png` 截图作为 `visual_candidate` 或 `final_approved` 依据。
- 继续把新的 story prop、anchor、NPC 或 UI proof 叠到整图底图上完成视觉批准。
- 在 asset acceptance 中把 `place.world_map.base_1280` 重新标成 `final_approved`。

V02-VISUALRECOVERY-004 的纵切必须证明：去掉 `world_map_base_1280.png` 后，首屏仍由 modular layers 形成可居住小镇。

## 13. First-screen Minimal Asset Pack

`V02-VISUALRECOVERY-003` 首屏统一资产包最小范围如下。少于此范围，不得进入 V02-VISUALRECOVERY-004 final runtime 纵切。

Round159 parent integration note: Round155 保留的是长期 canonical 命名目标；Round156-Round159 的首屏纵切使用当前工程兼容 ID 完成 gate，并在 `ThemeProfileResource` / `AssetResolver` 中提供 canonical category alias。当前 gate 的有效 delivered set 是 `terrain.grass.soft_tile`、`terrain.path.soft_tile`、`terrain.plaza.warm_tile`、`region.home.edge_chunk`、`region.town_plaza.chunk`、`region.shop_street.chunk`、`region.school_line.chunk`、`building.home.cottage`、`building.shop.market`、`building.school.gate`、`world_prop.anchor.apple_basket`、`world_prop.anchor.clock_corner`、`world_prop.home.sunny_corner`、`soft_shadow.oval.default`、`glass_hud_bar` 和 `glass_footer_bar`。第 13 节余下的更细分 P0 IDs 作为后续扩展 backlog，不阻塞本轮 `002-006` 首屏恢复收口。

### 13.1 Terrain / Region

| Pack | Required IDs | Proof 点 |
|---|---|---|
| Home / Plaza ground | `terrain_tile.grass.home_day`、`terrain_tile.plaza.warm_day`、`terrain_edge.grass_path.soft`、`terrain_decal.flower_dot.soft` | 启动首屏，Home 和 Plaza 基底可读 |
| Main path | `terrain_tile.path.main_soft`、`terrain_tile.path.side_soft`、`terrain_edge.plaza_path.soft` | Home -> Plaza -> Shop / School 方向自然 |
| School line | `terrain_tile.school_yard.soft_ground`、`region_chunk.school_gate.arrival_day`、`region_chunk.school_yard.play_corner_day` | School Gate / Yard 不是课堂或考试空间 |
| Shop street | `terrain_tile.shop_street.pavement`、`region_chunk.shop_street.window_day` | Shop 入口和橱窗地点感成立 |
| Plaza chunk | `region_chunk.town_plaza.core_day` | NPC / resources / story bench 有生活停留空间 |
| Home yard chunk | `region_chunk.home_yard.core_day` | Home 起点、安全回家感成立 |

### 13.2 Building Prefab

| Building | Required ID | Proof 点 |
|---|---|---|
| Home | `building_prefab.home.cottage_day` | 首屏第一眼知道哪里是家 |
| Shop | `building_prefab.shop.corner_day` | 购物地点可见但无强消费 |
| School Gate | `building_prefab.school.gate_day` | 安全入口、欢迎感，不是压力门 |
| Story Bench / Book Nook | `building_prefab.plaza.story_bench_day` | B Bear / branch story 可落地 |

### 13.3 World Prop / Anchor

| Area | Required IDs | Proof 点 |
|---|---|---|
| Home anchors | `world_prop.anchor.apple_tree`、`world_prop.anchor.clock_corner`、`world_prop.anchor.sunny_dog_corner`、`world_prop.anchor.watch_charm` | A/C/D/W prop-first 成立 |
| School anchors | `world_prop.anchor.school_gate_soft`、`world_prop.anchor.kite_ribbon`、`world_prop.anchor.soft_net`、`world_prop.anchor.robot_sign`、`world_prop.anchor.yoyo_basket` | G/K/N/R/Y prop-first 成立 |
| Shop anchors | `world_prop.anchor.hat_sign`、`world_prop.anchor.ice_cream_cart`、`world_prop.anchor.jacket_window`、`world_prop.anchor.orange_stall` | H/I/J/O 看起来像生活橱窗 |
| Plaza props | `world_prop.plaza.bench_soft`、`world_prop.plaza.flower_basket`、`world_prop.anchor.bear_book_corner`、`world_prop.anchor.sun_flower_patch` | Plaza 有停留点和故事角 |
| Resource | `world_prop.resource.branch_ground` | Branch 可收集、贴地、低噪 |

### 13.4 Actor / Shadow

| Actor / Shadow | Required IDs | Proof 点 |
|---|---|---|
| Player | `actor_sprite.player.standing` 或 `actor_anim_sheet.player.p0_motion` + `actor_anim_meta.player.p0_motion` | 首屏和走动时比例稳定 |
| Sunny | `actor_sprite.pet.sunny.standing` 或 `actor_anim_sheet.pet.sunny.p0_motion` + `actor_anim_meta.pet.sunny.p0_motion` | Sunny 可爱、贴地、不遮挡 |
| Mina | `actor_sprite.npc.mina.standing` | Plaza / Home line 的朋友感 |
| Shopkeeper | `actor_sprite.npc.shopkeeper.standing` | Shop 门口温和店主感 |
| Story Bear | `actor_sprite.npc.story_bear.standing` | Story Bench 生活化，不课程化 |
| Shadows | `shadow.soft_ellipse.tiny`、`shadow.soft_ellipse.small`、`shadow.soft_ellipse.medium`、`shadow.building.wide_soft` | actor / prop / building 都不漂浮 |

### 13.5 Glass UI / Feedback

| UI | Required IDs | Proof 点 |
|---|---|---|
| HUD / Footer | `glass_ui.hud_bar.compact`、`glass_ui.footer_bar.compact` | 无大白条，图标和短文本可读 |
| Buttons | `glass_ui.button.icon_normal`、`glass_ui.button.icon_pressed` | 触控态清楚，不像课程按钮 |
| Panel | `glass_ui.panel.large`、`glass_ui.panel.small` | Shop / Settings / Album 可读可关 |
| Prompt / feedback | `glass_ui.prompt_bubble.soft`、`ui_feedback.prompt_soft_glow`、`ui_feedback.tap_ripple_soft`、`ui_feedback.collect_sparkle_soft` | 反馈低噪、不显示 cell 或任务箭头 |

## 14. Child-safety Visual Constraints

所有 modular 资产必须通过儿童视觉安全约束：

- 不出现恐吓、危险攀爬、独自远行压力、倒计时、迟到、警报、失败惩罚或受伤宠物表现。
- 不出现课程页、黑板题目、试卷、分数、正确率、排名、奖杯、打卡墙、完成率或背诵提示。
- 不用红色警告、强闪烁、过度奖励爆炸、售罄 / 限时 / 亏欠感视觉。
- School 相关资产表现为校门、操场、玩具、欢迎和散步地点，不表现为课堂检查。
- Shop 相关资产表现为生活店铺和橱窗，不表现为推销、稀缺、强消费或买不起羞辱。
- Coast / Animal Park / far edge 只作可选预览，不引导独自离开安全小镇或模仿危险动作。
- UI 不显示 editor、debug、grid、cell、坐标、测试、runner 或内部状态词。
- 英文只作为环境词、物件名、短 NPC 句、相册标签或可选小游戏素材；不成为主流程门槛。

## 15. 后续执行输入

`V02-VISUALRECOVERY-003 首屏统一资产包生产`：

- 按第 13 节最小 asset pack 生产 / 整理首屏 modular assets。
- 每个 asset 写 logical ID、category、尺寸 / pivot / footprint、resource path、status、provenance、proof 点和 child-safety notes。
- 新资产最多标 `production`，不得跳到 `final_approved`。

`V02-VISUALRECOVERY-004 TownStage 无整图底图渲染纵切`：

- 以第 11 节 layer order 改造 `TownStage`。
- 证明 `place.world_map.base_1280` 不再作为 final 主背景。
- 保持旧真实入口、A-Z 相册、NPC、资源、商店、小屋和设置路径不退化。

`V02-VISUALRECOVERY-005 HUD / Anchor / Actor 视觉降噪`：

- 按第 8 至第 10 节统一 anchor badge、actor scale、shadow 和 glass UI。
- 优先消除大白条、裸字母牌、漂浮角色、prompt 噪声和 panel / map 视觉碰撞。

`V02-VISUALRECOVERY-006 1280 Final Visual Gate`：

- 只允许 modular runtime proof 进入 `visual_candidate` / `final_approved` 判定。
- 判定视图至少覆盖 Town first screen、Home yard / HomeRoom、Shop、School Gate / Yard、Album / Shop / Settings glass UI。

## 16. Acceptance Checklist

本规格本身的验收：

- [x] 覆盖 terrain tile、region chunk、building prefab、world prop / prop-first A-Z anchor、actor scale / shadow、glass UI。
- [x] 固定 runtime layer order，并能映射到当前 `TownStage` scene-native layers。
- [x] 固定 logical asset ID 命名和新增 ThemeProfile 类别建议。
- [x] 明确 `world_map_base_1280.png` / `place.world_map.base_1280` 只作 reference，不得作为 final runtime 主画面。
- [x] 明确首屏最小资产包，供 `V02-VISUALRECOVERY-003` 直接生产。
- [x] 明确儿童安全视觉约束。
- [x] 明确后续 `003`、`004`、`005`、`006` 的执行输入。

后续 runtime / asset 验收：

- [x] ThemeProfile / AssetResolver 支持 V02.38 modular categories，旧类别有明确 fallback；Round159 父级集成补充 canonical aliases。
- [x] First-screen minimal asset pack 均有 production 资产、mapping、provenance、contact sheet 和 acceptance record；footprint / pivot 细化留后续 full production polish。
- [x] `TownStage` runtime 不再以 `place.world_map.base_1280` 创建主 Ground Sprite；该资产只保留为 `reference_only`。
- [x] 1280 proof 显示首屏由 tile / chunk / prefab / prop / actor / UI 分层组成；当前状态为 `visual_candidate`。
- [x] 26 A-Z anchor 常驻且稳定 ID / route_order / core_word 不变；V02.38 首屏 A / C / Home props 采用 prop-first，badge 已降噪，完整 26 prop 迁移留后续扩展。
- [x] Actor、prop、building 使用统一 soft shadow / contact shadow 方向；玩家、Sunny、NPC 和资源通过 focused / full runner 保持可读。
- [x] HUD / footer / prompt / Settings 等高频 UI 接入 Apple-like translucent glass 方向；文本 / 按钮可读可触通过 1280 proof 与 runner 复核。
- [x] 真实入口 smoke 覆盖启动、移动、`看看`、Home、Shop、School line、相册 / UI 和设置路径；NPC / resource 等旧路径由 full runner 回归不退化。
- [x] PM / Art Direction gate 用同轮 1280 proof 将本 lane 标为 `visual_candidate`；Round159 未授予 `final_approved`。
