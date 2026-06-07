# Round136 V02.27 MAPEDITOR-008 可用性降噪验收记录

> 日期：2026-06-07  
> 状态：已完成  
> 范围：`scenes/map_editor/town_map_authoring.tscn` 场景内 Map Editor 可用性降噪

## 背景

用户打开 `town_map_authoring.tscn` 后反馈“这个画面感觉很乱”。Round135 的 toolbar / Inspector / status area 已具备功能，但编辑器打开时面板和长 marker 标签容易压住地图主体，手工编辑体验不够清楚。

## 本轮交付

- `town_map_authoring.tscn` 固定地图画布 origin，并将验证、工具、Inspector 和状态区域拆成顶部工作带与右侧工作栏。
- `TownMapAuthoring` 增加运行时同款 declutter layout，确保动态创建 UI 时不回到旧散乱位置。
- Toolbar 按钮与 layer toggle 文案缩短，保留 tooltip 说明。
- `MapAuthoringMarker` 改为 compact badge 标签和类型配色：A-Z 显示字母，resource 显示 `R`，NPC routine 显示 `N`，place label 截短。
- 新增 `tests/test_v027_mapeditor_usability_declutter.gd`，并注册进 `tests/headless_runner.gd`。

## 验证

- `godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`
- `godot --headless --path . --check-only --script scripts/editor/map_authoring_marker.gd`
- `godot --headless --path . --script tests/test_v027_mapeditor_usability_declutter.gd`
- `godot --headless --path . --script tests/test_v027_mapeditor_layers_inspector.gd`
- V02.27 MAPEDITOR-003..007 focused tests
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`
- `git diff --check`
- `.tmp` / `.bak` 残留检查

## 边界

- 不改变 `world_map.json`、`resource_points.json` 或 `npc_routines.json` 保存合同。
- 不改变 A-Z anchor 稳定 ID、letter、core_word、route_order、card_id、audio_id 或相册语义。
- 不把 Map Editor 接入孩子端 runtime。
- 不把图层默认可见性改掉，避免破坏 Round135 V02.27 合同。

## 结论

MAPEDITOR-008 已完成。Map Editor 打开场景后的视觉密度降低，核心保存 / 验证 / A-Z 保护路径回归通过。无新增已验证教训。
