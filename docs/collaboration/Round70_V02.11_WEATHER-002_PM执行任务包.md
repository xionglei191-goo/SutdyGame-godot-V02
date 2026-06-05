# Round 70 V02.11 WEATHER-002 PM 执行任务包

> 日期：2026-06-05  
> Owner：Narrative / Economy / Godot Dev / QA Agent  
> 状态：完成  
> 任务：`V02-WEATHER-002 NPC 问候与资源 / 商店轻变化`

## 任务目标

基于 `V02-WEATHER-001` 已建立的 `weather_event_id` 合同，把天气轻事件接入 NPC 问候变体、资源点温和提示和商店活动角引用。目标是让晴天、微风、雨后、小雨成为孩子能感到的小镇氛围，而不是限时任务、运营活动、真实天气系统或奖励压力。

## 输入

- `data/life/weather_events.json` 的四个 P0 天气事件。
- `data/life/today_status.json` 的 `weather_event_id` 引用。
- `data/life/daily_greetings.json`、`data/life/daily_requests.json`、`data/items/life_items.json`。
- `scripts/systems/today_status_service.gd`、`scripts/systems/content_contract_validator.gd`。
- `LESSON-008`：内容生产必须先过合同验证。
- `LESSON-009`：孩子端可玩必须有真实可见入口。
- `LESSON-010`：截图和逻辑回归工具链要分离。

## 交付物

- 天气事件驱动的 NPC 问候变体引用或数据结构，优先覆盖 Mina、店长、Sunny、故事熊、巴士哥哥。
- 资源提示 / 权重轻变化数据或服务输出，必须保持 P0 基础资源可得性。
- 商店活动角引用，必须不覆盖 `wooden_chair` 等 P0 常驻商品。
- Focused tests 与必要的 `headless_runner` 集成断言。
- `todo.md` 完成记录和 `lessons.md` 轮次复盘。

## 验收标准

- 四个 P0 天气事件均至少能影响一类温和 NPC 问候、资源提示或商店活动角说明。
- P0 常驻商品不消失；买不起、没购买或未互动都不会失败。
- 资源不会因天气减少基础可得性；天气只做视觉提示、轻权重或文案变化。
- 所有文案短、温和、生活化，不出现倒计时、剩余、错过、补签、连续、必须、失败、奖励翻倍、排名、售罄焦虑、危险天气或真实出行压力。
- 不接真实天气 API，不依赖真实日期，不引入联网权限。
- 不阻断 Home、Shop、小屋、Mina 日常、相册或 A-Z anchor 回访。

## 不做范围

- 不做新雨滴、风动效、天气粒子或新美术特效。
- 不做 P1 集市、家园整理日、P2 儿童节或小镇庆祝日。
- 不把天气变成每日任务、打卡链、奖励墙或课程内容。
- 不改 A-Z anchor 位置、route_order 或核心记忆编码。

## 执行结果

- `data/life/daily_greetings.json` 已新增 `weather_variants`，用稳定 `variant_id` 回连 `weather_events.npc_greeting_refs`。
- `DailyGreetingService` 已按本地 `day_key` / `weather_event_id` 返回天气问候变体，并输出 `weather_event_id`、`weather_tag` 和 `greeting_variant_id`。
- `data/life/resource_points.json` 已新增 `weather_hints`，`ResourceRefreshService` 只附加天气提示，不改变基础资源点、数量或同日采集规则。
- `data/items/life_items.json` 已为 7 天商店轮换新增 `weather_activity_corner`，`LifeShopService` 返回活动角说明但不替换 `offers`。
- `ContentContractValidator` 已验证天气问候引用、资源天气提示、商店活动角和 `wooden_chair` / P0 offer 保留。
- `tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`tests/test_life_services.gd` 和 `tests/headless_runner.gd` 已覆盖。

## 验证记录

- `find data -name '*.json' -print0 | xargs -0 jq empty`：通过。
- `godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd`：通过。
- `godot --headless --path . --check-only --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --script tests/test_v024_content_contracts.gd`：通过。
- `godot --headless --path . --script tests/test_daily_town_services.gd`：通过。
- `godot --headless --path . --script tests/test_life_services.gd`：通过。
- `godot --headless --path . --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --quit`：通过。
