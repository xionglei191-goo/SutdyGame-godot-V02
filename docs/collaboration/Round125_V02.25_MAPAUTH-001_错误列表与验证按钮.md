# Round125 V02.25 MAPAUTH-001 错误列表与验证按钮

> 日期：2026-06-07  
> 结论：已完成。下一项 Ready：`V02-MAPAUTH-002 安全写回 JSON 服务`。

## 1. 范围

本轮只做 authoring 候选地图的错误列表与验证按钮。`TownMapAuthoring` 仍只生成候选 dictionary；验证不写回 `data/maps/world_map.json`。安全写回、临时文件、备份和失败保护留给 `V02-MAPAUTH-002`。

## 2. 交付物

- `scenes/map_editor/town_map_authoring.tscn`：`ExportValidationPanel` 增加 `ValidateExportButton`、`ValidationStatusLabel` 和 `ValidationErrorsLabel`。
- `scripts/editor/town_map_authoring.gd`：新增 `validate_export_candidate()`、`get_validation_summary()` 和 panel 刷新逻辑；调用 `MapEditorSyncService.export_authoring_scene()` 校验候选 dictionary，并返回 `wrote_file=false`。
- `tests/test_v0225_mapauth001_validation_panel.gd`：覆盖有效候选、非法候选错误列表和 `world_map.json` 不写回。
- `tests/headless_runner.gd`：注册 MAPAUTH-001 runner gate。

## 3. 验证

| 验证项 | 结果 |
|---|---|
| `godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd` | 通过 |
| `godot --headless --path . --check-only --script tests/test_v0225_mapauth001_validation_panel.gd` | 通过 |
| `godot --headless --path . --check-only --script tests/headless_runner.gd` | 通过 |
| `godot --headless --path . --script tests/test_v0225_mapauth001_validation_panel.gd` | 通过 |
| `godot --headless --path . --script tests/test_town_map_authoring_export.gd` | 通过 |
| `godot --headless --path . --script tests/headless_runner.gd` | 通过 |
| `godot --headless --path . --quit` | 通过 |

## 4. 收口判断

`V02-MAPAUTH-001` 可收口。Authoring 层可见验证按钮和错误列表成立；有效候选显示无错误，非法候选显示合同错误，且验证过程不写回 JSON。下一轮进入 `V02-MAPAUTH-002`，实现合法才写、非法不写、失败不毁文件。
