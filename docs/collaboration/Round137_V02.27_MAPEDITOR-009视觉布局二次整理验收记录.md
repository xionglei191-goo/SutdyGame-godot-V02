# Round137 V02.27 MAPEDITOR-009 视觉布局二次整理验收记录

> 日期：2026-06-07
> 阶段：V02.27 Map Editor 完整化 / 可用性降噪追加返修
> 状态：已收口，当前无 Ready

## 返修背景

Round136 已完成 Map Editor 初次可用性降噪，但新的 1280x720 截图反馈仍显示：

- 顶部工具条横向排布容易在右侧被裁切。
- 验证面板、Inspector 和状态区仍像大块黑色面板压迫地图。
- 地图主体仍被周边 UI 挤压，打开场景时不够像一个完整编辑画布。

本轮只做视觉布局二次整理，不改 `MapEditorSyncService` 保存合同，不改三份 JSON 分文件写回策略，不把编辑器暴露给孩子端 runtime。

## 交付内容

- `scenes/map_editor/town_map_authoring.tscn`
  - 将打开场景后的工作区固定为左侧控制侧栏 + 右侧地图画布。
  - 验证、工具、Inspector、状态面板保持 228px 宽，并分别固定为 116 / 272 / 130 / 142px 高。
  - 面板启用 `clip_contents`，文本 label 限制行数，避免长文本撑出超高黑块。

- `scripts/editor/town_map_authoring.gd`
  - `MAP_CELL_SIZE` 使用 15px，`MAP_VIEW_ORIGIN` 为 `(252, 52)`，让 60x34 地图 canvas 在 1280x720 内完整显示。
  - `_apply_declutter_layout()` 固定左侧工作栏矩形，并统一应用 panel style / clipping / label constraints。
  - `get_editor_layout_summary()` 继续向 focused test 暴露地图与 panel 几何信息。

- `tests/test_v027_mapeditor_usability_declutter.gd`
  - 增加 validation / toolbar / inspector / status 高度断言。
  - 继续覆盖地图 origin、map extent、marker label 长度和默认图层可见性。

## 运行期几何复核

Godot MCP 运行 `res://scenes/map_editor/town_map_authoring.tscn` 后复核：

| 节点 | 位置 | 尺寸 |
|---|---|---|
| `TownMapAuthoring` | `(0, 0)` | `1280 x 720` |
| `GroundPreviewLayer` / `RoadLayer` | `(252, 52)` | map origin |
| `ExportValidationPanel` | `(12, 12)` | `228 x 116` |
| `EditorToolbar` | `(12, 140)` | `228 x 272` |
| `InspectorPanel` | `(12, 424)` | `228 x 130` |
| `EditorStatusPanel` | `(12, 566)` | `228 x 142` |

MCP runtime screenshot 返回 `1280 x 720`，用于确认场景可渲染取证。

## 验证记录

已通过：

```bash
godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd
godot --headless --path . --script tests/test_v027_mapeditor_usability_declutter.gd
godot --headless --path . --script tests/test_v027_mapeditor_layers_inspector.gd
godot --headless --path . --script tests/test_v027_mapeditor_place_save.gd
godot --headless --path . --script tests/test_v027_mapeditor_cell_painting.gd
godot --headless --path . --script tests/test_v027_mapeditor_resource_save.gd
godot --headless --path . --script tests/test_v027_mapeditor_npc_routine_save.gd
godot --headless --path . --script tests/test_v027_mapeditor_anchor_migration_guard.gd
godot --headless --path . --script tests/test_v027_mapeditor_full_regression.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
git diff --check
```

## 边界确认

- 不改 `data/maps/world_map.json`、`data/life/resource_points.json`、`data/life/npc_routines.json` 的保存合同。
- 不改 A-Z anchor 稳定 ID、letter、core_word、route_order、card_id、audio_id 或相册语义。
- 不新增 EditorPlugin，不进入孩子端 runtime。
- 不把地图做成孩子端可见格子 / 坐标 / footprint / debug 体验。
- 本轮无新增已验证教训；`lessons.md` 仅补充轮次复盘行。
