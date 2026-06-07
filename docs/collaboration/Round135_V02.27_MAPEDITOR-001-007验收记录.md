# Round135 V02.27 MAPEDITOR-001..007 验收记录

> 日期：2026-06-07
> 阶段：V02.27 Map Editor 完整化
> 状态：阶段收口，当前无 Ready

## 范围

本轮完善 `scenes/map_editor/town_map_authoring.tscn` 作为场景内 Godot 地图编辑工具，不做 EditorPlugin，不进入孩子端 runtime。编辑器只操作候选 state，运行时仍读取正式 JSON。

## 交付物

- `scripts/editor/map_authoring_marker.gd`
  - 增加 marker 选择信号、拖拽完成信号和 selected 样式。
- `scripts/editor/town_map_authoring.gd`
  - 增加 toolbar、tool mode、road / collision / interaction / place / anchor / resource / npc 图层开关、Inspector 和底部状态区。
  - 增加 Place 属性编辑、拖动联动和 Save Map。
  - 增加 road / collision / interaction 单 cell 画笔与橡皮。
  - 增加 resource marker 加载、移动、字段编辑、Validate Resources 和 Save Resources。
  - 增加 NPC routine day selector、marker 加载、移动、label 编辑、Validate Routines 和 Save Routines。
  - 增加 A-Z anchor 专门迁移模式，核心字段保持锁定。
- `scripts/editor/map_editor_sync_service.gd`
  - 增加 `resource_points.json` 与 `npc_routines.json` 的分文件加载、验证和安全写入。
  - 资源保存验证 `item_id`、quantity、canvas 和 protected cells。
  - NPC routine 验证 `npc_id`、day / routine 唯一性、canvas 和 protected cells。
  - 分文件保存继续采用 temp / backup / swap / post-load verify。
- `tests/`
  - 新增 V02.27 focused tests 并注册进 `tests/headless_runner.gd`。

## 测试矩阵

| 测试 | 覆盖 |
|---|---|
| `tests/test_v027_mapeditor_layers_inspector.gd` | 图层开关、工具模式、选择态、Inspector 和 day selector |
| `tests/test_v027_mapeditor_place_save.gd` | Place 字段编辑、移动联动、临时 map save、非法不写 |
| `tests/test_v027_mapeditor_cell_painting.gd` | road / collision / interaction 画笔、橡皮和 protected cell guard |
| `tests/test_v027_mapeditor_resource_save.gd` | resource marker 编辑、catalog item guard、分文件保存、非法不写 |
| `tests/test_v027_mapeditor_npc_routine_save.gd` | NPC routine day selector、label / cell 编辑、分文件保存、非法不写 |
| `tests/test_v027_mapeditor_anchor_migration_guard.gd` | move_anchor 专门模式、核心字段锁定、26 anchors 保持 |
| `tests/test_v027_mapeditor_full_regression.gd` | map / resource / routine 三文件临时保存、A-Z 不退化、正式 JSON 不被误改 |
| `tests/headless_runner.gd` | V02.27 轻量回归注册和共享 runner 集成 |

## 禁改边界

- 不改孩子端 `scenes/main.tscn` 导航，不暴露编辑器入口。
- 不改 26 个核心 `anchor_id`、`letter`、`core_word`、`route_order`、`card_id`、`audio_id` 或相册语义。
- Resource 与 NPC routine 不写入 `world_map.json`，只走各自分文件保存。
- 任何保存失败、合同失败或 post-load 失败都不得覆盖正式文件。
- 孩子端继续不得显示格子、坐标、footprint、debug 或编辑器术语。

## 验证命令

```bash
godot --headless --path . --check-only --script scripts/editor/map_editor_sync_service.gd
godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd
godot --headless --path . --check-only --script tests/headless_runner.gd
godot --headless --path . --script tests/test_v027_mapeditor_layers_inspector.gd
godot --headless --path . --script tests/test_v027_mapeditor_place_save.gd
godot --headless --path . --script tests/test_v027_mapeditor_cell_painting.gd
godot --headless --path . --script tests/test_v027_mapeditor_resource_save.gd
godot --headless --path . --script tests/test_v027_mapeditor_npc_routine_save.gd
godot --headless --path . --script tests/test_v027_mapeditor_anchor_migration_guard.gd
godot --headless --path . --script tests/test_v027_mapeditor_full_regression.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## 结果

Focused tests、full runner 和 Godot 启动通过后，`V02-MAPEDITOR-001..007` 可在 `todo.md` 标记完成。未产生新增已验证教训。
