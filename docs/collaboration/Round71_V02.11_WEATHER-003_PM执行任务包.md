# Round 71 V02.11 WEATHER-003 PM 执行任务包

> 日期：2026-06-05  
> Owner：Memory Palace / UI / Narrative / QA Agent  
> 状态：Ready  
> 任务：`V02-WEATHER-003 A-Z 天气相册线索`

## 任务目标

基于 `V02-WEATHER-001` 的天气事件合同和 `V02-WEATHER-002` 的天气问候 / 资源 / 商店轻变化，把 S Sun、K Kite、B Bear、U Umbrella 等天气环境线索接入相册或 card state。天气只作为小镇环境记忆线索，不变成打卡、顺序拜访、课程、答题或等级评价。

## 输入

- `data/life/weather_events.json` 的四个 P0 天气事件。
- `data/life/today_status.json` 的 `weather_event_id` 与 day_key 绑定。
- `data/anchors/new_word_revisit_paths.json`、`data/cards/az_core_cards.json`、A-Z core anchor 数据。
- `scripts/main.gd` 的 anchor / P1 return entry 可见 `看看` 路径和相册落账方式。
- `tests/test_v023_memory_palace_world.gd`、`tests/test_v0210_p1_return_entries.gd`、`tests/headless_runner.gd`。
- `LESSON-008`：内容生产必须先过合同验证。
- `LESSON-009`：孩子端可玩必须有真实可见入口。
- `LESSON-010`：截图和逻辑回归工具链要分离。

## 交付物

- S Sun、K Kite、B Bear、U Umbrella 等天气环境线索的数据绑定或相册记录。
- 至少晴天、微风、雨后、小雨四类天气事件各能落到一个温和 A-Z 天气线索。
- 孩子端真实 `看看` 路径或已有可见入口触发 card state / 相册记录。
- Focused tests 与必要的 `headless_runner` 集成断言。
- `todo.md` 完成记录和 `lessons.md` 轮次复盘。

## 验收标准

- 记录只表达地点故事、环境词和温和反馈；不显示正确率、等级、课程、背诵、测试、评分或顺序拜访。
- 不改变 26 个 A-Z anchor 的位置、`route_order`、核心 ID 或世界结构。
- 不接真实天气 API，不依赖真实日期，不引入联网权限。
- 不阻断 Home、Shop、小屋、Mina 日常、相册或既有 A-Z anchor 回访。
- 相册 / card state 必须从孩子端真实可见路径证明落账，不能只靠脚本直调或隐藏 contract 按钮。

## 不做范围

- 不做新天气动效、粒子、截图验收或双视口截图；这些留给 `V02-WEATHER-004`。
- 不新增 P1 集市、P2 节日或运营活动。
- 不把天气线索变成奖励墙、任务链、打卡链或学习测验。
