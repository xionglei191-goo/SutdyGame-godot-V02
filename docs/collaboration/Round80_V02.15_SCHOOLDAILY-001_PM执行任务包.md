# Round 80 V02.15 SCHOOLDAILY-001 PM 执行任务包

> 日期：2026-06-05
> Owner：PM / Game Design / Narrative / QA
> 当前任务：`V02-SCHOOLDAILY-001 Home / School 日常回访路线与任务拆分`
> 下一轮唯一 Ready：`V02-SCHOOLDAILY-002 School Day State Contract 数据化`

## 1. 背景

V02.14 已经把第一条 Home / School P0 路线做成孩子端真实可见的生活路线：

```text
Home morning
  -> Home-School Walk
  -> School Gate / School Yard
  -> Return / Sunny story
```

V02.15 的目标不是新增课程系统，而是把这条路线变成日常可回访的轻循环。差异来自 7 个本地 day_key、天气、校门问候、操场小发现、上学路环境线索和回家 Sunny 反馈；孩子端仍通过移动、`看看`、相册和小屋反馈自然触发。

## 2. V02.15 任务队列

| 顺序 | Task ID | Owner | 交付物 | 验收 |
|---|---|---|---|---|
| 1 | V02-SCHOOLDAILY-001 | PM / Game Design / Narrative / QA | V02.15 路线、7 天差异维度、任务拆分、PM 任务包和 Ready 队列 | `docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步；下一轮唯一 Ready 明确 |
| 2 | V02-SCHOOLDAILY-002 | Data Contract / Godot Dev / QA | School day state JSON、loader / service、合同测试 | 7 个 day_key 可加载；字段绑定 gate / yard / walk / return；儿童安全禁词拦截 |
| 3 | V02-SCHOOLDAILY-003 | Narrative / Godot Dev / Memory Palace / QA | School Gate / Yard 每日可见差异、A-Z 记录和 focused test | 从真实可见 `看看` 触发；学校像生活地点，不出现课堂或考试 |
| 4 | V02-SCHOOLDAILY-004 | Home Design / Narrative / Godot Dev / QA | Home Return / Sunny 日常回访反馈和保存记录 | 回家反馈温暖、可保存、不变成学习总结或家长报告 |
| 5 | V02-SCHOOLDAILY-005 | QA / PM / Godot Dev | 7 天学校生活 smoke、headless runner 注册和代表截图 | 7 天 Home -> Walk -> School -> Return 均可玩，不阻断旧日常闭环 |

## 3. 7 天差异维度

| 维度 | 可见入口 | A-Z / 记忆宫殿绑定 | 验收重点 |
|---|---|---|---|
| School Gate greeting | School Gate 附近按 `看看` | G Gate、E Elephant | 校门是温和入口，不是迟到、门禁或答题门 |
| School Yard discovery | School Yard / 操场网 / robot 角按 `看看` | N Net、K Kite、R Robot、Y Yo-yo、E Elephant | 操场是生活地点，不做课堂、考试、排名或速度挑战 |
| Home-School Walk variation | Home-School Walk 路牌 / 花丛 / 天空按 `看看` | G Gate、K Kite、S Sun、W Watch | 小路可走可回，不写独自远行、赶路或倒计时 |
| Home Return story | 回 Home / Sunny 角落按 `看看` | D Dog、A Apple、O Orange、C Clock | 回家反馈不是学习总结，也不是家长报告 |

## 4. V02-SCHOOLDAILY-002 开工说明

下一轮只做 School Day State Contract 数据化，不直接接运行时 UI。

建议输入：

- `data/life/homeschool_events.json`
- `data/life/today_status.json`
- `data/maps/world_map.json`
- `data/maps/az_world_plan.json`
- `data/curriculum/textbook_world_plan.json`
- `scripts/systems/today_status_service.gd`
- `scripts/systems/content_contract_validator.gd`
- `tests/test_daily_town_services.gd`
- `tests/test_v0214_homeschool_slice.gd`
- `LESSON-008`、`LESSON-009`、`LESSON-010`

最小交付：

- 新增 `data/life/school_day_states.json` 或同等稳定数据源。
- 7 个 `local_day_001` 至 `local_day_007` 均有 gate / yard / walk / return 四类内容引用或短文本。
- 每条内容绑定 `stage`、`place_id`、`anchor_ids`、`environment_words`、`child_facing_text`、`safety_note`。
- 新增 loader / service 或复用现有服务时，保持显式 `Dictionary` 类型标注。
- focused contract test 证明 7 天可加载、ID 唯一、anchor 存在、禁词被拦截。
- 不接孩子端课程页、不改 V02.14 `homeschool_events` 语义、不移动核心 anchor。

## 5. 禁用范围

- 不做课程表、上课铃倒计时、作业本、练习题、听写、背诵、测验、考试、分数、正确率或等级。
- 不把校门写成封锁、迟到惩罚、资格检查或答题门。
- 不把操场写成排名、速度挑战、危险攀爬或必须完成的活动。
- 不让 Bookshop、Bus Stop、Park、Theatre、Music Corner、Far Edge 进入 V02.15 P0 硬依赖。
- 不覆盖 V02.14 已有 `homeschool_events`，新增日常状态应作为可扩展层，避免破坏旧 smoke。

## 6. 验收命令建议

V02-SCHOOLDAILY-001 为 PM 文档任务，收口建议运行：

```bash
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

V02-SCHOOLDAILY-002 起涉及数据合同，应增加 JSON 校验、touched script `check-only`、focused contract test 和 headless runner 注册。
