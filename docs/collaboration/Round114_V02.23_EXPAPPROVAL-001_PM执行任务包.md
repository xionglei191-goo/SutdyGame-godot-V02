# Round114 V02.23 EXPAPPROVAL-001 PM 执行任务包

> 日期：2026-06-06
> 对应任务：`V02-EXPAPPROVAL-001 V02.23 体验批准线 PM 任务包与判定矩阵`
> 结论：进入 V02.23 体验批准线；本轮只建立任务包、判定矩阵、截图清单、禁改范围和下一项 Ready，不改 runtime、tests、assets 或 data。

## 1. 当前批准事实

V02.22 只证明 scene-native / hidden-grid 架构、地图 authoring export、runtime layer 分发和 panel scenes 通过，不等同 product complete，也不等同 product approved。

| 视图 / 区域 | 当前状态 | 来源与说明 |
|---|---|---|
| Album | `approved` | Round106 判定相册 overlay 清晰、地图元素不穿层、关闭路径可读；仍只代表 V02.21 playgate approved。 |
| Town Plaza / World Map | `needs_fix` | A-Z anchor、NPC、资源和底部提示仍偏拥挤，局部可读性不足。 |
| Home | `needs_fix` | 比早期更有居住感，但整体仍偏稀疏摆放板，大面积空白和装饰密度不足。 |
| Shop | `needs_fix` | 用途和购买路径可见，但 glass panel 在复杂地图上透明度 / 层级仍需复核。 |
| School Gate | `needs_fix` | 到达反馈温和，但画面拥挤、顶部长句和 School line anchor 叠加影响可读性。 |
| School Yard | `needs_fix` | 操场语义可见，但 anchor 密度、顶部长句和底部提示仍偏噪。 |
| Settings | `needs_fix` | 用途可见，但 translucent panel 压在复杂地图和 anchor 标签上，可读性不足。 |

禁止把 `production`、重构完成、headless 通过、旧截图或 V02.22 阶段收口自动写成 `approved`。

## 2. V02.23 任务队列

| 顺序 | Task ID | Owner | 目标 | 完成门槛 |
|---|---|---|---|---|
| 1 | V02-EXPAPPROVAL-001 | PM / Art Direction / QA | 固定 V02.23 体验批准线任务包、逐项判定矩阵、截图清单、禁改范围和下一项 Ready | 文档链路与 `todo.md` 同步；不改 runtime；下一项 Ready 为 `V02-EXPAPPROVAL-002` |
| 2 | V02-EXPAPPROVAL-002 | Map / UX / Art Direction / QA / Godot | Town Plaza 首屏生活密度与 anchor 降噪返修 | 1280 proof 显示居民、资源、place、A-Z anchor 层次清楚；不改 A-Z ID / route_order |
| 3 | V02-EXPAPPROVAL-003 | Home Design / UI / QA / Godot | Home 居住密度与小屋视觉批准返修 | Home 默认生活角、Sunny 反馈、家具状态和可见操作不退化；1280 proof 可判定 |
| 4 | V02-EXPAPPROVAL-004 | UI / UX / QA / Godot | Shop / Settings glass UI 可读可触批准返修 | 复杂地图背景上弹层可读、可触、可关闭；购买 / 休息 / 安全位置路径不退化 |
| 5 | V02-EXPAPPROVAL-005 | Map / Narrative / Art Direction / QA / Godot | School Gate / School Yard 生活地点化与噪声返修 | 学校像生活地点和操场，不像课程空间；anchor / HUD 噪声下降 |
| 6 | V02-EXPAPPROVAL-006 | QA / PM / Art Direction | 1280 RC 截图包、真实入口 smoke 与逐项 approved 判定 | 同轮 1280 proof 覆盖六个 needs_fix 视图和 Album 回归；逐项只按 PM / Art Direction 判定升级 |

## 3. 判定矩阵

| 判定项 | `approved` 条件 | `needs_fix` 条件 | 禁止作为批准依据 |
|---|---|---|---|
| 生活密度 | 第一眼能看出可停留、可回访、可互动的生活场所 | 空白、堆标、用途不清或像功能面板 | 节点存在、服务测试通过 |
| 真实入口 | 玩家从孩子端可见按钮 / `看看` / 地点移动触发 | 只能通过隐藏 contract、服务直调或测试 facade 触发 | hidden button、direct service call |
| A-Z anchor | anchor 像生活物件 / 地点线索，徽章只辅助 | 裸字母牌感、互相遮挡、顺序任务感 | route_order 存在 |
| UI 可读可触 | 1280 下文本不溢出，按钮可点，关闭路径清楚 | glass 透明过高、压住地图噪声、误触风险 | panel scene 已拆分 |
| 儿童安全 | 温暖短句、生活反馈、无压力 | 课程、测试、评分、打卡、倒计时、错过、工程文案 | 内容合同单独通过 |
| 截图证据 | 同轮 1280x720 runtime proof + PM / Art Direction 判定 | proof 缺失、旧轮次证据、无法代表当前 runtime | 旧 Round96 / Round99 / Round112 proof 自动沿用 |

## 4. 1280 RC 截图清单

V02-EXPAPPROVAL-006 必须使用同轮 runtime proof，不沿用旧截图自动批准：

- Town Plaza / World Map：首屏、靠近 Mina / resource / anchor、底栏提示可见状态。
- Home：默认小屋、家具操作状态、Sunny 反馈状态。
- Shop：商品面板打开、购买反馈、关闭路径。
- School Gate：到达反馈、School line anchor 可读状态。
- School Yard：操场物件、anchor、底栏提示和反馈。
- Settings：默认设置面板、休息确认、回安全位置路径。
- Album：回归截图，确认已批准项不退化。

## 5. 禁改范围

- 不新增课程 UI、课程页、练习题、测试、背诵、词表墙、分数、正确率、打卡或字母顺序任务。
- 不扩远郊 P0，不把 X/Z 写成每日必到或主线入口。
- 不改 26 个 A-Z `anchor_id`、`letter`、`core_word`、`route_order`、`card_id` 或既有相册语义。
- 不改 HomeDecorationService 存档结构，不显示格子、坐标、占格、footprint、debug path 等孩子端术语。
- 不把 V02.22 架构完成、`production` 资产状态、headless 通过或旧截图自动升级为 product approved。
- 不把 Letter Snake、Memory Card 或旧学习奖励链重新变成主循环。

## 6. 后续阶段占位

- V02.24 Home / Town Plaza 居住感加固：只在 V02.23 批准线之后推进 Home 默认生活角、Sunny 反馈、家具状态、Town Plaza 停留点、户外装饰规则和 NPC routine 到达感。
- V02.25 地图 Authoring 工具实用化：采用 `TownMapAuthoring` candidate dictionary + `MapEditorSyncService` validate/write-if-valid 双阶段提交；非法数据不得覆盖 `world_map.json`。
- V02.26 内容生产小批量：只做 7 天 NPC routine 轻变化、3-5 个资源点、4-6 条 A-Z 生活物件回访和 Shop / School Yard 看一眼事件；避免复用同一个 `core_anchor_id` 造成 `AnchorInteractionService` 一对一覆盖风险。

## 7. 本轮完成判断

`V02-EXPAPPROVAL-001` 的完成门槛是 PM 文档与台账同步，不是运行时返修。本轮完成后，下一轮唯一 Ready 应为 `V02-EXPAPPROVAL-002 Town Plaza 首屏生活密度与 anchor 降噪返修`。

验证建议：

```bash
rg -n "V02\\.23|EXPAPPROVAL|V02\\.24|HOMEPLAZA|V02\\.25|MAPAUTH|V02\\.26|CONTENTBATCH|needs_fix|approved" docs/12_V02开发路线.md docs/13_V02详细开发计划.md docs/14_内容基线整理与首批内容规划.md docs/15_项目经理接管与下一阶段执行计划.md todo.md docs/collaboration/Round114_V02.23_EXPAPPROVAL-001_PM执行任务包.md
godot --headless --path . --quit
```
