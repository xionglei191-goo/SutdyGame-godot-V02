# Round87 V02.18 MAPREAD-001 PM 执行任务包

> 日期：2026-06-05
> 任务：`V02-MAPREAD-001 V02.18 路线、审计范围和 Ready 规划`
> 状态：规划完成，下一轮唯一 Ready 为 `V02-MAPREAD-002 26 Anchor 可读性审计与截图基线`

## 1. 阶段目标

V02.18 在 V02.17 已完成的 26 anchor 运行时落地基础上，专注地图视觉可读性与探索体验抛光。目标不是新增课程内容、重排 A-Z 编码或扩远郊主线，而是让孩子在 1280x720 和 960x540 下能看懂 Home / School 中心、first ring、second ring、far edge 的区域关系，看得出 26 anchor 的生活物件轮廓，并能通过真实 `看看` 路径得到温和反馈和相册回访。

## 2. 任务队列

| 顺序 | Task ID | Owner | 交付物 | 完成门槛 |
|---|---|---|---|---|
| 1 | V02-MAPREAD-001 | PM / Map / Art Direction / QA | V02.18 路线、审计范围、任务拆分、本任务包和 Ready 队列 | `docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步 |
| 2 | V02-MAPREAD-002 | QA / Map / UX / Art Direction | 26 anchor 可读性审计表、双视口截图基线、遮挡 / 热点 / 小字 / 区域层次问题清单 | 覆盖 P0 center、first ring、second ring、far edge 和 Album |
| 3 | V02-MAPREAD-003 | Map / Art Direction / Godot / QA | 地图视觉层级、道路引导、安全边界和回家线索抛光 | 区域层次清楚，不改变核心编码或远郊边界 |
| 4 | V02-MAPREAD-004 | Godot / UX / Narrative / QA | Anchor 徽章、热点优先级、`看看` 反馈短句和相册回访抛光 | 生活物件优先，字母辅助，资源不吞 anchor |
| 5 | V02-MAPREAD-005 | QA / PM / Godot | 地图探索操作级 smoke、相册复核、headless runner 注册和双视口截图收口 | focused / headless / Godot 启动和代表截图通过 |

## 3. 下一轮 Ready：V02-MAPREAD-002

输入：

- `data/maps/world_map.json`
- `data/maps/az_world_plan.json`
- `data/anchors/az_core_anchors.json`
- `docs/collaboration/Round86_V02.17_WORLDMAP-002_005运行时布局与验收记录.md`
- V02.16 / V02.17 smoke 与截图记录
- `LESSON-009` 和 `LESSON-010`

交付：

- 26 anchor 可读性审计表，至少记录 anchor ID、地图层级、截图点、主轮廓、字母徽章、热点邻接、遮挡风险、文本风险和建议处理方式。
- 1280x720 与 960x540 截图基线口径，覆盖 Home anchors、School line、first ring、second ring、far edge 和 Album。
- 问题分级：P0 阻断、P1 抛光、P2 可延期。
- 明确哪些问题进入 `V02-MAPREAD-003`，哪些进入 `V02-MAPREAD-004`。

验收：

- 不修改 26 个核心 `anchor_id`、`letter`、`core_word`、`route_order` 或 `card_id`。
- 不以服务直调或隐藏按钮作为可读性证据。
- 审计必须覆盖真实可见入口、截图证据、热点优先级和孩子端文本。
- 不出现课程、测试、背诵、打卡、分数、完成率、远郊每日路线或独自远行压力。

## 4. 禁用范围

- 不新增课程 UI、单元页、练习题、字母打卡、完成率或评分。
- 不把 X/Z 远郊推进为 P0 或今日状态高频路线。
- 不用裸字母牌替代生活物件；字母徽章只能作为辅助识别。
- 不绕过 `AssetResolver` 硬编码素材路径。
- 不回滚 V02.16 / V02.17 已通过的可玩路径。
