# Round149 V02.35 RUNTIME-ANIM-001 动作操控运行时纵切

日期：2026-06-07

## 目标

将 Round144 动作规格、Round145 操控规格和 Round148 首批 motion / UI feedback production 资产接入孩子端 runtime，完成一个不改变隐藏网格合同的动作操控纵切。

## 交付

- `PlayerActor` 接入 `anim_sheet.player.p0_motion`，运行时根据 facing / walking 切换 idle / walk down、side、up 状态；缺失 motion sheet 时继续 fallback 到 standing 拼装。
- `Main` 保持现有 hidden-grid pathing / `move_toward()` 行走规则，新增 keyboard hold 连续步进、tap-to-move ripple 触发、prompt glow 可见反馈和 `get_runtime_motion_snapshot()` 测试快照。
- `TownStage` 新增 camera smoothing、`FeedbackLayer`、tap ripple feedback 和 player motion state forwarding。
- 新增 `tests/test_v0235_runtime_anim_controls.gd`，并在 `tests/headless_runner.gd` 注册轻量回归。

## 验收记录

- `godot --headless --path . --check-only --script scripts/main.gd`：通过。
- `godot --headless --path . --check-only --script scripts/stages/player_actor.gd`：通过。
- `godot --headless --path . --check-only --script scripts/stages/town_stage.gd`：通过。
- `godot --headless --path . --script tests/test_v0235_runtime_anim_controls.gd`：通过。
- `godot --headless --path . --script tests/test_v0220_playgate_controls.gd`：通过。
- `godot --headless --path . --check-only --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --script tests/headless_runner.gd`：通过。
- MCP 运行主场景后捕获 1280x720 viewport proof：通过，主场景可渲染并接受 movement input。

## 边界

- 不改 `world_map.json`、A-Z anchor ID / route_order / 相册语义或 story prop 数据。
- 不把 motion / UI feedback production 资产自动标为 approved。
- 不暴露格子、坐标、debug、编辑器或课程化文字到孩子端。
- 不实现 V02.36 故事线整合；下一轮再处理 P0 故事章节、A-Z 回访、相册落账和 story object 联动。

## Lessons

本轮无新增已验证教训。Godot 动态局部变量类型推断问题按既有 `LESSON-003` 规则显式标注后收敛。
