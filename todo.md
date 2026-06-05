# StudyGame V02 项目 TODO

> 最后更新：2026-06-05
> 状态事实来源：本文件
> 当前阶段：V02.7A 美术基线重建
> 当前里程碑：工程可玩闭环已完成，先重建可信 Sunshine Town 首屏，再推进每日小镇生活纵切

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
| 当前轮次 | Round 54：V02.7A 美术基线重建规划与启动 |
| 本轮目标 | 重评现有 P0/P1 素材状态，固定 Sunshine Town 首屏视觉目标，避免把占位资产误当最终美术 |
| 进行中 | V02-ARTBASE-001 首屏视觉目标与资产降级审计 |
| Ready | V02-ARTBASE-001 首屏视觉目标与资产降级审计 |
| 汇合任务 | 已完成：地图编辑层、运行时小镇体验、远期本地 stub、QA 汇合、主界面视觉修正、首屏 Playfield 化、Sprite2D 小镇资产化、孩子端中文界面、HUD 顶底栏收纳、顶部 HUD 单行压缩、底部操作栏精简、底部按钮儿童化视觉、背包气泡内容恢复、V02.1 每日小镇、V02.2 我的小屋、V02.3 小镇记忆宫殿、V02.4 内容生产框架、Round 48 真实可玩路径修复、Round 49 美术与策划路线更新、V02.5 美术素材生产线文档清单、V02.6 策划内容生产线、V02-POLISH-001、V02-POLISH-002、V02-POLISH-003、V02-POLISH-004 |
| 阻塞项 | 无 |
| 待确认决策 | 无 |
| 临时默认值 | 单一 storybook/cozy town 美术方向；素材必须有逻辑 asset ID；Home/Town Plaza/Shop；Mina/Shopkeeper/Pet Buddy；家具 `wooden_chair`；材料 `branch`；A-Z 锚点常驻地图；Letter Snake 仅可选；账号/云存档/语音/AI/社交均为本地 stub |

## 本轮分工

| 小组 | 任务 | 当前状态 | 备注 |
|---|---|---|---|
| Art Direction / Asset | V02-ART-001 美术资产目录与命名规范 | 完成 | 素材分类、逻辑 asset ID、状态和交付字段已写入 `docs/10` |
| Map / Asset | V02-ART-002 首批小镇场景素材清单 | 完成 | Home、Town Plaza、Shop、Bookshop、Bus Stop、道路、树、花、资源点清单已写入 `docs/10` |
| Narrative / Asset | V02-ART-003 首批角色与宠物素材清单 | 完成 | 玩家、Mina、店长、Sunny、故事熊、巴士哥哥清单已写入 `docs/10` |
| Home Design / Asset | V02-ART-004 家具与家园素材清单 | 完成 | 小桌、地毯、花盆、宠物碗、小床、墙饰清单已写入 `docs/10` |
| UI / Asset / UX | V02-ART-005 UI 图标与状态素材清单 | 完成 | 金币、点心、宠物状态、背包、相册、商店、设置/退出清单已写入 `docs/10` |
| Game Design / Narrative | V02-DESIGN-001 NPC 内容生产规范 | 完成 | NPC 字段、文本长度、关系阶段、轻委托对白和儿童安全边界已写入 `docs/14` |
| Game Design / Narrative | V02-DESIGN-002 每日轻委托内容包规划 | 完成 | 15 条每日轻委托规划已写入 `docs/14` |
| Game Design / Economy / Home Design | V02-DESIGN-003 商店与家具轮换策划 | 完成 | 商品分类、价格区间、轮换节奏和非惩罚经济已写入 `docs/14` |
| Memory Palace / Narrative / Curriculum | V02-DESIGN-004 A-Z 场景故事扩展规划 | 完成 | 26 个 anchor 的场景故事、视觉钩子和回访路径已写入 `docs/14` |
| Game Design / Narrative / UX | V02-DESIGN-005 节日与天气轻事件规划 | 完成 | 晴天、雨天/雨后、微风、集市日、儿童节、小镇庆祝等轻事件已写入 `docs/14` |
| UX / Godot / QA | V02-POLISH-001 退出与设置入口 | 完成 | 顶部设置入口、设置面板、休息二次确认、回到安全位置和操作级测试已接入 |
| QA / UI / Art Direction | V02-POLISH-002 玩家路径截图验收 | 完成 | 12 个关键路径截图清单、记录模板、触发规则和失败判定已建立 |
| QA / UX / Godot | V02-POLISH-003 移动端触控与布局复核 | 完成 | 1280x720 与 960x540 检查表、按钮尺寸、遮挡、安全区和弹层关闭路径标准已建立 |
| Art Direction / Asset / QA | V02-POLISH-004 首批正式素材替换验收 | 完成 | P0 production 素材已通过 ThemeProfile / AssetResolver 接入；运行时纹理断言、1280x720 MCP 截图抽查和 headless 验证通过 |
| PM / Art Direction / QA | V02-ARTBASE-001 首屏视觉目标与资产降级审计 | 进行中 | 重评现有 P0/P1 素材，固定 Town Plaza 首屏视觉目标，明确 production / approved 证据门槛 |
| Art Direction / Asset / QA / Godot | V02-POLISH-005 P1 素材替换与 960x540 补验 | 并入重评 | 不再作为独立 Ready；并入 V02.7A 美术基线重建与双视口截图验收 |

## Round 51 小组推进计划

### 1. Art Direction / Asset 组

- 当前任务：准备 `V02-POLISH-004` 首批正式素材替换验收。
- 输入：`docs/10_美术风格与换肤预留.md`、`docs/14_内容基线整理与首批内容规划.md`、现有主场景截图验收要求。
- 输出：关键占位视觉替换优先级、production / approved 接入记录字段、首屏与核心路径截图验收点。
- 验收：角色、场景、家具、UI 图标和关键 A-Z anchor 的替换清单能映射到逻辑 asset ID，不要求本轮生成素材。

### 2. Map / Asset 组

- 当前任务：支持 `V02-POLISH-002` / `V02-POLISH-004` 的地图截图点。
- 输入：小镇首屏、Home、Shop、Bookshop、Bus Stop、A-Z anchor 路线和资源点清单。
- 输出：关键路径截图应覆盖的地图位置、anchor 可见性、资源点可读性和遮挡风险。
- 验收：截图模板能明确每张图的地点、玩家动作、UI 状态和通过标准。

### 3. Narrative / Asset 组

- 当前任务：为 `V02-POLISH-001` 和 `V02-POLISH-002` 复核孩子端可见文案。
- 输入：NPC 文本规范、轻事件规划、当前 HUD / 弹层 / 设置入口文案。
- 输出：退出、设置、买不起、关闭弹层、截图路径中的儿童安全文案检查点。
- 验收：不出现工程调试、家长报告、学习压力、倒计时、失败惩罚或陌生人社交暗示。

### 4. Home Design / Asset 组

- 当前任务：支撑 `V02-POLISH-002` 小屋截图验收和 `V02-POLISH-003` 家具触控复核。
- 输入：小屋视图、家具摆放 / 旋转 / 收起路径、Sunny 家内反馈。
- 输出：小屋截图清单、家具操作按钮尺寸 / 状态 / 关闭路径检查点。
- 验收：小屋、家具、Sunny 和底栏不互相遮挡；没有新家具时也有可验收的默认路径。

### 5. UI / Asset / UX 组

- 当前任务：推进 `V02-POLISH-001` 退出与设置入口。
- 输入：孩子端底栏精简结果、背包气泡、相册 / 商店 / 小屋覆盖层、移动端安全区约束。
- 输出：PC 调试退出入口、儿童端设置或安全位置入口、移动端不误触规则和文案。
- 验收：PC 可关闭游戏；移动端退出不在主操作误触区；设置入口不暴露工程调试信息。

### 6. Game Design / Narrative 组

- 当前任务：V02.6 策划内容生产线已完成，转为 `V02-POLISH-001` / `V02-POLISH-002` 文案审核支持。
- 验收：NPC、每日委托、商店轮换、A-Z 场景故事和节日天气轻事件规划均已写入 `docs/14`，且不把英语、Letter Snake、测试或打卡重新变成主循环。
- 目标：为发布前门槛提供儿童安全文案、轻事件截图点和相册 / NPC / 商店路径的验收判断。

### 7. UX / QA / Godot 组

- 前置依赖：`V02-PLAYABLE-004`、`V02-ART-001`、`V02-UI-010`。
- 进行中：`V02-POLISH-001`、`V02-POLISH-002`。
- Ready：`V02-POLISH-003`、`V02-POLISH-004`。
- 目标：把退出、截图、移动端布局和正式素材替换门槛变成可执行清单；后续具体 Godot 实现按清单逐项验收。

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
- [x] **V02-UI-002 主界面生活小镇视觉重做**
  Owner：Godot Dev / UI Agent；依赖：V02-LIFE-013；交付物：`scenes/main.tscn` / `scripts/main.gd` 首屏布局和视觉；验收：启动首屏不再显示 Godot skeleton / Loaded places 等工程占位文案，地图成为主视觉，HUD 展示生活状态、邻居、背包和温和操作，保留统一 Interact、可选相册/小游戏入口，并通过 headless 与生活场景测试。
- [x] **V02-UI-003 动森式小镇首屏 Playfield**
  Owner：Godot Dev / UI Agent；依赖：V02-UI-002；交付物：`scripts/main.gd` 全屏小镇 playfield、轻 HUD、场景化 A-Z 锚点表现、动物居民/玩家视觉符号；验收：首屏不再是左导航+右状态面板，中间地图不是数据调试网格；A-Z 不以裸字母学习标签为主表现；孩子端只看到小镇、居民、背包、相册和温和互动；通过主场景、playable loop、headless 验证。
- [x] **V02-UI-004 Sprite2D 小镇首屏资产化**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-003；交付物：`scripts/main.gd` Node2D/Sprite2D runtime playfield、物件化 A-Z anchors、动物居民视觉、气泡式 HUD、截图验收记录；验收：RuntimeMap 不再是 Control 方块地图，首屏像孩子进入 Sunshine Town 小镇而不是开发者调试面板；结构测试、生活场景测试、playable loop、headless、Godot quit 和 MCP 截图验收通过。
- [x] **V02-UI-005 孩子端中文界面**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-004；交付物：`scripts/main.gd` 主界面中文标题、按钮、提示、状态反馈与测试断言更新；验收：孩子端首屏和生活操作反馈以中文为主，英文仅保留为环境/系统资产名；现有生活循环和 headless 验证通过。
- [x] **V02-UI-006 顶部消息栏与底部按钮栏**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-005；交付物：`scripts/main.gd` 顶部消息状态栏、底部统一按钮栏、无遮挡小镇 playfield；验收：左侧/右侧大面板不再覆盖地图，消息类信息集中顶部一排，操作与导航按钮集中底部一排，生活循环与 headless 验证通过。
- [x] **V02-UI-007 顶部 HUD 单行压缩**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-006；交付物：`scripts/main.gd` 单行顶部 HUD；验收：首屏不再出现标题横幅加状态横幅的双层顶部 UI，阳光小镇标题、开放状态、今日提示和背包摘要集中到一条紧凑 HUD，地图可视面积增加，focused/headless 验证通过。
- [x] **V02-UI-008 底部操作栏精简**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-007；交付物：`scripts/main.gd` 精简底部按钮栏；验收：孩子端底部常驻按钮只保留 `看看`、`小镇`、`小屋`、`背包`，生活循环、购买、喂养、相册和 Letter Snake 快捷按钮不再可见但保留脚本/测试 contract 节点，focused/headless 与 MCP 截图验证通过。
- [x] **V02-UI-009 底部按钮儿童化视觉**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-008；交付物：`scripts/main.gd` 底部按钮色彩、状态和布局优化；验收：底部按钮不再是沉重深绿色方块，主操作与导航有柔和且可区分的 normal/hover/pressed 状态，底栏居中且不横跨大半屏空白，focused/headless 与 MCP 截图验证通过。
- [x] **V02-UI-010 背包气泡内容恢复**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-009；交付物：`scripts/main.gd` 背包按钮交互与轻量背包气泡；验收：点击底部 `背包` 可打开/关闭包含金币、Sunny 点心、树枝、家具、相册和 Letter Snake 入口说明的中文气泡；气泡不覆盖大半地图，状态随存档背包内容刷新，focused/headless 与 MCP 截图验证通过。

## 长期路线：生活小镇从原型到长期可玩

> 目标版本：孩子每天可以回到 Sunshine Town，照顾 Sunny、拜访居民、收集材料、完成轻委托、装饰小屋、解锁小镇角落，并在环境里自然遇见英语词汇和 A-Z 记忆锚点。英语继续作为环境层、收藏层和记忆宫殿编码，不重新变成测试、课程或主线任务。

| 版本 | 主题 | 目标体验 | 完成标志 |
|---|---|---|---|
| V02.1 | 每日小镇 | 每天回来都有居民、资源和今日状态可看 | 多 NPC 每日问候、轻委托、资源刷新和今日状态通过 smoke |
| V02.2 | 我的小屋 | 小屋成为孩子愿意经营和装饰的归属空间 | 独立小屋视图、家具摆放/收起/保存、Sunny 家内反馈通过 |
| V02.3 | 小镇记忆宫殿 | A-Z 锚点成为稳定场景物件和回访路线 | 首批 A-Z 场景物件强化、相册收藏和新词故事回访通过 |
| V02.4 | 内容生产框架 | 后续内容主要写数据而不是改主脚本 | 委托、商品、家具、对白、anchor 内容数据化并有合同测试 |
| V02.5 | 美术素材生产线 | 占位小镇开始替换为可持续生产的角色、场景、家具、UI、图标和音效素材 | 资产目录、命名规范和首批素材清单能映射到 `AssetResolver` 逻辑 ID |
| V02.6 | 策划内容生产线 | NPC、每日委托、商店轮换、节日天气和 A-Z 场景故事可以稳定扩展 | 首批内容包规划满足儿童安全、非压力经济和记忆宫殿绑定规则 |
| V02.7 | 发布前体验与质量门槛 | 可玩路径、退出设置、移动端布局和截图验收成为发布前固定门槛 | 关键路径截图、触控布局、退出设置和正式素材替换验收有明确清单 |

### V02.1 每日小镇：回访、居民和资源

- [x] **V02-DAILY-001 每日问候系统**
  Owner：Narrative / Godot Dev / QA Agent；依赖：V02-LIFE-013；交付物：本地每日问候数据、问候状态保存、NPC 互动接入；验收：Mina、店长、Sunny、故事熊、巴士哥哥每天首次互动有中文问候并写入当日状态，同日重复不重复发奖励；孩子端无学习压力文案。
- [x] **V02-DAILY-002 多 NPC 每日轻委托扩展**
  Owner：Game Design / Narrative / Godot Dev Agent；依赖：V02-DAILY-001、V02-LIFE-004；交付物：至少 3 条新增本地每日轻委托；验收：店长、故事熊、Sunny 至少各有一条轻委托，包含接取、目标、交付、金币/材料/关系奖励、同日去重和保存重载测试。
- [x] **V02-DAILY-003 每日资源刷新**
  Owner：Godot Dev / Map / QA Agent；依赖：V02-LIFE-004；交付物：资源刷新服务和首批资源点数据；验收：树枝、花、石子等资源按本地日期刷新，已收集资源当天不重复出现，跨日刷新通过 headless 测试。
- [x] **V02-DAILY-004 今日状态与轻日历**
  Owner：UX / Godot Dev Agent；依赖：V02-DAILY-001；交付物：顶部 HUD 今日状态、天气/小镇事件本地 stub；验收：HUD 能显示“今天晴天 / 集市日 / Sunny 想玩”等短提示，不遮挡地图，不引入真实时间压力或错过惩罚。
- [x] **V02-DAILY-005 V02.1 每日小镇 smoke**
  Owner：QA Agent；依赖：V02-DAILY-001 至 V02-DAILY-004；交付物：每日小镇端到端 smoke；验收：启动、问候、接委托、收集资源、交付、奖励、背包刷新、同日去重、跨日刷新全链路通过 focused/headless。

### V02.2 我的小屋：家园装饰成为核心留存

- [x] **V02-HOME-001 独立小屋视图**
  Owner：Godot Dev / UI Agent；依赖：V02-LIFE-006；交付物：HomeRoom 场景或主场景小屋模式；验收：进入小屋后看到房间、家具、Sunny 和返回小镇入口，底部操作不覆盖房间。
- [x] **V02-HOME-002 家具摆放/旋转/收起交互**
  Owner：Godot Dev / UX Agent；依赖：V02-HOME-001；交付物：触屏友好的家具操作；验收：家具可选择、摆放、旋转、收起，非法位置有温和反馈，保存后重进位置不丢失。
- [x] **V02-HOME-003 家具与宠物用品商品扩展**
  Owner：Game Design / Godot Dev Agent；依赖：V02-LIFE-005、V02-HOME-001；交付物：首批家具和宠物用品数据；验收：至少包含小桌、地毯、花盆、宠物碗、小床、墙饰，商店可购买并进入背包或家园库存。
- [x] **V02-HOME-004 Sunny 家内反馈**
  Owner：Narrative / Godot Dev Agent；依赖：V02-HOME-001、V02-HOME-003；交付物：Sunny 对家具和小屋状态的本地反馈；验收：Sunny 会对宠物碗、小床等物件给出短反馈，提升温暖感但不显示考试式评分。
- [x] **V02-HOME-005 V02.2 小屋 smoke**
  Owner：QA Agent；依赖：V02-HOME-001 至 V02-HOME-004；交付物：小屋装饰端到端测试；验收：购买、进入小屋、摆放、旋转、收起、Sunny 反馈、保存重载全链路通过。

### V02.3 小镇记忆宫殿：A-Z 场景化与收藏回访

- [x] **V02-AZ-WORLD-001 首批 A-Z 场景物件强化**
  Owner：Memory Palace / Map / Godot Dev Agent；依赖：V02-LIFE-009；交付物：A/B/C/D/K/O/S/T/W 的场景物件表现升级；验收：Apple Tree、Bear Corner、Clock Tower、Dog House、Kite Hill、Orange Stand、Sun Plaza、Taxi Stop、Watch Sign 等在地图中可感知，不以裸字母标签为主表现。
- [x] **V02-AZ-WORLD-002 Anchor 互动与相册收藏**
  Owner：Godot Dev / Curriculum Agent；依赖：V02-AZ-WORLD-001、V02-CARD-001；交付物：anchor 轻互动和相册记录；验收：孩子靠近场景物件可“看看”，相册记录见过/听过/收藏状态，界面表达为小镇发现而不是单词测验。
- [x] **V02-AZ-WORLD-003 新词故事回访路径**
  Owner：Curriculum / Memory Palace / Narrative Agent；依赖：V02-AZ-WORLD-001；交付物：首批新词回访数据和短故事；验收：每个新增词具备 `letter`、`core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook`、`review_path`，并能从地图地点触发温和回访。
- [x] **V02-AZ-WORLD-004 V02.3 记忆宫殿审计**
  Owner：QA / Memory Palace Agent；依赖：V02-AZ-WORLD-001 至 V02-AZ-WORLD-003；交付物：A-Z 场景化审计和自动化检查；验收：核心 anchor 顺序、场景物件、相册绑定、新词故事绑定全部通过测试。

### V02.4 内容生产框架：让扩展主要写数据

- [x] **V02-CONTENT-001 每日委托数据化合同**
  Owner：Godot Dev / Game Design Agent；依赖：V02-DAILY-002；交付物：daily request schema 和 loader；验收：新增委托无需改 `scripts/main.gd` 主流程即可加载，ID、奖励、同日去重和儿童安全文案有测试。
- [x] **V02-CONTENT-002 NPC 对话数据化合同**
  Owner：Narrative / Godot Dev Agent；依赖：V02-DAILY-001；交付物：NPC greeting/dialogue 数据合同；验收：问候、轻委托对白、关系阶段对白可由数据驱动，默认本地 stub，无网络依赖。
- [x] **V02-CONTENT-003 家具和商品数据化合同**
  Owner：Godot Dev / Economy Agent；依赖：V02-HOME-003；交付物：商品、家具、分类、价格和摆放 footprint 数据合同；验收：商品轮换和家具摆放读取数据，非法价格、重复 ID、缺失稳定 ID 可被测试拦截。
- [x] **V02-CONTENT-004 Anchor 内容包校验增强**
  Owner：Curriculum / Memory Palace / QA Agent；依赖：V02-AZ-WORLD-004、V02-FUTURE-003；交付物：内容包校验规则扩展；验收：内容包不能覆盖核心 A-Z 编码，新增词必须绑定记忆宫殿字段，未通过人工审核不得进入 runtime。
- [x] **V02-CONTENT-005 V02.4 数据化回归**
  Owner：QA Agent；依赖：V02-CONTENT-001 至 V02-CONTENT-004；交付物：内容数据合同和回归测试集；验收：委托、对白、商品、家具、anchor 内容均可通过数据新增并通过 headless runner。

### Round 48 可玩路径修复：入口必须真实可操作

- [x] **V02-PLAYABLE-001 相册孩子端入口修复**
  Owner：PM / UI Agent；依赖：V02-AZ-WORLD-002、V02-UI-010；交付物：可见的相册入口、相册覆盖层、返回小镇路径；验收：孩子端可从可见 UI 打开相册并返回，不依赖隐藏 contract 按钮，相册中文界面通过测试。
- [x] **V02-PLAYABLE-002 商店购买孩子端入口修复**
  Owner：PM / UI / Systems Agent；依赖：V02-HOME-003、V02-CONTENT-003；交付物：靠近商店或店长可打开可见货架，货架按钮可购买家具并刷新背包/HUD；验收：实际 UI 按钮购买成功，金币扣减、物品入背包，买不起时温和反馈。
- [x] **V02-PLAYABLE-003 真实操作烟测补充**
  Owner：PM / QA Agent；依赖：V02-PLAYABLE-001、V02-PLAYABLE-002；交付物：主场景操作级 focused test；验收：测试通过“可见按钮/面板”打开相册、关闭相册、打开商店、点击商品购买，而不是直接调用隐藏脚本方法。
- [x] **V02-PLAYABLE-004 核心生活操作同步检测**
  Owner：PM / QA / UI Agent；依赖：V02-LIFE-011、V02-HOME-002、V02-AZ-WORLD-002；交付物：覆盖 `看看`、背包、小镇/小屋、NPC、资源、anchor、家具摆放/旋转/收起的玩家路径测试；验收：每个已宣称可玩的核心生活动作都有孩子端可见入口，并通过操作级 smoke。

### V02.5 美术素材生产线：从可玩占位走向可持续资产

> 本阶段只建立生产规范和首批素材清单，初期仍使用单一 storybook/cozy town 风格，不开启多主题并行生产。所有素材必须通过逻辑 asset ID 进入 `ThemeProfile` / `AssetResolver`，玩法脚本不得硬编码具体文件路径。

- [x] **V02-ART-001 美术资产目录与命名规范**
  Owner：Art Direction / Asset / Godot Dev Agent；依赖：V02-CORE-005、V02-UI-004；交付物：资产分类目录、逻辑 asset ID 规则、命名规范、占位/半正式/正式状态定义、`AssetResolver` 映射要求；验收：角色、宠物、场景、A-Z anchor、家具、UI、图标和音效等未来素材均能映射到稳定逻辑 ID，玩法脚本不得新增硬编码素材路径。
- [x] **V02-ART-002 首批小镇场景素材清单**
  Owner：Art Direction / Map / Asset Agent；依赖：V02-ART-001、V02-AZ-WORLD-001；交付物：Home、Town Plaza、Shop、Bookshop、Bus Stop、道路、树、花、资源点等小镇场景素材清单；验收：每个场景物件有用途、逻辑 asset ID、当前状态、优先级、替换目标、建议尺寸/比例和验收截图要求。
- [x] **V02-ART-003 首批角色与宠物素材清单**
  Owner：Art Direction / Narrative / Asset Agent；依赖：V02-ART-001、V02-NPC-001；交付物：玩家、Mina、店长、Sunny、故事熊、巴士哥哥等角色和宠物素材需求；验收：每个角色至少定义站立状态、基础表情/状态、地图显示尺寸、UI 头像需求和儿童友好表现边界。
- [x] **V02-ART-004 家具与家园素材清单**
  Owner：Art Direction / Home Design / Asset Agent；依赖：V02-ART-001、V02-HOME-003；交付物：小桌、地毯、花盆、宠物碗、小床、墙饰等首批家具和家园素材需求；验收：每个家具有 footprint、房间显示尺寸、图标、摆放方向、状态、替换优先级和小屋截图验收点。
- [x] **V02-ART-005 UI 图标与状态素材清单**
  Owner：UI / Art Direction / UX Agent；依赖：V02-ART-001、V02-UI-010；交付物：金币、点心、饥饿、开心、背包、相册、商店、设置/退出等 HUD 与按钮图标清单；验收：HUD 和按钮不再只依赖文字表达，图标有逻辑 ID、目标尺寸、可读性要求、触控状态和 1280x720 截图验收标准。

### V02.6 策划内容生产线：持续扩展日常、居民和记忆故事

> 策划内容继续服务生活 RPG / 小镇养成，英语只作为环境、收藏、NPC 短句、相册和 A-Z 记忆宫殿故事层。不得把 Letter Snake、测试、课程表或单词背诵重新变成主循环条件。

- [x] **V02-DESIGN-001 NPC 内容生产规范**
  Owner：Game Design / Narrative / Child Safety Agent；依赖：V02-CONTENT-002、V02-PLAYABLE-004；交付物：NPC 问候、关系阶段、轻委托对白、反馈语气和儿童安全文本边界规范；验收：新增 NPC 文本可直接进入数据合同验证，不包含失败惩罚、学习压力、开放陌生人社交或家长报告口吻。
- [x] **V02-DESIGN-002 每日轻委托内容包规划**
  Owner：Game Design / Narrative Agent；依赖：V02-CONTENT-001、V02-DAILY-002；交付物：首批 10-15 条每日轻委托规划；验收：每条委托有稳定 ID、NPC、目标、奖励、关系反馈、重复规则、儿童安全文案和可见操作入口，不依赖 Letter Snake 完成。
- [x] **V02-DESIGN-003 商店与家具轮换策划**
  Owner：Game Design / Economy / Home Design Agent；依赖：V02-CONTENT-003、V02-HOME-003；交付物：商品分类、价格区间、轮换节奏、金币来源和非惩罚经济原则；验收：金币用途清晰，买不起时只有温和反馈，不形成打卡压力、损失惩罚或强消耗循环。
- [x] **V02-DESIGN-004 A-Z 场景故事扩展规划**
  Owner：Memory Palace / Narrative / Curriculum Agent；依赖：V02-AZ-WORLD-003、V02-CONTENT-004；交付物：26 个 anchor 的场景故事、视觉钩子、回访路径和新词扩展规划；验收：首批 9 个达到可制作级，剩余 17 个达到规划级；所有新增词继续绑定 `letter`、`core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook`、`review_path`。
- [x] **V02-DESIGN-005 节日与天气轻事件规划**
  Owner：Game Design / Narrative / UX Agent；依赖：V02-DAILY-004、V02-CONTENT-001；交付物：晴天、雨天、集市日、儿童节等轻事件规划；验收：事件不惩罚缺席，不制造连续登录压力，能作为小镇氛围、NPC 问候、资源刷新或轻装饰变化进入后续数据生产。

### V02.7 发布前体验与质量门槛：把“能玩”推进到“可验收”

> 本阶段将玩家路径、截图、移动端布局和首批正式素材替换变成发布前门槛。文档规划完成后，具体实现和截图验收按任务逐项进入 Ready。

- [x] **V02-POLISH-001 退出与设置入口**
  Owner：UX / Godot Dev / QA Agent；依赖：V02-PLAYABLE-004；交付物：开发/桌面可见退出入口、儿童端设置或安全位置入口、移动端不误触规则；验收：PC 调试可关闭游戏，移动端不会把退出放在主操作误触区，孩子端文案安全且不暴露工程调试信息。
- [x] **V02-POLISH-002 玩家路径截图验收**
  Owner：QA / UI / Art Direction Agent；依赖：V02-PLAYABLE-004、V02-ART-001；交付物：关键路径截图清单和截图验收记录模板；验收：小镇、背包、商店、小屋、相册、anchor 互动等路径都有 1280x720 截图要求，每次 UI/美术大改后必须截图确认。
- [x] **V02-POLISH-003 移动端触控与布局复核**
  Owner：QA / UX / Godot Dev Agent；依赖：V02-UI-010、V02-PLAYABLE-004；交付物：1280x720 和较小横屏视口布局检查表；验收：按钮尺寸、遮挡、安全区、文字溢出、底栏/顶部 HUD 和弹层关闭路径均可操作。
- [x] **V02-POLISH-004 首批正式素材替换验收**
  Owner：Art Direction / Asset / QA Agent；依赖：V02-ART-002、V02-ART-003、V02-ART-004、V02-ART-005；交付物：关键占位视觉替换清单、正式或半正式素材接入记录和截图验收；验收：首屏不再像程序化占位原型，角色、场景、家具、UI 图标和关键 A-Z anchor 至少完成首批正式或半正式替换，并通过截图验收。
- [x] **V02-POLISH-005 P1 素材替换与 960x540 补验（并入 V02.7A 重评）**
  Owner：Art Direction / Asset / QA / Godot Agent；依赖：V02-POLISH-003、V02-POLISH-004；交付物：原计划为运行时可见 P1 角色、家具和 UI 图标素材接入记录、960x540 较小横屏截图验收；现结论：不再作为独立 Ready，已并入 `V02.7A 美术基线重建`，由 `V02-ARTBASE-*` 统一重评素材质量、production / approved 口径和双视口截图证据。

### V02.7A 美术基线重建：先让 Sunshine Town 第一眼可信

> 本阶段承认现有素材链路已打通，但当前资产仍偏占位。目标不是继续堆素材 ID，而是先重建 Town Plaza 首屏、基础角色、Home / Shop 和关键小物件视觉基线。`production` 只表示可集成，`approved` 必须有 PM / Art Direction 确认和 1280x720、960x540 截图证据。

- [~] **V02-ARTBASE-001 首屏视觉目标与资产降级审计**
  Owner：PM / Art Direction / QA Agent；依赖：V02-POLISH-004；交付物：当前 P0/P1 素材质量审计、哪些降回 `draft` / `placeholder_plus`、Sunshine Town 首屏参考标准；验收：文档不再把缺少截图证据的素材称为 `approved`，并明确 `production` 只表示可集成、不表示最终美术质量。
- [ ] **V02-ARTBASE-002 Town Plaza 主视觉生成与接入**
  Owner：Art Direction / Asset / Godot Agent；依赖：V02-ARTBASE-001；交付物：一张可用 Town Plaza 主场景底图或可拼接背景，接入 `place.town_plaza.day`；验收：1280x720 首屏第一眼像生活小镇，有 Home / Shop / 道路 / 停留空间，不像调试网格或程序占位。
- [ ] **V02-ARTBASE-003 角色与宠物基础套装**
  Owner：Art Direction / Character Asset / QA Agent；依赖：V02-ARTBASE-001；交付物：玩家、Mina、Sunny、店长站立图，同一画风与锚点尺寸；验收：同屏比例自然，角色可区分，儿童友好，无课堂 / 评分 / 战斗感。
- [ ] **V02-ARTBASE-004 Home / Shop / 小物件视觉基线**
  Owner：Art Direction / Map / Home Asset Agent；依赖：V02-ARTBASE-001、V02-ARTBASE-002；交付物：Home、Shop、树枝、花丛、宠物碗、Clock / Orange / Sun 相关物件；验收：地点和物件能支撑 V02.8 的三条日常路径，并通过逻辑 asset ID 接入或明确待接入记录。
- [ ] **V02-ARTBASE-005 双视口截图验收**
  Owner：QA / Art Direction / Godot Agent；依赖：V02-ARTBASE-002、V02-ARTBASE-003、V02-ARTBASE-004；交付物：1280x720 与 960x540 截图记录；验收：无明显遮挡、文字溢出、按钮贴边；截图能作为进入 V02.8 的门槛。

### V02.8 每日小镇生活纵切：让孩子完成 5 分钟日常

> 本阶段必须在 V02.7A 双视口截图通过后进入实现。范围固定为 Mina、店长、Sunny 三个角色和 C Clock / O Orange / S Sun 三个 A-Z 地点回访；Bookshop / Bus Stop 保留为后续 P1 扩展。

- [ ] **V02-DAILYLIFE-001 三 NPC 日常入口**
  Owner：Godot Dev / Narrative / QA Agent；依赖：V02-ARTBASE-005、V02-PLAYABLE-004；交付物：Mina、店长、Sunny 从孩子端可见入口触发问候和轻委托；验收：不依赖隐藏按钮，对话短、生活化、无学习压力。
- [ ] **V02-DAILYLIFE-002 三条 P0 轻委托可玩化**
  Owner：Godot Dev / Game Design / QA Agent；依赖：V02-DAILYLIFE-001、V02-CONTENT-001；交付物：`daily_mina_branch_walk_001`、`daily_shopkeeper_tiny_home_item_001`、`daily_sunny_room_tidy_001` 可从 UI 完成；验收：接取、行动、完成、奖励、同日去重、保存重载通过。
- [ ] **V02-DAILYLIFE-003 商店到小屋使用闭环**
  Owner：Godot Dev / Economy / Home Design Agent；依赖：V02-DAILYLIFE-002、V02-HOME-005；交付物：看商品 / 购买小物 -> 背包 / HUD 更新 -> 小屋摆放或移动 -> Sunny 反馈；验收：至少 1 件家具购买后可摆放并持久保存。
- [ ] **V02-DAILYLIFE-004 三个 A-Z 地点回访**
  Owner：Memory Palace / Narrative / Godot Dev Agent；依赖：V02-DAILYLIFE-001、V02-AZ-WORLD-004；交付物：`C Clock`、`O Orange`、`S Sun` 以地点故事、短句或相册发现参与日常；验收：不出现单词测验、课程、背诵要求；anchor 位置和核心编码不变。
- [ ] **V02-DAILYLIFE-005 5 分钟纵切 smoke 与截图**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-DAILYLIFE-001、V02-DAILYLIFE-002、V02-DAILYLIFE-003、V02-DAILYLIFE-004；交付物：端到端玩家路径测试和 1280x720、960x540 截图；验收：玩家从启动开始能完成“找 NPC -> 做小事 -> 得反馈 -> 使用奖励 / 回小屋”的完整路径。

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
- [x] **V02-MAP-003 实现 grid overlay**
  Owner：Map Tool Agent；依赖：V02-MAP-002；交付物：编辑器网格；验收：编辑 cell 与运行时逻辑 cell 一致。
- [x] **V02-MAP-004 实现 road cell 编辑**
  Owner：Map Tool Agent；依赖：V02-MAP-003；交付物：道路编辑工具；验收：可添加、删除道路 cell。
- [x] **V02-MAP-005 实现 occupied/interaction cell 编辑**
  Owner：Map Tool Agent；依赖：V02-MAP-003；交付物：碰撞与交互编辑工具；验收：interaction 不允许落在 occupied。
- [x] **V02-MAP-006 实现地图编辑撤销/重做**
  Owner：Map Tool Agent；依赖：V02-MAP-004/005；交付物：editor command stack；验收：地图编辑操作可撤销和重做。
- [x] **V02-MAP-007 实现地图 JSON 导入/导出**
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

- [x] **V02-FUTURE-001 实现 AccountAdapter 与本地账号迁移接口**
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-LOOP-002；验收：不改变现有本地 profile 行为，可替换账号后端。
- [x] **V02-FUTURE-002 实现 Cloud Save 与冲突处理**
  Owner：Godot Dev / QA Agent；依赖：V02-FUTURE-001；验收：多设备同步、离线恢复和冲突策略通过测试。
- [x] **V02-FUTURE-003 实现 ContentPackLoader 与内容包更新**
  Owner：Godot Dev / Curriculum Agent；依赖：V02-MAP-007、V02-CARD-001；验收：内容包可校验、安装、回滚且不覆盖核心 A-Z 编码。
- [x] **V02-FUTURE-004 接入真实 TTS、录音与跟读能力**
  Owner：Voice/AI / Godot Dev Agent；依赖：V02-VOICE-002、家长隐私审批；验收：权限、隐私、失败降级和移动端性能通过评审。
- [x] **V02-FUTURE-005 接入真实 AI NPC 与长期记忆**
  Owner：Voice/AI / Godot Dev Agent；依赖：V02-AI-003、家长隐私审批；验收：内容安全、角色边界、摘要和降级策略通过评审。
- [x] **V02-FUTURE-006 实现异步互访与家长批准好友**
  Owner：Godot Dev / QA Agent；依赖：V02-FUTURE-001/002；验收：无陌生人开放社交，权限和举报流程通过评审。
- [x] **V02-FUTURE-007 实现受控多人互动**
  Owner：Godot Dev / Game Design Agent；依赖：V02-FUTURE-006；验收：仅预设短语、表情或受控合作玩法，儿童安全通过评审。
- [x] **V02-FUTURE-008 实现第二主题与主题包切换**
  Owner：Asset / Godot Dev Agent；依赖：V02-CORE-005、V02-FUTURE-003；验收：无需修改玩法脚本即可切换主题。
- [x] **V02-FUTURE-009 完成 Android/iOS/平板深度适配**
  Owner：Godot Dev / UI/UX / QA Agent；依赖：V02-LOOP-002；验收：目标设备上的性能、触控、安全区、音频和存档通过测试。
- [x] **V02-FUTURE-010 建立 AI 辅助内容生产与人工审核管线**
  Owner：Curriculum / Voice/AI / QA Agent；依赖：V02-FUTURE-003；验收：候选内容可追溯、规则校验、人工批准后才可发布。

## 跨阶段质量门槛

- [x] **V02-QA-001 数据合同测试集**：schema load、JSON round-trip、ID 唯一、A-Z 顺序和地图校验全部通过。
- [x] **V02-QA-002 运行时 smoke 测试集**：地图加载、卡片状态、Pet/Shop/Coins、小游戏奖励、Voice/AI stub 全部通过。
- [x] **V02-QA-003 儿童体验检查**：孩子端无强考核、课程表、失败惩罚、家长报告或开放陌生人社交。
- [x] **V02-QA-004 移动端验收**：目标横屏设备上的触控区域、安全区、布局和性能通过。

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
| 2026-06-04 | Round 20 验收 | V02-MAP-003 | `WorldOverviewScene` 新增 `EditorOnlyGridOverlay`，网格尺寸与 `world_map.json` 的 `canvas_size` / `cell_size` 对齐；`test_world_overview_grid_overlay`、`test_world_overview_editor_proxy`、`headless_runner` 通过 |
| 2026-06-04 | Round 21 验收 | V02-MAP-004/005 | 编辑器支持 road cell 添加/删除、occupied cell 设置和 interaction cell 设置；interaction 落在 occupied 时返回 `interaction_over_occupied`；`test_world_overview_cell_editing`、`headless_runner` 通过 |
| 2026-06-04 | Round 22 验收 | V02-MAP-006 | 编辑器 command stack 覆盖 road、occupied、interaction 和 place marker move，支持 undo/redo；`test_world_overview_cell_editing`、`headless_runner` 通过 |
| 2026-06-04 | Round 23 验收 | V02-MAP-007 | 新增 `MapEditorSyncService`，支持 JSON 导入和 editor state 导出，导出结果通过 `WorldMapContract` 且保留 26 个 A-Z anchors；`test_world_overview_cell_editing`、`headless_runner` 通过 |
| 2026-06-04 | Round 24 验收 | V02-QA-001/002/003/004 | `headless_runner` 汇总数据合同、运行时 smoke、孩子端禁显文本、家长入口隔离、移动 viewport/renderer/safe area/touch nav 基线；`godot --headless --path . --quit` 与 `headless_runner` 通过 |
| 2026-06-04 | Round 25 验收 | V02-FUTURE-001 | 新增 `AccountAdapter` 本地账号 stub，暴露 `guest:local_profile`，迁移接口幂等且不改变 `SaveService`；`test_account_cloud_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 26 验收 | V02-FUTURE-002 | 新增 `CloudSaveAdapter` 本地云存档模拟，支持双 device slot、离线队列、冲突副本和 last-write，本地 stub 不联网不上传；`test_account_cloud_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 27 验收 | V02-FUTURE-003 | 新增 `ContentPackLoader`，支持本地内容包校验、安装、回滚，拒绝覆盖核心 A-Z anchor，新增词必须有记忆宫殿故事绑定字段；`test_content_theme_review_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 28 验收 | V02-FUTURE-004/005 | 新增 `VoiceProviderAdapter` 与 `AINPCProviderAdapter`，真实 provider 需要家长隐私 gate，默认走本地 voice/AI stub，不联网、不录音、不上传；`test_voice_ai_social_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 29 验收 | V02-FUTURE-006/007 | 新增 `FriendVisitService`，仅允许家长批准的本地 friend profile、预设短语、表情和合作事件，阻止陌生人和自由文本；`test_voice_ai_social_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 30 验收 | V02-FUTURE-008 | 新增第二主题 `theme_rainbow_garden_placeholder` 和 `ThemeSwitchService`，继续通过逻辑 asset ID 解析主题资源；`test_content_theme_review_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 31 验收 | V02-FUTURE-009 | 移动端基线纳入 `headless_runner`，验证 1280x720、mobile renderer、safe area、触控导航宽度和主场景性能 smoke；`godot --headless --path . --quit` 与 `headless_runner` 通过 |
| 2026-06-04 | Round 32 验收 | V02-FUTURE-010 | 新增 `ContentReviewPipeline`，候选内容必须人工批准后才能发布到 runtime，本地审核不联网；`test_content_theme_review_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 33 验收 | Final Integration | `todo.md` 全部可执行项已完成，地图编辑器、远期本地 stub、跨阶段 QA 全量回归通过；`godot --headless --path . --quit`、focused tests、`tests/headless_runner.gd` 通过 |
| 2026-06-04 | Round 36 验收 | V02-UI-004 | `RuntimeMap` 改为 `Node2D`，地面、道路、建筑、物件化 A-Z anchors、动物居民和玩家均由 `Sprite2D` 风格节点组成；右侧状态面板收为左侧小气泡 HUD；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner`、`godot --headless --path . --quit` 通过；MCP 成功捕获 1280x720 首屏截图并确认小镇 playfield 节点结构可见 |
| 2026-06-04 | Round 37 验收 | V02-UI-005 | 孩子端主界面标题、导航、HUD 气泡、操作按钮、背包状态、地点进入、移动、收集、购买、喂养和 NPC 显示名改为中文；英文仅保留 `Sunny`、`Letter Snake` 等环境/系统资产名；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 38 验收 | V02-UI-006 | 移除覆盖地图的左侧 `LifeRPGPanel`、`HomePetLoopPanel`、`OptionalActivityPanel` 三块大面板；消息、生活状态和背包摘要集中到顶部 `TownHUD` 一排；所有操作与导航集中到底部 `TownFooter` 一排按钮；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner`、`godot --headless --path . --quit` 通过；MCP 截图与节点属性确认顶底栏布局生效 |
| 2026-06-04 | Round 39 验收 | V02-UI-007 | 删除独立 `Header` 顶部横幅，将“阳光小镇”、开放状态、今日提示、循环状态和背包摘要合并到 48px 高的单行 `TownHUD`；底部 `TownFooter` 保持一排操作按钮；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner` 通过；MCP 截图与节点属性确认首屏顶部只剩一条紧凑 HUD |
| 2026-06-04 | Round 40 验收 | V02-UI-008 | 底部 `TownFooter` 可见操作精简为 `看看`、`小镇`、`小屋`、`背包` 四个按钮；`StartButton`、`HelpNeighborButton`、`BuyFoodButton`、`FeedSunnyButton`、`MemoryAlbumButton`、`LetterSnakeButton` 移入隐藏 `FooterContractButtons` 保持测试/脚本入口；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner` 通过；MCP 截图与场景树确认孩子端底栏仅四个可见按钮 |
| 2026-06-04 | Round 41 验收 | V02-UI-009 | 底部 `TownFooter` 收窄居中并改为柔和暖色底托；四个可见按钮改为圆角胶囊，主操作/选中导航使用暖黄色强调，普通导航使用浅色，normal/hover/pressed/focus 状态齐全；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner` 通过；MCP 截图与节点属性确认底栏约 647px 居中显示 |
| 2026-06-04 | Round 42 验收 | V02-UI-010 | 底部 `背包` 按钮打开轻量 `BackpackBubble`，展示金币、Sunny 点心、树枝、木椅、相册和 Letter Snake 入口说明；顶部 HUD 新增独立 `CoinState` 金币 badge，并将 `PetState` 收为点心、饥饿、开心三项，金币和宠物状态视觉分组；`check-only`、`test_life_rpg_scene`、`headless_runner` 通过；MCP 场景树确认 `CoinState` / `PetState` 独立存在 |
| 2026-06-04 | Round 43 规划 | 长期路线 | 新增“长期路线：生活小镇从原型到长期可玩”章节，确定 V02.1 每日小镇、V02.2 我的小屋、V02.3 小镇记忆宫殿、V02.4 内容生产框架四个里程碑，并将 `V02-DAILY-001` 设为下一项 Ready |
| 2026-06-04 | Round 44 验收 | V02.1 每日小镇 | 新增 `LocalDayService`、每日问候、每日资源刷新、今日状态和多 NPC 轻委托；Mina、店长、Sunny、故事熊、巴士哥哥每日问候按 day_key 保存，树枝/小花/小石子按日刷新，店长/故事熊/Sunny 新增轻委托；`jq`、`test_daily_request_service`、`test_daily_town_services`、`test_v021_daily_town_contract`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`test_life_services`、`test_memory_palace_embedding`、`check-only`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 45 验收 | V02.2 我的小屋 | 新增独立 `HomeRoom` 小屋视图，`小屋`/`小镇` 底栏可切换；家具目录扩展小桌、地毯、花盆、宠物碗、Sunny 小床和墙饰；`HomeDecorationService` 支持摆放、旋转、移动、收起、非法格温和反馈和 Sunny 家内反馈；`jq`、`test_v022_home_room_contract`、`test_life_services`、`test_life_rpg_scene`、`test_memory_palace_embedding`、`check-only`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 46 验收 | V02.3 小镇记忆宫殿 | 新增 `AnchorInteractionService` 和新词回访数据，靠近 A-Z anchor 使用 `看看` 会写入相册 seen/heard/collected 并显示温和故事；首批 A/B/C/D/K/O/S/T/W 保持 Sprite2D 场景物件表现；`test_v023_memory_palace_world`、`test_memory_album_scene`、`test_memory_palace_embedding`、`check-only`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 47 验收 | V02.4 内容生产框架 | 新增 `ContentContractValidator` 和 V02.4 内容合同测试，覆盖每日委托、每日问候、家具商品、新词故事、核心 A-Z 覆盖拦截和数据化 loader 回归；`find data -name '*.json' -print0 | xargs -0 jq empty`、`test_v024_content_contracts`、`check-only`、`headless_runner`、`test_life_rpg_scene`、`test_v022_home_room_contract`、`test_v023_memory_palace_world`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 48 验收 | 真实可玩路径修复 | 背包气泡新增可见相册入口并打开中文相册覆盖层；靠近商店 `看看` 打开可见货架，商品按钮可购买家具并刷新背包/HUD；小屋新增物件面板，可从可见按钮摆放、旋转、收起家具；新增 `test_playable_ui_operations` 并注册进 `headless_runner`；`check-only`、`test_memory_album_scene`、`test_playable_ui_operations`、`test_playable_loop_smoke`、`test_life_rpg_scene`、V02.1-V02.4 contract tests、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-05 | Round 49 规划 | PM 路线更新 | 更新 `todo.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/10_美术风格与换肤预留.md`、`docs/14_内容基线整理与首批内容规划.md`；新增 V02.5-V02.7 路线与 `V02-ART-001` 到 `V02-POLISH-004`，未运行 Godot 验证 |
| 2026-06-05 | Round 50 规划 | V02.5 美术素材生产线文档清单 | 完成 `V02-ART-001` 至 `V02-ART-005`：资产目录与命名规范、小镇场景、角色宠物、家具家园、UI 图标与状态素材清单均写入 `docs/10_美术风格与换肤预留.md`；未运行 Godot 验证 |
| 2026-06-05 | Round 51 PM 分派 | V02.6 策划内容生产线收口与 V02.7 小组任务安排 | 核对 `docs/14_内容基线整理与首批内容规划.md` 中 `V02-DESIGN-005` 已包含晴天、雨天/雨后、微风、集市日、儿童节、小镇庆祝等轻事件规划，并将 `V02-DESIGN-005` 标记完成；新增 `docs/collaboration/Round51_V02.7发布前质量门槛任务包.md`，分派 `V02-POLISH-001` 至 `V02-POLISH-004` 给 UX/Godot/QA、QA/UI/Art、QA/UX/Godot、Art/Asset/QA 小组；子小组补充 `Round51_UXQA_Polish001_002验收草案.md` 与 `Round51_V02-POLISH-003-004_QA-Asset验收草案.md`；文档一致性检查、`godot --headless --path . --quit`、`godot --headless --path . --script tests/headless_runner.gd` 通过 |
| 2026-06-05 | Round 52 验收 | V02.7 发布前体验门槛实现与验收表落地 | `scripts/main.gd` 新增顶部设置入口、`SettingsPanel`、声音开关、回到小镇安全位置、休息二次确认和退出入口；`tests/test_playable_ui_operations.gd` 与 `tests/headless_runner.gd` 覆盖设置真实可见路径、底栏不新增退出、二次确认和安全位置；新增 `docs/collaboration/Round52_V02.7发布前体验门槛执行记录.md`；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；`V02-POLISH-004` 因尚未接入正式素材保持进行中 |
| 2026-06-05 | Round 52 素材验收收口 | V02-POLISH-004 首批正式素材替换验收 | 接入 P0 production 素材：Town Plaza、Home、Shop、主路、树枝、玩家、Mina、Sunny、金币图标和背包图标；新增 `ThemeProfile` 分类、`AssetResolver` 查询、主场景逻辑 asset 纹理加载和运行时纹理断言；MCP 捕获 1280x720 首屏截图并抽查运行树；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过 |
| 2026-06-05 | Round 54 规划启动 | V02.7A 美术基线重建与 V02.8 每日小镇生活纵切 | 按 `AGENTS.md` 文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；将 `V02-POLISH-005` 并入 V02.7A 重评，新增 `V02-ARTBASE-001` 至 `005` 与 `V02-DAILYLIFE-001` 至 `005`；本轮只改 PM 文档和台账，未改运行时代码，未运行 Godot 验证 |
