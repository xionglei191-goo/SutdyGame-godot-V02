# Round130 V02.25 MAPAUTH-006 回归与 runner 集成

日期：2026-06-07

## 范围

- 收口 `V02-MAPAUTH-006 回归与 runner 集成`。
- 验证 V02.25 地图 Authoring 工具实用化完整链路：
  - authoring export
  - write-if-valid
  - invalid data no-write
  - A-Z runtime 不退化
  - map readability 不退化
  - full runner 集成

## 交付

- `tests/test_town_map_authoring_export.gd` 改用 `move_place_marker_candidate()` guarded move，覆盖 linked interaction / collision、26 A-Z 和 runtime JSON 不变。
- 新增 `tests/test_v0225_mapauth006_regression_pack.gd`。
- `tests/headless_runner.gd` 注册 MAPAUTH-006 focused test，并增加 runner 内联 regression check。

## 验证

- `godot --headless --path . --check-only --script tests/test_v0225_mapauth006_regression_pack.gd`
- `godot --headless --path . --script tests/test_town_map_authoring_export.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth006_regression_pack.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth001_validation_panel.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth002_write_back_service.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth003_place_marker_loop.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth004_anchor_protection.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth005_place_move_linkage.gd`
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

全部通过。

## 状态

- `V02-MAPAUTH-006` 已完成。
- V02.25 地图 Authoring 工具实用化阶段收口。
- 下一项 Ready：`V02-CONTENTBATCH-001 NPC routine 小批量`。
- 无新增已验证教训。
