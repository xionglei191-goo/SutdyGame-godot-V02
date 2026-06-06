# Round96 V02.19 ARTPASS-007 全屏构图与 UI 返修验收记录

> 日期：2026-06-06
> 任务：`V02-ARTPASS-007 全屏构图与 UI 风格返修`
> 触发原因：用户反馈游戏应为 fullscreen，当前仍像“地图在窗口里”，UI、icons 和整体风格仍需调整。

## 返修范围

- `scripts/main.gd` 移除主场景外层 `SafeArea` 边距，让 runtime playfield 直铺 1280x720。
- `RuntimeMap` 保留 60x34 逻辑网格与既有 A-Z / hotspot / NPC 坐标，渲染时缩放铺满 `1280x720`，点击输入反算回原逻辑格，避免破坏可玩路径。
- 旧 `RoadCell` 从主视觉降为 20% 透明弱引导，让生成底图成为主读图层。
- 常驻 `TownHUD` / `TownFooter` 改为轻量半透明 overlay，避免 skin texture 撑成大面板。
- 底栏上移，统一四个常驻按钮尺寸、圆角和背包 icon 比例。

## 视觉证据

- 最终 1280x720 proof：
  - `docs/collaboration/round96_visual_acceptance/shot_production005_town_plaza_round96_final_1280.png`
- 同组导出截图：
  - `shot_production005_home_round96_final_1280.png`
  - `shot_production005_shop_round96_final_1280.png`
  - `shot_production005_school_gate_round96_final_1280.png`
  - `shot_production005_school_yard_round96_final_1280.png`
  - `shot_production005_album_round96_final_1280.png`
  - `shot_production005_settings_round96_final_1280.png`

## 验证命令

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --script tests/test_asset_resolver.gd
godot --headless --path . --script tests/test_v0218_map_readability.gd
godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
历史截图命令已清理；保留 docs/collaboration/round96_visual_acceptance/ 下 round96_final_1280 证据文件。
```

## 结果

- 全部验证通过。
- 1280x720 proof 已确认底图铺满视口，常驻 UI 为 overlay，不再出现外层窗口边距。
- 本轮未改 A-Z anchor 数据、相册合同、NPC / 商店 / 小屋可玩路径。
- 无新增已验证教训。
