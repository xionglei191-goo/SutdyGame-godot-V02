# Round 62 V02.9 `WEEKLY-003` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-WEEKLY-001 一周回访内容合同与排期`、`V02-WEEKLY-002 每日状态与商店轮换数据化` 已完成。

## 本轮目标

预收故事熊 / 巴士哥哥的 P1 居民回访入口，让 Bookshop / Bus Stop 具备下一轮可实现、可截图、可验收的准备条件，但不把它们提前变成主流程硬依赖。

本轮是 Narrative / UX / QA / Godot 的入口与边界设计轮，不做真实运行时扩展，不新增强制每日任务，不改变 V02.8 的 P0 主路径。

## Owner

Narrative / UX / QA / Godot Agent

## Scope

允许修改：

- `docs/14_内容基线整理与首批内容规划.md`
- `docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md`
- `todo.md`
- `lessons.md`（仅当出现已验证新教训）

暂不修改：

- `scripts/main.gd`
- `data/life/daily_requests.json`
- `data/life/today_status.json`
- `data/items/life_items.json`
- `tests/headless_runner.gd`
- Bookshop / Bus Stop 运行时场景
- 故事熊 / 巴士哥哥主流程入口实现
- 真实天气系统、真实 AI、联网、账号或云存档

## Inputs

- `docs/14_内容基线整理与首批内容规划.md` 的 V02.9 一周回访节奏、故事熊 / 巴士哥哥 NPC 规划、B Bear / T Taxi anchor 故事。
- `docs/13_V02详细开发计划.md` 的 V02.9 执行顺序。
- `docs/15_项目经理接管与下一阶段执行计划.md` 的 PM 风险控制。
- `docs/collaboration/Round60_V02.9_WEEKLY-001_PM执行任务包.md`
- `docs/collaboration/Round61_V02.9_WEEKLY-002_PM执行任务包.md`
- `LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`

## Deliverables

- 故事熊 / Bookshop 的 P1 可见入口清单：入口触发、孩子端按钮或靠近路径、可接受反馈、禁止文案。
- 巴士哥哥 / Bus Stop 的 P1 可见入口清单：入口触发、孩子端按钮或靠近路径、可接受反馈、禁止文案。
- B Bear / T Taxi 的 A-Z 回访绑定说明：地点、视觉钩子、相册记录、回访路径和安全边界。
- 双视口截图点清单：至少覆盖 Bookshop 入口、Bear Corner、Bus Stop 入口、Taxi marker，以及对应 HUD / 底栏状态。
- 下一轮 `V02-WEEKLY-004` smoke 输入：哪些路径可以进入玩家路径测试，哪些仍保持 P1 计划。

## Acceptance Criteria

- Bookshop / Bus Stop 仍明确为 P1 入口预收，不成为 P0 主流程硬依赖。
- 故事熊不能成为老师、讲台、朗读、复述、背诵、测验或评分入口。
- 巴士哥哥不能引导陌生人带走、独自远行、上车离开小镇、赶时间、错过班车或道路危险。
- 每个入口都必须描述孩子端真实可见路径，不能把隐藏 contract 按钮或脚本直调当作验收依据。
- 每个截图点都必须列出视口、地点、玩家动作、UI 状态和失败判定。
- 文案保持短、温和、生活化；英语只作为环境词、物件名、相册标签或短 NPC 氛围句。

## Required Validation

本轮默认只改 PM / 内容文档，需做文档一致性与禁用词检查：

```bash
rg -n "V02-WEEKLY-003|Round 62|故事熊|巴士哥哥|Bookshop|Bus Stop|Bear Corner|Taxi marker" todo.md docs/13_V02详细开发计划.md docs/14_内容基线整理与首批内容规划.md docs/15_项目经理接管与下一阶段执行计划.md docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md
rg -n "背诵|测验|考试|评分|排名|倒计时|错过|赶时间|陌生人带走|独自远行|上车离开" docs/14_内容基线整理与首批内容规划.md docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md
```

若本轮实际修改运行时代码或数据，则必须追加 focused tests 和：

```bash
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## Handoff Notes

完成后填写：

- 修改文件：`docs/14_内容基线整理与首批内容规划.md`、`docs/13_V02详细开发计划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md`、`lessons.md`。
- 新增内容：故事熊 / Bookshop 入口清单、巴士哥哥 / Bus Stop 入口清单、B Bear / T Taxi 回访绑定、双视口截图点和 `V02-WEEKLY-004` smoke 输入。
- 验证方式：`find data -name '*.json' -print0 | xargs -0 jq empty`、文档状态同步 `rg` 检查、禁用词边界 `rg` 检查、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过。
- 风险：本轮只完成入口预收，不代表 Bookshop / Bus Stop 已有运行时真实入口；`V02-WEEKLY-004` 必须按“未实现不阻断 P0、声称接入才纳入真实操作截图”的口径验收。
- 待确认问题：无。PM 判断：`V02-WEEKLY-003` 可以标记完成，下一轮 Ready 为 `V02-WEEKLY-004 一周回访 smoke 与截图`。
