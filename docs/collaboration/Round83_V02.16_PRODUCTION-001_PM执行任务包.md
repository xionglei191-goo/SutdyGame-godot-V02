# Round83 V02.16 PRODUCTION-001 PM 执行任务包

> 日期：2026-06-05
> 阶段：V02.16 可制作内容与体验抛光 / Playable RC Gate
> 当前任务：V02-PRODUCTION-001 V02.16 路线、试玩范围和发布门槛规划
> 下一轮唯一 Ready：V02-PRODUCTION-002 孩子端文案、反馈语气和禁用词统一审校

## 阶段目标

V02.16 的目标是把 V02.8-V02.15 已跑通的核心体验整理成 5-10 分钟可试玩 / 可制作版本门槛。范围固定为现有 P0/P1 内容的体验抛光、文本统一、美术截图复核和完整玩家路径验收。

本阶段不是新内容大扩展，不新增地图区域，不新增课程 UI，不把 Bookshop / Bus Stop 升为 P0，不改变 A-Z anchor 结构。

## 试玩范围

- 每日小镇：Mina、资源、Shop、Home、Sunny、小屋、相册。
- Home / School：Home-School Walk、School Gate、School Yard、Return Home。
- 天气与 P1：晴天 / 微风 / 小雨 / 雨后线索，Bookshop / Bus Stop 轻回访只作为 P1。
- UI / 设置：底栏、背包、商店、小屋、相册、设置入口和关闭路径。

## 任务队列

| Task ID | Owner | 交付物 | 验收 |
|---|---|---|---|
| V02-PRODUCTION-001 | PM / Game Design / Narrative / QA | V02.16 路线、试玩范围、发布门槛、Round83 PM 任务包和 Ready 队列 | `docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步；下一轮唯一 Ready 是 V02-PRODUCTION-002 |
| V02-PRODUCTION-002 | Narrative / UX / QA / Godot | 孩子端文案、反馈语气和禁用词统一审校；文本扫描测试扩展 | HUD、NPC、Sunny、Home / School、天气、P1、商店、小屋、相册均为温暖短句；禁用词不回流 |
| V02-PRODUCTION-003 | UX / Godot / QA | 核心操作动线抛光，覆盖 `看看`、小镇、背包、商店、小屋、相册、设置 | 启动后位置清楚；底栏不遮挡；反馈明确；面板可关闭；不使用隐藏 contract 按钮作为验收 |
| V02-PRODUCTION-004 | Art Direction / UI / QA / Godot | Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings 关键截图复核 | 使用 `ThemeProfile` / `AssetResolver`；区分 `production` 与 `approved`；无双视口截图证据不得标为 `approved` |
| V02-PRODUCTION-005 | QA / PM / Godot | 试玩版总 smoke、headless runner 注册、1280x720 与 960x540 代表截图和阶段收口 | 启动 -> Mina / 资源 -> Shop -> Home -> Sunny -> Home-School Walk -> School Gate -> School Yard -> Return Home -> Album -> Settings 全路径通过 |

## 下一轮 Ready：V02-PRODUCTION-002

输入：

- `scripts/main.gd`
- `scripts/ui/memory_album.gd`
- `data/life/daily_greetings.json`
- `data/life/daily_requests.json`
- `data/life/weather_events.json`
- `data/life/homeschool_events.json`
- `data/life/school_day_states.json`
- `data/items/life_items.json`
- `tests/test_v024_content_contracts.gd`
- `tests/test_playable_ui_operations.gd`
- `tests/test_v0215_school_daily_slice.gd`
- `LESSON-008`、`LESSON-009`、`LESSON-010`

交付：

- 孩子端可见文本审校记录或代码 / 数据修改。
- 禁用词扫描扩展，覆盖 HUD、NPC、Sunny、Home / School、天气、P1、商店、小屋、相册和设置。
- Focused 文本安全测试和 full headless runner 通过。

验收禁用词：

- 课程、作业、测试、背诵、迟到、打卡、分数、正确率、家长报告、必须完成、错过损失。

## 不可改范围

- 不新增新地图区域。
- 不新增课程 UI、单元页、练习题、测验、背诵、听写、分数或正确率。
- 不扩 Bookshop / Bus Stop 为 P0，不让 P1 支线阻断每日小镇或 Home / School 主路径。
- 不移动 26 个核心 A-Z anchor，不覆盖 `core_anchor_id`、`route_order`、相册卡片或世界地图结构。
- 不重做主界面结构；V02-PRODUCTION-003 只允许小范围 UI / UX polish。
- 不把缺少截图证据的资产状态从 `production` 提升为 `approved`。

## 收口门槛

- `godot --headless --path . --script tests/headless_runner.gd` 通过。
- `godot --headless --path . --quit` 通过。
- V02-PRODUCTION-005 完成时必须有 1280x720 与 960x540 代表截图。
- `todo.md` 当前状态面板、本轮分工、正式任务列表和完成记录同步。
- `lessons.md` 只有出现已验证问题时才新增教训；无新增时写入轮次复盘“无新增已验证教训”。
