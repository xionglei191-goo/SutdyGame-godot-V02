# StudyGame V02 项目 TODO

> 最后更新：2026-06-04  
> 状态事实来源：本文件  
> 当前阶段：阶段 6/7 - 本地语音、NPC、AI 与家长摘要 stub 收口  
> 当前里程碑：首个可玩闭环已跑通，下一步接入固定 NPC 对话和家长入口/可见性检查

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
| 当前轮次 | Round 8：语音、NPC 与家长摘要 stub |
| 本轮目标 | 定义 VoiceLine/NPC 数据，建立 VoiceService、LLMClient、摘要和家长后台数据 stub |
| 进行中 | 无 |
| Ready | `V02-NPC-001`、`V02-PARENT-001`、`V02-PARENT-003` |
| 汇合任务 | 无；下一汇合点为 NPC 固定对白与家长后台入口集成 |
| 阻塞项 | 无 |
| 待确认决策 | 无 |
| 临时默认值 | 首批 9 个 anchor；Sunny/Dog；Home/Town Start/Supermarket |

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
- [ ] **V02-MAP-002 建立 EditorOnly proxy 节点结构**  
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
- [ ] **V02-NPC-001 接入首批固定 NPC 对话**  
  Owner：Narrative / Godot Dev Agent；依赖：V02-AI-001、V02-VOICE-002；交付物：Mina、Shopkeeper、Pet Buddy、Bus Helper、Story Bear 对话；验收：无真实 AI 时可完成首期互动。

## 阶段 7：家长后台与本地摘要

- [ ] **V02-PARENT-001 定义家长入口与触屏流程**  
  Owner：UI/UX Agent；依赖：V02-BASE-001；交付物：入口和 UI 规格；验收：不进入孩子主流程。
- [x] **V02-PARENT-002 实现 ParentDashboardStore stub**  
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-AI-003、V02-MINI-002；交付物：dashboard 数据服务；验收：可读取 card/minigame/NPC 本地摘要。
- [ ] **V02-PARENT-003 校验孩子端不显示后台内容**  
  Owner：QA Agent；依赖：V02-PARENT-001/002；交付物：可见性测试；验收：主流程无家长报告 UI。
- [ ] **V02-PARENT-004 实现本地家长摘要界面**  
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
