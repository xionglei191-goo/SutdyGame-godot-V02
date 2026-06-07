# Round123 V02.24 HOMEPLAZA-004 NPC routine 与广场到达感验收记录

> 日期：2026-06-07  
> 结论：已完成。下一项 Ready：`V02-HOMEPLAZA-005 回归、截图与收口`。

## 1. 范围

本轮只加固 NPC routine 的到达安全、fallback 和 Plaza 到达反馈。不扩 7 天内容批量，不改 HomeDecorationService 存档结构，不改 A-Z `anchor_id` / `letter` / `core_word` / `route_order` / `card_id` / 相册语义。

## 2. 交付物

- `scripts/systems/npc_routine_service.gd`：增加 world map arrival safety、protected anchor / interaction / place / collision 检查、blocked routine fallback、arrival zone 和温和 arrival text。
- `scripts/main.gd`：向 routine service 注入 world map context，保持 P0 NPC prompt 可达。
- `tests/test_v0224_npc_routine_arrival_safety.gd`：覆盖安全 Plaza routine、坏数据 fallback、缺失 routine fallback、Mina / Shopkeeper 可达 prompt、anchor / interaction arrival 拒绝和 plaza arrival count。
- `tests/headless_runner.gd`：注册 HOMEPLAZA-004 focused regression。

## 3. 验证

| 验证项 | 结果 |
|---|---|
| `godot --headless --path . --check-only --script scripts/systems/npc_routine_service.gd` | 通过 |
| `godot --headless --path . --check-only --script scripts/main.gd` | 通过 |
| `godot --headless --path . --check-only --script tests/headless_runner.gd` | 通过 |
| `godot --headless --path . --check-only --script tests/test_v0224_npc_routine_arrival_safety.gd` | 通过 |
| `godot --headless --path . --script tests/test_v0224_npc_routine_arrival_safety.gd` | 通过 |
| `godot --headless --path . --script tests/test_v0222_hidden_grid_life_systems.gd` | 通过 |
| `godot --headless --path . --script tests/test_v0221_livegate_hotspot_priority.gd` | 通过 |
| `godot --headless --path . --script tests/headless_runner.gd` | 通过 |
| `godot --headless --path . --quit` | 通过 |

## 4. 收口判断

`V02-HOMEPLAZA-004` 可收口。NPC routine 具备 safe arrival / fallback，不会因坏数据、anchor / interaction 覆盖或 routine 目标阻断 Mina / Shopkeeper 等 P0 入口。下一轮进入 `V02-HOMEPLAZA-005`，聚焦 living contract、outdoor decor rules、NPC routine safety、旧路径回归和 1280 proof。
