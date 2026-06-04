# StudyGame V02 开发经验记录

> 最后更新：2026-06-04  
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
