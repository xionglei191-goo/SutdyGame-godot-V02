# Round 77 V02.13 TEXTBOOK-001 至 005 验收记录

> 结论：`pass`  
> 范围：全量课本内容世界化主线策划，数据可加载，不接入 runtime。

## 交付物

- `curriculum/小学英语重点分析/三年级上册.txt`：新增三上结构化摘要和公开来源记录。
- `data/curriculum/textbook_world_plan.json`：新增 8 册 source ledger、85 个单元摘要、世界映射和主线分层。
- `scripts/data/textbook_world_contract.gd`：新增 V02.13 合同验证器。
- `tests/test_v0213_textbook_world_plan.gd`：新增 focused contract test。
- `tests/headless_runner.gd`：注册 `_check_v0213_textbook_world_plan()`。

## 验收结果

- 8 册来源齐备，覆盖三上、三下、四上、四下、五上、五下、六上、六下。
- 85 个单元摘要齐备：三上 10、三下 10、四上 10、四下 10、五上 12、五下 12、六上 12、六下 9。
- P0 世界映射集中在 Home、Home-School Walk、School Gate、School Yard、Shop 和 Sunny 角落。
- P1/P2 仅作为 Bookshop、Garden、Bus Stop、Clothes Shop、Park、Theatre、Music Corner 和 Far Edge 预留。
- 合同可拒绝缺册、P0 far edge 依赖和孩子端压力文案。

## 后续建议

下一阶段可进入 `V02.14 Home / School P0 课本世界化可玩纵切`，从 `seg_p0_home_morning_foundation` 和 `seg_p0_home_school_walk` 中选择最小可玩路径；仍不得新增课程页、单元门、测试或背诵入口。
