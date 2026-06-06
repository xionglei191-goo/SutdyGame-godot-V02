# StudyGame V02 开发经验记录

> 最后更新：2026-06-06
> 本文件只记录已经实际发生并确认的问题。潜在风险记录在项目计划或 `todo.md`，不作为开发经验。

## 记录规则

- 每条经验必须关联任务、现象、影响、根因、解决方式、预防规则和验证依据。
- 只有问题经过复现或文档核对确认后才能记录。
- 解决方式尚未实施时，应明确标记为“待处理”，并在 `todo.md` 建立任务。
- 每轮结束时复核是否产生新经验；没有则在轮次记录中注明“无新增已验证教训”。
- 可执行的预防规则必须进入后续任务的验收标准或自动化测试。

## LESSON-001：数量描述必须与实际清单核对

- **日期：** 2026-06-04
- **关联任务：** `V02-BASE-005`、`V02-BASE-009`、`V02-MAP-001`
- **现象：** `docs/14_内容基线整理与首批内容规划.md` 写明“第一阶段重点启用 8 个高关联 anchor”，但随后实际列出 A/B/C/D/K/O/S/T/W，共 9 个。
- **影响：** 内容、数据 schema、地图 marker 和验收测试可能分别按 8 个或 9 个实现，导致范围不一致和返工。
- **根因：** 文档中的数量为手工维护，修改清单后未同步更新概述文字，也没有自动统计或一致性检查。
- **解决方式：** 已执行 `V02-BASE-009`，统一描述为 9 个；首轮任务以实际清单 A/B/C/D/K/O/S/T/W 为准。
- **预防规则：**
  - 枚举型内容以实际数据或清单为事实来源，概述中的数量必须在验收时重新统计。
  - 数据建立后，为 anchor 数量、ID 唯一性和 `route_order` 增加自动校验。
  - 任务交付说明必须列出“声明数量”和“实际统计数量”的核对结果。
- **验证依据：** 对 `docs/14_内容基线整理与首批内容规划.md` 的对应段落进行人工计数，确认文字和实际清单均为 9 个。

## 轮次复盘记录

| 日期 | 轮次 | 新增已验证教训 | 备注 |
|---|---|---|---|
| 2026-06-04 | 项目接管与台账建立 | LESSON-001 | 已在 `todo.md` 创建 `V02-BASE-009`，并将首轮默认值固定为 9 个 anchor |
| 2026-06-04 | Round 1 集成 | LESSON-002 | 并行 agent 尚未完成时读取到中间版本，测试期望短暂与最终交付不一致 |
| 2026-06-04 | Round 5 服务集成 | LESSON-003、LESSON-004 | QuestEventService 出现 Godot 类型推断编译错误；失败测试留下 headless 进程 |
| 2026-06-04 | Round 8 本地 stub 集成 | 无 | 语音、NPC、AI 和家长摘要 stub 验收未产生新的已验证教训 |
| 2026-06-04 | 方向纠偏 | LESSON-005 | 旧文档把学习闭环作为主线，偏离生活 RPG / 小镇养成预期 |
| 2026-06-04 | Round 9 生活探索层 | 无 | 玩家移动、NPC 标记和关系存档按既有 Control 主场景最小接入，未产生新的已验证教训 |
| 2026-06-04 | Round 10 生活服务 | LESSON-003 复用 | 新增服务再次遇到 Godot 动态返回值类型推断问题，按 LESSON-003 显式标注局部变量后通过 |
| 2026-06-04 | Round 11 记忆宫殿审计 | 无 | 26 个 A-Z 地图锚点和新词故事编码绑定通过数据审计，未产生新的已验证教训 |
| 2026-06-04 | Round 12 学习入口降级 | LESSON-005 复用 | Letter Snake 从主流程依赖降为可选活动，验证了“学习系统不能重新成为主线推进条件”的纠偏规则 |
| 2026-06-04 | Round 13 地图上下文互动层 | 无 | 统一 `Interact` 已覆盖首批 NPC、资源、商店和家园对象；资源点暂用主脚本 registry，后续数据化时再扩 schema |
| 2026-06-04 | Round 14 首批固定 NPC 对话 | 无 | 五个 NPC 已从本地 profile fallback 接入主场景统一交互；仍保持无网络、无真实 AI、固定对白和本地记忆 |
| 2026-06-04 | Round 15 家长入口边界 | 无 | 家长入口改为非孩子导航规格，主流程测试开始扫描可见后台/报告文案，确保孩子端保持生活小镇体验 |
| 2026-06-04 | Round 16 本地家长摘要界面 | 无 | 家长 dashboard 独立成 parent-only 场景，继续通过孩子端禁显测试保证不污染主流程 |
| 2026-06-04 | Round 17 地图编辑层 EditorOnly proxy | 无 | WorldOverviewScene 编辑层通过专门测试与 headless runner；下一轮风险已进入 `todo.md`，不作为已验证教训新增 |
| 2026-06-04 | Round 18 地点进入与生活动作解耦 | 无 | 地图入口改为中性 place entry；购买、摆放、邻居帮助保留为显式生活动作，未产生新的已验证教训 |
| 2026-06-04 | Round 19 每日轻委托 MVP | 无 | Mina branch 轻委托通过服务级与主场景测试，保持本地、低压力、无 Letter Snake 条件，未产生新的已验证教训 |
| 2026-06-04 | Round 20 地图 grid overlay | 无 | 编辑器网格与运行时 cell 合同对齐，未产生新的已验证教训 |
| 2026-06-04 | Round 21 地图 cell 编辑 | 无 | road、occupied、interaction 编辑通过 focused tests，未产生新的已验证教训 |
| 2026-06-04 | Round 22 编辑撤销/重做 | 无 | command stack 覆盖地图编辑操作，未产生新的已验证教训 |
| 2026-06-04 | Round 23 地图 JSON 往返 | 无 | `MapEditorSyncService` 导出继续通过地图合同，未产生新的已验证教训 |
| 2026-06-04 | Round 24 跨阶段 QA | 无 | 数据合同、运行时 smoke、儿童体验和移动基线纳入 `headless_runner`，未产生新的已验证教训 |
| 2026-06-04 | Round 25-27 账号/云存档/内容本地 stub | 无 | 账号、云存档、内容包、主题和审核本地 stub 通过 focused tests，未产生新的已验证教训 |
| 2026-06-04 | Round 28-29 语音/AI/社交本地 stub | LESSON-006 | 并行 worker 关闭前写入了与主实现不一致的 runner 片段，导致重复常量/函数编译失败 |
| 2026-06-04 | Round 30-33 远期能力与最终集成 | LESSON-006 复用 | 清理重复 runner 注册后，全量回归通过；后续并行 agent 需减少共享测试入口冲突 |
| 2026-06-04 | Round 34 主界面视觉修正 | LESSON-007 | 生活 RPG 逻辑验收通过但首屏仍显示工程占位，补充视觉验收与占位文案拦截 |
| 2026-06-04 | Round 35 Playfield 化 | 无 | 首屏从仪表盘式 UI 转为全屏小镇 playfield，MCP 截图与 headless 验证通过，未新增已验证故障 |
| 2026-06-04 | Round 36 Sprite2D 小镇资产化 | 无 | RuntimeMap 改为 Node2D/Sprite2D 小镇资产层，A-Z anchors 与居民视觉物件化，MCP 截图和 headless 验证通过，未新增已验证故障 |
| 2026-06-04 | Round 37 孩子端中文界面 | 无 | 主界面与生活反馈改为中文显示，保留英语为环境/系统资产名，focused tests 与 headless 验证通过，未新增已验证故障 |
| 2026-06-04 | Round 38 HUD 顶底栏收纳 | 无 | 左侧/右侧大面板收纳为顶部消息栏与底部按钮栏，MCP 截图和 focused/headless 验证通过，未新增已验证故障 |
| 2026-06-04 | Round 39 顶部 HUD 单行压缩 | 无 | 独立标题横幅合并进 48px 单行 TownHUD，MCP 截图和 focused/headless 验证通过，未新增已验证故障 |
| 2026-06-04 | Round 40 底部操作栏精简 | 无 | 孩子端底部常驻按钮精简为四个，旧快捷按钮隐藏保留 contract，MCP 截图和 focused/headless 验证通过，未新增已验证故障 |
| 2026-06-04 | Round 41 底部按钮儿童化视觉 | 无 | 底栏收窄居中，按钮改为柔和暖色胶囊并补齐交互状态，MCP 截图和 focused/headless 验证通过，未新增已验证故障 |
| 2026-06-04 | Round 42 背包与 HUD 状态分组 | 无 | 背包气泡和顶部金币/宠物状态拆分通过 focused/headless 与 MCP 场景树验证，未新增已验证故障 |
| 2026-06-04 | Round 43 长期路线规划 | 无 | 仅更新 `todo.md` 长期路线和 Ready 队列，未改运行时代码，未新增已验证故障 |
| 2026-06-04 | Round 44 V02.1 每日小镇 | LESSON-003 复用 | 新增每日服务时再次遇到跨服务返回值类型推断问题，按既有规则显式标注局部变量后通过；未新增已验证故障 |
| 2026-06-04 | Round 45 V02.2 我的小屋 | 无 | 小屋视图、家具旋转/收起、宠物用品和 Sunny 家内反馈通过 focused/headless 验证，未新增已验证故障 |
| 2026-06-04 | Round 46 V02.3 小镇记忆宫殿 | 无 | Anchor 互动、相册收藏状态和新词回访故事绑定通过 focused/headless 审计，未新增已验证故障 |
| 2026-06-04 | Round 47 V02.4 内容生产框架 | LESSON-008 | 内容合同验证器、候选内容包拦截和数据化 loader 回归通过 focused/headless 验证 |
| 2026-06-04 | Round 48 真实可玩路径修复 | LESSON-009 | 服务和合同测试曾通过，但孩子端相册、商店和小屋操作入口断裂；已补玩家可见操作级 smoke |
| 2026-06-05 | Round 49 PM 路线更新 | 无新增已验证教训 | 仅更新 `todo.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/10_美术风格与换肤预留.md`、`docs/14_内容基线整理与首批内容规划.md`；未改运行时代码，未运行 Godot 验证 |
| 2026-06-05 | Round 50 V02.5 美术素材生产线 | 无新增已验证教训 | 仅更新 `todo.md` 和 `docs/10_美术风格与换肤预留.md`；完成美术资产目录、场景、角色宠物、家具家园、UI 图标文档清单，未改运行时代码，未运行 Godot 验证 |
| 2026-06-05 | Round 51 PM 分派 | 无新增已验证教训 | 核对 `docs/14` 中 `V02-DESIGN-005` 轻事件规划后收口 V02.6，并新增 Round 51 任务包与两份小组验收草案；未改运行时代码，文档一致性检查、`godot --headless --path . --quit` 和 `godot --headless --path . --script tests/headless_runner.gd` 通过 |
| 2026-06-05 | Round 52 V02.7 发布前体验门槛 | 无新增已验证教训 | 顶部设置入口、设置面板、休息二次确认和安全位置路径通过 focused/headless 验证；截图、移动端和素材替换验收表落地，正式素材尚未接入 |
| 2026-06-05 | Round 52 素材验收收口 | 无新增已验证教训 | P0 production 素材通过 `ThemeProfile` / `AssetResolver` 接入主场景；运行时纹理断言、MCP 1280x720 截图抽查和 focused/headless 验证通过 |
| 2026-06-05 | Round 54 PM 路线重规划 | 无新增已验证教训 | 仅更新 `docs/12`、`docs/13`、`docs/14`、`docs/15` 和 `todo.md`，将后续路线调整为 V02.7A 美术基线重建与 V02.8 每日小镇生活纵切；未改运行时代码，未运行 Godot 验证 |
| 2026-06-05 | Round 54 截图证据复核 | LESSON-010 | MCP 已能提供 `1280x720` 运行时截图，但 headless dummy renderer 不能直接导出窗口纹理；V02.7A 的 `960x540` 门槛图需改走 MCP 或非 headless 路径 |
| 2026-06-05 | Round 59 V02.8 纵切收口 | 无新增已验证教训 | 5 分钟日常纵切 focused/full headless 验证通过，并注册进 `headless_runner`；截图沿用已通过的非 headless 双视口证据，未产生新的已验证故障 |
| 2026-06-05 | Round 60 V02.9 路线与排期 | 无新增已验证教训 | 仅更新 PM 文档、内容基线、任务包和 `todo.md`，建立 V02.9 一周回访节奏与 `V02-WEEKLY-002` Ready；未改运行时代码，未产生新的已验证故障 |
| 2026-06-05 | Round 61 V02.9 每日状态与商店轮换 | LESSON-003 / LESSON-004 复用 | 新增服务合同再次需要显式类型标注；失败编译曾留下 headless 测试进程，清理后 focused/full 验证通过；未新增新的已验证故障类型 |
| 2026-06-05 | Round 62 V02.9 P1 居民回访入口预收 | 无新增已验证教训 | 仅更新 PM 文档、内容基线、任务包和 `todo.md`，预收故事熊 / 巴士哥哥入口、安全边界、截图点和下一轮 smoke 输入；headless runner 与 Godot headless 启动通过，未产生新的已验证故障 |
| 2026-06-05 | Round 63 V02.9 一周回访 smoke 与截图 | 无新增已验证教训 | 新增 7 天玩家路径 smoke 并注册进 headless runner；非 headless `x11` 路径成功导出 1280x720 / 960x540 代表截图；未产生新的已验证故障 |
| 2026-06-05 | Round 64 V02.10 路线与 Ready 队列 | 无新增已验证教训 | 仅更新 PM 路线、内容基线、任务包和 `todo.md`，建立 V02.10 P1 居民回访扩展与 `V02-P1RETURN-001` Ready；未改运行时代码，未产生新的已验证故障 |
| 2026-06-05 | Round 65 V02.10 P1 真实可见入口 | 无新增已验证教训 | Bookshop / Bear Corner / Bus Stop / Taxi marker 四个入口通过可见 `看看` 路径、focused test、headless runner 和 Godot 启动验证；未产生新的已验证故障 |
| 2026-06-05 | Round 66 V02.10 P1 轻回访 | 无新增已验证教训 | 故事熊 / 巴士哥哥两条 P1 看一眼类支线通过可见 NPC / `看看` 路径、focused test、headless runner 和 Godot 启动验证；未产生新的已验证故障 |
| 2026-06-05 | Round 67 V02.10 B/T 相册记录 | 无新增已验证教训 | B Bear / T Taxi 入口查看与 P1 轻回访均通过真实 `看看` 路径写入 card state / 小镇相册；测试中复用 LESSON-003 显式类型标注规则，未新增新的已验证故障类型 |
| 2026-06-05 | Round 68 V02.10 P1 smoke 与截图 | 无新增已验证教训 | P1 回访 smoke、headless runner、非 headless x11 双视口截图均通过；并行截图曾因共用 user save 产生 JSON warning，已改为按 suffix 隔离保存文件，属于 LESSON-010/现有工具链规则内处理，未新增新的已验证故障类型 |
| 2026-06-05 | Round 69 V02.11 天气路线规划 | 无新增已验证教训 | 仅更新 PM 文档、内容基线、任务包和 `todo.md`，建立 V02.11 天气与小镇轻事件纵切与 `V02-WEATHER-001` Ready；未改运行时代码，未产生新的已验证故障 |
| 2026-06-05 | Round 69 V02.11 天气数据合同 | 无新增已验证教训 | P0 天气事件 JSON、today_status 引用、TodayStatusService、ContentContractValidator、focused tests 和 headless runner 均通过；合同测试发现安全说明复述禁词后已改为正向表达，属于 LESSON-008 规则内收敛 |
| 2026-06-05 | Round 70 V02.11 天气问候与轻变化 | 无新增已验证教训 | 天气问候变体、资源天气提示和商店活动角通过 focused/headless 验证；P0 商品和基础资源可得性保持不变，未产生新的已验证故障 |
| 2026-06-05 | Round 71 V02.11 A-Z 天气相册线索 | 无新增已验证教训 | S Sun、K Kite、B Bear、U Umbrella 天气相册线索通过真实 `看看` 路径、相册显示、focused/headless 验证；测试中复用 LESSON-003 显式类型标注和 LESSON-009 真实可见入口规则，未新增新的已验证故障类型 |
| 2026-06-05 | Round 72 V02.11 天气纵切 smoke 与截图 | 无新增已验证教训 | 多天气 day_key smoke、headless runner、非 headless x11 双视口截图均通过；截图取证按 LESSON-010 走显示驱动路径，未新增新的已验证故障类型 |
| 2026-06-05 | Round 73 V02.12 Home / School 中心 A-Z 世界规划合同 | 无新增已验证教训 | 新增 `az_world_plan` 数据合同、规划验证器和 focused/headless 回归；Home / School 双中心、26 anchor 分布、远郊边界和未来 0 基础挂接位均通过验证，未产生新的已验证故障 |
| 2026-06-05 | Round 74-76 V02.12 AZWORLD 任务包与阶段收口 | 无新增已验证教训 | 通过子 agent 分派和 PM 集成完成区域道路安全规划、17 个 reserved anchor 制作规格、Home / School 0 基础挂接、截图验收口径和扩展合同回归；未产生新的已验证故障 |
| 2026-06-05 | Round 77 V02.13 全量课本内容世界化主线策划 | 无新增已验证教训 | 三上公开来源摘要、8 册 source ledger、85 个单元摘要、世界映射、P0/P1/P2 主线分层、合同测试和 headless runner 均通过；仅新增数据 / 合同 / PM 文档，未接入孩子端 runtime |
| 2026-06-05 | Round 78 V02.14 Home / School P0 可玩纵切路线规划 | 无新增已验证教训 | 仅更新 PM 文档、内容基线、任务包和 `todo.md`，建立 V02.14 Home / School P0 路线与 `V02-HOMESCHOOL-002` Ready；未改运行时代码，未产生新的已验证故障 |
| 2026-06-05 | Round 79 V02.14 Home / School P0 可玩纵切实现 | 无新增已验证教训 | Home / Walk / School / Return P0 可见 `看看` 路径、A-Z 相册落账、focused/full headless 和 MCP 1280x720 截图抽查通过；共享 runner 曾缺 `_check_v0214_homeschool_slice()` 注册函数，按 LESSON-006 的共享 runner 集成规则补齐后通过，未形成新的故障类型 |
| 2026-06-05 | Round 80 V02.15 Home / School 日常回访路线规划 | 无新增已验证教训 | 仅更新 PM 文档、内容基线、任务包和 `todo.md`，建立 V02.15 学校生活轻循环路线与 `V02-SCHOOLDAILY-002` Ready；未改运行时代码，未产生新的已验证故障 |
| 2026-06-05 | Round 81 V02-SCHOOLDAILY-002 School Day State Contract 数据化 | 无新增已验证教训 | 7 天 school day state、loader / service、内容合同检查和 focused/headless 验证通过；未产生新的已验证故障 |
| 2026-06-05 | Round 82 V02.15 学校日常完整纵切收口 | 无新增已验证教训 | 7 天 Home -> Walk -> School -> Return 真实 `看看` 路径、Sunny return 保存、headless runner 和双视口截图均通过；未产生新的已验证故障 |
| 2026-06-05 | Round 83 V02.16 Playable RC Gate 路线规划 | 无新增已验证教训 | 仅更新 PM 文档、内容基线、任务包和 `todo.md`，建立 V02.16 可制作内容与体验抛光路线与 `V02-PRODUCTION-002` Ready；未改运行时代码，未产生新的已验证故障 |
| 2026-06-05 | Round 86 V02.17 世界地图运行时落地收口 | LESSON-011 | 26 anchor 全量运行时 smoke 发现近邻资源 / 旧坐标会吞掉 A-Z 相册路径，已调整交互优先级与天气 smoke 坐标 |
| 2026-06-05 | Round 87 V02.18 世界地图可读性路线规划 | 无新增已验证教训 | 仅更新 PM 文档、内容基线、任务包和 `todo.md`，建立 V02.18 地图视觉可读性与探索体验抛光路线与 `V02-MAPREAD-002` Ready；未改运行时代码，未产生新的已验证故障 |
| 2026-06-05 | Round 88 V02.18 世界地图可读性收口 | 无新增已验证教训 | 26 anchor 可读性 focused/full headless 验证通过；共享 runner helper 补齐属于 LESSON-006 规则内处理，未形成新的故障类型 |
| 2026-06-06 | Round 93 V02.19 ARTPASS-004 地图区域资产接入 | 无新增已验证教训 | 世界地图底图、9 个区域块、`anchor_assets` 合同和 runtime logical asset 接入通过 JSON、AssetResolver、V02.18 可读性、V02.17 runtime、全量 headless runner 和 Godot 启动验证；未产生新的已验证故障 |
| 2026-06-06 | Round 94 V02.19 ARTPASS-005 26 Anchor 物件接入 | 无新增已验证教训 | 26 个 anchor production 物件资产、ThemeProfile 映射和 runtime ObjectSprite 接入通过 JSON、AssetResolver、V02.18 可读性、V02.17 runtime、全量 headless runner 和 Godot 启动验证；未产生新的已验证故障 |
| 2026-06-06 | Round 95 V02.19 ARTPASS-006 样张驱动美术返工收口 | 无新增已验证教训 | 地图底图、26 anchor、glass UI skin 和 1280x720 runtime proof 通过 JSON、AssetResolver、V02.18 可读性、V02.17 runtime、Playable UI、RC Gate、全量 headless runner 和 Godot 启动验证；UI skin raw-load warning 已在本轮内改为 ResourceLoader 优先，未形成新的故障类型 |
| 2026-06-06 | Round 96 V02.19 ARTPASS-007 全屏构图与 UI 返修收口 | 无新增已验证教训 | 针对用户视觉反馈完成 1280x720 fullscreen playfield、弱化旧路格、常驻 HUD/footer 轻玻璃化和底栏按钮比例统一；focused/full headless 与非 headless 1280 proof 均通过，未形成新的故障类型 |

## LESSON-002：并行交付必须在 agent 完成后再固定集成断言

- **日期：** 2026-06-04
- **关联任务：** `V02-MAP-001`、`V02-RUNTIME-001`
- **现象：** 地图数据 agent 尚未完成时，中间版本包含 Bus Station；集成测试据此暂时断言 4 个地点。agent 最终按任务范围收敛为 Home、Town Start、Supermarket 3 个地点，导致测试失败。
- **影响：** 集成测试对未完成交付建立了错误预期，产生一次无效失败和返工。
- **根因：** 主 Agent 在并行 worker 状态仍为工作中时，读取并依赖了其尚未稳定的写入结果。
- **解决方式：** 等待 worker 完成通知后，以最终文件和交付说明重新核对合同，将 smoke test 固定为 3 个地点。
- **预防规则：**
  - 可以提前审查并行任务的中间结果，但不得据此锁定合同或完成状态。
  - 集成断言必须在 worker 完成后，对照任务验收标准和最终文件确定。
  - 并行写入期间避免修改 worker 所有权范围内的文件。
- **验证依据：** 最终 `world_map.json` 包含 3 个地点、9 个 anchor；修正后的 headless runner 以最终合同为准。

## LESSON-003：Godot 4.6 中动态返回值要显式标注局部变量类型

- **日期：** 2026-06-04
- **关联任务：** `V02-QUEST-001`
- **现象：** `quest_event_service.gd` 中 `var purchase := shop_service.buy_pet_food()`、`var feed := pet_service.feed()` 等写法触发 “Cannot infer the type” 编译错误。
- **影响：** `tests/test_quest_event_service.gd` 无法加载依赖脚本，服务级主循环测试失败。
- **根因：** GDScript 对未声明类型的动态服务返回值推断不稳定，尤其在跨脚本方法调用和 `String.split()` 结果取值时。
- **解决方式：** 将相关局部变量改为显式类型，如 `var purchase: Dictionary`、`var pet_key: String`。
- **预防规则：**
  - 服务间返回 `Dictionary` 的调用点使用显式局部变量类型。
  - 新增脚本必须通过 `godot --headless --path . --check-only --script <file>`。
- **验证依据：** `quest_event_service.gd` check-only 通过，`tests/test_quest_event_service.gd` 通过。

## LESSON-004：失败或超时的 headless 测试可能留下后台进程

- **日期：** 2026-06-04
- **关联任务：** `V02-QUEST-001`、`V02-LOOP-002`
- **现象：** 早期 QuestEventService 编译失败后，系统中残留 `godot --headless --path . --script tests/...` 进程。
- **影响：** 后续测试可能受到资源占用或旧进程输出干扰。
- **根因：** 组合命令中某个 Godot script 编译失败后，进程未及时退出。
- **解决方式：** 手动检查并结束残留测试进程，再重新运行验证。
- **预防规则：**
  - 长跑或新 runner 使用 `timeout` 包裹。
  - 失败后执行 `ps -ef | rg 'godot --headless --path \\. --script tests/'` 检查残留。
- **验证依据：** 残留进程清理后，全套 headless 测试和 check-only 均通过。

## LESSON-005：产品参照类型必须写成主目标而不是隐含氛围

- **日期：** 2026-06-04
- **关联任务：** `V02-RESET-001`、`V02-RESET-002`、`V02-RESET-003`
- **现象：** 早期文档虽然写了“小镇生活”和“低压力”，但执行计划仍围绕英语学习闭环、A-Z、Memory Card 和 Letter Snake 展开，导致开发结果偏向学习原型，而不是动物森友会式生活 RPG / 养成。
- **影响：** 后续任务优先级错误，NPC、商店、宠物和地图都服务于学习奖励链，缺少角色移动、探索、NPC 关系、资源、家具和家园装饰等真正的生活模拟核心。
- **根因：** 产品参照类型没有在 `docs/01_产品总纲.md`、`docs/06_核心玩法循环.md` 和 `todo.md` 中明确为第一目标；学习系统被写成主循环而不是环境层。
- **解决方式：** 已执行方向纠偏，将产品定位改为生活 RPG / 小镇养成，旧学习闭环归档为技术资产；同时确认 A-Z 记忆宫殿不是可删除模块，而是地图底层编码和潜意识学习方法。
- **预防规则：**
  - 每轮开发前核对主循环是否仍是“探索、NPC、收集、商店、家园装饰、保存”。
  - 英语、Memory Card 和 Letter Snake 只能作为环境、收藏或可选活动，不能重新成为主线推进条件。
  - A-Z 记忆宫殿必须通过世界地图锚点保留，每个字母要有稳定位置、核心物件和路线顺序。
  - 新增单词必须绑定 `core_anchor_id`、地图地点、故事画面、视觉钩子和回访路径，不能作为孤立词条加入。
  - 新任务若不服务生活 RPG MVP，默认不得进入 Ready。
- **验证依据：** `docs/01_产品总纲.md`、`docs/06_核心玩法循环.md`、`docs/12_V02开发路线.md`、`AGENTS.md` 和 `todo.md` 已更新为生活 RPG / 小镇养成方向。

## LESSON-006：并行 worker 不应同时修改共享 runner 入口

- **日期：** 2026-06-04
- **关联任务：** `V02-FUTURE-004`、`V02-FUTURE-005`、`V02-FUTURE-006`、`V02-FUTURE-007`、`V02-QA-002`
- **现象：** 语音/AI/社交 worker 超时关闭前，曾向 `tests/headless_runner.gd` 写入一组旧接口名的 preload 和 `_check_voice_ai_social_stubs()`。主 Agent 随后实现最终接口并再次注册同名常量和函数，导致 Godot 报 “same name as a previously declared constant/function” 编译错误。
- **影响：** focused tests 已通过但全量 runner 无法加载，最终集成被阻断一次。
- **根因：** 多个并行执行者共享修改 `tests/headless_runner.gd`，且关闭中的 worker 产出没有经过最终接口核对；测试入口属于高冲突文件，不适合让多个 worker 同时写。
- **解决方式：** 保留与最终服务接口一致的 runner 检查，删除旧接口重复常量和重复函数；重新运行全量 headless 通过。
- **预防规则：**
  - 并行 worker 可以新增 focused test，但默认不直接修改共享 runner。
  - 共享 runner 由主 Agent 在集成阶段统一注册，注册前先 `rg` 检查同名 preload 和函数。
  - 关闭或超时的 worker 结果必须作为待审片段处理，不能默认视为已集成完成。
- **验证依据：** 清理重复注册后，`godot --headless --path . --script tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过。

## LESSON-007：主循环验收必须包含首屏视觉和玩家感知

- **日期：** 2026-06-04
- **关联任务：** `V02-LIFE-001` 至 `V02-LIFE-013`、`V02-UI-002`
- **现象：** 生活 RPG 相关服务、地图节点和 headless 行为测试均已完成，但启动首屏仍显示 `StudyGame V02`、`Godot skeleton`、`Loaded places ... from JSON` 等工程占位文案，玩家看到的风格没有变成 Sunshine Town 生活小镇。
- **影响：** `todo.md` 显示生活 MVP 已完成，但实际玩家第一感知仍像技术原型，导致产品方向纠偏没有落到主界面体验。
- **根因：** 早期验收偏向服务、数据合同和节点存在性，没有把首屏身份、视觉层级、占位文案清理和地图主视觉纳入自动验收。
- **解决方式：** 新增并完成 `V02-UI-002`，将主场景改为 Sunshine Town 标题、地图主舞台、右侧生活 HUD、温暖小镇色彩和更清晰的地点/NPC/anchor 表现；在 `headless_runner` 中拦截工程占位文案并要求首屏包含 Sunshine Town 身份。
- **预防规则：**
  - 所有“风格改变”“方向纠偏”“玩家体验”任务必须包含玩家可见首屏验收，不能只验收服务或节点。
  - 主界面不得保留 skeleton、Loaded from JSON、engine/version/debug summary 等工程占位文案。
  - Headless 测试需要扫描孩子端可见文本，防止工程占位、学习压力和家长后台文案回流。
  - 视觉任务完成前，至少运行主场景测试、全量 headless runner，并在 Godot 编辑器可用时做截图检查。
- **验证依据：** `godot --headless --path . --check-only --script scripts/main.gd`、`tests/test_life_rpg_scene.gd`、`tests/test_playable_loop_smoke.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；MCP 截图因 Godot 编辑器插件未运行无法执行。

## LESSON-008：内容生产必须先过合同验证

- **日期：** 2026-06-04
- **关联任务：** `V02-CONTENT-001` 至 `V02-CONTENT-005`
- **现象：** 每日委托、NPC 问候、家具商品、anchor 回访和新词故事都开始转向 JSON 数据生产；如果缺少统一合同，新增内容容易漏稳定 ID、漏 memory-story 字段、写入非法价格，或不小心覆盖核心 A-Z 锚点。
- **影响：** 主流程脚本会重新承载内容规则，后续扩展需要反复改 `scripts/main.gd`，并可能破坏记忆宫殿路线和儿童安全文本边界。
- **根因：** 数据化只解决“放在哪里”，还需要验收“能不能放、字段是否完整、是否伤害核心结构”。
- **解决方式：** 新增内容合同验证器，统一检查稳定 ID、重复 ID、非法价格、儿童安全文本、memory-story 绑定、核心 A-Z 覆盖和候选内容包错误；全量 runner 注册该合同检查。
- **预防规则：**
  - 新每日委托、NPC 问候、商品家具、anchor 回访和新词故事默认只改 JSON 与 focused test。
  - 候选内容包不能覆盖核心 A-Z anchor；新增单词必须绑定 letter、core_anchor_id、world_place_id、story_memory、visual_hook 和 review_path。
  - 修改共享 runner 仍由 PM 集成，新增内容先用 focused contract test 证明可加载。
- **验证依据：** `tests/test_v024_content_contracts.gd`、`tests/headless_runner.gd`、`godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd` 和 `godot --headless --path . --quit` 均通过。

## LESSON-009：隐藏 contract 按钮不能证明孩子端可玩

- **日期：** 2026-06-04
- **关联任务：** `V02-PLAYABLE-001` 至 `V02-PLAYABLE-004`
- **现象：** V02.1-V02.4 服务、数据合同和旧 smoke 测试均通过，但实际孩子端没有可见入口打开相册；商店购买依赖隐藏按钮或直接脚本方法；小屋家具摆放、旋转、收起也缺少真实可见操作路径。
- **影响：** `todo.md` 标记为完成的功能在玩家视角不可玩，项目看起来“系统存在”，但不能形成动物森友会式自由操作闭环。
- **根因：** 测试覆盖了服务方法、隐藏 contract 按钮和内部脚本调用，却没有要求通过当前孩子端可见 UI 按钮完成动作；`is_visible_in_tree()` 在 headless 手动场景中也不足以区分真实可见入口和隐藏父容器。
- **解决方式：** 新增相册覆盖层、背包内相册入口、商店货架面板、小屋物件面板，并新增 `test_playable_ui_operations.gd`；全量 `headless_runner` 注册玩家可见按钮路径，按可见按钮打开相册、商店、小屋并验证存档变化。
- **预防规则：**
  - 每个宣称“可玩”的孩子端动作必须有可见入口，且至少一个测试通过可见按钮或面板按钮触发。
  - 隐藏 contract 按钮只允许保留兼容性，不能作为完成验收依据。
  - 新增或精简 HUD/底栏后，必须同步跑玩家操作级 smoke，覆盖相册、商店、背包、小镇/小屋、`看看`、资源、NPC、anchor 和家具操作。
  - Headless UI 可见性检查应沿 Control 父链检查 `visible`，避免把隐藏父容器里的按钮当成孩子端入口。
- **验证依据：** `tests/test_playable_ui_operations.gd`、`tests/test_memory_album_scene.gd`、`tests/test_life_rpg_scene.gd`、`tests/test_playable_loop_smoke.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过。

## LESSON-010：headless dummy renderer 不能作为截图验收的唯一工具链

- **日期：** 2026-06-05
- **关联任务：** `V02-ARTBASE-005`
- **现象：** 通过 Godot MCP 可以拿到 `/root/Main` 的 `1280x720` 运行时截图，历史截图辅助脚本在 `godot --headless` 下执行时，`root.get_texture()` 返回空，无法导出 PNG。
- **影响：** 即使运行时主场景和 UI 已真实出现，QA 仍无法仅靠 headless dummy renderer 自动补齐 `960x540` 门槛图，容易把“截图没出”误判成“布局一定失败”。
- **根因：** `--headless` 使用 dummy renderer，不提供可直接读取的窗口纹理；脚本级 `get_texture().get_image()` 并不是稳定可用的截图路径。
- **解决方式：** 保留 headless 用于合同与逻辑回归；截图验收改为使用 MCP 运行时截图或非 headless 显示驱动；后续清理轮已移除旧截图辅助脚本，视觉取证不再复用该文件。
- **预防规则：**
  - 视觉验收任务必须提前区分“逻辑回归工具链”和“截图取证工具链”，不要默认二者都由 headless 完成。
  - 新增截图脚本时，先验证目标渲染路径是否真的能返回窗口纹理，再把它写进 PM 门槛。
  - 当 `1280x720` 已由 MCP 证明运行时可见、但较小视口截图缺失时，先记录工具链阻塞，再决定是否需要继续追查布局问题。
- **验证依据：** Godot MCP 曾捕获 `/root/Main` 的 `1280x720` 运行时截图；旧 capture 脚本曾复现 headless 空纹理问题，后续已清理。

## LESSON-011：密集地图热点必须验证交互优先级和旧坐标回归

- **日期：** 2026-06-05
- **关联任务：** `V02-WORLDMAP-002` 至 `V02-WORLDMAP-005`
- **现象：** V02.17 26 anchor 运行时 smoke 初次验证时，B Bear 附近的树枝资源先于 anchor 被 `interact_nearby()` 收集，导致相册未落账；V02.11 weather smoke 仍使用 K Kite / U Umbrella 的旧坐标，无法触发迁移后的天气相册线索。
- **影响：** 地图数据已经包含 26 个 anchor，但孩子端真实 `看看` 路径可能被近邻资源、NPC 或旧截图点吞掉，造成“合同存在但玩家不可点亮”的假完成。
- **根因：** 旧交互顺序是 exact hotspot -> nearby resource -> nearby anchor，资源点和 A-Z anchor 变密后会发生优先级冲突；同时旧 smoke 的固定坐标没有随 V02.17 运行时坐标迁移。
- **解决方式：** `interact_nearby()` 改为 exact hotspot -> exact resource -> nearby anchor -> nearby resource -> NPC，保留站在资源格上的收集路径，同时让近邻 A-Z `看看` 不被资源抢占；V02.11 weather smoke 与 headless runner 更新 K Kite / U Umbrella 到 V02.17 坐标。
- **预防规则：**
  - 新增或迁移地图热点时，必须跑真实 `看看` 路径 smoke，不能只检查 node / JSON 存在。
  - 资源、NPC、地点 hotspot 和 A-Z anchor 半径重叠时，要明确 exact 与 nearby 的优先级，并验证相册落账和资源收集都仍可达。
  - 迁移 anchor 坐标后，同步更新天气、P1、截图和历史 smoke 的固定 look cell，或改为从 `world_map.memory_anchors` 读取。
- **验证依据：** `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --script tests/test_v0211_weather_slice_smoke.gd`、`godot --headless --path . --script tests/test_v028_daily_life_slice.gd`、`godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`、`godot --headless --path . --script tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过。
