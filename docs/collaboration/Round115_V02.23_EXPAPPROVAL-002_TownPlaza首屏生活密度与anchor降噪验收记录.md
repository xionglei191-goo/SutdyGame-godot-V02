# Round115 V02.23 EXPAPPROVAL-002 Town Plaza 首屏生活密度与 anchor 降噪验收记录

> 日期：2026-06-06
> 对应任务：`V02-EXPAPPROVAL-002 Town Plaza 首屏生活密度与 anchor 降噪返修`
> 结论：本轮完成 Town Plaza / World Map 首屏生活密度与 anchor 降噪返修；仍不把 Town Plaza 写成 approved，最终 approved / needs_fix 需等 `V02-EXPAPPROVAL-006` 同轮全视图判定。

## 1. 改动范围

- `TownStage` 新增 `PlazaLifeLayer`，在 place 与 hotspot 之间渲染 5 个非交互生活细节：长椅、花篮、公告牌和小灯。
- `AnchorObject` 徽章保持 12px 可读字号，但改为更轻透明度和更弱 backplate；A-Z 物件本体不隐藏。
- 新增 `get_expapproval_snapshot()` 只读快照，供 focused test 检查 place、life detail、hotspot、anchor、resource、NPC 和 debug layer 状态。
- 新增 `tests/test_v0223_expapproval_town_plaza_density.gd`，证明首屏密度、A-Z identity、真实入口和互吞边界。
- 新增 `tests/capture_expapproval002_town_plaza.gd` 和 `docs/collaboration/round115_expapproval002_town_plaza/` 三张 1280 proof。

## 2. 保持不变

- 未改 26 个 A-Z `anchor_id`、`letter`、`core_word`、`route_order`、`card_id`。
- 未改 `HomeDecorationService` 存档结构。
- 未新增课程 UI、测试、词表墙、打卡、评分、倒计时、字母顺序任务或远郊 P0。
- 未把本轮 proof、headless 通过或 production 状态写成 product approved。

## 3. 1280 proof

| 截图 | 目的 |
|---|---|
| `docs/collaboration/round115_expapproval002_town_plaza/shot_round115_expapproval002_town_plaza_first_screen_1280.png` | Town Plaza 首屏生活密度 proof |
| `docs/collaboration/round115_expapproval002_town_plaza/shot_round115_expapproval002_town_plaza_mina_resource_anchor_1280.png` | Mina / resource / anchor 附近层次 proof |
| `docs/collaboration/round115_expapproval002_town_plaza/shot_round115_expapproval002_town_plaza_footer_prompt_1280.png` | 底栏提示与 anchor deliberate look proof |

`file docs/collaboration/round115_expapproval002_town_plaza/*.png` 已确认三张均为 1280 x 720 PNG。

## 4. 验证

```bash
godot --headless --path . --check-only --script scripts/stages/town_stage.gd
godot --headless --path . --check-only --script scripts/stages/anchor_object.gd
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_v0223_expapproval_town_plaza_density.gd
godot --headless --path . --script tests/test_town_stage_layered_runtime.gd
godot --headless --path . --script tests/test_v0221_livegate_hotspot_priority.gd
godot --headless --path . --script tests/test_v0218_map_readability.gd
godot --headless --path . --script tests/test_v0223_ui_panel_scene_split.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
godot --path . --display-driver x11 --script tests/capture_expapproval002_town_plaza.gd
file docs/collaboration/round115_expapproval002_town_plaza/*.png
```

结果：以上验证均通过。`godot --headless` 截图路径按既有 `LESSON-010` 仍不可作为截图工具链，本轮最终截图 proof 使用非 headless `x11` 显示驱动导出。

## 5. 下一项 Ready

`V02-EXPAPPROVAL-003 Home 居住密度与小屋视觉批准返修` 进入 Ready。约束继续保持：不改 `HomeDecorationService` 存档结构，不显示格子 / 坐标 / 占格术语，不把旧 proof 或 headless 逻辑验证自动写成 approved。
