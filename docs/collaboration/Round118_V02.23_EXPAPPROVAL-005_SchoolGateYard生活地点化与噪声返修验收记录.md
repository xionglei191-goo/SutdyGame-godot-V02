# Round118 V02.23 EXPAPPROVAL-005 School Gate / School Yard 生活地点化与噪声返修验收记录

> 日期：2026-06-07  
> 任务：`V02-EXPAPPROVAL-005 School Gate / School Yard 生活地点化与噪声返修`  
> 结论：返修交付物、focused proof、headless 回归、Godot 启动和同轮 1280 proof 均已完成。School Gate / School Yard 仅进入“可判定 / pending V02-EXPAPPROVAL-006”状态，不自动升级 `approved`。

## 范围

- 强化 School Gate / School Yard 作为生活地点和操场的视觉到达感。
- 降低 School line anchor / HUD proof 噪声，使截图可判断。
- 保留 A-Z anchor ID、card ID、route order、world_map 路线和现有 Home / School 可玩路径。
- 不新增课程页、作业、测试、分数、打卡、迟到或课堂压力。

## 交付物

- `scripts/stages/town_stage.gd`
  - 新增 School Gate / School Yard 非交互生活细节：校门小铃 / welcome mat、操场 soft net、kite ribbon、robot sign、yo-yo basket。
  - 扩展 `get_expapproval_snapshot()`，输出 school life detail、School-line anchor、muted badge 和 collision debug 状态。
- `scripts/main.gd`
  - School 到达 proof 文案改为更短的孩子端中文，英文只保留 `hello` 环境点缀。
  - 新增 `get_expapproval_school_snapshot()`，用于 approval focused test 和 runner 断言。
- `tests/test_v0223_expapproval_school_gate_yard_life_noise.gd`
  - 验证 School Gate / Yard 生活细节数量、G/K/N/R/Y anchor 保留、School-line badge 降噪、collision debug 隐藏、真实 `看看` 入口、保存落账和禁用压力词。
- `tests/headless_runner.gd`
  - 注册 Round118 School Gate / Yard focused proof。
- `tests/capture_expapproval005_school_gate_yard.gd`
  - 导出同轮 1280 proof。
- `docs/collaboration/round118_expapproval005_school_gate_yard/`
  - `shot_round118_expapproval005_school_gate_arrival_1280.png`
  - `shot_round118_expapproval005_school_gate_feedback_1280.png`
  - `shot_round118_expapproval005_school_yard_arrival_1280.png`
  - `shot_round118_expapproval005_school_yard_feedback_1280.png`

## 验证

- `godot --headless --path . --script tests/test_v0223_expapproval_school_gate_yard_life_noise.gd`：通过
- `godot --headless --path . --check-only --script scripts/stages/town_stage.gd`：通过
- `godot --headless --path . --check-only --script scripts/main.gd`：通过
- `godot --headless --path . --script tests/test_v0221_livegate_shop_school_arrival.gd`：通过
- `godot --headless --path . --script tests/test_playable_ui_operations.gd`：通过
- `godot --headless --path . --script tests/test_v0223_ui_panel_scene_split.gd`：通过
- `godot --headless --path . --script tests/headless_runner.gd`：通过
- `godot --headless --path . --quit`：通过
- `godot --path . --script tests/capture_expapproval005_school_gate_yard.gd`：通过
- `file docs/collaboration/round118_expapproval005_school_gate_yard/*.png`：4 张均为 `1280 x 720` PNG

## 判定边界

- 本轮只证明 School Gate / School Yard 已具备 V02.23 approval 线的同轮 proof 和真实入口验证输入。
- 本轮不改变批准事实：当前仍只有 Album 为 approved；Town Plaza / World Map、Home、Shop、School Gate、School Yard、Settings 等待 `V02-EXPAPPROVAL-006` 逐项判定。
- 无新增已验证教训；截图仍沿用 `LESSON-010` 的非 headless 显示驱动路径。
