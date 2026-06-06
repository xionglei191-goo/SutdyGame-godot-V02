# Round89 V02.19 ARTPASS-001 PM 执行任务包

> 日期：2026-06-05
> 任务：`V02-ARTPASS-001 V02.19 路线、资产范围和 Ready 规划`
> 状态：规划完成；Round91 已在此基础上将后续 Ready 调整为 `V02-ARTPASS-003 视觉方向确认包`

## 1. 阶段目标

V02.19 在 V02.17 / V02.18 已完成的世界地图运行时落地和可读性抛光基础上，进入实际地图与 P0 美术资产 production art pass。目标不是扩玩法、扩远郊、扩课程 UI 或重新设计 A-Z，而是让当前已可玩的 Sunshine Town 第一眼像 Animal Crossing-like 的温暖、可居住、可回访小镇，并让 HUD / 弹层 / 高频 UI 走 Apple-like translucent glass 方向；后续不采用绘本 / storybook / picture-book 作为正式生产方向。

本阶段优先替换：

- 世界地图底图、道路、Home / School / Town / Far Edge 区域块。
- Home exterior、Home-School Walk、School Gate、School Yard、Town Plaza、Shop / Bookshop / Bus Stop 等 P0 / 近场关键场景。
- 26 个 A-Z anchor 的生活物件视觉，字母徽章只作为辅助。
- Player、Mina、Sunny、Shopkeeper、Story Bear、Bus Helper 等首批角色 / 宠物。
- 背包、相册、商店、设置、金币、宠物状态等必要 UI 图标。

所有资产必须通过 logical asset ID、`ThemeProfile` 和 `AssetResolver` 接入；runtime 不得硬编码具体图片路径。`production` 只表示可集成，`approved` 必须有截图证据和 PM / Art Direction 判断。自 2026-06-06 起，后续所有未完成任务的阻塞性视觉验收以 1280x720 为准；960x540 暂缓到全部开发完成后的版本适配专项，不作为本任务包或中间阶段完成阻塞。

## 2. 任务队列

| 顺序 | Task ID | Owner | 交付物 | 完成门槛 |
|---|---|---|---|---|
| 1 | V02-ARTPASS-001 | PM / Art Direction / Map / QA | V02.19 路线、资产范围、任务拆分、本任务包和 Ready 队列 | `docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步 |
| 2 | V02-ARTPASS-002 | Art Direction / Asset / Tech Art / QA | 实际地图与 P0 资产清单、logical asset ID 表、替换目标、截图点和接入合同审计 | 每项有用途、尺寸、状态、依赖、替换目标、截图验收点和 `AssetResolver` 接入方式 |
| 3 | V02-ARTPASS-003 | Art Direction / UI / Map / QA | 视觉方向确认包：主玩法屏风格稿、Apple-like translucent glass UI 样张、角色 / 物件样张和风格规则 | 方向明确；拒绝绘本 / storybook / picture-book；不批量生成不可接入素材 |
| 4 | V02-ARTPASS-004 | Map / Asset / Godot / QA | P0 世界地图底图、区域块、道路和安全边界 production 资产接入 | 1280x720 下地图首屏像真实小镇；旧坐标、热点、HUD 和底栏不回退；960x540 等全部开发完成后专项适配 |
| 5 | V02-ARTPASS-005 | Asset / Memory Palace / Godot / QA | P0 场景外观与 26 anchor 生活物件 production 替换 | anchor 不靠裸字母牌；School line 不堆叠、不课程化；相册落账保持通过 |
| 6 | V02-ARTPASS-006 | Character Art / UI / Godot / QA | 角色、宠物、UI 图标 / glass UI 皮肤替换、1280x720 截图和阶段收口 | AssetResolver、focused/headless、Godot 启动和 1280x720 截图通过；960x540 等全部开发完成后专项适配 |

## 3. 下一轮 Ready：V02-ARTPASS-002

输入：

- `docs/10_美术风格与换肤预留.md`
- `docs/12_V02开发路线.md`
- `docs/13_V02详细开发计划.md`
- `docs/14_内容基线整理与首批内容规划.md`
- `docs/15_项目经理接管与下一阶段执行计划.md`
- `data/maps/world_map.json`
- `data/maps/az_world_plan.json`
- `data/anchors/az_core_anchors.json`
- `scripts/systems/asset_resolver.gd`
- `data/themes/theme_sunshine_town_placeholder.json`
- V02.16 / V02.17 / V02.18 smoke 与截图记录
- `LESSON-009`、`LESSON-010`、`LESSON-011`

交付：

- 实际地图与 P0 资产清单，至少覆盖世界地图底图、Home / School / Town 关键场景、26 anchor、首批角色 / 宠物和必要 UI 图标。
- logical asset ID 表，列出现有 ID、缺失 ID、建议新增 ID、目标文件名、目标目录和 `AssetResolver` 接入方式。
- 每项资产的建议尺寸 / 比例、用途、替换目标、生产状态、依赖、截图验收点和优先级。
- `production` 与 `approved` 判定口径，明确哪些资产只允许进入 production，哪些需要 PM / Art Direction 截图确认后才能 approved。
- 后续 `V02-ARTPASS-003` 至 `006` 的分派建议和风险清单。

验收：

- 不先批量生成不可接入素材；必须先固定 logical asset ID 和接入合同。
- 不改 26 个核心 `anchor_id`、`letter`、`core_word`、`route_order`、`card_id`、坐标语义或相册语义。
- 不新增课程页、测试、背诵、词表、分数、正确率、完成率或字母打卡路线。
- School Gate / School Yard 只能是生活地点、操场和回访地点，不做课堂、作业检查、迟到惩罚或老师训导空间。
- X/Z far edge 只作远处边界视觉，不进入 P0、今日状态高频池或每日必到路线。
- 后续未完成任务的阻塞性截图验收只包含 1280x720，且继续遵守 `LESSON-010`：截图取证走 MCP 或非 headless 显示驱动，headless 只负责逻辑回归。960x540 不删除，但暂缓到全部开发完成后的版本适配专项。

## 4. 禁用范围

- 不新增玩法系统、课程 UI、远郊主线、真实联网、账号、云存档或多人功能。
- 不把资产路径硬编码进 runtime 脚本。
- 不用更大的裸字母牌替代 anchor 生活物件。
- 不把 `production` 自动等同于 `approved`。
- 不回滚 V02.16 / V02.17 / V02.18 已通过的玩家路径、热点优先级或地图可读性规则。
