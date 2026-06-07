# Round152 V02.37 STORYBATCH-002 第二批 story prop / A-Z 回访内容包

> 日期：2026-06-07
> 任务：`V02-STORYBATCH-002 第二批 story prop / A-Z 回访内容包`
> 状态：完成
> 下一轮 Ready：`V02-STORYBATCH-003 第二批 production 资产与接入`

## 本轮范围

本轮只产出第二批 story prop / A-Z 回访内容包，不生成图片、不改 ThemeProfile / AssetResolver、不改 runtime、不写正式 JSON。后续 `V02-STORYBATCH-003` 再按本内容包生产 bitmap 资产并记录生图脚本证据；`V02-STORYBATCH-004` 再接 runtime 真实入口。

目标：

- 优先补 Round150 未覆盖的 P0 / first-batch 字母，避免继续堆 A/B/H/N/R/Y。
- 每条候选绑定稳定 `core_anchor_id`、place、context、environment words、story memory、visual hook、review path、asset need 和 child feedback。
- 保持 A-Z memory palace 结构不变，不重排、不覆盖 core anchors。
- School 仍是生活地点，不出现课程、测试、作业、迟到、分数、打卡或工程文案。

## Round150 覆盖差距

Round150 已通过首批 story prop 点亮：

- A Apple：`story_prop_marker_home_apple_welcome_photo`
- B Bear：`story_prop_marker_plaza_bear_book_branch`
- H Hat：`story_prop_marker_shop_hat_ribbon_window`
- N Net / R Robot / Y Yo-yo：`story_prop_marker_school_yard_net_robot_yoyo`

第二批优先补：

- C Clock、D Dog、G Gate、K Kite、O Orange、S Sun、W Watch

其中 C/D/K/O/S/W 已有 `new_word_revisit_paths` 线索，可升级为 story prop 资产包；G Gate 需要新增 gate bell 生活回访线索。

## 第二批 P0 内容包

| Candidate ID | Priority | Anchor | Place | Context | Environment Words | Asset Need |
|---|---|---|---|---|---|---|
| `story_prop_candidate_home_clock_chair` | P0 | `anchor_c_clock` | `place_home` | Home story wall / chair / morning | clock, chair, home, time | Clock corner + cozy chair prop |
| `story_prop_candidate_home_sunny_towel_dog` | P0 | `anchor_d_dog` | `place_home` | Sunny corner / pet care feel | dog, towel, Sunny, home | Folded towel + paw print + small Sunny corner marker |
| `story_prop_candidate_home_watch_wall_charm` | P0 | `anchor_w_watch` | `place_home` | Home wall / slow time | watch, wall, charm, time | Watch wall charm prop |
| `story_prop_candidate_school_gate_bell` | P0 | `anchor_g_gate` | `place_school_gate` | School Gate / morning hello | gate, bell, hello, school | Soft gate bell + friendly sign |
| `story_prop_candidate_walk_kite_leaf` | P0 | `anchor_k_kite` | `place_home_school_walk` | Home-School Walk / leaf resource / breeze | kite, leaf, wind, path | Kite ribbon + spinning leaf path prop |
| `story_prop_candidate_shop_orange_bowl` | P0 | `anchor_o_orange` | `place_supermarket` / `place_home` | Shop window + Sunny bowl return path | orange, bowl, shop, home | Orange stand / bowl sticker bridge prop |
| `story_prop_candidate_sun_flower_patch` | P0 | `anchor_s_sun` | `place_sun_scene` | Sun Scene / flower resource / weather clue | sun, flower, warm, plaza | Soft sun patch + flower cluster prop |

## 候选详情

### `story_prop_candidate_home_clock_chair`

| 字段 | 内容 |
|---|---|
| planned story prop ID | `story_prop_marker_home_clock_chair_corner` |
| planned logical asset ID | `story_prop.home.clock_chair_corner` |
| anchor | `anchor_c_clock` / C Clock |
| place | `place_home` |
| linked revisit story | `story_chair_clock_cozy_time` |
| story memory | The Clock corner ticks softly while a wooden chair waits for cozy home time. |
| visual hook | a small chair under the Clock with warm morning light |
| review path | Look at the Clock corner, return Home, then view the cozy chair nearby. |
| child label | 看看时钟小椅子 |
| child feedback | 小椅子安安静静靠在时钟旁边，家里的时间像慢慢坐了下来。 |
| asset note | Home story wall prop；不需要 world_map 新 Place，优先走 Home / story prop layer 的 logical asset。 |

### `story_prop_candidate_home_sunny_towel_dog`

| 字段 | 内容 |
|---|---|
| planned story prop ID | `story_prop_marker_home_sunny_towel_dog_corner` |
| planned logical asset ID | `story_prop.home.sunny_towel_dog_corner` |
| anchor | `anchor_d_dog` / D Dog |
| place | `place_home` |
| linked revisit story | `story_towel_dog_corner` |
| story memory | A soft towel rests near Sunny's Dog corner after a slow walk. |
| visual hook | a folded towel with one paw print beside the Dog corner |
| review path | Return Home, visit Sunny's Dog corner, then look for the folded towel. |
| child label | 看看 Sunny 的小毛巾 |
| child feedback | Sunny 的小毛巾折得软软的，像刚陪小镇慢慢走了一圈。 |
| asset note | 只表现照看和温暖，不写宠物责任压力、不写必须喂养。 |

### `story_prop_candidate_home_watch_wall_charm`

| 字段 | 内容 |
|---|---|
| planned story prop ID | `story_prop_marker_home_watch_wall_charm` |
| planned logical asset ID | `story_prop.home.watch_wall_charm` |
| anchor | `anchor_w_watch` / W Watch |
| place | `place_home` |
| linked revisit story | `story_watch_wall_charm` |
| story memory | A wall charm hangs below the Watch sign to remind the room that cozy time can be slow. |
| visual hook | a wall decoration under a Watch sign |
| review path | Walk by the Watch sign, then look at the home wall decoration. |
| child label | 看看手表小挂饰 |
| child feedback | 小挂饰在墙上轻轻晃了一下，好像提醒小屋不用着急。 |
| asset note | 与 C Clock 同属 Home slow-time 组，但分别绑定 C/W，不合并成同一 core anchor。 |

### `story_prop_candidate_school_gate_bell`

| 字段 | 内容 |
|---|---|
| planned story prop ID | `story_prop_marker_school_gate_bell_sign` |
| planned logical asset ID | `story_prop.school.gate_bell_sign` |
| anchor | `anchor_g_gate` / G Gate |
| place | `place_school_gate` |
| planned revisit story | `story_bell_gate_soft_hello` |
| story memory | The School Gate bell gives a tiny hello when the morning path reaches the gate. |
| visual hook | a round bell tied to the soft School Gate sign |
| review path | Walk from Home-School path to School Gate, look at the bell, then open the album. |
| child label | 看看校门小铃 |
| child feedback | 校门小铃轻轻亮了一下，只是在说早上好。 |
| asset note | School Gate 只做生活入口，不出现上课、迟到、作业、考试或排队压力。 |

### `story_prop_candidate_walk_kite_leaf`

| 字段 | 内容 |
|---|---|
| planned story prop ID | `story_prop_marker_walk_kite_leaf_path` |
| planned logical asset ID | `story_prop.walk.kite_leaf_path` |
| anchor | `anchor_k_kite` / K Kite |
| place | `place_home_school_walk` |
| linked revisit story | `story_leaf_kite_path` |
| resource context | `resource_leaf_school_walk` / `leaf` |
| story memory | A leaf turns under the Kite sky and points back to the school path. |
| visual hook | a small leaf spinning under the Kite ribbon |
| review path | Walk the Home-School path, look up at Kite, then notice the leaf by the road. |
| child label | 看看风筝小叶子 |
| child feedback | 小叶子在风筝下面转了个小圈，像在给小路打招呼。 |
| asset note | 可和微风天气联动，但不能变成每日必须或天气打卡。 |

### `story_prop_candidate_shop_orange_bowl`

| 字段 | 内容 |
|---|---|
| planned story prop ID | `story_prop_marker_shop_orange_bowl_window` |
| planned logical asset ID | `story_prop.shop.orange_bowl_window` |
| anchor | `anchor_o_orange` / O Orange |
| place | `place_supermarket`，回访可指向 `place_home` |
| linked revisit story | `story_pet_bowl_orange_round` |
| NPC context | Shopkeeper / Sunny |
| story memory | Sunny's bowl is round like a plate at the Orange Stand. |
| visual hook | a round bowl with a tiny orange sticker near the shop window |
| review path | Visit Orange Stand, then return Home and check Sunny's bowl. |
| child label | 看看橙子小碗 |
| child feedback | 橙子窗边的小碗圆圆的，像 Sunny 回家前留下的小记号。 |
| asset note | 不写购买压力；可作为 Shop -> Home 的温和回访桥。 |

### `story_prop_candidate_sun_flower_patch`

| 字段 | 内容 |
|---|---|
| planned story prop ID | `story_prop_marker_sun_flower_patch` |
| planned logical asset ID | `story_prop.plaza.sun_flower_patch` |
| anchor | `anchor_s_sun` / S Sun |
| place | `place_sun_scene` |
| linked revisit story | `story_flower_sun_window` |
| resource context | `resource_flower_sun_plaza` / `flower` |
| story memory | A flower under the Sun Scene makes the town feel warm and awake. |
| visual hook | a flower shining inside a soft sun patch |
| review path | Walk past Sun Scene, look at the flower patch, then open the album. |
| child label | 看看阳光小花 |
| child feedback | 阳光落在小花旁边，地面像悄悄暖了一小块。 |
| asset note | 现有 revisit story 的 `world_place_id` 写作 `place_town_start`；后续 runtime 接入时应以实际 anchor place `place_sun_scene` 为 proof 点，避免 S Sun 证据跑偏。 |

## P1 / 预留 backlog

以下内容暂不进入本轮 P0 资产包，但保留给后续批次：

| Candidate ID | Anchor | Reason |
|---|---|---|
| `story_prop_candidate_shop_icecream_jacket_window` | I Ice cream / J Jacket | Shop Street P0 可做，但本轮先补 first-batch C/D/K/O/S/W 和 G Gate；I/J 可在第三批 Shop window 组接入。 |
| `story_prop_candidate_plaza_queen_violin_poster` | Q Queen / V Violin | Story Bench P1 预览，不抢 P0 Home / School / Shop / Sun proof。 |
| `story_prop_candidate_animal_park_sign_group` | E/F/L/M/P/Z | P1 Animal Park 可选散步，不进入 P0 必经。 |
| `story_prop_candidate_coast_umbrella_shell_xbox` | U/X | Coast Edge 仍作为安全边界预览，不写成每日路线。 |

## 后续交付要求

`V02-STORYBATCH-003`：

- 按上述 7 条候选生产 bitmap 资产，使用 `/home/xionglei/GameProject/tools/image_generator.js` 或内置生图工具。
- 每张 bitmap 必须记录生图脚本、prompt 方向、源图临时落点、后处理、尺寸 / alpha 和接触表目检结果。
- 资产进入 repo asset tree 后，必须通过 logical asset ID 写入 ThemeProfile / AssetResolver；不能在 runtime 硬编码路径。

`V02-STORYBATCH-004`：

- 新增 story prop runtime 数据和真实 `看看` 入口 smoke。
- 每条 story prop 至少验证一次孩子端移动 / prompt / `看看` / story slice save record / A-Z card state。
- Home 内部候选若不能直接落 world cell，需要以 Home story prop layer 或 HomeRoom 等价入口证明，不可伪造地图 cell。

`V02-STORYBATCH-005`：

- 仅在同轮 1280 runtime proof、focused / full runner、PM / Art Direction 判定都通过后，才可把某项从 `production` 提升为 `approved`。

## 验收结论

- 第二批 P0 内容包覆盖 C/D/G/K/O/S/W：通过。
- 每条候选均绑定稳定 anchor、place、context、environment words、story memory、visual hook、review path、asset need 和 child feedback：通过。
- 未复用同一 `core_anchor_id` 造成覆盖风险：通过。
- 未改 runtime / data / tests / assets，未生成图片：通过。
- 未扩远郊 P0，未课程化 School：通过。

## 验证

- `godot --headless --path . --check-only --script tests/test_v0237_storybatch002_content_pack.gd`
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/test_v0237_storybatch002_content_pack.gd`
- `godot --headless --path . --script tests/headless_runner.gd`

以上均通过。`tests/test_v0237_storybatch002_content_pack.gd` 已注册进 `tests/headless_runner.gd` 的轻量文档合同门槛。
