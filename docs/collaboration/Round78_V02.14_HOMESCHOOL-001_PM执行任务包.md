# Round 78 V02.14 HOMESCHOOL-001 PM 执行任务包

> 日期：2026-06-05
> Owner：PM / Game Design / Narrative / QA
> 当前任务：`V02-HOMESCHOOL-001 Home / School P0 可玩纵切路线与任务拆分`
> 下一轮唯一 Ready：`V02-HOMESCHOOL-002 Home Morning Foundation 数据化与可见入口`

## 1. 背景

V02.12 已完成 Home / School 世界地图地基，V02.13 已完成全量课本内容世界化数据合同。V02.14 的目标不是继续补课本，也不是新增课程 UI，而是把 Home / School 第一主线做成孩子端真实可见的 P0 生活路线。

第一条 P0 主线固定为：

```text
Home 早晨
  -> Home-School Walk
  -> School Gate / School Yard
  -> 回 Home / Shop bridge
```

英语和课本内容只作为环境短句、地点故事、NPC 短反馈、相册线索和轻委托挂接；孩子端不显示课程、单元、测试、背诵、词表、分数、倒计时、错过或必须完成文案。

## 2. V02.14 任务队列

| 顺序 | Task ID | Owner | 交付物 | 验收 |
|---|---|---|---|---|
| 1 | V02-HOMESCHOOL-001 | PM / Game Design / Narrative / QA | V02.14 路线、P0 内容点、任务拆分、PM 任务包和 Ready 队列 | `docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步；下一轮唯一 Ready 明确 |
| 2 | V02-HOMESCHOOL-002 | Godot Dev / Narrative / QA | Home Morning Foundation 数据、Home / 小屋 / Sunny 可见入口、保存 / 相册轻记录和 focused test | 玩家从 Home 或小屋真实可见 `看看` 路径触发；A/C/D/W 线索温和；无课程 / 起床打卡 / 迟到压力 |
| 3 | V02-HOMESCHOOL-003 | Map / Godot Dev / UX / QA | Home-School Walk 可见路线、路牌 / 风筝 / 校门方向线索和安全返回 | 路线可走、可看、可回 Home；不引用 far edge，不出现赶路、倒计时、交通危险或独自远行 |
| 4 | V02-HOMESCHOOL-004 | Narrative / Godot Dev / Memory Palace / QA | School Gate / School Yard 首批地点故事、NPC 轻反馈和 A-Z 记录 | School 是生活地点和操场回访，不出现课堂、老师训导、作业、测试、背诵、分数 |
| 5 | V02-HOMESCHOOL-005 | QA / PM / Godot Dev | Home -> Walk -> School -> Return / Shop bridge 玩家路径 smoke、headless runner 注册和双视口截图 | P0 主线可玩且不阻断 V02.8-V02.11 每日小镇、商店、小屋、天气和相册路径 |

## 3. 首批 P0 内容点

| content ID | 首次实现任务 | 可见入口 | A-Z / 记忆宫殿绑定 | 验收重点 |
|---|---|---|---|---|
| `homeschool_home_morning_bag_001` | V02-HOMESCHOOL-002 | Home / 小屋书包或早晨角落按 `看看` | A Apple、C Clock、W Watch | 早晨短反馈，记录 Home 起点，不写迟到或打卡 |
| `homeschool_home_sunny_good_morning_001` | V02-HOMESCHOOL-002 | Sunny 角落按 `看看` | D Dog | `Good morning.` 只作环境短句，Sunny 反馈温和 |
| `homeschool_walk_gate_sign_001` | V02-HOMESCHOOL-003 | Home-School Walk 路牌 / 校门方向标记按 `看看` | G Gate | 安全小路可见，可回 Home，不触发远郊 |
| `homeschool_walk_kite_sky_001` | V02-HOMESCHOOL-003 | 路上风筝或天空标记按 `看看` | K Kite、S Sun | 天气和天空只作氛围，不做打卡 |
| `homeschool_school_gate_hello_001` | V02-HOMESCHOOL-004 | School Gate 附近按 `看看` | E Elephant、G Gate | 校门是温和生活入口，不是课堂门槛 |
| `homeschool_school_yard_play_001` | V02-HOMESCHOOL-004 | School Yard / 操场网 / robot 角按 `看看` | N Net、R Robot、Y Yo-yo | 操场回访和相册线索，不出现测验 |
| `homeschool_return_sunny_story_001` | V02-HOMESCHOOL-005 | 回 Home / Sunny 角落按 `看看` | D Dog、A Apple、O Orange | 回家反馈和旧闭环复核，不写学习总结 |

## 4. V02-HOMESCHOOL-002 开工说明

下一轮只做 Home Morning Foundation，不扩 Home-School Walk 或 School runtime。

建议输入：

- `data/maps/az_world_plan.json` 的 `foundation_story_hooks`
- `data/curriculum/textbook_world_plan.json` 的 P0 Home Morning Foundation 映射
- `data/anchors/new_word_revisit_paths.json`
- `data/cards/az_core_cards.json`
- `scripts/main.gd`
- `tests/test_v023_memory_palace_world.gd`
- `tests/test_playable_ui_operations.gd`
- `LESSON-008`、`LESSON-009`、`LESSON-010`

最小交付：

- Home / 小屋 / Sunny 角落的早晨可见入口或现有入口扩展。
- 1-2 条短反馈，包含 `Good morning.` / `home` / `bag` / `clock` / `dog` 等环境层，但中文承担理解。
- A/C/D/W 中至少 2 个 Home 线索进入相册或 card state 的温和记录。
- focused test 通过真实可见路径触发，不依赖隐藏 contract 按钮。
- 不改动 P1/P2、不移动核心 anchor、不接 School runtime。

## 5. 禁用范围

- 不做课程页、单元页、测试页、背诵页、词表墙、分数、星级、排名、正确率。
- 不写起床打卡、迟到惩罚、必须上学、作业检查、老师评价或家长报告。
- 不把 Home-School Walk 写成独自远行、上车离开、危险道路、赶路或倒计时。
- 不让 Bookshop、Bus Stop、Park、Theatre、Music Corner 或 Far Edge 成为 P0 硬依赖。
- 不把 Letter Snake 重新写回主线条件。

## 6. 验收命令建议

V02-HOMESCHOOL-001 为 PM 文档任务，收口建议运行：

```bash
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

V02-HOMESCHOOL-002 起涉及 runtime，应增加 touched script `check-only`、focused test、headless runner 和必要的截图验收。
