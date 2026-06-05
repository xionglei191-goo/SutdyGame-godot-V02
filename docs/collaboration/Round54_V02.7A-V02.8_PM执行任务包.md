# Round 54 V02.7A-V02.8 PM 执行任务包

> 日期：2026-06-05  
> PM 状态：Round 54 从“路线改写”进入“执行台账落地”。  
> 当前事实来源：`todo.md`。  
> 执行原则：先完成 `V02-ARTBASE-001` 到 `V02-ARTBASE-005`，双视口截图过关后，才进入 `V02-DAILYLIFE-001` 到 `V02-DAILYLIFE-005`。

## Round 54 总目标

把已经写进路线的两阶段计划变成可执行台账：

- 先用 `V02.7A` 重评现有 P0/P1 素材状态，固定 Sunshine Town 首屏视觉目标。
- 明确 `production` 与 `approved` 的证据门槛，阻止“可加载资源”被误记为“当前正式美术”。
- 让 `V02.8` 只在 `V02.7A` 双视口截图通过后开工，并固定为 Mina、店长、Sunny 与 `C/O/S` 三个地点回访。

## 当前工作区事实

Round 54 文档落地后，当前 worktree 又核对到一批与 `V02.7A` 对齐的候选实现：

- 逻辑 asset ID 到 `ThemeProfile` / `AssetResolver` 的扩展已经存在。
- 主场景已经出现 Town Plaza、角色、家具与 UI 图标的候选资源接入逻辑。
- `assets/art/` 下存在与上述映射对应的资源文件。
- `scripts/main.gd`、`tests/test_asset_resolver.gd`、`tests/test_life_rpg_scene.gd`、`tests/headless_runner.gd` 的针对性验证已通过。

PM 处理原则固定为：

- 把这些实现视为 `V02-ARTBASE-002`、`003`、`004` 的候选交付，不把它们当成“截图已收口”的完成状态。
- `V02-ARTBASE-005` 仍然是下一步唯一门槛任务；未补 `1280x720` / `960x540` 截图前，不把任何资源升级为 `approved`，也不启动 `V02-DAILYLIFE-001`。
- 当前取证补记：`1280x720` 已可通过 MCP 运行时截图复核；`960x540` 仍不能依赖 `godot --headless` dummy renderer 自动导出，需提前准备 MCP 或非 headless 路径。

## 固定执行顺序

| 顺序 | 任务 | Owner | 进入条件 | 完成门槛 |
|---|---|---|---|---|
| 1 | `V02-ARTBASE-001` 首屏视觉目标与资产降级审计 | PM / Art Direction / QA | `V02-POLISH-004` 已完成 | 已形成审计记录；缺少双视口证据的资源不再写成 `approved` |
| 2 | `V02-ARTBASE-002` Town Plaza 主视觉生成与接入 | Art Direction / Asset / Godot | `V02-ARTBASE-001` 完成 | 首屏第一眼像生活小镇，不像调试网格 |
| 3 | `V02-ARTBASE-003` 角色与宠物基础套装 | Art Direction / Character Asset / QA | `V02-ARTBASE-001` 完成 | 玩家 / Mina / Sunny / 店长同屏比例自然、可区分 |
| 4 | `V02-ARTBASE-004` Home / Shop / 小物件视觉基线 | Art Direction / Map / Home Asset | `V02-ARTBASE-001`、`002` 完成 | Home / Shop / 树枝 / 花丛 / 宠物碗 / `C/O/S` 相关物件能支撑三条日常路径 |
| 5 | `V02-ARTBASE-005` 双视口截图验收 | QA / Art Direction / Godot | `002`、`003`、`004` 完成 | `1280x720` 与 `960x540` 截图通过 |
| 6 | `V02-DAILYLIFE-001` 至 `005` | Godot Dev / Narrative / QA 等 | `V02-ARTBASE-005` 完成 | 玩家能从真实入口完成 5 分钟日常纵切 |

## 小组任务一：PM / Art Direction / QA

## Task

推进 `V02-ARTBASE-001 首屏视觉目标与资产降级审计`。

## Owner

PM / Art Direction / QA Agent

## Scope

允许修改或产出：

- `todo.md`
- `docs/15_项目经理接管与下一阶段执行计划.md`
- `docs/10_美术风格与换肤预留.md`
- `docs/collaboration/Round54_V02.7A-V02.8_PM执行任务包.md`
- `docs/collaboration/Round54_V02-ARTBASE-001首屏视觉目标与资产降级审计记录.md`

本轮不要求修改：

- `scripts/`
- `scenes/`
- `tests/`
- `data/`

## Inputs

- `todo.md`
- `docs/10_美术风格与换肤预留.md`
- `docs/collaboration/Round52_V02.7发布前体验门槛执行记录.md`
- `docs/collaboration/Round51_V02-POLISH-003-004_QA-Asset验收草案.md`
- `lessons.md` 中 `LESSON-007`、`LESSON-009`

## Deliverables

- P0 / P1 资源状态审计表。
- Sunshine Town 首屏目标构图说明。
- `production` / `approved` 证据门槛收口说明。
- 哪些资源继续保留 `production`、哪些降回 `draft` / `placeholder_plus` 的结论。

## Acceptance Criteria

- 审计范围至少覆盖：Town Plaza、Home、Shop、主路、树枝、玩家、Mina、Sunny、店长、宠物碗、花丛、`C Clock`、`O Orange`、`S Sun`。
- 缺少 `960x540` 证据的资源不得记为 `approved`。
- 首屏目标必须明确 Home / Shop / 道路 / 停留空间 / 主要角色的同屏关系。
- 结论必须能直接作为 `V02-ARTBASE-002`、`003`、`004` 的输入，不留“实现时再决定”的空档。

## Constraints

- 不把“已加载”直接等同于“视觉完成”。
- 不新增 Bookshop、Bus Stop、更多 NPC、更多天气变体。
- 不把 A-Z 做成裸字母牌、课程入口或答题门槛。

## 小组任务二：Art Direction / Asset / Godot

## Task

在 `V02-ARTBASE-001` 完成后推进 `V02-ARTBASE-002 Town Plaza 主视觉生成与接入`。

## Owner

Art Direction / Asset / Godot Agent

## Deliverables

- `place.town_plaza.day` 主视觉或可拼接背景。
- 接入记录与截图区域说明。
- 与 Home / Shop / 主路 / 玩家 / Mina / Sunny 的同屏构图说明。

## Acceptance Criteria

- 首屏第一眼像温暖小镇，不像调试网格或程序占位。
- 不引入玩法脚本硬编码素材路径。
- 至少能支撑 `shot_artbase005_town_1280` 与 `shot_artbase005_town_960` 两张门槛截图。

## 小组任务三：Art Direction / Character Asset / QA

## Task

在 `V02-ARTBASE-001` 完成后推进 `V02-ARTBASE-003 角色与宠物基础套装`。

## Owner

Art Direction / Character Asset / QA Agent

## Deliverables

- 玩家、Mina、Sunny、店长基础站立图或明确接入记录。
- 同屏比例、脚底锚点和儿童友好边界说明。

## Acceptance Criteria

- 四个对象同屏比例自然，可清楚区分，不像不同项目拼接。
- 不出现课堂 / 评分 / 战斗 / 威胁感视觉。
- 至少能支撑首屏、商店入口、小屋入口三类截图。

## 小组任务四：Art Direction / Map / Home Asset

## Task

在 `V02-ARTBASE-001` 与 `002` 完成后推进 `V02-ARTBASE-004 Home / Shop / 小物件视觉基线`。

## Owner

Art Direction / Map / Home Asset Agent

## Deliverables

- Home、Shop、树枝、花丛、宠物碗、`C Clock`、`O Orange`、`S Sun` 相关小物件的状态结论或接入记录。
- 哪些可直接进入 `production`，哪些仍保留 `draft` / `placeholder_plus`。

## Acceptance Criteria

- 能支撑三条 P0 委托的地图路径和回访点。
- 小物件不会遮挡 HUD、底栏、关键关闭路径和角色热点。
- A-Z 核心位置、路线顺序和故事编码保持稳定。

## 小组任务五：QA / Art Direction / Godot

## Task

收口 `V02-ARTBASE-005 双视口截图验收`，并给出进入 `V02.8` 的明确门槛结论。

## Owner

QA / Art Direction / Godot Agent

## Deliverables

- `1280x720` 与 `960x540` 截图记录。
- `pass / needs_fix / blocked` 结论。
- 是否允许进入 `V02.8` 的 PM 建议。
- 若 `960x540` 因工具链受阻未能导出，必须单独写明“工具链 blocked”而不是直接写成“布局 fail”。

## Acceptance Criteria

- 至少覆盖：首屏、商店入口、小屋入口、小屋操作、三 NPC 互动、至少一个 `C/O/S` 回访点。
- 不得出现工程文案、文字溢出、按钮贴边、关闭路径不可见。
- 结论必须回写 `todo.md` 状态与完成记录。

## V02.8 开工门槛

只有当以下条件同时满足时，PM 才能把 `V02-DAILYLIFE-001` 置为 `[~]`：

- `V02-ARTBASE-005` 已通过。
- 审计记录已明确哪些资源是 `production`，哪些是 `approved`，且无口径冲突。
- `todo.md` 当前状态面板、正式任务列表和完成记录已同步。
- 孩子端截图已能证明首屏、小屋、商店和至少一个 `C/O/S` 回访点的观感可信。

## PM 收口清单

每轮收口前，PM 统一检查：

1. `todo.md` 当前状态面板是否更新。
2. 任务状态是否只在满足验收时从 `[~]` 改为 `[x]`。
3. 是否补了新的协作文档、截图记录或验收结论。
4. 是否出现需要进入 `lessons.md` 的已验证问题。
5. 是否有任务误把隐藏 contract 按钮、脚本直调或“可加载素材”当成完成依据。
6. 是否已经把“工作区候选实现已存在”与“截图证据尚未齐全”明确区分，没有把候选实现直接写成阶段完成。

## 本轮验证要求

本任务包本身属于 PM 文档落地，不改运行时代码时无需运行 Godot。若后续任何小组进入 `scripts/`、`scenes/`、`tests/` 或资源接入实现，至少补：

```bash
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

UI / 美术改动还必须补 `1280x720` 与 `960x540` 截图证据。
其中 `1280x720` 可先使用 MCP 运行时截图复核；`960x540` 不应默认依赖 headless dummy renderer，必要时改走非 headless 显示路径。
