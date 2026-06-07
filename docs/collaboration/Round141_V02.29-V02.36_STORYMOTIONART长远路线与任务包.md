# Round141 V02.29-V02.36 STORYMOTIONART 长远路线与任务包

> 日期：2026-06-07
> 任务：`V02-STORYMOTIONART-001 完整故事线 / 动作操控 / 美术生产规格长远规划`
> 状态：规划完成，下一轮 Ready 为 `V02-STORYLINE-002 全量故事线总纲与章节骨架`

## 背景判断

V02.28 已证明 Map Editor 可用于真实小批量生产。现在的问题不再是“能不能加内容”，而是“接下来几轮到底按什么顺序，把故事、地图、动画、操控、美术和实现串成一条生产线”。如果继续零散加点，美术团队会缺少资产边界，动画团队会缺少帧规格，Godot 实现会缺少交互手感目标，故事内容也容易脱离当前地图和 A-Z 记忆宫殿结构。

因此 V02.29-V02.36 作为一组长线阶段：先完成故事与地图适配，再完成动作和操控规格，随后让美术团队按统一资产合同生产 tile map、故事物件和动画素材，最后进入 Godot 纵切实现与验收。

V02.29 本身只做长远路线和第一批规格，不直接生成正式资产，不重排 A-Z anchor，不扩远郊为 P0，不把 School 改成课程空间，不把孩子端 runtime 做成可见瓦块或编辑器界面。

## 长远目标

这一组阶段的目标是把 Sunshine Town 从“工具链可生产的小镇”推进到“故事、动作、美术、操控都可以批量生产的生活小镇”：

- 故事线：覆盖 Home、Town Plaza、Shop Street、School line、P1/P2 可选区和 26 个 A-Z anchor 的章节结构。
- 当前地图适配：故事落在现有 `world_map`、place、resource、NPC routine 和 A-Z anchor 结构上，只做局部可生产调整。
- 行走动画：明确玩家、NPC、Sunny 的移动状态、方向、帧数、尺寸、pivot、速度感和 sprite sheet 交付规则。
- Animal Crossing-like 操控：明确连续移动、隐藏网格、镜头跟随、靠近交互、触屏 / 键盘 / 手柄策略。
- 美术生产清单：输出 tile / ground / edge / prop / story object / character / animation / UI 资产需求。
- Map Editor 接入规范：所有资产以 logical asset ID、place/resource/routine/anchor 绑定和验收截图点进入管线。

## 多轮路线图

| 版本 / 轮次组 | 主题 | 核心问题 | 主要产出 | 完成后才能进入 |
|---|---|---|---|---|
| V02.29 | 长远路线与故事总纲 | 故事到底讲什么，如何围绕当前地图和 A-Z 展开 | 多轮路线、故事总纲、章节结构、P0/P1/P2 分层、首批故事资产需求 | 地图适配细化 |
| V02.30 | 当前地图适配与内容生产蓝图 | 哪些故事能直接落地，哪些需要 Map Editor 小改 | story-place-anchor-NPC 绑定表、Map Editor 候选清单、P0 路线图、缺口清单 | 动画 / 操控规格确认 |
| V02.31 | 行走动画与角色动作规格 | 角色如何走、停、转身、互动、打招呼 | player / NPC / Sunny sprite sheet 规格、状态机、命名、pivot、runtime proof 口径 | 美术动画生产 |
| V02.32 | Animal Crossing-like 操控手感规格 | 移动、镜头、靠近交互和隐藏网格如何统一 | 输入方案、速度曲线、镜头规则、prompt 优先级、触屏 / 键鼠 / 手柄策略、实现任务拆分 | Godot 操控纵切 |
| V02.33 | Tile map / 场景 / 故事资产生产规格 | 美术团队需要生产哪些地面、边缘、物件、角色、UI | asset backlog、logical asset ID、尺寸、atlas / sheet 规则、验收截图点 | 首批资产生产 |
| V02.34 | 美术资产首批生产与 Map Editor 接入 | 资产如何进入当前编辑器和 runtime | tile / prop / story object / animation 首批素材、ThemeProfile / AssetResolver 映射、editor marker 绑定 | 运行时替换纵切 |
| V02.35 | 动作操控运行时纵切 | 玩家是否真的像在连续小镇中走动和互动 | 连续移动、4 向动画、镜头跟随、靠近 prompt、真实入口 smoke、1280 proof | 故事线可玩纵切 |
| V02.36 | 故事线 + 美术 + 动作整合纵切 | 第一批故事是否在新操控和新资产下成立 | P0 故事章节可玩、A-Z 回访、相册落账、NPC / resource / story object 联动、阶段 RC proof | 后续内容批量生产 |

## 长线任务拆分

| 顺序 | Task ID | Owner | 交付物 | 完成门槛 |
|---|---|---|---|---|
| 1 | `V02-STORYMOTIONART-001` | PM / Narrative / Art Direction / UX / QA | V02.29-V02.36 长远路线、禁改边界、任务队列、验收矩阵和 Round141 任务包 | docs 12-15、`todo.md` 和本任务包同步；下一轮 Ready 明确；不改 runtime / data / tests / assets |
| 2 | `V02-STORYLINE-002` | Narrative / Memory Palace / PM | 全量故事线总纲、章节分层、P0/P1/P2 结构、A-Z anchor 故事索引 | 每条故事线有地点、NPC、anchor、新词故事、视觉钩子、回访路径和儿童安全边界 |
| 3 | `V02-STORYLINE-003` | Narrative / Map / QA | 当前地图适配表、缺口清单、可用 Place / resource / routine / interaction cell 绑定建议 | 不重排 26 A-Z；不扩远郊 P0；每条 P0 故事能落到当前地图或少量 Map Editor 可生产项 |
| 4 | `V02-MOTION-001` | Animation / UX / Godot / QA | 行走动画与状态机规格，覆盖 player / NPC / Sunny | 至少 4 向 idle / walk / turn / interact；预留 8 向；给出帧数、尺寸、pivot、scale、命名和验收动图要求 |
| 5 | `V02-CONTROLS-001` | UX / Godot / QA | Animal Crossing-like 操控规格和实现任务拆分 | 连续移动、隐藏网格、镜头跟随、靠近交互 prompt、虚拟摇杆 / tap move / 键鼠手柄策略清楚 |
| 6 | `V02-ARTPIPE-001` | Art Direction / Asset / Narrative | Tile map、场景、故事物件、角色、动画和 UI 的资产需求清单 | 每项有 logical asset ID、用途、尺寸建议、优先级、依赖故事线、验收截图点和禁止方向 |
| 7 | `V02-ARTPIPE-002` | Tech Art / Tooling / QA | 适配当前 Map Editor / ThemeProfile / AssetResolver 的美术接入规范 | 命名、导入、atlas / sprite sheet、asset acceptance、editor marker 绑定和 runtime proof 口径明确 |
| 8 | `V02-ARTPROD-001` | Art Direction / Asset / Tech Art | 首批 tile / prop / story object / animation 生产包 | 进入 repo asset tree，具备 import、logical asset ID、production acceptance，不标自动 approved |
| 9 | `V02-RUNTIME-ANIM-001` | Godot / UX / QA | 动作操控运行时纵切 | 连续移动、4 向动画、镜头、prompt 和真实入口 smoke 通过 |
| 10 | `V02-STORYSLICE-001` | Narrative / Godot / QA | 第一批故事线整合纵切 | P0 故事、A-Z 回访、NPC / resource / album 联动、1280 proof 通过 |

## V02.29 故事总纲轮

全量故事线不是单纯剧情文本，而是可制作的世界结构。每条故事线至少包含：

| 字段 | 要求 |
|---|---|
| `storyline_id` | 稳定 ID，`snake_case`，后续可进入 JSON 合同。 |
| `chapter_band` | `p0_home_school`、`p0_town_life`、`p1_first_ring`、`p2_second_ring`、`far_edge_preview`。 |
| `world_place_id` | 绑定现有 place；缺口需标为 Map Editor 可新增候选。 |
| `npc_id` | 主触发 NPC 或环境触发说明。 |
| `core_anchor_id` | 绑定稳定 A-Z anchor；不可新建替代核心 anchor。 |
| `new_words` | 环境英文词或物件名；必须能由中文上下文理解。 |
| `story_memory` | 记忆宫殿故事，围绕地点、物件、动作和情绪建立记忆。 |
| `visual_hook` | 美术可生产的视觉钩子，不依赖小字或裸字母牌。 |
| `review_path` | 回访路径，例如再次路过、相册、NPC 短句、天气变化或家具 / 资源联动。 |
| `asset_needs` | 该故事需要的 tile、prop、character pose、animation、UI icon 或 sound cue。 |
| `child_safety_notes` | 禁止课程、测试、打卡、倒计时、失败惩罚、陌生人出行压力。 |

V02.29 完成后，应能回答：P0 主线有哪些章节、每章在哪里发生、谁参与、绑定哪个 A-Z anchor、需要哪些首批故事资产、哪些只是 P1/P2 预留。

## V02.30 当前地图适配轮

V02.30 不重新规划世界，只把 V02.29 的故事线落到当前可生产地图上。

主要交付：

- `storyline_id -> world_place_id -> interaction_cell -> npc_id -> core_anchor_id` 的绑定表。
- 现有 Place 可直接承载的故事列表。
- 需要 Map Editor 小改的 Place / resource / NPC routine / interaction cell 候选列表。
- P0 Home / Town Plaza / Shop Street / School line 的 5-10 分钟故事动线。
- P1 Bookshop / Bus Stop / Garden / Bear Corner / Taxi marker 的可选回访线。
- P2 Park / Theatre / Music Corner / Sports Corner / far edge 的只预留不阻断说明。

验收：

- P0 故事不依赖远郊、课程 UI 或隐藏入口。
- A-Z anchor 只绑定故事，不重排 route order。
- 所有新增候选都能被 Map Editor 表达，不要求手工 JSON 才能生产。

## V02.31-V02.32 动作与操控轮

V02.31 动画规格必须先服务孩子端移动体验，而不是追求复杂表演。

| 对象 | 必须状态 | 方向 | 建议帧数 | 备注 |
|---|---|---|---|---|
| Player | idle、walk、turn、interact | 4 向必须，8 向预留 | idle 4，walk 8，turn 2-4，interact 4 | 需要统一 pivot 在脚底中心，速度感贴合当前连续移动 |
| NPC | idle、walk、greet、turn | 4 向必须 | idle 4，walk 6-8，greet 4 | routine 移动不应抢主角注意力 |
| Sunny | idle、walk、wag、greet、follow | 4 向必须 | idle 4，walk 8，wag 6，greet 4 | Sunny 动画可更活泼，但不能遮挡交互 prompt |

Sprite sheet 交付需要包含：透明 PNG、帧网格、单帧尺寸、pivot 说明、方向顺序、loop / non-loop 标记、logical animation ID、缩放比例和 1280 runtime proof 要求。

V02.32 操控规格至少覆盖：

- 玩家速度曲线：起步轻缓、停止不飘、转向有短过渡。
- 移动输入：键盘 WASD / 方向键、手柄左摇杆、移动端虚拟摇杆、轻点目的地。
- 镜头：局部跟随玩家，边界处不露空，不因 UI 面板打开而突然跳动。
- 交互：靠近后出现单一明确 prompt，优先级为 exact place / NPC / resource / anchor / decor。
- 隐藏网格：collision / footprint / routine 继续走底层数据，孩子端不显示格子、坐标或编辑器术语。
- 验收：必须有真实入口 smoke、1280 proof 和移动 / 交互连续性采样。

## V02.33-V02.34 美术生产与接入轮

V02.33 先输出资产生产 backlog，V02.34 才进入首批资产生产和接入。

美术清单按生产优先级拆为：

| 优先级 | 类别 | 内容 |
|---|---|---|
| P0 | 地面与边缘 | grass、path、plaza floor、school yard ground、shop street ground、water / coast edge、soft shadow / transition tiles |
| P0 | 场景与故事物件 | Home yard props、Story Bench、Ribbon Corner、Shop front sign、School Yard chalk / flag、A-Z 核心生活物件增强 |
| P0 | 角色与动画 | player 4 向行走、Mina、Shopkeeper、Sunny 首批动作 |
| P1 | first ring | Bookshop、Bus Stop、Garden、Clothes Shop、Bear Corner、Taxi marker 相关素材 |
| P1 | UI / feedback | interaction prompt、album badge、small item icon、gentle collect effect |
| P2 | second ring / far edge | Park、Theatre、Music Corner、Sports Corner、X/Z 远郊边界预览 |

首批资产包建议：

- `tilemap_p0_ground_pack_001`：grass、path、plaza、school yard、shop street、edge transition。
- `story_props_p0_pack_001`：Story Bench、Ribbon Corner、Shop sign、School chalk flower、Sunny yard toy。
- `anchor_refresh_p0_pack_001`：Home / School / Shop line 相关 anchor 生活物件增强。
- `character_motion_p0_pack_001`：player、Mina、Shopkeeper、Sunny 4 向基础动作。
- `ui_feedback_p0_pack_001`：interaction prompt、collect sparkle、album badge、small item icons。

接入要求：

- 所有正式素材先进入 logical asset ID 表，再接 `ThemeProfile` / `AssetResolver`。
- tile / prop 必须能被 Map Editor 或 runtime marker 引用。
- sprite sheet 必须有 import preset、frame metadata 和 runtime animation ID。
- `production` 只代表可集成，`approved` 仍需要 1280 proof 和 PM / Art Direction 判定。

## V02.35-V02.36 运行时纵切轮

V02.35 先做动作操控纵切，目标是手感成立：

- 连续移动不显格子。
- player 4 向动画随输入切换。
- camera follow 稳定。
- prompt 靠近出现、离开消失、优先级稳定。
- 真实入口 smoke 覆盖移动、看看、NPC、resource、anchor、place。

V02.36 再做故事整合纵切，目标是内容成立：

- 至少 1 条 P0 Home / Town / School 复合故事可玩。
- 至少 6 个 A-Z anchor 通过新故事回访路径落账。
- 至少 3 个新故事物件来自 Map Editor 或 asset ID 接入。
- NPC / Sunny / resource / album 都能服务故事，而不是孤立功能。
- 1280 proof 显示小镇连续、故事物件清楚、角色动作自然、UI 不遮挡。

## 禁改范围

- 不重排、重命名或替换 26 个核心 A-Z anchor 的稳定 ID、letter、core_word、route_order、card_id、audio_id。
- 不把 Letter Snake、课程页、测试、背诵、作业、打卡、分数、倒计时或完成率做回主循环。
- 不把 School Gate / School Yard 改成课堂、考试或老师训导空间。
- 不把 X/Z far edge、Bus Stop 或 Bookshop 扩成 P0 必经路线。
- 不绕过 `AssetResolver` / `ThemeProfile` 硬编码正式素材路径。
- 不把 Map Editor、格子、坐标、占格、collision、debug 等术语暴露到孩子端。

## 验收矩阵

| 验收项 | 标准 |
|---|---|
| 文档同步 | `docs/12 -> 13 -> 14 -> 15 -> todo.md` 已按顺序同步 |
| 长线顺序 | V02.29-V02.36 的依赖顺序清楚，故事 / 地图 / 动作 / 操控 / 美术 / runtime 不互相抢跑 |
| 任务粒度 | 后续每个分组能按单个 Task ID 开工，不需要重新猜范围 |
| A-Z 稳定 | 所有故事和美术需求引用既有 anchor，不重排记忆宫殿 |
| 地图适配 | P0 故事优先落在当前地图；新增内容只作为 Map Editor 小批量生产候选 |
| 动画可生产 | 帧数、方向、尺寸、pivot、命名、loop 规则足够交给动画团队 |
| 操控可实现 | 输入、镜头、移动、交互、隐藏网格和 QA proof 口径清楚 |
| 美术可接入 | 每项资产有 logical asset ID、替换目标和 runtime / editor 接入说明 |

## 下一轮 Ready

`V02-STORYLINE-002 全量故事线总纲与章节骨架`。

下一轮只做故事总纲和章节骨架，不直接改 runtime，不生成正式资产，不改地图 JSON。完成后再进入当前地图适配、动画规格、操控规格和美术清单拆解。
