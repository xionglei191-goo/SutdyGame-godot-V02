# Round 63 V02.9 `WEEKLY-004` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-WEEKLY-002 每日状态与商店轮换数据化`、`V02-WEEKLY-003 P1 居民回访入口预收` 已完成。

## 本轮目标

验证 V02.9 的 7 天回访节奏从玩家视角不阻断：连续切换 `local_day_001` 至 `local_day_007` 后，今日状态可刷新、商店轮换可读取、P0 常驻商品不消失，且孩子仍能从真实可见入口完成一条温和日常路径。

Bookshop / Bus Stop 在本轮仍按 P1 预收处理：`local_day_004` / `local_day_005` 可检查它们不阻断主流程，但不把未实现的入口当作失败。

## Owner

QA / PM / Godot Dev Agent

## Scope

允许修改：

- `tests/test_v029_weekly_return_smoke.gd`
- `tests/headless_runner.gd`
- `docs/collaboration/Round63_V02.9_WEEKLY-004_PM执行任务包.md`
- `todo.md`
- `lessons.md`（仅当出现已验证新教训）

暂不修改：

- Bookshop / Bus Stop 运行时入口
- 故事熊 / 巴士哥哥主流程实现
- 真实天气系统、真实 AI、联网、账号或云存档

## Inputs

- `docs/collaboration/Round61_V02.9_WEEKLY-002_PM执行任务包.md`
- `docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md`
- `docs/14_内容基线整理与首批内容规划.md` 的 V02.9 内容基线和截图点
- `tests/test_v028_daily_life_slice.gd`
- `tests/test_daily_town_services.gd`
- `LESSON-009`、`LESSON-010`

## Deliverables

- 7 天玩家路径 smoke：切换 `local_day_001` 至 `local_day_007`，刷新 HUD 今日状态，并通过可见 `看看` 完成至少一条 P0 日常。
- 商店轮换检查：每个 day_key 都能读取对应 `shop_rotation_id`，且包含 P0 常驻商品。
- P1 不阻断检查：`local_day_004` / `local_day_005` 即使 Bookshop / Bus Stop 未实现，也不能阻断 P0 可见路径。
- `tests/headless_runner.gd` 注册本轮 smoke。
- 代表截图记录：明确沿用或补充 1280x720 / 960x540 证据，且截图取证不依赖 headless dummy renderer。

## Acceptance Criteria

- 7 个本地 day_key 均可刷新 HUD 今日状态，且事件文本各不相同。
- 每天都能通过孩子端真实可见 `看看` 路径完成一条温和日常，不能依赖隐藏 contract 按钮或脚本直调完成玩家动作。
- 每天的商店轮换都保留 `wooden_chair` 和至少一个 P0 offer。
- `local_day_004` / `local_day_005` 只验证 P1 预收内容不阻断主流程；不得强制要求 Bookshop / Bus Stop 运行时入口。
- 可见文本不出现工程文案、课程、测验、评分、背诵、倒计时、失败惩罚、陌生人带走、独自远行或赶时间压力。
- focused test、headless runner 和 Godot headless 启动均通过。

## Required Validation

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --script tests/test_v029_weekly_return_smoke.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

截图取证按 `LESSON-010` 处理：headless 只做逻辑回归；代表截图使用已验证的非 headless / MCP 证据，或在后续单独补图时记录工具链。

## Handoff Notes

完成后填写：

- 修改文件：`tests/test_v029_weekly_return_smoke.gd`、`tests/headless_runner.gd`、`docs/collaboration/Round63_V02.9_WEEKLY-004_PM执行任务包.md`、`todo.md`、`docs/13_V02详细开发计划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`lessons.md`。
- 新增内容：7 天玩家路径 smoke、全量 runner 注册和 V02.9 阶段收口判断。
- 验证方式：`find data -name '*.json' -print0 | xargs -0 jq empty`、`godot --headless --path . --script tests/test_v029_weekly_return_smoke.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过。
- 风险：Bookshop / Bus Stop 仍只是 P1 入口预收，本轮没有实现其运行时入口；后续若要接入，必须单独建立真实入口和截图验收。
- 待确认问题：下一阶段路线尚未建立。PM 判断：`V02-WEEKLY-004` 和 V02.9 一周回访节奏可以标记完成，下一步应进入新阶段规划 / Ready 队列建立。
