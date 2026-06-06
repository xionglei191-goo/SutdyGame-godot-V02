# Round 59 V02.8 `DAILYLIFE-005` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-DAILYLIFE-001` 至 `004` 均已通过 focused/headless 验证。

## 本轮目标

用端到端玩家路径和双视口截图收口 V02.8：玩家从启动开始能完成“找 NPC -> 做小事 -> 得反馈 -> 使用奖励 / 回小屋”的 5 分钟日常纵切。

## Owner

QA / PM / Godot Dev Agent

## Scope

允许修改：

- `tests/test_life_rpg_scene.gd`
- `tests/test_playable_ui_operations.gd`
- `scripts/main.gd`
- 相关截图记录、协作文档和 `todo.md`

暂不修改：

- Bookshop / Bus Stop 新场景
- 更多 NPC、更多天气或节日系统
- 已通过的 `DAILYLIFE-001` 至 `004` 功能范围，除非 smoke 发现真实断点
- 真实 AI、联网、账号或云存档

## Inputs

- `todo.md`
- `docs/collaboration/Round58_V02.8_DAILYLIFE-004_PM执行任务包.md`
- 历史 ARTBASE 双视口截图结论
- `tests/test_life_rpg_scene.gd`
- `tests/test_playable_ui_operations.gd`
- `tests/test_v023_memory_palace_world.gd`
- `lessons.md` 中 `LESSON-009`、`LESSON-010`

## Deliverables

- 端到端玩家路径 smoke，覆盖启动、NPC、轻委托、奖励、商店、小屋和至少一个 A-Z 回访。
- 1280x720 与 960x540 截图记录。
- V02.8 是否完成的 PM 判断。
- 若截图工具链受阻，必须明确区分“工具链 blocked”和“布局 fail”。

## Acceptance Criteria

- 玩家路径必须从当前孩子端真实可见入口完成，不依赖隐藏 contract 按钮、脚本直调或纯服务测试。
- 路径至少覆盖：找 NPC、做一件小事、获得反馈 / 奖励、购买或使用奖励、回小屋、触发 Sunny 反馈、回访 C/O/S 至少一处。
- 文案短、温和、生活化，不出现考试、评分、课程、背诵、倒计时、失败惩罚或强消费压力。
- 1280x720 与 960x540 截图无明显遮挡、文字溢出、按钮贴边、工程文案。
- 不破坏 A-Z anchor 位置、路线顺序和新词故事绑定。

## Required Validation

```bash
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v023_memory_palace_world.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

截图取证继续沿用 `V02-ARTBASE-005` 的非 headless / MCP 路径；不要把 headless dummy renderer 当成唯一截图工具链。

## Handoff Notes

完成后填写：

- 修改文件：`tests/headless_runner.gd`、`todo.md`、`docs/collaboration/Round59_V02.8_DAILYLIFE-005_PM执行任务包.md`、`lessons.md`。
- 新增内容：`tests/test_v028_daily_life_slice.gd` 已作为端到端 focused smoke 存在；本轮将同一路径注册进 `tests/headless_runner.gd`。
- 验证方式：`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_v028_daily_life_slice.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/test_v023_memory_palace_world.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过。
- 截图记录：旧截图证据已清理；本任务保留 focused smoke、headless runner 与阶段收口结论。
- 风险：本轮未扩 Bookshop / Bus Stop / 更多 NPC / 天气系统；后续若开启下一阶段，需要先建立新 Ready 任务和验收口径。
- 待确认问题：无。PM 判断：`V02-DAILYLIFE-005` 与 V02.8 每日小镇生活纵切可以标记完成。
