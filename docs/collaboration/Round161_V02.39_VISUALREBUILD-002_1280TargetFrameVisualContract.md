# Round161 V02.39 VISUALREBUILD-002 1280 Target Frame Visual Contract

> 日期：2026-06-07
> 任务：`V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同`
> Owner：PM / Art Direction / Tech Art / UX
> 状态判定：2026-06-07 用户复核后，本轮生成的 target frame 被判定为不符合项目想要的游戏画面；`art_target_locked` 撤销。用户随后明确指定 `docs/collaboration/artpass003_visual_direction/artpass003_main_gameplay_direction_1280.png` 为正确正向参考；后续返修必须按该方向转译为 Sunshine Town 可执行 gameplay target。不得解锁 `V02-STORYBATCH-004/005`，不得标 `runtime_visual_match`，不得标 `final_approved`。
> 写入范围：新增本文档与 Round161 target frame 证据；不改 runtime / data / tests / assets。

## 0. 输入与方向基线

本合同读取并继承以下输入：

- `todo.md` 中 `V02-VISUALREBUILD-002..006`：002 负责 target frame 与 Godot 可执行合同；003 之后才拆 Logic Map / Visual Layout；005 才做 runtime match；006 才能判定 StoryBatch 是否解锁。
- `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 顶部 V02.39：V02.38 仅为 `visual_scaffold`，V02.39 必须按 `target 1280 frame -> visual layout contract -> unified asset kit -> runtime static-frame match -> gameplay binding -> art-direction gate` 执行。
- `docs/collaboration/Round160_V02.39_VISUALREBUILD-001视觉生产体系重建路线与任务包.md`：根因是生产模型错误，不能继续让 `world_map` / cell / place / anchor 全量直推首屏视觉。
- `docs/collaboration/Round92_V02.19_ARTPASS-003视觉方向确认包.md` 与三张方向图：

| 文件 | 规格 | 既有说明 | 本合同用途 |
|---|---|---|---|
| `docs/collaboration/artpass003_visual_direction/artpass003_main_gameplay_direction_1280.png` | 1280x720 PNG | Home-centered 地图、School / Shop / Animal Park / Coast Edge、道路层级和 glass HUD 同屏关系；方向参考，不是 runtime 资产 | 作为首屏世界构图、道路弧线、建筑体块和 HUD 空间参考 |
| `docs/collaboration/artpass003_visual_direction/artpass003_glass_ui_direction_1280.png` | 1280x720 PNG | 顶部 HUD、底部按钮、轻弹层、背包 / 相册 / 商店 translucent glass 方向；需替换为项目图标和中文短文本 | 作为 HUD / footer / panel 的透明度、边界、触控态和安全区参考 |
| `docs/collaboration/artpass003_visual_direction/artpass003_character_anchor_direction_1280.png` | 1280x720 PNG | 角色比例、Sunny / 居民友好度、Apple / Clock / Gate / Kite / Orange / Bear / Umbrella / Panda 等 anchor 物件化边界 | 作为 actor scale、anchor prop-first、字母 badge 降权参考 |

三张方向图均不是 `production` 或 `approved` 资产，不能被 runtime 直接切图复用。

### 0.1 Canonical Retarget Direction

用户已明确：正确的正向参考图是 `docs/collaboration/artpass003_visual_direction/artpass003_main_gameplay_direction_1280.png`。后续 `V02-VISUALREBUILD-002` 返修必须以它为 canonical gameplay style reference，目标不是复制该图，也不是把它当 runtime 背景，而是把它转译成 Sunshine Town 自己的可执行首屏：

- 继承：统一轻 2.5D 相机、温暖日光、圆润玩具感建筑、清晰道路弧线、动物居民生活感、低压力小镇密度、Apple-like glass HUD。
- 收敛：从参考图的全镇展示收敛到 Home-centered 首屏；School / Shop / Animal Park / Coast 只做方向预览，不同屏证明所有地点。
- 转译：建筑、动物、UI 图标、地点排布和装饰语言必须改为 Sunshine Town 自有设计；不得逐项复制外部 IP 特征。
- 可执行：返修 target 必须能拆为 Godot terrain / road / building prefab / prop / actor / shadow / glass UI layers，并能被 Visual Layout 复现。
- 禁止：不得再使用已驳回 Round161 PNG、拼贴图、逻辑地图截图、系统索引叠层或概念宣传图作为生产依据。

### 0.2 Round166 Retarget Attempts

基于 canonical reference 的返修尝试记录如下，均不自动授予 `art_target_locked`：

| 文件 | 规格 | 状态 | 结论 |
|---|---:|---|---|
| `docs/collaboration/round161_visual_rebuild_target/target_frame_v0239_round166_sunshine_town_retarget_1280.png` | 1024x1024 | rejected draft | image-to-image 方向较接近，但尺寸错误，不满足 1280x720 target frame 门槛。 |
| `docs/collaboration/round161_visual_rebuild_target/target_frame_v0239_round166_sunshine_town_retarget_1280x720.png` | 1280x720 | rejected draft | 尺寸正确，但用户复核指出画面已偏类 3D，Home 过大，压缩 gameplay 可走空间。不得作为资产包依据。 |
| `docs/collaboration/round161_visual_rebuild_target/target_frame_v0239_round166_sunshine_town_flat_2d_small_home_1280x720.png` | 1280x720 | rejected draft | 较前一版降低了房屋占比，但用户继续复核指出仍需进一步降 3D，否则后续瓦块地图难以编辑。不得作为资产包依据。 |
| `target_frame_v0239_round166_tile_editable_flat_1280.svg/png` | 1280x720 | removed rejected draft | 作为手工 SVG flat mock 尝试后被用户复核为更偏离目标；文件已删除，不进入目标目录、参考目录或资产依据。 |

新增硬性约束：

- Target 不得偏高精 3D 渲染、模型展示或景深概念图；应更像可在 Godot 中以 Sprite2D / Tile / prefab / UI layers 重建的 2D/2.5D gameplay mock。
- Home 是首屏生活焦点，但不能成为超大前景主角。Home 建议控制在 150-190px 宽，周围必须保留足够 yard、road、actor 和 interaction space。
- Main world band 中至少一半应读作可走道路、草地、院子、花园或互动空间，而不是被单一建筑或远景展示占满。
- 继续返修时不得再靠“文生图 / 图生图自由试错”直接追最终画面；下一步应先产出 tile-editable visual spec：tile size、道路 tile 套件、草地 / 花丛 / 水岸 tile、building prefab footprint、actor scale、prop scale 和 Map Editor 可编辑边界，再让美术或 Godot blockout 按该规格作图。
- Tile-editable 不等于低质示意图。目标仍需继承 `artpass003_main_gameplay_direction_1280.png` 的温暖、圆润、生活感和统一 UI，但底层必须能拆成瓦块、prefab 和 prop，而不是整张 3D 场景图。
- Round166 已新增 `docs/collaboration/Round166_V02.39_VISUALREBUILD-002_TileEditableVisualSpec.md`，作为下一轮白盒 / target frame 前置规格。后续不得跳过该规格直接重生目标图或开资产包。

## 1. 1280x720 Target Gameplay Frame

### 1.1 目标文件口径

`V02-VISUALREBUILD-002` 锁定的目标画面文件名口径如下：

- Target frame 文档合同：`docs/collaboration/Round161_V02.39_VISUALREBUILD-002_1280TargetFrameVisualContract.md`
- 本轮生成但已驳回的 target frame：`docs/collaboration/round161_visual_rebuild_target/target_frame_v0239_round161_home_centered_1280.png`
- 目标图规格：1280x720 PNG，RGB；仅作为 rejected evidence 保留，不得作为 art direction / visual layout 合同证据，不得作为 runtime full-map background、整图底图或资产生产依据。

本文档中的文字合同仍可作为问题清单和下一版 target brief 的输入，但本轮图片未锁定目标画面；当前状态回退为 `needs_retarget`，不代表 `art_target_locked`，也不代表 runtime 已匹配。

### 1.1.1 用户复核结论

用户复核明确指出：`target_frame_v0239_round161_home_centered_1280.png` 完全不是项目想要的游戏画面。PM / Art Direction 结论如下：

- 撤销此前对 Round161 target frame 的 `art_target_locked` 判定。
- `V02-VISUALREBUILD-004` 不得依据该图片生产资产包。
- 该图片只能保留为 rejected evidence，用来提醒后续 target frame 必须更像真实可执行 Godot gameplay screen，而不是漂亮概念插画、宣传场景或不可拆分整图。
- 下一轮必须先重做 `V02-VISUALREBUILD-002` 的目标画面口径：优先使用可执行 blockout / paintover / Godot mock frame，并由用户或 PM / Art Direction 明确确认后，才能重新进入资产包生产。

### 1.2 首屏画面目标

1280x720 首屏必须读作：孩子回到 Sunshine Town 的 Home-centered cozy town。画面第一眼是温暖小镇生活，不是地图索引、课程页面、功能总览或编辑器。

首屏必须包含：

- Home Core：画面视觉中心，位于中下偏左或中轴略左，屋顶、门口、院子和 Sunny 小角落可一眼识别。
- Safe Main Path：从 Home 门口向右上 / 上方弯出一条柔和主路，连接 Town Plaza / Shop / School line 的可预览方向。
- Town Life Cluster：Home 旁边有 2-4 个生活物件，如花盆、邮箱、树、长椅、Sunny toy、Apple basket 或 Clock corner。它们提供居住感，不像任务 marker。
- Actor Presence：玩家、Sunny 和 1 个居民可见但不抢画面。角色站在 Home 院子或主路交界，能暗示可移动和可互动。
- A-Z Prop-first Cues：首屏只露出少量 A-Z 线索，优先 Home 线 A/C/D/W 或一处 Shop / School 方向预告。它们必须先是生活 prop，再是记忆锚点。
- Glass HUD：顶部与底部 UI 轻悬浮，不把世界框成窗口，不用厚卡片解释系统。

首屏不得试图同时证明 26 个 anchors、所有 places、所有 NPC、所有资源和所有系统入口存在。

### 1.3 构图与负空间

构图按 1280x720 固定判断：

| 区域 | 像素范围 | 画面职责 |
|---|---|---|
| Top Safe HUD | y 16-88 | 轻 glass HUD，小镇状态、金币 / Sunny / 今日短提示；不得压住建筑主轮廓 |
| Sky / Far Depth Breathing Space | y 80-170 | 远景树线、School / Shop 方向小体块、柔和空气感；不得塞满 marker |
| Main World Band | y 150-610 | Home、道路、生活 prop、actor、A-Z prop-first 线索的主要表演区 |
| Bottom Action Safe Area | y 620-704 | 底部操作栏和触控按钮；世界画面应从按钮背后轻微延续，不被硬切成面板 |
| Left / Right Edge Padding | x 24-80 与 x 1200-1256 | 只放边缘树、栅栏、水边或远景，不放必须点击的小目标 |

负空间要求：

- Home 周围保留 80-140px 的可停留空地，不被资源、badge、NPC 或 UI 堵死。
- 主路弯曲处保留可读的空白路面，成为玩家动线，不叠满文字。
- 画面上方保留柔和远景空间，让 Shop / School 只是“可去的方向”，不是系统菜单。
- UI 下面保留 12-20px 世界可见缓冲，避免 HUD 像压在截图上的白条。

### 1.4 动线

玩家视觉动线固定为：

1. 先看到 Home 门口和 Sunny 小角落。
2. 视线沿弯曲主路走到 Town Plaza / Shop 方向。
3. 再看到远处 School line 或 Story / Park 预览。
4. 最后注意到底部 `看看` / 小屋 / 背包 / 相册等真实入口。

这条动线必须通过道路、建筑朝向、树篱、阴影和角色朝向完成，不依赖箭头、课程提示、全量 label 或系统 marker。

## 2. Godot 可执行 Visual Layout 合同

### 2.1 Camera / Viewport

- 阻塞验收视口固定为 `1280x720` 横屏。
- Camera 为轻 2.5D 俯视斜角表现，目标不是真实透视相机，而是稳定的 2D / Sprite2D 分层画面。
- 首屏逻辑焦点为 Home Core，世界中心不等同于 `world_map` 几何中心。
- Runtime 匹配阶段应先禁用自动展示全量地图的构图策略；镜头默认落在 Home-centered target frame。
- Camera smoothing 可保留，但 target proof 必须提供静态首帧，避免用运动模糊或镜头过渡掩盖构图问题。

### 2.2 Canvas / Coordinate Policy

- Canvas 以 1280x720 设计；后续 960x540 留到版本适配专项，不阻塞本轮。
- `world_map` 的 cell / collision / interaction / save / A-Z stable ID 继续作为逻辑事实，但不得直接决定首屏所有可见物件的屏幕位置。
- Visual Layout 需要独立持有 visual anchor、depth band、proxy position、occlusion rule、focus state 和 UI safe area。
- 孩子端不得显示 cell、grid、tile boundary、coordinate、footprint、occupied cells 或 editor marker。

### 2.3 Depth Bands

Godot runtime 应按以下 depth bands 组织，具体 z-index 可由 003/005 实现时映射：

| Band | 内容 | 视觉规则 |
|---|---|---|
| `far_backdrop` | 远景树线、水边、School / Shop / Park 轮廓预览 | 低对比、低细节，不可交互，不显示 label |
| `ground_shape` | 草地、主路、院子边界、柔和地块色块 | 连续空间，不露裸 grid / cell；道路用弧线和软边 |
| `large_structures` | Home、Shop distant prefab、School line distant prefab、树群 | 同相机、同光源、同比例；Home 优先清楚 |
| `mid_props` | 花盆、邮箱、bench、Apple basket、Clock corner、生活装饰 | 先服务生活密度，再承担 A-Z 线索 |
| `actors` | player、Sunny、Mina / 居民 | feet baseline 清楚，阴影统一，不能漂浮 |
| `front_props` | 近景树叶、篱笆、软遮挡物 | 可轻微遮挡地面，不遮挡 HUD / 底部按钮和核心交互 |
| `interaction_feedback` | prompt glow、tap ripple、hover / focus ring | 默认隐藏或低噪；靠近后出现，不常驻全屏 |
| `glass_ui` | HUD、footer、panel、toast | 轻 glass，图标优先，短文本辅助 |

### 2.4 Layer Order

基础 layer order：

1. Background color / atmospheric fill
2. Far backdrop sprites
3. Terrain and road shapes
4. Large structures
5. Ground shadows
6. Mid props and A-Z prop-first anchors
7. Actor shadows
8. Actors
9. Front props / soft occluders
10. Focus / prompt / tap feedback
11. Glass HUD and footer
12. Temporary panels / modal glass

禁止把旧 `place context`、debug label、fallback marker 或 low-alpha scene fragment 放在 3-8 层中冒充生活细节。

### 2.5 Asset Scale

以 1280x720 首屏为准：

| 类型 | 目标屏幕尺寸 | 说明 |
|---|---|---|
| Home main prefab | 210-280px 宽，150-210px 高 | 首屏最大生活焦点，但不占满画面 |
| Shop / School distant prefab | 90-160px 宽 | 作为方向预览，不抢 Home |
| Player | 46-64px 高 | 轮廓可读，能与地面阴影绑定 |
| Sunny | 32-46px 高 | 比 player 小，靠近 Home 或 player |
| NPC | 48-68px 高 | 与 player 同族比例，不成人化或怪异放大 |
| Major A-Z prop | 42-86px 宽 | 先像物件；字母 badge 如需出现，尺寸低于物件主体 |
| Small life prop | 18-48px 宽 | 形成生活密度，不承担点击证明 |
| HUD icon | 24-36px | 图标清楚，文字短 |
| Footer button hitbox | 72-96px 高区域内稳定 | 可触，不贴屏幕边 |

资产必须同相机、同光源、同边缘语言。不得混用不同代际的旧 scene fragment、低清 PNG、SVG 占位、方向图切片和程序色块。

### 2.6 Pivot / Feet Baseline

- Actor pivot 使用 feet baseline：脚底中心为排序和投影基准。
- 建筑 pivot 使用门口 / 接地中心作为视觉定位基准，不使用图片中心导致漂浮。
- A-Z prop pivot 使用接地点中心；树、标牌、篮子、钟、门、风筝线等都必须有可理解的落地点。
- 可交互代理可以偏移到更易点的位置，但视觉物件不能因此漂移。

### 2.7 Shadow

- 所有 actor 与可移动 / 可交互 prop 必须有软椭圆接触阴影。
- Home / 大型结构使用更宽、更淡的地面阴影，方向与主光一致。
- 阴影不得黑重、不得像 debug collision blob。
- 没有接触阴影的 prop 不得进入 target proof，因为会造成贴纸感和漂浮感。

### 2.8 UI Safe Area

- HUD 采用 Apple-like translucent glass：轻透明、柔和模糊、1-2px 高光边、柔和阴影、短文本可读。
- 顶部 HUD 不超过 y 16-88；底部 footer 主体不超过 y 620-704。
- UI 不得使用厚卡片、白色大板、课程面板或说明书式长文本。
- 高频按钮使用图标 + 1-3 个汉字短标签；关闭按钮位置稳定。
- Panel 只在打开背包 / 商店 / 相册 / 设置时出现；首屏默认不展示大面板。
- HUD 与 footer 不得遮挡 Home 门口、player、Sunny、主要路口或 A-Z prop-first 线索。

### 2.9 A-Z Prop-first 优先级

A-Z 仍是世界结构和记忆宫殿，但首屏表达降权：

| 优先级 | 表达 | 可见规则 |
|---|---|---|
| P0 visible | Home 周围少量生活 prop，如 Apple basket、Clock corner、Sunny dog corner、Watch charm | 可以首屏可见，必须先像生活物件 |
| P0 hinted | School / Shop 方向的 Gate、Kite、Orange 等 | 可作为远处小物件或路牌方向感，不常驻大 badge |
| P1 focus | 其余 anchor | 靠近、相册、局部 focus 或探索时出现，不做系统索引 |
| Badge | 小型辅助识别 | 不高于物件主体，不裸露成字母牌，不排成 A-Z 全量列表 |
| Story memory | 通过地点、物件、短反馈和回访路径体现 | 不通过课程页、词表或打卡目标体现 |

新词与 anchor 的 `letter`、`core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook`、`review_path` 规则继续保留；但视觉首屏不得把这些字段直接显示成系统说明。

## 3. Forbidden Remnants

以下残留在 target frame、runtime frame 和 side-by-side proof 中均为阻塞项：

- Full-map background：不得恢复 `world_map_base_1280.png` 或任何整张地图底图作为 final runtime 主画面。
- 裸 grid / cell：不得显示格子线、瓦块边界、坐标、debug collision、footprint、occupied cells 或编辑器符号。
- 课程面板：不得出现课程页、单元页、测验、词表墙、正确率、分数、排名、打卡、完成率或作业口吻。
- 厚卡片：不得用厚重白卡、大面板、纸质卡、storybook / picture-book 内页风格承载首屏。
- 裸字母牌：不得用大写 A-Z 字母牌、字母柱、字母路线或系统索引作为 anchor 主表现。
- 系统索引式全量 marker：不得在首屏同时铺满 26 anchors、所有 places、所有 NPC、所有 resource 和全量 labels。
- 旧 scene fragment 混搭：不得混入旧低透明 context、旧 place block、旧 road cell、旧 prefab 残片、旧 SVG 占位或不同风格 generation 批次的碎片。
- Debug / contract wording：孩子端不得看到 `anchor_id`、`place_id`、`cell`、`grid`、`logic map`、`visual layout`、`runtime match` 等工程词。
- UI explanation overload：HUD 不得承担教学说明书，不得用长文本解释系统。

## 4. Proof Checklist

`V02-VISUALREBUILD-002` 的 proof checklist 只用于锁 `art_target_locked`；后续 005/006 必须复用并补齐 runtime 证据。

| 检查项 | 002 要求 | 005 / 006 后续要求 |
|---|---|---|
| Target frame 文件 | 本轮 target PNG `docs/collaboration/round161_visual_rebuild_target/target_frame_v0239_round161_home_centered_1280.png` 已被用户复核驳回，只能作 rejected evidence | 004 / 005 / 006 不得引用该图作为生产或验收目标；必须等待新版 target frame |
| Runtime frame | 本轮不要求 runtime 截图，不改 runtime | 必须导出 1280x720 Godot runtime screenshot |
| Side-by-side | 本轮定义并排判断维度 | 必须提供 target / runtime 并排图或同页复核记录 |
| 真实入口 | 本轮只要求不得设计隐藏入口 | 运行时必须从孩子端真实入口启动、移动、看看、HUD / footer 操作，不用隐藏 contract 按钮冒充 |
| A-Z 稳定 | 不改 A-Z ID、letter、core_word、route_order、card_id、audio_id；首屏 prop-first 降权 | Runtime 匹配后仍保留 26 anchor 稳定事实和回访路径，不因视觉布局丢失核心 anchor |
| 儿童文本安全 | 合同禁止课程压力、工程词、惩罚和家长报告口吻 | Runtime HUD、prompt、toast、NPC / object 短句必须通过儿童安全审查 |
| Forbidden remnants | 本文档列出阻塞残留 | Runtime proof 中不得出现任何阻塞残留 |
| UI safe area | 1280x720 HUD / footer safe area 已定义 | Runtime 截图中 HUD / footer 不遮挡 Home、player、Sunny、主路和核心 prop |
| Artpass003 贴近度 | 合同继承 Round92 三张方向图 | Runtime 必须对照 main gameplay / glass UI / character anchor 三张方向图复核 |

## 5. 状态判定与交接

本任务原计划完成后只能给出：

- `art_target_locked`：1280 target gameplay frame 的画面目标和 Godot 可执行视觉合同已明确，可交给 003 / 004 / 005。

但 2026-06-07 用户复核后，本轮不得给出 `art_target_locked`。当前状态为：

- `needs_retarget`：目标画面需要重做；Round161 图片不符合项目想要的游戏画面。
- `V02-VISUALREBUILD-002` 必须回到进行中 / 返修。
- `V02-VISUALREBUILD-004` 必须撤回 Ready，等待新版 target frame 和用户 / PM / Art Direction 确认。

本任务不得给出：

- `runtime_visual_match`：因为本轮不改 runtime，也不导出 runtime screenshot。
- `final_approved`：因为尚未经过 target/runtime side-by-side、真实入口 smoke、A-Z runtime 稳定和 PM / Art Direction final gate。
- StoryBatch 解锁：`V02-STORYBATCH-004/005` 继续阻塞。Round153 第二批 production 资产仍只作为库存，不得叠到当前 `visual_scaffold` 上。

### 交给后续任务的明确输入

- `V02-VISUALREBUILD-003`：建立 Logic Map / Visual Layout 分层方案，让 `world_map` 管事实，让 Visual Layout 管构图、depth、occlusion、proxy 和 focus state。
- `V02-VISUALREBUILD-004`：按本文 target frame 生产统一环境资产包与 composition kit，资产必须同相机、同光源、同比例、同阴影语言，并通过 logical asset ID 管理。
- `V02-VISUALREBUILD-005`：先匹配一张 1280 runtime static frame，再恢复必要交互代理；必须提交 target/runtime side-by-side proof。
- `V02-VISUALREBUILD-006`：只有 runtime visual match、真实入口、A-Z 稳定和儿童文本安全全部通过，才可讨论 StoryBatch 是否解除阻塞。

## 6. PM / Art Direction 结论

V02.39 的第一张目标画面不是“把所有系统都摆出来”，而是“孩子一眼知道这里是可以回来的家和小镇”。Home 是首屏情绪中心，道路是探索邀请，A-Z 是生活物件里的记忆线索，UI 是轻轻托住操作的玻璃层。

## 7. Round161 证据记录

- Target frame：`docs/collaboration/round161_visual_rebuild_target/target_frame_v0239_round161_home_centered_1280.png`
- 生成方式：按仓库 Image Generation Fallback 使用 `/home/xionglei/GameProject/tools/image_generator.js` text-to-image。
- 尺寸验证：`file docs/collaboration/round161_visual_rebuild_target/target_frame_v0239_round161_home_centered_1280.png` 返回 `PNG image data, 1280 x 720, 8-bit/color RGB, non-interlaced`。
- 用户复核：该图完全不是项目想要的游戏画面。
- 修正后的状态结论：`V02-VISUALREBUILD-002` 未达到 `art_target_locked`，Round161 图片不得作为资产生产依据；`V02-STORYBATCH-004/005` 继续阻塞。

本合同锁定的是 target frame 和 Godot 执行边界；它不会替代 runtime proof。下一步必须把这个目标转成 Visual Layout schema / scene contract 和统一资产包，再用 Godot 1280 runtime frame 与目标画面并排复核。
