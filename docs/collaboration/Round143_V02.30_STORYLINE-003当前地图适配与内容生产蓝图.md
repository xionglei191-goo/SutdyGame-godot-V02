# Round143 V02.30 STORYLINE-003 当前地图适配与内容生产蓝图

> 日期：2026-06-07
> 任务：`V02-STORYLINE-003 当前地图适配与内容生产蓝图`
> 状态：完成
> 下一轮 Ready：`V02-MOTION-001 行走动画与角色动作规格`

## 本轮范围

本轮把 Round142 故事总纲落到当前 `world_map`、Place、interaction、resource、NPC routine 和 Map Editor 可生产候选上。仍不改正式 JSON、不生成正式资产、不改 runtime。

本轮判断只分三类：

- `direct_runtime`：现有 Place / interaction / resource / routine 已能承载故事，后续只需文案或素材接入。
- `asset_only`：地图结构不用改，只需要后续美术资产替换 / 增强。
- `map_editor_candidate`：建议后续用 Map Editor 生产 Place / interaction / resource / NPC routine 候选，再经 Validate 和安全写回。

## P0 动线适配

| 顺序 | 故事章节 | 当前可用地点 / 入口 | 当前 anchor | 当前 NPC / resource | 适配结论 | 后续生产候选 |
|---|---|---|---|---|---|---|
| 1 | `chapter_home_warm_start` | `place_home`，interaction `31,19` enter_home；home look cells `28,17` / `28,20` / `31,20` | A/C/D/W | Sunny routine `26,20` / `27,21` | `direct_runtime` | asset-only：Apple welcome photo、Clock chair、Sunny towel、Watch charm |
| 2 | `chapter_school_path_sky` | `place_home_school_walk` `24,15`；`place_school_gate` `21,12`；`place_school_yard` `19,15` | G/K/N/R/Y | leaf resource `22,15` | `direct_runtime` | asset-only：Kite ribbon、Gate bell、Net / Robot / Yo-yo props；可用 Map Editor 后续增加一个 School Yard story prop Place |
| 3 | `chapter_shop_street_kindness` | `place_supermarket` `41,11`；Shop front look `42,9`；`place_shop_ribbon_corner` `49,13` | H/I/J/O | Shopkeeper routine；ribbon resource `50,14` | `direct_runtime` | asset-only：Hat ribbon、Ice cream / Orange window、Jacket display；后续可用 Map Editor 微调 Ribbon Corner label / action |
| 4 | `chapter_story_plaza_circle` | `place_town_start` `18,19`；`place_plaza_story_bench` `12,20`；P1 return Bear cells `17,18` / `18,19` | B/Q/V/S | Story Bear routine `15-16,18`；branch resource `19,18`；flower resource `9,5` | `direct_runtime` | map_editor_candidate：Story Bench 可后续绑定 `look_storyline_event` 或 story asset marker；asset-only：Bear book、branch bookmark、Violin / Queen poster |
| 5 | `chapter_first_week_album` | Home / Walk / School / Shop / Town Plaza existing entries | A/B/C/D/G/H/K/O/S/W | Sunny / Mina / Story Bear / Shopkeeper | `direct_runtime` | 后续 runtime story slice 需要相册落账聚合，不在本轮实现 |

## P1 / P2 适配

| 章节 | 当前地点 | 当前 anchor | 当前资源 / 入口 | 适配结论 | 约束 |
|---|---|---|---|---|---|
| `chapter_animal_park_visit` | `place_animal_park` `39,22` | E/F/L/M/P/Z | pinecone resource `48,25` | `direct_runtime` + `asset_only` | P1 可选散步，不进入 P0 必经 |
| `chapter_coast_soft_edge` | `place_coast_edge` `52,27` | U/X | shell resource `53,28` | `direct_runtime` + `asset_only` | Coast / X 只作边界预览，不写寻宝压力 |
| `chapter_weather_resource_threads` | Home / Sun / Walk / Shop / Animal / Coast | B/S/K/H/M/U | branch / flower / leaf / ribbon / pinecone / shell | `direct_runtime` | 天气 / 资源只是软回访，不做每日必须 |

## Story-Place-Anchor-NPC 绑定表

| Storyline ID | Place | Interaction / cell | NPC / Trigger | Anchor IDs | Production status |
|---|---|---|---|---|---|
| `story_home_apple_photo_start` | `place_home` | Home entry / home look | Sunny | A | `asset_only` |
| `story_home_clock_chair_time` | `place_home` | Home entry / home look | Sunny | C | `asset_only` |
| `story_home_sunny_towel_corner` | `place_home` | Home entry / home look | Sunny | D | `asset_only` |
| `story_home_watch_wall_charm` | `place_home` | Home entry / home look | Sunny | W | `asset_only` |
| `story_walk_kite_leaf_path` | `place_home_school_walk` | `24,15`; resource `22,15` | Environment | K | `direct_runtime` |
| `story_school_gate_soft_bell` | `place_school_gate` | `21,12` | Environment | G | `asset_only` |
| `story_school_yard_net_chalk_robot_yoyo` | `place_school_yard` | `19,15`; existing extra event | Environment | N/R/Y | `direct_runtime` |
| `story_shop_hat_ribbon_window` | `place_supermarket` / `place_shop_ribbon_corner` | `42,9`, `49,13`; resource `50,14` | Shopkeeper | H | `direct_runtime` |
| `story_shop_icecream_orange_window` | `place_supermarket` | `42,9`, `41,11` | Shopkeeper | I/O | `asset_only` |
| `story_shop_jacket_display` | `place_supermarket` | `42,9` | Shopkeeper | J | `asset_only` |
| `story_plaza_bear_book_branch` | `place_town_start` / `place_plaza_story_bench` | `18,19`, `12,20`; resource `19,18` | Story Bear | B | `direct_runtime` |
| `story_plaza_queen_violin_poster` | `place_town_start` / `place_plaza_story_bench` | `12,20` | Story Bear | Q/V | `map_editor_candidate` |
| `story_sun_flower_patch` | `place_sun_scene` | `7,4`; resource `9,5` | Environment | S | `direct_runtime` |
| `story_animal_monkey_pinecone` | `place_animal_park` | `39,22`; resource `48,25` | Environment | M | `direct_runtime` |
| `story_animal_sign_group` | `place_animal_park` | `39,22` | Environment / Mina | E/F/L/P/Z | `asset_only` |
| `story_coast_umbrella_shell` | `place_coast_edge` | `52,27`; resource `53,28` | Environment | U | `direct_runtime` |
| `story_coast_x_box_boundary` | `place_coast_edge` | `52,27` | Environment | X | `asset_only` |

## Map Editor 候选清单

以下为后续 V02.34 / V02.36 前可考虑使用 Map Editor 生产的候选。它们不是本轮正式数据改动。

| Candidate ID | 类型 | 建议地点 / cell | 目的 | 依赖 | 优先级 |
|---|---|---|---|---|---|
| `place_story_bench_poster_corner` | Place / story prop marker | Story Bench 附近，候选 cell `13,20` | 承载 Queen / Violin poster，不让 Q/V 只停留在文字设定 | Story Bench 已存在 | P1 |
| `place_school_yard_story_corner` | Place / story prop marker | School Yard 附近，候选 cell `18,15` 或现有 `19,15` 旁 | 强化 Net / Robot / Yo-yo 三件物件的可见故事角 | School Yard existing look event | P0 |
| `place_home_story_wall` | Place / home detail marker | Home 内 / Home 外部逻辑 marker | 承载 Apple photo、Clock chair、Watch wall charm 的统一 story asset 入口 | HomeRoom asset work | P0 |
| `place_animal_park_sign_group` | Place / story prop marker | Animal Park 附近，候选 cell `46,24` | 承载 E/F/L/P/Z animal sign group | Animal Park asset pack | P1 |
| `place_coast_x_box_preview` | Place / boundary preview marker | Coast Edge 远边，候选 cell `56,29` | 承载 X box 远郊预览，不进入 P0 | Coast asset pack | P2 |
| `routine_story_bear_story_bench_001` | NPC routine | Story Bench 附近，候选 cell `14,20` | 让 Story Bear 偶尔靠近 Story Bench，强化故事地点 | NPC routine safety | P1 |
| `routine_mina_school_walk_001` | NPC routine | Home-School Walk，候选 cell `23,15` | 让 Mina 偶尔出现在小路旁，不阻断 Home / School | NPC routine safety | P0 |

## 素材替换优先级

`asset_only` 项可以先进入 V02.33 asset backlog，不需要地图数据变化：

| 优先级 | 资产 | 绑定故事 |
|---|---|---|
| P0 | Apple welcome photo、Clock chair、Sunny towel、Watch wall charm | Home start |
| P0 | Kite ribbon、Gate bell、School Yard net / chalk / robot / yo-yo | School path |
| P0 | Hat ribbon、Ice cream / Orange window、Jacket display | Shop Street |
| P0 | Bear open book、branch bookmark、Story Bench surface | Story Plaza |
| P1 | Animal Park sign group、Monkey tree / pinecone enhancement | Animal Park |
| P1 | Coast umbrella / shell path | Coast Edge |
| P2 | X box silhouette | Far edge preview |

## 风险与边界

- `place_town_start` 当前 label 是 `Story + Culture Bridge`，后续孩子端若出现 “culture bridge” 这种工程 / 成人概念，应改为生活化 label；本轮只记录风险，不改数据。
- `place_plaza_story_bench` / `place_shop_ribbon_corner` 当前 action 为 `open_town_start`，可承载轻看一眼；后续若做专门故事事件，应在 V02.36 runtime slice 中新增明确 story action，而不是复用模糊 action。
- `place_home` 相关故事多发生在 HomeRoom 内，地图 cell 只能代表入口；后续 Home story asset 应优先走 HomeRoom scene / logical asset，不强行把室内物件塞进 world_map。
- Animal Park 和 Coast Edge 只能保持 P1 / P2 可选，不得写入 P0 必经路线或每日必须。

## 交付给后续任务的输入

`V02-MOTION-001`：

- Player 必须优先支持 Home -> Walk -> School -> Shop -> Story Bench 的连续移动读感。
- NPC 首批动作优先 Mina、Shopkeeper、Story Bear、Sunny。
- Sunny 的 Home / follow / greet 动作优先于复杂表演。

`V02-CONTROLS-001`：

- prompt 优先级必须覆盖 exact place、NPC、resource、anchor、story prop 的冲突。
- Home / School Yard / Shop Street / Story Bench 是主要 prompt proof 区域。

`V02-ARTPIPE-001`：

- asset backlog 直接以本文件的 `asset_only` 和 `Map Editor 候选清单` 为输入。
- 所有 prop 需要 logical asset ID，后续不能硬编码文件路径。

## 验收结论

- 故事总纲已映射到当前 Place / interaction / resource / routine：通过。
- P0 主要故事均可由当前地图承载或明确为 asset-only：通过。
- Map Editor 候选已列出，且未手工修改正式 JSON：通过。
- A-Z anchor 稳定 ID / route_order 不变：通过。
- P1 / P2 未扩为 P0 必经：通过。

下一轮 Ready：`V02-MOTION-001 行走动画与角色动作规格`。
