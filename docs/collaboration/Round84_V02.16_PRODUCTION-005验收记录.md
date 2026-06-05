# Round84 V02.16 PRODUCTION-005 验收记录

> 日期：2026-06-05
> 阶段：V02.16 可制作内容与体验抛光 / Playable RC Gate
> 验收范围：V02-PRODUCTION-002 至 V02-PRODUCTION-005

## 完成结论

V02.16 Playable RC Gate 已完成。当前版本已经把 V02.8-V02.15 跑通的每日小镇、Home / School、天气、P1 轻回访、商店、小屋、Sunny、相册和设置整理为 5-10 分钟可试玩路径。

本轮未新增地图区域、课程 UI、大型系统或 A-Z anchor 结构改动。Bookshop / Bus Stop 继续保持 P1 支线，不进入 P0 硬依赖。

## 交付物

- 新增 `tests/test_v0216_playable_rc_gate.gd`：覆盖启动、Mina / 资源、Shop、Home、Sunny、Home-School Walk、School Gate、School Yard、Return Home、Album、Settings 的真实可见入口路径。
- 新增 `tests/capture_production005_screens.gd`：导出 Playable RC Gate 关键视图截图。
- 更新 `tests/headless_runner.gd`：注册 `_check_v0216_playable_rc_gate()`，把 V02.16 总路径纳入全量回归。
- 新增 `docs/collaboration/production005_captures/`：包含 Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings 的 1280x720 与 960x540 截图。

## 截图清单

| 视图 | 1280x720 | 960x540 |
|---|---|---|
| Town Plaza | `shot_production005_town_plaza_1280.png` | `shot_production005_town_plaza_960.png` |
| Home | `shot_production005_home_1280.png` | `shot_production005_home_960.png` |
| Shop | `shot_production005_shop_1280.png` | `shot_production005_shop_960.png` |
| School Gate | `shot_production005_school_gate_1280.png` | `shot_production005_school_gate_960.png` |
| School Yard | `shot_production005_school_yard_1280.png` | `shot_production005_school_yard_960.png` |
| Album | `shot_production005_album_1280.png` | `shot_production005_album_960.png` |
| Settings | `shot_production005_settings_1280.png` | `shot_production005_settings_960.png` |

## 验证命令

```bash
godot --headless --path . --check-only --script tests/test_v0216_playable_rc_gate.gd
godot --headless --path . --check-only --script tests/capture_production005_screens.gd
godot --headless --path . --check-only --script tests/headless_runner.gd
godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
godot --path . --display-driver x11 --rendering-driver opengl3 --resolution 1280x720 --script tests/capture_production005_screens.gd -- --output-dir docs/collaboration/production005_captures --suffix 1280
godot --path . --display-driver x11 --rendering-driver opengl3 --resolution 960x540 --script tests/capture_production005_screens.gd -- --output-dir docs/collaboration/production005_captures --suffix 960
```

## 文本与体验验收

- 孩子端可见文本扫描覆盖 HUD、NPC、Sunny、Home / School、天气、P1、商店、小屋、相册和设置。
- 禁用词未在可见 UI 中出现：课程、作业、测试、背诵、迟到、打卡、分数、正确率、家长报告、必须完成、错过损失等。
- `看看`、小镇、背包、商店、小屋、相册和设置均通过真实可见入口触发。
- 商店、小屋、相册和设置均有可见关闭或返回路径。
- 截图使用非 headless `x11` / `opengl3` 路径导出，符合 LESSON-010 的视觉取证规则。

## 资产状态口径

本轮截图证明当前关键视图可作为 Playable RC Gate 截图证据。`production` 仍表示资源可集成；是否提升为 `approved` 需要 PM / Art Direction 在后续美术质量审查中逐项确认。本记录不自动把所有资源提升为 `approved`。
