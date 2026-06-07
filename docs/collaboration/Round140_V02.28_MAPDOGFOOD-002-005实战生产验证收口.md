# Round140 V02.28 MAPDOGFOOD-002-005 实战生产验证收口

> 日期：2026-06-07
> 对应任务：`V02-MAPDOGFOOD-002` 至 `V02-MAPDOGFOOD-005`

## 结论

V02.28 Map Editor dogfood 已完成。正式内容改动来自场景内 `TownMapAuthoring` 候选 state、Validate、`MapEditorSyncService` 安全写回和 post-load verify，不用手工 JSON 修改冒充生产。

本轮证明 Map Editor 已能支撑小批量真实内容生产，但仍不标 `product complete`；960x540 适配继续保留到版本适配专项。

## 生产改动

| 类型 | ID | 改动 |
|---|---|---|
| Place | `place_plaza_story_bench` | 新增 Story Bench，位置 `12,19`，交互 `12,20`，`place_action=open_town_start` |
| Place | `place_shop_ribbon_corner` | 新增 Ribbon Corner，位置 `49,12`，交互 `49,13`，`place_action=open_town_start` |
| Resource | `resource_ribbon_shop_street` | 移动到 `50,14`，保留 `item_id=ribbon` 和每日软刷新 |
| NPC routine | `routine_shopkeeper_shop_003` | `local_day_003` 移动到 `43,14`，文案改为店长在 Ribbon Corner 旁整理小篮子 |

## Dogfood 发现与修复

- 首次尝试新增 Place 使用了不在合同内的 `place_type=landmark`，Map Editor validate 拒绝写回，证明合同保护有效。
- 新增 Place 默认 `place_action=look`，孩子端 runtime 不支持该动作。本轮补齐 `TownMapAuthoring` 的 Place Inspector `place_action` 编辑，并在 action 变更时同步对应 `interaction_cells.action`。
- 安全写回会生成 `.bak` 备份；正式交付不保留未跟踪备份文件，避免误认为内容资产。

## 孩子端复核

`tests/test_v028_mapdogfood_production.gd` 覆盖：

- Story Bench 和 Ribbon Corner 从真实移动后的 `看看` / place entry 路径可触发。
- moved ribbon resource 在 `50,14` 可采集，结果仍为 `item_id=ribbon`。
- Shopkeeper 在 `local_day_003` 的 moved routine cell 可 prompt 并互动。
- 可见 UI 文本不出现课程、测试、分数、倒计时、坐标、格子、调试或 `debug` 等术语。
- 26 个 A-Z anchor 保持完整，`letter`、`route_order`、`anchor_id`、`core_word` 不退化。

## 内容生产手册

1. 打开 `scenes/map_editor/town_map_authoring.tscn`，只在场景内编辑器操作候选 state。
2. Place：选择或新增 Place，编辑 `label`、`district_id`、`place_type`、`place_action`、size，再拖动 marker。新增可玩 Place 必须确认 `place_action` 是孩子端支持动作，并让 interaction action 同步。
3. Resource：选择 resource marker，编辑 `display_name`、`item_id`、`quantity`，拖动到目标 cell；`item_id` 必须存在于 `data/items/life_items.json`。
4. NPC routine：选择 day key，再选择 NPC routine marker，编辑 `label` 并拖动到目标 cell；routine cell 必须通过 arrival safety。
5. 保存前必须依次 Validate Map / Resources / Routines。任一验证失败时不得保存。
6. 保存必须走 `save_map_candidate()`、`save_resources_candidate()`、`save_routines_candidate()` 对应分文件路径，不把 resource 或 routine 写入 `world_map.json`。
7. 写回后运行 focused test、full runner、Godot 启动和 1280 proof；`.tmp` / 未跟踪 `.bak` 不作为正式交付。

## 永久禁改字段

A-Z core anchor 的 `anchor_id`、`letter`、`core_word`、`route_order`、`place_id`、`card_id`、`audio_id` 和相册语义继续永久锁定。移动 A-Z 位置必须进入 Move A-Z 专门模式，并保留 26 个 anchor 顺序与故事绑定。

## 1280 Proof

本轮曾用非 headless Godot 运行时导出并复核四张 1280x720 proof，覆盖 Story Bench、Ribbon Corner、moved ribbon resource 和 moved Shopkeeper routine。按本次仓库清理要求，临时 PNG 截图包与一次性 capture 脚本不入库；保留 focused / runner / Godot 启动验证作为可重复回归证据。

## 验证

已通过：

- `godot --headless --path . --script tests/test_v028_mapdogfood_production.gd`
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`
- `git diff --check`
- 非 headless 1280 proof 曾导出并复核；临时截图文件已按仓库清理要求移除
