# Round119 V02.23 EXPAPPROVAL-006 1280 RC 截图包真实入口 smoke 与逐项判定记录

> 日期：2026-06-07
> 对应任务：`V02-EXPAPPROVAL-006 1280 RC 截图包、真实入口 smoke 与逐项 approved 判定`
> 结论：本轮完成同轮 1280x720 runtime RC 截图包、真实入口 smoke、Album 回归 proof 和逐项 PM / Art Direction 判定。Town Plaza / World Map、Home、Shop、School Gate、School Yard、Settings 均按本轮证据升级为 `approved`；Album 经本轮回归截图确认无可见退化，状态保持 `approved`。

## 1. 本轮证据边界

本轮判定只使用 Round119 同轮证据：

- 非 headless runtime capture：`tests/capture_expapproval006_rc.gd`
- 同轮 proof 目录：`docs/collaboration/round119_expapproval006_rc/`
- 真实入口 smoke：`tests/test_v0223_expapproval006_rc_smoke.gd`
- runner 集成：`tests/headless_runner.gd`

以下内容不得作为本轮批准依据：旧 Round106 / Round112 / Round115-Round118 proof 自动沿用、headless 逻辑验证本身、`production` 状态、V02.22 scene-native / hidden-grid 架构完成、旧 panel split 测试名称。

## 2. 1280 RC 截图清单

| 视图 / 路径 | Round119 同轮 proof |
|---|---|
| Town Plaza / World Map | `shot_round119_expapproval006_town_plaza_first_screen_1280.png`、`shot_round119_expapproval006_town_plaza_prompt_1280.png` |
| Home | `shot_round119_expapproval006_home_default_1280.png`、`shot_round119_expapproval006_home_furniture_1280.png` |
| Shop | `shot_round119_expapproval006_shop_shelf_1280.png`、`shot_round119_expapproval006_shop_purchase_feedback_1280.png`、`shot_round119_expapproval006_shop_closed_path_1280.png` |
| School Gate | `shot_round119_expapproval006_school_gate_arrival_1280.png`、`shot_round119_expapproval006_school_gate_feedback_1280.png` |
| School Yard | `shot_round119_expapproval006_school_yard_arrival_1280.png`、`shot_round119_expapproval006_school_yard_feedback_1280.png` |
| Album | `shot_round119_expapproval006_album_open_1280.png`、`shot_round119_expapproval006_album_closed_path_1280.png` |
| Settings | `shot_round119_expapproval006_settings_default_1280.png`、`shot_round119_expapproval006_settings_rest_confirm_1280.png`、`shot_round119_expapproval006_settings_safe_place_1280.png` |

截图尺寸复核：上述 16 张 PNG 均为 `1280 x 720`。

## 3. 真实入口 smoke 范围

`tests/test_v0223_expapproval006_rc_smoke.gd` 覆盖以下孩子端真实入口：

- Town Plaza / World Map：进入 town view，移动到广场首屏与互动提示区域，检查 26 个 A-Z anchor、badge 降噪和 debug 隐藏。
- Home：从底栏小屋入口进入，使用可见家具按钮摆放 `wooden_chair`，检查默认生活细节、家具可见和孩子端文本。
- Shop：从地图 Shop hotspot 的可见 `看看` 打开，检查商品面板、触控高度、儿童安全文本和关闭路径。
- Album：从背包可见入口打开相册 overlay，再从可见关闭按钮返回。
- Settings：从顶部设置按钮打开，检查休息确认、取消、关闭和安全位置路径。
- School Gate / School Yard：通过玩家移动到地点并使用可见 `看看` 触发反馈，检查生活地点细节和无课程压力文案。

可见文本扫描覆盖工程文案、课程 / 作业 / 测试 / 分数 / 打卡 / 倒计时 / debug / grid / cell / 坐标 / 格子 / 占格 / 家长报告等禁词。

## 4. 逐项 PM / Art Direction 判定

| 视图 / 区域 | 本轮判定 | 判定依据 |
|---|---|---|
| Town Plaza / World Map | `approved` | Round119 首屏与 prompt proof 显示居民、资源、place、A-Z anchor 和 HUD 层级清楚；真实入口 smoke 保持 26 anchor、badge 全部降噪、collision debug 隐藏。 |
| Home | `approved` | Round119 默认小屋与家具 proof 显示生活角、Sunny / 家具状态和可见操作成立；smoke 从小屋入口与可见家具按钮完成摆放，孩子端不显示格子 / 坐标 / 占格术语。 |
| Shop | `approved` | Round119 商品、购买反馈和关闭路径 proof 显示 glass panel 可读、商品按钮可触、购买反馈清楚；smoke 从地图 Shop hotspot 的可见 `看看` 打开并验证触控高度与关闭路径。 |
| School Gate | `approved` | Round119 到达与反馈 proof 显示校门为生活地点，不像课堂入口；smoke 通过玩家移动和可见 `看看` 触发，校门文本无课程、测试、作业、分数或压力词。 |
| School Yard | `approved` | Round119 到达与反馈 proof 显示操场物件和 School line anchor 层级可读；smoke 通过玩家移动和可见 `看看` 触发，操场文本保持生活化。 |
| Album | `approved` | Album 既有批准事实经 Round119 打开与关闭路径回归 proof 复核，overlay 身份、关闭路径和地图遮挡关系无可见退化，因此保持 `approved`。 |
| Settings | `approved` | Round119 默认、休息确认和安全位置 proof 显示 glass panel 可读、按钮可触、二次确认和安全位置路径清楚；smoke 从顶部可见按钮打开并覆盖确认 / 取消 / 关闭路径。 |

## 5. 验证记录

已通过验证：

```bash
godot --headless --path . --script tests/test_v0223_expapproval006_rc_smoke.gd
godot --headless --path . --check-only --script tests/capture_expapproval006_rc.gd
godot --headless --path . --script tests/test_v0221_livegate_free_life_smoke.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v0221_livegate_shop_school_arrival.gd
godot --headless --path . --script tests/test_v0218_map_readability.gd
godot --headless --path . --script tests/test_v0223_ui_panel_scene_split.gd
godot --headless --path . --script tests/test_v0223_expapproval_town_plaza_density.gd
godot --headless --path . --script tests/test_v0223_expapproval_home_living_density.gd
godot --headless --path . --script tests/test_v0223_expapproval_shop_settings_glass.gd
godot --headless --path . --script tests/test_v0223_expapproval_school_gate_yard_life_noise.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
godot --path . --display-driver x11 --resolution 1280x720 --script tests/capture_expapproval006_rc.gd
file docs/collaboration/round119_expapproval006_rc/*.png
```

## 6. 后续 Ready

`V02-EXPAPPROVAL-006` 可收口。下一轮进入 `V02-HOMEPLAZA-001 PM 路线与禁改边界`，作为 V02.24 Home / Town Plaza 居住感加固的 PM 起点。

后续继续保持：

- 不改 HomeDecorationService 存档结构。
- 不改 26 个 A-Z anchor ID、`route_order`、核心绑定或相册语义。
- 不把 School 做成课程空间。
- 不把 headless 逻辑验证、架构完成或 production 状态单独写成 product approval。
