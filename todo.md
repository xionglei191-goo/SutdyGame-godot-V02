# StudyGame V02 项目 TODO

> 最后更新：2026-06-04  
> 状态事实来源：本文件  
> 当前阶段：方向纠偏 - 生活 RPG / 小镇养成 MVP  
> 当前里程碑：从学习闭环原型转为可移动、可探索、可互动、可装饰的小镇生活原型

## 维护规则

- `[ ]` 待办：尚未进入本轮。
- `[~]` 进行中：已进入本轮并正在实施。
- `[!]` 阻塞：存在明确阻塞条件，需记录原因和解除方式。
- `[x]` 完成：交付物存在、验证通过、验收标准满足。
- 每轮开工前更新“当前状态面板”；完成后更新任务状态、完成记录和 `lessons.md`。
- 任务不得仅因代码或文档已写完而完成；必须通过对应验收。
- 新需求先进入待办并明确阶段、依赖、Owner 和验收标准。

## 当前状态面板

| 项目 | 当前状态 |
|---|---|
| 当前轮次 | Round 19：每日轻委托 MVP |
| 本轮目标 | 完成 Mina 请求一根 `branch` 的本地每日轻委托，覆盖接取、收集、交付、奖励、去重和保存 |
| 进行中 | 无 |
| Ready | `V02-MAP-003` |
| 汇合任务 | 下一汇合点为地图编辑层与运行时小镇体验 |
| 阻塞项 | 无 |
| 待确认决策 | 无 |
| 临时默认值 | Home/Town Plaza/Shop；Mina/Shopkeeper/Pet Buddy；家具 `wooden_chair`；材料 `branch`；A-Z 锚点常驻地图；Letter Snake 仅可选 |

## 方向纠偏：生活 RPG / 小镇养成 MVP

> 旧的学习闭环、Memory Card、Letter Snake、Voice/AI stub 保留为技术资产和可选系统；A-Z 记忆宫殿保留为世界地图底层编码和潜意识学习方法。后续主线改为小镇生活、NPC 关系、收集、商店和家园装饰，但地图必须持续承载字母锚点。

- [x] **V02-RESET-001 重写产品定位**  
  Owner：PM Agent；交付物：`docs/01_产品总纲.md`；验收：明确生活 RPG / 小镇养成为第一目标，英语降级为环境层。
- [x] **V02-RESET-002 重写核心玩法循环**  
  Owner：PM / Game Design Agent；交付物：`docs/06_核心玩法循环.md`；验收：主循环为探索、NPC、收集、商店、家园装饰和长期回访。
- [x] **V02-RESET-003 重写开发路线与工作规范**  
  Owner：PM Agent；交付物：`docs/12_V02开发路线.md`、`AGENTS.md`、`todo.md`；验收：Ready 队列指向生活 RPG MVP，不再指向学习闭环扩展。
- [x] **V02-RESET-004 明确 A-Z 记忆宫殿地图植入原则**  
  Owner：PM / Memory Palace Agent；交付物：`docs/01_产品总纲.md`、`docs/04_A-Z记忆宫殿与记忆卡系统.md`、`docs/05_世界结构与地图编辑架构.md`；验收：每个字母必须有世界锚点，作为潜意识记忆编码植入，不以考试形式显性推进。
- [x] **V02-RESET-005 明确新单词故事必须绑定记忆宫殿编码**  
  Owner：PM / Memory Palace / Curriculum Agent；交付物：`docs/04_A-Z记忆宫殿与记忆卡系统.md`、`docs/14_内容基线整理与首批内容规划.md`；验收：新增单词必须有 `letter`、`core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook`、`review_path`。

## 生活 RPG MVP：角色、小镇、NPC、收集与家园

- [x] **V02-LIFE-001 实现玩家角色移动与触屏控制**  
  Owner：Godot Dev Agent；依赖：V02-CORE-001、V02-RUNTIME-001；交付物：Player 节点、移动脚本、碰撞和相机跟随；验收：玩家可在 Home/Town Plaza/Shop 间移动，触屏和键盘调试均可用。
- [x] **V02-LIFE-002 调整运行时地图为可探索小镇**  
  Owner：Map / Godot Dev Agent；依赖：V02-LIFE-001；交付物：Home、Town Plaza、Shop 的探索布局；验收：地图不是静态信息面板，玩家能在场景中行走和触发热点，首批 A-Z 锚点有固定位置和可感知表现。
- [x] **V02-LIFE-003 接入动物居民固定互动**  
  Owner：Narrative / Godot Dev Agent；依赖：V02-AI-001、V02-VOICE-002；交付物：Mina、Shopkeeper、Pet Buddy 的场景互动入口；验收：可对话、可保存一次关系或每日问候状态。
- [x] **V02-LIFE-004 建立资源与背包最小系统**  
  Owner：Godot Dev Agent；依赖：V02-CORE-004；交付物：资源点、InventoryService、材料数据；验收：可捡起 `branch` 并保存到背包。
- [x] **V02-LIFE-005 改造商店为家具/生活物品购买**  
  Owner：Godot Dev Agent；依赖：V02-LIFE-004、V02-SHOP-001；交付物：家具商品数据和购买流程；验收：可购买 `wooden_chair`，coins 扣减并保存。
- [x] **V02-LIFE-006 实现家园装饰 MVP**  
  Owner：Godot Dev / UI Agent；依赖：V02-LIFE-001、V02-LIFE-005；交付物：房间网格、家具摆放/收起、HomeState 保存；验收：购买家具后可在家中摆放，重启后位置保留。
- [x] **V02-LIFE-007 生活 MVP smoke test**  
  Owner：QA Agent；依赖：V02-LIFE-001 至 V02-LIFE-006；交付物：headless 或服务级 smoke test；验收：起床、出门、对话、收集、购买、回家摆放、保存全链路通过。
- [x] **V02-LIFE-008 降级学习系统入口**  
  Owner：PM / Godot Dev Agent；依赖：V02-LIFE-007；交付物：Memory Album 和 Letter Snake 入口调整说明或实现；验收：孩子端主流程不再被学习任务驱动，Letter Snake 仅作为可选活动。
- [x] **V02-LIFE-009 A-Z 锚点潜意识植入审计**  
  Owner：Memory Palace / QA Agent；依赖：V02-LIFE-002；交付物：26 个 anchor 的地图位置、表现物件和路线顺序审计；验收：A-Z 锚点不是 UI 装饰，能在生活地图中形成稳定路径记忆。
- [x] **V02-LIFE-010 新词故事编码数据审计**  
  Owner：Curriculum / Memory Palace / QA Agent；依赖：V02-LIFE-009；交付物：首批新词的锚点绑定和故事记忆审计；验收：每个新词都能追溯到字母锚点、地图地点、视觉钩子和生活回访路径。
- [x] **V02-LIFE-011 地图上下文互动层**  
  Owner：Godot Dev / UX Agent；依赖：V02-LIFE-008；交付物：统一 `Interact` / `Use` 操作、附近 NPC/资源/商店/家园对象检测、面板调试按钮降级；验收：玩家移动到附近对象后用同一个操作完成对话、收集、购买和摆放，远离对象时返回无目标或距离不足。
- [x] **V02-LIFE-012 解耦地点进入与生活动作**  
  Owner：Godot Dev / UX Agent；依赖：V02-LIFE-011；交付物：中性的 place entry 互动结果、独立的商店购买/家园摆放/邻居帮助触发路径；验收：进入 Home、Town Start、Supermarket 不自动发 coins、不自动购买、不自动摆放，生活动作仍可通过显式对象或后续轻委托触发并通过测试。
- [x] **V02-LIFE-013 每日轻委托 MVP**  
  Owner：Game Design / Godot Dev / Narrative Agent；依赖：V02-LIFE-003、V02-LIFE-004、V02-LIFE-012；交付物：首个本地每日轻委托数据与服务、Mina 请求 branch 的 NPC 互动、奖励与关系保存；验收：接取、收集、交付、奖励、当日去重和重载保存通过 headless 测试，孩子端不出现学习压力文案，Letter Snake 不作为完成条件。

## 阶段 0：框架与管理基线

- [x] **V02-BASE-001 产品定位与体验原则**  
  Owner：PM Agent；交付物：`docs/01_产品总纲.md`、`docs/02_目标用户与体验原则.md`；验收：目标用户、产品边界、儿童端与家长端原则明确。
- [x] **V02-BASE-002 学习与 A-Z 基线**  
  Owner：Curriculum / Memory Palace Agent；依赖：V02-BASE-001；交付物：`docs/03_英语学习与0基础进阶体系.md`、`docs/04_A-Z记忆宫殿与记忆卡系统.md`；验收：0 基础阶梯和稳定 A-Z 编码原则明确。
- [x] **V02-BASE-003 世界、玩法与系统设计基线**  
  Owner：PM / Game Design Agent；依赖：V02-BASE-001；交付物：`docs/05` 至 `docs/10`；验收：地图、主循环、NPC/语音、小游戏、家长后台和美术边界明确。
- [x] **V02-BASE-004 技术架构与开发路线**  
  Owner：Godot Dev / PM Agent；依赖：V02-BASE-003；交付物：`docs/11_Godot技术架构.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`；验收：技术分层、阶段路线、任务和测试标准明确。
- [x] **V02-BASE-005 首批内容基线**  
  Owner：Curriculum / PM Agent；依赖：V02-BASE-002；交付物：`docs/14_内容基线整理与首批内容规划.md`；验收：首批场景、卡片、事件、NPC、语音和小游戏内容明确。
- [x] **V02-BASE-006 项目接管与首轮任务包**  
  Owner：PM Agent；依赖：V02-BASE-004；交付物：`docs/15_项目经理接管与下一阶段执行计划.md`、`docs/collaboration/首轮任务包_阶段1启动.md`；验收：近期里程碑、优先级、风险和首轮任务明确。
- [x] **V02-BASE-007 协作与贡献规范**  
  Owner：PM Agent；交付物：`AGENTS.md`、`docs/collaboration/多Agent协作规范_v0.2.md`、`docs/collaboration/任务交接模板.md`；验收：任务分配、交付和验收流程明确。
- [x] **V02-BASE-008 项目执行台账与经验库**  
  Owner：PM Agent；依赖：V02-BASE-006；交付物：`todo.md`、`lessons.md`；验收：覆盖阶段 0-8，建立每轮状态与经验维护规则。
- [x] **V02-BASE-009 统一首批 anchor 数量描述**  
  Owner：PM / Memory Palace Agent；依赖：V02-BASE-005；交付物：修正内容基线中的“8 个”为“9 个”；验收：文字数量与 A/B/C/D/K/O/S/T/W 一致，并复核相关文档。
- [x] **V02-BASE-010 确认首测设备与自动测试方案**  
  Owner：PM / Godot Dev / QA Agent；依赖：V02-CORE-001；交付物：Android 屏幕基线和测试 runner 决策记录；验收：后续任务无需再决定测试入口与首测尺寸。

## 阶段 1：Godot 项目骨架

- [x] **V02-CORE-001 创建 Godot 4.x 移动端项目骨架**  
  Owner：Godot Dev Agent；依赖：V02-BASE-006；交付物：`project.godot`、可运行主场景；验收：Godot 可打开，`godot --headless --path . --quit` 正常退出。
- [x] **V02-CORE-002 建立基础目录结构**  
  Owner：Godot Dev Agent；依赖：V02-CORE-001；交付物：`scenes/`、`scripts/`、`data/`、`assets/`、`tests/`；验收：路径符合技术架构并有最小运行说明。
- [x] **V02-CORE-003 配置共享工具路径与 Git 忽略规则**  
  Owner：Godot Dev Agent；交付物：`.gitignore`、`config/shared_tools_paths.env.example`、共享工具说明；验收：凭据、Godot 缓存、共享工具副本和日志被排除。
- [x] **V02-CORE-004 建立 Local SaveService stub**  
  Owner：Godot Dev Agent；依赖：V02-CORE-001；交付物：SaveService 脚本与测试；验收：profile、GameState、LearningRecord 可往返保存。
- [x] **V02-CORE-005 建立 ThemeProfile 与 AssetResolver 占位**  
  Owner：Asset / Godot Dev Agent；依赖：V02-CORE-002；交付物：主题数据和资源解析器；验收：玩法脚本不硬编码具体资产路径。

## 阶段 2：地图编辑与运行时生成

- [x] **V02-MAP-001 定义 WorldMap/Place/Road/District Resource 与最小 JSON**  
  Owner：Map Tool Agent；依赖：V02-CORE-001/002；交付物：Resource、schema 说明、`world_map.json`；验收：Home/Town Start/Supermarket 和 9 个首批 anchor 可加载。
- [x] **V02-MAP-002 建立 EditorOnly proxy 节点结构**  
  Owner：Map Tool Agent；依赖：V02-MAP-001；交付物：WorldOverviewScene 编辑层；验收：可拖动 place marker，运行时不依赖 EditorOnly。
- [ ] **V02-MAP-003 实现 grid overlay**  
  Owner：Map Tool Agent；依赖：V02-MAP-002；交付物：编辑器网格；验收：编辑 cell 与运行时逻辑 cell 一致。
- [ ] **V02-MAP-004 实现 road cell 编辑**  
  Owner：Map Tool Agent；依赖：V02-MAP-003；交付物：道路编辑工具；验收：可添加、删除道路 cell。
- [ ] **V02-MAP-005 实现 occupied/interaction cell 编辑**  
  Owner：Map Tool Agent；依赖：V02-MAP-003；交付物：碰撞与交互编辑工具；验收：interaction 不允许落在 occupied。
- [ ] **V02-MAP-006 实现地图编辑撤销/重做**  
  Owner：Map Tool Agent；依赖：V02-MAP-004/005；交付物：editor command stack；验收：地图编辑操作可撤销和重做。
- [ ] **V02-MAP-007 实现地图 JSON 导入/导出**  
  Owner：Map Tool Agent；依赖：V02-MAP-001/006；交付物：MapEditorSyncService；验收：JSON 往返后数据一致。
- [x] **V02-MAP-008 实现地图校验脚本**  
  Owner：QA / Map Tool Agent；依赖：V02-MAP-001；交付物：校验服务和测试；验收：非法 ID、区域、道路连接、交互点和 A-Z 顺序可拦截。
- [x] **V02-RUNTIME-001 实现 RuntimeMapBuilder**  
  Owner：Godot Dev Agent；依赖：V02-CORE-001/002、V02-MAP-001；交付物：运行时地图生成器；验收：从 JSON 显示 Home、Town Start、Supermarket 占位。
- [x] **V02-RUNTIME-002 生成 TileMapLayer 和 roads**  
  Owner：Godot Dev Agent；依赖：V02-RUNTIME-001；交付物：运行时地面与道路；验收：地面和道路正确可见。
- [x] **V02-RUNTIME-003 生成 landmark、hotspot 和 collision**  
  Owner：Godot Dev Agent；依赖：V02-RUNTIME-002、V02-MAP-005；交付物：运行时对象；验收：点击和碰撞与数据一致。
- [x] **V02-RUNTIME-004 生成完整 A-Z anchor markers**  
  Owner：Godot Dev Agent；依赖：V02-RUNTIME-001、V02-AZ-001；交付物：anchor layer；验收：26 个 anchor 数据完整，首批 9 个可见或可互动。

## 阶段 3：A-Z 与 Memory Card

- [x] **V02-AZ-001 提取 A-Z core anchor 表**  
  Owner：Memory Palace Agent；依赖：V02-BASE-009；交付物：26 个 core anchor 数据；验收：A=Apple，`route_order` 1-26 唯一。
- [x] **V02-AZ-002 绑定 0 基础词与教材来源**  
  Owner：Curriculum Agent；依赖：V02-AZ-001；交付物：curriculum refs；验收：每张 core card 有来源或补齐标记。
- [x] **V02-CARD-001 实现 MemoryCardService**  
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-AZ-001；交付物：卡片状态服务和测试；验收：Seen/Heard/Played/Collected/Shiny 可保存。
- [x] **V02-CARD-002 设计并实现 Memory Album 第一版**  
  Owner：UI/UX / Godot Dev Agent；依赖：V02-CARD-001、V02-CORE-005；交付物：相册 UI；验收：孩子端像收藏相册，不像单词表。

## 阶段 4：Home / Pet / Shop / Coins 主循环

- [x] **V02-LOOP-001 定义宠物食物循环状态与奖励规则**  
  Owner：Game Design Agent；依赖：V02-BASE-005；交付物：事件、状态变化、coins 和奖励规则；验收：完整闭环可实现且无强考核表达。
- [x] **V02-PET-001 实现 PetService**  
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-LOOP-001；交付物：宠物状态服务和测试；验收：Sunny/Dog 可饿、可喂、可反馈。
- [x] **V02-SHOP-001 实现 ShopService**  
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-LOOP-001；交付物：商店购买服务和测试；验收：coins 可购买食物并保存。
- [x] **V02-QUEST-001 实现 QuestEventService 最小版**  
  Owner：Godot Dev Agent；依赖：V02-PET-001、V02-SHOP-001；交付物：事件服务；验收：宠物需求可触发小游戏和购买链。
- [x] **V02-UI-001 设计并实现触屏 Home/Pet UI**  
  Owner：UI/UX / Godot Dev Agent；依赖：V02-CORE-005、V02-PET-001；交付物：Home/Pet 场景与 UI；验收：横屏手机和平板触控区域足够。
- [x] **V02-LOOP-002 接通主循环端到端流程**  
  Owner：Godot Dev / QA Agent；依赖：V02-QUEST-001、V02-MINI-003、V02-CARD-001、V02-UI-001；交付物：可玩闭环和 smoke test；验收：从宠物饿到喂食、反馈、卡片和保存全链路通过。

## 阶段 5：小游戏框架与 Letter Snake

- [x] **V02-MINI-001 定义 Letter Snake 规则与配置**  
  Owner：Minigame Agent；依赖：V02-LOOP-001、V02-AZ-002；交付物：四组目标、结果和奖励配置；验收：支持目标字母/单词且任意分数有奖励。
- [x] **V02-MINI-002 实现 MinigameService**  
  Owner：Godot Dev Agent；依赖：V02-MINI-001、V02-CARD-001；交付物：小游戏服务；验收：可启动、返回结果、写学习记录和发奖励。
- [x] **V02-MINI-003 实现 Letter Snake 原型**  
  Owner：Godot Dev Agent；依赖：V02-MINI-002；交付物：小游戏场景；验收：分数转换为 coins 和 card progress，能返回原场景。
- [x] **V02-MINI-004 测试奖励差异与无失败表达**  
  Owner：QA Agent；依赖：V02-MINI-003；交付物：奖励测试；验收：低分有奖励、高分更多，孩子端无 failed/wrong/test。

## 阶段 6：语音、NPC 与 AI 本地桩

- [x] **V02-VOICE-001 定义 VoiceLine schema**  
  Owner：Voice/AI Agent；依赖：V02-BASE-005；交付物：语音数据；验收：支持 text、audio_id、TTS/录音/跟读预留字段。
- [x] **V02-VOICE-002 实现 VoiceService stub**  
  Owner：Godot Dev Agent；依赖：V02-VOICE-001；交付物：语音服务和测试；验收：mock 播放和录音调用不报错、不申请权限。
- [x] **V02-AI-001 定义 NPC profile/memory schema**  
  Owner：Voice/AI / Narrative Agent；依赖：V02-BASE-005；交付物：NPC profile、memory 和固定对白数据；验收：首批 NPC 均有安全边界与本地数据。
- [x] **V02-AI-002 实现 LLMClient stub**  
  Owner：Godot Dev Agent；依赖：V02-AI-001；交付物：AI client；验收：返回固定安全占位回复，不连接真实模型。
- [x] **V02-AI-003 实现 ConversationSummary stub**  
  Owner：Godot Dev Agent；依赖：V02-AI-001/002；交付物：摘要服务；验收：可生成并保存家长端可读的本地摘要。
- [x] **V02-NPC-001 接入首批固定 NPC 对话**  
  Owner：Narrative / Godot Dev Agent；依赖：V02-AI-001、V02-VOICE-002；交付物：Mina、Shopkeeper、Pet Buddy、Bus Helper、Story Bear 对话；验收：无真实 AI 时可完成首期互动。

## 阶段 7：家长后台与本地摘要

- [x] **V02-PARENT-001 定义家长入口与触屏流程**  
  Owner：UI/UX Agent；依赖：V02-BASE-001；交付物：入口和 UI 规格；验收：不进入孩子主流程。
- [x] **V02-PARENT-002 实现 ParentDashboardStore stub**  
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-AI-003、V02-MINI-002；交付物：dashboard 数据服务；验收：可读取 card/minigame/NPC 本地摘要。
- [x] **V02-PARENT-003 校验孩子端不显示后台内容**  
  Owner：QA Agent；依赖：V02-PARENT-001/002；交付物：可见性测试；验收：主流程无家长报告 UI。
- [x] **V02-PARENT-004 实现本地家长摘要界面**  
  Owner：UI/UX / Godot Dev Agent；依赖：V02-PARENT-001/002；交付物：本地 dashboard；验收：家长可查看摘要与设置，孩子端流程不受影响。

## 阶段 8：远期能力

> 本阶段任务必须在第一阶段主循环验收后才能进入 Ready；每项仍需单独设计、隐私评审和范围确认。

- [ ] **V02-FUTURE-001 实现 AccountAdapter 与本地账号迁移接口**  
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-LOOP-002；验收：不改变现有本地 profile 行为，可替换账号后端。
- [ ] **V02-FUTURE-002 实现 Cloud Save 与冲突处理**  
  Owner：Godot Dev / QA Agent；依赖：V02-FUTURE-001；验收：多设备同步、离线恢复和冲突策略通过测试。
- [ ] **V02-FUTURE-003 实现 ContentPackLoader 与内容包更新**  
  Owner：Godot Dev / Curriculum Agent；依赖：V02-MAP-007、V02-CARD-001；验收：内容包可校验、安装、回滚且不覆盖核心 A-Z 编码。
- [ ] **V02-FUTURE-004 接入真实 TTS、录音与跟读能力**  
  Owner：Voice/AI / Godot Dev Agent；依赖：V02-VOICE-002、家长隐私审批；验收：权限、隐私、失败降级和移动端性能通过评审。
- [ ] **V02-FUTURE-005 接入真实 AI NPC 与长期记忆**  
  Owner：Voice/AI / Godot Dev Agent；依赖：V02-AI-003、家长隐私审批；验收：内容安全、角色边界、摘要和降级策略通过评审。
- [ ] **V02-FUTURE-006 实现异步互访与家长批准好友**  
  Owner：Godot Dev / QA Agent；依赖：V02-FUTURE-001/002；验收：无陌生人开放社交，权限和举报流程通过评审。
- [ ] **V02-FUTURE-007 实现受控多人互动**  
  Owner：Godot Dev / Game Design Agent；依赖：V02-FUTURE-006；验收：仅预设短语、表情或受控合作玩法，儿童安全通过评审。
- [ ] **V02-FUTURE-008 实现第二主题与主题包切换**  
  Owner：Asset / Godot Dev Agent；依赖：V02-CORE-005、V02-FUTURE-003；验收：无需修改玩法脚本即可切换主题。
- [ ] **V02-FUTURE-009 完成 Android/iOS/平板深度适配**  
  Owner：Godot Dev / UI/UX / QA Agent；依赖：V02-LOOP-002；验收：目标设备上的性能、触控、安全区、音频和存档通过测试。
- [ ] **V02-FUTURE-010 建立 AI 辅助内容生产与人工审核管线**  
  Owner：Curriculum / Voice/AI / QA Agent；依赖：V02-FUTURE-003；验收：候选内容可追溯、规则校验、人工批准后才可发布。

## 跨阶段质量门槛

- [ ] **V02-QA-001 数据合同测试集**：schema load、JSON round-trip、ID 唯一、A-Z 顺序和地图校验全部通过。
- [ ] **V02-QA-002 运行时 smoke 测试集**：地图加载、卡片状态、Pet/Shop/Coins、小游戏奖励、Voice/AI stub 全部通过。
- [ ] **V02-QA-003 儿童体验检查**：孩子端无强考核、课程表、失败惩罚、家长报告或开放陌生人社交。
- [ ] **V02-QA-004 移动端验收**：目标横屏设备上的触控区域、安全区、布局和性能通过。

## 完成记录

| 日期 | 轮次 | 完成事项 | 验证依据 |
|---|---|---|---|
| 2026-06-04 | 项目接管 | V02-BASE-001 至 V02-BASE-008、V02-CORE-003 | 对应文档与配置文件存在并完成内容复核；Godot `4.6.3.stable` 可用 |
| 2026-06-04 | Round 1 | V02-BASE-009、V02-BASE-010 | anchor 描述已统一为 9 个；测试 runner 与 Android 视口基线已写入执行计划 |
| 2026-06-04 | Stage 0 收尾 | V02-BASE-007 工作标准对齐 | `AGENTS.md` 已更新为阶段 1 目标、台账流程、技术标准与产品边界 |
| 2026-06-04 | Round 1 验收 | V02-CORE-001/002、V02-MAP-001/008、V02-RUNTIME-001 | Godot 主场景与编辑器加载通过；JSON 断言通过；headless 合同与运行时 loader 测试通过 |
| 2026-06-04 | Round 2 验收 | V02-CORE-004/005、V02-RUNTIME-002 | SaveService、AssetResolver、运行时道路/地点/anchor 可视化通过独立测试和统一 headless runner |
| 2026-06-04 | Round 3 验收 | V02-AZ-001、V02-LOOP-001、V02-MINI-001 | A-Z core、宠物食物循环、Letter Snake 配置与内容引用测试全部通过 |
| 2026-06-04 | Round 4 验收 | V02-AZ-002、V02-CARD-001、V02-PET-001、V02-SHOP-001 | 扩展卡、MemoryCardService、PetService、ShopService 通过独立测试与汇合引用测试 |
| 2026-06-04 | Round 5 验收 | V02-MINI-002、V02-QUEST-001 | MinigameService、QuestEventService 与服务级 Sunny 食物循环 smoke 通过；V02-LOOP-002 因缺 Letter Snake 场景和触屏 UI 保持待办 |
| 2026-06-04 | Round 6 验收 | V02-MINI-003、V02-UI-001、V02-LOOP-002、V02-MINI-004 | Letter Snake 原型、Home/Pet 触屏入口、可玩主循环 smoke、奖励差异与禁用词测试通过 |
| 2026-06-04 | Round 7 验收 | V02-CARD-002、V02-RUNTIME-003、V02-RUNTIME-004 | Memory Album、运行时 hotspot/collision、完整 26 个 A-Z anchor marker 通过全量回归 |
| 2026-06-04 | Round 8 验收 | V02-VOICE-001/002、V02-AI-001/002/003、V02-PARENT-002 | VoiceService、NPCMemoryStore、LLMClient、ConversationSummaryService、ParentDashboardStore 本地 stub 测试通过 |
| 2026-06-04 | Round 9 验收 | V02-LIFE-001/002/003 | 主场景新增 LifeRPGPanel、Player 移动/点击移动、碰撞阻挡、Mina/Shopkeeper/Pet Buddy 标记和 NPC 关系存档；`test_life_rpg_scene`、`headless_runner`、旧 playable loop smoke 通过 |
| 2026-06-04 | Round 10 验收 | V02-LIFE-004/005/006 | 新增 life item 数据、InventoryService、LifeShopService、HomeDecorationService；主场景可捡 branch、买 wooden_chair、摆放家具并保存；`test_life_services`、`test_life_rpg_scene`、`headless_runner` 通过 |
| 2026-06-04 | Round 11 验收 | V02-LIFE-007/009/010 | 生活 MVP smoke 已覆盖移动、NPC、收集、购买、摆放、保存；`world_map.memory_anchors` 扩展为 26 个 A-Z 锚点；`test_memory_palace_embedding` 校验锚点顺序和新词故事编码绑定 |
| 2026-06-04 | Round 12 验收 | V02-LIFE-008 | 主场景新增可选活动面板，Memory Album / Letter Snake 保留为 side activities；Sunny 主流程通过 Help Neighbor 生活动作获得 coins，不再要求 Letter Snake；`test_playable_loop_smoke`、`test_life_rpg_scene`、`headless_runner` 通过 |
| 2026-06-04 | Round 13 验收 | V02-LIFE-011 | 主场景 LifeRPGPanel 降级 Pick/Buy/Place 调试按钮为统一 `Interact`；`interact_nearby()` 覆盖 NPC 对话、branch 收集、超市购买、家门口摆放和空格无目标反馈；`test_life_rpg_scene` 通过 |
| 2026-06-04 | Round 14 验收 | V02-NPC-001 | 主场景生成 Mina、Shopkeeper、Pet Buddy、Bus Helper、Story Bear 五个 NPC marker；统一 `interact_nearby()` 使用 profile fallback 本地固定对白，写入 `npc_relationships` 和 `npc_memory.recent_events`，无网络/真实 AI；`test_life_rpg_scene`、`test_ai_npc_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 15 验收 | V02-PARENT-001/003 | 新增家长入口触屏流程合同和 `Main.get_parent_entry_spec()`；孩子端主导航移除 `Parent`，`test_life_rpg_scene` 与 `test_playable_loop_smoke` 扫描可见文本，验证主流程无家长后台/报告 UI |
| 2026-06-04 | Round 16 验收 | V02-PARENT-004 | 新增独立 `ParentDashboard` 场景和脚本，读取 `ParentDashboardStore` 展示本地概览、卡片、活动、NPC 摘要和隐私设置；`test_parent_dashboard_scene` 验证 parent-only、本地无账号/网络/录音且孩子端未挂载 dashboard |
| 2026-06-04 | Round 17 验收 | V02-MAP-002 | `WorldOverviewScene` 编辑层生成 `EditorOnlyProxyRoot` 和 place proxy marker，支持测试移动 marker 且不写回 JSON；运行时 `Main` 和 `RuntimeMapBuilder` 不依赖 EditorOnly；`test_world_overview_editor_proxy`、`headless_runner` 通过 |
| 2026-06-04 | Round 18 验收 | V02-LIFE-012 | Home、Town Start、Supermarket 入口统一返回 `place_entry`，只更新中性地点状态，不再自动发 coins、购买 `wooden_chair` 或摆放家具；显式 Help Neighbor、购买和摆放动作仍可用；`test_life_rpg_scene`、`test_playable_loop_smoke`、`test_life_services`、`headless_runner` 通过 |
| 2026-06-04 | Round 19 验收 | V02-LIFE-013 | 新增 `DailyRequestService` 和 `data/life/daily_requests.json`；Mina 可接取 branch 轻委托，收集后交付会消耗 branch、发 6 coins、写入 Mina 关系和 NPC memory，同日重复不重复奖励；`test_daily_request_service`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`test_life_services`、`headless_runner` 通过 |
