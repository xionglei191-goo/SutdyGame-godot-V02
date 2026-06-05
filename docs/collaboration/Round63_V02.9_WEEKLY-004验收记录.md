# Round 63 `V02-WEEKLY-004` 一周回访 smoke 与截图验收记录

> 日期：2026-06-05  
> 范围：V02.9 一周回访节奏收口。  
> PM 结论：`pass`，V02.9 的 7 天低压力回访节奏可以标记完成。

## 逻辑验证

新增 `tests/test_v029_weekly_return_smoke.gd`，并注册进 `tests/headless_runner.gd`。

覆盖内容：

- 连续切换 `local_day_001` 至 `local_day_007`。
- 每天刷新 HUD 今日状态，确认事件文案和 Sunny 提示同步变化。
- 每天按 `shop_rotation_id` 读取商店轮换，确认 `wooden_chair` 和 P0 offer 不消失。
- 每天通过真实可见 `看看` 路径完成 Mina 小树枝日常，验证资源、交付、奖励和按 day_key 保存。
- `local_day_004` / `local_day_005` 仅检查 Story Bear / Bus Helper 的 P1 状态和 B Bear / T Taxi 线索，不要求未实现的 Bookshop / Bus Stop 入口。
- 可见文本检查不出现工程文案、课程、测验、评分、背诵、倒计时、失败惩罚、陌生人带走、独自远行或赶时间压力。

## 截图取证

截图脚本沿用 `tests/capture_artbase005_screens.gd`。按 `LESSON-010`，本轮使用非 headless `x11` 路径取证，headless 只作为逻辑回归。

输出目录：`docs/collaboration/weekly004_captures/`

取证命令：

```bash
godot --display-driver x11 --path . --resolution 1280x720 --script tests/capture_artbase005_screens.gd -- --output-dir docs/collaboration/weekly004_captures --suffix weekly004_1280
godot --display-driver x11 --path . --resolution 960x540 --script tests/capture_artbase005_screens.gd -- --output-dir docs/collaboration/weekly004_captures --suffix weekly004_960
```

截图清单：

| 文件 | 视口 | 场景 | 结论 |
|---|---:|---|---|
| `shot_artbase005_town_weekly004_1280.png` | `1280x720` | 小镇首屏 | pass |
| `shot_artbase005_town_weekly004_960.png` | `960x540` | 小镇首屏 | pass |
| `shot_artbase005_shop_weekly004_1280.png` | `1280x720` | 商店入口 / 货架 | pass |
| `shot_artbase005_shop_weekly004_960.png` | `960x540` | 商店入口 / 货架 | pass |
| `shot_artbase005_home_weekly004_1280.png` | `1280x720` | 小屋操作 | pass |
| `shot_artbase005_home_weekly004_960.png` | `960x540` | 小屋操作 | pass |
| `shot_artbase005_anchor_clock_weekly004_1280.png` | `1280x720` | `C Clock` 回访点 | pass |
| `shot_artbase005_anchor_clock_weekly004_960.png` | `960x540` | `C Clock` 回访点 | pass |
| `shot_artbase005_anchor_orange_weekly004_1280.png` | `1280x720` | `O Orange` 回访点 | pass |
| `shot_artbase005_anchor_orange_weekly004_960.png` | `960x540` | `O Orange` 回访点 | pass |
| `shot_artbase005_anchor_sun_weekly004_1280.png` | `1280x720` | `S Sun` 回访点 | pass |
| `shot_artbase005_anchor_sun_weekly004_960.png` | `960x540` | `S Sun` 回访点 | pass |
| `shot_artbase005_npc_mina_weekly004_1280.png` | `1280x720` | Mina 互动 | pass |
| `shot_artbase005_npc_mina_weekly004_960.png` | `960x540` | Mina 互动 | pass |
| `shot_artbase005_npc_shopkeeper_weekly004_1280.png` | `1280x720` | 店长互动 | pass |
| `shot_artbase005_npc_shopkeeper_weekly004_960.png` | `960x540` | 店长互动 | pass |
| `shot_artbase005_npc_sunny_weekly004_1280.png` | `1280x720` | Sunny 互动 | pass |
| `shot_artbase005_npc_sunny_weekly004_960.png` | `960x540` | Sunny 互动 | pass |

## 抽查判断

- `shot_artbase005_town_weekly004_960.png`：HUD 与底栏可读，地图主体未被 UI 遮挡，首屏不是工程占位。
- `shot_artbase005_shop_weekly004_960.png`：商店货架面板可读，关闭按钮可见，底栏不遮挡商品按钮。
- PNG 文件尺寸已核对为 `1280x720` 或 `960x540`，没有空文件或错误分辨率。

## 验证命令

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --script tests/test_v029_weekly_return_smoke.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

以上命令已通过。

## PM 判断

- `V02-WEEKLY-004` 可以标记完成。
- V02.9 一周回访节奏可以标记完成：7 天状态、商店轮换、P0 可见路径、P1 不阻断边界和代表截图证据均已具备。
- 下一步不应自动扩 Bookshop / Bus Stop 为主流程，应先由 PM 建立下一阶段路线和 Ready 队列。

