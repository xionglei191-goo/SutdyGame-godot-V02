# Round 60 V02.9 `WEEKLY-001` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02.8 每日小镇生活纵切` 已通过 focused/headless 验证和双视口截图证据。

## 本轮目标

把 V02.8 的 5 分钟日常纵切扩展为 V02.9 的 7 天回访设计合同：每天都有温和今日状态、居民轻目标、商店 / 小屋回访理由和 A-Z 环境线索，但不引入连续登录、倒计时、失败惩罚或学习压力。

## Owner

PM / Game Design / Narrative / QA Agent

## Scope

允许修改：

- `docs/12_V02开发路线.md`
- `docs/13_V02详细开发计划.md`
- `docs/14_内容基线整理与首批内容规划.md`
- `docs/15_项目经理接管与下一阶段执行计划.md`
- `todo.md`
- `lessons.md`（仅当出现已验证新教训）
- 本任务包和后续协作文档

暂不修改：

- `scripts/main.gd`
- `data/life/*.json`
- `data/items/*.json`
- Bookshop / Bus Stop 运行时场景
- 更多 NPC、真实天气系统、真实 AI、联网、账号或云存档

## Inputs

- `todo.md`
- `docs/12_V02开发路线.md`
- `docs/13_V02详细开发计划.md`
- `docs/14_内容基线整理与首批内容规划.md`
- `docs/15_项目经理接管与下一阶段执行计划.md`
- `docs/collaboration/Round59_V02.8_DAILYLIFE-005_PM执行任务包.md`
- `lessons.md` 中 `LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`

## Deliverables

- V02.9 阶段路线和任务拆分。
- `local_day_001` 至 `local_day_007` 的内容排期草案。
- P0 可实现内容与 P1 入口预收内容边界。
- 后续数据化改动清单：今日状态、每日委托、商店轮换、小屋反馈、A-Z 回访。
- 一周 smoke、内容合同、双视口截图和儿童安全文案验收口径。

## Acceptance Criteria

- 7 天排期每天都有 `day_key`、今日状态、主居民、轻目标、商店 / 小屋回访、A-Z 线索和验收重点。
- 不把 Bookshop / Bus Stop、故事熊、巴士哥哥直接变成主流程硬依赖；只允许作为 P1 入口预收。
- 不出现连续登录、倒计时、错过损失、排名、课程、背诵、测试或强制购买。
- V02.9 正式任务列表至少包含合同排期、数据化、P1 入口预收和一周 smoke / 截图四项。
- `todo.md` 当前状态面板、本轮分工、正式任务列表和完成记录保持同步。

## Required Validation

本轮为 PM 文档与台账任务，不改运行时代码。收口至少执行：

```bash
rg -n '\[~\].*V02-DAILYLIFE|待 PM 开启下一阶段|V02\.7A 美术基线重建` -> `V02\.8|当前 Ready 为 `V02-WEEKLY-001|下一轮唯一 Ready。' todo.md docs/12_V02开发路线.md docs/13_V02详细开发计划.md docs/15_项目经理接管与下一阶段执行计划.md
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## Handoff Notes

完成后填写：

- 修改文件：`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md`、`lessons.md`。
- 新增内容：新增 V02.9 一周回访节奏路线、`local_day_001` 至 `local_day_007` 内容排期草案、V02-WEEKLY-001 至 004 任务拆分，以及 Round60 PM 任务包。
- 验证方式：`rg -n '\[~\].*V02-DAILYLIFE|待 PM 开启下一阶段|V02\.7A 美术基线重建\` -> \`V02\.8|当前 Ready 为 \`V02-WEEKLY-001|下一轮唯一 Ready。' todo.md docs/12_V02开发路线.md docs/13_V02详细开发计划.md docs/15_项目经理接管与下一阶段执行计划.md` 无旧状态残留；`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过。
- 风险：V02-WEEKLY-002 开始后会触碰数据与合同测试；必须先做 focused contract，不要直接改主场景流程。Bookshop / Bus Stop 继续保持 P1 入口预收，不是主流程依赖。
- 待确认问题：无。PM 判断：`V02-WEEKLY-001` 可以标记完成，下一轮 Ready 为 `V02-WEEKLY-002 每日状态与商店轮换数据化`。
