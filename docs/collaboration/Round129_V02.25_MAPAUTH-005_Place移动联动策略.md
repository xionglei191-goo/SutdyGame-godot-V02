# Round129 V02.25 MAPAUTH-005 Place 移动联动策略

日期：2026-06-07

## 范围

- 收口 `V02-MAPAUTH-005 Place 移动联动策略`。
- 保持 V02.25 双阶段提交：`TownMapAuthoring` 只更新候选 dictionary，`MapEditorSyncService` 负责合同验证，非法候选不得写回 `data/maps/world_map.json`。
- 不改 A-Z anchor ID / route_order / 相册语义，不改运行时读取 JSON 的边界。

## 交付

- `TownMapAuthoring` 新增 `move_place_marker_candidate()`。
- Place 合法移动会联动更新：
  - `position`
  - `occupied_cells`
  - Place 主 `interaction_cell`
  - 顶层 `interaction_cells`
  - 随 place footprint 镜像的 `collision_cells`
- 移动采用 guarded candidate：先生成完整候选，再做 move overlap 检查和 `MapEditorSyncService.export_to_dictionary()` 合同验证，通过后才替换 `editor_state` 与 marker 位置。
- 非法移动返回 `move_validation_failed` / `validation_failed`，并保留上一份有效候选。

## 验证

- `godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth005_place_move_linkage.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth001_validation_panel.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth002_write_back_service.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth003_place_marker_loop.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth004_anchor_protection.gd`
- `godot --headless --path . --script tests/test_town_map_authoring_export.gd`
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

全部通过。

## 状态

- `V02-MAPAUTH-005` 已完成。
- 下一项 Ready：`V02-MAPAUTH-006 回归与 runner 集成`。
- 无新增已验证教训。
