# Round165 V02.39 VISUALREBUILD-006 Art-direction Gate 与 StoryBatch 解锁判定矩阵

> 日期：2026-06-07
> 任务：`V02-VISUALREBUILD-006 Art-direction gate 与 StoryBatch 解锁判定`
> Owner：QA / PM / Art Direction / UX
> 写入范围：本文档；不改 runtime / data / tests / assets。
> 当前输入事实：V02.38 Round155-Round159 已重解释为 `visual_scaffold`；Round161 target PNG 已被用户复核驳回，`art_target_locked` 已撤销；`V02-STORYBATCH-004/005` 继续阻塞；只有 V02.39 重新取得有效 target frame、达到 `runtime_visual_match` 并通过本 gate，StoryBatch 才可恢复。

> 返修状态：本文为 gate 规则草案与后续复核矩阵，不代表当前可进入 gate；在 `V02-VISUALREBUILD-002` 重新通过 target gameplay frame 复核前，不得用本文解锁 `V02-VISUALREBUILD-004` 或 StoryBatch。

## 输入事实

- `todo.md` 当前状态面板、分工表和正式阶段任务列表均记录：`V02-STORYBATCH-004/005` 阻塞；Round161 生成的 target PNG 已被用户复核为“完全不是项目想要的游戏画面”，只能保留为 rejected evidence；`art_target_locked` 撤销，`V02-VISUALREBUILD-002` 回到返修进行中，`V02-VISUALREBUILD-004` 暂停且不得据此生产资产包。
- `docs/13_V02详细开发计划.md` 和 `docs/15_项目经理接管与下一阶段执行计划.md` 已固定 V02.39 顺序：`target 1280 frame -> visual layout / layer / perspective / density contract -> unified asset kit -> Godot runtime static-frame match -> gameplay binding -> art-direction gate`。
- Round159 证明 no-full-map modular runtime 与真实入口 smoke 成立，但二次复核后只可作为 `visual_scaffold` 证据；Round160 明确工程脚手架不能替代目标画面批准。
- `LESSON-014` 要求区分 `production`、`functional_pass` 和 `final_approved`；`LESSON-015` 要求视觉测试同时检查下限和噪声上限；`LESSON-016` 要求先有 target frame 和 target/runtime 并排 art-direction gate；`LESSON-017` 要求概念插画不得替代可执行 gameplay target frame。

## Final Gate 进入条件

`V02-VISUALREBUILD-006` 不能在早期直接开 gate。进入 final gate 前，必须已经具备以下全部前置证据：

| 前置条件 | 必须已有证据 | 不足时状态 |
|---|---|---|
| `art_target_locked` | `V02-VISUALREBUILD-002` 已交付 1280 target gameplay frame、camera、depth bands、layer order、asset scale、UI safe area、A-Z priority、forbidden remnants 和 proof checklist，并由 PM / Art Direction 认可。 | 继续阻塞；不得进入 runtime 批准。 |
| `runtime_visual_match` | `V02-VISUALREBUILD-005` 已提交 Godot 1280 runtime screenshot，与 target frame 并排复核，构图、比例、光源、密度、UI、actor、anchor 噪声和旧残留均足够接近。 | 返修到 V02-VISUALREBUILD-005。 |
| 同轮 1280 proof | gate 当轮重新导出 `1280x720` runtime PNG，不复用旧截图；截图包含 target/runtime 并排版和原始 runtime 图。 | 保持 `runtime_visual_match` 以下，不做 final 判定。 |
| 真实入口 smoke | 从孩子端真实启动、移动、`看看`、Home / Shop / School / Album or UI / Settings or safe path 中至少一条完整生活路径通过；不能只调用 service 或打开内部 panel。 | `functional_pass` 不足或返修。 |
| A-Z 稳定 | 26 个 A-Z stable ID / letter / route_order / core_word / card_id / audio_id 不被改写；首屏只以 prop-first 线索呈现，badge / label 不压过生活感。 | 阻塞 StoryBatch；必要时返修 Visual Layout。 |
| 儿童文本安全 | 可见文本、prompt、HUD、album label、NPC 短句和 debug 残留扫描通过；无课程、测试、分数、打卡、坐标、grid、cell、强压力或强消费文案。 | 返修文案；不得 final approved。 |

## 判定矩阵

| 判定结果 | 何时使用 | 必须有的证据 | 后续动作 |
|---|---|---|---|
| 继续阻塞 | 缺少 `art_target_locked`，或尚未完成 V02-VISUALREBUILD-003/004/005，或没有同轮 1280 proof。 | 阻塞原因、缺失证据、解除条件、当前仍可用的历史证据列表。 | `V02-STORYBATCH-004/005` 维持 `[!]`；`todo.md` 状态面板、分工表、正式任务列表和阻塞项保持一致。 |
| 返修 | 已进入 V02.39 后段，但 target/runtime 并排复核发现构图、比例、噪声、旧残留、A-Z priority、UI safe area、真实入口或儿童文本任一不达标。 | 失败截图、失败项说明、目标 frame 对照差异、负责返修任务 ID、复测命令。 | 回退到对应任务：target 问题回 V02-VISUALREBUILD-002，layout 问题回 003，资产问题回 004，runtime 匹配问题回 005，gate 文案 / 入口问题由 006 返修复核。 |
| `runtime_visual_match` | Godot runtime 1280 frame 与 target frame 并排足够接近，真实入口未退化，但 PM / Art Direction 尚未做 final gate 或截图包不完整。 | target frame、runtime PNG、并排复核表、视觉噪声上限 / exact count、真实入口 smoke、A-Z 稳定记录。 | 可进入 `V02-VISUALREBUILD-006` final gate；仍不得自动解锁 StoryBatch。 |
| `final_approved` | final gate 全部通过，PM / Art Direction 明确签出。 | `art_target_locked`、`runtime_visual_match`、同轮 1280 proof、真实入口 smoke、A-Z 稳定、儿童文本安全、target/runtime 并排判定、PM / Art Direction 结论。 | V02.39 视觉 gate 可收口；准备 StoryBatch 解锁 ledger。 |
| StoryBatch 解锁 | `final_approved` 已成立，且 StoryBatch-004 的工作范围不会破坏刚批准的 Visual Layout / A-Z / child safety。 | final gate 文档、截图包、复核命令结果、StoryBatch-004 恢复范围、todo/docs ledger 同步清单。 | 将 `V02-STORYBATCH-004` 从阻塞转 Ready；`V02-STORYBATCH-005` 保持阻塞或待办，直到第二批 runtime smoke 后再做 proof / approved 判定。 |

## 不可替代项

以下证据不能单独或组合替代 `final_approved`：

- `godot --headless --path . --script tests/headless_runner.gd` 通过。它只能证明功能和合同回归，不证明画面达到 target。
- `production` asset 状态。它只代表资源可集成、有 logical asset ID / provenance / 接入记录，不代表孩子端可见或视觉批准。
- `visual_scaffold`。它只代表工程层级存在，不能替代 `art_target_locked`、`runtime_visual_match` 或 final gate。
- Round119 或更早的旧 `approved`。这些历史结论按 `functional_pass` 管理，不得继承为 V02.39 `final_approved`。
- 单张截图。final gate 至少需要 target/runtime 并排、同轮 1280 runtime proof、真实入口 smoke、A-Z 稳定和儿童文本安全一起成立。

## StoryBatch-004 转 Ready 的精确条件

`V02-STORYBATCH-004 第二批 runtime 接入与真实入口 smoke` 只能在以下全部条件满足后，从 `[!]` 阻塞转为 Ready：

| 条件 | 通过口径 |
|---|---|
| V02.39 final gate 已通过 | 本文或后续同类 gate 文档明确写出 `final_approved`，且不是仅写 `runtime_visual_match`。 |
| `runtime_visual_match` 证据仍同轮有效 | StoryBatch 解锁使用的 runtime proof 与 final gate 同轮或经过明确复核；不得拿 Round159 或旧 proof 解锁。 |
| StoryBatch-004 范围不叠回视觉噪声 | 第二批 C/D/G/K/O/S/W story prop runtime 接入必须遵守 Visual Layout 的 prop priority、occlusion、focus state、UI safe area 和 forbidden remnants。 |
| 真实入口 smoke 不退化 | 启动、移动、`看看`、Home / Shop / School / Album or UI / Settings or safe path 仍可从孩子端路径触发。 |
| A-Z 稳定 | 不改 stable anchor ID、letter、route_order、core_word、card_id、audio_id；新 story prop 只绑定既有 anchor story / review path。 |
| 儿童文本安全 | 新增短句、album label、prompt 和反馈不得出现课程化、测试化、压力化或 debug / grid / cell 术语。 |
| PM / Art Direction 明确解锁 | 解锁记录必须写入 collaboration 文档，并同步到 `todo.md` 与 docs ledger。 |

### Ledger 同步清单

解锁时必须同步以下位置，不能只改状态面板或只改分工表：

| 文件 / 区域 | 必须同步内容 |
|---|---|
| `todo.md` 当前状态面板 | Ready 改为 `V02-STORYBATCH-004`；阻塞项中移除或改写 StoryBatch-004；保留 StoryBatch-005 的依赖状态。 |
| `todo.md` 本轮分工 | `V02-STORYBATCH-004` 从阻塞改为 Ready；备注写明 final gate 文档和截图包路径。 |
| `todo.md` 当前正式阶段任务列表 | 若 V02.39 收口，则把 `V02-VISUALREBUILD-006` 标 `[x]`，并在 StoryBatch 列表中把 `V02-STORYBATCH-004` 标 Ready / `[ ]`；不得漏掉正式任务表。 |
| `todo.md` 完成记录 | 记录 gate 结论、命令、截图包、child-safety 和 A-Z 稳定结论。 |
| `docs/12_V02开发路线.md` | 若阶段路线从 V02.39 进入 StoryBatch runtime，更新当前阶段和下一项 Ready。 |
| `docs/13_V02详细开发计划.md` | 更新 V02.39 / V02.37+ 表格中 StoryBatch-004 的阻塞解除事实。 |
| `docs/14_内容基线整理与首批内容规划.md` | 若第二批内容恢复，标明仍只恢复 C/D/G/K/O/S/W 的既有内容包，不新增第三批。 |
| `docs/15_项目经理接管与下一阶段执行计划.md` | 同步状态语义、final gate 结论、StoryBatch-004 Ready 和 StoryBatch-005 仍需 runtime smoke 后判定。 |
| `lessons.md` | 只有出现新故障、失败模式或经验证的预防规则时新增 lesson；单纯通过不新增 lesson。 |

## 复核命令与截图包要求

Gate 复核至少需要以下命令或等价证据。命令可由后续实际实现按文件名调整，但证据类型不可省略。

| 复核项 | 推荐命令 / 证据 | 通过标准 |
|---|---|---|
| 静态 sanity | `git diff --check` | 无 whitespace / patch 格式问题。 |
| Godot 启动 | `godot --headless --path . --quit` | 项目可启动退出。 |
| Focused visual layout / runtime tests | V02.39 对应 focused tests，例如 visual layout contract、asset kit、runtime visual match、A-Z stability、child text safety。 | 不能只跑 full runner；必须覆盖本阶段新增合同。 |
| Full regression | `godot --headless --path . --script tests/headless_runner.gd` | 全量回归通过；若失败，不进入 final gate。 |
| Capture script check-only | V02.39 capture script 的 `--check-only` | capture 脚本可加载。 |
| Non-headless 1280 capture | `godot --path . --display-driver x11 --resolution 1280x720 --script <V02.39 capture script>` | 生成同轮 `1280x720` runtime proof；遵循 LESSON-010，不能用 headless 空纹理截图替代。 |
| 尺寸确认 | `file <proofs>/*.png` 或 `identify <proofs>/*.png` | 每张 proof 均为 `1280 x 720`。 |
| 人工 art-direction 复核 | target frame 与 runtime screenshot side-by-side，附差异表。 | 构图、比例、光源、密度、UI、actor、A-Z 噪声、旧残留均达到 target。 |

截图包必须包含：

- `target_1280.png` 或等价 target frame / paintover。
- `runtime_1280.png`，来自同轮 Godot non-headless capture。
- `side_by_side_target_runtime_1280.png` 或同等并排版。
- 至少一张真实入口 proof，能看出孩子端路径而非内部 panel 直开。
- A-Z 稳定 / prop-first proof：首屏 priority 与 focus / album revisit 路径不冲突。
- UI safe area proof：HUD / footer / prompt / panel 不遮挡 playfield，不出现大白条或 debug label。
- `manifest.md` 或表格：列出截图文件名、生成命令、时间、任务 ID、判定人和结论。

## 失败时如何更新 todo 与 lessons

如果 gate 失败，必须按失败类型更新 ledger：

| 失败类型 | `todo.md` 更新 | `lessons.md` 更新 |
|---|---|---|
| 缺少前置证据 | `V02-VISUALREBUILD-006` 保持 `[ ]` 或 `[!]`；阻塞项写明缺少 `art_target_locked`、`runtime_visual_match` 或同轮 proof。 | 通常不新增 lesson，除非暴露新的流程误判。 |
| target/runtime 不匹配 | 对应任务回到 `[~]` 或 `[!]`；分工表和正式任务列表写明返修到 V02-VISUALREBUILD-002/003/004/005 哪一项。 | 若发现新型视觉生产失败模式，新增 lesson；若只是执行未完成，不新增。 |
| 真实入口退化 | `V02-VISUALREBUILD-006` 返修；StoryBatch-004/005 继续阻塞；完成记录不得写 final approved。 | 若退化来自新系统边界误解，新增 lesson。 |
| A-Z 不稳定 | StoryBatch 解锁继续阻塞；正式任务表写明不可改 stable ID / route_order / core_word 等字段。 | 若出现 anchor 稳定性新风险，新增 lesson。 |
| 儿童文本不安全 | gate 失败，写明具体文本类型和修复 owner；不得进入 StoryBatch。 | 若禁用词或文案类型以前未覆盖，新增 lesson。 |
| 误把 headless / production / scaffold / 旧 approved 当 final | 立即更正状态语义，恢复阻塞；完成记录写明撤销原因。 | 必须新增或扩展 lesson，因为这是 LESSON-014/016 的复发。 |

## Gate 结论模板

后续实际执行 `V02-VISUALREBUILD-006` 时，PM / Art Direction 应使用以下结论之一：

| 结论 | 标准措辞 |
|---|---|
| 继续阻塞 | `V02-STORYBATCH-004/005` 继续阻塞；缺少 `<具体证据>`，不得恢复 Ready。 |
| 返修 | V02.39 已进入 gate，但 `<区域 / 证据>` 未达标；返修回 `<任务 ID>`，StoryBatch 不解锁。 |
| `runtime_visual_match` | Runtime 与 target 并排复核通过，可进入 final gate；尚未授予 `final_approved`，StoryBatch 不解锁。 |
| `final_approved` | 同轮 1280 proof、真实入口、A-Z 稳定、儿童文本安全和 PM / Art Direction 均通过；V02.39 final gate 通过。 |
| StoryBatch 解锁 | 基于 V02.39 `final_approved`，`V02-STORYBATCH-004` 可从阻塞转 Ready；`V02-STORYBATCH-005` 等待第二批 runtime smoke 后再判定。 |

## 本轮文档结论

本文只准备 gate 与解锁判定矩阵，不授予任何新状态。当前事实仍是：V02.38 为 `visual_scaffold`，`V02-STORYBATCH-004/005` 继续阻塞；必须先完成 V02.39 的 `art_target_locked`、Visual Layout、统一资产包和 `runtime_visual_match`，再由本 gate 判定是否 `final_approved` 以及是否解锁 StoryBatch-004。
