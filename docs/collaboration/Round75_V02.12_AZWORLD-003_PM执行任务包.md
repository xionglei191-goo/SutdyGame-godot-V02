# Round 75 V02.12 AZWORLD-003 PM 执行任务包

> 日期：2026-06-05  
> Owner：Memory Palace / Narrative / Art Direction Agent  
> 状态：Ready  
> 任务：`V02-AZWORLD-003 17 个 reserved anchor 升级为可制作级规格`

## 任务目标

把 E/F/G/H/I/J/L/M/N/P/Q/R/U/V/X/Y/Z 共 17 个 reserved A-Z anchor 从规划级升级为可交给数据、场景、美术、叙事和 QA worker 制作的规格。交付重点是每个 anchor 的稳定地点、生活化故事、视觉钩子、可见入口、相册记录、素材规格和儿童安全边界。

本任务不改变 26 个核心 A-Z 记忆宫殿编码。`anchor_id`、`letter`、`core_word`、`route_order` 必须继续以 `data/anchors/az_core_anchors.json` 为事实来源；地图分布和 Home / School 双中心路线继续以 `data/maps/az_world_plan.json` 为事实来源。所有 anchor 必须先是 Sunshine Town 的生活物件、地点或温和环境线索，再承载英文环境层；不得做成课程牌、测验牌、词表墙、背诵入口或路线考试。

## 输入

- `data/anchors/az_core_anchors.json`：核心 `anchor_id`、`letter`、`core_word`、`route_order`、`card_id` 和 reserved/first_batch 状态事实来源。
- `data/maps/az_world_plan.json`：V02.12 Home / School 双中心、四层环线、17 个 reserved anchor 的 `district_id`、`world_place_id`、`map_ring`、`home_school_relation`、`story_memory`、`visual_hook`、`review_path`、`album_record`、`child_safety`。
- `docs/14_内容基线整理与首批内容规划.md`：A-Z 场景故事生产规则、剩余 17 个规划级 anchor 种子、儿童安全和英语环境层边界。
- `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`：V02.12 阶段拆分和 `V02-AZWORLD-003` 位置。
- `LESSON-005`：生活 RPG / 小镇养成是主目标，学习系统只能作为环境、收藏或可选活动。
- `LESSON-008`：内容生产必须先过合同验证，新增词和 anchor 回访必须绑定稳定记忆宫殿字段。
- `LESSON-009`：孩子端可玩必须有真实可见入口，隐藏 contract 按钮不能作为完成依据。
- `LESSON-010`：截图验收使用 MCP 或非 headless 显示路径，headless 只作为逻辑和合同回归。

## 范围

- 为 17 个 reserved anchor 补齐制作规格：地图位置、场景入口、叙事短线、视觉构图、素材清单、相册落账方式、未来轻事件 / NPC / 新词挂接建议。
- 明确每个 anchor 的最小可制作要求，保证下一轮 worker 可以按规格新增 JSON、场景节点、素材 ID、相册记录和 focused tests。
- 保持 17 个 anchor 仍是生活化探索与相册发现，不进入 P0 主线硬依赖；School 线 anchor 可服务 Home / School 起步路线，但不变成课程检查。
- 允许提出新增 logical asset ID、album clue ID、place interaction ID、NPC / weather / daily request 绑定建议；实际新增数据和运行时代码由后续实现任务执行。

## 不做范围

- 不修改 `todo.md`、`docs/12` 至 `docs/15`、`data`、`tests`、`scripts` 或任何运行时代码。
- 不改变任何核心 `anchor_id`、`letter`、`core_word`、`route_order`、`card_id`。
- 不启用完整 26 anchor 运行时互动，不把 17 个 reserved anchor 一次性写入主流程任务链。
- 不新增课程页、单元地图、答题、拼写检查、正确率、分数、等级、背诵、打卡、连续登录、倒计时或错过惩罚。
- 不把远郊 X / Z 做成每日必到地点，不触发真实离开小镇、赶车或独自远行。

## 交付物

- 一份制作级规格文档或数据草案，逐项覆盖 17 个 reserved anchor。
- 每个 anchor 至少包含：`anchor_id`、`letter`、`core_word`、`route_order`、`world_place_id`、`district_id`、`map_ring`、`home_school_relation`、可见入口、故事记忆、视觉钩子、素材要求、相册记录、儿童安全边界、后续轻事件 / NPC / 新词挂接建议。
- 美术交付清单：每个 anchor 至少 1 个主视觉资产 logical asset ID 建议，必要时补 1 个状态 / 装饰 / 缩略图 asset ID 建议。
- 相册交付清单：每个 anchor 至少 1 条 album record / clue 建议，明确照片标题、缩略图内容和落账触发。
- 入口交付清单：每个 anchor 至少 1 个孩子端真实可见 `看看` 或生活动作入口建议，明确从哪个 place / NPC / weather / daily request 可到达。
- QA 交付清单：focused 合同检查点、玩家可见入口检查点、儿童安全文本扫描点和双视口截图点建议。
- 下一轮衔接说明：哪些内容交给 Data / Godot / Art / QA worker，哪些必须等待 `V02-AZWORLD-004` 0 基础主线挂接。

## 17 个 Reserved Anchor 最小规格要求

| Letter | anchor_id | core_word | route_order | 地图位置 | 最小制作规格 |
|---|---|---|---:|---|---|
| E | `anchor_e_elephant` | Elephant | 5 | `district_school_center` / `place_playground` / `center` | School 旁大象滑梯。入口从 School Yard 或 Playground `看看` 触发；主资产为低矮大象滑梯、圆耳朵遮阳板和小脚印；相册为 `Elephant Slide`；文案强调路过看看和安全地面，不引导攀爬、排队竞争或速度评价。 |
| F | `anchor_f_fox` | Fox | 6 | `district_daily_town` / `place_garden` / `first_ring` | Garden 转角狐狸灌木。入口从花园散步、采小花或雨后花园 `看看` 触发；主资产为狐狸灌木、蓬松尾巴、脚边小花；相册为 `Fox Topiary`；狐狸必须是温和造型，不追逐、不惊吓、不做野生动物危险叙事。 |
| G | `anchor_g_gate` | Gate | 7 | `district_school_center` / `place_school_gate` / `center` | School Gate 安全入口。入口从 Home 到 School 主路或校门 `看看` 触发；主资产为圆拱校门、小铃铛、欢迎小旗；相册为 `School Gate`；Gate 不能作为封锁、资格判断、迟到惩罚或课程入口。 |
| H | `anchor_h_hat` | Hat | 8 | `district_daily_town` / `place_clothes_shop` / `first_ring` | Shop Street 大帽子招牌。入口从 Shop Street、服装橱窗或晴天阴影 `看看` 触发；主资产为帽子招牌、帽檐阴影、彩色缎带；相册为 `Hat Sign`；不得强制购买、评价穿着或制造外貌比较。 |
| I | `anchor_i_ice_cream` | Ice cream | 9 | `district_daily_town` / `place_shop_street` / `first_ring` | 街角冰淇淋车贴纸。入口从 Shop Street 散步、节日贴纸或食物词故事 `看看` 触发；主资产为冰淇淋车、小伞、不会滴落的甜筒牌；相册为 `Ice Cream Cart`；只做看一眼也开心的生活物件，不制造消费、糖分焦虑或奖励诱导。 |
| J | `anchor_j_jacket` | Jacket | 10 | `district_daily_town` / `place_clothes_shop` / `first_ring` | 雨后服装橱窗 Jacket。入口从 Clothes Shop 橱窗、雨天问候或 Shop Street `看看` 触发；主资产为夹克、挂钩、雨滴贴纸、暖色橱窗；相册为 `Jacket Window`；不评价孩子穿着、不暗示没穿对会失败。 |
| L | `anchor_l_lion` | Lion | 12 | `district_expansion_town` / `place_bookshop` / `second_ring` | Bookshop Plaza 狮子喷泉。入口从 Bookshop 扩展、故事熊回访或广场散步 `看看` 触发；主资产为狮子喷泉、书页形水花、石座；相册为 `Lion Fountain`；喷泉不可引导靠近水边、攀爬或吼叫惊吓。 |
| M | `anchor_m_monkey` | Monkey | 13 | `district_expansion_town` / `place_park` / `second_ring` | Park 树上 Monkey 装置。入口从 Park 资源点、树枝委托或动物相册 `看看` 触发；主资产为树上猴子装置、弯树枝、低矮木牌；相册为 `Park Monkey`；不能鼓励爬树、荡绳、追逐或危险模仿。 |
| N | `anchor_n_net` | Net | 14 | `district_school_center` / `place_sports_corner` / `center` | School Sports Corner 软网。入口从 School Yard、风天叶子或运动角 `看看` 触发；主资产为软网、叶子、低矮支架；相册为 `Soft Net`；不表现输赢比赛、淘汰、排名、技巧评分或体育压力。 |
| P | `anchor_p_panda` | Panda | 16 | `district_expansion_town` / `place_bookshop` / `second_ring` | Bookshop 附近 Panda 休息角。入口从 Bookshop、休息角或故事熊旁 `看看` 触发；主资产为熊猫靠垫、竹叶杯垫、圆形茶点桌；相册为 `Panda Corner`；休息角不评价表现，不把安静坐好做成纪律考核。 |
| Q | `anchor_q_queen` | Queen | 17 | `district_expansion_town` / `place_theatre` / `second_ring` | Theatre 前 Queen 故事海报。入口从 Theatre 外、Story Show 预留或节日装饰 `看看` 触发；主资产为皇冠海报、星星贴纸、剧场帘布；相册为 `Queen Poster`；Queen 只作为故事装饰，不涉及真实权力、身份优劣、性别刻板或表现评价。 |
| R | `anchor_r_robot` | Robot | 18 | `district_school_center` / `place_school_yard` / `center` | School 工具角 Robot 导视。入口从 School Yard、工坊预留或颜色词故事 `看看` 触发；主资产为圆润机器人牌、胸口小灯、工具箱；相册为 `Robot Sign`；Robot 不连接开放聊天、不冒充真实 AI、不发布指令或评分。 |
| U | `anchor_u_umbrella` | Umbrella | 21 | `district_expansion_town` / `place_park` / `second_ring` | Park 长椅旁大 Umbrella。入口从 Park 回访、雨天相册或晴天散步 `看看` 触发；主资产为大伞、长椅、雨滴 / 阳光双状态贴纸；相册为 `Umbrella Bench`；不制造天气危险、避险恐惧、必须出门或打卡压力。 |
| V | `anchor_v_violin` | Violin | 22 | `district_expansion_town` / `place_music_corner` / `second_ring` | Music Corner 小舞台 Violin。入口从 Music Corner、Theatre 节日或声音相册 `看看` 触发；主资产为小提琴、音符灯、舞台边地毯；相册为 `Violin Corner`；不要求演奏、节奏跟打、评分、才艺比较或公开表演压力。 |
| X | `anchor_x_x_mark_box` | X-mark Box | 24 | `district_far_edge` / `place_airport_cargo` / `far_edge` | Far Edge 安全失物箱。入口只从远期交通边缘预览、失物箱轻事件或相册故事 `看看` 触发；主资产为圆角箱子、X 胶带、贴纸角；相册为 `X-mark Box`；远郊不成为 P0 每日路线，不写机场出行、独自离开、陌生人取物或宝藏竞争。 |
| Y | `anchor_y_yo_yo` | Yo-yo | 25 | `district_school_center` / `place_school_yard` / `center` | School 活动角 Yo-yo。入口从 School Yard、玩具角或放学整理 `看看` 触发；主资产为悬挂溜溜球、彩绳、收纳小盒；相册为 `Yo-yo Corner`；不做技巧挑战、连击、排行榜或玩具没收压力，只表达玩具可以放回原位。 |
| Z | `anchor_z_zebra` | Zebra | 26 | `district_far_edge` / `place_zoo_edge` / `far_edge` | Zoo Edge 花坛旁 Zebra 图案线。入口只从远期动物相册、交通安全氛围或边界预览 `看看` 触发；主资产为斑马线、斑马小牌、路边花坛；相册为 `Zebra Edge`；不引导独自过马路、进动物园、追动物或离开安全区域。 |

## 素材 / 相册 / 入口要求

- 素材必须通过 logical asset ID 进入后续 `ThemeProfile` / `AssetResolver`，运行时代码不得硬编码具体图片路径。
- 建议命名：主资产使用 `az_anchor_<letter>_<word>_main`，相册缩略图使用 `album_az_<letter>_<word>_thumb`，状态装饰使用 `az_anchor_<letter>_<word>_<state>`。
- 每个 anchor 至少有一个可从地图上识别的主轮廓，移动端 960x540 下也能看出核心物件，不依赖小字说明。
- 英文只作为物件名、招牌、相册标题或 NPC 短句环境层；孩子端主要反馈使用温和中文。
- 每个相册记录必须绑定 `card_id` 或后续 card state，不显示正确率、等级、星级、完成百分比、课程进度或背诵状态。
- 每个入口必须是孩子端真实可见的 `看看`、NPC 对话、天气轻事件、资源点旁路过或生活动作，不得只靠隐藏按钮、测试脚本或后台合同调用证明。
- School 线 E/G/N/R/Y 可以作为 Home / School 起步路线的环境 anchor，但仍不得作为上课资格、考试路线或顺序背词门槛。
- X/Z 远郊 anchor 只能作为预留景物和相册故事，默认不进入 P0 日常、每日委托高频池或 0 基础主线硬依赖。

## 儿童安全禁区

- 禁止课程化表达：课程牌、测验牌、单元门、背诵墙、词表墙、正确率、错题、等级、分数、排名、考试纸。
- 禁止时间压力：倒计时、迟到、赶车、错过、补签、连续登录、限时奖励、今天不做就损失。
- 禁止出行风险：独自远行、陌生人带走、真实离开小镇、机场出发、过马路任务、靠近水边或攀爬引导。
- 禁止消费和表现焦虑：强制购买、买不起失败、穿着评价、才艺评分、运动输赢、技巧连击、公开表演压力。
- 禁止恐吓或羞愧：动物追逐、机器人命令、天气危险、宠物责任羞愧、玩具没收、门禁资格判断。
- 禁止让英语成为主流程门槛：看见英文可以获得环境记忆，但不能要求孩子读出、拼写、选择、复述或按字母顺序拜访。

## 验收标准

- 17 个 reserved anchor 均有制作级规格，且数量人工核对为 17：E/F/G/H/I/J/L/M/N/P/Q/R/U/V/X/Y/Z。
- 每项规格保留原始 `anchor_id`、`letter`、`core_word`、`route_order`，与 `az_core_anchors.json` 和 `az_world_plan.json` 一致。
- 每项规格都有可见入口、生活化 `story_memory`、明确 `visual_hook`、相册记录、素材 ID 建议和儿童安全边界。
- 任一 anchor 都不是课程牌、测验牌、词表墙、背诵入口或顺序路线考试。
- School / Home 中心路线继续成立；E/G/N/R/Y 等 School 线 anchor 不破坏 P0 Home / School 安全起步；X/Z 远郊不阻断 P0。
- 美术规格能被拆成主资产、缩略图和可选状态装饰；运行时接入必须走 logical asset ID。
- 后续实现任务必须能用 focused 合同测试验证 17 个规格字段完整、ID 唯一、引用有效和儿童安全文本合规。
- 玩家可玩验收必须通过真实可见入口证明相册落账，不能只通过服务直调或隐藏 contract 按钮。

## 建议验证命令

文档规格任务本身不改运行时代码；完成后建议执行以下只读 / 回归检查：

```bash
rg -n "anchor_[efghijlmnpqruvxyz]|课程|测验|背诵|正确率|倒计时|赶车|独自远行" docs/collaboration/Round75_V02.12_AZWORLD-003_PM执行任务包.md
godot --headless --path . --quit
godot --headless --path . --script tests/test_v0212_az_world_plan.gd
godot --headless --path . --script tests/headless_runner.gd
```

后续实现任务新增数据 / 脚本后，还需要补 focused tests，至少覆盖：

- 17 个 reserved anchor 的制作级字段存在且非空。
- `anchor_id`、`letter`、`core_word`、`route_order` 未变化。
- 每个 anchor 的 album record、visible entry 和 logical asset ID 可解析。
- 儿童安全禁词和课程化文案扫描。
- 代表入口在 1280x720 与 960x540 下无明显遮挡，截图取证走 MCP 或非 headless 显示路径。

## 下一轮衔接

- Data / Content worker：把本任务包中的 17 项规格转为后续可验证 JSON 或内容合同草案，补齐 album clue、visible entry、asset logical ID 和 NPC / weather / request 绑定字段。
- Godot Dev worker：按 Data 规格实现最小可见 `看看` 入口和相册落账，优先 School 线 E/G/N/R/Y 与 Daily Town F/H/I/J，远郊 X/Z 保持预览级。
- Art Direction / Asset worker：按 logical asset ID 产出主视觉、缩略图和必要状态装饰，先保证移动端轮廓和生活物件感。
- QA worker：建立 focused contract test、玩家可见入口 smoke、儿童安全文本扫描和双视口截图点，不使用 hidden contract button 作为完成依据。
- PM 下一轮：在 `V02-AZWORLD-003` 验收后，再推进 `V02-AZWORLD-004 Home / School 0 基础主线挂接位`；0 基础内容只能挂在 Home / School 生活事件里，孩子端仍不显示课程、单元、测试或背诵。
