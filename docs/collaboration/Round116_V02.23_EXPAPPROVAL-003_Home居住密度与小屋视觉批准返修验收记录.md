# Round116 V02.23 EXPAPPROVAL-003 Home 居住密度与小屋视觉批准返修验收记录

> 日期：2026-06-06
> 对应任务：`V02-EXPAPPROVAL-003 Home 居住密度与小屋视觉批准返修`
> 结论：本轮完成 Home 默认生活角、Sunny 反馈、家具状态和小屋视觉密度返修；仍不把 Home 写成 approved，最终 approved / needs_fix 需等 `V02-EXPAPPROVAL-006` 同轮全视图判定。

## 1. 改动范围

- `HomeRoom` scene 新增 `HomeLifeLayer`，渲染 6 个非交互默认生活细节：地毯、小桌、窗边花盆、墙上故事卡、Sunny 碗和 Sunny 小床。
- `main.gd` 新增 `get_expapproval_home_snapshot()` 只读快照，供 focused test 检查 Home 生活细节、家具状态、Sunny 反馈、保存 key 和孩子端文案。
- Home 家具状态文案从可见坐标改为“左边 / 靠墙 / 靠前 / 小角落”等孩子端空间语言。
- 新增 `tests/test_v0223_expapproval_home_living_density.gd`，证明默认生活密度、可见家具操作、Sunny 反馈、无格子 / 坐标术语和 HomeDecorationService save key 不扩展。
- 新增 `tests/capture_expapproval003_home.gd` 和 `docs/collaboration/round116_expapproval003_home/` 三张 1280 proof。

## 2. 保持不变

- 未改 `HomeDecorationService` 的存档结构；默认生活细节不写入 `placed_furniture`。
- 未改 A-Z `anchor_id`、`letter`、`core_word`、`route_order`、`card_id`。
- 未新增课程 UI、测试、词表墙、打卡、评分、倒计时、作业、课堂或字母顺序任务。
- 未把本轮 proof、headless 通过或 production 状态写成 product approved。

## 3. 1280 proof

| 截图 | 目的 |
|---|---|
| `docs/collaboration/round116_expapproval003_home/shot_round116_expapproval003_home_default_room_1280.png` | Home 默认生活密度 proof |
| `docs/collaboration/round116_expapproval003_home/shot_round116_expapproval003_home_visible_furniture_1280.png` | 可见家具摆放与小屋状态 proof |
| `docs/collaboration/round116_expapproval003_home/shot_round116_expapproval003_home_sunny_feedback_1280.png` | Sunny 反馈与家具状态 proof |

`file docs/collaboration/round116_expapproval003_home/*.png` 已确认三张均为 1280 x 720 PNG。

## 4. 验证

```bash
godot --headless --path . --check-only --script scripts/stages/home_room.gd
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --check-only --script tests/test_v0223_expapproval_home_living_density.gd
godot --headless --path . --check-only --script tests/capture_expapproval003_home.gd
godot --headless --path . --script tests/test_v0223_expapproval_home_living_density.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v022_home_room_contract.gd
godot --headless --path . --script tests/test_v0223_ui_panel_scene_split.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
godot --path . --display-driver x11 --script tests/capture_expapproval003_home.gd
file docs/collaboration/round116_expapproval003_home/*.png
```

结果：以上验证均通过。`godot --headless` 截图路径按既有 `LESSON-010` 仍不可作为截图工具链，本轮最终截图 proof 使用非 headless `x11` 显示驱动导出。

## 5. 下一项 Ready

`V02-EXPAPPROVAL-004 Shop / Settings glass UI 可读可触批准返修` 进入 Ready。约束继续保持：复杂地图背景上的 glass panel 必须可读可触，购买、休息确认和回安全位置必须来自可见入口；不把旧 proof、headless 逻辑验证或本轮 Home proof 自动写成 approved。
