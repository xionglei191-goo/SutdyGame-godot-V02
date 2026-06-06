# Round94 V02.19 ARTPASS-005 验收记录

> 日期：2026-06-06  
> 任务：`V02-ARTPASS-005 P0 场景与 26 Anchor 物件替换`  
> 结论：通过，进入 `V02-ARTPASS-006 角色 / 宠物 / UI 资产替换与截图收口`

## 本轮交付

- 新增 26 个 A-Z anchor 生活物件 SVG/PNG 资产与 Godot import，路径为 `assets/art/anchors/anchor_*.{svg,png}`。
- 新增 `scripts/tools/generate_artpass005_anchor_assets.js`，用于稳定再生成 anchor SVG/PNG，并机械同步 `theme_sunshine_town_placeholder.json` 的 `anchor_assets` 映射和 acceptance records。
- `data/themes/theme_sunshine_town_placeholder.json` 的 26 个 `anchor.*` logical ID 已从 placeholder 路径升级到 `res://assets/art/anchors/*.png` production 映射。
- `scripts/main.gd` 的 26 个 runtime anchor object texture key 已接入 `anchor_assets`；`_create_anchor_object_sprite()` 现在按 A-Z 映射到 production anchor 物件，而不是旧程序色块或 reserved fallback。
- `tests/test_asset_resolver.gd` 与 `tests/headless_runner.gd` 检查 26 个 anchor production 资产解析、文件存在、acceptance record、child-safety notes 和 anchor-integrity notes。
- `tests/test_v0218_map_readability.gd` 要求每个 runtime anchor `ObjectSprite` 使用 160px production anchor texture，同时继续验证徽章可读性、真实 `看看` 路径和相册落账。

## 不变边界

- 不改变 26 anchor 的 `anchor_id`、letter、card_id、坐标、badge offset、look hotspot 或相册语义。
- 不把字母画进物件资产；字母仍只作为现有 badge 辅助识别。
- 不新增课程 UI、背诵、测试、分数、打卡、倒计时、技巧挑战、购买压力或远郊 P0 主线。
- 960x540 继续留到全部开发完成后的版本适配专项。

## 验证

- `find data -name '*.json' -print0 | xargs -0 jq empty`
- `godot --headless --path . --script tests/test_asset_resolver.gd`
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`
- `godot --headless --path . --check-only --script scripts/main.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

## 下一步

`V02-ARTPASS-006` 收口角色、宠物和 UI：确认 Player、Mina、Sunny、Shopkeeper、Story Bear、Bus Helper、必要 UI 图标和 glass UI 皮肤的 production / approved 状态，补 1280x720 截图证据，并保持孩子端触控与可读性。
