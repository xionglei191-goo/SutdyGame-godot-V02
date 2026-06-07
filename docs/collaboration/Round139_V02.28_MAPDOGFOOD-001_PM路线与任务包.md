# Round139 V02.28 MAPDOGFOOD-001 PM 路线与任务包

> 日期：2026-06-07
> 状态：规划 / Ready
> 范围：Map Editor 实战生产验证

## 目标

V02.28 的目标是把 V02.27 已完成的场景内 Map Editor 从“功能可用”推进到“生产可用”。本阶段用编辑器完成一小批真实内容生产，验证候选编辑、Validate、安全写回、runtime load、孩子端真实入口、内容生产手册和 1280 proof 能连成稳定流程。

本轮只做 PM 路线和任务包，不改 runtime、data、tests 或 assets。

## 任务队列

| Task ID | Owner | 交付物 | 验收 |
|---|---|---|---|
| V02-MAPDOGFOOD-001 | PM / Tooling / QA | 路线、禁改边界、任务包和台账同步 | docs 12-15、`todo.md` 和本任务包同步；下一项 Ready 明确 |
| V02-MAPDOGFOOD-002 | Tooling / Map / QA | Map Editor 小批量生产实战 | 用场景内编辑器完成少量 Place / resource / NPC routine 改动；通过 Validate、安全写回和 runtime load；A-Z 不退化 |
| V02-MAPDOGFOOD-003 | QA / UX / Child Safety | 孩子端真实入口复核 | 新内容来自真实移动 / `看看` / 相册路径，可见可达，不遮挡核心入口，不出现编辑器术语 |
| V02-MAPDOGFOOD-004 | Tooling / PM / Content | 内容生产手册与操作边界 | 明确增改 Place / resource / NPC routine、验证保存、回滚和 A-Z 锁定字段 |
| V02-MAPDOGFOOD-005 | QA / PM | 回归、1280 proof 与阶段收口 | focused dogfood、V02.27 editor 回归、full runner、Godot 启动和 1280 proof 通过；不标 product complete |

## V02-MAPDOGFOOD-002 Ready 输入

- 使用 `scenes/map_editor/town_map_authoring.tscn` 和 `TownMapAuthoring` 作为生产入口。
- 正式 dogfood 改动必须能追溯到候选 state、Validate、`MapEditorSyncService` 安全写回和 post-load verify。
- 允许范围：2-3 个生活停留 / Place 细节、1-2 个资源点，或 1 个 NPC routine 轻微调整。具体选点由执行者基于现有地图冲突和可达性选择。
- 必须保留分文件边界：map 写 `data/maps/world_map.json`，resource 写 `data/life/resource_points.json`，routine 写 `data/life/npc_routines.json`。

## 禁改边界

- 不新增课程 UI、测试、背诵、打卡、分数、倒计时、错过或家长报告语气。
- 不扩远郊为 P0，不把 School 改成课程空间。
- 不改 26 个 A-Z anchor 的稳定 ID、letter、core_word、route_order、card_id、audio_id、相册语义或新词故事绑定。
- 不把编辑器入口接入孩子端 runtime，不显示格子、坐标、footprint、debug 或编辑器术语。
- 不用手工直接修改正式 JSON 冒充 Map Editor 生产；手工 JSON 调试不能算 dogfood 证据。

## 验收矩阵

- 文档：docs 12-15、`todo.md` 和本任务包一致。
- 工具：V02.27 focused tests 至少覆盖 Map Editor 直接编辑、保存边界和 A-Z 保护。
- 数据：dogfood 后 JSON 必须可加载，且 A-Z runtime / map readability 不退化。
- 体验：孩子端真实入口 smoke 覆盖新内容可见、可达、可关闭。
- 视觉：阶段收口时导出 1280x720 proof；960x540 留到版本适配专项。

## 下一项 Ready

`V02-MAPDOGFOOD-002 Map Editor 小批量生产实战` 作为下一轮 Ready。
