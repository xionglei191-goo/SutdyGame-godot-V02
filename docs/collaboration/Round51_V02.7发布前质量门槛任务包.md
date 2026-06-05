# Round 51 V02.7 发布前质量门槛任务包

> 日期：2026-06-05  
> PM 状态：V02.6 策划内容生产线已收口，V02.7 发布前体验与质量门槛启动。  
> 执行原则：先建立验收门槛和清单，再按清单做 Godot 实现、截图和素材替换。所有任务继续保护生活 RPG / 小镇养成主循环，英语只作为环境、收藏、短句、相册和 A-Z 记忆宫殿层。

## Round 51 总目标

把“已经能玩”的 Sunshine Town 推进到“每次发布前都能验收”：

- PC / 桌面调试环境有可见退出路径。
- 移动端孩子主操作区不出现误触退出。
- 小镇、背包、商店、小屋、相册、anchor 互动等关键路径有固定截图验收。
- 1280x720 与较小横屏视口的触控和布局有检查表。
- 首批正式或半正式素材替换有逻辑 asset ID、接入记录和截图门槛。

## 小组任务一：UX / Godot / QA

## Task

推进 `V02-POLISH-001 退出与设置入口`。

## Owner

UX / Godot Dev / QA Agent

## Scope

允许修改或产出：

- `todo.md`
- `docs/collaboration/Round51_V02.7发布前质量门槛任务包.md`
- 后续实现阶段可修改 `scripts/main.gd`、`scenes/main.tscn`、相关 UI tests。

本轮规划阶段不要求修改：

- `data/`
- A-Z anchor 核心数据。
- 商店、委托、NPC 内容合同。

## Inputs

- `todo.md`
- `docs/01_产品总纲.md`
- `docs/02_目标用户与体验原则.md`
- `docs/10_美术风格与换肤预留.md`
- `docs/14_内容基线整理与首批内容规划.md`
- `docs/collaboration/多Agent协作规范_v0.2.md`

## Deliverables

- PC / 桌面调试退出入口方案。
- 儿童端设置或安全位置入口方案。
- 移动端不误触规则。
- 退出 / 设置文案安全检查点。
- 对应实现或验收任务拆分建议。

## Acceptance Criteria

- PC 调试可通过可见入口关闭游戏或回到安全状态。
- 移动端退出不放在底部主操作误触区，不和 `看看`、`小镇`、`小屋`、`背包` 混淆。
- 孩子端文案不暴露 Godot、debug、runner、JSON、contract、测试等工程信息。
- 不出现学习压力、家长报告、失败惩罚、连续登录或陌生人社交暗示。
- 后续如进入 Godot 实现，必须补 focused UI test 和 headless runner 覆盖。

## Constraints

- 不把家长后台做成孩子端主导航。
- 不把退出按钮做成高频主操作按钮。
- 不引入真实账号、联网、录音或云服务依赖。

## 小组任务二：QA / UI / Art Direction

## Task

推进 `V02-POLISH-002 玩家路径截图验收`。

## Owner

QA / UI / Art Direction Agent

## Scope

允许修改或产出：

- `docs/collaboration/`
- `todo.md`
- 后续可新增截图验收记录模板或测试说明。

本轮不修改：

- 运行时代码。
- 资产文件。
- 内容 JSON。

## Inputs

- `todo.md`
- `docs/10_美术风格与换肤预留.md`
- `docs/14_内容基线整理与首批内容规划.md`
- `lessons.md` 中 `LESSON-007` 和 `LESSON-009`

## Deliverables

- 关键路径截图清单。
- 1280x720 截图验收记录模板。
- 每次 UI / 美术大改后的截图触发规则。
- 截图失败判定标准。

## Acceptance Criteria

- 至少覆盖：小镇首屏、背包气泡、商店货架、购买反馈、小屋视图、家具操作、相册覆盖层、anchor 互动、NPC 对话、资源收集。
- 每张截图都写明：视口、入口路径、玩家位置或操作、必须可见的 UI / 地图元素、不能出现的遮挡或工程文案。
- 截图验收要求能和 `V02-POLISH-003` 移动布局检查、`V02-POLISH-004` 素材替换检查复用。
- 不把隐藏 contract 按钮截图当成孩子端可玩证据。

## Constraints

- 截图标准以孩子端真实可见入口为准。
- 不用服务测试、脚本直接调用或隐藏按钮代替玩家路径截图。
- 截图要求不得把 A-Z anchor 变成裸字母测验牌。

## 小组任务三：QA / UX / Godot

## Task

准备 `V02-POLISH-003 移动端触控与布局复核`。

## Owner

QA / UX / Godot Agent

## Scope

允许修改或产出：

- `docs/collaboration/`
- `todo.md`
- 后续可修改 UI tests 或主场景布局实现。

本轮不修改：

- A-Z 核心数据。
- 内容生产文档正文，除非发现验收冲突。

## Inputs

- `docs/02_目标用户与体验原则.md`
- `docs/11_Godot技术架构.md`
- `docs/10_美术风格与换肤预留.md`
- `todo.md`
- 当前主界面 HUD / 底栏 / 背包 / 商店 / 小屋 / 相册路径。

## Deliverables

- 1280x720 横屏检查表。
- 较小横屏视口检查表。
- 按钮尺寸、遮挡、安全区、文字溢出、弹层关闭路径和底栏 / HUD 检查项。
- 与 `V02-POLISH-002` 截图清单的对应关系。

## Acceptance Criteria

- 所有常驻按钮和弹层关闭按钮都满足儿童触屏可操作尺寸。
- 顶部 HUD、底部栏、背包气泡、商店面板、小屋物件面板、相册覆盖层不互相遮挡。
- 较小横屏视口下文本不溢出、不覆盖关键地图物件、不遮挡返回路径。
- 检查表能转换为 focused UI test 或 MCP 截图验收。

## Constraints

- 不为了省空间重新引入左右大面板覆盖地图。
- 不把设置、退出、相册、商店、学习小游戏全部塞回底部主操作栏。
- 不使用工程调试文案向孩子解释布局或功能。

## 小组任务四：Art Direction / Asset / QA

## Task

准备 `V02-POLISH-004 首批正式素材替换验收`。

## Owner

Art Direction / Asset / QA Agent

## Scope

允许修改或产出：

- `docs/collaboration/`
- `todo.md`
- 后续可更新 `docs/10_美术风格与换肤预留.md` 的替换状态或接入记录。

本轮不修改：

- 玩法脚本中的具体素材路径。
- `ThemeProfile` / `AssetResolver` 合同外的直接路径引用。

## Inputs

- `docs/10_美术风格与换肤预留.md`
- `docs/14_内容基线整理与首批内容规划.md`
- `docs/04_A-Z记忆宫殿与记忆卡系统.md`
- `todo.md`

## Deliverables

- 首批占位替换优先级。
- 素材接入记录字段：逻辑 asset ID、状态、资源路径、替换对象、截图区域、验收结论。
- `production` / `approved` 状态进入游戏的验收标准。
- 首屏和核心路径素材替换截图门槛。

## Acceptance Criteria

- P0 至少覆盖：`place.town_plaza.day`、`place.home.exterior`、`place.shop.exterior`、`place.road.main`、`place.resource.branch`、`character.player.standing`、`character.mina.standing`、`pet.sunny.standing`、`ui_icon.coin`、`ui_icon.bag`。
- A-Z anchor 替换继续使用稳定逻辑 ID，不移动核心路线或重写核心编码。
- 正式或半正式素材替换必须通过 1280x720 截图验收，且不让首屏回到程序化占位原型观感。
- 玩法脚本不得新增硬编码具体美术路径。

## Constraints

- 不并行开启多套美术风格。
- 不使用未授权 IP、商标、照片或素材。
- 不把素材替换做成课程页、测验牌、成绩墙或 Letter Snake 主线入口。

## PM 集成顺序

1. UX / Godot / QA 先交 `V02-POLISH-001` 方案或实现。
2. QA / UI / Art Direction 同步交 `V02-POLISH-002` 截图清单。
3. QA / UX / Godot 基于截图清单补 `V02-POLISH-003` 移动布局检查表。
4. Art Direction / Asset / QA 基于截图清单和美术 ID 规则补 `V02-POLISH-004` 替换验收表。
5. PM 对照 `todo.md` 更新任务状态、完成记录和 `lessons.md`。

## 本轮验证要求

本任务包为 PM 分派和文档清单，不改运行时代码时无需运行 Godot。若任一小组进入 Godot 实现，必须至少运行：

```bash
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

UI 或美术改动还必须补 1280x720 截图验收记录。
