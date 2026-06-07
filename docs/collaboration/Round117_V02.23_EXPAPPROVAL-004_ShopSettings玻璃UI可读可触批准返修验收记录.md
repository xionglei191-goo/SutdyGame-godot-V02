# Round117 V02.23 EXPAPPROVAL-004 Shop / Settings 玻璃 UI 可读可触批准返修验收记录

> 日期：2026-06-06
> 对应任务：`V02-EXPAPPROVAL-004 Shop / Settings glass UI 可读可触批准返修`
> 结论：本轮完成 Shop / Settings 在复杂地图背景上的 glass panel 可读性、触控、关闭路径和反馈返修；仍不把 Shop 或 Settings 写成 approved，最终 approved / needs_fix 需等 `V02-EXPAPPROVAL-006` 同轮全视图判定。

## 1. 改动范围

- Shop / Settings panel scene script 加固 1280 读感：更宽面板、更不透明的玻璃底、更深文字、更稳定的 46px 触控按钮。
- Shop 商品按钮加宽并统一 46px 触控高度，购买路径继续走孩子端可见 `看看` -> 商店货架 -> 商品按钮。
- Settings 保持顶部可见入口，休息确认只在点击“休息一下”后出现；“回到小镇”仍关闭面板并回到安全位置。
- `main.gd` 新增 `get_expapproval_shop_settings_snapshot()` 只读快照，供 focused test 检查 panel 尺寸、按钮触控高度、确认状态和孩子端文本。
- 新增 `tests/test_v0223_expapproval_shop_settings_glass.gd`、`tests/capture_expapproval004_shop_settings.gd`，并注册进 `tests/headless_runner.gd`。

## 2. 保持不变

- 未改商店商品数据、价格、库存或保存结构。
- 未改设置 / 休息 / 回安全位置的业务语义。
- 未改 A-Z `anchor_id`、`letter`、`core_word`、`route_order`、`card_id`。
- 未新增课程 UI、测试、词表墙、打卡、评分、倒计时、作业、课堂或字母顺序任务。
- 未把本轮 proof、headless 通过或 scene 化状态写成 product approved。

## 3. 1280 proof

| 截图 | 目的 |
|---|---|
| `docs/collaboration/round117_expapproval004_shop_settings/shot_round117_expapproval004_shop_shelf_1280.png` | Shop 货架 glass panel 可读可触 proof |
| `docs/collaboration/round117_expapproval004_shop_settings/shot_round117_expapproval004_shop_purchase_feedback_1280.png` | Shop 可见购买与金币反馈 proof |
| `docs/collaboration/round117_expapproval004_shop_settings/shot_round117_expapproval004_settings_rest_confirm_1280.png` | Settings 休息确认、关闭和安全位置控件 proof |

`file docs/collaboration/round117_expapproval004_shop_settings/*.png` 已确认三张均为 1280 x 720 PNG。

## 4. 验证

```bash
godot --headless --path . --script tests/test_v0223_expapproval_shop_settings_glass.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v0223_ui_panel_scene_split.gd
godot --headless --path . --quit
godot --headless --path . --script tests/headless_runner.gd
godot --path . --display-driver x11 --resolution 1280x720 --script tests/capture_expapproval004_shop_settings.gd
file docs/collaboration/round117_expapproval004_shop_settings/*.png
```

结果：以上验证均通过。`godot --headless` 截图路径按既有 `LESSON-010` 仍不可作为截图工具链，本轮最终截图 proof 使用非 headless `x11` 显示驱动导出。

## 5. 下一项 Ready

`V02-EXPAPPROVAL-005 School Gate / School Yard 生活地点化与噪声返修` 进入 Ready。约束继续保持：学校必须像校门和操场生活地点，不得课程化、测试化或压力化；本轮 Shop / Settings proof 仍等待 `V02-EXPAPPROVAL-006` 逐项判定，不自动 approved。
