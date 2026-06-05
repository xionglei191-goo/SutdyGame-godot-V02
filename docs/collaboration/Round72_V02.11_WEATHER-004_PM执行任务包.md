# Round 72 V02.11 WEATHER-004 PM 执行任务包

> 日期：2026-06-05  
> Owner：QA / PM / Godot Dev Agent  
> 状态：Ready  
> 任务：`V02-WEATHER-004 天气纵切 smoke 与双视口截图`

## 任务目标

基于 `V02-WEATHER-001` 至 `V02-WEATHER-003` 的天气数据、问候 / 资源 / 商店轻变化和 A-Z 天气相册线索，完成多天气 day_key 的玩家路径 smoke 与代表截图验收。天气仍然只是 Sunshine Town 的温和氛围变化，不变成打卡、限时运营、连续登录、顺序拜访、答题、评分或奖励墙。

## 输入

- `data/life/weather_events.json` 的四个 P0 天气事件与 `album_clues`。
- `data/life/today_status.json` 的 7 个本地 day_key 与 `weather_event_id`。
- `scripts/main.gd` 的今日状态 HUD、资源 / 商店 / 相册 / A-Z 可见 `看看` 路径。
- `tests/test_v023_memory_palace_world.gd` 的 S Sun、K Kite、B Bear、U Umbrella 天气相册落账覆盖。
- `tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`tests/test_life_services.gd`、`tests/headless_runner.gd`。
- `LESSON-009`：孩子端可玩必须有真实可见入口。
- `LESSON-010`：截图验收不要依赖 headless dummy renderer。

## 交付物

- 多天气 day_key 玩家路径 smoke，至少覆盖晴天、微风、雨后、小雨四类天气状态。
- 必要的 focused test 与 `tests/headless_runner.gd` 集成断言。
- 1280x720 与 960x540 代表截图，建议覆盖 Today HUD、Town Plaza / Kite、Bookshop / Bear Corner、Shop / Home 或相册路径。
- `docs/collaboration/Round72_V02.11_WEATHER-004验收记录.md` 与截图目录。
- `todo.md` 完成记录和 `lessons.md` 轮次复盘。

## 验收标准

- 多天气状态在 HUD 可见，且 P0 Home / Shop / 小屋 / Mina / 相册 / A-Z 路径不阻断。
- S Sun、K Kite、B Bear、U Umbrella 天气线索仍可从真实可见 `看看` 路径落账。
- P0 常驻商品不消失，基础资源可得性不因天气减少，Mina 日常仍能完成。
- 截图无明显遮挡、文字溢出、工程文案、课程化文案、倒计时、错过、补签、连续登录或运营压力。
- 截图取证按 `LESSON-010` 使用 MCP 或非 headless 显示路径；headless 只作为逻辑和合同回归。

## 不做范围

- 不新增天气粒子、真实天气 API、联网权限、运营活动或节日奖励墙。
- 不把天气线索变成顺序拜访、任务链、学习测验或相册评分。
- 不重排 26 个 A-Z anchor，不改变核心 ID、位置、`route_order` 或世界结构。
