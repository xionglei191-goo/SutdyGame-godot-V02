# Round93 V02.19 ARTPASS-004 验收记录

> 日期：2026-06-06  
> 任务：`V02-ARTPASS-004 P0 世界地图底图与区域块替换`  
> 结论：通过，进入 `V02-ARTPASS-005 P0 场景与 26 Anchor 物件替换`

## 本轮交付

- 新增世界地图底图与区域块资产源文件和 PNG：
  - `assets/art/places/world_map_base_1280.*`
  - `assets/art/places/home_yard_day.*`
  - `assets/art/places/home_school_walk_day.*`
  - `assets/art/places/school_gate_exterior.*`
  - `assets/art/places/school_yard_day.*`
  - `assets/art/places/shop_street_day.*`
  - `assets/art/places/animal_park_day.*`
  - `assets/art/places/coast_edge_day.*`
  - `assets/art/places/sun_scene_morning.*`
  - `assets/art/places/story_culture_bridge_day.*`
- `ThemeProfileResource` 与 `AssetResolver` 增加 `anchor_assets` 类别和 `get_anchor_asset()`，为 ARTPASS-005 的 26 anchor 物件替换预留正式合同。
- `data/themes/theme_sunshine_town_placeholder.json` 新增 10 个 `place.*` production 映射和 26 个 `anchor.*` logical ID；旧 `storybook_placeholder` 风格字段改为 `cozy_town_glass_placeholder`。
- `scripts/main.gd` 将 Ground、9 个 MapRead zone 和 9 个 place marker body 接到 logical asset ID；有 production body 资产时不再叠加旧门窗 / 屋顶占位层。
- `tests/test_asset_resolver.gd`、`tests/test_v0218_map_readability.gd` 和 `tests/headless_runner.gd` 增加 ARTPASS-004 地图资产解析与 runtime 贴图断言。

## 不变边界

- 不改变 `data/maps/world_map.json` 的 60x34 Home-centered 布局、place 坐标、hotspot、collision、roads 或 26 anchor 坐标。
- 不改变 Home / School / Town / Far Edge 的 A-Z 语义和相册落账路径。
- 不新增课程 UI、答题、打卡、倒计时、分数、远郊 P0 主线或联网能力。
- 本轮只完成 1280x720 口径下的地图区域资产接入；960x540 继续留到全部开发完成后的版本适配专项。

## 验证

- `find data -name '*.json' -print0 | xargs -0 jq empty`
- `godot --headless --path . --script tests/test_asset_resolver.gd`
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`
- `godot --headless --path . --check-only --script scripts/main.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

## 下一步

`V02-ARTPASS-005` 以本轮新增的 `anchor_assets` 合同为输入，替换 26 个 anchor 的生活物件视觉。验收重点仍是物件优先、字母徽章辅助、School line 不堆叠、不课程化，并保持真实 `看看` 路径和相册落账通过。
