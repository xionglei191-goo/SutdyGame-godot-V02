# Round131 V02.26 CONTENTBATCH-001 NPC routine 小批量

日期：2026-06-07

## 范围

- 收口 `V02-CONTENTBATCH-001 NPC routine 小批量`。
- 内容范围控制为 7 天 NPC routine 轻变化。
- 不改 A-Z ID / route_order，不改存档结构，不制造赶路、迟到、错过、值班或每日必须压力。

## 交付

- `data/life/npc_routines.json` 扩展为 `local_day_001` 至 `local_day_007`。
- 每天覆盖五位居民：
  - Mina
  - Shopkeeper
  - Sunny / `pet_buddy`
  - Bus Helper
  - Story Bear
- 新增 `tests/test_v026_contentbatch001_npc_routine_batch.gd`。
- `tests/headless_runner.gd` 注册 CONTENTBATCH-001 focused test，并加入 day 7 runtime snapshot / Mina prompt 回归。
- 调整 runner 中旧 V02.22 routine 断言：默认数据补齐后不再要求 fallback_count >= 1，而是要求 routine snapshot 可用且默认 routine 不 blocked。

## 验证

- `godot --headless --path . --check-only --script scripts/systems/npc_routine_service.gd`
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/test_v026_contentbatch001_npc_routine_batch.gd`
- `godot --headless --path . --script tests/test_v0224_npc_routine_arrival_safety.gd`
- `godot --headless --path . --script tests/test_v024_content_contracts.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

全部通过。

## 状态

- `V02-CONTENTBATCH-001` 已完成。
- 下一项 Ready：`V02-CONTENTBATCH-002 资源刷新点小批量`。
- 无新增已验证教训。
