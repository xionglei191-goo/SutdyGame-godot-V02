# Round138 V02.27 MAPEDITOR-010 直接拖拽编辑与字母可见性返修验收记录

日期：2026-06-07

## 背景

用户反馈 Map Editor 仍然“不能移动和编辑，而且看不到字母”。本轮只修复场景内编辑器可操作性，不改孩子端 runtime，不改三份 JSON 保存合同。

## 交付

- `MapAuthoringMarker` 拖拽改为按下后全局追踪鼠标移动与释放，避免鼠标离开小 marker 后拖拽中断。
- `TownMapAuthoring` 将 marker drag finish 接入候选 move 验证，移动失败会回退原 cell 并显示状态。
- Inspector 新增真实输入框和 Apply 按钮，可从场景内直接编辑 Place、resource、NPC routine 字段，以及在 Move A-Z 模式下编辑 anchor `cell_x` / `cell_y`。
- A-Z 字母 marker 改为在 marker `_draw()` 中直接绘制居中字母，同时增大字号、提高对比、提高 z 顺序，并保持 A-Z anchor 迁移必须进入 Move A-Z 专门模式。
- 新增 `tests/test_v027_mapeditor_direct_edit_drag.gd`，并注册进 `tests/headless_runner.gd`。
- 更新 `tests/test_v027_mapeditor_usability_declutter.gd`，覆盖 A-Z 字母字号与 z 顺序。

## 验收

- `godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`
- `godot --headless --path . --check-only --script scripts/editor/map_authoring_marker.gd`
- `godot --headless --path . --script tests/test_v027_mapeditor_direct_edit_drag.gd`
- `godot --headless --path . --script tests/test_v027_mapeditor_usability_declutter.gd`
- `godot --headless --path . --script tests/test_v027_mapeditor_layers_inspector.gd`
- `godot --headless --path . --script tests/test_v027_mapeditor_place_save.gd`
- `godot --headless --path . --script tests/test_v027_mapeditor_full_regression.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`
- `git diff --check`

## 边界

- 不把编辑器入口暴露给孩子端 runtime。
- 不改变 `data/maps/world_map.json`、`data/life/resource_points.json`、`data/life/npc_routines.json` 的保存合同。
- 不允许普通编辑改 26 个核心 A-Z anchor 的稳定 ID、letter、core_word、route_order、card_id 或 audio_id。
