# Round153 V02.37 STORYBATCH-003 第二批 production 资产与接入

> 日期：2026-06-07
> 任务：`V02-STORYBATCH-003 第二批 production 资产与接入`
> 状态：完成
> 下一轮 Ready：`V02-STORYBATCH-004 第二批 runtime 接入与真实入口 smoke`

## 本轮范围

本轮承接 Round152 的 C/D/G/K/O/S/W 七条 story prop 内容包，生产并接入第二批 production bitmap 资产。范围只覆盖资产、logical asset ID、ThemeProfile / AssetResolver、story prop JSON、Map Editor marker 和 focused asset test；不做 runtime approved 判定，不把 `production` 自动升级为 `approved`。

## 资产清单

| Anchor | Story prop ID | Logical asset ID | Final PNG | Size |
|---|---|---|---|---|
| C Clock | `story_prop_marker_home_clock_chair_corner` | `story_prop.home.clock_chair_corner` | `assets/art/story_props/home/clock_chair_corner_v001.png` | 128x128 RGBA |
| D Dog | `story_prop_marker_home_sunny_towel_dog_corner` | `story_prop.home.sunny_towel_dog_corner` | `assets/art/story_props/home/sunny_towel_dog_corner_v001.png` | 128x128 RGBA |
| W Watch | `story_prop_marker_home_watch_wall_charm` | `story_prop.home.watch_wall_charm` | `assets/art/story_props/home/watch_wall_charm_v001.png` | 128x128 RGBA |
| G Gate | `story_prop_marker_school_gate_bell_sign` | `story_prop.school.gate_bell_sign` | `assets/art/story_props/school/gate_bell_sign_v001.png` | 128x128 RGBA |
| K Kite | `story_prop_marker_walk_kite_leaf_path` | `story_prop.walk.kite_leaf_path` | `assets/art/story_props/walk/kite_leaf_path_v001.png` | 160x128 RGBA |
| O Orange | `story_prop_marker_shop_orange_bowl_window` | `story_prop.shop.orange_bowl_window` | `assets/art/story_props/shop/orange_bowl_window_v001.png` | 128x128 RGBA |
| S Sun | `story_prop_marker_sun_flower_patch` | `story_prop.plaza.sun_flower_patch` | `assets/art/story_props/plaza/sun_flower_patch_v001.png` | 128x128 RGBA |

## Provenance

Built-in image generation was unavailable in this session, so the repo fallback script was used:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "<prompt>" tmp/round153_storybatch003_sources/<asset>_source.png 1024x1024
```

All source prompts used a cozy 2D story prop sprite style, a flat chroma-key backdrop, no characters, no text, no watermark, and explicit child-safety avoid terms such as classroom, test, score, timer, homework, purchase pressure, care pressure, and editor / grid language.

Source files:

| Asset | Source |
|---|---|
| Clock chair corner | `tmp/round153_storybatch003_sources/clock_chair_corner_source.png` |
| Sunny towel dog corner | `tmp/round153_storybatch003_sources/sunny_towel_dog_corner_source.png` |
| Watch wall charm | `tmp/round153_storybatch003_sources/watch_wall_charm_source.png` |
| Gate bell sign | `tmp/round153_storybatch003_sources/gate_bell_sign_source.png` |
| Kite leaf path | `tmp/round153_storybatch003_sources/kite_leaf_path_source.png` |
| Orange bowl window | `tmp/round153_storybatch003_sources/orange_bowl_window_source.png` |
| Sun flower patch | `tmp/round153_storybatch003_sources/sun_flower_patch_source.png` |

Post-processing used ImageMagick `convert`: alpha set, per-source corner chroma key with fuzz, trim, resize, transparent extent, and overwrite to the final repo paths. `tmp/round153_storybatch003_sources/contact_sheet.png` was used for dark-background contact inspection; the first pass caught residual pink background on several sources, then a per-image key pass produced clean transparent edges.

## 接入记录

- `data/themes/theme_sunshine_town_placeholder.json`：新增 7 个 `story_prop_assets` 映射和 7 条 `asset_acceptance` 记录，状态均为 `production`，`viewport_evidence` 保持 `pending_1280_runtime_proof`。
- `data/life/story_props.json`：新增 7 个 story prop marker，绑定 Round152 planned ID、logical asset ID、place、anchor、child label / feedback、environment words 和 optional NPC / resource context。
- `MapEditorSyncService` / `TownMapAuthoring`：既有 story prop validator 和 marker layer 能加载并选择全部 11 个 story prop marker。
- `tests/test_v0237_storybatch003_asset_integration.gd`：覆盖第二批 asset resolver、acceptance record、story prop JSON、child safety、anchor uniqueness 和 Map Editor marker validation。
- `tests/headless_runner.gd`：注册 STORYBATCH-003 runner 门槛。

## 验收结论

- 七个 bitmap 资产已进入 repo asset tree：通过。
- 所有 runtime / editor 入口均使用 logical asset ID，经 ThemeProfile / AssetResolver 解析：通过。
- 第二批 story props 总数为 7，合计 story prop marker 为 11，且不复用第二批 anchor：通过。
- `production` 未自动升级为 `approved`，1280 runtime proof 仍留给 `V02-STORYBATCH-004` / `005`：通过。
- 未改 A-Z anchor ID、letter、core word、route order 或 album card 语义：通过。
- 儿童文本不出现课程、测试、背诵、打卡、分数、倒计时、坐标、格子、debug 或 editor 术语：通过。

## 验证

- `godot --headless --path . --check-only --script tests/test_v0237_storybatch003_asset_integration.gd`
- `godot --headless --path . --script tests/test_v0237_storybatch003_asset_integration.gd`
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/headless_runner.gd`

以上均通过。
