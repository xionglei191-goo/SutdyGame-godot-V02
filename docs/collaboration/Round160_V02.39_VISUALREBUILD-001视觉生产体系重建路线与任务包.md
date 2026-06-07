# Round160 V02.39 VISUALREBUILD-001 视觉生产体系重建路线与任务包

> 日期：2026-06-07
> 任务：`V02-VISUALREBUILD-001 Godot 视觉生产体系重建路线与任务包`
> 状态：规划收口；下一项 Ready 为 `V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同`
> 写入范围：docs 12-15、`todo.md`、`lessons.md`、本协作文档；不改 runtime / data / tests / assets。

## 结论

V02.38 Round155-Round159 完成了有价值的工程脚手架：TownStage 已经能摆脱 full-map background，使用 terrain / region / prefab / prop / actor / glass UI 分层渲染。但用户二次视觉复核确认，当前画面仍明显偏离 `docs/collaboration/artpass003_visual_direction/`，不能继续称为 `visual_candidate`，更不能授予 `final_approved` 或恢复 StoryBatch runtime 扩张。

根因不是若干局部 bug，而是生产模型错误：项目仍以 `world_map` 数据、cell、place、anchor、NPC 和功能入口为第一驱动，再把视觉资产贴到运行时上。目标方向要求先有 1280 gameplay target frame，再把视觉构图、层级、透视、密度和交互代理拆成 Godot 可执行合同，最后绑定回运行时。

## 逐问题拆解

| 问题 | 表层现象 | 更深根因 | 后续处理 |
|---|---|---|---|
| 首屏构图失败 | 当前 Town 像地图 / 编辑器叠层，不像 home-centered cozy town | 没有先锁定目标画面，逻辑地点和系统入口抢占首屏 | V02-VISUALREBUILD-002 先产出 target frame 和构图合同 |
| 旧场景碎片污染 | 低透明 place context 仍像灰色旧图残留 | fallback 对功能友好，但对最终 proof 有害 | Visual Layout 合同中明确哪些旧 context 必须清零，哪些只能做不可见代理 |
| A-Z 压过生活感 | 26 anchors / badge 仍像字母地图索引 | 记忆宫殿结构和首屏视觉优先级没有分层 | 首屏只保留少量 prop-first 线索，其余通过探索 / focus / 相册分层出现 |
| 地点标签像 UI debug | label 与环境不融合 | place ID / name 直接可视化，没有环境 signage 设计 | 标签改为世界物件、招牌或靠近态提示，不做常驻系统名牌 |
| 资产风格碎片化 | building、terrain、anchor、actor、HUD 代际不统一 | 按任务批次生产，而非按同一 target frame 统一生产 | V02-VISUALREBUILD-004 只接受同相机、同光源、同比例资产包 |
| Home interior 原型感 | 小屋功能可用但不温暖 | HomeRoom 仍按操作面板和占位家具证明功能 | V02.39 先做首屏 town visual match，Home interior 作为后续独立 target frame |
| 验收偏工程 | no-full-map、headless、入口 smoke 通过但画面仍不对 | 自动化 gate 被误作美术批准 | 新 gate 必须 target frame 与 runtime screenshot 并排人工复核 |

## 系统级根因

| 维度 | 诊断 | 必须改变的规则 |
|---|---|---|
| Art | 方向参考没有转成 Godot 可执行 art bible / target-frame contract | 每次 visual approval 前必须先有 1280 target frame、paintover 或等价静态目标图 |
| Architecture | Logic Map 与 Visual Layout 融在一起 | `world_map` 管事实；Visual Layout 管构图、depth、occlusion、visual proxy 和 focus state |
| Code | fallback / context marker / label 机制适合功能回归，不适合 final proof | final proof 模式必须能关闭旧 context、debug-like label 和高噪声 badge |
| Planning | 首屏承担太多系统展示 | 首屏先证明“可居住的小镇”，系统入口和内容批次延后绑定 |
| UX / UI | HUD 仍解释系统，压过世界 | glass UI 只支持状态和操作，不承担说明书职责 |
| QA | 自动化检查尺寸、节点、入口，缺少 art-direction 对照 | Gate 增加 target/runtime side-by-side、构图、比例、密度、残留和 A-Z 降噪检查 |
| Tooling | Map Editor 适合逻辑 authoring，不适合单独完成 artpass 构图 | Map Editor 继续管数据；Visual Layout 需要独立 target-frame authoring / placement contract |
| Godot feasibility | Godot 可以实现目标，但不能靠现有 data-map 直接自然长出来 | 先静态画面匹配，再恢复交互和动态系统 |

## 新状态语义

| 状态 | 含义 |
|---|---|
| `production` | 资源或实现可集成，有 logical asset ID / provenance / 接入记录。 |
| `functional_pass` | 真实入口、交互、保存或回归成立，但不代表视觉目标通过。 |
| `visual_scaffold` | 工程层级存在，能支撑后续视觉重建，但当前画面未达目标。V02.38 当前属于此状态。 |
| `art_target_locked` | 1280 target frame 与 Godot 可执行视觉合同已通过 PM / Art Direction。 |
| `runtime_visual_match` | Godot runtime 1280 screenshot 与 target frame 并排复核足够接近。 |
| `final_approved` | runtime visual match、真实入口、A-Z 稳定、儿童安全文本和 PM / Art Direction 最终判断全部通过。 |

## V02.39 任务队列

| 顺序 | 任务 | Owner | 交付物 | 验收 |
|---|---|---|---|---|
| 1 | `V02-VISUALREBUILD-001` 视觉生产体系重建路线与任务包 | PM / Art Direction / UX / QA | docs 12-15、`todo.md`、`lessons.md`、Round160 | 当前文档事实同步；StoryBatch 阻塞；下一项 Ready 明确 |
| 2 | `V02-VISUALREBUILD-002` 1280 目标画面与 Godot 可执行视觉合同 | PM / Art Direction / Tech Art / UX | target gameplay frame、layer contract、camera / depth / scale / UI safe area / A-Z priority 表 | 达到 `art_target_locked`；不改 runtime |
| 3 | `V02-VISUALREBUILD-003` Logic Map / Visual Layout 分层方案 | Tech Lead / Godot / Tooling / QA | 数据边界、visual layout schema 或 scene contract、迁移策略 | 旧 `world_map` 事实不退化；首屏视觉布局不再由 cell 全量直推 |
| 4 | `V02-VISUALREBUILD-004` 首屏统一环境资产包与 composition kit | Art Direction / Asset / Tech Art | terrain、region、building、prop、shadow、actor scale、glass UI 资产包 | 同风格、同比例、同光源；logical asset ID 完整；无旧 scene fragment 混入 |
| 5 | `V02-VISUALREBUILD-005` TownStage runtime visual match 纵切 | Godot / Tech Art / QA | Godot 1280 runtime frame、visual layout binding、必要交互代理 | target/runtime 并排复核达到 `runtime_visual_match`；真实入口不退化 |
| 6 | `V02-VISUALREBUILD-006` Art-direction gate 与 StoryBatch 解锁判定 | PM / Art Direction / UX / QA | final gate 记录、截图包、阻塞解除或继续返修结论 | 只有通过 gate 才能把 `V02-STORYBATCH-004` 转 Ready |

## 当前阻塞与禁改

- `V02-STORYBATCH-004/005` 继续阻塞；Round153 第二批 production 资产只作为库存保留。
- 不新增第三批 story prop，不扩远郊 P0，不新增课程 UI、词表墙、完成率或字母顺序任务。
- 不重新规划 A-Z anchor ID、letter、core_word、route_order、card_id 或 audio_id。
- 不把 `world_map_base_1280.png` 或任何整张底图恢复为 final runtime 主画面。
- 不把 no-full-map、layer count、headless runner、真实入口 smoke 或 `visual_scaffold` 自动解释为 `final_approved`。

## 下一项 Ready 输入

`V02-VISUALREBUILD-002` 开工时必须先读取：

- `docs/collaboration/artpass003_visual_direction/`
- `docs/collaboration/Round92_V02.19_ARTPASS-003视觉方向确认包.md`
- `docs/collaboration/Round159_V02.38_VISUALRECOVERY-006_1280FinalVisualGate.md`
- 本文件
- `docs/12_V02开发路线.md`
- `docs/13_V02详细开发计划.md`
- `todo.md`

交付不得只写文字描述；必须形成能让 Godot / Tech Art 执行的 1280 visual contract，至少包含 target frame、layer order、camera、depth bands、asset scale、visual anchor priority、occlusion rules、UI safe area、A-Z first-screen policy、forbidden remnants 和 proof comparison checklist。
