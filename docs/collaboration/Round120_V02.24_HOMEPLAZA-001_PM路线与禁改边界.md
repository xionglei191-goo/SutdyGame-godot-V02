# Round120 V02.24 HOMEPLAZA-001 PM 路线与禁改边界

> 日期：2026-06-07
> 对应任务：`V02-HOMEPLAZA-001 PM 路线与禁改边界`
> 结论：进入 V02.24 Home / Town Plaza 居住感加固。本轮只固定路线、任务拆分、禁改范围、验收矩阵和下一项 Ready，不改 runtime、tests、assets 或 data。

## 1. 输入事实

V02.23 已在 Round119 完成体验批准线：

| 视图 / 区域 | 当前批准事实 | 来源 |
|---|---|---|
| Album | `approved` | Round119 同轮回归 proof 无可见退化，保持 approved |
| Town Plaza / World Map | `approved` | Round119 同轮 1280 RC proof + 真实入口 smoke + PM / Art Direction 逐项判定 |
| Home | `approved` | Round119 同轮 1280 RC proof + 真实入口 smoke + PM / Art Direction 逐项判定 |
| Shop | `approved` | Round119 同轮 1280 RC proof + 真实入口 smoke + PM / Art Direction 逐项判定 |
| School Gate | `approved` | Round119 同轮 1280 RC proof + 真实入口 smoke + PM / Art Direction 逐项判定 |
| School Yard | `approved` | Round119 同轮 1280 RC proof + 真实入口 smoke + PM / Art Direction 逐项判定 |
| Settings | `approved` | Round119 同轮 1280 RC proof + 真实入口 smoke + PM / Art Direction 逐项判定 |

V02.24 不是重新批准线，也不是扩大主线内容。目标是在已批准体验上继续加厚 Home 和 Town Plaza 的“可停留、可回访、像生活空间”的细节。

## 2. V02.24 阶段目标

V02.24 聚焦五件事：

- HomeRoom 默认生活角：让空屋第一眼有生活痕迹，而不是功能摆放板；默认生活细节不写入 `placed_furniture`。
- Sunny 反馈：强化 Sunny 在小屋中的陪伴、看见家具变化、温和反馈。
- 家具状态：让已有 `wooden_chair` 等家具的摆放、已摆放、收起状态更可读，但不改保存结构。
- Town Plaza 停留点：补广场可停留的小物件、休息点、轻提示和自然回访动机。
- 户外装饰规则：固定 allowed place / footprint / 禁覆盖核心 anchor、place、interaction 的规则，为后续实现和测试提供边界。

## 3. 任务队列

| 顺序 | Task ID | Owner | 目标 | 完成门槛 |
|---|---|---|---|---|
| 1 | V02-HOMEPLAZA-001 | PM / Home Design / Map / QA | 固定 V02.24 路线、任务拆分、禁改边界和下一项 Ready | 本文档、docs/12-15、`todo.md`、`lessons.md` 同步；不改 runtime |
| 2 | V02-HOMEPLAZA-002 | Home Design / UI / Godot / QA | HomeRoom 居住感加固 | 新增 Home living contract；Home 默认生活角、Sunny 反馈、家具状态可见；不改 HomeDecorationService 保存 schema，默认生活细节不写入 `placed_furniture` |
| 3 | V02-HOMEPLAZA-003 | Map / Game Design / Godot / QA | Town Plaza 停留点与户外装饰规则 | Plaza 停留点和 allowed place / footprint / 禁覆盖规则落地；核心 anchor / place / interaction 不被装饰覆盖 |
| 4 | V02-HOMEPLAZA-004 | NPC / Map / Godot / QA | NPC routine 与广场到达感 | NPC routine 到达感、fallback 和广场停留反馈成立；P0 NPC 不因 routine、天气或装饰阻断入口 |
| 5 | V02-HOMEPLAZA-005 | QA / PM / Art Direction | 回归、截图与收口 | focused tests、headless runner、1280 proof 和收口记录通过；不把后续内容扩展混入 V02.24 |

## 4. 禁改范围

- 不改 `HomeDecorationService` 存档结构、保存 key、家具 item ID、已摆家具加载语义。
- 不把默认生活角、氛围物件或非交互装饰写入 `home_state.placed_furniture`。
- 不改 26 个 A-Z `anchor_id`、`letter`、`core_word`、`route_order`、`card_id`、核心相册语义或世界路线顺序。
- 不在孩子端显示格子、坐标、占格、footprint、cell、debug、路径搜索、编辑器或写回术语。
- 不新增课程页、练习题、背诵、测试、词表墙、分数、正确率、打卡、倒计时或迟到压力。
- 不把 School、远郊 X/Z 或 authoring 工具提前纳入 V02.24 P0。
- 不把 V02.24 写成 product complete；它是居住感加固阶段。

## 5. 验收矩阵

| 方向 | 必须证明 | 失败判定 |
|---|---|---|
| Home 默认生活角 | 空屋也有温暖、可停留、可回访的生活细节 | 仍像空白功能面板、家具网格或调试房间 |
| Sunny 反馈 | Sunny 能对小屋 / 家具变化给短句反馈 | 反馈缺失、像任务评分、像家长报告或课程评价 |
| 家具状态 | 可见操作、已摆放状态、收起 / 返回路径不退化 | 操作只能靠隐藏 facade，或孩子端出现格子 / 坐标 / 占格词 |
| Town Plaza 停留点 | 广场有自然停留点，生活细节不遮挡 NPC / resource / place / anchor | 只堆装饰、遮挡核心入口、变成任务路线或字母牌墙 |
| 户外装饰规则 | allowed place / footprint / 禁覆盖核心对象有自动化验证 | 装饰可覆盖 Home / Shop / School / A-Z anchor / NPC 入口 |
| NPC routine | routine 有 fallback，Mina / Shopkeeper / Sunny 等 P0 入口不被阻断 | NPC 因 routine、天气或装饰消失，或到达反馈变成打卡压力 |
| 旧路径回归 | V02.21 free life、Playable UI、TownStage layer、panel scene 和 full runner 不退化 | 任何已批准入口、相册、商店、小屋、设置路径断裂 |

## 6. 测试计划

V02.24 新增 / 扩展：

```bash
godot --headless --path . --script tests/test_v0224_home_room_living_contract.gd
godot --headless --path . --script tests/test_v0224_town_plaza_outdoor_decor_rules.gd
godot --headless --path . --script tests/test_v0224_npc_routine_arrival.gd
godot --headless --path . --script tests/test_v0224_homeplaza_smoke.gd
```

V02.24 回归：

```bash
godot --headless --path . --script tests/test_v0222_hidden_grid_life_systems.gd
godot --headless --path . --script tests/test_town_stage_layered_runtime.gd
godot --headless --path . --script tests/test_v0223_ui_panel_scene_split.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v0221_livegate_free_life_smoke.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

V02-HOMEPLAZA-005 需要非 headless 1280 proof，沿用 LESSON-010 的显示驱动路径，不用 headless 空截图做视觉批准证据。

## 7. 下一项 Ready

本轮收口后，下一项 Ready 为：

`V02-HOMEPLAZA-002 HomeRoom 居住感加固`

执行提示：

- 先新增 focused living contract，再改 HomeRoom 表现。
- 只加表现和孩子端反馈，不迁移 HomeDecorationService 保存 schema。
- 所有新增孩子端文案必须短、温暖、生活化，无格子 / 坐标 / 占格 / debug 术语。
