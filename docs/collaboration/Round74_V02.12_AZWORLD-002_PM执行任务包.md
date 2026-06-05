# Round 74 V02.12 AZWORLD-002 PM 执行任务包

> 日期：2026-06-05  
> Owner：Map / UX / QA Agent  
> 状态：Ready  
> 任务：`V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划`

## 任务目标

基于 `V02-AZWORLD-001` 已完成的 Home / School 双中心和 26 个 A-Z anchor 分布合同，规划 Sunshine Town 世界地图的区域层级、道路骨架、环线结构和儿童安全边界。目标是让孩子能从 Home 出发，稳定走到 School、Town Plaza、Shop、小屋、A-Z anchor 和轻回访地点；地图应像温暖小镇生活空间，而不是课程地图、闯关线路、考试路线或远郊冒险。

本轮只做可执行规划和验收口径，不落地数据、场景、脚本或测试实现。

## 输入

- `data/maps/az_world_plan.json`：V02.12 世界规划数据源，包含 Home / School 双中心、26 anchor 分布、区域层级和 P0/P1/P2 边界。
- `scripts/data/az_world_plan_contract.gd`：现有世界规划合同口径。
- `todo.md` 当前 Ready：`V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划`。
- V02-AZWORLD-001 验收事实：Home / School 为世界地图中心；A/C/D/W 覆盖 Home 线；E/G/K/N/R/Y 覆盖 School 线；X/Z 等远郊锚点不成为 P0 主流程硬依赖。
- 现有生活主路径：Home、School、Town Plaza、Shop、小屋、Mina、Sunny、店长、故事熊、巴士哥哥、Bookshop、Bus Stop、资源点、相册和 A-Z 回访入口。
- `LESSON-009`：孩子端可玩必须有真实可见入口。
- `LESSON-010`：截图验收不要依赖 headless dummy renderer。

## 范围

- 规划 Home / School 双中心关系：Home 是日常出发、安全返回和小屋生活中心；School 是儿童生活、0 基础挂接和 E/G/K/N/R/Y 等 School 线 anchor 的中心。
- 规划四层区域结构：
  - `center`：Home、School、Town Plaza、Shop、小屋入口、P0 NPC 与 P0 资源点。
  - `first_ring`：Home-School Walk、Bookshop、Bus Stop、Bear Corner、Kite Yard、Garden、Near River 等可轻松回访区域。
  - `second_ring`：更完整的 A-Z anchor 回访带、季节 / 天气线索、P1 轻事件和扩展资源点。
  - `far_edge`：X/Z 等远郊记忆锚点、观景点、边缘故事线索；只作为 P2 或未来扩展，不阻断 P0。
- 规划 Home-School Walk：从 Home 到 School 的安全步行主路，必须清楚、短、可往返，并串起 0 基础学习挂接所需的生活化场景，而不是课堂式关卡。
- 规划道路和环线：
  - P0 主路：Home -> Town Plaza / Shop / School 的清晰路线。
  - First Ring loop：围绕 Home / School 的轻环线，支持日常散步和 A-Z 近场回访。
  - Second Ring loop：承接更多 anchor、天气线索和 P1 支线，不影响 P0。
  - Far Edge spur：远郊只能是支路或可选外缘，不允许成为 Home、School、Shop、小屋或 P0 anchor 的必经通道。
- 规划安全边界：软边界、家长可理解的安全提示、视觉阻挡、返回点、不可进入区域说明和迷路恢复口径。
- 输出给下一轮 Data Contract / Godot Dev / QA 可直接执行的字段建议、检查清单和验证命令。

## 交付物

- 一份世界地图区域与道路规划文档，建议命名为 `docs/collaboration/Round74_V02.12_AZWORLD-002区域道路安全规划.md`，包含区域表、道路表、环线表、安全边界表和 P0/P1/P2 分级。
- Home / School 双中心动线说明，明确 Home-School Walk 的入口、出口、沿途节点、可见提示和返回策略。
- `center`、`first_ring`、`second_ring`、`far_edge` 的 anchor / NPC / 资源 / 支线承载建议。
- 远郊不阻断 P0 的硬性检查清单，至少覆盖 X/Z 和任意未来 P2 边缘地点。
- 面向下一轮数据化的字段建议，例如 `zone_id`、`ring_level`、`route_id`、`is_p0_required`、`safe_return_node_id`、`edge_boundary_type`、`blocks_p0_if_missing`。
- 验收记录草案，记录本轮没有修改 `data`、`scripts`、`tests`、`todo.md` 或 `docs/12-15`。

## 验收标准

- Home / School 双中心清晰：孩子能理解“从家出发、去学校、回家休息”，且两者都不是单纯课程入口。
- Home-School Walk 是 P0 安全路线：路径短、可往返、入口可见、沿途不含危险、陌生人带走、赶时间、倒计时或考试压力。
- `center` 和 `first_ring` 足够承载 P0：Home、School、Town Plaza、Shop、小屋、Mina、Sunny、店长、基础资源和核心近场 anchor 不依赖 `second_ring` 或 `far_edge`。
- `second_ring` 只扩展回访和探索深度：缺失、未开放或未实现时，不阻断 P0 主流程、商店、小屋、NPC 日常、相册或 Home-School Walk。
- `far_edge` 只作为远郊可选探索：X/Z 等远郊 anchor 有稳定记忆位置，但不要求孩子先到远郊才能完成 P0 日常或基础 A-Z 近场体验。
- 道路规划至少包含一条 P0 主路、一条 first_ring 环线、一条 second_ring 环线和若干 far_edge 支路，并标明每条路线的用途、优先级、安全返回点和是否可缺省。
- 安全边界不使用惩罚、失败、体力耗尽、走丢恐吓或真实出行风险；只能使用温和提示、视觉边界、陪伴式返回和“今天先在这里玩”的表达。
- 文档没有把英语学习改成课程、测试、背诵、单词钻题或 Letter Snake 主线；英文只作为 ambient layer、地名、牌子、短句、相册标签和可选活动存在。
- 本轮只新增 PM / Map / UX / QA 文档，不修改 `todo.md`、`docs/12-15`、`data`、`tests`、`scripts`。

## 禁区

- 不修改 `todo.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`。
- 不修改 `data`、`tests`、`scripts`、`scenes` 或任何运行时代码。
- 不重排 26 个 A-Z anchor 的稳定世界结构，不改变已完成合同中的核心 ID、中心原则或远郊边界。
- 不把 School 做成课程选择页、考试入口、词表入口、背诵路线或强制学习关卡。
- 不把 Home-School Walk 做成限时上学、迟到惩罚、通勤压力、独自远行或陌生人护送。
- 不引入真实地图、联网定位、真实学校数据、账号、社交、广告、运营活动或连续登录。
- 不把 far_edge 变成 P0 必经路径，不用 X/Z 阻断 Home、School、Shop、小屋、Mina 或基础资源。

## 安全边界

- P0 区域必须始终有安全返回：Home、School、Town Plaza、Shop、小屋和 Home-School Walk 上任意关键节点都应能回到 Home 或中心路。
- 远郊入口必须有可理解的温和提示，例如“前面是以后一起看的远处风景”，不能出现“危险”“禁止”“失败”“走丢”等恐吓式表达。
- 道路视觉应避免暗巷、车流穿越、悬崖边缘、深水强诱导、陌生人带路、独自离镇等儿童不安全意象。
- Bus Stop / Taxi / far_edge 只表达小镇边缘和未来旅行想象，不触发真实离开小镇、赶车、错过班次或被带走。
- School 区域表达上学生活、操场、书包、花园、公告牌和朋友问候，不出现分数、排名、作业惩罚或考试倒计时。
- 地图迷路恢复应是陪伴式：轻提示、路牌、返回按钮、熟悉 NPC 指路或自动回到最近安全点。

## 建议验证命令

本轮交付是文档规划，原则上不需要改动运行时代码；建议执行轻量文档和现有合同回归：

```bash
test -f docs/collaboration/Round74_V02.12_AZWORLD-002_PM执行任务包.md
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script scripts/data/az_world_plan_contract.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

如下一轮开始修改数据或运行时代码，再补充 focused test，例如 `tests/test_v0212_az_world_plan.gd` 或后续新增的地图路径合同测试。

## 下一轮衔接

- `V02-AZWORLD-003` 建议进入 Data Contract / Map / QA：把本轮区域、道路、环线和安全边界规划落入 `az_world_plan` 的结构化字段，并扩展合同验证。
- `V02-AZWORLD-004` 建议进入 Godot Dev / UX：在运行时地图或可见入口中体现 Home-School Walk、first_ring 轻环线、second_ring 可选探索和 far_edge 温和边界。
- `V02-AZWORLD-005` 建议进入 QA：做 Home -> School -> Shop -> Home、小屋、Mina、A-Z 近场 anchor、second_ring 可选点和 far_edge 不阻断 P0 的 smoke / 截图验收。
- 下一轮必须继续保持 Home / School 双中心，继续保护远郊不阻断 P0，并让 0 基础和课本挂接只保留在内部合同字段，不在孩子端显示课程化压力。
