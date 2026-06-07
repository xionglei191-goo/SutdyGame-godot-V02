# Round122 V02.24 HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则验收记录

> 日期：2026-06-07
> 对应任务：`V02-HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则`
> 结论：已完成。下一项 Ready：`V02-HOMEPLAZA-004 NPC routine 与广场到达感`。

## 1. 范围

本轮只加固 Town Plaza 的可停留感和户外装饰安全规则，不改变 A-Z anchor ID、letter、core_word、route_order、card_id 或相册语义。

实现内容：

- `OutdoorDecorationService` 新增 plaza-side allowed zones、item footprint、protected target 检查和 allowed-place summary。
- 禁止户外装饰覆盖 core anchor、place / interaction、resource、NPC 和已摆物件 footprint。
- `TownStage` 新增 `PlazaChatStool`、`PlazaSnackCrate` 两个非交互停留点。
- `TownStage.get_expapproval_snapshot()` 输出 `plaza_stay_point_count`、`plaza_stay_point_names` 和 `outdoor_decor_count`。
- 新增 `tests/test_v0224_town_plaza_outdoor_decor_rules.gd` 并注册 `tests/headless_runner.gd`。

## 2. 禁改边界复核

- 26 个 A-Z anchor 保持不变。
- 户外装饰只使用隐藏 cell / footprint 规则，孩子端不显示格子、坐标、占格、footprint 或 debug 术语。
- 旧 V02.22 outdoor decor 可摆 / 挪 / 收路径保持可用。
- 本轮不做 product complete 或新的 approved 判定。

## 3. 验证

已通过：

```bash
godot --headless --path . --check-only --script scripts/systems/outdoor_decoration_service.gd
godot --headless --path . --check-only --script scripts/stages/town_stage.gd
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --check-only --script tests/headless_runner.gd
godot --headless --path . --script tests/test_v0224_town_plaza_outdoor_decor_rules.gd
godot --headless --path . --script tests/test_v0222_hidden_grid_life_systems.gd
godot --headless --path . --script tests/test_v0223_expapproval_town_plaza_density.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## 4. 后续输入

`V02-HOMEPLAZA-004` 进入 Ready。下一轮应聚焦 NPC routine 与广场到达感，保持 routine fallback，不因装饰、天气或 routine 阻断 Mina / Shopkeeper / Sunny 等 P0 入口。
