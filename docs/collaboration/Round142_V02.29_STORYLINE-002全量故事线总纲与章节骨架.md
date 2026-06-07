# Round142 V02.29 STORYLINE-002 全量故事线总纲与章节骨架

> 日期：2026-06-07
> 任务：`V02-STORYLINE-002 全量故事线总纲与章节骨架`
> 状态：完成
> 下一轮 Ready：`V02-STORYLINE-003 当前地图适配与内容生产蓝图`

## 本轮范围

本轮只做故事总纲和章节骨架，不改 runtime、不改正式 JSON、不生成正式资产。故事必须围绕当前 `world_map`、已存在 Place、NPC、resource、routine 和 26 个 A-Z anchor 展开，后续是否需要 Map Editor 小改留到 `V02-STORYLINE-003` 决定。

核心目标：

- 固定 P0 / P1 / P2 / far edge 的故事章节结构。
- 为 26 个 A-Z anchor 建立可制作故事索引。
- 每个 anchor 都给出地点、NPC / 触发者、新词、记忆故事、视觉钩子、回访路径和首批资产需求。
- 保持 School 是生活地点，不是课堂、考试、作业或打卡空间。
- 让英语继续作为环境词、物件名、短句和相册标签，不作为通关门槛。

## 章节总览

| 章节 ID | 分层 | 名称 | 地点范围 | 主 NPC / 触发者 | 核心体验 | 覆盖 anchor |
|---|---|---|---|---|---|---|
| `chapter_home_warm_start` | P0 | 小屋暖早晨 | Home / Home yard | Sunny / Mina | 起床、看小屋、和 Sunny 打招呼、发现 Apple / Clock / Dog / Watch | A/C/D/W |
| `chapter_school_path_sky` | P0 | 慢慢上学路 | Home-School Walk / School Gate / School Yard | Mina / 环境触发 | 从小屋走到校门和操场，只看生活角落，不上课 | G/K/N/R/Y |
| `chapter_shop_street_kindness` | P0 | 小店街的温柔帮忙 | Shop Street / Ribbon Corner / Supermarket | Shopkeeper / Mina | 看橱窗、找小丝带、认识 Hat / Ice cream / Orange / Jacket | H/I/J/O |
| `chapter_story_plaza_circle` | P0 | 故事长椅和广场朋友 | Town Plaza / Story Bench / Bear Corner | Story Bear / Bus Helper | 在故事长椅旁听小镇故事，建立 Bear / Queen / Violin 的广场记忆 | B/Q/V |
| `chapter_animal_park_visit` | P1 | 动物公园慢回访 | Animal Park | Mina / Sunny / 环境触发 | 远一点的动物角落，只作为可选散步和相册扩展 | E/F/L/M/P/Z |
| `chapter_coast_soft_edge` | P1 | 海边伞影 | Coast Edge | Bus Helper / 环境触发 | 海边只作安全边界和温和预览，不要求每日到达 | U/X |
| `chapter_weather_resource_threads` | P1 | 天气和小资源线 | Home / School path / Shop / Animal Park / Coast | 环境触发 | branch / flower / leaf / ribbon / pinecone / shell 串起复访 | B/S/K/H/M/U |
| `chapter_first_week_album` | P0 汇总 | 第一周相册线 | Home / Walk / School / Shop / Town Plaza | Sunny / Mina / Story Bear | 把前几章的生活发现落到相册，而不是做学习总结 | A/B/C/D/G/H/K/O/S/W |

## P0 主线章节骨架

### `chapter_home_warm_start`

孩子从 Home 开始，先看到 Apple welcome、Clock corner、Sunny 的 Dog corner 和 Watch wall charm。Sunny 用短动作回应，Mina 可以在第一天靠近 Home / Plaza 给一个很轻的问候。章节目标不是“去上学”，而是让孩子理解小屋是安全起点。

| 字段 | 内容 |
|---|---|
| 主要地点 | `place_home` |
| 关键 anchor | A Apple、C Clock、D Dog、W Watch |
| 主要 NPC | Sunny / Mina |
| 环境词 | home、apple、clock、dog、watch、Good morning |
| 视觉资产需求 | Apple welcome box、Clock corner、Sunny soft towel、Watch wall charm、Home morning light |
| 回访路径 | 每天回家、相册、Sunny 反馈、小屋默认生活细节 |
| 禁止方向 | 不写起床打卡、迟到、家长报告、照顾宠物压力 |

### `chapter_school_path_sky`

孩子沿 Home-School Walk 到 School Gate 和 School Yard。School 是小镇生活地点：门铃、风筝、操场小网、机器人角、Yo-yo 彩绳。没有课堂页、考试、老师训导或作业检查。

| 字段 | 内容 |
|---|---|
| 主要地点 | `place_home_school_walk`、`place_school_gate`、`place_school_yard` |
| 关键 anchor | G Gate、K Kite、N Net、R Robot、Y Yo-yo |
| 主要 NPC | Mina / 环境触发 |
| 环境词 | go、look、school、gate、kite、net、robot、yo-yo |
| 视觉资产需求 | Soft gate bell、Kite sky ribbon、play net、small robot corner、yo-yo string |
| 回访路径 | 上学小路看一眼、相册 School Yard 页、天气微风变化 |
| 禁止方向 | 不写课堂、作业、考试、迟到、分数、必须完成 |

### `chapter_shop_street_kindness`

Shop Street 是温柔交易和生活帮忙空间。店长整理小篮子，Ribbon Corner 作为 V02.28 dogfood 产物进入故事线。孩子可以看到 Hat、Ice cream、Orange、Jacket 的橱窗物件，也可以收集 ribbon 作为故事物件。

| 字段 | 内容 |
|---|---|
| 主要地点 | `place_supermarket`、`place_shop_ribbon_corner` |
| 关键 anchor | H Hat、I Ice cream、J Jacket、O Orange |
| 主要 NPC | Shopkeeper / Mina |
| 环境词 | shop、hat、ice cream、jacket、orange、ribbon、thank you |
| 视觉资产需求 | Hat sign、Ice cream sticker、Jacket window、Orange stand、Ribbon basket |
| 回访路径 | Shop front look event、resource ribbon、商店轮换、相册 Shop Street 页 |
| 禁止方向 | 不写买不起压力、强推销、限时商品、消费排名 |

### `chapter_story_plaza_circle`

Town Plaza 和 Story Bench 是小镇讲故事的心脏。Story Bear 把 branch 当书签，Bus Helper 在广场边只做安全交通氛围，不引导独自远行。Queen 和 Violin 作为广场表演 / 小剧场预留，不进入 P0 必须路线。

| 字段 | 内容 |
|---|---|
| 主要地点 | `place_town_start`、`place_plaza_story_bench` |
| 关键 anchor | B Bear、Q Queen、V Violin、S Sun |
| 主要 NPC | Story Bear / Bus Helper / Mina |
| 环境词 | bear、book、bench、sun、story、violin |
| 视觉资产需求 | Story Bench、Bear open book、branch bookmark、soft sun patch、violin poster |
| 回访路径 | Story Bench 看一眼、branch resource、相册 Town Story 页、天气晴天变化 |
| 禁止方向 | 不写阅读测验、背诵、表演评分、陌生人带走 |

## P1 / P2 章节骨架

### `chapter_animal_park_visit`

Animal Park 是第一圈之后的可选散步，不阻断 P0。Elephant、Fox、Lion、Monkey、Panda、Zebra 都以温和装置、树影、长椅或小路牌存在。Pinecone 已经绑定 Monkey tree，可作为回访资源。

| 字段 | 内容 |
|---|---|
| 主要地点 | `place_animal_park` |
| 关键 anchor | E Elephant、F Fox、L Lion、M Monkey、P Panda、Z Zebra |
| 主要 NPC | Mina / Sunny / 环境触发 |
| 环境词 | elephant、fox、lion、monkey、panda、zebra、pinecone |
| 视觉资产需求 | Animal park gatelet、monkey tree、pinecone path、animal sign group |
| 回访路径 | 可选散步、pinecone resource、相册 Animal Park 页 |
| 禁止方向 | 不写动物园任务清单、收集完成率、危险动物接触 |

### `chapter_coast_soft_edge`

Coast Edge 是安全边界和远景感。Umbrella 和 X-mark Box 都只作为边界预览，不做每日必经。Shell 已经绑定 Umbrella，适合轻回访。

| 字段 | 内容 |
|---|---|
| 主要地点 | `place_coast_edge` |
| 关键 anchor | U Umbrella、X X-mark Box |
| 主要 NPC | Bus Helper / 环境触发 |
| 环境词 | coast、umbrella、shell、box、look |
| 视觉资产需求 | Umbrella coast shade、shell path、soft edge sign、X-mark box silhouette |
| 回访路径 | shell resource、相册 Coast Edge 页、天气雨后变化 |
| 禁止方向 | 不写独自远行、海边危险、寻宝压力或错过奖励 |

## 26 Anchor 故事索引

| Letter | Anchor | Chapter | 地点 | NPC / 触发者 | 新词 / 环境词 | Story Memory | Visual Hook | Review Path | 首批资产需求 |
|---|---|---|---|---|---|---|---|---|---|
| A | `anchor_a_apple` | `chapter_home_warm_start` | Home | Sunny | apple / photo / home | Apple welcome box beside a tiny family photo makes Home feel like the safe first stop. | Apple sticker photo frame | Start at Home, look at Apple corner, open album | Apple welcome box, photo frame |
| B | `anchor_b_bear` | `chapter_story_plaza_circle` | Town Plaza / Story Bench | Story Bear | bear / branch / book | Story Bear tucks a branch into an open book like a tiny bookmark. | Branch bookmark in Bear book | Pick branch, visit Story Bench, talk to Story Bear | Bear open book, branch bookmark |
| C | `anchor_c_clock` | `chapter_home_warm_start` | Home | Sunny | clock / chair / time | Clock corner ticks slowly while a cozy chair waits for morning. | Small chair under Clock | Look at Clock, return Home, place / view chair | Clock corner, cozy chair |
| D | `anchor_d_dog` | `chapter_home_warm_start` | Home | Sunny | dog / towel / Sunny | A soft towel rests near Sunny's Dog corner after a slow walk. | Folded towel with paw print | Return Home, check Sunny corner, album | Sunny towel, Dog corner |
| E | `anchor_e_elephant` | `chapter_animal_park_visit` | Animal Park | Environment | elephant / slide / hello | Elephant slide waits like a gentle hill in Animal Park. | Elephant-shaped slide | Optional Animal Park walk, album | Elephant slide prop |
| F | `anchor_f_fox` | `chapter_animal_park_visit` | Animal Park | Mina | fox / flower / path | A fox topiary peeks beside a small flower path. | Fox topiary with flower | Walk with Mina, look at fox path | Fox topiary, flower cluster |
| G | `anchor_g_gate` | `chapter_school_path_sky` | School Gate | Environment | gate / hello / school | School Gate bell says Hello without asking any questions. | Soft bell on gate | Look at School Gate, album | Gate bell, soft sign |
| H | `anchor_h_hat` | `chapter_shop_street_kindness` | Shop Street | Shopkeeper | hat / ribbon / shop | Ribbon curls beside the Hat sign and makes the shop window friendly. | Hat sign with ribbon loop | Walk Shop Street, find ribbon | Hat sign, ribbon basket |
| I | `anchor_i_ice_cream` | `chapter_shop_street_kindness` | Shop Street | Shopkeeper | ice cream / sticker / window | Ice cream sticker shines on the shop window like a cool little star. | Ice cream window sticker | Look at shop window, album | Ice cream sticker prop |
| J | `anchor_j_jacket` | `chapter_shop_street_kindness` | Shop Street | Shopkeeper | jacket / window / color | Jacket display hangs quietly beside the warm shop light. | Tiny jacket window | Shop front revisit | Jacket display |
| K | `anchor_k_kite` | `chapter_school_path_sky` | Home-School Walk / School Yard | Environment | kite / leaf / wind | A leaf turns under the Kite sky and points back to the school path. | Leaf spinning under Kite ribbon | Walk path, look up, collect leaf | Kite ribbon, spinning leaf |
| L | `anchor_l_lion` | `chapter_animal_park_visit` | Animal Park | Environment | lion / fountain / rest | Lion fountain sits near the park path like a quiet resting friend. | Lion fountain | Optional Animal Park album | Lion fountain |
| M | `anchor_m_monkey` | `chapter_animal_park_visit` | Animal Park | Environment | monkey / pinecone / tree | Pinecone waits below Monkey tree like a tiny climbing tower. | Pinecone under Monkey tree | Animal Park walk, collect pinecone | Monkey tree, pinecone |
| N | `anchor_n_net` | `chapter_school_path_sky` | School Yard | Environment | net / play / chalk | Net corner holds a chalk flower beside the play yard. | Soft play net with chalk flower | School Yard look event | Play net, chalk flower |
| O | `anchor_o_orange` | `chapter_shop_street_kindness` | Shop Street / Home | Shopkeeper / Sunny | orange / bowl / thank you | Sunny's bowl is round like a plate at the Orange stand. | Bowl with orange sticker | Visit Orange stand, return Home | Orange stand, bowl sticker |
| P | `anchor_p_panda` | `chapter_animal_park_visit` | Animal Park | Mina | panda / snack / bench | Panda sign waits near a quiet snack bench for a soft hello. | Panda snack bench | Optional park revisit | Panda bench sign |
| Q | `anchor_q_queen` | `chapter_story_plaza_circle` | Town Plaza | Story Bear | queen / poster / crown | Queen poster near Story Bench turns a story page into a tiny stage. | Crown poster near bench | Story Bench revisit | Queen poster, crown badge |
| R | `anchor_r_robot` | `chapter_school_path_sky` | School Yard | Environment | robot / corner / play | Robot corner blinks softly beside the yard toys, just to say hello. | Small friendly robot | School Yard look event | Robot corner prop |
| S | `anchor_s_sun` | `chapter_story_plaza_circle` | Sun Scene / Town Plaza | Environment | sun / flower / sunny | Flower under Sun Scene makes the town feel warm and awake. | Flower in sun patch | Sun Scene / flower resource / album | Sun patch, flower cluster |
| T | `anchor_t_taxi` | `chapter_story_plaza_circle` | Home / Plaza edge | Bus Helper | taxi / stone / sign | Stone near Taxi sign keeps a story page steady in the wind. | Stone on story page near taxi sign | Find stone, visit Bus Helper | Taxi sign, story stone |
| U | `anchor_u_umbrella` | `chapter_coast_soft_edge` | Coast Edge | Environment | umbrella / shell / coast | Shell rests near Umbrella coast path and keeps a tiny sea sound. | Shell beside umbrella shade | Coast walk, collect shell | Umbrella shade, shell |
| V | `anchor_v_violin` | `chapter_story_plaza_circle` | Town Plaza | Story Bear | violin / music / poster | Violin poster beside Story Bench makes the page feel like a soft song. | Violin poster | Story Bench / album | Violin poster |
| W | `anchor_w_watch` | `chapter_home_warm_start` | Home | Sunny | watch / wall / time | Wall charm hangs below Watch sign to remind Home that time can be slow. | Watch wall charm | Home wall revisit | Watch charm |
| X | `anchor_x_x_mark_box` | `chapter_coast_soft_edge` | Coast Edge | Environment | box / coast / look | X-mark box sits far away as a soft boundary, not a treasure race. | Small X box silhouette | Coast preview only | X box silhouette |
| Y | `anchor_y_yo_yo` | `chapter_school_path_sky` | School Yard | Environment | yo-yo / string / play | Yo-yo string curls beside the chalk flower after a gentle play break. | Coiled yo-yo string | School Yard revisit | Yo-yo string |
| Z | `anchor_z_zebra` | `chapter_animal_park_visit` | Animal Park | Environment | zebra / crossing / path | Zebra crossing sign marks the far animal path as a looking spot only. | Zebra crossing sign | Optional park edge preview | Zebra sign |

## 首批故事资产需求

| Asset ID 建议 | 类型 | 用途 | 依赖故事 | 优先级 |
|---|---|---|---|---|
| `story_prop.apple_welcome_photo_001` | prop | Home Apple welcome + photo hook | A / Home start | P0 |
| `story_prop.clock_corner_chair_001` | prop | Clock + chair cozy time | C / Home start | P0 |
| `story_prop.sunny_towel_paw_001` | prop | Sunny Dog corner towel | D / Home start | P0 |
| `story_prop.watch_wall_charm_001` | prop | Watch wall revisit | W / Home start | P0 |
| `story_prop.kite_leaf_path_001` | prop | Kite + leaf school path | K / School path | P0 |
| `story_prop.school_gate_bell_001` | prop | School Gate hello | G / School path | P0 |
| `story_prop.school_yard_net_chalk_001` | prop | Net / Robot / Yo-yo yard story | N/R/Y / School yard | P0 |
| `story_prop.shop_hat_ribbon_001` | prop | Hat + ribbon shop window | H / Shop Street | P0 |
| `story_prop.shop_icecream_orange_window_001` | prop | Ice cream / Orange shop front | I/O / Shop Street | P0 |
| `story_prop.story_bench_bear_book_001` | prop | Bear open book + branch bookmark | B / Town Plaza | P0 |
| `story_prop.plaza_violin_queen_poster_001` | prop | Q/V story plaza preview | Q/V / Town Plaza | P1 |
| `story_prop.animal_park_signs_001` | prop pack | E/F/L/M/P/Z animal park preview | Animal Park | P1 |
| `story_prop.coast_umbrella_shell_001` | prop | U shell / umbrella coast edge | Coast Edge | P1 |
| `story_prop.coast_x_box_001` | prop | X far edge boundary | Coast Edge | P2 |

## 交付给后续任务的输入

`V02-STORYLINE-003` 需要基于本总纲输出：

- 每条 P0 故事能否直接落在现有 Place / interaction cell。
- 哪些视觉钩子需要新增 Place、resource point、routine 或 interaction cell。
- 哪些内容只需要素材替换，不需要地图变更。
- P1 / P2 哪些只做预览，不进入 P0 主流程。

`V02-MOTION-001` 需要基于本总纲优先覆盖：

- Player walk / idle / interact。
- Sunny idle / walk / wag / greet / follow。
- Mina / Shopkeeper / Story Bear greet / idle / short walk。

`V02-ARTPIPE-001` 需要基于本总纲优先整理：

- P0 Home、School path、School Yard、Shop Street、Story Bench 的 story prop。
- Animal Park 和 Coast Edge 作为 P1/P2 预留资产包。
- 所有素材都必须有 logical asset ID，后续经 `ThemeProfile` / `AssetResolver` 接入。

## 验收结论

- 覆盖 26 个 A-Z anchor：通过。
- P0/P1/P2 分层：通过。
- 每个 anchor 有地点、触发者、环境词、story memory、visual hook、review path 和资产需求：通过。
- 不改 runtime、data、tests、assets：通过。
- 不重排 A-Z、不扩远郊 P0、不课程化 School：通过。

下一轮 Ready：`V02-STORYLINE-003 当前地图适配与内容生产蓝图`。
