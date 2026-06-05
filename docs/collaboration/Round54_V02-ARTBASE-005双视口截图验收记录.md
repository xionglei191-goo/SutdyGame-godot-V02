# Round 54 `V02-ARTBASE-005` 双视口截图验收记录

> 日期：2026-06-05  
> 范围：`V02-ARTBASE-005 双视口截图验收`。  
> PM 结论：`pass`，允许进入 `V02.8 每日小镇生活纵切`。

## 取证方式

- 截图脚本：`tests/capture_artbase005_screens.gd`
- 输出目录：`docs/collaboration/artbase005_captures/`
- 非 headless 取证命令：

```bash
godot --display-driver x11 --path . --resolution 960x540 --script tests/capture_artbase005_screens.gd -- --output-dir docs/collaboration/artbase005_captures --suffix 960
godot --display-driver x11 --path . --resolution 1280x720 --script tests/capture_artbase005_screens.gd -- --output-dir docs/collaboration/artbase005_captures --suffix 1280
```

## 截图清单

| 文件 | 视口 | 场景 | 结论 |
|---|---:|---|---|
| `shot_artbase005_town_1280.png` | `1280x720` | 小镇首屏 | pass |
| `shot_artbase005_town_960.png` | `960x540` | 小镇首屏 | pass |
| `shot_artbase005_shop_1280.png` | `1280x720` | 商店入口 / 货架 | pass |
| `shot_artbase005_shop_960.png` | `960x540` | 商店入口 / 货架 | pass |
| `shot_artbase005_home_1280.png` | `1280x720` | 小屋操作 | pass |
| `shot_artbase005_home_960.png` | `960x540` | 小屋操作 | pass |
| `shot_artbase005_anchor_clock_1280.png` | `1280x720` | `C Clock` 回访点 | pass |
| `shot_artbase005_anchor_clock_960.png` | `960x540` | `C Clock` 回访点 | pass |
| `shot_artbase005_anchor_orange_1280.png` | `1280x720` | `O Orange` 回访点 | pass |
| `shot_artbase005_anchor_orange_960.png` | `960x540` | `O Orange` 回访点 | pass |
| `shot_artbase005_anchor_sun_1280.png` | `1280x720` | `S Sun` 回访点 | pass |
| `shot_artbase005_anchor_sun_960.png` | `960x540` | `S Sun` 回访点 | pass |
| `shot_artbase005_npc_mina_1280.png` | `1280x720` | Mina 互动 | pass |
| `shot_artbase005_npc_mina_960.png` | `960x540` | Mina 互动 | pass |
| `shot_artbase005_npc_shopkeeper_1280.png` | `1280x720` | 店长互动 | pass |
| `shot_artbase005_npc_shopkeeper_960.png` | `960x540` | 店长互动 | pass |
| `shot_artbase005_npc_sunny_1280.png` | `1280x720` | Sunny 互动 | pass |
| `shot_artbase005_npc_sunny_960.png` | `960x540` | Sunny 互动 | pass |
| `contact_artbase005_1280.png` | contact sheet | 全量 1280 快速审图 | pass |
| `contact_artbase005_960.png` | contact sheet | 全量 960 快速审图 | pass |

## 验收判断

- `1280x720` 与 `960x540` 均有首屏、商店、小屋、三 NPC 互动和 `C/O/S` 回访点证据。
- 960 contact sheet 未见明显文字溢出、按钮贴边、关键关闭路径不可见或地图主体被 UI 吃掉。
- 商店面板在较小横屏中仍可读，关闭按钮可见。
- 小屋画面中 Sunny、宠物碗、小床和操作面板同时可见，底栏不遮挡核心操作。
- `C Clock`、`O Orange`、`S Sun` 以地图物件和短句回访方式出现，没有变成测验、课程或背诵入口。

## 进入 V02.8 的 PM 建议

- `V02-ARTBASE-005` 可以标记为完成。
- `V02-ARTBASE-001` 到 `004` 的候选实现已被双视口截图覆盖，可作为 V02.8 的当前 production 基线。
- 暂不把资源升级为长期最终美术；本轮 `approved` 只表示允许进入 V02.8 纵切，不代表后续无需美术精修。
- 下一轮 Ready：`V02-DAILYLIFE-001 三 NPC 日常入口`。
