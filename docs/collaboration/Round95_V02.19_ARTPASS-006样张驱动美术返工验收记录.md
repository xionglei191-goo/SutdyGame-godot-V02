# Round95 V02.19 ARTPASS-006 样张驱动美术返工验收记录

日期：2026-06-06

## 范围

- 以 Round92 三张 1280x720 样张为正式方向：Animal Crossing-like cozy town 世界视觉、Apple-like translucent glass UI、anchor 先是生活物件。
- 使用本地生图脚本优先生产 runtime bitmap 资产；旧 SVG / 工程化占位资产不再作为正式美术方向基线。
- 保留 logical asset ID、A-Z anchor ID / 坐标语义、`看看` 热点、相册落账和旧玩家路径 smoke。

## 交付物

- 地图：`assets/art/places/world_map_base_1280.png`，尺寸 1280x720。
- 区域：Home Yard、Home-School Walk、School Gate、School Yard、Shop Street、Animal Park、Coast Edge、Sun Scene、Story + Culture Bridge 共 9 个 PNG。
- Anchor：`assets/art/anchors/anchor_*.png` 26 个，全部为 160x160 production runtime texture。
- UI：`assets/art/ui/skin/glass_*.png`，覆盖 HUD、footer、panel、button、icon button 等 glass skin。
- 证据：`docs/collaboration/round95_visual_acceptance/shot_round95_runtime_1280.png`，MCP runtime 截图，1280x720。

## Runtime 接入

- `data/themes/theme_sunshine_town_placeholder.json` 的 `place_assets`、`anchor_assets` 和 `ui_skin` 已映射到 production PNG。
- `scripts/main.gd` 通过 logical asset ID 加载地图底图、anchor 物件和 glass UI skin。
- 区域 / place production 贴图在 runtime 中保留为极淡 metadata，避免压过 `world_map_base_1280` 的整体小镇视觉。
- UI skin loader 优先使用 `ResourceLoader`，仅在失败时 fallback 到 raw image load。

## 1280x720 视觉结论

- 通过：runtime 首屏已读作温暖 2.5D 小镇地图，水岸、中心建筑、道路、商店街、动物公园和海边层次清楚。
- 通过：HUD / footer / panel 控件读作 translucent glass，中文 UI 和按钮仍清晰可触。
- 通过：26 个 A-Z anchor 保持可见、可触发、可落账，字母 badge 是辅助层，不改变记忆宫殿结构。
- 通过：未出现课程、测试、词表、打卡、倒计时、远郊主流程压力或工程占位文案。

## 验证

- `find data -name '*.json' -print0 | xargs -0 jq empty`：通过。
- `godot --headless --path . --script tests/test_asset_resolver.gd`：通过。
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`：通过。
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`：通过。
- `godot --headless --path . --script tests/test_playable_ui_operations.gd`：通过。
- `godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`：通过。
- `godot --headless --path . --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --quit`：通过。

无新增已验证教训。
