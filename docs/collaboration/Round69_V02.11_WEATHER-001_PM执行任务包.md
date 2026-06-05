# Round 69 V02.11 WEATHER-001 PM 执行任务包

> 日期：2026-06-05  
> Owner：PM / Game Design / Data Contract / Godot Dev / QA Agent  
> 状态：完成  
> 任务：`V02-WEATHER-001 天气轻事件数据合同与今日状态接入`

## 任务目标

将 `docs/14_内容基线整理与首批内容规划.md` 中已规划的 P0 天气轻事件推进到运行时数据合同和孩子端今日状态显示。首轮只做晴天、微风、雨后、小雨四类 P0 氛围事件的数据化、校验和 HUD 可见短句，不做真实天气联网、节日运营页、倒计时或奖励墙。

## 输入

- `docs/14_内容基线整理与首批内容规划.md` 的 `V02-DESIGN-005 节日与天气轻事件规划`。
- V02.9 的 `today_status` / `TodayStatusService` / 商店轮换数据合同。
- `LESSON-008`：内容生产必须先过合同验证。
- `LESSON-009`：孩子端可玩必须有真实可见入口。
- `LESSON-010`：截图和逻辑回归工具链要分离。

## 交付物

- 天气轻事件 JSON 数据或在现有 `today_status` 中明确引用的事件结构。
- Loader / service / validator 对 P0 天气事件字段的检查。
- 至少 4 个本地 day_key 能加载不同天气事件，并在 HUD 今日状态显示温和短句。
- Focused contract test 与 `tests/headless_runner.gd` 注册。
- `todo.md` 完成记录和 `lessons.md` 轮次复盘。

## 验收标准

- `event_weather_sunny_soft_001`、`event_weather_breezy_kite_001`、`event_weather_after_rain_001`、`event_weather_light_rain_001` 均有稳定 ID、P0 优先级、天气标签、今日状态文案、儿童安全说明。
- 今日状态文案必须短、温和、移动端 HUD 可读。
- 不出现倒计时、剩余、错过、补签、连续、必须、失败、奖励翻倍、排名、真实危险天气压力。
- 不阻断 Home、Shop、小屋、Mina 日常、相册或 A-Z anchor 回访。
- 不接真实天气 API，不依赖真实日期，不引入联网权限。

## 不做范围

- 不做雨滴、风动效、节日旗帜等新美术特效。
- 不做 P1 集市、故事安静日、家园整理日或 P2 儿童节 / 小镇庆祝日。
- 不改 P0 常驻商品，不制造限时购买或售罄焦虑。
- 不把天气事件变成课程、打卡、背诵或测试。

## 执行结果

- 已新增 `data/life/weather_events.json`，包含晴天、微风、雨后、小雨四个 P0 天气轻事件。
- 已在 `data/life/today_status.json` 为 7 个本地 `day_key` 增加 `weather_event_id` 引用，至少 4 个 day_key 覆盖四类 P0 天气事件。
- `TodayStatusService` 已加载天气事件并输出 `weather_event_id`、`weather_event`、`today_status_text` 和包含天气短句的 `hud_text`。
- `ContentContractValidator` 已检查 required P0 weather event、天气标签、P0 优先级、儿童安全文本和 `today_status` 引用。
- `tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd` 和 `tests/headless_runner.gd` 已覆盖天气合同与 HUD 可见短句。

## 验证记录

- `find data -name '*.json' -print0 | xargs -0 jq empty`：通过。
- `godot --headless --path . --check-only --script scripts/systems/today_status_service.gd`：通过。
- `godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd`：通过。
- `godot --headless --path . --script tests/test_daily_town_services.gd`：通过。
- `godot --headless --path . --script tests/test_v024_content_contracts.gd`：通过。
- `godot --headless --path . --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --quit`：通过。
