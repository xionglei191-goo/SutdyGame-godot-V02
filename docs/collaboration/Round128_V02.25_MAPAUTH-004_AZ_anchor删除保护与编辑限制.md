# Round128 V02.25 MAPAUTH-004 A-Z anchor 删除保护与编辑限制

> 日期：2026-06-07
> 状态：已完成
> 下一项 Ready：`V02-MAPAUTH-005 Place 移动联动策略`

## 范围

- 本轮只处理 A-Z anchor 的删除保护和关键字段编辑限制。
- `TownMapAuthoring` 仍只生成候选 dictionary。
- runtime 仍读取 `data/maps/world_map.json`。
- 不处理 Place move 的 occupied / interaction 联动；该范围留给 `V02-MAPAUTH-005`。

## Agent 审阅

本轮调用子 agent Sartre 做只读边界审阅。审阅结论：

- A-Z core anchor 删除必须返回明确拒绝，不得改 `editor_state.memory_anchors` 或 marker layer。
- 核心字段应锁定：`anchor_id`、`letter`、`core_word`、`route_order`、`place_id`，并建议保留 `card_id` / `audio_id` 稳定。
- `WorldMapContract` 会拦截部分错误，但 focused test 仍必须直接证明 26 A-Z 不退化。
- 如果 marker position 仍可移动，测试应证明只有 `position` 改变，identity / encoding 字段不变。

## 实现

- `scripts/editor/town_map_authoring.gd`
  - 新增 `delete_anchor_marker_candidate()`。
  - 新增 `edit_anchor_field_candidate()`。
  - 新增 `get_authoring_anchor_summary()`。
  - 26 个 A-Z anchor 被识别为 protected core anchor。
  - 删除 core anchor 返回 `protected_core_anchor`。
  - 未知 anchor 删除返回 `unknown_anchor_id`。
  - `anchor_id`、`letter`、`core_word`、`route_order`、`place_id`、`card_id`、`audio_id` 编辑返回 `anchor_field_locked`。
  - marker position candidate 仍可通过既有 marker 移动路径改变，用于后续 MAPAUTH-005 联动策略。

- `tests/test_v0225_mapauth004_anchor_protection.gd`
  - 覆盖 26 个 A-Z anchor 初始存在并全部 protected。
  - 覆盖删除 `anchor_a_apple` 被拒绝且 marker 保留。
  - 覆盖未知 anchor 删除拒绝。
  - 覆盖关键字段编辑全部被拒绝。
  - 覆盖 anchor marker position candidate 移动后 locked fields 不变。
  - 覆盖导出仍有 26 anchors、A-Z route order 不变、validation 不写 JSON。

- `tests/headless_runner.gd`
  - 注册 MAPAUTH-004 focused test preload。
  - 增加 `_check_v0225_mapauth004_anchor_protection()`。

## 验证

- `godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`
- `godot --headless --path . --check-only --script tests/test_v0225_mapauth004_anchor_protection.gd`
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth004_anchor_protection.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth003_place_marker_loop.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth002_write_back_service.gd`
- `godot --headless --path . --script tests/test_v0225_mapauth001_validation_panel.gd`
- `godot --headless --path . --script tests/test_town_map_authoring_export.gd`
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

## 收口

- `todo.md` 已同步当前状态面板、本轮分工、正式任务列表和完成记录。
- `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 已同步 Round128 完成事实。
- `lessons.md` 记录 Round128 无新增已验证教训。

## 下一轮注意

- `V02-MAPAUTH-005` 应处理 Place marker 移动后的 `position`、`occupied_cells`、`interaction_cell` 和 `interaction_cells` 联动策略。
- 继续保持 `TownMapAuthoring` candidate-only，写回只能经 `MapEditorSyncService`。
- Place 移动不得破坏 existing place / anchor / road / interaction 合同。
