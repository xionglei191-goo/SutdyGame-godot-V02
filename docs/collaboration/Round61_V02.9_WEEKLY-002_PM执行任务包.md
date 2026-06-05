# Round 61 V02.9 `WEEKLY-002` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-WEEKLY-001 一周回访内容合同与排期` 已完成。

## 本轮目标

把 V02.9 的 7 天回访排期落到可测试数据合同：`today_status` 按 7 个本地 `day_key` 稳定加载，商店提供 P0 常驻、P1 日常轮换和 P2 天气 / 节日轻变体，且不引入连续登录、倒计时、错过损失或强制购买。

## Owner

Godot Dev / Economy / QA Agent

## Scope

允许修改：

- `data/life/today_status.json`
- `data/items/life_items.json`
- `scripts/systems/today_status_service.gd`
- `scripts/systems/life_shop_service.gd`
- `scripts/systems/content_contract_validator.gd`
- focused tests and `tests/headless_runner.gd`
- `todo.md`
- `lessons.md`（仅当出现已验证新教训）

暂不修改：

- `scripts/main.gd`
- Bookshop / Bus Stop 运行时场景
- 新 NPC 运行时入口
- 真实天气系统、真实 AI、联网、账号或云存档

## Inputs

- `docs/14_内容基线整理与首批内容规划.md` 的 V02.9 一周回访节奏内容基线
- `data/life/today_status.json`
- `data/items/life_items.json`
- `tests/test_v024_content_contracts.gd`
- `tests/test_daily_town_services.gd`
- `LESSON-008`、`LESSON-009`

## Deliverables

- 7 天 `today_status` 数据，包含 `day_key`、weather、event、sunny_hint、primary_npc、anchor_hint 和 shop_rotation_id。
- 商店轮换数据，至少包含 P0 常驻商品、P1 每日轮换和 P2 天气 / 节日轻变体。
- `TodayStatusService` 支持按 `day_key` 稳定命中，未知 day_key 可温和 fallback。
- `LifeShopService` 支持读取轮换 offer，且 P0 常驻商品不消失。
- focused contract test 覆盖 7 天状态、商店轮换、P0 常驻、儿童安全文案和买不起不失败。

## Acceptance Criteria

- `local_day_001` 至 `local_day_007` 均可加载不同今日状态，并有 A-Z anchor 线索。
- 每一天的商店 offer 都包含至少 1 个 P0 常驻商品；P1/P2 可选但必须有稳定 `rotation_tier`。
- 买不起返回温和 `not_enough_coins`，不出现失败、倒计时、错过损失、排名或强制购买文案。
- 内容合同验证器能拦截缺失 day_key、重复 day_key、缺失 shop_rotation_id、非法 rotation_tier 和压力文案。
- 不修改主场景流程；本轮只做数据和服务合同。

## Required Validation

```bash
godot --headless --path . --script tests/test_v024_content_contracts.gd
godot --headless --path . --script tests/test_daily_town_services.gd
godot --headless --path . --script tests/test_life_services.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## Handoff Notes

完成后填写：

- 修改文件：`data/life/today_status.json`、`data/items/life_items.json`、`scripts/systems/today_status_service.gd`、`scripts/systems/life_shop_service.gd`、`scripts/systems/inventory_service.gd`、`scripts/systems/content_contract_validator.gd`、`tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`tests/test_life_services.gd`、`tests/headless_runner.gd`、`todo.md`、`lessons.md`。
- 新增内容：7 天稳定 `today_status` 合同、7 天 `shop_rotations`、按 day / rotation 读取商店 offer 的服务接口、内容合同验证器对 today status / shop rotation 的校验、focused 和 full runner 覆盖。
- 验证方式：`find data -name '*.json' -print0 | xargs -0 jq empty`、`godot --headless --path . --script tests/test_v024_content_contracts.gd`、`godot --headless --path . --script tests/test_daily_town_services.gd`、`godot --headless --path . --script tests/test_life_services.gd`、`godot --headless --path . --check-only --script scripts/systems/today_status_service.gd`、`godot --headless --path . --check-only --script scripts/systems/life_shop_service.gd`、`godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过。
- 风险：本轮仅完成数据 / 服务合同，主场景尚未显示每日轮换货架；`V02-WEEKLY-004` 前仍需操作级玩家路径和截图补验。Bookshop / Bus Stop 仍保持 P1 入口预收，不是主流程依赖。
- 待确认问题：无。PM 判断：`V02-WEEKLY-002` 可以标记完成，下一轮 Ready 为 `V02-WEEKLY-003 P1 居民回访入口预收`。
