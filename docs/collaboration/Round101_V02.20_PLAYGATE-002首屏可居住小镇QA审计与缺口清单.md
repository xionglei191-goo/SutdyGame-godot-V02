# Round101 V02.20 PLAYGATE-002 首屏可居住小镇 QA 审计与缺口清单

> 日期：2026-06-06
> 任务：`V02-PLAYGATE-002 首屏可居住小镇 QA 审计与缺口清单`
> 范围：只审计现有 proof / 文档 / 台账；不改 runtime、tests、assets 或 data。
> 结论：V02.19 只能作为 1280x720 art baseline，不自动等同 product complete、mobile complete、release approved 或 PM / Art Direction approved。V02.20 仍需按 PLAYGATE-003..009 继续补齐真实 5 分钟生活动线、空间分层、UI 可触、文本审校、旧路径回归和 approved 判定。

## 1. 审计输入与证据确认

已核对：

- `todo.md`、`lessons.md`
- `docs/collaboration/Round99_V02.19_ARTPASS-010运行时视觉验收与发布候选记录.md`
- `docs/collaboration/round99_runtime_visual_acceptance/`
- `docs/collaboration/Round96_V02.19_ARTPASS-007全屏构图与UI返修验收记录.md`
- `docs/collaboration/round96_visual_acceptance/`
- `docs/collaboration/Round100_V02.20_PLAYGATE-001_PM执行任务包.md`
- `docs/12_V02开发路线.md`
- `docs/13_V02详细开发计划.md`
- `docs/15_项目经理接管与下一阶段执行计划.md`

证据存在性验证已执行：

```bash
find docs/collaboration/round99_runtime_visual_acceptance -maxdepth 1 -type f -name '*.png' -print
file docs/collaboration/round99_runtime_visual_acceptance/*.png docs/collaboration/round96_visual_acceptance/*round96_final_1280.png
rg -n "V02\\.19|V02\\.20|PLAYGATE|1280|approved|production" docs/12_V02开发路线.md docs/13_V02详细开发计划.md docs/15_项目经理接管与下一阶段执行计划.md todo.md
```

截图基线：

- Round99 主证据：Town Plaza、Home、Shop、Album、Settings 的 `*_denoised_1280.png`，均为 1280x720 PNG。
- Round96 补充证据：School Gate、School Yard 的 `round96_final_1280.png`，均为 1280x720 PNG。
- 审计限制：Round99 没有 School Gate / School Yard denoised proof，因此学校视图结论只按 Round96 final proof 和路线台账判断；不得据此标最终 approved。

## 2. 总体判断

V02.19 已经从“占位地图”推进到“统一 cozy town art baseline”：底图铺满 1280x720，主要 UI 变成 glass overlay，Town / Home / Shop / Album / Settings 证据可打开且无明显工程文案。Round100 又补了连续行走、局部镜头、上下文 `看看` 提示和 HUD / anchor 降噪，这些是 V02.20 playgate 的正确入口。

但从孩子第一眼的“能在这里生活”角度看，当前仍不是 product complete：

- Town Plaza 仍像一张漂亮全景地图叠加 26 个字母和多个热点，生活物件、居民目的、可停留区域的优先级还不够清楚。
- Home 功能可用，但室内视觉偏空、偏编辑器格子，家具和宠物生活痕迹不足，居住感最弱。
- Shop 可读且无强消费压力，但弹层遮挡大，商品与店铺空间的关系更像列表，不像走进街角商店。
- School Gate / School Yard 有安全文本和生活线索，但 proof 仍是全图叠层，学校地点没有形成独立可识别的到达感。
- Album 和 Settings 可用，但相册英文长句、状态按钮和设置弹层仍需专门审校与触控复核。

## 3. 逐视图 QA 审计表

| 视图 | 证据 | 居住感 | 动线入口 | 遮挡 / 可读性 | 儿童安全视觉结论 | 审计结论 |
|---|---|---|---|---|---|---|
| Town Plaza | Round99 `shot_round99_town_plaza_denoised_1280.png` | 背景已像温暖小镇，水岸、商店街、家、道路和动物居民有生活氛围；但 A-Z 徽章和热点数量仍抢主视觉，孩子第一眼更容易读成“找字母地图”。 | 底栏 `看看`、`小镇`、`小屋`、`背包` 可见；顶部提示给出靠近居民 / 小屋 / 商店或树枝可看看。Round100 已说明上下文看看存在，但该 proof 仍不能证明完整 5 分钟自由动线。 | 顶部 HUD 横跨全屏，底栏遮住海滩下缘；字母徽章在 B/T/E/H/I/O/J/F/L/Z/U/P/X 等区域密集，部分物件和角色被徽章压过。 | 无课程、测试、评分、倒计时、战斗或警报；视觉安全。 | 可作为 1280 art baseline；不应标 product complete。空间分层和 anchor 降噪是 playgate 阻塞输入。 |
| Home | Round99 `shot_round99_home_denoised_1280.png` | 当前最弱。小屋是可操作房间，但大面积空白、格子地板和单个角色使其更像家具编辑界面，不像已经有人生活的小屋。 | 底栏 `小屋` 入口可见；右侧物件面板可摆放小木椅，但 `旋转` / `挪动` / `收起` 灰显，直接操作状态不清。 | 右侧物件面板可读；左侧 Sunny 气泡可读；主房间尺寸偏小且居中偏上，底部留白过多。 | 文案温和，无强制学习、惩罚或消费压力。 | 居住感阻塞 playgate。必须进入 Home / 家具 / Sunny 生活痕迹返修输入。 |
| Shop | Round99 `shot_round99_shop_denoised_1280.png` | 街角商店背景存在，商品列表有小镇购物感；但半透明大面板覆盖右半屏，商店更像 UI 列表而非店内浏览。 | 商店面板已打开，`收起` 可见，商品项可读；金币价格明确。 | 面板与 A-Z 徽章 H/I/O/J/F/L/Z/U/M/P 同屏叠加，右侧地图读图被弱化；底栏与商品列表下缘接近，长列表可能需要触控专项复核。 | 无倒计时、售罄、限时、强消费或运营压力；价格表达温和。 | 不阻塞基础安全，但阻塞 playgate 的商店空间分层和真实浏览感。 |
| School Gate | Round96 `shot_production005_school_gate_round96_final_1280.png` | 有校门文本和学校路线语义，但 proof 仍是全镇大地图，校门地点本身不够突出；学校不像独立可到达场景。 | 顶部反馈显示 School Gate 文案，说明真实 `看看` 路线曾可触发；底栏入口仍是通用按钮。 | 字母和热点叠层较多；School Gate 文案在顶部单行较长，含中英混排，截断风险需文本审校。 | 文案为轻松问候，没有作业、测试、分数或训导。 | 学校安全方向正确；地点到达感和文案长度是 playgate 阻塞输入。 |
| School Yard | Round96 `shot_production005_school_yard_round96_final_1280.png` | 操场线索存在，但仍在同一全图视角里表达；儿童活动区、可停留物件和学校生活氛围不够独立。 | 顶部反馈显示 School Yard 文案，说明操场 `看看` 路线曾可触发；但 proof 不证明自由移动到操场后的局部镜头体验。 | 顶部文本过长并截断，地图中徽章 / 小物件 / 角色叠加较密。 | 无课堂、测试、背诵、迟到、打卡或分数；安全。 | 安全不阻塞，但 School line 的空间识别、局部镜头 proof 和短句审校阻塞 playgate。 |
| Album | Round99 `shot_round99_album_denoised_1280.png` | 相册像收藏册，符合回访记录功能；不是生活空间，但可作为小镇记忆入口。 | `返回` 可见；卡片状态、亮点和收藏状态可见。 | 相册全屏解决了 Round99 之前的字母徽章穿层；但卡片英文句子偏长，按钮密度和滚动条位置需触控复核。 | 无测试/评分；但 `亮点 38`、`玩过`、`已收藏` 是否会被孩子理解为评价体系，需要 V02-PLAYGATE-006 文本审校。 | 可用，不阻塞基础 playgate；文本和触控进入后续优化 / UI 专项。 |
| Settings | Round99 `shot_round99_settings_denoised_1280.png` | 设置是工具弹层，不要求居住感；当前视觉与 glass UI 一致。 | `收起`、`声音开`、`回到小镇`、`休息一下` 可见，关闭路径明确。 | 右侧弹层遮挡地图，但属于临时设置状态；按钮尺寸在 1280 下可读，960 暂不判定。 | 文案温和，休息入口安全，没有家长后台、报告、工程文案或惩罚压力。 | 1280 基础可用；小视口和触控态进入版本适配专项。 |

## 4. 缺口分级

### 阻塞 playgate

| ID | 缺口 | 影响视图 | 依据 | 后续承接 |
|---|---|---|---|---|
| PG-BLOCK-001 | 首屏仍偏“全景地图 + 字母徽章 + 热点”，生活用途优先级不够清楚。 | Town Plaza、Shop、School Gate、School Yard | Round99 / Round96 proof 中 A-Z 徽章与热点密集，多个生活物件被同层抢占。 | PLAYGATE-004 |
| PG-BLOCK-002 | Home 室内居住感不足，房间像空白摆放网格，不像孩子会回来的小屋。 | Home | Round99 Home proof 大面积空白、家具少、Sunny 生活痕迹弱。 | PLAYGATE-004、PLAYGATE-005 |
| PG-BLOCK-003 | Shop / School 仍缺“到达一个地点”的局部体验 proof，当前更多是全图叠 UI 或全图触发反馈。 | Shop、School Gate、School Yard | Round99 Shop 为右侧面板覆盖地图；Round96 School 两张仍是全图视角。 | PLAYGATE-003、PLAYGATE-004 |
| PG-BLOCK-004 | V02.20 新的连续行走、局部镜头、上下文 `看看` 尚未形成 3-5 分钟自由生活 smoke 规格和截图证据。 | 全路径 | Round100 明确未完成 Home / Shop 直接操作、NPC routine、资源 2.0 和完整 3-5 分钟新 smoke。 | PLAYGATE-003、PLAYGATE-007 |
| PG-BLOCK-005 | `production` / `approved` 状态仍需人工截图判断，V02.19 不能自动批准。 | 全视图 | docs/12、docs/13、docs/15、Round100 均明确 V02.19 只是 1280 art baseline。 | PLAYGATE-008、PLAYGATE-009 |

### 可后续优化

| ID | 缺口 | 影响视图 | 说明 | 后续承接 |
|---|---|---|---|---|
| PG-OPT-001 | Town Plaza 中居民 routine 与可停留活动还不够明显。 | Town Plaza | 角色可见，但缺少“正在生活”的状态表达，如散步、停留、看摊、照顾宠物。 | PLAYGATE-004 或后续内容扩展 |
| PG-OPT-002 | 相册英文句子和状态词偏功能化。 | Album | 英语作为 ambient layer 可以保留，但句长和按钮语义需要孩子端语气审校。 | PLAYGATE-006 |
| PG-OPT-003 | Settings 视觉安全，但可以更像系统小抽屉，减少遮挡地图面积。 | Settings | 不阻塞 1280 基础可用。 | PLAYGATE-005 |
| PG-OPT-004 | Shop 商品列表可读，但商品视觉和实际小镇位置关系弱。 | Shop | 可在后续把货架、店长反馈和已拥有状态做得更生活化。 | PLAYGATE-004、PLAYGATE-005 |

### 版本适配专项

| ID | 缺口 | 影响视图 | 说明 | 后续承接 |
|---|---|---|---|---|
| PG-ADAPT-001 | 960x540 和更小横屏暂不作为本阶段阻塞门槛。 | 全视图 | docs/12、docs/13、docs/15 已固定 1280x720 为当前未完成任务的阻塞性视觉验收口径。 | 全量开发完成后的移动适配专项 |
| PG-ADAPT-002 | 顶部 HUD、底栏、弹层按钮在小视口下的触控尺寸、文字截断和安全区需重测。 | Town Plaza、Home、Shop、Album、Settings | 当前审计只基于 1280 proof，不能推断移动小视口通过。 | PLAYGATE-005 输入，最终进适配专项 |
| PG-ADAPT-003 | School Gate / Yard 缺 Round99 denoised 证据，后续 approved 前需补同口径截图。 | School Gate、School Yard | 本轮用 Round96 final proof 补审，不作为 approved 依据。 | PLAYGATE-008 |

## 5. 儿童安全视觉结论

当前 proof 未发现以下禁用方向：课程页、测试、背诵、作业检查、评分、打卡、倒计时、错过压力、强消费、售罄焦虑、家长报告、工程调试文案、战斗警报或陌生人出行压力。

需要后续审校的不是“危险内容”，而是“产品语气”：Album 中 `亮点`、`玩过`、较长英文句，以及 School 顶部长句需要改成更短、更像生活发现的孩子端表达。School Gate / School Yard 的方向应继续保持“生活地点、问候、操场小发现”，不能升级为课堂或考试。

## 6. 对 PLAYGATE-003..009 的输入结论

| 后续任务 | 输入结论 |
|---|---|
| PLAYGATE-003 启动到 5 分钟自由生活 playgate smoke 规格 | Smoke 必须从启动首屏出发，覆盖连续行走、上下文 `看看`、Mina / Sunny / Shopkeeper、资源、Shop、Home、Album、Settings；不得用隐藏 contract 入口。必须证明 Home / Shop / School line 在 V02.20 局部镜头下可走可看。 |
| PLAYGATE-004 居民、资源、家具和 anchor 空间分层返修方案 | 优先解决 Town Plaza 首屏信息层级、Home 居住感、Shop 货架/店长/商品关系、School Gate / Yard 到达感，以及 A-Z 徽章不压过生活物件。不得改 A-Z ID、route_order 或 anchor 语义。 |
| PLAYGATE-005 HUD / 底栏 / 弹层 / 相册可读可触摸返修方案 | 1280 下重点复核顶部 HUD 长句、底栏遮挡、Shop 大面板、Home 物件面板、Album 卡片按钮、Settings 弹层关闭路径；960x540 只记录为版本适配专项。 |
| PLAYGATE-006 孩子端文本和生活反馈 playgate 审校 | 审校 Town 提示、Home Sunny、Shop 商品、School Gate / Yard 顶部反馈、Album 卡片和 Settings；保留英语为 ambient layer，避免课程化、评价化和工程化。 |
| PLAYGATE-007 V02.8-V02.19 旧玩家路径回归矩阵 | 重点确认 V02.20 行走 / 局部镜头 / 上下文看看没有退化每日小镇、小屋、A-Z、天气、Home / School、P1、Playable RC 和 art pass 后路径。 |
| PLAYGATE-008 1280 release-candidate 截图包和 approved 判定 | 必须重新导出 1280 proof，至少覆盖 Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings；Round99 / Round96 只能做输入证据，不能自动 approved。 |
| PLAYGATE-009 V02.20 playgate 收口与下一阶段决策 | 若 PG-BLOCK-001..005 未解决，应继续居住感返修；若 1280 approved 通过，再决定进入内容扩展或移动适配专项。 |

## 7. 验证与台账说明

本任务为文档 QA 审计，无需运行 Godot。已按要求使用 `rg`、`find`、`file` 和截图查看确认引用证据存在。

按用户本轮限制“只写一个新文档”，本轮未更新 `todo.md` 或 `lessons.md`。未新增已验证故障教训；本轮缺口属于 playgate 审计发现，已在本文件分级并作为 PLAYGATE-003..009 输入。
