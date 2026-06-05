# Round 86 V02.17 WORLDMAP-002-005 运行时布局与验收记录

> 日期：2026-06-05  
> 状态：已完成  
> 范围：`V02-WORLDMAP-002` 至 `V02-WORLDMAP-005`

## 布局结论

V02.17 不重新规划 A-Z 编码，而是把 `az_world_plan` 落到运行时 `data/maps/world_map.json`。26 个 anchor 全部进入 `memory_anchors`，保留核心 `anchor_id`、`letter`、`core_word`、`route_order` 和 `card_id`。

## 26 Anchor 运行时蓝图

| 层级 | Letters | 运行时地点 | 入口状态 | 截图 / QA 重点 |
|---|---|---|---|---|
| P0 Home line | A/C/D/W | Home | 可见物件，靠近后 `看看` 落账 | Home morning、Home return、Watch / Clock / Dog / Apple 不课程化 |
| P0 School line | E/G/K/N/R/Y | Home-School Walk、School Gate、School Yard | 可见物件，靠近后 `看看` 或 school event 落账 | Gate / Yard / Net / Robot / Yo-yo 是生活地点线索 |
| First ring | B/F/H/I/J/O/T | Town Start、Supermarket、Bookshop / Bus Stop 入口 | 可见物件或 P1 `看看` 入口 | 不阻断 P0，不要求购买、阅读测验或赶车 |
| Second ring | L/M/P/Q/S/U/V | Town / Park / Theatre / Music 预览区 | 可见预览物件，靠近后 `看看` 落账 | 只作故事、自然、天气和声音回访 |
| Far edge | X/Z | Transport far edge | 可见边界预览，靠近后 `看看` 落账 | 不进入 P0，不写独自远行或真实离开小镇 |

## 运行时坐标要求

- 每个 anchor 使用 `world_map.memory_anchors[].position` 作为运行时坐标。
- Home / School P0 anchor 不能集中在远郊或商店区域。
- First / second ring anchor 可以作为预览，但不能遮挡 P0 主路。
- X / Z 必须位于 transport / far edge 侧，且不与 P0 Home / School 主线交互格重叠。
- Anchor 格或邻近格应可步行，且至少一个真实 `看看` 路径能点亮相册。

## 已处理的运行时风险

- `anchor_b_bear` 从树枝资源格移开，并调整 `interact_nearby()` 优先级，避免近邻资源收集抢占 A-Z `看看`。
- `anchor_u_umbrella` 从巴士哥哥 NPC 格移开，避免 NPC 对话抢占 `看看`。
- W Watch 调回 Home 线，E/G/K/N/R/Y 调入 Home / School 中心路线，X/Z 保持 far edge 预览。
- V02.11 weather smoke 的 K Kite / U Umbrella 路径已对齐 V02.17 运行时坐标，避免旧截图点继续指向已迁移 anchor。

## 验收口径

- Focused test：`tests/test_v0217_worldmap_anchor_runtime.gd`
- 全量 runner：`tests/headless_runner.gd` 注册 `_check_v0217_worldmap_anchor_runtime()`
- 截图口径：后续非 headless / MCP 截图应覆盖 Home anchors、School Yard anchors、First Ring anchors、Second Ring preview、Far Edge X/Z 五组代表视图。

## 验证结果

- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`：通过。
- `godot --headless --path . --script tests/test_v0211_weather_slice_smoke.gd`：通过。
- `godot --headless --path . --script tests/test_v028_daily_life_slice.gd`：通过。
- `godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`：通过。
- `godot --headless --path . --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --quit`：通过。

## 禁用范围

- 不改变核心 A-Z 编码。
- 不要求按 A-Z 顺序拜访。
- 不显示课程、测试、背诵、分数、正确率、倒计时、打卡或必须完成。
- 不让 X/Z 成为 P0 或每日必到路径。
