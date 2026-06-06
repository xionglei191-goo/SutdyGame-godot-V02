# Round97 V02.19 ARTPASS-008 剩余 runtime 素材补齐验收记录

> 日期：2026-06-06
> 任务：`V02-ARTPASS-008 Round92 样张风格剩余 runtime 素材补齐`
> 范围：只覆盖仍由 `ThemeProfile` / `AssetResolver` 映射到 runtime 的 PNG；不改 gameplay、地图坐标、A-Z anchor 结构、UI 布局或 logical asset ID。

## 目标

本轮补齐 Round95/96 后仍遗漏的 runtime 美术资产，包括 place、UI icon、Sunny、家具和角色。它们不是废弃资源，而是仍在主题映射中使用的生产素材；因此本轮采用直接覆盖原 PNG 路径的方式，保持所有 logical asset ID 和 runtime 映射结构不变。

## 生成方式

- 参考样张：`docs/collaboration/artpass003_visual_direction/`
  - `artpass003_main_gameplay_direction_1280.png`
  - `artpass003_glass_ui_direction_1280.png`
  - `artpass003_character_anchor_direction_1280.png`
- 外部生成脚本：`node /home/xionglei/GameProject/tools/image_generator.js text "<prompt>" "<output.png>" "1024x1024"`
- 执行方式：逐张外部生成，单张请求加超时和失败清单；超时项单独重试。
- 后处理：place 保持当前 runtime 尺寸裁切；角色、宠物、家具、UI icon 和外观 sprite 使用边缘连通背景抠除，输出透明 PNG。

Prompt 摘要：统一使用 Round92 Sunshine Town 方向，关键词为 cozy Animal Crossing inspired children mobile life RPG、rounded soft forms、warm fresh daylight but not yellow、low stress、pastel greens and peach accents、soft 2.5D game asset、Apple-like translucent glass UI；明确禁止 classroom、grades、combat、warning colors、text、letters、watermark。

## 替换清单

| 类别 | 路径 |
|---|---|
| places | `assets/art/places/town_plaza_day.png` |
| places | `assets/art/places/home_yard_day.png` |
| places | `assets/art/places/home_school_walk_day.png` |
| places | `assets/art/places/school_gate_exterior.png` |
| places | `assets/art/places/school_yard_day.png` |
| places | `assets/art/places/shop_street_day.png` |
| places | `assets/art/places/animal_park_day.png` |
| places | `assets/art/places/coast_edge_day.png` |
| places | `assets/art/places/sun_scene_morning.png` |
| places | `assets/art/places/story_culture_bridge_day.png` |
| places | `assets/art/places/home_exterior.png` |
| places | `assets/art/places/shop_exterior.png` |
| places | `assets/art/places/road_main.png` |
| characters | `assets/art/characters/player_standing.png` |
| characters | `assets/art/characters/mina_standing.png` |
| characters | `assets/art/characters/shopkeeper_standing.png` |
| characters | `assets/art/characters/story_bear_standing.png` |
| characters | `assets/art/characters/bus_helper_standing.png` |
| pets | `assets/art/pets/sunny_standing.png` |
| furniture | `assets/art/furniture/small_table_placed.png` |
| furniture | `assets/art/furniture/pet_bowl_placed.png` |
| furniture | `assets/art/furniture/sunny_bed_placed.png` |
| UI icons | `assets/art/ui/icons/coin.png` |
| UI icons | `assets/art/ui/icons/bag.png` |
| UI icons | `assets/art/ui/icons/shop.png` |
| UI icons | `assets/art/ui/icons/close.png` |
| UI icons | `assets/art/ui/icons/settings.png` |

未替换：`assets/art/places/world_map_base_1280.png` 和 26 个 `assets/art/anchors/anchor_*.png`，它们已在 Round95 覆盖，本轮不重新生成。

## 数据记录

`data/themes/theme_sunshine_town_placeholder.json` 已更新上述 27 个 logical asset ID 的 `asset_acceptance` 记录：

- `status`: `production`
- `acceptance_result`: `pass`
- `viewport_evidence`: `round97_artpass008_preview.png`
- 不标记 `approved`，等待 PM / Art Direction 后续明确确认。

## 视觉证据

- 总览预览：`docs/collaboration/round97_artpass008_preview.png`
- 视觉抽查结论：place 素材已转为完整 cozy town 外部生成图；角色、Sunny、家具、UI icons 已去除黑灰棚底并具备透明 alpha；未发现课程、分数、战斗、警报色、强消费或水印文本。

## 验收口径

- 保持现有文件名、目录和 logical asset ID。
- 不恢复已删除 SVG 源稿。
- 不修改 `ThemeProfile` 映射 key，不新增 gameplay 依赖。
- 不改变地图坐标、A-Z anchor route/order、热点优先级、UI 布局或孩子端文案。
- 本轮验收为 1280x720 口径；960x540 后续按全量开发完成后的专项适配处理。

## 验证结果

已通过：

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
python3 mapped PNG existence check
python3 orphan .import check
godot --headless --path . --script tests/test_asset_resolver.gd
godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

结果摘要：JSON 解析通过；所有 mapped `res://assets/art/...png` 文件存在；无孤儿 `.import`；AssetResolver、Playable RC Gate、UI 操作、全量 headless runner 和 Godot headless 启动均通过。
