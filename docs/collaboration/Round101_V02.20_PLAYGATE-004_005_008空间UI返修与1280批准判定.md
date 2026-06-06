# Round101 V02.20 PLAYGATE-004 / 005 / 008 空间 UI 返修与 1280 批准判定

> 日期：2026-06-06
> 范围：文档交付；不修改 runtime、assets、data 或 tests。
> 对应任务：`V02-PLAYGATE-004`、`V02-PLAYGATE-005`、`V02-PLAYGATE-008`
> 结论：V02.19 只能作为 `1280x720 art baseline` 和 production 接入基线，不能写成 product complete。V02.20 仍需先完成空间分层、UI 可触可读和截图批准门槛，再决定是否进入内容扩展。

## 1. 输入与证据

本轮只基于现有文档、台账和截图证据做 PM / Art Direction / QA 判定：

- `todo.md`：当前阶段已进入 `V02.20 可居住小镇重建`；Round101 中 `V02-PLAYGATE-004`、`005`、`008` 均为进行中。
- `lessons.md`：继续沿用 `LESSON-007` 首屏玩家感知、`LESSON-009` 真实可见入口、`LESSON-010` 截图工具链、`LESSON-011` 热点优先级规则。
- `docs/collaboration/Round100_V02.20_PLAYGATE-001_PM执行任务包.md`：明确 V02.19 是 1280 art baseline，不等同 product complete；V02.20 目标是可居住小镇 playgate。
- `docs/collaboration/Round99_V02.19_ARTPASS-010运行时视觉验收与发布候选记录.md`：Town Plaza、Home、Shop、Album、Settings 有 1280 proof；School Gate / School Yard 不在 Round99 proof 包中。
- `docs/collaboration/Round92_V02.19_ARTPASS-003视觉方向确认包.md`：世界视觉为 Animal Crossing-like cozy town；UI 为 Apple-like translucent glass；anchor 先是生活物件，字母徽章只辅助。
- `docs/collaboration/round99_runtime_visual_acceptance/`：存在 1280x720 PNG proof，覆盖 Town Plaza、Home、Shop、Album、Settings。
- `docs/collaboration/round96_visual_acceptance/`：存在 School Gate / School Yard 的 1280x720 final proof，可作为补充参考，但不是 Round99 denoised release-candidate 包的一部分。

已做只读验证：

```bash
ls -la docs/collaboration/round99_runtime_visual_acceptance docs/collaboration/artpass003_visual_direction
file docs/collaboration/round99_runtime_visual_acceptance/*.png docs/collaboration/artpass003_visual_direction/*.png
file docs/collaboration/round96_visual_acceptance/shot_production005_school_gate_round96_final_1280.png docs/collaboration/round96_visual_acceptance/shot_production005_school_yard_round96_final_1280.png
```

## 2. PLAYGATE-004 空间分层返修方案

目标：让 P0 地点一眼能读出生活用途，让居民、资源、家具和 A-Z anchor 各有位置层级，避免热点互吞。不得修改 26 个 A-Z 的 `anchor_id`、`core_word`、`route_order`、坐标语义或相册语义。

### 2.1 空间层级规则

| 层级 | 对象 | 返修要求 | 阻塞判定 |
|---|---|---|---|
| 生活地点层 | Home、Town Plaza、Shop、School Gate、School Yard | 每个地点先有生活用途：回家、散步、购物、到校门、操场活动；地点用途不得只靠文字或字母说明 | 首屏看不出地点用途，或地点像课程 / 测试空间 |
| 主路与安全边界层 | Home-School Walk、道路、回家 / 回镇路径 | 道路要引导玩家移动，不压住 anchor 和资源；远郊只作边界预览 | 路径看起来像任务路线、课程路线或诱导独自远行 |
| 居民层 | Mina、Shopkeeper、Sunny、Story Bear、Bus Helper | 居民必须站在其生活用途附近，周围留出交互缓冲，不与资源 / anchor 共格或紧贴 | 玩家靠近后 `看看` 目标不稳定，NPC 被资源或 anchor 抢焦点 |
| 资源层 | branch、flower、pebble 等 | 资源应放在道路边、树下、广场边缘，作为散步发现；不得贴住 NPC 脚下或 anchor 触发区 | 资源吞掉 NPC / anchor `看看`，或像噪点覆盖地图 |
| 家具 / 小屋层 | small table、pet bowl、Sunny bed、wooden chair | 家具操作区必须与 Sunny 反馈、背包入口和收起 / 旋转控制分开 | 家具按钮遮挡反馈，或操作后看不出小屋用途 |
| Anchor 物件层 | 26 个 A-Z 生活物件 | anchor 先是生活物件；徽章只辅助；School line、Shop Street、Home Core 分组必须自然 | 裸字母牌成为主视觉，或 anchor 被地点建筑 / HUD 压住 |
| 热点提示层 | glow、context prompt、`看看` 提示 | 只提示当前最近 / 最高优先级目标；提示文案应显示生活对象名称 | 多个目标重叠时提示跳动或显示错误对象 |

### 2.2 P0 地点返修清单

| 地点 | 生活用途目标 | 居民 / 资源 / Anchor 分层建议 | 需要避免 |
|---|---|---|---|
| Town Plaza | 出门散步、遇见 Mina、捡 branch、进入日常循环 | Mina 留在广场可见边缘；branch 放在道路边，不贴 Mina；Clock / Sun 等 anchor 保持物件化 | 资源点抢 Mina；广场只像大地图缩略图 |
| Home | 回家、小屋、Sunny、家具整理、Home Core anchors | Sunny 与 pet bowl / Sunny bed 保持可读距离；A/C/D/W/T 不被 Home 外观和回家入口盖住 | 小屋仍只像功能面板；Home Core anchor 被建筑或按钮遮挡 |
| Shop | 购物、看商品、店长反馈、Orange / Hat / Ice cream / Jacket 街区 | Shopkeeper 靠近门口或柜台；商品 anchor 在橱窗 / 货架外观内分区；资源不进入购物热点区 | 强消费视觉、商品列表遮住关闭路径、Orange 被商店牌覆盖 |
| School Gate | 到校门、问候、Gate / Sun / Kite 线索入口 | Gate 是安全生活入口；School line anchor 与门口留出通行缓冲 | 校门像迟到检查、闸门、课堂入口或资格判断 |
| School Yard | 操场发现、软网、风筝、玩具和活动角 | K/N/R/Y 分为天空 / 地面 / 工具角 / 玩具角；每个 anchor 保持单独可看轮廓 | anchor 堆叠成课程板；操场像比赛 / 评分场 |

### 2.3 热点优先级规则

后续实现应把热点判定写成可审计规则，而不是靠场景摆放碰运气：

1. NPC 互动优先于资源拾取，除非玩家明确站在资源交互半径内且 NPC 超出提示半径。
2. P0 place 入口优先于远郊 / P1 preview，不允许 X/Z 或 Coast Edge 抢 Home / School 线。
3. Anchor `看看` 优先于同位置装饰背景，但不能抢 NPC 正在进行的轻委托交付。
4. 资源点不得与 anchor look cell、NPC cell、shop counter cell、home entry cell 共格。
5. 每个 hotspot 需要 debug-free 的孩子端提示名，例如 `看看 Mina`、`看看 小树枝`、`看看 Clock`，不显示坐标或 contract ID。

## 3. PLAYGATE-005 UI 可读可触摸返修方案

目标：HUD / 底栏 / 弹层 / 相册在 1280x720 下可读、可触、可关闭，并且不遮挡 P0 生活操作。960x540 继续留到全部开发完成后的专项适配，不作为本轮阻塞门槛。

### 3.1 1280x720 阻塞门槛

| UI 区域 | 返修要求 | 阻塞判定 |
|---|---|---|
| 顶部 HUD | 只保留小镇状态、金币 / 宠物 / 今日短提示；不显示格子坐标、调试加载、长段说明 | 文本溢出、遮住角色 / anchor、出现工程或课程文案 |
| 底栏 | `看看`、小镇 / 小屋 / 背包等入口触控目标稳定；图标优先，短文本辅助 | 按钮贴边、大小不一、误触热点、缺少 pressed / disabled 状态 |
| 上下文 `看看` | 显示当前目标，不再让孩子猜点击对象；目标变化要稳定 | 靠近多个对象时提示跳动，或显示与实际触发不一致 |
| 商店弹层 | 商品名、价格、金币、购买 / 关闭路径可读；买不起只温和 disabled | 关闭按钮不明显，价格 / 文本挤压，强消费 / 倒计时视觉 |
| 小屋 / 家具弹层 | 摆放、旋转、挪动、收起按钮可触；Sunny 反馈不被盖住 | 家具操作和 Sunny 反馈互相遮挡，无法返回小镇 |
| 相册 | 全屏 overlay 盖住地图层；字母徽章不穿层；卡片文字短且可读 | 地图元素穿透、相册像课程表 / 完成率、关闭路径不清 |
| 设置 | 关闭、声音、回安全位置、休息入口清楚；不遮住核心操作 | 退出 / 休息路径引发误触，或文案像家长后台 |

### 3.2 UI 返修优先级

| 优先级 | 项目 | 说明 |
|---|---|---|
| P0 | 上下文 `看看` 稳定性 | 这是孩子理解居民、资源、anchor 和 place 的主入口，必须先稳定。 |
| P0 | 弹层关闭一致性 | 商店、小屋、相册、设置都要有固定关闭位置和足够触控面积。 |
| P0 | HUD / 底栏避让地图焦点 | Town Plaza / Home / Shop / School line 的关键互动对象不得被常驻 UI 压住。 |
| P1 | 图标与短文本统一 | 图标风格、尺寸、透明 glass 承载层统一到 Round92 方向。 |
| P1 | 相册信息密度 | 相册保留收藏感和地点故事，减少课程化标签和长文本。 |
| 专项 | 960x540 适配 | 等全部开发完成后单独开移动 / 小横屏专项，不回填为本轮完成阻塞。 |

## 4. PLAYGATE-008 1280 截图包与 approved 判定

判定口径：

- `production`：资产或 UI 已通过 logical asset ID / runtime 接入，可作为实现基线。
- `approved`：有 1280x720 runtime 截图证据，并经 PM / Art Direction 判定达到当前 playgate 目的。
- `needs_fix`：截图证据缺失、证据不属于最新 Round99 包、生活用途不清、UI / 热点 / 触控仍需返修，或文档已明确“不标最终美术 approved”。

### 4.1 截图证据表

| 画面 | 证据 | 来源 | 1280 存在性 | 判定 |
|---|---|---|---|---|
| Town Plaza / World Map | `docs/collaboration/round99_runtime_visual_acceptance/shot_round99_town_plaza_denoised_1280.png` | Round99 denoised proof | 已确认 1280x720 PNG | `approved` for 1280 art baseline；仍需 PLAYGATE 空间审计后批准 product |
| Home | `docs/collaboration/round99_runtime_visual_acceptance/shot_round99_home_denoised_1280.png` | Round99 denoised proof | 已确认 1280x720 PNG | `needs_fix` for approved；Round99 已说明小屋仍是功能型可玩视图 |
| Shop | `docs/collaboration/round99_runtime_visual_acceptance/shot_round99_shop_denoised_1280.png` | Round99 denoised proof | 已确认 1280x720 PNG | `approved` for 1280 art baseline；product approved 需复核关闭路径和购买触控 |
| School Gate | `docs/collaboration/round96_visual_acceptance/shot_production005_school_gate_round96_final_1280.png` | Round96 final proof | 已确认 1280x720 PNG | `needs_fix` / pending Round101 RC proof；不在 Round99 截图包 |
| School Yard | `docs/collaboration/round96_visual_acceptance/shot_production005_school_yard_round96_final_1280.png` | Round96 final proof | 已确认 1280x720 PNG | `needs_fix` / pending Round101 RC proof；不在 Round99 截图包 |
| Album | `docs/collaboration/round99_runtime_visual_acceptance/shot_round99_album_denoised_1280.png` | Round99 denoised proof | 已确认 1280x720 PNG | `approved` for 1280 art baseline；继续禁止地图徽章穿层 |
| Settings | `docs/collaboration/round99_runtime_visual_acceptance/shot_round99_settings_denoised_1280.png` | Round99 denoised proof | 已确认 1280x720 PNG | `approved` for 1280 art baseline；product approved 需复核休息 / 回安全位置误触 |

### 4.2 批准结论

当前可批准内容：

- Town Plaza / World Map 可作为 `1280 art baseline approved`，但不是 product complete。
- Shop、Album、Settings 可作为 `1280 art baseline approved`，后续仍要进入 PLAYGATE UI 操作复核。
- Round92 三张样张继续只作为 visual direction reference，不是 runtime `production` 或 `approved` 资产。

当前不可批准内容：

- Home 不标最终 approved。原因：Round99 原文已写明“当前小屋仍是功能型可玩视图，不标最终美术 approved”。
- School Gate / School Yard 不标 Round101 release-candidate approved。原因：存在 Round96 1280 proof，但缺少 Round99 denoised / Round101 RC 截图包复核；还需要验证校门 / 操场是否生活化、非课程化、热点不堆叠。
- V02.20 不能整体标 product complete。原因：PLAYGATE-004 / 005 / 007 / 008 / 009 尚未全部收口，且当前任务只是文档返修方案和批准判定。

## 5. 下一阶段优先级建议

| 优先级 | 下一步 | Owner 建议 | 完成门槛 |
|---|---|---|---|
| 1 | 先完成 PLAYGATE-002 / 003 / 007 的审计与旧路径矩阵整合 | QA / UX / Godot | 确认首屏缺口、5 分钟真实入口 smoke、V02.8-V02.19 旧路径是否退化 |
| 2 | 按本文件执行 PLAYGATE-004 空间返修 | Map / UX / Art Direction / Godot | 居民、资源、anchor、家具不互吞；P0 地点生活用途清楚 |
| 3 | 按本文件执行 PLAYGATE-005 UI 返修 | UI / UX / QA / Godot | HUD / 底栏 / 弹层 / 相册 1280 无遮挡、可触、可关闭 |
| 4 | 重新导出 Round101 1280 RC 截图包 | Art Direction / QA | Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings 全量同轮 proof |
| 5 | PLAYGATE-008 二次批准 | PM / Art Direction / QA | 逐项从 `needs_fix` 升级或保留；不得把 `production` 自动写成 `approved` |
| 6 | PLAYGATE-009 决策 | PM / QA | 决定进入内容扩展、继续居住感返修或移动适配专项 |

## 6. 非本轮范围

- 不新增 gameplay、课程 UI、远郊 P0、真实联网、账号、云存档或商业化。
- 不重排 A-Z，不改 `anchor_id`、`core_word`、`route_order`、坐标语义或相册语义。
- 不修改 runtime、assets、data、tests。
- 不把 960x540 作为本轮阻塞门槛；它仍归入全部开发完成后的专项适配。
- 不把 V02.19 写成 product complete。

## 7. 验证说明

本任务是文档交付，无需运行 Godot。已通过 `rg` / `ls` / `file` 确认输入文档和 1280 PNG 证据存在。后续若进入实现或截图批准，应另开运行时任务并导出同轮 1280 RC 截图包。
