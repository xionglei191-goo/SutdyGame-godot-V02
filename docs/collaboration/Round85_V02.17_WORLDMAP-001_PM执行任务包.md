# Round 85 V02.17 WORLDMAP-001 PM 执行任务包

> 日期：2026-06-05  
> Owner：PM / Map / Memory Palace / QA Agent  
> 状态：Ready  
> 任务：`V02-WORLDMAP-001 V02.17 路线、地图布局范围和 Ready 规划`

## 任务目标

建立 V02.17 “世界地图运行时落地与 26 Anchor 可视布局”阶段路线，把 V02.12 已完成的 `az_world_plan` 从规划合同推进到运行时地图布局、可见热点、相册落账和截图验收。下一轮唯一 Ready 固定为 `V02-WORLDMAP-002 26 Anchor 地图坐标与分层可达蓝图`。

本阶段不重新设计 A-Z 编码，不改变任何核心 `anchor_id`、`letter`、`core_word`、`route_order` 或 `card_id`。所有 anchor 必须先是 Sunshine Town 的生活物件、地点或环境线索，再承载英文环境层；不得做成课程牌、测试牌、词表墙、字母打卡或顺序拜访考试。

## 输入

- `data/maps/az_world_plan.json`：Home / School 双中心、四层环线、26 anchor 分布、routes、safety boundaries、reserved specs、foundation hooks 和截图口径。
- `data/anchors/az_core_anchors.json`：核心 anchor ID、字母、核心词、路线顺序和 card 绑定事实来源。
- `data/maps/world_map.json`：当前运行时地图、地点、热点和已接入 Home / School 可见路径。
- `docs/12_V02开发路线.md`：V02.17 路线和跨路线门槛。
- `docs/13_V02详细开发计划.md`：V02.17 当前 PM 执行摘要。
- `docs/14_内容基线整理与首批内容规划.md`：V02.17 内容基线、地图分层、任务拆分和禁用范围。
- `docs/15_项目经理接管与下一阶段执行计划.md`：当前 PM 接管计划和风险控制。
- `todo.md`：唯一状态事实来源。
- `LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`：生活 RPG 方向、内容合同、真实可见入口和截图工具链规则。

## 范围

- 固定 V02.17 阶段目标：26 anchor 运行时地图落地、分层可达、相册落账和双视口截图。
- 将阶段拆为 `V02-WORLDMAP-002` 至 `005`，分别覆盖地图坐标蓝图、P0 中心路线接入、first / second ring 预览和 26 anchor QA 收口。
- 明确 P0 / first ring / second ring / far edge 边界，尤其保护 Home / School 中心路线和 X/Z 远郊安全预览。
- 建立下一轮 worker 可直接执行的交付物和验收标准。

## 不做范围

- 不修改运行时代码、JSON 地图数据、测试或素材资产。
- 不改变 `az_world_plan` 的核心编码事实，不重新命名 26 anchor。
- 不接入 26 anchor 运行时热点，不生成新截图。
- 不新增课程页、单元页、答题、拼写检查、背诵、分数、正确率、排行榜、打卡、倒计时或错过惩罚。
- 不把 X/Z far edge 变成 P0 主线、今日状态高频池或每日必到地点。

## V02.17 任务队列

| Task ID | Owner | 交付物 | 验收 |
|---|---|---|---|
| V02-WORLDMAP-001 | PM / Map / Memory Palace / QA | V02.17 路线、地图布局范围、任务拆分、Round85 PM 任务包和 Ready 队列 | `docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步；下一轮唯一 Ready 是 V02-WORLDMAP-002 |
| V02-WORLDMAP-002 | Map / UX / Memory Palace / QA | 26 anchor 运行时坐标蓝图、道路关系、入口状态、截图点和安全边界表 | 每个 anchor 保留核心 ID / route_order；P0、first、second、far edge 分层清楚；不要求孩子顺序拜访 |
| V02-WORLDMAP-003 | Godot Dev / Map / Narrative / QA | P0 Home / School 中心路线地图节点、热点和相册落账 | A/C/D/W/E/G/K/N/R/Y 从真实可见 `看看` 触发；不阻断 V02.16 总路径；学校不课程化 |
| V02-WORLDMAP-004 | Godot Dev / Narrative / Art Direction / QA | first / second ring anchor 预览、P1 入口和 logical asset ID 接入计划 | B/F/H/I/J/O/T/L/M/P/Q/S/U/V 至少有可见入口或明确预览状态；P0 不被阻断 |
| V02-WORLDMAP-005 | QA / PM / Godot | 26 anchor 合同测试、运行时 smoke、相册落账复核和双视口截图 | focused / headless / Godot 启动通过，代表截图无明显遮挡、工程文案、裸字母牌或课程化文案 |

## 下一轮唯一 Ready

`V02-WORLDMAP-002 26 Anchor 地图坐标与分层可达蓝图`

下一轮应先产出一份可执行蓝图，而不是直接改运行时代码。蓝图至少包含：

- 26 个 anchor 的运行时坐标或相对布局点。
- 所属 ring、place、道路连接、可达状态、入口状态。
- 主视觉轮廓与 logical asset ID 建议。
- `看看` 热点、相册记录、截图点和儿童安全边界。
- P0 中心路线、first ring、second ring、far edge 的可达 / 预览规则。

## 验收标准

- `docs/12`、`docs/13`、`docs/14`、`docs/15` 和 `todo.md` 均已同步到 V02.17。
- `todo.md` 当前状态面板、当前分工表、正式任务列表和完成记录一致。
- 下一轮唯一 Ready 明确为 V02-WORLDMAP-002。
- 没有把 V02.17 写成课程地图、字母测试、顺序拜访或新主线压力系统。
- 本轮仅为 PM 路线规划，不要求运行 Godot 验证；建议执行文档一致性检查。

## 建议验证命令

```bash
rg -n "V02\\.17|V02-WORLDMAP|Round85|26 Anchor|far edge|顺序拜访|课程|测试|背诵" docs/12_V02开发路线.md docs/13_V02详细开发计划.md docs/14_内容基线整理与首批内容规划.md docs/15_项目经理接管与下一阶段执行计划.md todo.md docs/collaboration/Round85_V02.17_WORLDMAP-001_PM执行任务包.md
```
