# Round146 V02.33 ARTPIPE-001 Tile map / 场景 / 故事资产生产规格

> 日期：2026-06-07
> 任务：`V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格`
> 状态：完成
> 下一轮 Ready：`V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范`

## 本轮范围

本轮只输出美术资产生产规格和 backlog，不生成正式资产、不修改 `ThemeProfile`、不改 runtime、不改正式 JSON。输入来自：

- Round142 故事总纲：P0/P1/P2 章节、26 A-Z story memory 和首批 story prop needs。
- Round143 当前地图适配：`direct_runtime`、`asset_only` 和 Map Editor 候选。
- Round144 动作规格：player / Sunny / NPC motion pack、logical animation ID 和 fallback。
- Round145 操控规格：连续移动、prompt、camera 和 hidden-grid 对 tile / edge / UI feedback 的要求。
- `docs/10_美术风格与换肤预留.md`：Animal Crossing-like cozy town、Apple-like translucent glass UI、logical asset ID 和 `production` / `approved` 状态规则。

当前 repo 已有 production places、26 anchor PNG、character standing、Sunny standing、furniture、UI skin/icons；缺口集中在 story props、tile / edge atlas、motion packs、UI feedback 和 animation metadata。本轮把这些缺口变成可交给美术团队和 tech art 的生产清单。

## 生产总则

| 规则 | 要求 |
|---|---|
| 风格 | Animal Crossing-like cozy town，温暖、明亮、圆润、可居住，不采用绘本 / storybook / picture-book 叙事插画 |
| UI | Apple-like translucent glass，只做轻反馈，不做课程面板、厚卡片或任务榜 |
| 接入 | 每项必须有 logical asset ID；后续经 `ThemeProfile` / `AssetResolver` 映射 |
| 状态 | 新资产初始最多标 `draft` 或 `production`；`approved` 必须有同轮 1280 proof 和 PM / Art Direction 判定 |
| A-Z | 不重排 anchor，不替换稳定 ID / letter / route_order；anchor refresh 只能增强生活物件 |
| School | School Gate / Yard 是生活地点，不画成课堂、考试、作业或分数空间 |
| Far edge | Coast / X / Z 只作可选预览，不生产 P0 必经引导箭头 |
| 验收 | 每个 P0 pack 需要 1280x720 proof 点；960x540 留到全量开发后适配专项 |

## 目录建议

```text
assets/art/tiles/
assets/art/tiles/metadata/
assets/art/story_props/
assets/art/story_props/home/
assets/art/story_props/school/
assets/art/story_props/shop/
assets/art/story_props/plaza/
assets/art/story_props/animal_park/
assets/art/story_props/coast/
assets/art/characters/animation/
assets/art/characters/animation/metadata/
assets/art/pets/animation/
assets/art/pets/animation/metadata/
assets/art/ui/feedback/
```

目录不是 runtime 合同；runtime 只认 logical asset ID。

## Tile / Ground Backlog

| Pack ID | Logical asset IDs | 内容 | 尺寸建议 | 优先级 | 依赖 | 1280 proof 点 |
|---|---|---|---|---|---|---|
| `tilemap_p0_ground_pack_001` | `tile.grass.home_day`、`tile.path.main_soft`、`tile.path.side_soft`、`tile.plaza.warm_day`、`tile.school_yard.soft_ground`、`tile.shop_street.pavement` | Home、Plaza、School、Shop 的基础地面和可走路径 | 64x64 tile；可选 128x128 高精源；PNG alpha / atlas metadata | P0 | Round145 连续移动脚底读感 | Home -> School -> Shop 横向走动，脚底不浮、不像格子棋盘 |
| `tile_edge_p0_pack_001` | `tile_edge.grass_path.soft`、`tile_edge.plaza_path.soft`、`tile_edge.school_yard_path.soft`、`tile_edge.shop_path.soft` | grass/path/plaza/school/shop 过渡边缘 | 64x64；四边 / 内外角 | P0 | `tilemap_p0_ground_pack_001` | 道路边界自然，不显示硬方格 |
| `tile_decoration_p0_pack_001` | `tile_decal.sun_patch.soft`、`tile_decal.leaf_scatter.light`、`tile_decal.flower_dot.soft` | 轻地面装饰，辅助 story memory | 64x64 decal，alpha | P0 | S/K/F story hooks | 不干扰 resource / prompt，不遮挡玩家脚底 |
| `tilemap_p1_outer_pack_001` | `tile.animal_park.grass`、`tile.coast.sand_soft`、`tile.coast.water_edge_safe` | Animal Park / Coast 可选区域地面 | 64x64 tile + edge | P1 | P1 chapters | Park / Coast 看起来可散步，但无 P0 强制路线 |

## Story Prop Backlog

| Asset ID | 地点 | 绑定故事 / anchor | 类型 | 尺寸建议 | 优先级 | 生产说明 | Proof 点 |
|---|---|---|---|---|---|---|---|
| `story_prop.home.apple_welcome_photo` | Home / HomeRoom | A Apple | prop | 96x96 或 HomeRoom 内 1x1 | P0 | Apple welcome box + tiny photo frame；英文只作为 `Apple` 物件名 | Home 早晨 / HomeRoom，能看出安全起点 |
| `story_prop.home.clock_corner_chair` | Home / HomeRoom | C Clock | prop | 128x96 | P0 | Clock corner + cozy chair；不做赶时间 | HomeRoom，Clock 有慢生活感 |
| `story_prop.home.sunny_towel_paw` | Home / Sunny corner | D Dog | prop | 96x64 | P0 | Paw towel / Sunny 角落 | Sunny greet proof，不制造照顾压力 |
| `story_prop.home.watch_wall_charm` | Home wall | W Watch | prop | 64x96 | P0 | 小 wall charm，不做闹钟倒计时 | Home wall proof |
| `story_prop.school.gate_bell_soft` | School Gate | G Gate | prop | 96x128 | P0 | gate bell / welcome detail；不画课堂铃声压力 | School Gate 到达 proof |
| `story_prop.school.kite_leaf_path` | Walk / Yard | K Kite | prop + decal | 128x128 | P0 | Kite ribbon + spinning leaf | Home-School Walk 连续移动 proof |
| `story_prop.school.yard_net_robot_yoyo_corner` | School Yard | N/R/Y | prop pack | 192x128 或 3x 96x96 | P0 | Net、Robot、Yo-yo 生活玩具角 | School Yard prompt proof |
| `story_prop.shop.hat_ribbon_window` | Shop Street / Ribbon Corner | H Hat | prop | 128x128 | P0 | Hat sign + ribbon loop；配合 ribbon resource | Shop front / Ribbon Corner proof |
| `story_prop.shop.icecream_orange_jacket_window` | Shop Street | I/O/J | prop pack | 192x128 | P0 | 橱窗贴纸 / orange stand / jacket display | Shop Street proof |
| `story_prop.plaza.bear_book_branch_bookmark` | Story Bench | B Bear | prop | 160x128 | P0 | Bear open book + branch bookmark | Story Bench / branch prompt proof |
| `story_prop.plaza.queen_violin_poster` | Story Bench | Q/V | prop | 128x128 | P1 | 小 poster，不做表演评分 | Story Bench P1 proof |
| `story_prop.animal_park.sign_group` | Animal Park | E/F/L/P/Z | prop pack | 256x160 | P1 | animal sign group / gentle wayfinding | Animal Park optional proof |
| `story_prop.coast.umbrella_shell_path` | Coast Edge | U | prop + decal | 160x128 | P1 | umbrella shade + shell path | Coast optional proof |
| `story_prop.coast.x_box_preview` | Coast far edge | X | boundary prop | 96x96 | P2 | X box silhouette only，非寻宝目标 | Far edge preview proof |

## A-Z Anchor Refresh Backlog

现有 26 anchor 已有 production PNG，本轮不要求重画全部，只定义“增强而非替换记忆结构”的 refresh 包。

| Pack ID | Anchor | Refresh 目标 | 规则 | 优先级 |
|---|---|---|---|---|
| `anchor_refresh_home_p0_pack_001` | A/C/D/W | 与 Home story props 视觉统一 | 保留 anchor ID 和 core object；增强 photo / chair / towel / charm 关系 | P0 |
| `anchor_refresh_school_p0_pack_001` | G/K/N/R/Y | 与 School Yard story corner 统一 | 字母 badge 辅助，物件是主体 | P0 |
| `anchor_refresh_shop_p0_pack_001` | H/I/J/O | 与 Shop window / Ribbon Corner 统一 | 不做商品推销压力 | P0 |
| `anchor_refresh_plaza_p0_pack_001` | B/Q/V/S/T | Story Bench / Sun / Taxi 生活线 | Q/V 为 poster 预留，不进入 P0 必经 | P0/P1 |
| `anchor_refresh_outer_p1_pack_001` | E/F/L/M/P/U/X/Z | Animal Park / Coast 可选预览 | 不做远郊强引导 | P1/P2 |

## Character Motion Backlog

| Pack ID | Logical IDs | 内容 | 文件建议 | 优先级 | Proof 点 |
|---|---|---|---|---|---|
| `character_motion_player_p0_pack_001` | `anim.player.idle.*`、`anim.player.walk.*`、`anim.player.interact.*` | Player 4 向 idle / walk / interact | `assets/art/characters/animation/player_p0_motion_v001.png` + metadata JSON | P0 | Home -> School -> Shop 连续走动 |
| `pet_motion_sunny_p0_pack_001` | `anim.pet.sunny.idle.*`、`walk.*`、`wag.*`、`greet.*` | Sunny idle / walk / wag / greet | `assets/art/pets/animation/sunny_p0_motion_v001.png` + metadata | P0 | Home greet / Sunny corner |
| `character_motion_mina_p0_pack_001` | `anim.npc.mina.idle.*`、`greet.*`、`short_walk.*` | Mina idle / greet / short_walk | `assets/art/characters/animation/mina_p0_motion_v001.png` + metadata | P0 | Plaza / School Walk prompt |
| `character_motion_shopkeeper_p0_pack_001` | `anim.npc.shopkeeper.idle.*`、`greet.*`、`tidy.*` | Shopkeeper welcome / tidy | `assets/art/characters/animation/shopkeeper_p0_motion_v001.png` + metadata | P0 | Shop front / Ribbon Corner |
| `character_motion_story_bear_p0_pack_001` | `anim.npc.story_bear.idle.*`、`greet.*`、`read.*` | Story Bear read / greet | `assets/art/characters/animation/story_bear_p0_motion_v001.png` + metadata | P0 | Story Bench |
| `character_motion_bus_helper_p1_pack_001` | `anim.npc.bus_helper.idle.*`、`greet.*`、`sign_check.*` | Bus Helper sign check | `assets/art/characters/animation/bus_helper_p1_motion_v001.png` + metadata | P1 | Plaza edge / Taxi sign |

Metadata 必须包含 frame size、pivot、fps、loop、direction、fallback asset ID。缺 metadata 时不得进入 production。

## UI Feedback Backlog

| Asset ID | 用途 | 尺寸建议 | 优先级 | 规则 |
|---|---|---|---|---|
| `ui_feedback.prompt_soft_glow` | 当前 `看看` target 的轻 glow | 64x64 / 96x96 alpha | P0 | 不像任务箭头，不遮挡角色 |
| `ui_feedback.collect_sparkle_soft` | resource collect 轻反馈 | 64x64 strip 或 6 帧 | P0 | 无奖励爆炸，不制造完成率 |
| `ui_feedback.album_badge_soft` | 相册落账小反馈 | 64x64 | P0 | 只表达发现，不显示分数 |
| `ui_feedback.tap_ripple_soft` | tap-to-move 地面反馈 | 96x96 6 帧 | P0 | 不显示目标 cell 或路径线 |
| `ui_control.virtual_joystick_base` | 移动端虚拟摇杆底 | 160x160 源图 | P1 | 半透明，不遮挡底栏 |
| `ui_control.virtual_joystick_knob` | 虚拟摇杆 knob | 72x72 源图 | P1 | 触控反馈温和 |

## Production Batches

| 批次 | 目标 | 包含 | 完成条件 |
|---|---|---|---|
| `art_batch_p0_story_walk_001` | Home -> School -> Shop -> Story Bench 第一批故事动线 | P0 tile、Home / School / Shop / Story Bench story props、Player / Sunny / Mina / Shopkeeper / Story Bear motion、prompt / collect feedback | 每项有 logical ID、PNG / metadata 计划、1280 proof 点和 child-safety notes |
| `art_batch_p1_outer_preview_001` | Animal Park / Coast 可选预览 | Animal Park sign group、Coast umbrella / shell、X box、outer tiles、Bus Helper motion | 不进入 P0 必经；proof 只验证可选回访 |
| `art_batch_editor_marker_001` | Map Editor 候选可视化 | Story Bench poster corner、School Yard story corner、Animal Park sign group、Coast X preview marker art | 后续 ARTPIPE-002 规定 marker / ThemeProfile 接入 |
| `art_batch_ui_touch_feedback_001` | 操控反馈和移动端预留 | prompt glow、tap ripple、collect sparkle、joystick base / knob | HUD / footer 不遮挡，panel lock 时不误导 |

## Asset Acceptance 字段

后续 V02.34 每项生产资产至少记录：

| 字段 | 说明 |
|---|---|
| `record_id` | `asset_accept_YYYY_MM_DD_<asset_id>` |
| `logical_asset_id` | 稳定 logical ID |
| `category` | `tile_atlas` / `place_assets` / `story_prop_assets` / `character_animation_assets` / `pet_animation_assets` / `ui_feedback_assets` |
| `status` | `draft` / `production` / `approved` |
| `resource_path_for_mapping` | repo 内路径，仅 ThemeProfile 使用 |
| `replacement_target` | 替换哪个占位、story prop 或 motion pack |
| `viewport_evidence` | 1280 proof 文件名或待补 |
| `acceptance_result` | `pending` / `pass` / `needs_fix` |
| `notes_child_safety` | 是否无课程、测试、压力、警告 |
| `notes_anchor_integrity` | 是否保持 A-Z ID / route_order / story binding |

## 禁用风格和内容

- 不采用绘本内页、课程地图、厚卡片式学习 app、裸字母牌阵列。
- 不使用倒计时、打卡、分数、奖杯、排行榜、测试卷、课堂黑板作为 P0 视觉。
- 不把 story props 画成不可触达的远景插画；P0 prop 必须能落在当前地图 / HomeRoom / Map Editor 候选。
- 不生成无法进入 `ThemeProfile` / `AssetResolver` 的孤立图片。
- 不把 `production` 自动写成 `approved`。

## 交付给后续任务的输入

`V02-ARTPIPE-002`：

- 增加 `story_prop_assets`、`character_animation_assets`、`pet_animation_assets`、`animation_metadata_assets`、`ui_feedback_assets` 的 ThemeProfile / AssetResolver 接入规范。
- 规定 Map Editor marker 如何引用 story prop logical ID。
- 规定 atlas / sprite sheet import、metadata 校验和 fallback。

`V02-ARTPROD-001`：

- 优先生产 `art_batch_p0_story_walk_001`。
- 每个 production asset 必须进入 repo asset tree，并附 logical ID / metadata / proof 计划。
- production 后仍需 V02.34 / V02.36 proof 才能进入 approved。

## 验收结论

- tile map、ground edge、story props、A-Z anchor refresh、character motion、UI feedback backlog：通过。
- 每项有 logical asset ID、用途、尺寸建议、优先级、依赖故事线、是否 atlas / sprite sheet、验收截图点和禁用风格：通过。
- 与 Round142 / 143 / 144 / 145 输入一致：通过。
- 不生成资产、不改 ThemeProfile、不改 runtime / data / tests：通过。

下一轮 Ready：`V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范`。
