# Round127 V02.25 MAPAUTH-003 Place marker 新增 / 删除最小闭环

> 日期：2026-06-07
> 状态：已完成
> 下一项 Ready：`V02-MAPAUTH-004 A-Z anchor 删除保护与编辑限制`

## 范围

- 本轮只推进 `TownMapAuthoring` 的 Place marker candidate 新增 / 删除闭环。
- `TownMapAuthoring` 仍只生成候选 dictionary，不直接写 `data/maps/world_map.json`。
- 写回仍必须经由 `MapEditorSyncService` 的 validate / write-if-valid 双阶段流程。
- runtime 仍以 `data/maps/world_map.json` 为事实来源。

## 实现

- `scripts/editor/town_map_authoring.gd`
  - 新增 `add_place_marker_candidate()`。
  - 新增 `delete_place_marker_candidate()`。
  - 新增 `get_authoring_place_summary()`。
  - 新增 place candidate 时同步加入 place marker 和对应 `interaction_cells`。
  - 删除 place candidate 时同步移除 marker 和对应 `interaction_cells`。
  - 删除仍被 A-Z anchor 引用的 place 时返回 `place_has_anchors`，不修改候选数据。

- `tests/test_v0225_mapauth003_place_marker_loop.gd`
  - 覆盖新增合法 place candidate。
  - 覆盖重复 place ID 拒绝。
  - 覆盖候选通过 `MapEditorSyncService.export_authoring_scene()` 合同验证。
  - 覆盖 26 个 A-Z anchor 保持。
  - 覆盖 anchor-owned place 删除保护。
  - 覆盖删除新增 place candidate 后 interaction 清理。
  - 覆盖整个 add / validate / delete loop 不改 `world_map.json` 原文。

- `tests/headless_runner.gd`
  - 注册 MAPAUTH-003 focused test preload。
  - 增加 `_check_v0225_mapauth003_place_marker_loop()` 集成断言。

## 验证

- `godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`
- `godot --headless --path . --check-only --script tests/test_v0225_mapauth003_place_marker_loop.gd`
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth003_place_marker_loop.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth001_validation_panel.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth002_write_back_service.gd`
- `godot --headless --path . --script tests/test_town_map_authoring_export.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`
- `godot --headless --path . --quit`

说明：曾先运行旧文件名 `tests/test_v0217_world_map_runtime.gd`，该文件不存在；已改跑当前文件 `tests/test_v0217_worldmap_anchor_runtime.gd` 并通过。

## 收口

- `todo.md` 已同步当前状态面板、本轮分工、正式任务列表和完成记录。
- `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 已同步 Round127 完成事实。
- `lessons.md` 记录 Round127 无新增已验证教训。

## 下一轮注意

- `V02-MAPAUTH-004` 需要围绕 A-Z anchor 删除保护和关键字段编辑限制展开。
- 继续保持 26 A-Z anchor、`anchor_id`、`core_word`、`route_order` 和相册语义不退化。
- 不要让 authoring 层直接写 runtime JSON。
