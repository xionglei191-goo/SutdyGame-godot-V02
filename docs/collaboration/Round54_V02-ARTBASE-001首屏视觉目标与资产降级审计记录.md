# Round 54 `V02-ARTBASE-001` 首屏视觉目标与资产降级审计记录

> 日期：2026-06-05  
> 范围：`V02-ARTBASE-001 首屏视觉目标与资产降级审计`。  
> 目标：重评现有 P0 / P1 资源状态，固定 Sunshine Town 首屏目标，并为 `V02-ARTBASE-002`、`003`、`004` 提供直接输入。

## 审计结论摘要

- Round 52 已接入的 P0 资源目前最多可记为 `production`，不得直接记为 `approved`。
- 当前主要问题不是“资源不存在”，而是“缺少双视口证据”和“首屏观感仍接近占位原型”。
- `V02.7A` 阶段的优先级应从“继续补更多素材 ID”切换为“先固定首屏构图和关键对象同屏可信度”。
- `V02.8` 暂不开放；只有 `V02-ARTBASE-005` 双视口截图通过后，才能进入三 NPC 日常纵切。

## 当前工作区核对结果

基于本轮对当前 worktree 的非文档改动核对，已经确认存在一批 `V02.7A` 候选实现，但它们还没有足够证据直接改写阶段完成状态：

- `data/themes/theme_sunshine_town_placeholder.json` 已新增 `place_assets`、`character_assets`、`furniture_assets`、`ui_icon_assets` 和 `asset_acceptance` 记录，覆盖 Town Plaza、Home、Shop、主路、树枝、玩家、Mina、Sunny、店长、家具与部分 UI 图标。
- `scripts/data/theme_profile_resource.gd` 与 `scripts/systems/asset_resolver.gd` 已扩展到上述新分类，说明逻辑 asset ID 到资源映射链路已经准备好承接 `V02-ARTBASE-002`、`003`、`004`。
- `scripts/main.gd` 已出现主场景侧的候选接入：Town HUD 图标、背包图标、商店图标、关闭图标、设置图标、Town Plaza / Home / Shop / 主路 / 树枝 / 玩家 / Mina / Sunny / 店长 / 家具的纹理解析逻辑都已存在。
- `assets/art/` 下已存在对应 PNG / SVG 资源文件，说明当前不是“无资产可接”，而是“有候选资产待验收”。
- 当前自动化验证已通过：`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit`。

PM 结论：

- 这些证据足以证明 `V02-ARTBASE-002`、`003`、`004` 已经存在“候选实现正在工作区中”的事实。
- 这些证据仍不足以把 `V02-ARTBASE-002`、`003`、`004` 记为 `[x]`，也不足以把任何资源升级为 `approved`，因为 `1280x720` / `960x540` 的 V02.7A 截图证据尚未补齐。
- 因此，当前正确的 PM 口径是：保留 `V02-ARTBASE-001` 为唯一进行中主任务；把 `002`、`003`、`004` 视为“已有候选实现，待截图收口”；把 `005` 视为下一步唯一门槛任务。

## Round 54 证据补记

- 已通过 Godot MCP 捕获 `/root/Main` 的 `1280x720` 运行时截图，并复核 `TownHUD`、`TownFooter`、`RuntimeMap` 与 Town Plaza / Home / Shop 同时出现在真实主场景中。
- 已通过运行时节点属性复核确认：顶部 HUD 与底部 `TownFooter` 仍落在安全区域内，没有在当前默认逻辑分辨率下直接消失。
- 已新增 `tests/capture_artbase005_screens.gd` 作为 `V02-ARTBASE-005` 的批量截图辅助脚本，用来串起首屏、商店、小屋和 anchor 回访点的固定取证路径。
- 但该脚本在 `godot --headless` 的 dummy renderer 下会遇到 `root.get_texture()` 为空的问题，说明当前缺失的是截图导出工具链，而不是已经确认失败的布局结论。
- 因此，本轮可确认“`1280x720` 运行时证据存在”，但仍不能宣布 `V02-ARTBASE-005` 通过；`960x540` 与其余门槛图仍需改走 MCP 或非 headless 显示路径补齐。

## 固定口径

| 状态 | 含义 | 本轮使用方式 |
|---|---|---|
| `placeholder` | 纯程序或临时占位，只用于功能验证 | 不允许作为 V02.7A 目标图主视觉 |
| `placeholder_plus` | 已脱离纯程序占位，可用于构图、遮挡和比例验证 | 允许暂时参与首屏讨论，但不能算达成 |
| `draft` | 已有明确方向，可进入截图讨论和替换优先级排程 | 允许作为 `V02-ARTBASE-002` / `003` / `004` 的过渡目标 |
| `production` | 可集成、可跑体验验证 | 需要至少 `1280x720` 截图和 resolver 映射记录 |
| `approved` | PM / Art Direction 确认可作为当前正式素材 | 必须有 `1280x720` 与 `960x540` 双视口证据 |

## Sunshine Town 首屏目标

首屏必须同时满足以下构图要求：

- Town Plaza 是第一眼主舞台，不再像调试网格或大面积纯色地块。
- Home 与 Shop 同屏可感知，且玩家能从首屏判断“这是能回家的地方”和“这是可以买东西的地方”。
- 主路清楚连接 Home、Town Plaza 和 Shop，不被 HUD / 底栏切断。
- 玩家、Mina、Sunny 至少三者形成稳定的第一眼生活感；店长可作为 Shop 邻近对象在次一级画面出现。
- `C Clock`、`O Orange`、`S Sun` 只作为环境故事物件存在，不以裸字母牌或课程入口出现。

## P0 / P1 资产审计表

| logical_asset_id | 对象 | 当前结论 | 证据现状 | 问题 | 下一步 Owner | 后续任务 |
|---|---|---|---|---|---|---|
| `place.town_plaza.day` | Town Plaza 首屏主视觉 | `production` 保留，不得记 `approved` | 已有 Round 52 `1280x720` 抽查 | 缺少 `960x540`；首屏仍偏占位感 | Art Direction / Asset / Godot | `V02-ARTBASE-002` |
| `place.home.exterior` | Home 外观 | `production` 保留，不得记 `approved` | 已接入 P0 production | 需要在新首屏构图里验证与主路 / 玩家关系 | Art Direction / Map | `V02-ARTBASE-004` |
| `place.shop.exterior` | Shop 外观 | `production` 保留，不得记 `approved` | 已接入 P0 production | 需要在首屏与商店入口截图里验证可读性 | Art Direction / Map | `V02-ARTBASE-004` |
| `place.road.main` | 主路 | `production` 保留，不得记 `approved` | 已接入 P0 production | 需复核双视口下是否仍清楚可走 | Art Direction / QA | `V02-ARTBASE-002`、`005` |
| `place.resource.branch` | 树枝资源点 | `production` 保留，不得记 `approved` | 已接入 P0 production | 需复核与花丛、UI 图标的区分度 | Map / Home Asset | `V02-ARTBASE-004` |
| `character.player.standing` | 玩家站立图 | `production` 保留，不得记 `approved` | 已接入 P0 production | 需与 Mina / Sunny / 店长统一比例 | Character Asset / QA | `V02-ARTBASE-003` |
| `character.mina.standing` | Mina 站立图 | `production` 保留，不得记 `approved` | 已接入 P0 production | 需复核与玩家同屏关系是否自然 | Character Asset / QA | `V02-ARTBASE-003` |
| `pet.sunny.standing` | Sunny 站立图 | `production` 保留，不得记 `approved` | 已接入 P0 production | 需复核 Home / 小屋 / 首屏三类场景一致性 | Character Asset / QA | `V02-ARTBASE-003` |
| `ui_icon.coin` | 金币图标 | `production` 保留，不得记 `approved` | 已接入 P0 production | 缺少较小横屏截图证据 | UI / QA | `V02-ARTBASE-005` |
| `ui_icon.bag` | 背包图标 | `production` 保留，不得记 `approved` | 已接入 P0 production | 缺少较小横屏截图证据 | UI / QA | `V02-ARTBASE-005` |
| `character.shopkeeper.standing` | 店长站立图 | `draft` | 工作区已存在候选贴图、映射和 headless 通过，但无 V02.7A 截图证据 | 待在商店入口与较小横屏中确认可读性 | Character Asset | `V02-ARTBASE-003` |
| `place.home.interior` | 小屋室内主视觉 | `draft` | 现有小屋可玩，且家具 / Sunny 路径已通过 headless；但未进入本轮截图审计结论 | 需要和 Sunny / 家具操作一起复核可信度 | Home Asset / QA | `V02-ARTBASE-004`、`005` |
| `furniture.pet_bowl.placed` | 宠物碗 | `placeholder_plus` | 工作区已存在候选贴图和映射，但无 `1280x720` 小屋证据 | 需要更明确的小屋照顾感 | Home Asset | `V02-ARTBASE-004` |
| `place.flower.small` | 花丛装饰 | `placeholder_plus` | 仅有规划清单 | 需与树枝 / 野花区分 | Map / Asset | `V02-ARTBASE-004` |
| `anchor.c.clock_tower` | `C Clock` 相关物件 | `draft` | 有内容规划，无本轮截图证据 | 需作为环境故事物件而非学习牌 | Memory Palace / Asset | `V02-ARTBASE-004` |
| `anchor.o.orange_sign` | `O Orange` 相关物件 | `draft` | 有内容规划，无本轮截图证据 | 需落到 Shop 货架或招牌环境中 | Memory Palace / Asset | `V02-ARTBASE-004` |
| `anchor.s.sun_patch` | `S Sun` 相关物件 | `draft` | 有内容规划，无本轮截图证据 | 需落到 Home 门口或阳光地块 | Memory Palace / Asset | `V02-ARTBASE-004` |

## 降级规则

本轮固定以下规则：

- 已有 `1280x720` 截图、且已通过 `ThemeProfile` / `AssetResolver` 接入的资源，可继续保留 `production`。
- 缺少 `960x540` 证据的资源，一律不得标为 `approved`。
- 只存在规划清单、没有本轮接入证据的对象，最多记为 `draft`。
- 只能支撑功能、但首屏或小屋观感仍明显临时的对象，记为 `placeholder_plus`，不得跳级为 `production`。

## `V02-ARTBASE-005` 截图门槛

| 截图编号 | 视口 | 场景 | 必须可见 | 不得出现 |
|---|---|---|---|---|
| `shot_artbase005_town_1280` | `1280x720` | 小镇首屏 | Town Plaza、Home、Shop、主路、玩家、Mina、Sunny、顶部 HUD、底栏 | 调试网格感、工程文案、裸字母牌 |
| `shot_artbase005_town_960` | `960x540` | 小镇首屏 | 与 `1280x720` 相同的主视觉关系仍可读 | 文本溢出、按钮贴边、地图主体被 UI 吃掉 |
| `shot_artbase005_shop_1280` | `1280x720` | 商店入口 | Shop 外观、店长、金币、购买路径 | 强促销、羞辱性买不起反馈 |
| `shot_artbase005_home_1280` | `1280x720` | 小屋入口 / 小屋操作 | Home / Sunny / 宠物碗 / 至少一件家具 / 返回路径 | 按钮遮挡 Sunny、无关闭路径 |
| `shot_artbase005_anchor_1280` | `1280x720` | `C` / `O` / `S` 任一回访点 | 物件化 anchor、短故事或环境短句、返回路径 | 单词测验、课程入口、背诵要求 |

## 进入 V02.8 的 PM 判断

只有当以下条件全部满足时，才允许把 `V02-DAILYLIFE-001` 置为 `[~]`：

- `V02-ARTBASE-002`、`003`、`004` 已交付。
- `V02-ARTBASE-005` 双视口截图全部通过。
- 本审计表中的 `production` / `approved` 结论与 `todo.md`、`docs/15` 无冲突。
- 首屏、小屋和商店至少各有一张可信截图，不再像程序占位原型。

## Handoff Notes

- 修改文件：本记录、`todo.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、必要时 `docs/10_美术风格与换肤预留.md`
- 新增内容：资产状态审计、首屏目标、截图门槛、进入 V02.8 的阶段门槛
- 验证方式：文档一致性复核；后续实现轮再补 Godot headless 与截图证据
- 风险：当前工作区已有未提交 runtime / asset 改动，本轮不直接并入审计结论
- 待确认问题：`V02-ARTBASE-002` 到 `005` 完成后，是否需要把部分 P0 资源升级为 `approved`
