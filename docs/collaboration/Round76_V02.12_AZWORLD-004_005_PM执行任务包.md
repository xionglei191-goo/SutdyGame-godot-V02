# Round 76 V02.12 AZWORLD-004 / 005 PM 执行任务包

> 日期：2026-06-05  
> Owner：Curriculum / Narrative / PM / QA Agent，QA / PM / Godot Dev Agent  
> 状态：Ready  
> 任务：`V02-AZWORLD-004 Home / School 0 基础主线挂接位`、`V02-AZWORLD-005 合同测试、回归验证和截图验收口径`

## 任务目标

在 `V02-AZWORLD-001` 已建立 Home / School 双中心和 26 个 A-Z anchor 世界规划合同的基础上，为 Home / School 第一主线预留 0 基础英语挂接位，并建立后续实现进入 V02.12 收口前必须通过的合同测试、回归验证和截图验收口径。

本任务包只定义执行边界、数据 / 文案原则、交付物和验收门槛。0 基础内容只能作为 Home、School、Home-School Walk、Morning Plaza 等生活事件里的内部挂接，不做孩子端课程页、单元页、测试、背诵、词表或学习闯关。

## 输入

- `data/maps/az_world_plan.json`：Home / School 双中心、四层环线、26 anchor 分布和 `future_curriculum_hooks`。
- `scripts/data/az_world_plan_contract.gd`：V02.12 A-Z 世界规划合同校验器。
- `tests/test_v0212_az_world_plan.gd` 与 `tests/headless_runner.gd`：当前 focused / headless 回归基线。
- `docs/14_内容基线整理与首批内容规划.md` 的 V02.12 世界结构、A-Z 路线分布、合同字段和验收边界。
- `LESSON-005`：英语和学习系统只能是环境层 / 收藏 / 可选活动，不能重新成为主线推进条件。
- `LESSON-008`：内容生产必须先过合同验证。
- `LESSON-009`：孩子端可玩必须有真实可见入口。
- `LESSON-010`：截图验收不要依赖 headless dummy renderer。

## 范围

### V02-AZWORLD-004 范围

- 建立 Home / School 第一主线的 0 基础挂接表或等价规划结构。
- 覆盖 `family`、`home`、`room`、`clock`、`dog`、`bag`、`school`、`gate`、`play`、`look`、`go`、`good morning` 等首批词 / 短句。
- 为每个挂接位绑定生活场景、A-Z anchor、故事画面、视觉钩子、回访路径、孩子端可见表达和内部 curriculum tag。
- 优先绑定 Home 线与 School 线：A Apple、C Clock、D Dog、W Watch、E Elephant、G Gate、K Kite、N Net、R Robot、Y Yo-yo。
- 可引用第一圈生活地点作为辅助回访，但不得让 Shop、Bookshop、Bus Stop 或远郊预留成为第一主线硬依赖。

### V02-AZWORLD-005 范围

- 明确 V02.12 世界规划、0 基础挂接和儿童安全文案的合同测试口径。
- 建立 focused/headless 回归范围，确保 A-Z 世界规划进入全量 runner。
- 建立后续实现截图点：Home、School、Home-School Walk、Morning Plaza 或 School Gate、代表远郊预留。
- 输出截图验收记录模板或可复用口径，后续实现者按此取证。
- 区分逻辑验证和截图取证：headless 用于合同 / 回归，截图使用 MCP 或非 headless 显示路径。

## 不做范围

- 不新增运行时主线任务链，除非后续 Godot Dev 任务明确接手。
- 不把教材章节、课本单元、课程目标或测试要求展示给孩子。
- 不改 26 个核心 anchor 的 `anchor_id`、`letter`、`core_word`、`route_order`。
- 不重排 Home / School 双中心和四层环线。
- 不新增联网、账号、云存档、真实 AI、真实语音评测、排名、连续登录或限时活动。
- 不要求孩子按 A-Z 顺序走完整路线。

## 0 基础词 / 短句挂接原则

- 每个词 / 短句必须先落到一个生活动作或地点，再落到英语环境层。例如 `good morning` 是 Home 起床 / School Gate 早晨问候，不是晨读任务。
- 每个挂接位必须有稳定内部 ID，建议形如 `foundation_home_good_morning_001`，并包含 `foundation_tag`、`phrase_or_word`、`scene_id`、`anchor_id`、`storyline_hook`、`child_facing_line`、`review_path`、`safety_note`。
- 孩子端可以看到短、温和、生活化的中文句子，英语只作为物件名、招牌、短问候、相册标题或 NPC 一句话自然出现。
- 同一个词可以多点回访，但必须有主 anchor；例如 `clock` 主挂 C Clock，`dog` 主挂 D Dog，`gate` 主挂 G Gate，`play` 主挂 K Kite / School Yard。
- `family`、`home`、`room` 应优先在 Home / Room / 小屋整理里出现；不要要求孩子说明家庭结构或填个人信息。
- `bag` 可绑定 Home-School Walk、School Gate 或玩家背包整理；不要做检查书包、漏带惩罚或上学焦虑。
- `go`、`look` 应作为操作语义和 NPC 温和提示；不要变成指令考试或速度要求。
- `good morning` 只能是问候和相册短句；不要要求跟读、评分或重复背诵。
- 所有 `curriculum_refs`、教材版本、课本页码、CEFR / 年级信息只能进入内部字段，孩子端不可见。

## 建议首批挂接表

| 词 / 短句 | 主场景 | 推荐 anchor | 孩子端表达方向 | 内部意图 |
|---|---|---|---|---|
| `home` | Home 门口 / 小屋 | A Apple | 从家门口慢慢出发 | 认识 Home 起点 |
| `family` | Home 客厅 / 照片墙 | A Apple / W Watch | 家里的照片在等你回来 | 家庭归属感 |
| `room` | 小屋整理 | W Watch / C Clock | 整理自己的小角落 | 房间物件名 |
| `clock` | Home 小桌 | C Clock | 圆钟说今天慢慢开始 | 时间物件 |
| `dog` | Sunny 角落 | D Dog | Sunny 在家里摇尾巴 | 宠物朋友 |
| `bag` | Home-School Walk / School Gate | G Gate | 小包包陪你走到校门 | 上学携带物 |
| `school` | School Gate / School Yard | G Gate / E Elephant | 学校门口亮着小旗 | 学校地点 |
| `gate` | School Gate | G Gate | 小铃铛在校门旁轻轻响 | 安全入口 |
| `play` | School Yard / Playground | K Kite | 风筝在操场上挥手 | 玩耍动作 |
| `look` | 所有 `看看` 入口 | K Kite / B Bear | 看一眼，记在相册里 | 观察动作 |
| `go` | Home-School Walk | G Gate / T Taxi | 我们慢慢走过去 | 移动动作 |
| `good morning` | Home 早晨 / School Gate | C Clock / G Gate | 早上好，今天也慢慢来 | 温和问候 |

## 交付物

### V02-AZWORLD-004

- Home / School 0 基础挂接位规划文档或数据草案，覆盖首批词 / 短句。
- 每个挂接位绑定一个主生活场景和一个主 A-Z anchor。
- 每个挂接位包含孩子端可见表达、内部 curriculum tag、故事画面、视觉钩子和回访路径。
- 明确禁止孩子端显示课程 / 单元 / 测试 / 背诵 / 词表的文案规则。

### V02-AZWORLD-005

- Focused contract test 更新或新增计划，覆盖 0 基础挂接字段完整性、anchor 绑定、禁用文案和远郊不阻断。
- `tests/headless_runner.gd` 注册计划或实际注册记录。
- 双视口截图验收口径，至少覆盖 1280x720 与 960x540。
- 截图验收记录模板，包含截图文件名、视口、路径、观察点、通过 / 失败判断。
- V02.12 阶段收口标准和阻塞判定。

## 验收标准

- 首批词 / 短句均有稳定内部挂接位，且不作为孩子端硬性学习目标显示。
- 每个挂接位都绑定 Home / School 生活事件、A-Z anchor、故事画面、视觉钩子和回访路径。
- Home / School 双中心不被改写；A-Z 26 anchor 的核心 ID、字母、核心词和路线顺序不变。
- `family`、`home`、`room`、`clock`、`dog` 优先落在 Home / 小屋 / Sunny 生活路径。
- `school`、`gate`、`bag`、`play`、`look`、`go`、`good morning` 优先落在 School / Home-School Walk / School Gate / School Yard。
- 远郊 X / Z 等预留 anchor 不成为 P0 主线、0 基础词挂接或截图必经路径。
- 合同测试能拦截缺失 anchor 绑定、缺失 `foundation_tag`、孩子端禁用文案、远郊主线依赖和课程化压力词。
- Headless runner 通过；Godot headless 启动通过。
- 截图覆盖 Home、School、Home-School Walk 和代表远郊预留，且无明显遮挡、文字溢出、工程占位或课程化文案。

## 儿童端禁用文案

孩子端 UI、NPC 对话、相册、HUD、按钮、弹层和截图中不得出现以下方向：

- 课程、单元、课本第几页、今日学习目标、学习任务。
- 测试、测验、考试、答题、闯关、评分、正确率、错题、排名。
- 背诵、默写、词表、单词清单、必须记住、复习打卡。
- 连续登录、倒计时、错过、补签、失败、惩罚、奖励翻倍。
- 你还不会、做错了、落后了、必须完成才能去学校。

可用替代表达：

- “看一眼，记在相册里。”
- “早上好，今天也慢慢来。”
- “小包包陪你走到校门。”
- “Sunny 在家里等你。”
- “校门的小铃铛轻轻响。”

## 建议验证命令

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script scripts/data/az_world_plan_contract.gd
godot --headless --path . --check-only --script tests/test_v0212_az_world_plan.gd
godot --headless --path . --script tests/test_v0212_az_world_plan.gd
godot --headless --path . --script tests/test_az_core_data.gd
godot --headless --path . --script tests/test_memory_palace_embedding.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

如后续实现新增独立 0 基础挂接数据或服务，还需补充：

```bash
godot --headless --path . --check-only --script <新增脚本>
godot --headless --path . --script <新增 focused test>
```

## 截图验收口径

截图取证使用 MCP 或非 headless 显示路径；headless dummy renderer 只负责逻辑回归。每个截图需记录视口、路径、主要观察点和失败判定。

| 截图点 | 建议视口 | 必看内容 | 失败判定 |
|---|---|---|---|
| Home morning | 1280x720、960x540 | Home、Clock / Dog / Room 生活物件，温和早晨短句 | 出现课程 / 单元 / 测试 / 词表，或 HUD 遮挡主物件 |
| Home-School Walk | 1280x720、960x540 | 从 Home 到 School 的安全路线，Bag / Go / Look 语义自然 | 路线像强制闯关、倒计时、赶路压力或按钮溢出 |
| School Gate | 1280x720、960x540 | School、Gate、Good morning，校门为安全入口 | Gate 表现为封锁、资格判断、答题门或失败状态 |
| School Yard / Playground | 1280x720、960x540 | Play / Kite / Elephant 等学校生活锚点 | Play 被做成测验、排名、速度挑战或强制完成 |
| Far Edge reserve | 1280x720 或 960x540 代表图 | X / Z 等远郊只作为预留边界和相册世界感 | 远郊成为第一主线必经、独自远行、赶车或出行焦虑 |

截图记录建议文件名：

- `shot_v0212_azworld004_home_morning_1280.png`
- `shot_v0212_azworld004_home_school_walk_960.png`
- `shot_v0212_azworld004_school_gate_1280.png`
- `shot_v0212_azworld004_school_yard_960.png`
- `shot_v0212_azworld005_far_edge_reserve_1280.png`

## V02.12 阶段收口标准

V02.12 只有在以下条件全部满足后才能收口：

- `V02-AZWORLD-001` 至 `V02-AZWORLD-005` 均有交付物和验收记录。
- Home / School 双中心、四层环线、26 anchor 分布和远郊预留边界稳定。
- 17 个 reserved anchor 已具备可制作级规格，或明确记录为后续阶段 P1 / P2 预留且不阻断 P0。
- Home / School 0 基础挂接位覆盖首批词 / 短句，并全部绑定生活事件和 anchor。
- 合同测试、focused test、headless runner 和 Godot headless 启动通过。
- 双视口截图覆盖 Home、School、Home-School Walk 和代表远郊预留。
- 孩子端截图和可见文本中没有课程、单元、测试、背诵、词表、评分、倒计时、错过或运营压力。
- 后续进入运行时实现前，PM 已确认英语仍是环境层，生活 RPG / cozy town 主循环不被学习门槛替代。

## 改动文件

- `docs/collaboration/Round76_V02.12_AZWORLD-004_005_PM执行任务包.md`
