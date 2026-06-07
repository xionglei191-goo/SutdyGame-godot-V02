# Round107 V02.22 HIDDENGRID-001 PM 执行任务包

> 日期：2026-06-06
> 状态：Ready 任务包
> 事实来源：`todo.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`

## 阶段目标

V02.22 把两个方向合并为一个长期架构阶段：

- Animal Crossing-like 隐藏网格生活小镇：孩子端看到连续、温暖、可停留、可装饰、可回访的小镇；底层继续用 cell / footprint / occupied cells 管理移动、碰撞、热点、摆放、刷新、NPC routine、A-Z anchor 和保存。
- Godot scenes 组件化：逐步把 `scripts/main.gd` 中的 TownStage、Player、NPC、资源、anchor、HomeRoom、HUD、背包、商店、相册和设置拆成 scenes / scripts，降低后续扩展风险。

本阶段不是课程扩展，不是远郊扩张，不是可见瓦块地图重做，也不是一次性重构。每个拆分步骤都必须保持当前孩子端真实入口、保存结构、logical asset ID 和 A-Z 记忆宫殿稳定编码。

## 禁改范围

- 不改变 `anchor_id`、`letter`、`core_word`、`route_order`、`card_id` 和既有 A-Z 相册语义。
- 不把 School Gate / School Yard 改成课堂、课程、作业、测试、背诵、打卡或分数空间。
- 不把 X/Z far edge 写入 P0 主流程。
- 不在孩子端显示格子、瓦块、坐标、占格、碰撞、路径搜索、调试、编辑器等术语。
- 不用隐藏 contract 按钮作为完成依据。
- 不把 `production` 或 scene 拆分完成自动写成 product approved。

## 任务队列

| 顺序 | 任务 | Owner | 交付物 | 验收 |
|---|---|---|---|---|
| 1 | V02-HIDDENGRID-001 路线、架构边界和任务包 | PM / Tech Lead / QA | 文档链路、todo、Round107 任务包 | 下一轮 Ready 明确；本轮不改 runtime |
| 2 | V02-HIDDENGRID-002 TownStage scene 抽离 | Godot / Map / QA | `scenes/world/town_stage.tscn`、TownStage 脚本、旧路径回归 | 启动、移动、点击到 cell、热点提示、26 anchor、3-5 分钟 smoke 不退化 |
| 3 | V02-HIDDENGRID-003 Actor / Interactable scene 抽离 | Godot / UX / QA | PlayerActor、NPCActor、InteractableObject、AnchorObject、ResourceObject prefab | NPC / resource / anchor / place 优先级稳定；A-Z 相册和资源去重通过 |
| 4 | V02-HIDDENGRID-004 UI scenes 抽离 | UI / Godot / QA | TownHUD、TownFooter、Backpack、Shop、Home、Album、Settings scene / panel scripts | 可见入口和关闭路径不退化；儿童安全文本通过 |
| 5 | V02-HIDDENGRID-005 户外装饰、资源 2.0 与 NPC routine | Game Design / Godot / QA | 户外装饰数据、保存、资源刷新、NPC routine fallback | 至少一个户外装饰可摆 / 挪 / 收并保存；NPC routine 不阻断 P0 |
| 6 | V02-HIDDENGRID-006 回归、1280 proof 和阶段收口 | QA / PM / Art Direction | Focused/headless 回归、1280 proof、approved / needs_fix 判定 | 不把重构完成误标 product complete |

## 首轮 Ready

下一轮唯一 Ready：

`V02-HIDDENGRID-002 TownStage scene 抽离`

进入条件：

- `world_map` cell 坐标、MAP_CELL_SIZE、地图缩放和点击反算口径先梳理清楚。
- 先保留 `Main` 作为编排入口，TownStage 只接管地图显示、输入和地图节点生成。
- 旧 `tests/test_v0221_livegate_free_life_smoke.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0217_worldmap_anchor_runtime.gd` 和 `tests/headless_runner.gd` 作为最小回归门槛。

## 收口要求

每个 V02-HIDDENGRID 任务完成后同步：

- `todo.md` 当前状态面板、分工表、正式阶段任务、完成记录。
- 只有出现已验证失败或新教训时更新 `lessons.md`。
- 若涉及 UI / 地图视觉，导出 1280x720 proof；960x540 仍保留到全部开发完成后的版本适配专项。
