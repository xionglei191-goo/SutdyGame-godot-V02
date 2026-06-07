# StudyGame V02 项目 TODO

> 最后更新：2026-06-07
> 状态事实来源：本文件
> 当前阶段：V02.39 Godot 视觉生产体系重建
> 当前里程碑：Round160 V02-VISUALREBUILD-001 已完成路线与任务包；V02.38 Round155-Round159 项目级重解释为 `visual_scaffold`

## 维护规则

- `[ ]` 待办：尚未进入本轮。
- `[~]` 进行中：已进入本轮并正在实施。
- `[!]` 阻塞：存在明确阻塞条件，需记录原因和解除方式。
- `[x]` 完成：交付物存在、验证通过、验收标准满足。
- 每轮开工前更新“当前状态面板”；完成后更新任务状态、完成记录和 `lessons.md`。
- 任务不得仅因代码或文档已写完而完成；必须通过对应验收。
- 新需求先进入待办并明确阶段、依赖、Owner 和验收标准。

## 当前状态面板

| 项目 | 当前状态 |
|---|---|
| 当前轮次 | Round160：V02-VISUALREBUILD-001 Godot 视觉生产体系重建路线与任务包 |
| 本轮目标 | 已将二次视觉复核结论写入 docs 12-15、Round160、todo 和 lessons；V02.38 重解释为 `visual_scaffold`，StoryBatch 继续阻塞 |
| 进行中 | 暂无 |
| Ready | `V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同` |
| 汇合任务 | 已完成：地图编辑层、运行时小镇体验、远期本地 stub、QA 汇合、主界面视觉修正、首屏 Playfield 化、Sprite2D 小镇资产化、孩子端中文界面、HUD 顶底栏收纳、顶部 HUD 单行压缩、底部操作栏精简、底部按钮儿童化视觉、背包气泡内容恢复、V02.1 每日小镇、V02.2 我的小屋、V02.3 小镇记忆宫殿、V02.4 内容生产框架、Round 48 真实可玩路径修复、Round 49 美术与策划路线更新、V02.5 美术素材生产线文档清单、V02.6 策划内容生产线、V02-POLISH-001、V02-POLISH-002、V02-POLISH-003、V02-POLISH-004、V02.7A 美术基线重建、V02-DAILYLIFE-001、V02-DAILYLIFE-002、V02-DAILYLIFE-003、V02-DAILYLIFE-004、V02-DAILYLIFE-005、V02.8 每日小镇生活纵切、V02-WEEKLY-001、V02-WEEKLY-002、V02-WEEKLY-003、V02-WEEKLY-004、V02.9 一周回访节奏、V02-P1RETURN-001、V02-P1RETURN-002、V02-P1RETURN-003、V02-P1RETURN-004、V02.10 P1 居民回访扩展、V02-WEATHER-001、V02-WEATHER-002、V02-WEATHER-003、V02-WEATHER-004、V02.11 天气与小镇轻事件纵切、V02-AZWORLD-001、V02-AZWORLD-002、V02-AZWORLD-003、V02-AZWORLD-004、V02-AZWORLD-005、V02.12 学校-家庭中心世界地图与 A-Z 锚点规划、V02-TEXTBOOK-001、V02-TEXTBOOK-002、V02-TEXTBOOK-003、V02-TEXTBOOK-004、V02-TEXTBOOK-005、V02.13 全量课本内容世界化主线策划、V02-HOMESCHOOL-001、V02-HOMESCHOOL-002、V02-HOMESCHOOL-003、V02-HOMESCHOOL-004、V02-HOMESCHOOL-005、V02-SCHOOLDAILY-001、V02-SCHOOLDAILY-002、V02-SCHOOLDAILY-003、V02-SCHOOLDAILY-004、V02-SCHOOLDAILY-005、V02.15 Home / School 日常回访与学校生活轻循环、V02-PRODUCTION-001、V02-PRODUCTION-002、V02-PRODUCTION-003、V02-PRODUCTION-004、V02-PRODUCTION-005、V02.16 可制作内容与体验抛光 / Playable RC Gate、V02-WORLDMAP-001、V02-WORLDMAP-002、V02-WORLDMAP-003、V02-WORLDMAP-004、V02-WORLDMAP-005、V02.17 世界地图运行时落地与 26 Anchor 可视布局、V02-MAPREAD-001、V02-MAPREAD-002、V02-MAPREAD-003、V02-MAPREAD-004、V02-MAPREAD-005、V02.18 世界地图视觉可读性与探索体验抛光、V02-ARTPASS-001、V02-ARTPASS-002、V02-ARTPASS-003、V02-ARTPASS-004、V02-ARTPASS-005、V02-ARTPASS-006、V02-ARTPASS-007、V02-ARTPASS-008、V02-ARTPASS-009、V02-ARTPASS-010、V02.19 1280 art baseline、V02-PLAYGATE-001、V02-PLAYGATE-002、V02-PLAYGATE-003、V02-PLAYGATE-004、V02-PLAYGATE-005、V02-PLAYGATE-006、V02-PLAYGATE-007、V02-PLAYGATE-008、V02-PLAYGATE-009、V02.20 playgate 文档收口、V02-LIVEGATE-001、V02-LIVEGATE-002、V02-LIVEGATE-003、V02-LIVEGATE-004、V02-LIVEGATE-005、V02.21 可居住小镇返修实现、V02-HIDDENGRID-001、V02-HIDDENGRID-002、V02-HIDDENGRID-003、V02-HIDDENGRID-004、V02-HIDDENGRID-005、V02-HIDDENGRID-006、V02-HIDDENGRID-007、V02.22 隐藏网格生活小镇与 scenes 组件化阶段收口、V02-EXPAPPROVAL-001、V02-EXPAPPROVAL-002、V02-EXPAPPROVAL-003、V02-EXPAPPROVAL-004、V02-EXPAPPROVAL-005、V02-EXPAPPROVAL-006、V02-HOMEPLAZA-001、V02-HOMEPLAZA-002、V02-HOMEPLAZA-003、V02-HOMEPLAZA-004、V02-HOMEPLAZA-005、V02-MAPAUTH-001、V02-MAPAUTH-002、V02-MAPAUTH-003、V02-MAPAUTH-004、V02-MAPAUTH-005、V02-MAPAUTH-006、V02-CONTENTBATCH-001、V02-CONTENTBATCH-002、V02-CONTENTBATCH-003、V02-CONTENTBATCH-004、V02-MAPEDITOR-010、V02.27 Map Editor 完整化、V02-MAPDOGFOOD-001、V02-MAPDOGFOOD-002、V02-MAPDOGFOOD-003、V02-MAPDOGFOOD-004、V02-MAPDOGFOOD-005、V02.28 Map Editor 实战生产验证、V02-STORYMOTIONART-001、V02.29-V02.36 长远路线、V02-MOTION-001、V02-CONTROLS-001、V02-ARTPIPE-001、V02-ARTPIPE-002、V02-ARTPROD-001、V02-RUNTIME-ANIM-001、V02-STORYSLICE-001、V02-VISUALRECOVERY-002、V02-VISUALRECOVERY-003、V02-VISUALRECOVERY-004、V02-VISUALRECOVERY-005、V02-VISUALRECOVERY-006、V02-VISUALREBUILD-001 |
| 阻塞项 | `V02-STORYBATCH-004/005` 继续阻塞；必须等待 V02.39 达到 `runtime_visual_match` 并由 PM / Art Direction 明确解锁 |
| 待确认决策 | 无；已采用 V02.39 Godot 视觉生产体系重建路线，full-map background 禁用仍为最终目标 |
| 临时默认值 | V02.37 在 Round153 后暂停；Round153 第二批 production 资产保留为库存但不进入 runtime / final approval；`docs/collaboration/artpass003_visual_direction/` 和 Round92 是当前视觉硬门槛；`place.world_map.base_1280` / `world_map_base_1280.png` 只能作为 reference，不得作为 final runtime 主画面；状态语义为 `production`、`functional_pass`、`visual_scaffold`、`art_target_locked`、`runtime_visual_match`、`final_approved`；Round119 历史 `approved` 改按旧阶段 `functional_pass` 管理；Round159 `visual_candidate` 项目级重解释为 `visual_scaffold`；A-Z 默认 prop-first，字母 badge 只作辅助；V02.39 必须先 target 1280 frame，再 visual layout contract，再 runtime match；底层保留 cell / footprint / occupied cells，孩子端不显示格子、瓦块、坐标或调试术语；Apple-like translucent glass UI；不采用绘本 / storybook / picture-book / 课程面板 / 厚卡片 / 裸字母牌作为正式方向；素材必须有 logical asset ID；当前未完成视觉验收只看 1280x720，960x540 等全部开发完成后再做版本适配；A-Z 锚点常驻地图；Letter Snake 仅可选；账号/云存档/语音/AI/社交均为本地 stub |

## 本轮分工

| 小组 | 任务 | 当前状态 | 备注 |
|---|---|---|---|
| PM / Narrative / Art Direction / UX / QA | V02-STORYMOTIONART-001 V02.29-V02.36 长远路线与任务包 | 完成 | Round141 已完成长远路线；下一轮 Ready 为 `V02-STORYLINE-002` |
| Narrative / Memory Palace / PM | V02-STORYLINE-002 全量故事线总纲与章节骨架 | 完成 | Round142 已完成，不改 runtime / data / assets |
| Narrative / Map / QA | V02-STORYLINE-003 当前地图适配与内容生产蓝图 | 完成 | Round143 已完成 direct_runtime / asset_only / Map Editor 候选清单 |
| Animation / UX / Godot / QA | V02-MOTION-001 行走动画与角色动作规格 | 完成 | Round144 已完成 player / NPC / Sunny 动作状态机和 sprite sheet 规格 |
| UX / Godot / QA | V02-CONTROLS-001 Animal Crossing-like 操控规格 | 完成 | Round145 已完成连续移动、镜头、隐藏网格、prompt 和输入策略 |
| Art Direction / Asset / Narrative | V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格 | 完成 | Round146 已完成 tile、edge、prop、story object、character motion、UI feedback backlog |
| Tech Art / Tooling / QA | V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范 | 完成 | Round147 已完成导入、命名、ThemeProfile、editor marker、sprite sheet 和 proof 规则 |
| Art Direction / Asset / Tech Art / QA | V02-ARTPROD-001 首批美术资产生产与接入 | 完成 | Round148 已完成首批 story prop / character motion / pet motion / UI feedback / tile edge production 资产接入；production 不自动 approved |
| Art Direction / Asset / QA | Round141-151 图片来源返修 | 完成 | 已确认 Round148 是唯一新增 bitmap PNG 的轮次；10 张同名 production PNG 已用 `/home/xionglei/GameProject/tools/image_generator.js` 重新生成并保持原 logical asset ID / 尺寸合同 |
| Godot / UX / QA | V02-RUNTIME-ANIM-001 动作操控运行时纵切 | 完成 | Round149 已完成 player motion sheet、keyboard hold、camera smoothing、prompt glow / tap ripple、真实入口 smoke 和 1280 proof |
| Narrative / Godot / Art Direction / QA | V02-STORYSLICE-001 故事线 + 美术 + 动作整合纵切 | 完成 | Round150 已完成四个 P0 story prop runtime、A/B/H/N/R/Y 相册落账、Story Bear / branch 轻联动和 1280 proof |
| PM / Narrative / Art Direction / QA | V02-STORYBATCH-001 V02.37+ 内容批量生产与批准线规划 | 完成 | Round151 已完成后续 story batch 队列、批准线和下一轮 Ready；本轮未改 runtime / data / tests / assets |
| Narrative / Memory Palace / Art Direction / QA | V02-STORYBATCH-002 第二批 story prop / A-Z 回访内容包 | 完成 | Round152 已完成 C/D/G/K/O/S/W 七条候选内容包和文档合同测试 |
| Asset / Tech Art / Godot / QA | V02-STORYBATCH-003 第二批 production 资产与接入 | 完成 | Round153 已完成 7 张第二批 production PNG、ThemeProfile / AssetResolver、story prop JSON、Map Editor marker 和 provenance 证据；production 不自动 approved |
| Godot / Narrative / QA | V02-STORYBATCH-004 第二批 runtime 接入与真实入口 smoke | 阻塞 | 等待 V02.39 达到 `runtime_visual_match` 并由 PM / Art Direction 明确解锁；不得把新 story prop 叠到当前 `visual_scaffold` 上 |
| QA / PM / Art Direction | V02-STORYBATCH-005 1280 proof、approved 判定与阶段收口 | 阻塞 | 不得在 `visual_scaffold` 上做 approved 判定；需等待 V02.39 final gate |
| PM / Art Direction / QA | V02-VISUALRECOVERY-001 全面纠偏与文档重写 | 完成 | Round154 已完成；docs 12-15、todo、lessons 和 Round154 任务包同步；`git diff --check` 与 Godot headless 启动通过；不改 runtime |
| Art Direction / Tech Art / Godot / QA | V02-VISUALRECOVERY-002 Modular Visual System 规格 | 完成 | Round155 规格完成；Round159 补充 canonical category alias 与首屏 delivered set 说明 |
| Asset / Art Direction / Tech Art | V02-VISUALRECOVERY-003 首屏统一资产包生产 | 完成 | Round156 首屏统一资产包、provenance 和接触表已补齐 School-line chunk；ThemeProfile 映射和 acceptance 记录通过 |
| Godot / Tech Art / QA | V02-VISUALRECOVERY-004 TownStage 无整图底图渲染纵切 | 完成 | TownStage 用 modular terrain / region / prefab / prop layers；`world_map_base_1280.png` 仅 reference |
| UX / Art Direction / Godot / QA | V02-VISUALRECOVERY-005 HUD / Anchor / Actor 视觉降噪 | 完成 | glass HUD / footer、prompt glow、tap ripple、shadow、anchor badge 降噪和非 prefab place marker 降噪通过 |
| PM / Art Direction / UX / QA | V02-VISUALRECOVERY-006 1280 Final Visual Gate | 完成 | Round159 5 张 1280 proof 与真实入口 smoke 通过；二次视觉复核后项目级重解释为 `visual_scaffold`，未授予 `visual_candidate` / `final_approved` |
| PM / Art Direction / UX / QA | V02-VISUALREBUILD-001 Godot 视觉生产体系重建路线与任务包 | 完成 | Round160 已完成；docs 12-15、todo、lessons 和 Round160 任务包同步；不改 runtime / data / tests / assets |
| PM / Art Direction / Tech Art / UX | V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同 | Ready | 下一轮唯一 Ready；必须产出 target frame、layer / camera / depth / scale / UI safe area / A-Z priority / forbidden remnants 合同，达到 `art_target_locked` |
| Tech Lead / Godot / Tooling / QA | V02-VISUALREBUILD-003 Logic Map / Visual Layout 分层方案 | 待办 | 等待 V02-VISUALREBUILD-002；`world_map` 管逻辑事实，Visual Layout 管构图、深度、遮挡和 focus state |
| Art Direction / Asset / Tech Art | V02-VISUALREBUILD-004 首屏统一环境资产包与 composition kit | 待办 | 等待 target frame 和 layout contract；不得混用旧 scene fragment 或风格不一资产 |
| Godot / Tech Art / QA | V02-VISUALREBUILD-005 TownStage runtime visual match 纵切 | 待办 | 先匹配一张 1280 runtime frame，再恢复必要交互代理；目标状态为 `runtime_visual_match` |
| PM / Art Direction / UX / QA | V02-VISUALREBUILD-006 Art-direction gate 与 StoryBatch 解锁判定 | 待办 | 只有 target/runtime 并排复核、真实入口、A-Z 稳定和儿童安全全部通过后，才能解除 StoryBatch 阻塞 |
| Art Direction / Asset | V02-ART-001 美术资产目录与命名规范 | 完成 | 素材分类、逻辑 asset ID、状态和交付字段已写入 `docs/10` |
| Map / Asset | V02-ART-002 首批小镇场景素材清单 | 完成 | Home、Town Plaza、Shop、Bookshop、Bus Stop、道路、树、花、资源点清单已写入 `docs/10` |
| Narrative / Asset | V02-ART-003 首批角色与宠物素材清单 | 完成 | 玩家、Mina、店长、Sunny、故事熊、巴士哥哥清单已写入 `docs/10` |
| Home Design / Asset | V02-ART-004 家具与家园素材清单 | 完成 | 小桌、地毯、花盆、宠物碗、小床、墙饰清单已写入 `docs/10` |
| UI / Asset / UX | V02-ART-005 UI 图标与状态素材清单 | 完成 | 金币、点心、宠物状态、背包、相册、商店、设置/退出清单已写入 `docs/10` |
| Game Design / Narrative | V02-DESIGN-001 NPC 内容生产规范 | 完成 | NPC 字段、文本长度、关系阶段、轻委托对白和儿童安全边界已写入 `docs/14` |
| Game Design / Narrative | V02-DESIGN-002 每日轻委托内容包规划 | 完成 | 15 条每日轻委托规划已写入 `docs/14` |
| Game Design / Economy / Home Design | V02-DESIGN-003 商店与家具轮换策划 | 完成 | 商品分类、价格区间、轮换节奏和非惩罚经济已写入 `docs/14` |
| Memory Palace / Narrative / Curriculum | V02-DESIGN-004 A-Z 场景故事扩展规划 | 完成 | 26 个 anchor 的场景故事、视觉钩子和回访路径已写入 `docs/14` |
| Game Design / Narrative / UX | V02-DESIGN-005 节日与天气轻事件规划 | 完成 | 晴天、雨天/雨后、微风、集市日、儿童节、小镇庆祝等轻事件已写入 `docs/14` |
| UX / Godot / QA | V02-POLISH-001 退出与设置入口 | 完成 | 顶部设置入口、设置面板、休息二次确认、回到安全位置和操作级测试已接入 |
| QA / UI / Art Direction | V02-POLISH-002 玩家路径截图验收 | 完成 | 12 个关键路径截图清单、记录模板、触发规则和失败判定已建立 |
| QA / UX / Godot | V02-POLISH-003 移动端触控与布局复核 | 完成 | 1280x720 与 960x540 检查表、按钮尺寸、遮挡、安全区和弹层关闭路径标准已建立 |
| Art Direction / Asset / QA | V02-POLISH-004 首批正式素材替换验收 | 完成 | P0 production 素材已通过 ThemeProfile / AssetResolver 接入；运行时纹理断言、1280x720 MCP 截图抽查和 headless 验证通过 |
| PM / Art Direction / QA | V02-ARTBASE-001 首屏视觉目标与资产降级审计 | 完成 | 已形成审计记录、production / approved 证据门槛和 V02.8 进入判断 |
| Art Direction / Asset / QA / Godot | V02-POLISH-005 P1 素材替换与 960x540 补验 | 并入重评 | 不再作为独立 Ready；并入 V02.7A 美术基线重建与双视口截图验收 |
| QA / Art Direction / Godot | V02-ARTBASE-005 双视口截图验收 | 完成 | 历史双视口截图证据已清理归档，当前以 headless 回归与 Round96 final 1280 证据为准 |
| Godot Dev / Narrative / QA | V02-DAILYLIFE-001 三 NPC 日常入口 | 完成 | Mina、店长、Sunny 均已通过孩子端真实可见 `看看` 入口触发，并通过 focused/headless 验证 |
| Godot Dev / Game Design / QA | V02-DAILYLIFE-002 三条 P0 轻委托可玩化 | 完成 | Mina、店长、Sunny 三条 P0 委托均已通过主场景真实 `看看` 路径完成，并验证奖励、同日去重和保存重载 |
| Godot Dev / Economy / Home Design | V02-DAILYLIFE-003 商店到小屋使用闭环 | 完成 | 商店可见购买、小屋可见摆放 / 旋转 / 挪动 / 收起、背包更新、Sunny 反馈和持久化均已通过操作级验证 |
| Memory Palace / Narrative / Godot Dev | V02-DAILYLIFE-004 三个 A-Z 地点回访 | 完成 | C/O/S 三处均已通过主场景真实 `看看` 路径触发，写入相册状态并保持生活化地点故事 |
| QA / PM / Godot Dev | V02-DAILYLIFE-005 5 分钟纵切 smoke 与截图 | 完成 | `tests/test_v028_daily_life_slice.gd` 与 `tests/headless_runner.gd` 已覆盖端到端可见入口；旧双视口截图证据已清理，功能以 headless smoke 保留 |
| PM / Game Design / Narrative / QA | V02-WEEKLY-001 一周回访内容合同与排期 | 完成 | V02.9 路线、7 天排期、P0/P1 边界、禁用文案和验收口径已写入 docs/todo/Round60 任务包 |
| Godot Dev / Economy / QA | V02-WEEKLY-002 每日状态与商店轮换数据化 | 完成 | 7 天 `today_status`、P0/P1/P2 商店轮换、服务接口、内容合同和全量 runner 验证已通过 |
| Narrative / UX / QA / Godot | V02-WEEKLY-003 P1 居民回访入口预收 | 完成 | 故事熊 / 巴士哥哥入口、安全边界、截图点和 `V02-WEEKLY-004` smoke 输入已写入 docs/14 与 Round62 任务包 |
| QA / PM / Godot Dev | V02-WEEKLY-004 一周回访 smoke 与截图 | 完成 | 7 天玩家路径 smoke、headless runner、1280x720 / 960x540 代表截图已通过 |
| Godot Dev / UX / QA | V02-P1RETURN-001 Bookshop / Bus Stop 真实可见入口 | 完成 | 已接入 Bookshop 门口、Bear Corner、Bus Stop 站牌、Taxi marker 的真实可见 `看看` 入口；focused/headless 验证通过 |
| Narrative / Godot Dev / QA | V02-P1RETURN-002 故事熊 / 巴士哥哥 P1 轻回访 | 完成 | 已接入 Story Bear / Bear Corner 与 Bus Helper / Taxi marker 两条 P1 看一眼类支线，focused/headless 验证通过 |
| Memory Palace / UI / QA | V02-P1RETURN-003 B Bear / T Taxi 相册与 A-Z 记录 | 完成 | B Bear / T Taxi 入口查看和 P1 轻回访均会写入 card state / 小镇相册；focused/headless 验证通过 |
| QA / PM / Godot Dev | V02-P1RETURN-004 P1 回访 smoke 与截图 | 完成 | P1 支线 smoke、headless runner、1280x720 / 960x540 代表截图均已通过 |
| PM / Game Design / Data Contract / QA | V02-WEATHER-001 天气轻事件数据合同与今日状态接入 | 完成 | P0 天气事件合同、today_status 引用、service / validator / HUD 和 focused/headless 验证已通过 |
| Narrative / Economy / Godot Dev / QA | V02-WEATHER-002 NPC 问候与资源 / 商店轻变化 | 完成 | 天气问候变体、资源天气提示、商店活动角和 focused/headless 验证已通过 |
| Memory Palace / UI / Narrative / QA | V02-WEATHER-003 A-Z 天气相册线索 | 完成 | S Sun、K Kite、B Bear、U Umbrella 已通过真实 `看看` 路径写入天气相册线索与 card state |
| QA / PM / Godot Dev | V02-WEATHER-004 天气纵切 smoke 与双视口截图 | 完成 | 多天气 smoke、headless runner、1280x720 / 960x540 代表截图均已通过 |
| PM / Memory Palace / Map / Curriculum / QA | V02-AZWORLD-001 Home / School 中心地图原则与 26 anchor 分布合同 | 完成 | `az_world_plan` 数据合同、Home / School 双中心、26 anchor 分布、远郊边界和 focused/headless 验证已通过 |
| Map / PM / UX / QA | V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划 | 完成 | 已完成 Round74 任务包、区域道路安全规划、`routes` / `safety_boundaries` 合同和 focused/headless 验证 |
| Memory Palace / Narrative / Art Direction / QA | V02-AZWORLD-003 17 个 reserved anchor 升级为可制作级规格 | 完成 | 已完成 Round75 任务包、17 个 `reserved_anchor_specs`、可制作级规格记录和合同验证 |
| Curriculum / Narrative / PM / QA | V02-AZWORLD-004 Home / School 0 基础主线挂接位 | 完成 | 已完成 Round76 任务包、`foundation_story_hooks` 和 Home / School 0 基础挂接记录 |
| QA / PM / Godot Dev | V02-AZWORLD-005 合同测试、回归验证和截图验收口径 | 完成 | 已完成 `screenshot_acceptance`、扩展 focused/headless 回归和 V02.12 收口验证 |
| Curriculum / PM / QA | V02-TEXTBOOK-001 小学全册教材源补齐 | 完成 | 三上已补结构化摘要与公开来源记录；三下至六下 7 册沿用本地分析，8 册 source ledger 已进入 `textbook_world_plan` |
| Curriculum / Data Contract / QA | V02-TEXTBOOK-002 全量课本内容结构化清单 | 完成 | 85 个单元摘要已进入 `curriculum_items`，覆盖三上至六下每册单元数 |
| Memory Palace / Narrative / Map / QA | V02-TEXTBOOK-003 世界化主线映射表 | 完成 | `world_mappings` 已绑定世界地点、NPC、A-Z anchor、故事记忆、视觉钩子、回访路径和孩子端温和表达 |
| PM / Curriculum / Narrative / QA | V02-TEXTBOOK-004 Home / School 第一主线与 P0/P1/P2 分层 | 完成 | `mainline_segments` 已定义 Home morning、Home-School Walk、Shop bridge、P1 first ring 和 P2 reserve，P0 不使用远郊 |
| QA / Data Contract / PM | V02-TEXTBOOK-005 数据合同与回归验证 | 完成 | 新增 `TextbookWorldContract`、focused test 和 headless runner 注册；V02.13 数据合同通过 |
| PM / Game Design / Narrative / QA | V02-HOMESCHOOL-001 Home / School P0 可玩纵切路线与任务拆分 | 完成 | 已完成 V02.14 路线、P0 内容点、任务拆分、Round78 PM 任务包和下一轮 Ready |
| Godot Dev / Narrative / QA | V02-HOMESCHOOL-002 Home Morning Foundation 数据化与可见入口 | 完成 | Home / 小屋 / Sunny 早晨真实可见 `看看` 入口、A/C/D/W 线索和 focused test 已通过 |
| Map / Godot Dev / UX / QA | V02-HOMESCHOOL-003 Home-School Walk 可见路径与安全边界 | 完成 | Home-School Walk 路牌 / 风筝热点、安全返回和 G/K/S 线索已通过 |
| Narrative / Godot Dev / Memory Palace / QA | V02-HOMESCHOOL-004 School Gate / School Yard 首批地点故事 | 完成 | School Gate / School Yard 地点故事和 E/G/K/N/R/Y 线索已通过 |
| QA / PM / Godot Dev | V02-HOMESCHOOL-005 P0 主线 smoke、截图和儿童文本验收 | 完成 | 玩家路径 smoke、headless runner 注册、Godot 启动和 MCP 1280x720 运行时截图抽查已通过 |
| PM / Game Design / Narrative / QA | V02-SCHOOLDAILY-001 Home / School 日常回访路线与任务拆分 | 完成 | 已完成 V02.15 路线、7 天差异维度、任务拆分、Round80 PM 任务包和下一轮 Ready |
| Data Contract / Godot Dev / QA | V02-SCHOOLDAILY-002 School Day State Contract 数据化 | 完成 | 7 天 school day state、loader / service、合同测试和儿童安全禁词拦截已通过 focused/headless 验证 |
| Narrative / Godot Dev / Memory Palace / QA | V02-SCHOOLDAILY-003 School Gate / Yard 每日可见差异 | 完成 | 校门 / 操场按天变化的真实 `看看` 路径、A-Z 记录和 focused/headless 验证已通过 |
| Home Design / Narrative / Godot Dev / QA | V02-SCHOOLDAILY-004 Home Return / Sunny 日常回访 | 完成 | 7 天 return_home / Sunny 回家反馈按 day_key 保存并通过 focused/headless 验证 |
| QA / PM / Godot Dev | V02-SCHOOLDAILY-005 7 天学校生活 smoke 与截图 | 完成 | 7 天玩家路径 smoke、headless runner、1280x720 / 960x540 代表截图均已通过 |
| PM / Game Design / Narrative / QA | V02-PRODUCTION-001 V02.16 路线、试玩范围和发布门槛规划 | 完成 | 已完成 V02.16 Playable RC Gate 范围、任务拆分、Round83 PM 任务包和下一轮 Ready |
| Narrative / UX / QA / Godot | V02-PRODUCTION-002 孩子端文案、反馈语气和禁用词统一审校 | 完成 | 新增 V02.16 可见文本扫描，覆盖 HUD、NPC、Sunny、Home / School、天气、P1、商店、小屋、相册和设置 |
| UX / Godot / QA | V02-PRODUCTION-003 核心操作动线抛光 | 完成 | `看看`、小镇、背包、商店、小屋、相册、设置均通过真实可见入口和关闭路径验证 |
| Art Direction / UI / QA / Godot | V02-PRODUCTION-004 关键美术 / UI 截图复核 | 完成 | 已导出 Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings 双视口截图；继续区分 `production` 与 `approved` |
| QA / PM / Godot | V02-PRODUCTION-005 试玩版总 smoke、双视口截图和阶段收口 | 完成 | 总 smoke 注册进 headless runner，双视口截图与阶段验收记录已落地 |
| PM / Map / Memory Palace / QA | V02-WORLDMAP-001 V02.17 路线、地图布局范围和 Ready 规划 | 完成 | 已完成 V02.17 世界地图运行时落地路线、任务拆分、Round85 PM 任务包和下一轮 Ready |
| Map / UX / Memory Palace / QA | V02-WORLDMAP-002 26 Anchor 地图坐标与分层可达蓝图 | 完成 | 26 anchor 运行时坐标 / 分层 / 截图口径已写入 Round86 记录并落到 `world_map.memory_anchors` |
| Godot Dev / Map / Narrative / QA | V02-WORLDMAP-003 P0 Home / School 中心路线运行时地图接入 | 完成 | A/C/D/W/E/G/K/N/R/Y 均可通过真实 `看看` 或 Home / School event 落账 |
| Godot Dev / Narrative / Art Direction / QA | V02-WORLDMAP-004 First / Second Ring Anchor 预览与 P1 可见入口 | 完成 | B/F/H/I/J/O/T/L/M/P/Q/S/U/V 具备可见预览 / P1 入口，不阻断 P0 |
| QA / PM / Godot | V02-WORLDMAP-005 26 Anchor 合同、smoke 与双视口截图收口 | 完成 | focused V02.17、全量 headless runner、Godot 启动通过；截图口径记录完成 |
| PM / Map / Art Direction / QA | V02-MAPREAD-001 V02.18 路线、审计范围和 Ready 规划 | 完成 | 已完成 V02.18 地图可读性抛光路线、任务拆分、Round87 PM 任务包和下一轮 Ready |
| QA / Map / UX / Art Direction | V02-MAPREAD-002 26 Anchor 可读性审计与截图基线 | 完成 | 26 anchor 审计、截图组基线、徽章 / 物件 / 热点问题清单已进入 Round88 验收记录和 focused test |
| Map / Art Direction / Godot / QA | V02-MAPREAD-003 地图视觉层级与道路引导抛光 | 完成 | 新增 MapReadabilityLayer、Home / School / Town / Far Edge 区域底纹与短路牌，focused/headless 验证通过 |
| Godot / UX / Narrative / QA | V02-MAPREAD-004 Anchor 徽章、热点优先级和反馈短句抛光 | 完成 | 字母徽章尺寸 / 对比增强，anchor 元数据与真实 `看看` 路径回归通过 |
| QA / PM / Godot | V02-MAPREAD-005 地图探索 smoke、相册复核与双视口截图收口 | 完成 | `tests/test_v0218_map_readability.gd`、V02.17 回归、全量 headless runner 和 Godot 启动均通过；截图口径写入 Round88 记录 |
| PM / Art Direction / Map / QA | V02-ARTPASS-001 V02.19 路线、资产范围和 Ready 规划 | 完成 | 已完成 V02.19 production art pass 路线、任务拆分、Round89 PM 任务包和下一轮 Ready |
| Art Direction / Asset / Tech Art / QA | V02-ARTPASS-002 实际地图与 P0 资产清单 / 接入合同审计 | 完成 | Home 居中运行时地图、验收合同、资产接入审计和 1280-only 后续验收口径均已落地 |
| Art Direction / UI / Map / QA | V02-ARTPASS-003 视觉方向确认包 | 完成 | Round92 已产出三张 1280x720 方向样张、风格规则、禁用方向和后续生产门槛 |
| Map / Asset / Godot / QA | V02-ARTPASS-004 P0 世界地图底图与区域块替换 | 完成 | Round93 已接入世界地图底图、9 个区域块、place marker body 和 `anchor_assets` 合同，focused/full headless 验证通过 |
| Asset / Memory Palace / Godot / QA | V02-ARTPASS-005 P0 场景与 26 Anchor 物件替换 | 完成 | Round94 已接入 26 anchor 生活物件 production 资产，focused/full headless 验证通过 |
| Character Art / UI / Godot / QA | V02-ARTPASS-006 角色 / 宠物 / UI 资产替换与截图收口 | 完成 | Round95 已按 Round92 样张重生成并接入地图底图、26 anchor 和 glass UI 皮肤；1280x720 runtime 截图收口，旧 SVG 资产不再代表正式美术方向 |
| UX / UI / Godot / QA | V02-ARTPASS-007 全屏构图与 UI 风格返修 | 完成 | Round96 已将 runtime map 逻辑网格缩放铺满 1280x720，移除外层安全区边距，旧路格降为弱引导，常驻 HUD/footer 改为轻玻璃 overlay，底栏按钮与背包图标比例统一；最终 1280 proof 已导出 |
| Art Direction / Asset / Godot / QA | V02-ARTPASS-008 Round92 样张风格剩余 runtime 素材补齐 | 完成 | 27 个仍在 `ThemeProfile` 使用的 places、UI icons、Sunny、家具和角色 PNG 已由外部生成脚本覆盖；`asset_acceptance` 标为 `production`，不改 gameplay、地图坐标、A-Z anchor 或 logical asset ID |
| Art Direction / Asset / Godot / QA | V02-ARTPASS-009 资源 branch Round92 样张风格漏项补齐 | 完成 | `place.resource.branch` 已外部生成并覆盖 `assets/art/resources/branch.png`；`asset_acceptance` 标为 `production`，不改资源采集、Bear Corner story binding 或 logical asset ID |
| Art Direction / QA / Godot | V02-ARTPASS-010 运行时视觉验收与发布候选整理 | 完成 | Round99 已导出 1280x720 runtime proof，完成旧辅助层降噪、Album overlay 穿层修复、focused/headless 验证和发布候选记录 |
| PM / QA / Art Direction / UX / Godot | V02-PLAYGATE-001 V02.20 可居住小镇重建路线、任务队列和首批纵切 | 完成 | Round100 已明确 V02.19 收口为 1280 art baseline 而非 product complete；V02.20 PLAYGATE-001..009 队列、Round100 PM 任务包、连续行走、局部镜头、上下文 `看看` 提示、HUD / anchor 降噪和 `tests/test_v0220_playgate_controls.gd` 已落地 |
| QA / UX / Art Direction | V02-PLAYGATE-002 首屏可居住小镇 QA 审计与缺口清单 | 完成 | Round101 已完成首屏审计与缺口分级；不改 runtime、tests、assets 或 data |
| UX / Godot / QA | V02-PLAYGATE-003 启动到 5 分钟自由生活 playgate smoke 规格 | 完成 | Round101 已固定真实入口 smoke 规格；后续由 V02-LIVEGATE-004 实现测试 |
| Map / UX / Art Direction / QA | V02-PLAYGATE-004 居民、资源、家具和 anchor 空间分层返修方案 | 完成 | Round101 已固定空间分层和热点优先级返修规则 |
| UI / UX / QA | V02-PLAYGATE-005 HUD / 底栏 / 弹层 / 相册可读可触摸返修方案 | 完成 | Round101 已固定 1280 UI 可读可触返修规则；960x540 保留到专项适配 |
| Narrative / Child Safety / QA | V02-PLAYGATE-006 孩子端文本和生活反馈 playgate 审校 | 完成 | Round101 文本审校通过；后续继续弱化 Letter Snake / 格子术语 |
| QA / Godot | V02-PLAYGATE-007 V02.8-V02.19 旧玩家路径回归矩阵 | 完成 | Round101 已完成旧路径保留 / 退化 / 待返修矩阵 |
| Art Direction / PM / QA | V02-PLAYGATE-008 1280 release-candidate 截图包和 approved 判定 | 完成 | Round101 已完成 1280 判定；Home、School Gate、School Yard 仍 needs_fix |
| PM / QA | V02-PLAYGATE-009 V02.20 playgate 收口与下一阶段决策 | 完成 | Round101 决定下一阶段继续 V02.21 居住感返修实现 |
| Map / UX / Godot / QA | V02-LIVEGATE-001 空间分层与热点优先级返修 | 完成 | Round102 已完成；不改 A-Z ID / route_order，目标优先级稳定规则、focused/headless 验证通过 |
| Home Design / Godot / UI / QA | V02-LIVEGATE-002 Home 居住感和直接家具操作返修 | 完成 | Round103 已完成；Home 生活细节、家具可见操作、Sunny 反馈和保存重载通过 |
| Map / Art Direction / QA | V02-LIVEGATE-003 Shop / School line 到达感与局部 proof | 完成 | Round104 已完成；Shop / School Gate / School Yard 到达反馈和 focused 回归通过 |
| QA / Godot | V02-LIVEGATE-004 3-5 分钟自由生活 smoke 实现 | 完成 | Round105 已完成；真实入口覆盖启动、移动、看看、NPC、资源、商店、小屋、Sunny、相册和设置 |
| PM / Art Direction / QA | V02-LIVEGATE-005 1280 RC 截图包与二次 approved 判定 | 完成 | Round106 已完成；Album 为 V02.21 playgate approved，Town / Home / Shop / School Gate / School Yard / Settings 保留 needs_fix |
| PM / Tech Lead / QA | V02-HIDDENGRID-001 V02.22 路线、架构边界和任务包 | 完成 | Round107 已完成规划；隐藏网格生活小镇与 scenes 组件化合并为 V02.22，Round107 任务包落地 |
| Godot / Map / QA | V02-HIDDENGRID-002 TownStage scene 抽离 | 完成 | Round108 已完成；`TownStage` scene 管理地图显示、输入、节点生成和 player marker，旧路径回归通过 |
| Godot / UX / QA | V02-HIDDENGRID-003 Actor / Interactable scene 抽离 | 完成 | Round109 已完成；Player / NPC / Resource / Anchor / Place hotspot 已 prefab 化，focused/headless 验证通过 |
| UI / Godot / QA | V02-HIDDENGRID-004 UI scenes 抽离 | 完成 | Round110 已完成；TownHUD / TownFooter scene 化，panel 可见路径回归通过 |
| Game Design / Godot / QA | V02-HIDDENGRID-005 户外装饰、资源 2.0 与 NPC routine 隐藏网格纵切 | 完成 | Round111 已完成；户外摆放、资源 2.0 摘要、NPC routine fallback 和旧路径回归通过 |
| QA / PM / Art Direction | V02-HIDDENGRID-006 3-5 分钟回归、1280 proof 和阶段收口 | 完成 | Round112 已完成；final smoke、headless runner、Godot 启动和 1280 proof 通过；V02.22 阶段收口但不标 product complete |
| Godot / Map / UI / QA | V02-HIDDENGRID-007 Scene-native map + UI panel refactor | 完成 | Round113 已完成；地图 authoring scene、TownStage runtime layers、Home / Shop / Backpack / Album / Settings panel 均可在 Godot 编辑器微调，runtime JSON、旧入口和 A-Z 合同保持兼容 |
| PM / Art Direction / QA | V02-EXPAPPROVAL-001 V02.23 体验批准线 PM 任务包与判定矩阵 | 完成 | Round114 已完成；只做 docs / todo / PM 任务包，固定批准事实、截图清单、禁改范围和下一项 Ready |
| Map / UX / Art Direction / QA / Godot | V02-EXPAPPROVAL-002 Town Plaza 首屏生活密度与 anchor 降噪返修 | 完成 | Round115 已完成局部返修；Round119 同轮 RC 判定 Town Plaza / World Map approved |
| Home Design / UI / QA / Godot | V02-EXPAPPROVAL-003 Home 居住密度与小屋视觉批准返修 | 完成 | Round116 已完成局部返修；Round119 同轮 RC 判定 Home approved |
| UI / UX / QA / Godot | V02-EXPAPPROVAL-004 Shop / Settings glass UI 可读可触批准返修 | 完成 | Round117 已完成局部返修；Round119 同轮 RC 判定 Shop / Settings approved |
| Map / Narrative / Art Direction / QA / Godot | V02-EXPAPPROVAL-005 School Gate / School Yard 生活地点化与噪声返修 | 完成 | Round118 已完成局部返修；Round119 同轮 RC 判定 School Gate / School Yard approved |
| QA / PM / Art Direction | V02-EXPAPPROVAL-006 1280 RC 截图包、真实入口 smoke 与逐项 approved 判定 | 完成 | Round119 已完成；同轮 1280 proof + PM / Art Direction 逐项判定，Album 回归保持 approved，六个返修视图逐项升级 approved |
| PM / Home Design / Map / QA | V02-HOMEPLAZA-001 V02.24 PM 路线与禁改边界 | 完成 | Round120 已完成；V02.24 路线、禁改边界和任务拆分已写入 PM 任务包 |
| Home Design / UI / Godot / QA | V02-HOMEPLAZA-002 HomeRoom 居住感加固 | 完成 | Round121 已完成；默认生活角加固、Sunny 反馈、家具状态和保存边界验证通过 |
| Map / Game Design / Godot / QA | V02-HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则 | 完成 | Round122 已完成；Plaza stay points、allowed place / footprint / 禁覆盖规则验证通过 |
| NPC / Map / Godot / QA | V02-HOMEPLAZA-004 NPC routine 与广场到达感 | 完成 | Round123 已完成；arrival safety、plaza feedback 和 P0 prompt 回归通过 |
| QA / PM / Art Direction | V02-HOMEPLAZA-005 回归、截图与收口 | 完成 | Round124 已完成；living contract、outdoor decor rules、NPC routine safety、旧路径和 1280 proof 通过 |
| Tooling / QA | V02-MAPAUTH-001 错误列表与验证按钮 | 完成 | Round125 已完成；错误可见可复核，验证不写回文件 |
| Tooling / Data Contract / QA | V02-MAPAUTH-002 安全写回 JSON 服务 | 完成 | Round126 已完成；合法才写、非法不写、失败不毁文件 |
| Tooling / Map / QA | V02-MAPAUTH-003 Place marker 新增 / 删除最小闭环 | 完成 | Round127 已完成；runtime 仍读 JSON |
| Memory Palace / Tooling / QA | V02-MAPAUTH-004 A-Z anchor 删除保护与编辑限制 | 完成 | Round128 已完成；26 A-Z 不退化 |
| Map / Tooling / QA | V02-MAPAUTH-005 Place 移动联动策略 | 完成 | Round129 已完成；移动联动 position / occupied / interaction / collision 并经验证后提交候选 |
| QA / PM | V02-MAPAUTH-006 回归与 runner 集成 | 完成 | Round130 已完成；authoring export / write-back / A-Z runtime / map readability / full runner 通过 |
| NPC / Narrative / QA | V02-CONTENTBATCH-001 NPC routine 小批量 | 完成 | Round131 已完成；7 天 routine 轻变化、fallback 和 full runner 通过 |
| Economy / Map / QA | V02-CONTENTBATCH-002 资源刷新点小批量 | 完成 | Round132 已完成；4 个资源点、温和反馈、每日软刷新和 full runner 通过 |
| Memory Palace / Narrative / QA | V02-CONTENTBATCH-003 A-Z 生活物件回访 | 完成 | Round133 已完成；6 条回访、唯一 core_anchor_id 和 full runner 通过 |
| Narrative / QA / Godot | V02-CONTENTBATCH-004 Shop front / School Yard 小事件 smoke | 完成 | Round134 已完成；2 个看一眼事件来自真实入口，不课程化，full runner 通过 |
| PM / Tooling / QA | V02-MAPEDITOR-001 PM 路线、禁改边界、任务包与 ledger 同步 | 完成 | Round135 已同步 V02.27 Map Editor 完整化队列、分文件保存边界和验收矩阵 |
| Tooling / UI / QA | V02-MAPEDITOR-002 图层开关、选择态、Inspector 基础 | 完成 | 场景内工具，不做 EditorPlugin，不进入孩子端 runtime |
| Tooling / Map / QA | V02-MAPEDITOR-003 Place 拖动、属性编辑、Save Map | 完成 | 保存前强制 Validate，写 map 目标并备份 |
| Tooling / Map / QA | V02-MAPEDITOR-004 Road / Collision / Interaction 绘制与地图保存验证 | 完成 | 单 cell 画笔 / 橡皮，不覆盖 protected cells |
| Tooling / Economy / QA | V02-MAPEDITOR-005 Resource marker 编辑与 resource_points 分文件保存 | 完成 | item_id 必须来自 `life_items.json`，资源点不覆盖核心目标 |
| Tooling / NPC / QA | V02-MAPEDITOR-006 NPC routine day selector、marker 编辑与 npc_routines 分文件保存 | 完成 | routine 到达点必须通过 arrival safety |
| Tooling / Memory Palace / QA | V02-MAPEDITOR-007 A-Z anchor 迁移模式、保护验证、全量回归收口 | 完成 | 只允许专门模式移动位置，不改稳定 ID / letter / route_order / core_word |
| Tooling / UX / QA | V02-MAPEDITOR-008 Map Editor 可用性降噪 | 完成 | 固定编辑器打开时的顶部/右侧工作区、缩短 marker 标签、降低面板遮挡；不改保存合同、不进孩子端 runtime |
| Tooling / UX / QA | V02-MAPEDITOR-009 Map Editor 视觉布局二次整理 | 完成 | 左侧分组栏、固定高度侧栏、15px cell 地图画布和 panel text clip 通过 focused/full 回归；不改保存合同、不进孩子端 runtime |
| Tooling / UX / QA | V02-MAPEDITOR-010 Map Editor 直接拖拽编辑与字母可见性返修 | 完成 | 已修复鼠标拖拽坐标计算，补 Inspector 字段编辑控件，提高 A-Z 字母 marker 字号/对比/z 顺序；不改保存合同、不进孩子端 runtime |
| PM / Tooling / QA | V02-MAPDOGFOOD-001 PM 路线、禁改边界和任务包 | 完成 | 已固定 V02.28 Map Editor 实战生产验证队列、禁止范围、验收矩阵和下一项 Ready；本轮不改 runtime/data/tests |
| Tooling / Map / QA | V02-MAPDOGFOOD-002 Map Editor 小批量生产实战 | 完成 | Round140 已用场景内编辑器完成 Story Bench / Ribbon Corner、moved ribbon resource 和 Shopkeeper routine；Validate、安全写回、runtime load 通过 |
| QA / UX / Child Safety | V02-MAPDOGFOOD-003 孩子端真实入口复核 | 完成 | 新内容通过真实移动 / `看看` / resource / NPC 路径验证可见可达，不遮挡 A-Z，不出现编辑器术语 |
| Tooling / PM / Content | V02-MAPDOGFOOD-004 内容生产手册与操作边界 | 完成 | Round140 收口记录已写明 Place / resource / NPC routine 生产流程、验证保存、备份清理和 A-Z 锁定字段 |
| QA / PM | V02-MAPDOGFOOD-005 回归、1280 proof 与阶段收口 | 完成 | focused dogfood、V02.27 编辑器回归、full runner、Godot 启动、1280 proof 和 diff 检查通过；阶段收口但不标 product complete |

## 当前正式阶段任务列表：V02.39 Godot 视觉生产体系重建

| 状态 | Task ID | Owner | 交付物 | 验收标准 |
|---|---|---|---|---|
| [x] | V02-VISUALREBUILD-001 | PM / Art Direction / UX / QA | docs 12-15、Round160、`todo.md`、`lessons.md` | V02.38 重解释为 `visual_scaffold`；`V02-STORYBATCH-004/005` 阻塞；下一项 Ready 明确 |
| [ ] | V02-VISUALREBUILD-002 | PM / Art Direction / Tech Art / UX | 1280 target gameplay frame、Godot 可执行视觉合同 | 构图、camera、depth bands、layer order、asset scale、UI safe area、A-Z priority、forbidden remnants 和 proof checklist 明确；达到 `art_target_locked` |
| [ ] | V02-VISUALREBUILD-003 | Tech Lead / Godot / Tooling / QA | Logic Map / Visual Layout 分层方案 | `world_map` 继续保留 cell / collision / interaction / A-Z ID / save 事实；Visual Layout 独立管理 visual anchors / depth / proxy / occlusion / focus state |
| [ ] | V02-VISUALREBUILD-004 | Art Direction / Asset / Tech Art | 首屏统一环境资产包与 composition kit | 资产同相机、同光源、同比例、同透视；logical asset ID 完整；不混入旧 scene fragment |
| [ ] | V02-VISUALREBUILD-005 | Godot / Tech Art / QA | TownStage runtime visual match 纵切 | 1280 runtime screenshot 与 target frame 并排复核达到 `runtime_visual_match`；真实入口不退化 |
| [ ] | V02-VISUALREBUILD-006 | PM / Art Direction / UX / QA | Art-direction gate 与 StoryBatch 解锁判定 | 只有 `runtime_visual_match`、真实入口、A-Z 稳定、儿童安全文本和 PM / Art Direction 通过后，`V02-STORYBATCH-004` 才能转 Ready |

## Round 80 小组推进计划

### 1. PM / Game Design / Narrative / QA 组

- 当前任务：已完成 `V02-SCHOOLDAILY-001 Home / School 日常回访路线与任务拆分`，并将 `V02-SCHOOLDAILY-002` 置为 Ready。
- 输入：V02.14 可玩纵切收口记录、`data/life/homeschool_events.json`、`data/life/today_status.json`、`data/maps/az_world_plan.json`、`data/curriculum/textbook_world_plan.json`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：V02.15 阶段目标、7 天差异维度、正式任务拆分、Round80 PM 任务包、下一轮 Ready、不可改范围和验收标准。
- 验收：下一轮 agent 可直接按 `docs/collaboration/Round80_V02.15_SCHOOLDAILY-001_PM执行任务包.md` 开工；学校生活保持生活化，不出现课程页、作业、测试、背诵、迟到、打卡、分数、远郊硬依赖或隐藏入口验收。

### 2. Data Contract / Godot Dev / QA 组

- 当前任务：已完成 `V02-SCHOOLDAILY-002 School Day State Contract 数据化`。
- 输入：Round80 PM 任务包、`data/life/homeschool_events.json`、`data/life/today_status.json`、`scripts/systems/today_status_service.gd`、`scripts/systems/content_contract_validator.gd`、`tests/test_daily_town_services.gd`、`tests/test_v0214_homeschool_slice.gd`。
- 输出：7 天 school day state 数据、loader / service、focused contract test 和 headless runner 注册。已完成。
- 验收：7 个 `local_day_001` 至 `local_day_007` 均可加载 gate / yard / walk / return 内容；字段绑定地点、anchor、环境词、孩子端温和文本和安全说明；不出现课程、作业、测试、迟到、打卡、分数或家长报告。已通过。

## Round 64 小组推进计划

### 1. PM / Game Design / UX / QA 组

- 当前任务：已建立 V02.10 P1 居民回访扩展路线，并将 `V02-P1RETURN-001` 置为 Ready。
- 输入：`docs/collaboration/Round64_V02.10_P1RETURN-001_PM执行任务包.md`、Round62 P1 入口预收、Round63 V02.9 收口验收、`LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：V02.10 阶段目标、正式任务拆分、第一项 Ready、不可改范围和验收标准。
- 验收：Bookshop / Bus Stop 仍是 P1 支线，不成为 P0 主流程硬依赖；下一轮 agent 可直接按任务包开工。

## Round 65 小组推进计划

### 1. Godot Dev / UX / QA 组

- 当前任务：已完成 `V02-P1RETURN-001` Bookshop / Bus Stop 真实可见入口。
- 输入：`docs/14_内容基线整理与首批内容规划.md` 的 V02.10 入口实现基线、Round62 P1 入口预收、`LESSON-009`、`LESSON-010`。
- 输出：Bookshop 门口、Bear Corner、Bus Stop 站牌、Taxi marker 四个孩子端真实 `看看` 入口，focused test 与 headless runner 注册。已完成。
- 验收：四个入口可从可见 `InteractButton` 触发；反馈温和；P0 商店 / 小屋 / Mina 路径不受影响；不出现阅读测验、赶车压力、陌生人带走、独自远行、倒计时或主线阻断。已通过。

## Round 66 小组推进计划

### 1. Narrative / Godot Dev / QA 组

- 当前任务：已完成 `V02-P1RETURN-002` 故事熊 / 巴士哥哥 P1 轻回访。
- 输入：`docs/14_内容基线整理与首批内容规划.md` 的 `V02-P1RETURN-002` 任务拆分、`V02-P1RETURN-001` 四个真实可见入口、`LESSON-008`、`LESSON-009`。
- 输出：`daily_story_bear_find_bear_corner_001` 与 `daily_bus_helper_taxi_spot_001` 两条看一眼类 P1 支线，focused test 与 headless runner 注册。已完成。
- 验收：两条支线可从真实可见 NPC / `看看` 路径接取、看入口、回 NPC 完成并同日去重；不强制购买、不离开小镇、不要求阅读或赶车。已通过。

## Round 67 小组推进计划

### 1. Memory Palace / UI / QA 组

- 当前任务：已完成 `V02-P1RETURN-003` B Bear / T Taxi 相册与 A-Z 记录。
- 输入：`V02-P1RETURN-001` 四个真实可见入口、`V02-P1RETURN-002` 两条 P1 看一眼类支线、`LESSON-008`、`LESSON-009`。
- 输出：B Bear / T Taxi 入口查看或支线完成后的 card state / 小镇相册记录，focused test 与 headless runner 注册。已完成。
- 验收：记录只表达地点故事、环境词和温和反馈；不显示正确率、等级、课程、背诵、测试或评分；必须从孩子端真实 `看看` 路径证明落账。已通过。

## Round 68 小组推进计划

### 1. QA / PM / Godot Dev 组

- 当前任务：已完成 `V02-P1RETURN-004` P1 回访 smoke 与截图。
- 输入：`V02-P1RETURN-001` 四个真实可见入口、`V02-P1RETURN-002` 两条 P1 轻回访、`V02-P1RETURN-003` B/T 相册记录、`LESSON-009`、`LESSON-010`。
- 输出：P1 支线玩家路径 smoke、headless runner 注册、1280x720 与 960x540 代表截图。已完成。
- 验收：P1 支线可玩且不阻断 P0 主路径；Bookshop / Bus Stop 截图无明显遮挡、工程文案、课程化文案、倒计时或出行压力。已通过。

## Round 69 小组推进计划

### 1. PM / Game Design / Data Contract / QA 组

- 当前任务：已完成 `V02-WEATHER-001` 天气轻事件数据合同与今日状态接入。
- 输入：`docs/14_内容基线整理与首批内容规划.md` 的 P0 天气轻事件规划、V02.9 今日状态合同、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：`data/life/weather_events.json`、`today_status.weather_event_id`、`TodayStatusService` 天气事件 loader、`ContentContractValidator` 合同拦截、focused/headless 验证。已完成。
- 验收：晴天 / 微风 / 雨后 / 小雨 P0 氛围事件均有稳定 ID、P0 优先级、天气标签、今日状态文案和儿童安全说明；不做真实天气联网、限时运营、连续登录、倒计时或节日奖励。已通过。

## Round 70 小组推进计划

### 1. Narrative / Economy / Godot Dev / QA 组

- 当前任务：已完成 `V02-WEATHER-002` NPC 问候与资源 / 商店轻变化。
- 输入：`docs/collaboration/Round70_V02.11_WEATHER-002_PM执行任务包.md`、`data/life/weather_events.json`、`data/life/today_status.json`、`data/life/daily_greetings.json`、`data/items/life_items.json`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：天气事件驱动的 NPC 问候变体、资源天气提示和商店活动角引用，focused/headless 验证。已完成。
- 验收：P0 常驻商品不消失，资源不会因天气减少基础可得性，NPC 文案温和且数据化，不制造限时购买、售罄焦虑、真实天气联网或出行压力。已通过。

## Round 71 小组推进计划

### 1. Memory Palace / UI / Narrative / QA 组

- 当前任务：已完成 `V02-WEATHER-003` A-Z 天气相册线索。
- 输入：`docs/collaboration/Round71_V02.11_WEATHER-003_PM执行任务包.md`、`data/life/weather_events.json`、`data/anchors/new_word_revisit_paths.json`、`data/cards/az_core_cards.json`、`scripts/main.gd`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：S Sun、K Kite、B Bear、U Umbrella 等天气环境线索与相册 / card state 记录，focused/headless 验证。已完成。
- 验收：只记录地点故事、环境词和温和反馈，不做天气打卡、答题、背诵、顺序拜访或等级评价；必须从孩子端真实 `看看` 路径证明落账。已通过。

## Round 72 小组推进计划

### 1. QA / PM / Godot Dev 组

- 当前任务：已完成 `V02-WEATHER-004` 天气纵切 smoke 与双视口截图。
- 输入：`docs/collaboration/Round72_V02.11_WEATHER-004_PM执行任务包.md`、V02-WEATHER-001 至 003 验证结果、`tests/test_v023_memory_palace_world.gd`、`tests/test_v024_content_contracts.gd`、`tests/headless_runner.gd`、`LESSON-009`、`LESSON-010`。
- 输出：多天气 day_key 玩家路径 smoke、headless runner 注册、1280x720 与 960x540 代表截图。已完成。
- 验收：多天气状态可见且 P0 Home / Shop / 小屋 / Mina / 相册 / A-Z 路径不阻断；截图无明显遮挡、工程文案、倒计时、错过或运营压力。已通过。

## Round 73 小组推进计划

### 1. PM / Memory Palace / Map / Curriculum / QA 组

- 当前任务：已完成 `V02-AZWORLD-001 Home / School 中心地图原则与 26 anchor 分布合同`。
- 输入：用户确认的 Home / School 世界中心方向、`data/anchors/az_core_anchors.json`、`docs/14_内容基线整理与首批内容规划.md` 的 26 anchor 故事种子、`LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：`data/maps/az_world_plan.json`、`scripts/data/az_world_plan_contract.gd`、`tests/test_v0212_az_world_plan.gd`、`tests/headless_runner.gd` 注册、路线文档和台账同步。已完成。
- 验收：Home / School 为世界地图中心；26 个 anchor 全量分布；A/C/D/W 覆盖 Home 线，E/G/K/N/R/Y 覆盖 School 线；X/Z 等远郊锚点不成为 P0 主流程硬依赖；未来 0 基础 / 课本挂接只进入内部字段，孩子端不显示课程、单元、测试、背诵或词表。已通过。

## Round 74 小组推进计划

### 1. Map / PM / UX / QA 组

- 当前任务：已完成 `V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划`。
- 输入：`data/maps/az_world_plan.json`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：`docs/collaboration/Round74_V02.12_AZWORLD-002_PM执行任务包.md`、`docs/collaboration/Round74_V02.12_AZWORLD-002区域道路安全规划.md`，以及 `data/maps/az_world_plan.json` 的 `routes` / `safety_boundaries`。已完成。
- 验收：任务包能直接交给 Map / UX / QA worker 执行；远郊预留不成为 P0 主流程硬依赖；不出现独自远行、赶车、倒计时、陌生人带走、课程化地图或测试路线。已通过。

## Round 63 小组推进计划（历史记录）

### 1. QA / PM / Godot Dev 组

- 当前任务：已完成 `V02-WEEKLY-004` 一周回访 smoke 与截图。
- 输入：`docs/collaboration/Round63_V02.9_WEEKLY-004_PM执行任务包.md`、`docs/collaboration/Round61_V02.9_WEEKLY-002_PM执行任务包.md`、`docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md`、`tests/test_v028_daily_life_slice.gd`、`tests/test_daily_town_services.gd`、`LESSON-009`、`LESSON-010`。
- 输出：7 天玩家路径 smoke、`tests/headless_runner.gd` 注册、代表截图证据口径和完成判断。已完成。
- 验收：连续切换 7 个本地 day_key 后仍能从可见入口完成温和日常；P0 商店商品不消失；Bookshop / Bus Stop 未实现时不阻断主流程；截图无明显遮挡或工程文案。已通过。

## Round 62 小组推进计划（历史记录）

### 1. Narrative / UX / QA / Godot 组

- 当前任务：已完成 `V02-WEEKLY-003` P1 居民回访入口预收。
- 输入：`docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md`、V02.9 一周排期、故事熊 / 巴士哥哥 profile、Bookshop / Bus Stop 内容边界、B Bear / T Taxi anchor 故事、`LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：故事熊 / 巴士哥哥的可见入口清单、安全边界、截图点、B Bear / T Taxi 回访绑定和 `V02-WEEKLY-004` smoke 输入。已完成。
- 验收：Bookshop / Bus Stop 不进入主流程硬依赖，不出现陌生人带走、独自远行、赶时间、阅读测验、背诵、评分、倒计时或错过压力。已通过文档边界复核。

### 2. QA / PM 组

- 当前任务：已复核 P1 入口预收可作为下一轮 smoke / 截图输入。
- 输入：`docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md`、`docs/14_内容基线整理与首批内容规划.md`、`LESSON-009`、`LESSON-010`。
- 输出：允许 `V02-WEEKLY-004` 进入 Ready 的 PM 判断。
- 验收：每个入口都有真实可见路径和截图点；截图取证不默认依赖 headless dummy renderer；隐藏按钮或脚本直调不能作为完成依据。已满足。

## Round 61 小组推进计划（历史记录）

### 1. Godot Dev / Economy / QA 组

- 当前任务：已完成 `V02-WEEKLY-002` 每日状态与商店轮换数据化。
- 输入：`docs/collaboration/Round61_V02.9_WEEKLY-002_PM执行任务包.md`、`docs/14_内容基线整理与首批内容规划.md`、`data/life/today_status.json`、`data/items/life_items.json`、`tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`LESSON-008`、`LESSON-009`。
- 输出：7 天 `today_status`、P0/P1/P2 商店轮换数据、`TodayStatusService` / `LifeShopService` 读取接口、内容合同验证和 focused / full runner 测试。
- 验收：7 个本地 day_key 均可加载不同状态 / 轮换；P0 常驻商品不消失；买不起不失败；不要求连续登录。已通过。

### 2. Narrative / UX / QA / Godot 组

- 当前任务：准备进入 `V02-WEEKLY-003` P1 居民回访入口预收。
- 输入：V02.9 一周排期、故事熊 / 巴士哥哥 profile、Bookshop / Bus Stop 内容边界、`LESSON-009`。
- 输出：故事熊 / 巴士哥哥的可见入口清单、安全边界、截图点和后续实现任务包。
- 验收：Bookshop / Bus Stop 不进入主流程硬依赖，不出现陌生人带走、独自远行、赶时间或阅读测验压力。

## Round 60 小组推进计划（历史记录）

### 1. PM / Game Design / Narrative / QA 组

- 当前任务：已完成 `V02-WEEKLY-001` 一周回访内容合同与排期。
- 输入：`docs/collaboration/Round60_V02.9_WEEKLY-001_PM执行任务包.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`。
- 输出：V02.9 阶段路线、`local_day_001` 至 `local_day_007` 排期草案、P0/P1 边界、数据化改动清单和一周 smoke / 截图验收口径。
- 验收：不引入连续登录、倒计时、错过损失、排名、课程、背诵、测试或强制购买；Bookshop / Bus Stop 只作为 P1 入口预收。

### 2. Godot Dev / Economy / QA 组

- 当前任务：准备进入 `V02-WEEKLY-002` 每日状态与商店轮换数据化。
- 输入：`docs/14_内容基线整理与首批内容规划.md` 的 V02.9 一周排期、`data/life/today_status.json`、`data/life/daily_requests.json`、`data/items/life_items.json`、`tests/test_v024_content_contracts.gd`。
- 输出：7 天 `today_status`、商店 P0/P1/P2 轮换数据、focused contract test 和儿童安全文案检查。
- 验收：7 个本地 day_key 均可加载不同状态 / 轮换；P0 常驻商品不消失；买不起不失败；不要求连续登录。

## Round 59 小组推进计划（历史记录）

### 1. QA / PM / Godot Dev 组

- 当前任务：已完成 `V02-DAILYLIFE-005` 5 分钟纵切 smoke 与截图。
- 输入：`docs/collaboration/Round59_V02.8_DAILYLIFE-005_PM执行任务包.md`、`tests/test_life_rpg_scene.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v023_memory_palace_world.gd`、历史 ARTBASE 双视口截图记录。
- 输出：`tests/test_v028_daily_life_slice.gd`、`tests/headless_runner.gd` 中的端到端玩家路径测试，以及历史 ARTBASE 双视口截图结论。
- 验收：玩家从启动开始能完成“找 NPC -> 做小事 -> 得反馈 -> 使用奖励 / 回小屋”的完整路径；截图无明显遮挡、文字溢出、按钮贴边，且不出现工程文案或学习压力。已通过。

### 2. PM 组

- 当前任务：已完成 V02.8 阶段收口判断。
- 输入：`V02-DAILYLIFE-001` 至 `004` 验证结果、Round59 smoke 和截图结果。
- 输出：允许 V02.8 标记完成；下一步可进入下一阶段路线规划，但本轮不扩大 Bookshop / Bus Stop / 更多 NPC / 天气系统范围。
- 验收：所有 V02.8 正式任务完成并有验证证据后，才把本阶段汇合任务写入完成记录。已满足。

## Round 58 小组推进计划（历史记录）

### 1. Memory Palace / Narrative / Godot Dev 组

- 当前任务：已完成 `V02-DAILYLIFE-004` 三个 A-Z 地点回访。
- 输入：`docs/collaboration/Round58_V02.8_DAILYLIFE-004_PM执行任务包.md`、`data/anchors/new_word_revisit_paths.json`、`tests/test_v023_memory_palace_world.gd`、`tests/test_memory_palace_embedding.gd`、`LESSON-005`、`LESSON-009`。
- 输出：`C Clock`、`O Orange`、`S Sun` 的地点故事、短句或相册发现真实入口。
- 验收：三处 anchor 均可从孩子端真实 `看看` 路径触发并写入相册 / 记忆状态；不出现单词测验、课程、背诵要求；anchor 位置和核心编码不变。

### 2. QA / PM 组

- 当前任务：已完成 A-Z 记忆宫殿作为世界结构而非学习测试的验收口径复核。
- 输入：`V02-DAILYLIFE-003` 验证结果、`tests/test_v023_memory_palace_world.gd`、`tests/test_life_rpg_scene.gd`。
- 输出：`V02-DAILYLIFE-004` focused/headless 验证结果、是否允许进入 `V02-DAILYLIFE-005` 的 PM 判断。
- 验收：C/O/S 三处都通过真实入口并保持生活化后，才把 `V02-DAILYLIFE-005` 置为 `[~]`。

## Round 57 小组推进计划（历史记录）

### 1. Godot Dev / Economy / Home Design 组

- 当前任务：已完成 `V02-DAILYLIFE-003` 商店到小屋使用闭环。
- 输入：`docs/collaboration/Round57_V02.8_DAILYLIFE-003_PM执行任务包.md`、`tests/test_playable_ui_operations.gd`、`tests/test_v022_home_room_contract.gd`、`LESSON-009`。
- 输出：看商品 / 购买小物 -> 背包 / HUD 更新 -> 小屋摆放或移动 -> Sunny 反馈的连续孩子端路径。
- 验收：至少 1 件家具从可见商店购买后能在小屋中摆放、移动或收起并持久保存；Sunny 反馈可见、温和、无学习压力。

### 2. QA / PM 组

- 当前任务：已完成 V02.8 商店到小屋闭环验收口径复核。
- 输入：`V02-DAILYLIFE-002` 验证结果、`tests/test_playable_ui_operations.gd`、`tests/test_life_rpg_scene.gd`。
- 输出：`V02-DAILYLIFE-003` focused/headless 验证结果、是否允许进入 `V02-DAILYLIFE-004` 的 PM 判断。
- 验收：商店购买和小屋使用都必须从真实可见入口完成，不能用隐藏 contract 按钮或脚本直调代替。

## Round 56 小组推进计划（历史记录）

### 1. Godot Dev / Game Design / QA 组

- 当前任务：已完成 `V02-DAILYLIFE-002` 三条 P0 轻委托可玩化。
- 输入：`docs/collaboration/Round56_V02.8_DAILYLIFE-002_PM执行任务包.md`、`data/life/daily_requests.json`、`tests/test_life_rpg_scene.gd`、`tests/test_playable_ui_operations.gd`、`LESSON-009`。
- 输出：`daily_mina_branch_walk_001`、`daily_shopkeeper_tiny_home_item_001`、`daily_sunny_room_tidy_001` 的孩子端接取、行动、完成、奖励、同日去重和保存重载路径。
- 验收：三条 P0 委托均通过当前孩子端可见 UI 或 `看看` 路径完成；不依赖隐藏 contract 按钮、脚本直调或纯服务测试；文本保持短、温和、生活化。

### 2. QA / PM 组

- 当前任务：已完成 V02.8 轻委托可玩验收口径复核。
- 输入：`V02-DAILYLIFE-001` 验证结果、`tests/test_life_rpg_scene.gd`、`tests/test_playable_ui_operations.gd`。
- 输出：`V02-DAILYLIFE-002` focused/headless 验证结果、是否允许进入 `V02-DAILYLIFE-003` 的 PM 判断。
- 验收：三条 P0 委托全都可从真实入口完成后，才把 `V02-DAILYLIFE-003` 置为 `[~]`。

## Round 55 小组推进计划（历史记录）

### 1. Godot Dev / Narrative / QA 组

- 当前任务：已完成 `V02-DAILYLIFE-001` 三 NPC 日常入口。
- 输入：`docs/collaboration/Round55_V02.8_DAILYLIFE-001_PM执行任务包.md`、历史 ARTBASE 双视口截图记录、`LESSON-009`。
- 输出：Mina、店长、Sunny 的孩子端可见互动路径、短问候 / 轻委托入口文本、操作级测试覆盖。
- 验收：三 NPC 均可从当前主场景靠近并按 `看看` 触发；不依赖隐藏 contract 按钮、脚本直调或纯服务测试；文本短、生活化、无学习压力。

### 2. QA / PM 组

- 当前任务：已完成 V02.8 玩家路径验收口径复核。
- 输入：`V02-ARTBASE-005` 双视口截图记录、`tests/test_life_rpg_scene.gd`、`tests/test_playable_ui_operations.gd`。
- 输出：`V02-DAILYLIFE-001` focused/headless 验证结果、是否允许进入 `V02-DAILYLIFE-002` 的 PM 判断。
- 验收：孩子端真实路径通过后才把 `V02-DAILYLIFE-002` 置为 `[~]`。

## Round 54 小组推进计划（历史记录）

### 1. PM / Art Direction / QA 组

- 当前任务：完成 `V02-ARTBASE-001` 资产降级审计与首屏目标固定。
- 输入：`docs/10_美术风格与换肤预留.md`、`docs/collaboration/Round52_V02.7发布前体验门槛执行记录.md`、`docs/collaboration/Round51_V02-POLISH-003-004_QA-Asset验收草案.md`。
- 输出：`docs/collaboration/Round54_V02-ARTBASE-001首屏视觉目标与资产降级审计记录.md`、P0/P1 状态结论、`production` / `approved` 门槛说明。
- 验收：缺少 `960x540` 证据的资源不得标 `approved`；Town Plaza 首屏目标明确到 Home / Shop / 主路 / 玩家 / Mina / Sunny 的同屏关系。

### 2. Art Direction / Asset / Godot 组

- 当前任务：以 `V02-ARTBASE-001` 结论为输入，准备 `V02-ARTBASE-002` Town Plaza 主视觉接入。
- 输入：资产降级审计结论、现有 `place.town_plaza.day` 接入记录、Round 52 首屏抽查结论。
- 输出：Town Plaza 主视觉替换优先级、接入路径、首屏构图草案和需要保留的逻辑 asset ID。
- 验收：不新增运行时方向，不硬编码具体素材路径；首屏必须更像生活小镇而不是调试原型。

### 3. Art Direction / Character Asset / QA 组

- 当前任务：基于 `V02-ARTBASE-001` 准备 `V02-ARTBASE-003` 角色与宠物基础套装。
- 输入：`docs/10_美术风格与换肤预留.md` 中玩家 / Mina / Sunny / 店长条目、Round 52 P0 角色接入情况。
- 输出：玩家、Mina、Sunny、店长的同屏比例、脚底锚点和儿童友好边界要求。
- 验收：四个对象可清楚区分、比例自然、无课堂 / 评分 / 战斗感。

### 4. Art Direction / Map / Home Asset 组

- 当前任务：准备 `V02-ARTBASE-004` Home / Shop / 小物件视觉基线。
- 输入：Home / Shop / 小屋 / 树枝 / 花丛 / 宠物碗 / `C Clock` / `O Orange` / `S Sun` 的规划与现有截图点。
- 输出：哪些资源继续保留 `production`，哪些降回 `draft` / `placeholder_plus`，以及三条日常路径所需的最小小物件包。
- 验收：能直接支撑 `V02-DAILYLIFE-001` 到 `003` 的地图路径，不破坏 A-Z 核心位置和故事编码。

### 5. QA / Art Direction / Godot 组

- 当前任务：固定 `V02-ARTBASE-005` 双视口截图门槛。
- 输入：`V02-ARTBASE-001` 审计记录、Round 51/52 截图与布局验收草案。
- 输出：`1280x720`、`960x540` 两套截图记录和 `pass / needs_fix / blocked` 判断口径。
- 验收：至少覆盖首屏、商店入口、小屋入口、小屋操作、三 NPC 互动和至少一个 `C/O/S` 回访点；截图通过前不得启动 V02.8。
- Round 54 已确认：通过 MCP 复核 `/root/Main` 的 `1280x720` 运行时截图，TownHUD、TownFooter、RuntimeMap 与 Town Plaza / Home / Shop 已在真实主场景中出现。
- Round 54 工具链补记：截图辅助脚本与旧截图目录已在清理轮移除；后续视觉取证直接使用当前阶段截图工具或 MCP/非 headless 路径，不再复用旧 capture 脚本。

### 6. Godot Dev / Narrative / QA 组

- 当前任务：保持 `V02-DAILYLIFE-*` 为未开工状态，只预收 V02.8 的孩子端真实入口约束。
- 输入：`docs/14_内容基线整理与首批内容规划.md` 中 V02.8 纵切基线、`LESSON-009`。
- 输出：三 NPC、三条 P0 委托和 `C/O/S` 回访的真实入口清单，等待 `V02-ARTBASE-005` 通过后进入实现。
- 验收：不提前扩 Bookshop / Bus Stop / 更多 NPC / 更多天气；不以隐藏 contract 按钮作为完成依据。

## PM 节奏与验收接口

- 每轮开工：更新“当前状态面板”，并把当轮唯一主任务置为 `[~]`。
- 每轮分派：统一使用 `docs/collaboration/任务交接模板.md`，并要求提交修改文件、交付物、验证方式、风险、待确认问题。
- 每轮验收：先子组自检，再 QA 验证，再由 PM 对照 `todo.md` 的阶段门槛判定 `[x]`、`[~]` 或 `[!]`。
- 每轮收口：同步 `todo.md` 当前状态面板、本轮分工、正式任务列表和完成记录；只有出现已验证问题时才更新 `lessons.md`。
- 可玩验收：隐藏 contract 按钮、脚本直调和纯服务通过不能单独算完成，必须有玩家可见入口证据。
- 美术验收：`production` 仅表示可集成；`approved` 必须附 `1280x720` 与 `960x540` 双视口截图证据。

> Round 54 工作区核对补记：当前未提交实现已经覆盖 Town Plaza、Home、Shop、主路、树枝、玩家、Mina、Sunny、店长、家具与部分 UI 图标的候选接入，且 `scripts/main.gd` check-only、`tests/test_asset_resolver.gd`、`tests/test_life_rpg_scene.gd`、`tests/headless_runner.gd`、`godot --headless --path . --quit` 均已通过；本轮又通过 MCP 复核了 `/root/Main` 的 `1280x720` 运行时截图证据，但 `960x540` 仍因 headless dummy renderer 无法导出窗口纹理而未补齐，因此 `V02-ARTBASE-002`、`003`、`004` 仍保持候选实现状态，`V02-ARTBASE-005` 仍是进入 V02.8 的唯一门槛。

## Round 51 小组推进计划（历史记录）

### 1. Art Direction / Asset 组

- 当前任务：准备 `V02-POLISH-004` 首批正式素材替换验收。
- 输入：`docs/10_美术风格与换肤预留.md`、`docs/14_内容基线整理与首批内容规划.md`、现有主场景截图验收要求。
- 输出：关键占位视觉替换优先级、production / approved 接入记录字段、首屏与核心路径截图验收点。
- 验收：角色、场景、家具、UI 图标和关键 A-Z anchor 的替换清单能映射到逻辑 asset ID，不要求本轮生成素材。

### 2. Map / Asset 组

- 当前任务：支持 `V02-POLISH-002` / `V02-POLISH-004` 的地图截图点。
- 输入：小镇首屏、Home、Shop、Bookshop、Bus Stop、A-Z anchor 路线和资源点清单。
- 输出：关键路径截图应覆盖的地图位置、anchor 可见性、资源点可读性和遮挡风险。
- 验收：截图模板能明确每张图的地点、玩家动作、UI 状态和通过标准。

### 3. Narrative / Asset 组

- 当前任务：为 `V02-POLISH-001` 和 `V02-POLISH-002` 复核孩子端可见文案。
- 输入：NPC 文本规范、轻事件规划、当前 HUD / 弹层 / 设置入口文案。
- 输出：退出、设置、买不起、关闭弹层、截图路径中的儿童安全文案检查点。
- 验收：不出现工程调试、家长报告、学习压力、倒计时、失败惩罚或陌生人社交暗示。

### 4. Home Design / Asset 组

- 当前任务：支撑 `V02-POLISH-002` 小屋截图验收和 `V02-POLISH-003` 家具触控复核。
- 输入：小屋视图、家具摆放 / 旋转 / 收起路径、Sunny 家内反馈。
- 输出：小屋截图清单、家具操作按钮尺寸 / 状态 / 关闭路径检查点。
- 验收：小屋、家具、Sunny 和底栏不互相遮挡；没有新家具时也有可验收的默认路径。

### 5. UI / Asset / UX 组

- 当前任务：推进 `V02-POLISH-001` 退出与设置入口。
- 输入：孩子端底栏精简结果、背包气泡、相册 / 商店 / 小屋覆盖层、移动端安全区约束。
- 输出：PC 调试退出入口、儿童端设置或安全位置入口、移动端不误触规则和文案。
- 验收：PC 可关闭游戏；移动端退出不在主操作误触区；设置入口不暴露工程调试信息。

### 6. Game Design / Narrative 组

- 当前任务：V02.6 策划内容生产线已完成，转为 `V02-POLISH-001` / `V02-POLISH-002` 文案审核支持。
- 验收：NPC、每日委托、商店轮换、A-Z 场景故事和节日天气轻事件规划均已写入 `docs/14`，且不把英语、Letter Snake、测试或打卡重新变成主循环。
- 目标：为发布前门槛提供儿童安全文案、轻事件截图点和相册 / NPC / 商店路径的验收判断。

### 7. UX / QA / Godot 组

- 前置依赖：`V02-PLAYABLE-004`、`V02-ART-001`、`V02-UI-010`。
- 进行中：`V02-POLISH-001`、`V02-POLISH-002`。
- Ready：`V02-POLISH-003`、`V02-POLISH-004`。
- 目标：把退出、截图、移动端布局和正式素材替换门槛变成可执行清单；后续具体 Godot 实现按清单逐项验收。

## 方向纠偏：生活 RPG / 小镇养成 MVP

> 旧的学习闭环、Memory Card、Letter Snake、Voice/AI stub 保留为技术资产和可选系统；A-Z 记忆宫殿保留为世界地图底层编码和潜意识学习方法。后续主线改为小镇生活、NPC 关系、收集、商店和家园装饰，但地图必须持续承载字母锚点。

- [x] **V02-RESET-001 重写产品定位**
  Owner：PM Agent；交付物：`docs/01_产品总纲.md`；验收：明确生活 RPG / 小镇养成为第一目标，英语降级为环境层。
- [x] **V02-RESET-002 重写核心玩法循环**
  Owner：PM / Game Design Agent；交付物：`docs/06_核心玩法循环.md`；验收：主循环为探索、NPC、收集、商店、家园装饰和长期回访。
- [x] **V02-RESET-003 重写开发路线与工作规范**
  Owner：PM Agent；交付物：`docs/12_V02开发路线.md`、`AGENTS.md`、`todo.md`；验收：Ready 队列指向生活 RPG MVP，不再指向学习闭环扩展。
- [x] **V02-RESET-004 明确 A-Z 记忆宫殿地图植入原则**
  Owner：PM / Memory Palace Agent；交付物：`docs/01_产品总纲.md`、`docs/04_A-Z记忆宫殿与记忆卡系统.md`、`docs/05_世界结构与地图编辑架构.md`；验收：每个字母必须有世界锚点，作为潜意识记忆编码植入，不以考试形式显性推进。
- [x] **V02-RESET-005 明确新单词故事必须绑定记忆宫殿编码**
  Owner：PM / Memory Palace / Curriculum Agent；交付物：`docs/04_A-Z记忆宫殿与记忆卡系统.md`、`docs/14_内容基线整理与首批内容规划.md`；验收：新增单词必须有 `letter`、`core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook`、`review_path`。

## 生活 RPG MVP：角色、小镇、NPC、收集与家园

- [x] **V02-LIFE-001 实现玩家角色移动与触屏控制**
  Owner：Godot Dev Agent；依赖：V02-CORE-001、V02-RUNTIME-001；交付物：Player 节点、移动脚本、碰撞和相机跟随；验收：玩家可在 Home/Town Plaza/Shop 间移动，触屏和键盘调试均可用。
- [x] **V02-LIFE-002 调整运行时地图为可探索小镇**
  Owner：Map / Godot Dev Agent；依赖：V02-LIFE-001；交付物：Home、Town Plaza、Shop 的探索布局；验收：地图不是静态信息面板，玩家能在场景中行走和触发热点，首批 A-Z 锚点有固定位置和可感知表现。
- [x] **V02-LIFE-003 接入动物居民固定互动**
  Owner：Narrative / Godot Dev Agent；依赖：V02-AI-001、V02-VOICE-002；交付物：Mina、Shopkeeper、Pet Buddy 的场景互动入口；验收：可对话、可保存一次关系或每日问候状态。
- [x] **V02-LIFE-004 建立资源与背包最小系统**
  Owner：Godot Dev Agent；依赖：V02-CORE-004；交付物：资源点、InventoryService、材料数据；验收：可捡起 `branch` 并保存到背包。
- [x] **V02-LIFE-005 改造商店为家具/生活物品购买**
  Owner：Godot Dev Agent；依赖：V02-LIFE-004、V02-SHOP-001；交付物：家具商品数据和购买流程；验收：可购买 `wooden_chair`，coins 扣减并保存。
- [x] **V02-LIFE-006 实现家园装饰 MVP**
  Owner：Godot Dev / UI Agent；依赖：V02-LIFE-001、V02-LIFE-005；交付物：房间网格、家具摆放/收起、HomeState 保存；验收：购买家具后可在家中摆放，重启后位置保留。
- [x] **V02-LIFE-007 生活 MVP smoke test**
  Owner：QA Agent；依赖：V02-LIFE-001 至 V02-LIFE-006；交付物：headless 或服务级 smoke test；验收：起床、出门、对话、收集、购买、回家摆放、保存全链路通过。
- [x] **V02-LIFE-008 降级学习系统入口**
  Owner：PM / Godot Dev Agent；依赖：V02-LIFE-007；交付物：Memory Album 和 Letter Snake 入口调整说明或实现；验收：孩子端主流程不再被学习任务驱动，Letter Snake 仅作为可选活动。
- [x] **V02-LIFE-009 A-Z 锚点潜意识植入审计**
  Owner：Memory Palace / QA Agent；依赖：V02-LIFE-002；交付物：26 个 anchor 的地图位置、表现物件和路线顺序审计；验收：A-Z 锚点不是 UI 装饰，能在生活地图中形成稳定路径记忆。
- [x] **V02-LIFE-010 新词故事编码数据审计**
  Owner：Curriculum / Memory Palace / QA Agent；依赖：V02-LIFE-009；交付物：首批新词的锚点绑定和故事记忆审计；验收：每个新词都能追溯到字母锚点、地图地点、视觉钩子和生活回访路径。
- [x] **V02-LIFE-011 地图上下文互动层**
  Owner：Godot Dev / UX Agent；依赖：V02-LIFE-008；交付物：统一 `Interact` / `Use` 操作、附近 NPC/资源/商店/家园对象检测、面板调试按钮降级；验收：玩家移动到附近对象后用同一个操作完成对话、收集、购买和摆放，远离对象时返回无目标或距离不足。
- [x] **V02-LIFE-012 解耦地点进入与生活动作**
  Owner：Godot Dev / UX Agent；依赖：V02-LIFE-011；交付物：中性的 place entry 互动结果、独立的商店购买/家园摆放/邻居帮助触发路径；验收：进入 Home、Town Start、Supermarket 不自动发 coins、不自动购买、不自动摆放，生活动作仍可通过显式对象或后续轻委托触发并通过测试。
- [x] **V02-LIFE-013 每日轻委托 MVP**
  Owner：Game Design / Godot Dev / Narrative Agent；依赖：V02-LIFE-003、V02-LIFE-004、V02-LIFE-012；交付物：首个本地每日轻委托数据与服务、Mina 请求 branch 的 NPC 互动、奖励与关系保存；验收：接取、收集、交付、奖励、当日去重和重载保存通过 headless 测试，孩子端不出现学习压力文案，Letter Snake 不作为完成条件。
- [x] **V02-UI-002 主界面生活小镇视觉重做**
  Owner：Godot Dev / UI Agent；依赖：V02-LIFE-013；交付物：`scenes/main.tscn` / `scripts/main.gd` 首屏布局和视觉；验收：启动首屏不再显示 Godot skeleton / Loaded places 等工程占位文案，地图成为主视觉，HUD 展示生活状态、邻居、背包和温和操作，保留统一 Interact、可选相册/小游戏入口，并通过 headless 与生活场景测试。
- [x] **V02-UI-003 动森式小镇首屏 Playfield**
  Owner：Godot Dev / UI Agent；依赖：V02-UI-002；交付物：`scripts/main.gd` 全屏小镇 playfield、轻 HUD、场景化 A-Z 锚点表现、动物居民/玩家视觉符号；验收：首屏不再是左导航+右状态面板，中间地图不是数据调试网格；A-Z 不以裸字母学习标签为主表现；孩子端只看到小镇、居民、背包、相册和温和互动；通过主场景、playable loop、headless 验证。
- [x] **V02-UI-004 Sprite2D 小镇首屏资产化**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-003；交付物：`scripts/main.gd` Node2D/Sprite2D runtime playfield、物件化 A-Z anchors、动物居民视觉、气泡式 HUD、截图验收记录；验收：RuntimeMap 不再是 Control 方块地图，首屏像孩子进入 Sunshine Town 小镇而不是开发者调试面板；结构测试、生活场景测试、playable loop、headless、Godot quit 和 MCP 截图验收通过。
- [x] **V02-UI-005 孩子端中文界面**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-004；交付物：`scripts/main.gd` 主界面中文标题、按钮、提示、状态反馈与测试断言更新；验收：孩子端首屏和生活操作反馈以中文为主，英文仅保留为环境/系统资产名；现有生活循环和 headless 验证通过。
- [x] **V02-UI-006 顶部消息栏与底部按钮栏**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-005；交付物：`scripts/main.gd` 顶部消息状态栏、底部统一按钮栏、无遮挡小镇 playfield；验收：左侧/右侧大面板不再覆盖地图，消息类信息集中顶部一排，操作与导航按钮集中底部一排，生活循环与 headless 验证通过。
- [x] **V02-UI-007 顶部 HUD 单行压缩**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-006；交付物：`scripts/main.gd` 单行顶部 HUD；验收：首屏不再出现标题横幅加状态横幅的双层顶部 UI，阳光小镇标题、开放状态、今日提示和背包摘要集中到一条紧凑 HUD，地图可视面积增加，focused/headless 验证通过。
- [x] **V02-UI-008 底部操作栏精简**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-007；交付物：`scripts/main.gd` 精简底部按钮栏；验收：孩子端底部常驻按钮只保留 `看看`、`小镇`、`小屋`、`背包`，生活循环、购买、喂养、相册和 Letter Snake 快捷按钮不再可见但保留脚本/测试 contract 节点，focused/headless 与 MCP 截图验证通过。
- [x] **V02-UI-009 底部按钮儿童化视觉**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-008；交付物：`scripts/main.gd` 底部按钮色彩、状态和布局优化；验收：底部按钮不再是沉重深绿色方块，主操作与导航有柔和且可区分的 normal/hover/pressed 状态，底栏居中且不横跨大半屏空白，focused/headless 与 MCP 截图验证通过。
- [x] **V02-UI-010 背包气泡内容恢复**
  Owner：Godot Dev / UI / QA Agent；依赖：V02-UI-009；交付物：`scripts/main.gd` 背包按钮交互与轻量背包气泡；验收：点击底部 `背包` 可打开/关闭包含金币、Sunny 点心、树枝、家具、相册和 Letter Snake 入口说明的中文气泡；气泡不覆盖大半地图，状态随存档背包内容刷新，focused/headless 与 MCP 截图验证通过。

## 长期路线：生活小镇从原型到长期可玩

> 目标版本：孩子每天可以回到 Sunshine Town，照顾 Sunny、拜访居民、收集材料、完成轻委托、装饰小屋、解锁小镇角落，并在环境里自然遇见英语词汇和 A-Z 记忆锚点。英语继续作为环境层、收藏层和记忆宫殿编码，不重新变成测试、课程或主线任务。

| 版本 | 主题 | 目标体验 | 完成标志 |
|---|---|---|---|
| V02.1 | 每日小镇 | 每天回来都有居民、资源和今日状态可看 | 多 NPC 每日问候、轻委托、资源刷新和今日状态通过 smoke |
| V02.2 | 我的小屋 | 小屋成为孩子愿意经营和装饰的归属空间 | 独立小屋视图、家具摆放/收起/保存、Sunny 家内反馈通过 |
| V02.3 | 小镇记忆宫殿 | A-Z 锚点成为稳定场景物件和回访路线 | 首批 A-Z 场景物件强化、相册收藏和新词故事回访通过 |
| V02.4 | 内容生产框架 | 后续内容主要写数据而不是改主脚本 | 委托、商品、家具、对白、anchor 内容数据化并有合同测试 |
| V02.5 | 美术素材生产线 | 占位小镇开始替换为可持续生产的角色、场景、家具、UI、图标和音效素材 | 资产目录、命名规范和首批素材清单能映射到 `AssetResolver` 逻辑 ID |
| V02.6 | 策划内容生产线 | NPC、每日委托、商店轮换、节日天气和 A-Z 场景故事可以稳定扩展 | 首批内容包规划满足儿童安全、非压力经济和记忆宫殿绑定规则 |
| V02.7 | 发布前体验与质量门槛 | 可玩路径、退出设置、移动端布局和截图验收成为发布前固定门槛 | 关键路径截图、触控布局、退出设置和正式素材替换验收有明确清单 |

### V02.1 每日小镇：回访、居民和资源

- [x] **V02-DAILY-001 每日问候系统**
  Owner：Narrative / Godot Dev / QA Agent；依赖：V02-LIFE-013；交付物：本地每日问候数据、问候状态保存、NPC 互动接入；验收：Mina、店长、Sunny、故事熊、巴士哥哥每天首次互动有中文问候并写入当日状态，同日重复不重复发奖励；孩子端无学习压力文案。
- [x] **V02-DAILY-002 多 NPC 每日轻委托扩展**
  Owner：Game Design / Narrative / Godot Dev Agent；依赖：V02-DAILY-001、V02-LIFE-004；交付物：至少 3 条新增本地每日轻委托；验收：店长、故事熊、Sunny 至少各有一条轻委托，包含接取、目标、交付、金币/材料/关系奖励、同日去重和保存重载测试。
- [x] **V02-DAILY-003 每日资源刷新**
  Owner：Godot Dev / Map / QA Agent；依赖：V02-LIFE-004；交付物：资源刷新服务和首批资源点数据；验收：树枝、花、石子等资源按本地日期刷新，已收集资源当天不重复出现，跨日刷新通过 headless 测试。
- [x] **V02-DAILY-004 今日状态与轻日历**
  Owner：UX / Godot Dev Agent；依赖：V02-DAILY-001；交付物：顶部 HUD 今日状态、天气/小镇事件本地 stub；验收：HUD 能显示“今天晴天 / 集市日 / Sunny 想玩”等短提示，不遮挡地图，不引入真实时间压力或错过惩罚。
- [x] **V02-DAILY-005 V02.1 每日小镇 smoke**
  Owner：QA Agent；依赖：V02-DAILY-001 至 V02-DAILY-004；交付物：每日小镇端到端 smoke；验收：启动、问候、接委托、收集资源、交付、奖励、背包刷新、同日去重、跨日刷新全链路通过 focused/headless。

### V02.2 我的小屋：家园装饰成为核心留存

- [x] **V02-HOME-001 独立小屋视图**
  Owner：Godot Dev / UI Agent；依赖：V02-LIFE-006；交付物：HomeRoom 场景或主场景小屋模式；验收：进入小屋后看到房间、家具、Sunny 和返回小镇入口，底部操作不覆盖房间。
- [x] **V02-HOME-002 家具摆放/旋转/收起交互**
  Owner：Godot Dev / UX Agent；依赖：V02-HOME-001；交付物：触屏友好的家具操作；验收：家具可选择、摆放、旋转、收起，非法位置有温和反馈，保存后重进位置不丢失。
- [x] **V02-HOME-003 家具与宠物用品商品扩展**
  Owner：Game Design / Godot Dev Agent；依赖：V02-LIFE-005、V02-HOME-001；交付物：首批家具和宠物用品数据；验收：至少包含小桌、地毯、花盆、宠物碗、小床、墙饰，商店可购买并进入背包或家园库存。
- [x] **V02-HOME-004 Sunny 家内反馈**
  Owner：Narrative / Godot Dev Agent；依赖：V02-HOME-001、V02-HOME-003；交付物：Sunny 对家具和小屋状态的本地反馈；验收：Sunny 会对宠物碗、小床等物件给出短反馈，提升温暖感但不显示考试式评分。
- [x] **V02-HOME-005 V02.2 小屋 smoke**
  Owner：QA Agent；依赖：V02-HOME-001 至 V02-HOME-004；交付物：小屋装饰端到端测试；验收：购买、进入小屋、摆放、旋转、收起、Sunny 反馈、保存重载全链路通过。

### V02.3 小镇记忆宫殿：A-Z 场景化与收藏回访

- [x] **V02-AZ-WORLD-001 首批 A-Z 场景物件强化**
  Owner：Memory Palace / Map / Godot Dev Agent；依赖：V02-LIFE-009；交付物：A/B/C/D/K/O/S/T/W 的场景物件表现升级；验收：Apple Tree、Bear Corner、Clock Tower、Dog House、Kite Hill、Orange Stand、Sun Plaza、Taxi Stop、Watch Sign 等在地图中可感知，不以裸字母标签为主表现。
- [x] **V02-AZ-WORLD-002 Anchor 互动与相册收藏**
  Owner：Godot Dev / Curriculum Agent；依赖：V02-AZ-WORLD-001、V02-CARD-001；交付物：anchor 轻互动和相册记录；验收：孩子靠近场景物件可“看看”，相册记录见过/听过/收藏状态，界面表达为小镇发现而不是单词测验。
- [x] **V02-AZ-WORLD-003 新词故事回访路径**
  Owner：Curriculum / Memory Palace / Narrative Agent；依赖：V02-AZ-WORLD-001；交付物：首批新词回访数据和短故事；验收：每个新增词具备 `letter`、`core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook`、`review_path`，并能从地图地点触发温和回访。
- [x] **V02-AZ-WORLD-004 V02.3 记忆宫殿审计**
  Owner：QA / Memory Palace Agent；依赖：V02-AZ-WORLD-001 至 V02-AZ-WORLD-003；交付物：A-Z 场景化审计和自动化检查；验收：核心 anchor 顺序、场景物件、相册绑定、新词故事绑定全部通过测试。

### V02.4 内容生产框架：让扩展主要写数据

- [x] **V02-CONTENT-001 每日委托数据化合同**
  Owner：Godot Dev / Game Design Agent；依赖：V02-DAILY-002；交付物：daily request schema 和 loader；验收：新增委托无需改 `scripts/main.gd` 主流程即可加载，ID、奖励、同日去重和儿童安全文案有测试。
- [x] **V02-CONTENT-002 NPC 对话数据化合同**
  Owner：Narrative / Godot Dev Agent；依赖：V02-DAILY-001；交付物：NPC greeting/dialogue 数据合同；验收：问候、轻委托对白、关系阶段对白可由数据驱动，默认本地 stub，无网络依赖。
- [x] **V02-CONTENT-003 家具和商品数据化合同**
  Owner：Godot Dev / Economy Agent；依赖：V02-HOME-003；交付物：商品、家具、分类、价格和摆放 footprint 数据合同；验收：商品轮换和家具摆放读取数据，非法价格、重复 ID、缺失稳定 ID 可被测试拦截。
- [x] **V02-CONTENT-004 Anchor 内容包校验增强**
  Owner：Curriculum / Memory Palace / QA Agent；依赖：V02-AZ-WORLD-004、V02-FUTURE-003；交付物：内容包校验规则扩展；验收：内容包不能覆盖核心 A-Z 编码，新增词必须绑定记忆宫殿字段，未通过人工审核不得进入 runtime。
- [x] **V02-CONTENT-005 V02.4 数据化回归**
  Owner：QA Agent；依赖：V02-CONTENT-001 至 V02-CONTENT-004；交付物：内容数据合同和回归测试集；验收：委托、对白、商品、家具、anchor 内容均可通过数据新增并通过 headless runner。

### Round 48 可玩路径修复：入口必须真实可操作

- [x] **V02-PLAYABLE-001 相册孩子端入口修复**
  Owner：PM / UI Agent；依赖：V02-AZ-WORLD-002、V02-UI-010；交付物：可见的相册入口、相册覆盖层、返回小镇路径；验收：孩子端可从可见 UI 打开相册并返回，不依赖隐藏 contract 按钮，相册中文界面通过测试。
- [x] **V02-PLAYABLE-002 商店购买孩子端入口修复**
  Owner：PM / UI / Systems Agent；依赖：V02-HOME-003、V02-CONTENT-003；交付物：靠近商店或店长可打开可见货架，货架按钮可购买家具并刷新背包/HUD；验收：实际 UI 按钮购买成功，金币扣减、物品入背包，买不起时温和反馈。
- [x] **V02-PLAYABLE-003 真实操作烟测补充**
  Owner：PM / QA Agent；依赖：V02-PLAYABLE-001、V02-PLAYABLE-002；交付物：主场景操作级 focused test；验收：测试通过“可见按钮/面板”打开相册、关闭相册、打开商店、点击商品购买，而不是直接调用隐藏脚本方法。
- [x] **V02-PLAYABLE-004 核心生活操作同步检测**
  Owner：PM / QA / UI Agent；依赖：V02-LIFE-011、V02-HOME-002、V02-AZ-WORLD-002；交付物：覆盖 `看看`、背包、小镇/小屋、NPC、资源、anchor、家具摆放/旋转/收起的玩家路径测试；验收：每个已宣称可玩的核心生活动作都有孩子端可见入口，并通过操作级 smoke。

### V02.5 美术素材生产线：从可玩占位走向可持续资产

> 本阶段只建立生产规范和首批素材清单，初期使用单一 Animal Crossing-like cozy town 世界视觉和 Apple-like translucent glass UI，不开启多主题并行生产，不采用绘本 / storybook / picture-book 作为正式生产方向。所有素材必须通过逻辑 asset ID 进入 `ThemeProfile` / `AssetResolver`，玩法脚本不得硬编码具体文件路径。

- [x] **V02-ART-001 美术资产目录与命名规范**
  Owner：Art Direction / Asset / Godot Dev Agent；依赖：V02-CORE-005、V02-UI-004；交付物：资产分类目录、逻辑 asset ID 规则、命名规范、占位/半正式/正式状态定义、`AssetResolver` 映射要求；验收：角色、宠物、场景、A-Z anchor、家具、UI、图标和音效等未来素材均能映射到稳定逻辑 ID，玩法脚本不得新增硬编码素材路径。
- [x] **V02-ART-002 首批小镇场景素材清单**
  Owner：Art Direction / Map / Asset Agent；依赖：V02-ART-001、V02-AZ-WORLD-001；交付物：Home、Town Plaza、Shop、Bookshop、Bus Stop、道路、树、花、资源点等小镇场景素材清单；验收：每个场景物件有用途、逻辑 asset ID、当前状态、优先级、替换目标、建议尺寸/比例和验收截图要求。
- [x] **V02-ART-003 首批角色与宠物素材清单**
  Owner：Art Direction / Narrative / Asset Agent；依赖：V02-ART-001、V02-NPC-001；交付物：玩家、Mina、店长、Sunny、故事熊、巴士哥哥等角色和宠物素材需求；验收：每个角色至少定义站立状态、基础表情/状态、地图显示尺寸、UI 头像需求和儿童友好表现边界。
- [x] **V02-ART-004 家具与家园素材清单**
  Owner：Art Direction / Home Design / Asset Agent；依赖：V02-ART-001、V02-HOME-003；交付物：小桌、地毯、花盆、宠物碗、小床、墙饰等首批家具和家园素材需求；验收：每个家具有 footprint、房间显示尺寸、图标、摆放方向、状态、替换优先级和小屋截图验收点。
- [x] **V02-ART-005 UI 图标与状态素材清单**
  Owner：UI / Art Direction / UX Agent；依赖：V02-ART-001、V02-UI-010；交付物：金币、点心、饥饿、开心、背包、相册、商店、设置/退出等 HUD 与按钮图标清单；验收：HUD 和按钮不再只依赖文字表达，图标有逻辑 ID、目标尺寸、可读性要求、触控状态和 1280x720 截图验收标准。

### V02.6 策划内容生产线：持续扩展日常、居民和记忆故事

> 策划内容继续服务生活 RPG / 小镇养成，英语只作为环境、收藏、NPC 短句、相册和 A-Z 记忆宫殿故事层。不得把 Letter Snake、测试、课程表或单词背诵重新变成主循环条件。

- [x] **V02-DESIGN-001 NPC 内容生产规范**
  Owner：Game Design / Narrative / Child Safety Agent；依赖：V02-CONTENT-002、V02-PLAYABLE-004；交付物：NPC 问候、关系阶段、轻委托对白、反馈语气和儿童安全文本边界规范；验收：新增 NPC 文本可直接进入数据合同验证，不包含失败惩罚、学习压力、开放陌生人社交或家长报告口吻。
- [x] **V02-DESIGN-002 每日轻委托内容包规划**
  Owner：Game Design / Narrative Agent；依赖：V02-CONTENT-001、V02-DAILY-002；交付物：首批 10-15 条每日轻委托规划；验收：每条委托有稳定 ID、NPC、目标、奖励、关系反馈、重复规则、儿童安全文案和可见操作入口，不依赖 Letter Snake 完成。
- [x] **V02-DESIGN-003 商店与家具轮换策划**
  Owner：Game Design / Economy / Home Design Agent；依赖：V02-CONTENT-003、V02-HOME-003；交付物：商品分类、价格区间、轮换节奏、金币来源和非惩罚经济原则；验收：金币用途清晰，买不起时只有温和反馈，不形成打卡压力、损失惩罚或强消耗循环。
- [x] **V02-DESIGN-004 A-Z 场景故事扩展规划**
  Owner：Memory Palace / Narrative / Curriculum Agent；依赖：V02-AZ-WORLD-003、V02-CONTENT-004；交付物：26 个 anchor 的场景故事、视觉钩子、回访路径和新词扩展规划；验收：首批 9 个达到可制作级，剩余 17 个达到规划级；所有新增词继续绑定 `letter`、`core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook`、`review_path`。
- [x] **V02-DESIGN-005 节日与天气轻事件规划**
  Owner：Game Design / Narrative / UX Agent；依赖：V02-DAILY-004、V02-CONTENT-001；交付物：晴天、雨天、集市日、儿童节等轻事件规划；验收：事件不惩罚缺席，不制造连续登录压力，能作为小镇氛围、NPC 问候、资源刷新或轻装饰变化进入后续数据生产。

### V02.7 发布前体验与质量门槛：把“能玩”推进到“可验收”

> 本阶段将玩家路径、截图、移动端布局和首批正式素材替换变成发布前门槛。文档规划完成后，具体实现和截图验收按任务逐项进入 Ready。

- [x] **V02-POLISH-001 退出与设置入口**
  Owner：UX / Godot Dev / QA Agent；依赖：V02-PLAYABLE-004；交付物：开发/桌面可见退出入口、儿童端设置或安全位置入口、移动端不误触规则；验收：PC 调试可关闭游戏，移动端不会把退出放在主操作误触区，孩子端文案安全且不暴露工程调试信息。
- [x] **V02-POLISH-002 玩家路径截图验收**
  Owner：QA / UI / Art Direction Agent；依赖：V02-PLAYABLE-004、V02-ART-001；交付物：关键路径截图清单和截图验收记录模板；验收：小镇、背包、商店、小屋、相册、anchor 互动等路径都有 1280x720 截图要求，每次 UI/美术大改后必须截图确认。
- [x] **V02-POLISH-003 移动端触控与布局复核**
  Owner：QA / UX / Godot Dev Agent；依赖：V02-UI-010、V02-PLAYABLE-004；交付物：1280x720 和较小横屏视口布局检查表；验收：按钮尺寸、遮挡、安全区、文字溢出、底栏/顶部 HUD 和弹层关闭路径均可操作。
- [x] **V02-POLISH-004 首批正式素材替换验收**
  Owner：Art Direction / Asset / QA Agent；依赖：V02-ART-002、V02-ART-003、V02-ART-004、V02-ART-005；交付物：关键占位视觉替换清单、正式或半正式素材接入记录和截图验收；验收：首屏不再像程序化占位原型，角色、场景、家具、UI 图标和关键 A-Z anchor 至少完成首批正式或半正式替换，并通过截图验收。
- [x] **V02-POLISH-005 P1 素材替换与 960x540 补验（并入 V02.7A 重评）**
  Owner：Art Direction / Asset / QA / Godot Agent；依赖：V02-POLISH-003、V02-POLISH-004；交付物：原计划为运行时可见 P1 角色、家具和 UI 图标素材接入记录、960x540 较小横屏截图验收；现结论：不再作为独立 Ready，已并入 `V02.7A 美术基线重建`，由 `V02-ARTBASE-*` 统一重评素材质量、production / approved 口径和双视口截图证据。

### V02.7A 美术基线重建：先让 Sunshine Town 第一眼可信

> 本阶段承认现有素材链路已打通，但当前资产仍偏占位。目标不是继续堆素材 ID，而是先重建 Town Plaza 首屏、基础角色、Home / Shop 和关键小物件视觉基线。`production` 只表示可集成，`approved` 必须有 PM / Art Direction 确认和 1280x720、960x540 截图证据。

- [x] **V02-ARTBASE-001 首屏视觉目标与资产降级审计**
  Owner：PM / Art Direction / QA Agent；依赖：V02-POLISH-004；交付物：当前 P0/P1 素材质量审计、哪些降回 `draft` / `placeholder_plus`、Sunshine Town 首屏参考标准；验收：文档不再把缺少截图证据的素材称为 `approved`，并明确 `production` 只表示可集成、不表示最终美术质量。完成记录：`docs/collaboration/Round54_V02-ARTBASE-001首屏视觉目标与资产降级审计记录.md` 已落地。
- [x] **V02-ARTBASE-002 Town Plaza 主视觉生成与接入**
  Owner：Art Direction / Asset / Godot Agent；依赖：V02-ARTBASE-001；交付物：一张可用 Town Plaza 主场景底图或可拼接背景，接入 `place.town_plaza.day`；验收：1280x720 首屏第一眼像生活小镇，有 Home / Shop / 道路 / 停留空间，不像调试网格或程序占位。完成记录：`place.town_plaza.day` 已通过 `AssetResolver` 接入并在 `shot_artbase005_town_1280.png`、`shot_artbase005_town_960.png` 中复核。
- [x] **V02-ARTBASE-003 角色与宠物基础套装**
  Owner：Art Direction / Character Asset / QA Agent；依赖：V02-ARTBASE-001；交付物：玩家、Mina、Sunny、店长站立图，同一画风与锚点尺寸；验收：同屏比例自然，角色可区分，儿童友好，无课堂 / 评分 / 战斗感。完成记录：玩家、Mina、Sunny、店长在首屏、商店、小屋和三 NPC 互动截图中通过双视口复核。
- [x] **V02-ARTBASE-004 Home / Shop / 小物件视觉基线**
  Owner：Art Direction / Map / Home Asset Agent；依赖：V02-ARTBASE-001、V02-ARTBASE-002；交付物：Home、Shop、树枝、花丛、宠物碗、Clock / Orange / Sun 相关物件；验收：地点和物件能支撑 V02.8 的三条日常路径，并通过逻辑 asset ID 接入或明确待接入记录。完成记录：Home、Shop、宠物碗、Sunny 小床和 `C/O/S` 回访点已进入 `V02-ARTBASE-005` 双视口截图证据。
- [x] **V02-ARTBASE-005 双视口截图验收**
  Owner：QA / Art Direction / Godot Agent；依赖：V02-ARTBASE-002、V02-ARTBASE-003、V02-ARTBASE-004；交付物：1280x720 与 960x540 截图记录；验收：无明显遮挡、文字溢出、按钮贴边；截图能作为进入 V02.8 的门槛。完成记录：旧双视口截图记录与截图目录已清理；当前运行时素材接入由 `AssetResolver` 验证、Round95/96 视觉证据和 headless 回归维持。

### V02.8 每日小镇生活纵切：让孩子完成 5 分钟日常

> 本阶段必须在 V02.7A 双视口截图通过后进入实现。范围固定为 Mina、店长、Sunny 三个角色和 C Clock / O Orange / S Sun 三个 A-Z 地点回访；Bookshop / Bus Stop 保留为后续 P1 扩展。

- [x] **V02-DAILYLIFE-001 三 NPC 日常入口**
  Owner：Godot Dev / Narrative / QA Agent；依赖：V02-ARTBASE-005、V02-PLAYABLE-004；交付物：Mina、店长、Sunny 从孩子端可见入口触发问候和轻委托；验收：不依赖隐藏按钮，对话短、生活化、无学习压力。完成记录：三 NPC 均可从主场景靠近并用 `看看` 触发，互动写入关系 / 最近事件 / 当日状态，`test_life_rpg_scene` 与 `test_playable_ui_operations` 已覆盖真实可见路径。
- [x] **V02-DAILYLIFE-002 三条 P0 轻委托可玩化**
  Owner：Godot Dev / Game Design / QA Agent；依赖：V02-DAILYLIFE-001、V02-CONTENT-001；交付物：`daily_mina_branch_walk_001`、`daily_shopkeeper_tiny_home_item_001`、`daily_sunny_room_tidy_001` 可从 UI 完成；验收：接取、行动、完成、奖励、同日去重、保存重载通过。完成记录：沿用现有 ID `daily_mina_branch_001`、`daily_shopkeeper_flower_001`、`daily_sunny_flower_001` 作为三条 P0 委托映射；主场景测试已覆盖真实 `看看` 接取、资源行动、完成反馈、奖励、同日去重和保存重载。
- [x] **V02-DAILYLIFE-003 商店到小屋使用闭环**
  Owner：Godot Dev / Economy / Home Design Agent；依赖：V02-DAILYLIFE-002、V02-HOME-005；交付物：看商品 / 购买小物 -> 背包 / HUD 更新 -> 小屋摆放或移动 -> Sunny 反馈；验收：至少 1 件家具购买后可摆放并持久保存。完成记录：商店可见入口可购买木椅并刷新背包；小屋可见入口可摆放、旋转、挪动、收起家具；Sunny 小屋反馈可见，移动后坐标和背包变化可从保存状态重载验证。
- [x] **V02-DAILYLIFE-004 三个 A-Z 地点回访**
  Owner：Memory Palace / Narrative / Godot Dev Agent；依赖：V02-DAILYLIFE-001、V02-AZ-WORLD-004；交付物：`C Clock`、`O Orange`、`S Sun` 以地点故事、短句或相册发现参与日常；验收：不出现单词测验、课程、背诵要求；anchor 位置和核心编码不变。完成记录：新增 `C Clock` 日常回访故事；C/O/S 三处均已通过主场景移动到 anchor 附近并按 `看看` 触发，写入 card state / 相册状态，HUD 显示生活化地点故事且无测验文案。
- [x] **V02-DAILYLIFE-005 5 分钟纵切 smoke 与截图**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-DAILYLIFE-001、V02-DAILYLIFE-002、V02-DAILYLIFE-003、V02-DAILYLIFE-004；交付物：端到端玩家路径测试和 1280x720、960x540 截图；验收：玩家从启动开始能完成“找 NPC -> 做小事 -> 得反馈 -> 使用奖励 / 回小屋”的完整路径。完成记录：新增 `tests/test_v028_daily_life_slice.gd` 并注册进 `tests/headless_runner.gd`，覆盖 Mina 委托、树枝采集、奖励、商店买木椅、背包、小屋摆放、Sunny 反馈和 C/O/S 回访。

### V02.9 一周回访节奏：让孩子愿意回来看看

> 本阶段在 V02.8 可玩纵切基础上扩展 7 天低压力回访节奏。重点是今日状态、居民轻目标、商店轮换、小屋反馈和 A-Z 环境线索的数据合同与玩家路径，不做连续登录、限时活动、强制购买或学习打卡。

- [x] **V02-WEEKLY-001 一周回访内容合同与排期**
  Owner：PM / Game Design / Narrative / QA Agent；依赖：V02-DAILYLIFE-005、V02-CONTENT-001；交付物：V02.9 阶段路线、7 天内容排期、P0/P1 边界、数据化改动清单和验收口径；验收：每天都有 `day_key`、今日状态、主居民、轻目标、商店 / 小屋回访、A-Z 线索和儿童安全边界，不引入连续登录或错过惩罚。完成记录：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 和 `docs/collaboration/Round60_V02.9_WEEKLY-001_PM执行任务包.md` 已同步 V02.9 路线与 7 天排期。
- [x] **V02-WEEKLY-002 每日状态与商店轮换数据化**
  Owner：Godot Dev / Economy / QA Agent；依赖：V02-WEEKLY-001、V02-CONTENT-001；交付物：7 天 `today_status` 数据、商店 P0/P1/P2 轮换数据、focused contract test；验收：7 个本地 day_key 均可加载不同状态 / 轮换，P0 常驻商品不消失，买不起不失败，不要求连续登录。完成记录：`data/life/today_status.json` 升级为 7 天稳定 `day_key` / `shop_rotation_id` 合同；`data/items/life_items.json` 新增 7 天 `shop_rotations`；`TodayStatusService`、`LifeShopService`、`InventoryService` 和 `ContentContractValidator` 已支持并验证周轮换合同；focused tests 与 `headless_runner` 已覆盖。
- [x] **V02-WEEKLY-003 P1 居民回访入口预收**
  Owner：Narrative / UX / QA / Godot Agent；依赖：V02-WEEKLY-001、V02-WEEKLY-002；交付物：故事熊 / 巴士哥哥的可见入口清单、安全边界、截图点和后续实现任务包；验收：Bookshop / Bus Stop 不进入主流程硬依赖，不出现陌生人带走、独自远行、赶时间或阅读测验压力。完成记录：`docs/14_内容基线整理与首批内容规划.md` 已新增故事熊 / Bookshop、巴士哥哥 / Bus Stop 入口清单、B Bear / T Taxi 回访绑定、双视口截图点和 `V02-WEEKLY-004` smoke 输入；`docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md` 已完成 handoff。
- [x] **V02-WEEKLY-004 一周回访 smoke 与截图**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-WEEKLY-002、V02-WEEKLY-003；交付物：7 天玩家路径 smoke、headless runner 注册、1280x720 与 960x540 代表截图；验收：连续切换 7 个本地 day_key 后仍能从可见入口完成温和日常，截图无明显遮挡或工程文案。完成记录：新增 `tests/test_v029_weekly_return_smoke.gd` 并注册进 `tests/headless_runner.gd`，覆盖 7 天 HUD 刷新、商店轮换、Mina 可见日常、P1 不阻断和儿童安全文案；旧截图验收文件和截图目录已清理，保留玩家路径 smoke 与 headless runner 回归。

### V02.10 P1 居民回访扩展：让预收居民成为可见支线

> 本阶段只把故事熊 / Bookshop、巴士哥哥 / Bus Stop 做成 P1 可见回访，不扩完整全镇、不接真实出行、不做阅读测验，也不让 P1 支线阻断 P0 每日生活。

- [x] **V02-P1RETURN-001 Bookshop / Bus Stop 真实可见入口**
  Owner：Godot Dev / UX / QA Agent；依赖：V02-WEEKLY-003、V02-WEEKLY-004；交付物：Bookshop 门口、Bear Corner、Bus Stop 站牌、Taxi marker 的孩子端 `看看` 入口和 focused test；验收：四个入口可从真实可见路径触发，反馈温和，P0 主路径不受影响，不出现阅读测验、赶车压力、陌生人带走或独自远行。完成记录：`data/maps/world_map.json` 新增四个 P1 return hotspot；`scripts/main.gd` 新增 `look_p1_return_entry` 可见互动处理并记录 `p1_return_entries`；`tests/test_v0210_p1_return_entries.gd` 与 `tests/headless_runner.gd` 已覆盖四个入口、P0 路径不阻断和儿童安全文案。
- [x] **V02-P1RETURN-002 故事熊 / 巴士哥哥 P1 轻回访**
  Owner：Narrative / Godot Dev / QA Agent；依赖：V02-P1RETURN-001、V02-CONTENT-001；交付物：至少 2 条 P1 看一眼 / 带材料类支线；验收：可接取、可完成、同日去重，不强制购买、不离开小镇、不要求阅读或赶车。完成记录：`data/life/daily_requests.json` 新增 `daily_story_bear_find_bear_corner_001` 与 `daily_bus_helper_taxi_spot_001`；`DailyRequestService` 支持 `required_p1_entries`；主场景将 Story Bear / Bus Helper 可见 NPC 互动路由到 V02.10 P1 请求；`tests/test_v0210_p1_light_returns.gd` 与 `tests/headless_runner.gd` 已覆盖接取、入口查看、回 NPC 完成、同日去重和儿童安全文案。
- [x] **V02-P1RETURN-003 B Bear / T Taxi 相册与 A-Z 记录**
  Owner：Memory Palace / UI / QA Agent；依赖：V02-P1RETURN-001、V02-AZ-WORLD-004；交付物：B Bear / T Taxi 入口或支线完成后的 card state / 相册记录；验收：相册只记录地点故事、环境词和温和反馈，不显示正确率、等级、课程或测试。完成记录：`scripts/main.gd` 将 `look_p1_return_entry` 的 `linked_anchor_id` 写入对应 `card_id` 的 seen/heard/collected card state；`tests/test_v0210_p1_return_entries.gd`、`tests/test_v0210_p1_light_returns.gd` 与 `tests/headless_runner.gd` 已覆盖 B Bear / T Taxi 从真实 `看看` 路径落账、相册 UI 显示“已收藏”且无正确率 / 等级 / 测试文案。
- [x] **V02-P1RETURN-004 P1 回访 smoke 与截图**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-P1RETURN-001、V02-P1RETURN-002、V02-P1RETURN-003；交付物：P1 支线玩家路径 smoke、headless runner 注册、1280x720 与 960x540 代表截图；验收：P1 支线可玩且不阻断 P0 主路径，Bookshop / Bus Stop 截图无明显遮挡或工程文案。完成记录：新增 `tests/test_v0210_p1_return_smoke.gd` 并在 `tests/headless_runner.gd` 以 `_check_v0210_p1_return_smoke()` 注册，覆盖故事熊 / 巴士哥哥 P1 路径、B/T 相册记录、P0 Mina / 商店 / 小屋不阻断和禁用文案；旧截图 capture 脚本、验收文件和截图目录已清理，保留 P1 smoke 与 headless runner 回归。

### V02.11 天气与小镇轻事件纵切：让每天的小镇有温和变化

> 本阶段只把晴天、微风、雨后、小雨等 P0 天气轻事件做成生活化数据合同和可见今日状态，不做真实天气联网、节日运营页、连续登录、倒计时、补签、错过损失或奖励墙。

- [x] **V02-WEATHER-001 天气轻事件数据合同与今日状态接入**
  Owner：PM / Game Design / Data Contract / Godot Dev / QA Agent；依赖：V02-WEEKLY-002、V02-DESIGN-005、V02-CONTENT-001；交付物：P0 天气事件 JSON / today_status 引用、loader / validator、focused contract test 和 HUD 今日状态可见短句；验收：晴天、微风、雨后、小雨四类事件均有稳定 ID、P0 优先级、天气标签、短中文状态文案和儿童安全说明，不接真实天气 API，不出现倒计时、错过、补签、连续或必须文案。完成记录：`data/life/weather_events.json`、`data/life/today_status.json`、`scripts/systems/today_status_service.gd`、`scripts/systems/content_contract_validator.gd`、`tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd` 和 `tests/headless_runner.gd` 已接入并验证通过。
- [x] **V02-WEATHER-002 NPC 问候与资源 / 商店轻变化**
  Owner：Narrative / Economy / Godot Dev / QA Agent；依赖：V02-WEATHER-001、V02-DAILYLIFE-001、V02-WEEKLY-002；交付物：天气事件驱动的 NPC 问候变体、资源提示 / 权重轻变化和商店活动角引用；验收：P0 常驻商品不消失，资源不会因天气减少基础可得性，NPC 文案温和且数据化，不制造限时购买或售罄焦虑。完成记录：`data/life/daily_greetings.json` 新增天气问候变体，`data/life/resource_points.json` 新增天气提示，`data/items/life_items.json` 新增 `weather_activity_corner`；`DailyGreetingService`、`ResourceRefreshService`、`LifeShopService` 和 `ContentContractValidator` 已接入并通过 focused/headless 验证。
- [x] **V02-WEATHER-003 A-Z 天气相册线索**
  Owner：Memory Palace / UI / Narrative / QA Agent；依赖：V02-WEATHER-001、V02-AZ-WORLD-004、V02-P1RETURN-003；交付物：S Sun、K Kite、B Bear、U Umbrella 等天气环境线索与相册 / card state 记录；验收：只记录地点故事、环境词和温和反馈，不做天气打卡、答题、背诵、顺序拜访或等级评价。完成记录：`data/life/weather_events.json` 新增 `album_clues`，`scripts/main.gd` 在真实可见 anchor / P1 look 路径记录 `weather_album_clues` 并点亮对应 card state，`scripts/ui/memory_album.gd` 显示 U Umbrella 卡片，`scripts/systems/content_contract_validator.gd` 拦截天气相册线索字段缺失；`tests/test_v023_memory_palace_world.gd` 覆盖 S Sun、K Kite、B Bear、U Umbrella 在对应 day_key 通过 `看看` 路径落账并打开相册验证“已收藏”，focused/headless 验证通过。
- [x] **V02-WEATHER-004 天气纵切 smoke 与双视口截图**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-WEATHER-001、V02-WEATHER-002、V02-WEATHER-003；交付物：多天气 day_key 玩家路径 smoke、headless runner 注册、1280x720 与 960x540 代表截图；验收：多天气状态可见且 P0 Home / Shop / 小屋 / Mina / 相册 / A-Z 路径不阻断，截图无明显遮挡、工程文案、倒计时、错过或运营压力。完成记录：新增 `tests/test_v0211_weather_slice_smoke.gd` 并在 `tests/headless_runner.gd` 注册 `_check_v0211_weather_slice_smoke()`，覆盖晴天、微风、小雨、雨后四类天气 day_key、Mina 日常、P0 商店、小屋摆放、相册和 S/K/B/U 天气线索落账；旧截图 capture 脚本、验收文件和截图目录已清理，focused/headless 回归保留。

### V02.12 学校-家庭中心世界地图与 A-Z 锚点规划

> 本阶段先为后续课本场景主线建立地图地基：Home 和 School 位于世界地图中心，26 个 A-Z anchor 分布在中心、第一圈、第二圈和远郊预留中。课本知识点只作为未来场景挂接位，不在孩子端显示课程、单元、测试、背诵或词表。

- [x] **V02-AZWORLD-001 Home / School 中心地图原则与 26 anchor 分布合同**
  Owner：PM / Memory Palace / Map / Curriculum / QA Agent；依赖：V02.11 收口、V02-AZ-WORLD-004、V02-CONTENT-005；交付物：`data/maps/az_world_plan.json`、`scripts/data/az_world_plan_contract.gd`、focused contract test、`headless_runner` 注册、路线文档同步；验收：Home / School 为中心，26 个 anchor 全量分布，A/C/D/W 覆盖 Home 线，E/G/K/N/R/Y 覆盖 School 线，X/Z 远郊不阻断 P0，未来 0 基础 / 课本挂接字段完整。完成记录：新增 `data/maps/az_world_plan.json` 定义 Home / School 双中心、center / first_ring / second_ring / far_edge 四层结构和 26 anchor 分布；新增 `scripts/data/az_world_plan_contract.gd` 与 `tests/test_v0212_az_world_plan.gd`，并在 `tests/headless_runner.gd` 注册 `_check_v0212_az_world_plan()`；同步 `docs/12`、`docs/13`、`docs/14`、`docs/15` 和 `todo.md`；JSON、focused、A-Z core、memory palace、headless runner 和 Godot headless 启动均通过。
- [x] **V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划**
  Owner：Map / PM / UX / QA Agent；依赖：V02-AZWORLD-001；交付物：中心、第一圈、第二圈、远郊预留的区域 / 道路 / 安全边界规划；验收：Home-School Walk 可作为第一主线安全路线，远郊不制造出行压力。完成记录：新增 `docs/collaboration/Round74_V02.12_AZWORLD-002_PM执行任务包.md` 与 `docs/collaboration/Round74_V02.12_AZWORLD-002区域道路安全规划.md`；`data/maps/az_world_plan.json` 新增 `routes` 与 `safety_boundaries`；合同和 focused test 已覆盖 P0 Home-School Walk、first / second ring、far_edge 不阻断和安全返回点。
- [x] **V02-AZWORLD-003 17 个 reserved anchor 升级为可制作级规格**
  Owner：Memory Palace / Narrative / Art Direction / QA Agent；依赖：V02-AZWORLD-001、V02-AZWORLD-002；交付物：E/F/G/H/I/J/L/M/N/P/Q/R/U/V/X/Y/Z 的可见入口、相册记录、素材规格和儿童安全边界；验收：17 个 reserved anchor 可交给数据、场景、美术 worker 拆分。完成记录：新增 `docs/collaboration/Round75_V02.12_AZWORLD-003_PM执行任务包.md` 与 `docs/collaboration/Round75_V02.12_AZWORLD-003可制作级规格记录.md`；`data/maps/az_world_plan.json` 新增 17 条 `reserved_anchor_specs`，均包含 visible entry、album record、logical asset IDs、`make_ready` 和安全说明；合同和 focused test 已覆盖。
- [x] **V02-AZWORLD-004 Home / School 0 基础主线挂接位**
  Owner：Curriculum / Narrative / PM / QA Agent；依赖：V02-AZWORLD-001；交付物：family、home、room、clock、dog、bag、school、gate、play、look、go、good morning 等内部挂接位；验收：知识点落在 Home / School 生活事件中，不形成课程页或测试门槛。完成记录：新增 `docs/collaboration/Round76_V02.12_AZWORLD-004_005_PM执行任务包.md` 与 `docs/collaboration/Round76_V02.12_AZWORLD-004_005挂接与验收记录.md`；`data/maps/az_world_plan.json` 新增 `foundation_story_hooks`，覆盖 12 个首批 0 基础 tag / 短句并绑定 Home / School 场景与 A-Z anchor。
- [x] **V02-AZWORLD-005 合同测试、回归验证和截图验收口径**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-AZWORLD-001 至 004；交付物：focused/headless 回归、后续实现截图点和验收记录口径；验收：A-Z 世界规划进入全量回归，截图点覆盖 Home、School、Home-School Walk 和代表远郊预留。完成记录：`scripts/data/az_world_plan_contract.gd` 与 `tests/test_v0212_az_world_plan.gd` 已扩展覆盖 routes、safety boundaries、reserved specs、foundation hooks 和 screenshot acceptance；`tests/headless_runner.gd` 已注册 `_check_v0212_az_world_plan()`；全量验证通过。

### V02.13 全量课本内容世界化主线策划

> 本阶段把小学三上至六下 8 册课本内容补齐为可加载世界化数据源。范围固定为数据与合同，不接入孩子端 runtime，不做课程页、单元门、背诵表、测试路线或截图验收。

- [x] **V02-TEXTBOOK-001 小学全册教材源补齐**
  Owner：Curriculum / PM / QA Agent；依赖：V02.12 收口；交付物：三上结构化摘要、8 册 `textbook_sources` ledger；验收：三上、三下、四上、四下、五上、五下、六上、六下均有本地摘要或来源记录。完成记录：新增 `curriculum/小学英语重点分析/三年级上册.txt`，保留公开来源 URL、抓取日期和只摘要不复制原文的边界；`data/curriculum/textbook_world_plan.json` 的 `textbook_sources` 覆盖 8 册。
- [x] **V02-TEXTBOOK-002 全量课本内容结构化清单**
  Owner：Curriculum / Data Contract / QA Agent；依赖：V02-TEXTBOOK-001；交付物：按年级 / 单元 / 主题整理的 `curriculum_items`；验收：每个单元有主题、关键词、短句、生活场景候选和来源。完成记录：`curriculum_items` 覆盖 85 个单元摘要：三上 10、三下 10、四上 10、四下 10、五上 12、五下 12、六上 12、六下 9。
- [x] **V02-TEXTBOOK-003 世界化主线映射表**
  Owner：Memory Palace / Narrative / Map / QA Agent；依赖：V02-TEXTBOOK-002、V02-AZWORLD-001；交付物：`world_mappings`；验收：每个映射绑定 `world_place_id`、`npc_id`、`anchor_id`、`story_memory`、`visual_hook`、`review_path`、`child_facing_line` 和 `tier`。完成记录：新增 P0/P1/P2 世界映射，P0 聚焦 Home、Home-School Walk、School Gate、School Yard、Shop 和 Sunny 角落，P1/P2 只作扩展预留。
- [x] **V02-TEXTBOOK-004 Home / School 第一主线与 P0/P1/P2 分层**
  Owner：PM / Curriculum / Narrative / QA Agent；依赖：V02-TEXTBOOK-003；交付物：`mainline_segments`；验收：P0 只覆盖 0 基础、三上 / 三下高频和 Home / School 生活事件，P1/P2 不阻断当前每日小镇。完成记录：新增 Home Morning Foundation、Home-School Walk Foundation、Shop Food Bridge、First Ring Story Expansion 和 Future Reserve 五段分层；P0 不使用 `anchor_x_x_mark_box` / `anchor_z_zebra` 或 far edge 地点。
- [x] **V02-TEXTBOOK-005 数据合同与回归验证**
  Owner：QA / Data Contract / PM Agent；依赖：V02-TEXTBOOK-001 至 004；交付物：`scripts/data/textbook_world_contract.gd`、`tests/test_v0213_textbook_world_plan.gd`、`tests/headless_runner.gd` 注册；验收：JSON、合同、focused、headless runner 和 Godot headless 启动通过。完成记录：新增 `TextbookWorldContract`，可拦截缺册、单元数不一致、缺映射、P0 远郊依赖和孩子端压力文案；focused/headless 验证通过。

### V02.14 Home / School P0 可玩纵切

> 本阶段把 V02.13 的 Home / School 第一主线推进为孩子端真实可见的生活路线。P0 只覆盖 Home、Home-School Walk、School Gate、School Yard、Shop 和 Sunny 角落；Bookshop、Bus Stop、Park、Theatre、Music Corner、Far Edge 继续作为 P1/P2 预留，不阻断主流程。

- [x] **V02-HOMESCHOOL-001 Home / School P0 可玩纵切路线与任务拆分**
  Owner：PM / Game Design / Narrative / QA Agent；依赖：V02.13 收口、V02-AZWORLD-001 至 005、V02-TEXTBOOK-001 至 005；交付物：V02.14 路线、P0 内容点、任务拆分、Round78 PM 任务包和 Ready 队列；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步，下一轮唯一 Ready 明确。完成记录：新增 `docs/collaboration/Round78_V02.14_HOMESCHOOL-001_PM执行任务包.md`；将 V02.14 拆为 `V02-HOMESCHOOL-002` 至 `005`，首批内容点固定为 Home morning、Home-School Walk、School Gate / School Yard 和 Return / Shop bridge。
- [x] **V02-HOMESCHOOL-002 Home Morning Foundation 数据化与可见入口**
  Owner：Godot Dev / Narrative / QA Agent；依赖：V02-HOMESCHOOL-001；交付物：Home / 小屋 / Sunny 早晨可见入口、温和反馈、A/C/D/W Home 线索记录和 focused test；验收：玩家从真实可见 `看看` / Home / Sunny / 小屋路径触发，不依赖隐藏 contract 按钮，不出现起床打卡、迟到、课程、作业、测试、背诵、分数或家长报告。完成记录：新增 `data/life/homeschool_events.json` 的 Home morning 两条 P0 事件；`data/maps/world_map.json` 新增 Home / Sunny 早晨可见 hotspot；`scripts/main.gd` 通过 `look_homeschool_event` 保存 `homeschool_events` 并点亮 A/C/D/W 对应 card state；`tests/test_v0214_homeschool_slice.gd` 真实可见 `看看` 路径通过。
- [x] **V02-HOMESCHOOL-003 Home-School Walk 可见路径与安全边界**
  Owner：Map / Godot Dev / UX / QA Agent；依赖：V02-HOMESCHOOL-002；交付物：Home-School Walk 可走路线、路牌 / 风筝 / 校门方向线索、安全返回和 focused test；验收：路线可走、可看、可回 Home，不引用 far edge，不出现赶路、倒计时、交通危险或独自远行。完成记录：`data/maps/world_map.json` 已接入 `place_home_school_walk`、路牌与风筝天空两个 P0 hotspot；玩家可移动至小路节点并用底栏 `看看` 触发 G/K/S/W 线索；focused / headless 验证确认不引用 far edge、不阻断回 Home。
- [x] **V02-HOMESCHOOL-004 School Gate / School Yard 首批地点故事**
  Owner：Narrative / Godot Dev / Memory Palace / QA Agent；依赖：V02-HOMESCHOOL-003；交付物：School Gate / School Yard 首批地点故事、NPC 轻反馈、E/G/K/N/R/Y A-Z 记录和 focused test；验收：学校像生活地点和操场回访，不出现课堂、老师训导、作业、测试、背诵或分数。完成记录：`data/life/homeschool_events.json` 新增 School Gate hello 与 School Yard play corner；`data/maps/world_map.json` 接入 `place_school_gate` / `place_school_yard` 可见 hotspot；`tests/test_v0214_homeschool_slice.gd` 验证 E/G/K/N/R/Y card state 与相册收藏状态。
- [x] **V02-HOMESCHOOL-005 P0 主线 smoke、截图和儿童文本验收**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-HOMESCHOOL-002、V02-HOMESCHOOL-003、V02-HOMESCHOOL-004；交付物：Home -> Walk -> School -> Return / Shop bridge 玩家路径 smoke、headless runner 注册、1280x720 与 960x540 代表截图；验收：P0 主线可玩且不阻断 V02.8-V02.11 已有每日小镇、商店、小屋、天气和相册路径，截图无明显遮挡、工程文案或课程化文案。完成记录：新增 `tests/test_v0214_homeschool_slice.gd` 覆盖 Home -> Walk -> School -> Return / Shop bridge、相册落账、旧 P0 商店 / 小屋闭环和儿童安全禁词；`tests/headless_runner.gd` 已补齐 `_check_v0214_homeschool_slice()` 注册；focused、headless runner、Godot headless 启动和 MCP 1280x720 运行时截图抽查通过。

### V02.15 Home / School 日常回访与学校生活轻循环

> 本阶段把 V02.14 已经走通的 Home / School P0 路线扩展为 7 天低压力回访节奏。P0 仍只覆盖 Home、Home-School Walk、School Gate、School Yard、Shop 和 Sunny 角落；差异来自校门问候、操场小发现、上学路环境线索和回家 Sunny 反馈，不新增课程页、作业、测试、打卡、迟到或分数。

- [x] **V02-SCHOOLDAILY-001 Home / School 日常回访路线与任务拆分**
  Owner：PM / Game Design / Narrative / QA Agent；依赖：V02.14 收口、V02-AZWORLD-001 至 005、V02-TEXTBOOK-001 至 005；交付物：V02.15 路线、7 天差异维度、任务拆分、Round80 PM 任务包和 Ready 队列；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步，下一轮唯一 Ready 明确。完成记录：新增 `docs/collaboration/Round80_V02.15_SCHOOLDAILY-001_PM执行任务包.md`；将 V02.15 拆为 `V02-SCHOOLDAILY-002` 至 `005`，首批差异维度固定为 School Gate greeting、School Yard discovery、Home-School Walk variation 和 Home Return story。
- [x] **V02-SCHOOLDAILY-002 School Day State Contract 数据化**
  Owner：Data Contract / Godot Dev / QA Agent；依赖：V02-SCHOOLDAILY-001；交付物：School day state JSON、loader / service、合同测试；验收：7 个 `local_day_001` 至 `local_day_007` 均可加载 gate / yard / walk / return 内容，字段绑定 `stage`、`place_id`、`anchor_ids`、`environment_words`、`child_facing_text` 和 `safety_note`，合同拦截课程、作业、测试、迟到、打卡、分数或家长报告文案。完成记录：新增 `data/life/school_day_states.json` 7 天四阶段 school day state；`scripts/systems/school_day_state_service.gd` 可按 day_key 读取今日 school state 与阶段 entry；`scripts/systems/content_contract_validator.gd` 已纳入 school day state 合同检查；`tests/test_v024_content_contracts.gd` 验证 7 天 `home_school_walk` / `school_gate` / `school_yard` / `return_home` 可加载并含 anchor、环境词、孩子端文本和安全说明；focused、check-only 与 headless runner 通过。
- [x] **V02-SCHOOLDAILY-003 School Gate / Yard 每日可见差异**
  Owner：Narrative / Godot Dev / Memory Palace / QA Agent；依赖：V02-SCHOOLDAILY-002；交付物：School Gate / Yard 每日可见差异、A-Z 记录和 focused test；验收：玩家从真实可见 `看看` 路径触发校门 / 操场每日反馈，E/G/K/N/R/Y 线索自然复现，不出现课堂、老师训导、作业、测试、背诵或分数。完成记录：`scripts/main.gd` 已在 `look_homeschool_event` 中按当前 `day_key` 读取 `SchoolDayStateService.get_entry(stage)`，校门 / 操场真实 `看看` 热点会显示当天 `child_facing_text`、保存 `school_day_events` 并点亮 entry 绑定的 A-Z card state；新增 `tests/test_v0215_school_daily_slice.gd` 覆盖 7 天校门 / 操场每日差异、A-Z card 落账和儿童安全文案。
- [x] **V02-SCHOOLDAILY-004 Home Return / Sunny 日常回访**
  Owner：Home Design / Narrative / Godot Dev / QA Agent；依赖：V02-SCHOOLDAILY-003；交付物：Home Return / Sunny 按 day_key 的回家反馈、保存记录和 focused test；验收：回家反馈温暖、可保存、可复核相册，不变成学习总结、家长报告、作业检查或表现评价。完成记录：`return_home` 阶段已按 7 个 day_key 读取 Sunny 回家文本并保存为 `school_day_events`，`tests/test_v0215_school_daily_slice.gd` 验证 7 条 `return_home` 记录均落账、保留 stage / day_key / anchors / environment_words，并确认 display_prefix 仍绑定 Sunny。
- [x] **V02-SCHOOLDAILY-005 7 天学校生活 smoke 与截图**
  Owner：QA / PM / Godot Dev Agent；依赖：V02-SCHOOLDAILY-002、V02-SCHOOLDAILY-003、V02-SCHOOLDAILY-004；交付物：7 天 Home -> Walk -> School -> Return 玩家路径 smoke、headless runner 注册、1280x720 与 960x540 代表截图；验收：7 天均可玩且不阻断 V02.8-V02.14 已有每日小镇、商店、小屋、天气、相册和 Home / School 纵切路径，截图无明显遮挡、工程文案或课程化文案。完成记录：新增 `tests/test_v0215_school_daily_slice.gd`，覆盖 7 天 x 4 阶段真实可见 `看看` 路径、28 条 school day event 保存、7 条 Sunny return 保存、商店 / 小屋旧路径不阻断和儿童安全禁词；`tests/headless_runner.gd` 注册 `_check_v0215_school_daily_slice()`。

### V02.16 可制作内容与体验抛光 / Playable RC Gate

> 本阶段把 V02.8-V02.15 已跑通的核心体验整理成 5-10 分钟可试玩 / 可制作版本门槛。范围固定为现有 P0/P1 内容的文本统一、操作动线抛光、美术 / UI 截图复核和完整玩家路径验收；不扩地图、不新增课程 UI、不把 Bookshop / Bus Stop 升为 P0，也不改 A-Z anchor 结构。

- [x] **V02-PRODUCTION-001 V02.16 路线、试玩范围和发布门槛规划**
  Owner：PM / Game Design / Narrative / QA Agent；依赖：V02.15 收口、V02-DAILYLIFE-005、V02-WEATHER-004、V02-P1RETURN-004、V02-SCHOOLDAILY-005；交付物：V02.16 路线、试玩范围、发布门槛、Round83 PM 任务包和 Ready 队列；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步，下一轮唯一 Ready 明确。完成记录：新增 `docs/collaboration/Round83_V02.16_PRODUCTION-001_PM执行任务包.md`；将 V02.16 拆为 `V02-PRODUCTION-002` 至 `005`，试玩范围固定为每日小镇、Home / School、天气、P1 轻回访、商店、小屋、Sunny、相册和设置。
- [x] **V02-PRODUCTION-002 孩子端文案、反馈语气和禁用词统一审校**
  Owner：Narrative / UX / QA / Godot Agent；依赖：V02-PRODUCTION-001；交付物：孩子端可见文本审校、反馈语气统一、禁用词扫描测试扩展；验收：HUD、NPC、Sunny、Home / School、天气、P1、商店、小屋、相册和设置均为温暖短句，不出现课程、作业、测试、背诵、迟到、打卡、分数、正确率、家长报告、必须完成或错过损失。完成记录：新增 `tests/test_v0216_playable_rc_gate.gd` 的孩子端可见文本扫描，并在 `tests/headless_runner.gd` 注册 `_check_v0216_playable_rc_gate()`；扫描覆盖启动、Mina、资源、商店、小屋、Sunny、Home / School、相册和设置真实可见状态。
- [x] **V02-PRODUCTION-003 核心操作动线抛光**
  Owner：UX / Godot / QA Agent；依赖：V02-PRODUCTION-002；交付物：`看看`、小镇、背包、商店、小屋、相册、设置的打开、反馈、关闭和遮挡修正；验收：启动后能看懂当前位置，底栏不遮挡，反馈明确，面板可关闭；只做小范围 UI / UX polish，不重做主界面结构，不使用隐藏 contract 按钮作为验收。完成记录：V02.16 smoke 已覆盖 `看看`、小镇、背包、商店、小屋、相册和设置的真实可见入口；商店 / 相册 / 设置均验证可见关闭路径，小屋验证摆放、旋转、挪动和 Sunny 反馈。
- [x] **V02-PRODUCTION-004 关键美术 / UI 截图复核**
  Owner：Art Direction / UI / QA / Godot Agent；依赖：V02-PRODUCTION-003；交付物：Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings 的 1280x720 与 960x540 截图复核记录；验收：使用 `ThemeProfile` / `AssetResolver`，无 runtime 硬编码资源路径；资产状态区分 `production` 与 `approved`，缺少双视口截图证据不得标为 `approved`。完成记录：旧截图 capture 脚本与截图目录已清理；历史 Round84 V02.16 记录曾明确本轮不自动把全部资源提升为 `approved`。
- [x] **V02-PRODUCTION-005 试玩版总 smoke、双视口截图和阶段收口**
  Owner：QA / PM / Godot Agent；依赖：V02-PRODUCTION-002、V02-PRODUCTION-003、V02-PRODUCTION-004；交付物：试玩版总 smoke、`tests/headless_runner.gd` 注册、1280x720 与 960x540 代表截图、`todo.md` 与 `lessons.md` 收口；验收：启动 -> Mina / 资源 -> Shop -> Home -> Sunny -> Home-School Walk -> School Gate -> School Yard -> Return Home -> Album -> Settings 全路径通过，截图无明显遮挡、文本溢出、工程文案或课程化文案。完成记录：历史 Round84 V02.16 生产截图验收已清理归档；focused V02.16 smoke、全量 headless runner、Godot headless 启动和双视口截图导出均通过，V02.16 Playable RC Gate 可标记完成。

### V02.17 世界地图运行时落地与 26 Anchor 可视布局

> 本阶段把 V02.12 的 `az_world_plan` 从规划合同推进到运行时地图布局、可见热点、相册落账和截图验收。范围固定为现有 26 个 A-Z anchor、Home / School 双中心、first / second ring 和 far edge 安全边界；不重新设计 A-Z 编码，不做课程地图、字母打卡或顺序拜访考试。

- [x] **V02-WORLDMAP-001 V02.17 路线、地图布局范围和 Ready 规划**
  Owner：PM / Map / Memory Palace / QA Agent；依赖：V02.16 收口、V02-AZWORLD-001 至 005、V02-HOMESCHOOL-005、V02-SCHOOLDAILY-005、V02-PRODUCTION-005；交付物：V02.17 路线、地图布局范围、任务拆分、Round85 PM 任务包和 Ready 队列；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步，下一轮唯一 Ready 明确。完成记录：新增 `docs/collaboration/Round85_V02.17_WORLDMAP-001_PM执行任务包.md`；将 V02.17 拆为 `V02-WORLDMAP-002` 至 `005`，阶段目标固定为 26 anchor 坐标蓝图、P0 中心路线运行时接入、first / second ring 预览和 26 anchor QA 收口。
- [x] **V02-WORLDMAP-002 26 Anchor 地图坐标与分层可达蓝图**
  Owner：Map / UX / Memory Palace / QA Agent；依赖：V02-WORLDMAP-001、`data/maps/az_world_plan.json`、`data/anchors/az_core_anchors.json`；交付物：26 anchor 运行时坐标蓝图、道路关系、入口状态、截图点和安全边界表；验收：每个 anchor 保留 `anchor_id`、`letter`、`core_word`、`route_order` 和 `card_id`，P0 / first ring / second ring / far edge 分层清楚，不要求孩子按 A-Z 顺序拜访，不出现课程、测试、背诵、打卡、倒计时或远郊主流程依赖。完成记录：`docs/collaboration/Round86_V02.17_WORLDMAP-002_005运行时布局与验收记录.md` 固定 Home line、School line、first ring、second ring、far edge 运行时坐标口径；`data/maps/world_map.json` 的 26 个 `memory_anchors` 保留核心 ID、letter、core_word、route_order 和 card_id。
- [x] **V02-WORLDMAP-003 P0 Home / School 中心路线运行时地图接入**
  Owner：Godot Dev / Map / Narrative / QA Agent；依赖：V02-WORLDMAP-002；交付物：A/C/D/W、E/G/K/N/R/Y 的中心路线地图节点、可见物件、`看看` 热点、相册落账和 focused test；验收：Home -> Home-School Walk -> School Gate -> School Yard 可走可看，所有落账来自真实可见入口，不阻断 V02.16 总路径，学校不课程化。完成记录：`tests/test_v0217_worldmap_anchor_runtime.gd` 覆盖中心路线 anchor 真实 `看看` 落账；`interact_nearby()` 调整为 exact resource 优先、nearby anchor 优先于 nearby resource，避免 A-Z 相册入口被周边资源吞掉。
- [x] **V02-WORLDMAP-004 First / Second Ring Anchor 预览与 P1 可见入口**
  Owner：Godot Dev / Narrative / Art Direction / QA Agent；依赖：V02-WORLDMAP-002、V02-WORLDMAP-003；交付物：B/F/H/I/J/O/T 与 L/M/P/Q/S/U/V 的预览入口、P1 支线入口、logical asset ID 接入计划和儿童安全文本；验收：first / second ring 不阻断 P0，Bookshop、Garden、Park、Theatre、Music Corner 等只作生活回访或预览，不出现顺序拜访、阅读测验、赶车压力、表演评分或危险模仿。完成记录：first / second ring 与 X/Z far edge 均通过 V02.17 focused test 的 Node2D / ObjectSprite / 相册落账验证；B Bear、K Kite、U Umbrella 等既有天气 / P1 路径已对齐新坐标。
- [x] **V02-WORLDMAP-005 26 Anchor 合同、smoke 与双视口截图收口**
  Owner：QA / PM / Godot Agent；依赖：V02-WORLDMAP-003、V02-WORLDMAP-004；交付物：26 anchor 合同测试、运行时 smoke、相册落账复核、1280x720 与 960x540 代表截图和阶段收口记录；验收：focused / headless / Godot 启动通过；代表截图无明显遮挡、文本溢出、工程文案、裸字母牌或课程化文案；X/Z 远郊只作边界预览，不进入 P0。完成记录：`godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --script tests/test_v0211_weather_slice_smoke.gd`、`godot --headless --path . --script tests/test_v028_daily_life_slice.gd`、`godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；截图验收口径写入 Round86 记录，后续实际双视口截图仍按非 headless / MCP 工具链执行。

### V02.18 世界地图视觉可读性与探索体验抛光

> 本阶段把 V02.17 已经落地的 26 anchor 地图从“功能可达”推进到“孩子能看懂、找得到、愿意回访”。范围固定为视觉可读性、道路引导、热点优先级、反馈短句、相册回访和双视口截图证据；不新增课程内容，不重排 A-Z 编码，不扩远郊 P0，不做字母打卡或完成率。

- [x] **V02-MAPREAD-001 V02.18 路线、审计范围和 Ready 规划**
  Owner：PM / Map / Art Direction / QA Agent；依赖：V02.17 收口、V02-WORLDMAP-002 至 005、V02-PRODUCTION-005、`LESSON-009`、`LESSON-010`、`LESSON-011`；交付物：V02.18 路线、审计范围、任务拆分、Round87 PM 任务包和 Ready 队列；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步，下一轮唯一 Ready 明确。完成记录：新增 `docs/collaboration/Round87_V02.18_MAPREAD-001_PM执行任务包.md`；将 V02.18 拆为 `V02-MAPREAD-002` 至 `005`，阶段目标固定为 26 anchor 可读性审计、地图视觉层级 / 道路引导抛光、anchor 徽章 / 热点优先级 / 反馈短句抛光和地图探索 smoke / 双视口截图收口。
- [x] **V02-MAPREAD-002 26 Anchor 可读性审计与截图基线**
  Owner：QA / Map / UX / Art Direction Agent；依赖：V02-MAPREAD-001、`data/maps/world_map.json`、`data/maps/az_world_plan.json`、Round86 V02.17 运行时布局与验收记录；交付物：26 anchor 可读性审计表、双视口截图基线、遮挡 / 热点 / 小字 / 区域层次问题清单；验收：覆盖 Home anchors、School line、first ring、second ring、far edge 和 Album，不改核心 ID / route_order，不以服务直调或隐藏按钮作为可读性证据，不出现课程、测试、背诵、打卡、分数、完成率或远郊每日路线。完成记录：`tests/test_v0218_map_readability.gd` 覆盖 26 anchor 的截图组、主轮廓、徽章尺寸、可见 look cell、真实 `看看` 路径和儿童安全文案；Round88 验收记录固定 Home anchors / School line / first ring / second ring / far edge / Album 截图口径。
- [x] **V02-MAPREAD-003 地图视觉层级与道路引导抛光**
  Owner：Map / Art Direction / Godot / QA Agent；依赖：V02-MAPREAD-002；交付物：Home / School / Town / Far Edge 区域层次、道路引导、安全边界和回家线索抛光；验收：1280x720 与 960x540 下 P0 中心、第一圈、第二圈和远郊边界一眼可区分，不改变 26 anchor 核心编码，不误导孩子独自远行或每日必到。完成记录：`scripts/main.gd` 新增 `MapReadabilityLayer`、三组区域底纹和四个短路牌，Home / School / Town Ring / Far Edge 视觉层级可被 focused/headless 审计。
- [x] **V02-MAPREAD-004 Anchor 徽章、热点优先级和反馈短句抛光**
  Owner：Godot / UX / Narrative / QA Agent；依赖：V02-MAPREAD-002、V02-MAPREAD-003；交付物：字母徽章辅助识别、热点优先级、`看看` 反馈短句和相册回访文案抛光；验收：生活物件优先、字母徽章辅助；附近资源 / NPC / hotspot 不吞掉 anchor 相册路径；反馈不课程化、不打卡、不评价。完成记录：字母徽章尺寸提升至 28px、字体提升至 16，并为 anchor 增加 `mapread_layer` / `mapread_screenshot_group` 元数据；focused test 使用真实 `InteractButton` 验证 26 anchor 相册路径不被资源、NPC 或 hotspot 吞掉。
- [x] **V02-MAPREAD-005 地图探索 smoke、相册复核与双视口截图收口**
  Owner：QA / PM / Godot Agent；依赖：V02-MAPREAD-003、V02-MAPREAD-004；交付物：地图探索操作级 smoke、相册复核、headless runner 注册、1280x720 与 960x540 代表截图和阶段收口记录；验收：26 anchor 探索路径、旧 V02.16 / V02.17 路径和相册显示均通过；截图无明显遮挡、文本溢出、工程文案、裸字母牌或课程化文案。完成记录：新增 `docs/collaboration/Round88_V02.18_MAPREAD-002_005验收记录.md`；`tests/headless_runner.gd` 已实际执行 V02.18 可读性审计；focused、V02.17 回归、全量 headless runner 和 Godot 启动均通过。

### V02.19 实际地图与 P0 美术资产生产替换

> 本阶段把 V02.17 / V02.18 已经可走、可看、可回访的世界地图推进到 production art pass。范围固定为实际地图底图、P0 场景、26 anchor 生活物件、首批角色 / 宠物和必要 UI 图标的生产替换；正式方向为 Animal Crossing-like cozy town 世界视觉和 Apple-like translucent glass UI；不采用绘本 / storybook / picture-book；不新增课程 UI、不扩玩法系统、不重排 A-Z 编码、不把远郊做成 P0。自 2026-06-06 起，后续所有未完成验收只考虑 1280x720；960x540 等全部开发完成后再做版本适配，不作为中间阶段完成阻塞。

- [x] **V02-ARTPASS-001 V02.19 路线、资产范围和 Ready 规划**
  Owner：PM / Art Direction / Map / QA Agent；依赖：V02.18 收口、V02-PRODUCTION-005、`LESSON-009`、`LESSON-010`、`LESSON-011`；交付物：V02.19 路线、资产范围、任务拆分、Round89 PM 任务包和 Ready 队列；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 同步，下一轮唯一 Ready 明确。完成记录：新增 `docs/collaboration/Round89_V02.19_ARTPASS-001_PM执行任务包.md`；原拆分为 `V02-ARTPASS-002` 至 `005`，Round91 按新美术方向补入 `V02-ARTPASS-003 视觉方向确认包` 并将后续生产替换顺延到 `004` 至 `006`。
- [x] **V02-ARTPASS-002 实际地图与 P0 资产清单 / 接入合同审计**
  Owner：Art Direction / Asset / Tech Art / QA Agent；依赖：V02-ARTPASS-001、`docs/10_美术风格与换肤预留.md`、`data/maps/world_map.json`、`data/maps/az_world_plan.json`、`ThemeProfile` / `AssetResolver`；交付物：实际地图与 P0 资产清单、logical asset ID 表、替换目标、建议尺寸、截图点、状态定义和接入合同审计；验收：清单覆盖世界地图底图、Home / School / Town 关键场景、26 anchor、角色 / 宠物和 UI 图标；每项有用途、尺寸、状态、依赖、替换目标、截图验收点和 `AssetResolver` 接入方式；不得先批量生成不可接入素材；后续未完成任务的视觉阻塞验收只要求 1280x720，960x540 等全部开发完成后专项适配。完成记录：运行时世界地图已按 Home 居中布局迁移；`docs/collaboration/artpass002_layout_review/home_centered_layout_contract_v1.json` 已标为 runtime reference；新增 `docs/collaboration/Round90_V02.19_ARTPASS-002资产接入合同审计.md`，固定 runtime place 接入清单、26 anchor 建议 `anchor.*` logical asset ID、ARTPASS-003/004/005 分派建议和验证门槛；Round91 已补充视觉方向确认包并将生产替换顺延为 ARTPASS-004/005/006；`data/themes/theme_sunshine_town_placeholder.json` 的当前验收证据名已切到 1280 口径；JSON、AssetResolver、V02.18 可读性、全量 headless runner 和 Godot 启动均通过。
- [x] **V02-ARTPASS-003 视觉方向确认包**
  Owner：Art Direction / UI / Map / QA Agent；依赖：V02-ARTPASS-002、用户确认的 Animal Crossing-like cozy town / Apple-like translucent glass UI 方向、`docs/10_美术风格与换肤预留.md`；交付物：主玩法屏 1280x720 视觉方向稿或等效规格、Apple-like translucent glass UI 样张、角色 / Sunny / anchor 物件样张、浓缩风格规则和禁用方向；验收：世界视觉像可生活的小镇，不像绘本内页、故事书插画或课程地图；UI 透明但清晰可读、触控态稳定；PM / Art Direction 通过后才进入批量 production 资产替换。完成记录：新增 `docs/collaboration/Round92_V02.19_ARTPASS-003视觉方向确认包.md`；生成 `artpass003_main_gameplay_direction_1280.png`、`artpass003_glass_ui_direction_1280.png`、`artpass003_character_anchor_direction_1280.png` 三张 1280x720 方向样张；文件尺寸验证通过；本轮未改 runtime、数据合同或 ThemeProfile 映射。
- [x] **V02-ARTPASS-004 P0 世界地图底图与区域块替换**
  Owner：Map / Asset / Godot / QA Agent；依赖：V02-ARTPASS-003；交付物：P0 世界地图底图、Home / School / Town / Far Edge 区域块、道路、安全边界、回家线索 production 资产接入；验收：1280x720 下世界地图首屏像真实小镇，Home / School / Town / Far Edge 层次清楚，不改变 26 anchor 坐标语义、热点路径或 HUD / 底栏可读性；960x540 等全部开发完成后专项适配。完成记录：新增 `docs/collaboration/Round93_V02.19_ARTPASS-004验收记录.md`；新增世界地图底图与 9 个区域块 SVG/PNG 资产并生成 Godot import；`ThemeProfileResource`、`AssetResolver` 与 `ThemeSwitchService` 新增 `anchor_assets` 合同和 `get_anchor_asset()`；`data/themes/theme_sunshine_town_placeholder.json` 新增 10 个 `place.*` production 映射、26 个 `anchor.*` logical ID 和 ARTPASS-004 asset acceptance；`scripts/main.gd` 将 Ground、9 个 MapRead zone 和 9 个 place marker body 接入 logical asset ID；AssetResolver、V02.18 可读性、V02.17 anchor runtime、全量 headless runner、Godot 启动和 JSON 验证均通过。
- [x] **V02-ARTPASS-005 P0 场景与 26 Anchor 物件替换**
  Owner：Asset / Memory Palace / Godot / QA Agent；依赖：V02-ARTPASS-004；交付物：Home exterior、Home-School Walk、School Gate、School Yard、Town Plaza、Shop / Bookshop / Bus Stop 场景外观与 26 anchor 生活物件 production 替换；验收：每个 anchor 先像生活物件，字母徽章只辅助；School line 不堆叠、不课程化；真实 `看看` 路径、热点优先级和相册落账保持通过。完成记录：新增 `docs/collaboration/Round94_V02.19_ARTPASS-005验收记录.md`；新增 `assets/art/anchors/anchor_*.svg/.png` 26 个 A-Z 生活物件资产和 Godot import；新增 `scripts/tools/generate_artpass005_anchor_assets.js` 用于稳定生成并同步 `anchor_assets` 映射；`data/themes/theme_sunshine_town_placeholder.json` 的 26 个 `anchor.*` logical ID 已指向 production PNG 并具备 acceptance records；`scripts/main.gd` 将 26 个 runtime anchor ObjectSprite texture key 接入 `anchor_assets`；AssetResolver、V02.18 可读性、V02.17 anchor runtime、全量 headless runner、Godot 启动和 JSON 验证均通过。
- [x] **V02-ARTPASS-006 角色 / 宠物 / UI 资产替换与截图收口**
  Owner：Character Art / UI / Godot / QA Agent；依赖：V02-ARTPASS-005；交付物：Player、Mina、Sunny、Shopkeeper、Story Bear、Bus Helper、背包 / 相册 / 商店 / 设置 / 金币等首批 UI 图标和 glass UI 皮肤 production 替换、1280x720 截图和阶段收口记录；验收：风格统一，移动端可读可触；`production` / `approved` 状态清楚；AssetResolver 测试、旧玩家路径 smoke、26 anchor smoke、Godot 启动和 1280x720 截图通过；960x540 等全部开发完成后专项适配。
  完成记录：新增并接入 `assets/art/places/world_map_base_1280.png`、9 个区域 PNG、`assets/art/anchors/anchor_*.png` 26 个 160x160 anchor 物件和 `assets/art/ui/skin/glass_*.png` glass UI 皮肤；`data/themes/theme_sunshine_town_placeholder.json` 的 `place_assets`、`anchor_assets` 与 `ui_skin` 已指向 production PNG；`scripts/main.gd` 用 logical asset ID 加载地图底图、anchor 物件和 glass HUD / footer / panel / button skin，并将区域 / place 生产贴图降为极淡 runtime metadata，让 1280 底图成为主视觉；新增 `docs/collaboration/round95_visual_acceptance/shot_round95_runtime_1280.png` 与 `docs/collaboration/Round95_V02.19_ARTPASS-006样张驱动美术返工验收记录.md`。验证：`find data -name '*.json' -print0 | xargs -0 jq empty`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0217_worldmap_anchor_runtime.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v0216_playable_rc_gate.gd`、`tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；MCP runtime proof 为 1280x720；无新增已验证教训。
- [x] **V02-ARTPASS-007 全屏构图与 UI 风格返修**
  Owner：UX / UI / Godot / QA Agent；依赖：V02-ARTPASS-006；交付物：1280x720 playfield 全屏化、旧路格弱化、HUD / footer 轻玻璃 overlay、底栏按钮比例统一和验收记录；验收：地图不再像嵌在窗口里，底部按钮和背包 icon 尺寸统一，常驻 UI 不遮挡核心探索。完成记录：`scripts/main.gd` 已移除主场景外层 SafeArea 边距并将 runtime 地图缩放铺满 1280x720 playfield；新增 `docs/collaboration/Round96_V02.19_ARTPASS-007全屏构图与UI返修验收记录.md` 和 `docs/collaboration/round96_visual_acceptance/shot_production005_town_plaza_round96_final_1280.png`；focused / headless / 非 headless 1280 截图验证通过。
- [x] **V02-ARTPASS-008 Round92 样张风格剩余 runtime 素材补齐**
  Owner：Art Direction / Asset / Godot / QA Agent；依赖：V02-ARTPASS-003、V02-ARTPASS-006、V02-ARTPASS-007；交付物：仍在 runtime 映射中使用的 place、UI icon、Sunny、家具和角色 PNG 按 Round92 样张风格外部生成并覆盖原路径；验收：保持 existing logical asset ID、ThemeProfile / AssetResolver 映射、gameplay、地图坐标、A-Z anchor 结构和 UI 布局不变；透明类素材具备可抠图 alpha；`asset_acceptance` 标 `production` 而非 `approved`；JSON、AssetResolver、Playable RC、UI 操作、headless runner 和 Godot 启动验证通过。
  完成记录：使用项目约定外部生成脚本逐张生成并重试超时项，覆盖 `assets/art/places/` 13 个 runtime PNG、`assets/art/ui/icons/` 5 个 icon、`assets/art/pets/sunny_standing.png`、3 个家具和 5 个角色；透明类素材已做边缘连通背景抠除；新增 `docs/collaboration/Round97_V02.19_ARTPASS-008剩余runtime素材补齐验收记录.md` 与 `docs/collaboration/round97_artpass008_preview.png`；`data/themes/theme_sunshine_town_placeholder.json` 已更新 27 个 `asset_acceptance` 记录为 `production` / `pass`，不标 `approved`；静态和 Godot 验证均通过。
- [x] **V02-ARTPASS-009 资源 branch Round92 样张风格漏项补齐**
  Owner：Art Direction / Asset / Godot / QA Agent；依赖：V02-ARTPASS-008；交付物：`place.resource.branch` 对应 `assets/art/resources/branch.png` 按 Round92 样张风格外部生成并覆盖原路径；验收：保持 resource collection path、Bear Corner story binding、logical asset ID、ThemeProfile / AssetResolver 映射、gameplay、A-Z anchor 结构和 UI 布局不变；透明 PNG 尺寸保持 96x96；`asset_acceptance` 标 `production` 而非 `approved`。
  完成记录：使用项目约定外部生成脚本生成 branch raw，做边缘连通背景抠除后覆盖 `assets/art/resources/branch.png`；新增 `docs/collaboration/Round98_V02.19_ARTPASS-009资源branch漏项补齐验收记录.md` 与 `docs/collaboration/round98_artpass009_branch_preview.png`；`data/themes/theme_sunshine_town_placeholder.json` 已更新 `place.resource.branch` 的 `asset_acceptance` 为 `production` / `pass`；静态和 Godot 验证通过。
- [x] **V02-ARTPASS-010 运行时视觉验收与发布候选整理**
  Owner：Art Direction / QA / Godot Agent；依赖：V02-ARTPASS-006 至 V02-ARTPASS-009；交付物：1280x720 runtime proof 截图包、运行时视觉审查记录、必要的接入层比例 / alpha / z-index 小修和发布候选结论；验收：Town Plaza、Home、Shop、School Gate、School Yard、resource branch、Album、Settings 画面无明显遮挡、比例失衡、透明边缘问题、旧占位突兀感、课堂 / 成绩 / 战斗 / 警报视觉或强消费感；保持 gameplay、地图坐标、A-Z anchor 结构、logical asset ID 和 UI 主布局不变。
  完成记录：新增 `docs/collaboration/Round99_V02.19_ARTPASS-010运行时视觉验收与发布候选记录.md` 和 `docs/collaboration/round99_runtime_visual_acceptance/` 截图包；`scripts/main.gd` 将旧 RoadCell、hotspot glow、花树辅助层进一步降噪，让 production 底图成为主视觉；恢复 28px / 16 字号字母徽章合同；修复 `MemoryAlbumOverlay` 层级，打开相册时隐藏 TownStage，避免地图字母徽章穿透到相册卡片；导出 Town Plaza、Home、Shop、Album、Settings 1280x720 proof；`find data -name '*.json' -print0 | xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/main.gd`、`tests/test_asset_resolver.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0217_worldmap_anchor_runtime.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v0216_playable_rc_gate.gd`、`tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；无残留 headless 测试进程；无新增已验证教训。

### V02.20 可居住小镇重建

> 本阶段把 V02.19 的 1280 art baseline 推进到 playgate。V02.19 只证明 production art 已按 logical asset ID 接入并在 1280x720 proof 中可用，不等同 product complete。V02.20 聚焦首屏居住感、真实入口、生活动线、UI 可读可触、旧玩家路径回归和 approved 判定；不新增课程 UI、不扩远郊 P0、不重排 A-Z 编码、不把 Letter Snake 重新变成主线。

- [x] **V02-PLAYGATE-001 V02.20 可居住小镇重建路线、任务队列和 Ready 规划**
  Owner：PM / QA / Art Direction Agent；依赖：V02-ARTPASS-010、Round99 runtime proof、`LESSON-007`、`LESSON-009`、`LESSON-010`、`LESSON-011`；交付物：V02.20 路线、V02.19 1280 art baseline 收口口径、PLAYGATE-001..009 队列、Round100 PM 任务包和下一轮 Ready；验收：`docs/12`、`docs/13`、`docs/15`、`todo.md` 同步，V02.19 不标 product complete，下一轮唯一 Ready 明确。完成记录：新增 `docs/collaboration/Round100_V02.20_PLAYGATE-001_PM执行任务包.md`；V02.20 队列已建立；下一轮唯一 Ready 为 `V02-PLAYGATE-002 首屏可居住小镇 QA 审计与缺口清单`；本轮仅改 PM / QA 文档和台账，未改 runtime code、tests、data 或 assets。
- [x] **V02-PLAYGATE-002 首屏可居住小镇 QA 审计与缺口清单**
  Owner：QA / UX / Art Direction Agent；依赖：V02-PLAYGATE-001、Round99 runtime proof；交付物：Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings 审计表、截图缺口、玩家感知问题清单和缺口分级；验收：只基于现有 proof / 文档 / 台账审计，不改 runtime、tests、assets 或 data；列出阻塞 playgate、可后续优化、版本适配专项；不新增课程 UI、远郊 P0、真实联网或商业化任务。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-002首屏可居住小镇QA审计与缺口清单.md` 已落地，明确 V02.19 只能作为 1280 art baseline，不自动 product complete 或 approved。
- [x] **V02-PLAYGATE-003 启动到 5 分钟自由生活 playgate smoke 规格**
  Owner：UX / Godot / QA Agent；依赖：V02-PLAYGATE-002；交付物：启动、移动、看看、NPC、资源、商店、小屋、Sunny、相册、设置的真实入口 smoke 规格；验收：每一步来自孩子端真实可见入口，不用隐藏 contract 按钮。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-003_007自由生活smoke规格与旧路径回归矩阵.md` 已固定 3-5 分钟真实入口 smoke 规格，后续由 V02-LIVEGATE-004 实现。
- [x] **V02-PLAYGATE-004 居民、资源、家具和 anchor 空间分层返修方案**
  Owner：Map / UX / Art Direction / QA Agent；依赖：V02-PLAYGATE-002；交付物：空间层级、热点优先级、生活用途可读性返修建议；验收：不改 A-Z ID / route_order，不让资源 / NPC / anchor 热点互相吞掉。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md` 已固定空间分层和热点优先级规则。
- [x] **V02-PLAYGATE-005 HUD / 底栏 / 弹层 / 相册可读可触摸返修方案**
  Owner：UI / UX / QA Agent；依赖：V02-PLAYGATE-002；交付物：HUD、底栏、弹层、相册的 1280x720 可读可触问题清单和返修建议；验收：无明显遮挡、文字溢出或关闭路径不清；960x540 保留到全部开发完成后专项适配。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md` 已固定 1280 UI 返修门槛。
- [x] **V02-PLAYGATE-006 孩子端文本和生活反馈 playgate 审校**
  Owner：Narrative / Child Safety / QA Agent；依赖：V02-PLAYGATE-002；交付物：可见文本审校清单和替换建议；验收：温暖短句、生活化反馈，无课程、测试、评分、打卡、倒计时、错过或工程文案。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-006孩子端文本与生活反馈审校.md` 已落地，文本不阻塞 playgate。
- [x] **V02-PLAYGATE-007 V02.8-V02.19 旧玩家路径回归矩阵**
  Owner：QA / Godot Agent；依赖：V02-PLAYGATE-003；交付物：旧玩家路径保留 / 退化 / 待返修矩阵；验收：每日小镇、小屋、A-Z、天气、Home / School、P1、Playable RC 和 art pass 后路径均有结论。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-003_007自由生活smoke规格与旧路径回归矩阵.md` 已列出保留 / 退化 / 待返修矩阵。
- [x] **V02-PLAYGATE-008 1280 release-candidate 截图包和 approved 判定**
  Owner：Art Direction / PM / QA Agent；依赖：V02-PLAYGATE-004、V02-PLAYGATE-005、V02-PLAYGATE-006、V02-PLAYGATE-007；交付物：1280 release-candidate 截图包、`production` / `approved` 判定记录；验收：只有 PM / Art Direction 截图判断通过的视图才能标 `approved`。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md` 已判定 Town / Shop / Album / Settings 仅为 1280 art baseline approved，Home、School Gate、School Yard 仍 needs_fix。
- [x] **V02-PLAYGATE-009 V02.20 playgate 收口与下一阶段决策**
  Owner：PM / QA Agent；依赖：V02-PLAYGATE-008；交付物：V02.20 收口记录、下一阶段决策和 ledger sync；验收：明确进入内容扩展、移动适配专项或继续居住感返修；完成记录和 lessons 复核完成。完成记录：`docs/collaboration/Round101_V02.20_PLAYGATE-009收口与下一阶段决策.md` 已决定下一阶段继续 V02.21 居住感返修实现。

### V02.21 可居住小镇返修实现

> 本阶段把 V02.20 playgate 审计结果落到运行时体验。V02.21 不新增课程 UI、不扩远郊 P0、不重排 A-Z 编码、不进入 960x540 专项；先把 1280 主体验修成更能生活的小镇。

- [x] **V02-LIVEGATE-001 空间分层与热点优先级返修**
  Owner：Map / UX / Godot / QA Agent；依赖：V02-PLAYGATE-009、`LESSON-009`、`LESSON-011`；交付物：Town / Home / Shop / School line 的居民、资源、anchor、place 分层返修，`看看` prompt 稳定规则和 focused/headless 验证；验收：不改 A-Z ID / route_order；资源 / NPC / anchor / place 不互吞；真实入口和旧路径回归通过。完成记录：`scripts/main.gd` 已将 exact place / resource / anchor 作为明确目标，NPC 优先于附近非精确资源 / anchor；新增 `tests/test_v0221_livegate_hotspot_priority.gd` 并注册 `tests/headless_runner.gd`，focused、V02.18、V02.20、全量 headless 验证通过。
- [x] **V02-LIVEGATE-002 Home 居住感和直接家具操作返修**
  Owner：Home Design / Godot / UI / QA Agent；依赖：V02-LIVEGATE-001；交付物：小屋居住感、家具选择 / 摆放 / 旋转 / 挪动 / 收起可见操作、Sunny 反馈和保存重载验证；验收：Home 不再只是功能网格，孩子端操作不依赖服务直调或隐藏按钮。完成记录：`scripts/main.gd` 已新增 Home 窗、阳光、墙钟、置物架、门垫、宠物角和当前家具状态；`tests/test_playable_ui_operations.gd` 覆盖可见 Home 入口、生活细节、摆放 / 旋转 / 挪动 / 收起、Sunny 反馈和保存重载；focused、V02.8 纵切、全量 headless 验证通过。
- [x] **V02-LIVEGATE-003 Shop / School line 到达感与局部 proof**
  Owner：Map / Art Direction / QA Agent；依赖：V02-LIVEGATE-001；交付物：Shop、School Gate、School Yard 地点到达感返修和同轮 1280 RC proof；验收：生活用途清楚、无课程化，截图和旧路径回归通过。完成记录：`scripts/main.gd` 已新增 Shop / School Gate / School Yard arrival proof 面板和短到达反馈，入口格优先识别 interaction `place_id`；新增 `tests/test_v0221_livegate_shop_school_arrival.gd` 并注册 `tests/headless_runner.gd`；focused、V02.18、V02.20、热点优先级、全量 headless 验证通过。
- [x] **V02-LIVEGATE-004 3-5 分钟自由生活 smoke 实现**
  Owner：QA / Godot Agent；依赖：V02-LIVEGATE-001、V02-LIVEGATE-002、V02-LIVEGATE-003；交付物：focused test 与 runner 集成；验收：启动、移动、看看、NPC、资源、商店、小屋、Sunny、相册、设置全部来自真实入口，不使用隐藏 contract 按钮。完成记录：新增 `tests/test_v0221_livegate_free_life_smoke.gd` 并注册 `tests/headless_runner.gd`，覆盖启动 HUD、连续行走、Mina 委托、树枝资源、商店买椅子、背包打开相册、小屋摆放、Sunny 反馈、School Gate 看看、设置休息确认 / 取消和安全位置；focused、main check-only、全量 headless runner 和 Godot 启动验证通过。
- [x] **V02-LIVEGATE-005 1280 RC 截图包与二次 approved 判定**
  Owner：PM / Art Direction / QA Agent；依赖：V02-LIVEGATE-004；交付物：Town、Home、Shop、School Gate、School Yard、Album、Settings 同轮 1280 proof 和 approved / needs_fix 判定；验收：PM / Art Direction 明确判定，不把 `production` 自动当 approved。完成记录：新增 `tests/capture_livegate005_rc.gd` 和 `docs/collaboration/round106_livegate005_rc/` 七张 1280x720 runtime proof；新增 `docs/collaboration/Round106_V02.21_LIVEGATE-005_1280_RC截图与二次判定.md`，判定 `Album` 为 V02.21 playgate approved，Town / Home / Shop / School Gate / School Yard / Settings 保留 `needs_fix`，不把 `production` 或旧轮次 proof 误写为 product approved；capture、focused、headless runner 和 Godot 启动验证通过。

### V02.22 隐藏网格生活小镇与 scenes 组件化

> 本阶段把“Animal Crossing-like 隐藏网格生活小镇”和“Godot scenes 组件化”合并推进。底层继续使用 `world_map` cell / footprint / occupied cells 管理移动、碰撞、热点、摆放、刷新、NPC routine、A-Z anchor 和保存；孩子端不显示格子、瓦块、坐标或调试术语。拆分 scenes 只改变工程边界，不改变已通过的真实入口、保存结构、logical asset ID 或 A-Z 记忆宫殿稳定编码。

- [x] **V02-HIDDENGRID-001 V02.22 路线、架构边界和任务包**
  Owner：PM / Tech Lead / QA Agent；依赖：V02-LIVEGATE-005；交付物：V02.22 总路线、scene 拆分顺序、隐藏网格内容边界、禁改范围、验收矩阵、Round107 任务包和台账同步；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 与协作文档同步，下一轮唯一 Ready 明确，本轮不改 runtime。完成记录：新增 `docs/collaboration/Round107_V02.22_HIDDENGRID-001_PM执行任务包.md`；文档链路已把 V02.22 固定为隐藏网格生活小镇与 scenes 组件化大阶段，下一轮 Ready 为 `V02-HIDDENGRID-002 TownStage scene 抽离`。
- [x] **V02-HIDDENGRID-002 TownStage scene 抽离**
  Owner：Godot / Map / QA Agent；依赖：V02-HIDDENGRID-001；交付物：`scenes/world/town_stage.tscn`、TownStage 脚本、地图显示 / 输入 / 节点生成抽离、旧路径回归；验收：主场景仍可从真实入口启动；地图缩放、点击到 cell、玩家连续行走、热点提示、26 anchor、资源、NPC 和 3-5 分钟 free life smoke 不退化；不改 A-Z ID / route_order、save key 或 logical asset ID。完成记录：新增 `scenes/world/town_stage.tscn` 与 `scripts/stages/town_stage.gd`，由 TownStage 管理 `RuntimeMapFrame`、`RuntimeMapInput`、`RuntimeMap`、地图节点生成、玩家 marker、点击到 cell 信号和局部镜头；`scripts/main.gd` 保留旧字段和 `move_player_by_cells` / `request_player_walk_to_cell` / `finish_player_walk_for_test` / `move_player_to_cell` / `get_current_interaction_target` facade，不迁移业务互动、保存结构、A-Z ID / route_order 或 logical asset ID；focused、headless runner 和 Godot 启动验证通过。
- [x] **V02-HIDDENGRID-003 Actor / Interactable scene 抽离**
  Owner：Godot / UX / QA Agent；依赖：V02-HIDDENGRID-002；交付物：`PlayerActor`、`NPCActor`、`InteractableObject`、`AnchorObject`、`ResourceObject`、place hotspot prefab / scene 和统一占格 / 交互接口；验收：NPC / resource / anchor / place 优先级稳定，A-Z 相册落账、资源同日去重、NPC 问候和旧玩家路径回归通过。完成记录：新增 `scenes/world/actors/player_actor.tscn`、`npc_actor.tscn`、`resource_object.tscn`、`anchor_object.tscn`、`interactable_object.tscn` 及对应脚本；`TownStage` 改为实例化 prefab 管理 Player、NPC、Resource、Anchor、Place marker 和 hotspot，并保留旧节点名 / metadata / `Main` facade；新增 `tests/test_v0222_actor_prefab_split.gd` 并注册 `tests/headless_runner.gd`，验证 prefab 脚本接入、交互优先级和旧玩家路径；focused、map readability、A-Z runtime、free life smoke、Playable UI、headless runner 和 Godot 启动均通过。
- [x] **V02-HIDDENGRID-004 UI scenes 抽离**
  Owner：UI / Godot / QA Agent；依赖：V02-HIDDENGRID-003；交付物：TownHUD、TownFooter、Backpack、Shop、Home、Album、Settings 等 scene / panel scripts；验收：底栏、背包、商店、小屋、相册、设置可见入口和关闭路径不退化；儿童安全文本、focused UI tests 和 headless runner 通过。完成记录：新增 `scenes/world/ui/town_hud.tscn`、`scenes/world/ui/town_footer.tscn`、`scripts/ui/town_hud.gd`、`scripts/ui/town_footer.gd`；`Main` 改为实例化 TownHUD / TownFooter scene，并保留 `status_label`、`coin_label`、`pet_label`、底栏按钮、背包、商店、小屋、相册和设置旧入口；新增 `tests/test_v0222_ui_scene_split.gd` 并注册 `tests/headless_runner.gd`，覆盖 HUD/Footer scene script、label facade、背包、相册、设置路径；focused、Playable UI、headless runner 验证通过。
- [x] **V02-HIDDENGRID-005 户外装饰、资源 2.0 与 NPC routine 隐藏网格纵切**
  Owner：Game Design / Godot / QA Agent；依赖：V02-HIDDENGRID-003、V02-HIDDENGRID-004；交付物：户外装饰数据与保存、自然资源刷新、NPC routine fallback、地点停留反馈；验收：至少一个户外装饰可摆 / 挪 / 收并保存重载；资源刷新温和；NPC routine 不阻断 P0；A-Z anchor 稳定；孩子端不出现格子、瓦块、坐标、编辑器或调试术语。完成记录：新增 `OutdoorDecorationService`、`NPCRoutineService`、`data/life/npc_routines.json` 和资源点 `refresh_rule`；`ResourceRefreshService` 暴露 `get_refresh_summary()`；`Main` 接入户外摆放 / 挪动 / 收起 facade、NPC routine snapshot 和 routine 后 NPC 坐标；`TownStage` 渲染 `OutdoorDecorLayer`；新增 `tests/test_v0222_hidden_grid_life_systems.gd` 并注册 `tests/headless_runner.gd`，覆盖户外装饰保存 / 地图节点、资源 2.0 摘要、NPC routine fallback 和旧 NPC 互动优先级；focused、热点优先级、free life smoke、Playable UI、headless runner 和 Godot 启动验证通过。
- [x] **V02-HIDDENGRID-006 3-5 分钟回归、1280 proof 和阶段收口**
  Owner：QA / PM / Art Direction Agent；依赖：V02-HIDDENGRID-005；交付物：focused smoke、headless runner 集成、Godot 启动验证、Town / Home / Shop / School line / Album / Settings 1280 proof、approved / needs_fix 判定；验收：scene 拆分和隐藏网格生活系统均通过真实入口验证；不把重构完成、production 或旧 proof 误标为 product complete / approved。完成记录：新增 `tests/test_v0222_hiddengrid_final_smoke.gd`、`tests/capture_hiddengrid006_rc.gd`、`docs/collaboration/round112_hiddengrid006_rc/` 6 张 1280 proof 和 `docs/collaboration/Round112_V02.22_HIDDENGRID-006阶段收口与1280proof.md`；final smoke、headless runner、Godot 启动和截图尺寸验证通过；V02.22 六项任务可阶段收口，但产品状态仍不标 product complete / approved。
- [x] **V02-HIDDENGRID-007 Scene-native map + UI panel refactor**
  Owner：Godot / Map / UI / QA Agent；依赖：V02-HIDDENGRID-006；交付物：`TownMapAuthoring` authoring scene、固定 runtime layers、Backpack / Settings / Shop / MemoryAlbumOverlay / HomeRoom panel scenes、focused tests 和 runner 注册；验收：地图可由 Godot authoring scene 导出 dictionary 并通过 `WorldMapContract`；`TownStage.setup()` 按固定 layer 分发 road / place / hotspot / anchor / resource / NPC / player；Home / Shop / Backpack / Album / Settings 可见入口与关闭路径不退化；runtime 仍读 `data/maps/world_map.json`，save key、A-Z anchor ID / route_order 和 logical asset ID 不变。完成记录：新增 `tests/test_town_map_authoring_export.gd`、`tests/test_town_stage_layered_runtime.gd`、`tests/test_v0223_ui_panel_scene_split.gd` 并注册进 `tests/headless_runner.gd`；`scripts/editor/town_map_authoring.gd` 的 authoring export 只同步 marker position，避免未编辑 footprint 时改写既有 occupied cells；focused、旧 UI / actor / hidden-grid / playable / map / A-Z 回归、全量 headless runner 和 Godot 启动均通过；无新增已验证教训。

### V02.23 体验批准线

> 本阶段已完成体验批准线。Round119 仅使用同轮 1280 RC proof、真实入口 smoke 和 PM / Art Direction 逐项判定收口：Album 回归无可见退化并保持 approved；Town Plaza / World Map、Home、Shop、School Gate、School Yard、Settings 均逐项升级为 approved。V02.22 scene-native / hidden-grid 架构完成仍不等同 product approved；`tests/test_v0223_ui_panel_scene_split.gd` 是 Round113 HIDDENGRID-007 回归证据，不作为 V02.23 批准证据。

- [x] **V02-EXPAPPROVAL-001 V02.23 体验批准线 PM 任务包与判定矩阵**
  Owner：PM / Art Direction / QA Agent；依赖：V02-HIDDENGRID-007、Round106、Round112；交付物：V02.23 体验批准线 PM 任务包、approved / needs_fix 判定矩阵、1280 RC 截图清单、禁改范围、V02.24-V02.26 后续路线和台账同步；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 与 Round114 任务包同步；只把 `V02-EXPAPPROVAL-002` 作为收口后的唯一 Ready；不改 runtime、tests、assets 或 data；不把 `production`、重构完成、headless 通过或旧 proof 自动写成 approved。完成记录：新增 `docs/collaboration/Round114_V02.23_EXPAPPROVAL-001_PM执行任务包.md`，同步 V02.23-V02.26 路线、批准事实、判定矩阵、截图清单、禁改范围、V02.25 双阶段写回和 V02.26 小批量内容边界；`rg` 静态一致性检查和 `godot --headless --path . --quit` 通过；无新增已验证教训。
- [x] **V02-EXPAPPROVAL-002 Town Plaza 首屏生活密度与 anchor 降噪返修**
  Owner：Map / UX / Art Direction / QA / Godot Agent；依赖：V02-EXPAPPROVAL-001；交付物：Town Plaza / World Map 首屏生活密度、A-Z anchor 降噪、NPC / resource / place 层次返修、focused smoke 和 1280 proof；验收：居民、资源、anchor、place 不互吞；首屏像可生活小镇；A-Z ID / route_order 不变；真实入口和同轮 1280 proof 支撑判定。完成记录：新增 `PlazaLifeLayer`、anchor badge 降噪、`tests/test_v0223_expapproval_town_plaza_density.gd`、`tests/capture_expapproval002_town_plaza.gd`、`docs/collaboration/round115_expapproval002_town_plaza/` 三张 1280 proof 和 `docs/collaboration/Round115_V02.23_EXPAPPROVAL-002_TownPlaza首屏生活密度与anchor降噪验收记录.md`；focused / full headless / Godot 启动 / 非 headless 1280 capture 均通过；不把 Town Plaza 自动标 approved。
- [x] **V02-EXPAPPROVAL-003 Home 居住密度与小屋视觉批准返修**
  Owner：Home Design / UI / QA / Godot Agent；依赖：V02-EXPAPPROVAL-002；交付物：Home 默认生活角、Sunny 反馈、家具状态和小屋视觉密度返修；验收：可见家具操作、保存重载和 Sunny 反馈不退化；不改 HomeDecorationService 存档结构；1280 proof 可判定。完成记录：新增 `HomeLifeLayer` 与 6 个非交互默认生活细节；Home 家具状态文案改为孩子端小角落语言，不显示格子 / 坐标 / 占格术语；新增 `get_expapproval_home_snapshot()`、`tests/test_v0223_expapproval_home_living_density.gd`、`tests/capture_expapproval003_home.gd`、`docs/collaboration/round116_expapproval003_home/` 三张 1280 proof 和 `docs/collaboration/Round116_V02.23_EXPAPPROVAL-003_Home居住密度与小屋视觉批准返修验收记录.md`；focused / full headless / Godot 启动 / 非 headless 1280 capture 均通过；不把 Home 自动标 approved。
- [x] **V02-EXPAPPROVAL-004 Shop / Settings glass UI 可读可触批准返修**
  Owner：UI / UX / QA / Godot Agent；依赖：V02-EXPAPPROVAL-003；交付物：Shop / Settings glass UI 可读性、触控、关闭路径和反馈返修；验收：复杂地图背景上 panel 清楚；购买、休息确认、回安全位置来自可见入口；文本不溢出。完成记录：Shop / Settings panel scene script 加固为更宽、更清楚的 glass panel，Shop 商品按钮和 Settings 控件统一 46px 触控高度；新增 `get_expapproval_shop_settings_snapshot()`、`tests/test_v0223_expapproval_shop_settings_glass.gd`、`tests/capture_expapproval004_shop_settings.gd`、`docs/collaboration/round117_expapproval004_shop_settings/` 三张 1280 proof 和 `docs/collaboration/Round117_V02.23_EXPAPPROVAL-004_ShopSettings玻璃UI可读可触批准返修验收记录.md`；focused / playable UI / panel split / full headless / Godot 启动 / 非 headless 1280 capture 均通过；不把 Shop 或 Settings 自动标 approved。
- [x] **V02-EXPAPPROVAL-005 School Gate / School Yard 生活地点化与噪声返修**
  Owner：Map / Narrative / Art Direction / QA / Godot Agent；依赖：V02-EXPAPPROVAL-004；交付物：School Gate / School Yard 生活地点化、School line anchor / HUD 噪声返修和局部 proof；验收：校门 / 操场像生活地点，不出现课程、测试、作业、分数或课堂压力；真实入口和 1280 proof 通过。完成记录：新增 School Gate / School Yard 非交互生活细节、短到达 proof 和 `get_expapproval_school_snapshot()`；新增 `tests/test_v0223_expapproval_school_gate_yard_life_noise.gd`、`tests/capture_expapproval005_school_gate_yard.gd`、`docs/collaboration/round118_expapproval005_school_gate_yard/` 四张 1280 proof 和 `docs/collaboration/Round118_V02.23_EXPAPPROVAL-005_SchoolGateYard生活地点化与噪声返修验收记录.md`；focused / Shop-School arrival / playable UI / panel split / full headless / Godot 启动 / 非 headless 1280 capture 均通过；School Gate / School Yard 仍不标 approved，等待 `V02-EXPAPPROVAL-006` 逐项判定。
- [x] **V02-EXPAPPROVAL-006 1280 RC 截图包、真实入口 smoke 与逐项 approved 判定**
  Owner：QA / PM / Art Direction Agent；依赖：V02-EXPAPPROVAL-002、V02-EXPAPPROVAL-003、V02-EXPAPPROVAL-004、V02-EXPAPPROVAL-005；交付物：同轮 1280 RC 截图包、真实入口 smoke、Album 回归和逐项 approved / needs_fix 判定记录；验收：只有 PM / Art Direction 判断通过的视图升级 approved；旧 proof、headless 逻辑验证、`production` 状态或 V02.22 架构完成不得自动作为批准依据。完成记录：新增 `tests/test_v0223_expapproval006_rc_smoke.gd`、`tests/capture_expapproval006_rc.gd`、`docs/collaboration/round119_expapproval006_rc/` 16 张 1280x720 RC proof 和 `docs/collaboration/Round119_V02.23_EXPAPPROVAL-006_1280_RC截图包真实入口smoke与逐项判定记录.md`；真实入口 smoke、capture check-only、V02.21 free life、Playable UI、Shop-School arrival、map readability、panel split、V02.23 EXPAPPROVAL-002..005 focused tests、headless runner、Godot 启动、非 headless 1280 capture 和 PNG 尺寸复核均通过；Album 回归保持 approved，Town Plaza / World Map、Home、Shop、School Gate、School Yard、Settings 按本轮证据逐项升级 approved；下一轮 Ready 为 `V02-HOMEPLAZA-001 PM 路线与禁改边界`。

### V02.24 Home / Town Plaza 居住感加固

> 本阶段已在 V02.23 体验批准线之后进入实现队列。Round120 已固定 V02.24 路线、任务拆分、禁改边界和测试计划；目标是补 Home 默认生活角、Sunny 反馈、家具状态、Town Plaza 停留点、户外装饰 allowed place / footprint / 禁覆盖规则和 NPC routine 到达感；不改 HomeDecorationService 存档结构，不显示格子 / 坐标 / 占格术语。

- [x] **V02-HOMEPLAZA-001 PM 路线与禁改边界**
  Owner：PM / Home Design / Map / QA Agent；依赖：V02-EXPAPPROVAL-006；交付物：V02.24 路线、任务拆分、禁改边界和 Ready 队列；验收：下一项 Ready 明确；不改存档结构或 A-Z 编码。完成记录：新增 `docs/collaboration/Round120_V02.24_HOMEPLAZA-001_PM路线与禁改边界.md`，固定 V02.24 输入事实、阶段目标、V02-HOMEPLAZA-001..005 队列、禁改范围、验收矩阵和测试计划；明确默认生活角不写入 `home_state.placed_furniture`，不改 HomeDecorationService 存档结构，不改 26 个 A-Z anchor / route_order / 相册语义，孩子端不显示格子 / 坐标 / 占格 / footprint / debug 术语；同步 `docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 和 `lessons.md`；静态一致性检查和 Godot 启动验证通过；下一轮 Ready 为 `V02-HOMEPLAZA-002 HomeRoom 居住感加固`。
- [x] **V02-HOMEPLAZA-002 HomeRoom 居住感加固**
  Owner：Home Design / UI / Godot / QA Agent；依赖：V02-HOMEPLAZA-001；交付物：Home 默认生活角、Sunny 反馈、家具状态和 HomeRoom 视觉密度；验收：可见操作、保存、Sunny 反馈和截图通过。完成记录：新增 `HomeDefaultBookStack`、`HomeDefaultSunnyToy`、`HomeDefaultWarmCup` 三个 HomeLifeLayer 默认生活细节，强化空状态与 Sunny 小屋反馈文案；`get_expapproval_home_snapshot()` 增加 `v02.24_homeplaza_002` living contract 标识；新增 `tests/test_v0224_home_room_living_contract.gd` 并注册 `tests/headless_runner.gd`，覆盖默认生活角不少于 9 个细节、默认细节不写入 `placed_furniture`、可见按钮摆放 pet bowl / Sunny bed、Sunny 反馈刷新、保存 state 只持久化玩家摆放家具和儿童文本无技术术语；`godot --headless --path . --script tests/test_v0224_home_room_living_contract.gd`、`godot --headless --path . --check-only --script scripts/stages/home_room.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0223_expapproval_home_living_density.gd`、`godot --headless --path . --quit` 和 `godot --headless --path . --script tests/headless_runner.gd` 均通过；不改 HomeDecorationService 存档结构，不改 A-Z anchor / route_order / 相册语义；下一轮 Ready 为 `V02-HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则`。
- [x] **V02-HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则**
  Owner：Map / Game Design / Godot / QA Agent；依赖：V02-HOMEPLAZA-001；交付物：Town Plaza 停留点、allowed place / footprint / 禁覆盖规则和 focused test；验收：户外装饰不覆盖核心 anchor、place 或交互入口。完成记录：`OutdoorDecorationService` 增加 plaza-side allowed zones、item footprint、protected anchor / interaction / resource / NPC / place 检查和 allowed-place summary；`TownStage` 增加 PlazaChatStool、PlazaSnackCrate 两个非交互停留点并在 snapshot 输出 `plaza_stay_point_count` / `outdoor_decor_count`；新增 `tests/test_v0224_town_plaza_outdoor_decor_rules.gd` 并注册 `tests/headless_runner.gd`，覆盖安全角落摆放 / 挪动、非 plaza 区域拒绝、Home entry / Taxi anchor / Taxi stone / Mina / 大件 footprint 覆盖拒绝、已摆物件重叠拒绝、runtime 渲染 outdoor decor 和 26 A-Z anchor 保持；`godot --headless --path . --check-only --script scripts/systems/outdoor_decoration_service.gd`、`scripts/stages/town_stage.gd`、`scripts/main.gd`、`tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0224_town_plaza_outdoor_decor_rules.gd`、`tests/test_v0222_hidden_grid_life_systems.gd`、`tests/test_v0223_expapproval_town_plaza_density.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；不改 A-Z anchor / route_order / 相册语义；下一轮 Ready 为 `V02-HOMEPLAZA-004 NPC routine 与广场到达感`。
- [x] **V02-HOMEPLAZA-004 NPC routine 与广场到达感**
  Owner：NPC / Map / Godot / QA Agent；依赖：V02-HOMEPLAZA-003；交付物：NPC routine 到达感、fallback 和广场停留反馈；验收：P0 NPC 不因 routine、天气或装饰阻断入口。完成记录：`NPCRoutineService` 增加 world map arrival safety、protected anchor / interaction / place / collision 检查、blocked routine fallback、arrival zone 和温和 arrival text；`scripts/main.gd` 向 routine service 注入 world map；新增 `tests/test_v0224_npc_routine_arrival_safety.gd` 并注册 `tests/headless_runner.gd`，覆盖安全 Plaza routine、坏数据 fallback、缺失 routine fallback、Mina / Shopkeeper 可达 prompt、anchor / interaction arrival 拒绝和 plaza arrival count；`godot --headless --path . --check-only --script scripts/systems/npc_routine_service.gd`、`scripts/main.gd`、`tests/headless_runner.gd`、`tests/test_v0224_npc_routine_arrival_safety.gd`、`godot --headless --path . --script tests/test_v0224_npc_routine_arrival_safety.gd`、`tests/test_v0222_hidden_grid_life_systems.gd`、`tests/test_v0221_livegate_hotspot_priority.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-HOMEPLAZA-005 回归、截图与收口`。
- [x] **V02-HOMEPLAZA-005 回归、截图与收口**
  Owner：QA / PM / Art Direction Agent；依赖：V02-HOMEPLAZA-002、V02-HOMEPLAZA-003、V02-HOMEPLAZA-004；交付物：focused tests、headless runner、1280 proof 和收口记录；验收：Home / Town Plaza living contract、outdoor decor rules、NPC routine safety 和旧路径回归通过。完成记录：新增 `tests/test_v0224_homeplaza005_rc_smoke.gd`、`tests/capture_homeplaza005_rc.gd` 和 `docs/collaboration/round124_homeplaza005_rc/` 五张 1280x720 proof；`tests/headless_runner.gd` 注册 HOMEPLAZA-005 RC smoke；Home living contract、Town Plaza outdoor decor rules、NPC routine arrival safety、HOMEPLAZA-005 RC smoke、全量 headless runner、Godot 启动、非 headless 1280 capture 和 PNG 尺寸复核均通过；V02.24 阶段收口，不标 product complete；下一轮 Ready 为 `V02-MAPAUTH-001 错误列表与验证按钮`。

### V02.25 地图 Authoring 工具实用化

> 本阶段采用双阶段提交：`TownMapAuthoring` 只生成候选 dictionary；`MapEditorSyncService` 负责 validate 和 write-if-valid。合同失败时禁止写回，失败不得覆盖 `world_map.json`；必须证明合法才写、非法不写、失败不毁文件、26 A-Z 不退化、runtime 仍读 JSON。

- [x] **V02-MAPAUTH-001 错误列表与验证按钮**
  Owner：Tooling / QA Agent；依赖：V02-HOMEPLAZA-005；交付物：authoring 错误列表、验证按钮和 focused test；验收：错误可见可复核，不写回 JSON。完成记录：`TownMapAuthoring` 的 `ExportValidationPanel` 增加 Validate button、状态文本和错误列表；新增 `validate_export_candidate()` / `get_validation_summary()`，通过 `MapEditorSyncService.export_authoring_scene()` 校验候选 dictionary 并显式返回 `wrote_file=false`；新增 `tests/test_v0225_mapauth001_validation_panel.gd` 并注册进 `tests/headless_runner.gd`，覆盖有效候选通过、无错误、无写回，非法 marker 候选显示 `place position outside district: place_home`，且 `world_map.json` 原文不变；`scripts/editor/town_map_authoring.gd` check-only、focused validation panel、既有 authoring export、全量 headless runner 和 Godot 启动均通过；下一轮 Ready 为 `V02-MAPAUTH-002 安全写回 JSON 服务`。
- [x] **V02-MAPAUTH-002 安全写回 JSON 服务**
  Owner：Tooling / Data Contract / QA Agent；依赖：V02-MAPAUTH-001；交付物：`MapEditorSyncService` write-if-valid、临时文件 / 备份策略和失败保护测试；验收：合法才写、非法不写、失败不毁文件。完成记录：`MapEditorSyncService` 新增 `write_if_valid()`、`write_authoring_scene_if_valid()` 和 `write_valid_dictionary()`，采用 validate -> temp file -> backup -> swap -> post-write runtime load 流程；合同失败直接返回 `validation_failed` 且不写；写入失败 / commit 失败会清理 temp 并保留原 target；新增 `tests/test_v0225_mapauth002_write_back_service.gd` 并注册进 `tests/headless_runner.gd`，覆盖合法写入、backup、RuntimeMapBuilder 可加载、26 A-Z 保持、非法候选不写、模拟 commit failure 不毁文件且真实 `world_map.json` 原文不变；MAPAUTH-001 validation panel、既有 authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动均通过；下一轮 Ready 为 `V02-MAPAUTH-003 Place marker 新增 / 删除最小闭环`。
- [x] **V02-MAPAUTH-003 Place marker 新增 / 删除最小闭环**
  Owner：Tooling / Map / QA Agent；依赖：V02-MAPAUTH-002；交付物：Place marker 新增 / 删除、验证和 write-back 最小闭环；验收：合法临时 JSON 可 load 并通过 contract，runtime 仍读 JSON。完成记录：`TownMapAuthoring` 新增 `add_place_marker_candidate()`、`delete_place_marker_candidate()` 和 `get_authoring_place_summary()`，Place add / delete 只改候选 `editor_state` 与 marker layer，不写 `data/maps/world_map.json`；新增 candidate 自动带 interaction cell，删除会同步移除对应 interaction；删除仍被 A-Z anchor 引用的 place 会返回 `place_has_anchors`。新增 `tests/test_v0225_mapauth003_place_marker_loop.gd` 并注册进 `tests/headless_runner.gd`，覆盖新增合法 place、拒绝重复 ID、验证候选通过、26 A-Z 保持、拒绝删除 anchor-owned place、删除新增 place、runtime JSON 原文不变；focused MAPAUTH-001/002/003、authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动均通过；下一轮 Ready 为 `V02-MAPAUTH-004 A-Z anchor 删除保护与编辑限制`。
- [x] **V02-MAPAUTH-004 A-Z anchor 删除保护与编辑限制**
  Owner：Memory Palace / Tooling / QA Agent；依赖：V02-MAPAUTH-003；交付物：A-Z anchor 删除保护、关键字段编辑限制和 focused test；验收：26 A-Z 不退化，核心 anchor 不可误删或重排。完成记录：`TownMapAuthoring` 新增 `delete_anchor_marker_candidate()`、`edit_anchor_field_candidate()` 和 `get_authoring_anchor_summary()`；26 个 A-Z anchor 均识别为 protected core anchor，删除返回 `protected_core_anchor` 且不改候选数据；`anchor_id`、`letter`、`core_word`、`route_order`、`place_id`、`card_id`、`audio_id` 等关键字段编辑返回 `anchor_field_locked`；marker position candidate 仍可移动但不改变 locked fields。新增 `tests/test_v0225_mapauth004_anchor_protection.gd` 并注册进 `tests/headless_runner.gd`，覆盖删除保护、未知 anchor、关键字段锁定、position-only 移动、26 A-Z 保持、A-Z route order 保持、validation 不写 JSON；focused MAPAUTH-001/002/003/004、authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动均通过；下一轮 Ready 为 `V02-MAPAUTH-005 Place 移动联动策略`。
- [x] **V02-MAPAUTH-005 Place 移动联动策略**
  Owner：Map / Tooling / QA Agent；依赖：V02-MAPAUTH-004；交付物：Place 移动对 interaction / occupied / road 关系的联动策略和验证；验收：移动不破坏合同，不把可玩入口移到不可达或 occupied 冲突位置。完成记录：`TownMapAuthoring` 新增 `move_place_marker_candidate()`，对 Place 移动采用 guarded candidate：先在候选 dictionary 中同步更新 `position`、`occupied_cells`、主 `interaction_cell`、顶层 `interaction_cells` 和随 footprint 镜像的 `collision_cells`，再经 move overlap 检查与 `MapEditorSyncService.export_to_dictionary()` 合同验证，通过后才替换 `editor_state` 与 marker 位置；非法移动返回 `move_validation_failed` / `validation_failed` 且不改变上一份有效候选。新增 `tests/test_v0225_mapauth005_place_move_linkage.gd` 并注册进 `tests/headless_runner.gd`，覆盖 Home 合法移动联动、collision 同步、导出合同通过、26 A-Z 保持、越界移动拒绝、未知 place 拒绝、validation 不写 JSON 和 `world_map.json` 原文不变；`godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`、`tests/test_v0225_mapauth005_place_move_linkage.gd`、focused MAPAUTH-001/002/003/004/005、authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动均通过；下一轮 Ready 为 `V02-MAPAUTH-006 回归与 runner 集成`。
- [x] **V02-MAPAUTH-006 回归与 runner 集成**
  Owner：QA / PM Agent；依赖：V02-MAPAUTH-005；交付物：扩展 `test_town_map_authoring_export.gd`、新增 write-back service test、A-Z runtime / map readability / full runner 回归；验收：非法数据不写文件，合法临时 JSON 可 load 并通过 contract。完成记录：`tests/test_town_map_authoring_export.gd` 改为使用 `move_place_marker_candidate()` guarded move，断言 Home `position` / `interaction_cell` / `collision_update_count` 联动、26 A-Z 保持和 runtime `world_map.json` 原文不变；新增 `tests/test_v0225_mapauth006_regression_pack.gd` 并注册进 `tests/headless_runner.gd`，覆盖 authoring scene 合法候选写入临时 JSON、`RuntimeMapBuilder` 可加载、26 A-Z 保持、Home linked move 落盘、raw invalid candidate 写回被 `validation_failed` 阻止、临时 target 原文不变、无 `.tmp` 残留且真实 `world_map.json` 不变；`godot --headless --path . --check-only --script tests/test_v0225_mapauth006_regression_pack.gd`、`tests/test_town_map_authoring_export.gd`、`tests/test_v0225_mapauth006_regression_pack.gd`、focused MAPAUTH-001/002/003/004/005、A-Z runtime、map readability、全量 headless runner 和 Godot 启动均通过；V02.25 地图 Authoring 工具实用化阶段收口，下一轮 Ready 为 `V02-CONTENTBATCH-001 NPC routine 小批量`。

### V02.26 内容生产小批量

> 本阶段只做小批量内容：7 天 NPC routine 轻变化、3-5 个新增资源点、4-6 条 A-Z 生活物件回访、Shop 门口 / School Yard 看一眼事件。避免复用同一个 `core_anchor_id`，因为当前 `AnchorInteractionService` 有一对一覆盖风险。

- [x] **V02-CONTENTBATCH-001 NPC routine 小批量**
  Owner：NPC / Narrative / QA Agent；依赖：V02-MAPAUTH-006；交付物：7 天 NPC routine 轻变化数据、fallback 和 focused test；验收：routine 不阻断 P0，不制造赶路、迟到、错过或值班压力。完成记录：`data/life/npc_routines.json` 扩展为 local_day_001..007 七天 routine，覆盖 Mina、Shopkeeper、Sunny、Bus Helper、Story Bear 五位居民，使用安全到达 cell 和温和生活化文案；新增 `tests/test_v026_contentbatch001_npc_routine_batch.gd` 并注册进 `tests/headless_runner.gd`，覆盖 7 天数据可加载、每天五位居民齐全、默认 routine 无 blocked / fallback、每位居民至少两处轻变化、文案无赶路 / 迟到 / 错过 / 值班压力词、坏数据 fallback 仍安全、day 7 runtime snapshot 和 Mina 可达 prompt；同步调整 runner 中旧 V02.22 fallback 断言为默认 routine snapshot unblocked；`godot --headless --path . --check-only --script scripts/systems/npc_routine_service.gd`、`tests/test_v026_contentbatch001_npc_routine_batch.gd`、`tests/test_v0224_npc_routine_arrival_safety.gd`、`tests/test_v024_content_contracts.gd`、`tests/headless_runner.gd` 和 Godot 启动均通过；下一轮 Ready 为 `V02-CONTENTBATCH-002 资源刷新点小批量`。
- [x] **V02-CONTENTBATCH-002 资源刷新点小批量**
  Owner：Economy / Map / QA Agent；依赖：V02-CONTENTBATCH-001；交付物：3-5 个资源刷新点、温和反馈和 contract test；验收：不制造刷材料压力、限时采集、错过惩罚或资源枯竭焦虑。完成记录：`data/life/resource_points.json` 新增 `resource_shell_coast_edge`、`resource_leaf_school_walk`、`resource_pinecone_animal_park`、`resource_ribbon_shop_street` 四个每日软刷新点；`data/items/life_items.json` 新增 `shell`、`leaf`、`pinecone`、`ribbon` 四个材料条目并绑定稳定 A-Z 记忆故事；新增 `tests/test_v026_contentbatch002_resource_points.gd` 并注册进 `tests/headless_runner.gd`，覆盖资源点加载、物品目录、道路可达、避开 protected anchor / interaction / collision、无压力词、同日去重、跨日刷新和主场景真实 resource prompt；同步修正 `tests/test_v0222_hidden_grid_life_systems.gd` 的旧 fallback 断言以适配 CONTENTBATCH-001 后默认 routine 完整状态；`godot --headless --path . --check-only --script tests/test_v026_contentbatch002_resource_points.gd`、`tests/test_v026_contentbatch002_resource_points.gd`、`tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`tests/test_v0222_hidden_grid_life_systems.gd`、`tests/test_v0223_expapproval_town_plaza_density.gd`、`tests/test_v0221_livegate_hotspot_priority.gd`、`tests/headless_runner.gd` 和 Godot 启动均通过；下一轮 Ready 为 `V02-CONTENTBATCH-003 A-Z 生活物件回访`。
- [x] **V02-CONTENTBATCH-003 A-Z 生活物件回访**
  Owner：Memory Palace / Narrative / QA Agent；依赖：V02-CONTENTBATCH-002；交付物：4-6 条 A-Z 生活物件回访、story_memory、visual_hook 和 review_path；验收：每条绑定稳定 anchor / place，不复用同一 `core_anchor_id` 导致覆盖。完成记录：`data/anchors/new_word_revisit_paths.json` 新增 `photo` / A Apple、`towel` / D Dog、`leaf` / K Kite、`ribbon` / H Hat、`pinecone` / M Monkey、`shell` / U Umbrella 六条生活物件回访；新增 `tests/test_v026_contentbatch003_anchor_revisits.gd` 并注册进 `tests/headless_runner.gd`，覆盖必填字段、story_id 唯一、`core_anchor_id` 全局唯一、核心 anchor / letter 匹配、儿童安全文案、`AnchorInteractionService` lookup、card state 和主场景六个真实 anchor prompt；`godot --headless --path . --check-only --script tests/test_v026_contentbatch003_anchor_revisits.gd`、`tests/test_v026_contentbatch003_anchor_revisits.gd`、`tests/test_v023_memory_palace_world.gd`、`tests/test_v024_content_contracts.gd`、`tests/headless_runner.gd` 和 Godot 启动均通过；下一轮 Ready 为 `V02-CONTENTBATCH-004 Shop front / School Yard 小事件 smoke`。
- [x] **V02-CONTENTBATCH-004 Shop front / School Yard 小事件 smoke**
  Owner：Narrative / QA / Godot Agent；依赖：V02-CONTENTBATCH-003；交付物：Shop front / School Yard 看一眼事件、focused smoke 和 full runner 回归；验收：事件来自真实入口，不课程化，不阻断 P0。完成记录：`data/life/homeschool_events.json` 新增 `homeschool_shop_front_window_001` 与 `homeschool_school_yard_chalk_flower_001` 两个生活化看一眼事件；`data/maps/world_map.json` 在 Shop Street `42,9` 和 School Yard `18,14` 新增真实 `look_homeschool_event` 入口，均落在可达道路且避开已有 exact anchor / resource / interaction / collision；新增 `tests/test_v026_contentbatch004_look_events.gd` 并注册进 `tests/headless_runner.gd`，覆盖 JSON、可达性、protected cell 避让、儿童安全文本、主场景真实 `看看`、保存落账、相册 card state 和 Shop P0 入口不阻断；focused、V02.14 homeschool 回归、CONTENTBATCH-002/003 回归、content contracts、全量 headless runner 和 Godot 启动均通过；V02.26 内容生产小批量阶段收口。

### V02.27 Map Editor 完整化

> 本阶段完善 `scenes/map_editor/town_map_authoring.tscn` 作为场景内 Godot 地图编辑工具，不做 EditorPlugin，不进入孩子端 runtime。编辑器支持 Place、road、collision、interaction、resource、NPC routine 和 A-Z anchor 位置的候选编辑；保存采用分文件按钮，分别写 `data/maps/world_map.json`、`data/life/resource_points.json`、`data/life/npc_routines.json`。每次保存前强制 Validate，写入使用 temp / backup / post-load 验证，失败不得破坏原文件。Round136-Round138 已补充打开场景后的 UI 可用性降噪、左侧控制栏整理、直接拖拽编辑、Inspector 输入控件和 A-Z 字母可见性返修。

- [x] **V02-MAPEDITOR-001 PM 路线、禁改边界、任务包与 ledger 同步**
  Owner：PM / Tooling / QA Agent；依赖：V02-CONTENTBATCH-004；交付物：V02.27 Map Editor 完整化路线、V02-MAPEDITOR-001..009 队列、禁改边界、分文件保存策略和验收矩阵；验收：`todo.md`、docs 12-15 和协作记录同步；不改孩子端 runtime 体验，不把编辑器入口暴露给孩子端。完成记录：见 Round135、Round136 与 Round137 验收记录。
- [x] **V02-MAPEDITOR-002 图层开关、选择态、Inspector 基础**
  Owner：Tooling / UI / QA Agent；依赖：V02-MAPEDITOR-001；交付物：顶部工具栏、图层开关、工具模式、右侧 Inspector 和底部状态区；验收：road / collision / interaction / place / anchor / resource / npc 图层可独立显示隐藏；点选 marker 后 Inspector 可读；不写任何 JSON。
- [x] **V02-MAPEDITOR-003 Place 拖动、属性编辑、Save Map**
  Owner：Tooling / Map / QA Agent；依赖：V02-MAPEDITOR-002；交付物：Place 选择、拖动、label / place_type / district_id / size 编辑和 Save Map；验收：Place 移动继续联动 occupied / interaction / collision；保存前强制 Validate；合法才写 map 目标，非法 / 模拟失败不写且保留备份。
- [x] **V02-MAPEDITOR-004 Road / Collision / Interaction 绘制与地图保存验证**
  Owner：Tooling / Map / QA Agent；依赖：V02-MAPEDITOR-003；交付物：road / collision / interaction 单 cell 画笔与橡皮；验收：绘制只改候选 state；禁止覆盖 A-Z anchor、核心 place footprint、资源和 NPC routine cell；保存回归通过。
- [x] **V02-MAPEDITOR-005 Resource marker 编辑与 resource_points 分文件保存**
  Owner：Tooling / Economy / QA Agent；依赖：V02-MAPEDITOR-004；交付物：resource marker 显示、移动、display_name / quantity / item_id 编辑、Validate Resources 和 Save Resources；验收：item_id 必须存在于 `life_items.json`；资源点不覆盖 anchor / place / interaction / NPC；合法才写 `resource_points.json` 目标。
- [x] **V02-MAPEDITOR-006 NPC routine day selector、marker 编辑与 npc_routines 分文件保存**
  Owner：Tooling / NPC / QA Agent；依赖：V02-MAPEDITOR-005；交付物：day selector、NPC routine marker 显示、移动、label 编辑、Validate Routines 和 Save Routines；验收：npc_id 必须来自已知 runtime NPC；arrival cell 通过 safety；合法才写 `npc_routines.json` 目标。
- [x] **V02-MAPEDITOR-007 A-Z anchor 迁移模式、保护验证、全量回归收口**
  Owner：Tooling / Memory Palace / QA Agent；依赖：V02-MAPEDITOR-006；交付物：Move Anchor 专门模式、A-Z anchor 位置迁移、保护验证和全量回归；验收：26 个 A-Z anchor 保持完整，`anchor_id` / `letter` / `core_word` / `route_order` / `card_id` / `audio_id` 永远不可编辑；V02.17 / V02.18 / V02.25 / V02.26 和 full runner 通过；阶段收口。
- [x] **V02-MAPEDITOR-008 Map Editor 可用性降噪**
  Owner：Tooling / UX / QA Agent；依赖：V02-MAPEDITOR-007；交付物：固定地图画布、顶部工具工作带、右侧 Inspector / 状态工作栏、compact marker badge 和 focused test；验收：打开 `town_map_authoring.tscn` 时面板分区清楚、marker 标签不再长文本堆叠；保存合同、默认图层可见性和孩子端 runtime 边界不变。完成记录：见 Round136 验收记录。

- [x] **V02-MAPEDITOR-009 Map Editor 视觉布局二次整理**
  Owner：Tooling / UX / QA Agent；依赖：V02-MAPEDITOR-008；交付物：左侧控制侧栏、右侧完整地图画布、固定高度验证 / 工具 / Inspector / 状态面板、sidebar label clipping 和布局回归断言；验收：`town_map_authoring.tscn` 以 1280x720 打开时工具不横向溢出，侧栏不扩成超高黑块，地图 canvas 不被裁切；保存合同、A-Z anchor 保护、resource / NPC routine 分文件保存和孩子端 runtime 边界不变。完成记录：见 Round137 验收记录。

- [x] **V02-MAPEDITOR-010 Map Editor 直接拖拽编辑与字母可见性返修**
  Owner：Tooling / UX / QA Agent；依赖：V02-MAPEDITOR-009；交付物：marker 直接拖拽事件提交、Inspector 可填写输入框与 Apply、A-Z 字母 marker 字号 / 对比 / z 顺序增强和 MAPEDITOR-010 focused test；验收：Place / resource / NPC marker 拖拽可通过候选验证提交，A-Z anchor 仍必须进入 Move A-Z 专门模式，Inspector 字段可从场景内直接编辑，字母 A-Z 在 1280x720 下可读；保存合同、A-Z 锁定字段、三份 JSON 分文件边界和孩子端 runtime 边界不变。完成记录：见 Round138 验收记录。

- [x] **V02-MAPDOGFOOD-001 PM 路线、禁改边界和任务包**
  Owner：PM / Tooling / QA Agent；依赖：V02-MAPEDITOR-010；交付物：V02.28 Map Editor 实战生产验证路线、禁改边界、任务包和验收矩阵；验收：docs 12-15、`todo.md` 和协作记录同步，下一轮 Ready 明确；不改 runtime、data、tests 或 assets。完成记录：见 Round139 验收记录。

- [x] **V02-MAPDOGFOOD-002 Map Editor 小批量生产实战**
  Owner：Tooling / Map / QA Agent；依赖：V02-MAPDOGFOOD-001；交付物：2 个 Place、1 个 resource、1 个 NPC routine 的正式 dogfood 内容改动；验收：改动来自场景内 Map Editor 候选 state、Validate 和 `MapEditorSyncService` 安全写回；正式 JSON 可 load；A-Z 不退化。完成记录：见 Round140 验收记录。

- [x] **V02-MAPDOGFOOD-003 孩子端真实入口复核**
  Owner：QA / UX / Child Safety Agent；依赖：V02-MAPDOGFOOD-002；交付物：dogfood 内容的真实移动 / `看看` / resource / NPC 路径复核；验收：新内容可见可达，不遮挡 A-Z，不显示坐标、格子、编辑器、调试或课程压力文案。完成记录：见 Round140 验收记录。

- [x] **V02-MAPDOGFOOD-004 内容生产手册与操作边界**
  Owner：Tooling / PM / Content Agent；依赖：V02-MAPDOGFOOD-002；交付物：Map Editor 内容生产手册、保存流程、回滚注意和 A-Z 锁定字段清单；验收：后续内容生产者可按手册执行 Place / resource / NPC routine 增改、验证、保存和回归。完成记录：见 Round140 验收记录。

- [x] **V02-MAPDOGFOOD-005 回归、1280 proof 与阶段收口**
  Owner：QA / PM Agent；依赖：V02-MAPDOGFOOD-002、V02-MAPDOGFOOD-003、V02-MAPDOGFOOD-004；交付物：focused dogfood test、V02.27 editor 回归、full runner、Godot 启动、1280 proof 和阶段收口记录；验收：工具链证明生产可用，但不标 product complete；960x540 保留到版本适配专项。完成记录：见 Round140 验收记录。

- [x] **V02-STORYMOTIONART-001 V02.29-V02.36 长远路线与任务包**
  Owner：PM / Narrative / Art Direction / UX / QA Agent；依赖：V02-MAPDOGFOOD-005、用户确认的四个方向：完整故事线规划、行走动画、Animal Crossing-like 操控、美术团队 tile map / 故事 / 动画资产生产；交付物：V02.29-V02.36 多轮路线、禁改边界、任务队列、验收矩阵和 Round141 长远路线任务包；验收：`docs/12`、`docs/13`、`docs/14`、`docs/15`、`todo.md` 和协作记录同步，下一轮 Ready 明确；不改 runtime、data、tests 或 assets。完成记录：新增 `docs/collaboration/Round141_V02.29-V02.36_STORYMOTIONART长远路线与任务包.md`；V02.29-V02.36 已拆为故事总纲、当前地图适配、行走动画规格、Animal Crossing-like 操控规格、tile / prop / story object / animation 资产生产规格、Map Editor / AssetResolver 接入规范、动作操控运行时纵切和故事整合纵切；下一轮 Ready 为 `V02-STORYLINE-002 全量故事线总纲与章节骨架`。

- [x] **V02-STORYLINE-002 全量故事线总纲与章节骨架**
  Owner：Narrative / Memory Palace / PM Agent；依赖：V02-STORYMOTIONART-001、`data/maps/world_map.json`、`data/anchors/az_core_anchors.json`、`data/maps/az_world_plan.json`、`docs/14_内容基线整理与首批内容规划.md`；交付物：P0/P1/P2 全量故事线总纲、章节结构、A-Z anchor 故事索引、每条故事线的地点 / NPC / anchor / 新词故事 / 视觉钩子 / 回访路径 / 首批资产需求；验收：不改 runtime、data 或 assets；不重排 A-Z；不扩远郊 P0；每条故事线都有儿童安全边界和可制作资产需求。完成记录：见 Round142 验收记录。

- [x] **V02-STORYLINE-003 当前地图适配与内容生产蓝图**
  Owner：Narrative / Map / QA Agent；依赖：V02-STORYLINE-002、V02.28 Map Editor dogfood 生产手册；交付物：story-place-anchor-NPC 绑定表、现有 Place 可直接承载故事列表、Map Editor 可生产候选清单、P0/P1/P2 缺口清单；验收：所有 P0 故事能落到当前地图或少量 Map Editor 候选；不要求手工 JSON；不重排 26 A-Z。完成记录：见 Round143 验收记录。

- [x] **V02-MOTION-001 行走动画与角色动作规格**
  Owner：Animation / UX / Godot / QA Agent；依赖：V02-STORYLINE-003；交付物：player / NPC / Sunny 的 idle / walk / turn / interact / greet / follow 状态机、4 向必须 / 8 向预留、sprite sheet 命名、帧数、尺寸、pivot、scale、loop 规则和 proof 口径；验收：动画团队可按规格生产首批动作资产，Godot 可按 logical animation ID 接入。完成记录：新增 `docs/collaboration/Round144_V02.31_MOTION-001行走动画与角色动作规格.md`；基于当前 `scripts/main.gd` 的连续移动、`TownStage`、`PlayerActor` / `NPCActor` 和 `ThemeProfile` standing fallback，固定 Player、Sunny、Mina、Shopkeeper、Story Bear、Bus Helper 的动作优先级、4 向 / 8 向、帧数、FPS、loop、pivot、sprite sheet metadata、`character_animation_assets` / `pet_animation_assets` / `animation_metadata_assets` 建议、AssetResolver 接入边界和 V02.35 runtime proof 口径；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-CONTROLS-001 Animal Crossing-like 操控规格`。

- [x] **V02-CONTROLS-001 Animal Crossing-like 操控规格**
  Owner：UX / Godot / QA Agent；依赖：V02-MOTION-001；交付物：连续移动、速度曲线、转向 / 停止、镜头跟随、靠近 prompt、虚拟摇杆、tap-to-move、键盘 / 手柄输入和隐藏网格规则；验收：可直接拆分为 Godot 实现任务；孩子端不显示格子、坐标、占格、debug 或编辑器术语。完成记录：新增 `docs/collaboration/Round145_V02.32_CONTROLS-001动森式操控规格.md`；基于当前 tap-to-cell、keyboard 单步、`move_toward()` 连续显示、`TownStage` camera clamp 和 prompt 系统，固定统一 motion intent、输入优先级、keyboard hold、tap-to-move 替换目标、virtual joystick / gamepad 预留、速度 / 加减速参数、隐藏网格边界、prompt 优先级与锁定、camera smoothing、动画联动和 V02.35 focused / 1280 proof 口径；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格`。

- [x] **V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格**
  Owner：Art Direction / Asset / Narrative Agent；依赖：V02-STORYLINE-003、V02-MOTION-001、V02-CONTROLS-001；交付物：tile map、ground edge、story props、A-Z anchor refresh、character motion、UI feedback 资产 backlog；验收：每项有 logical asset ID、用途、尺寸建议、优先级、依赖故事线、是否 atlas / sprite sheet、验收截图点和禁用风格。完成记录：新增 `docs/collaboration/Round146_V02.33_ARTPIPE-001美术资产生产规格.md`；基于 Round142 / 143 / 144 / 145 和 `docs/10`，输出 P0/P1/P2 tile / edge、story prop、anchor refresh、character motion、UI feedback、production batch、asset acceptance 字段和禁用风格清单；明确新增 `story_prop_assets`、`character_animation_assets`、`pet_animation_assets`、`animation_metadata_assets`、`ui_feedback_assets` 等后续接入类别；本轮未生成资产、未改 ThemeProfile、未改 runtime / data / tests；下一轮 Ready 为 `V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范`。

- [x] **V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范**
  Owner：Tech Art / Tooling / QA Agent；依赖：V02-ARTPIPE-001；交付物：正式素材命名、导入、atlas / sprite sheet、logical asset ID、ThemeProfile 映射、editor marker 绑定、asset acceptance 和 runtime proof 规则；验收：美术团队交付的 tile / prop / animation 能进入当前编辑器和 runtime；`production` 不自动等同 `approved`。完成记录：新增 `docs/collaboration/Round147_V02.34_ARTPIPE-002_MapEditor_ThemeProfile_AssetResolver接入规范.md`；基于当前 `ThemeProfileResource` / `AssetResolver` 和 Map Editor 能力，固定新增 `story_prop_assets`、`tile_edge_assets`、`character_animation_assets`、`pet_animation_assets`、`animation_metadata_assets`、`ui_feedback_assets` 类别、AssetResolver API、sprite sheet metadata schema、story prop marker 合同、Map Editor 接入流程、asset import、asset acceptance、runtime proof 和 validators；本轮未生成资产、未改 runtime / data / tests；下一轮 Ready 为 `V02-ARTPROD-001 首批美术资产生产与接入`。

- [x] **V02-ARTPROD-001 首批美术资产生产与接入**
  Owner：Art Direction / Asset / Tech Art / QA Agent；依赖：V02-ARTPIPE-002；交付物：首批 tile / prop / story object / character motion / UI feedback production 资产和接入记录；验收：资源进入 repo asset tree、Godot import、ThemeProfile / AssetResolver 和 editor marker 绑定；1280 proof 可判定，未判定前不标 approved。完成记录：新增 `docs/collaboration/Round148_V02.34_ARTPROD-001首批美术资产生产与接入.md`；新增首批 P0 story prop、player / Sunny motion sheet、motion metadata、UI feedback、tile edge PNG 和 `data/life/story_props.json`；`ThemeProfileResource` / `AssetResolver` 新增 story prop、tile edge、character / pet animation、animation metadata 和 UI feedback 类别；`TownMapAuthoring` 新增 `StoryPropMarkerLayer`、`place_story_prop` tool mode、story prop marker selection / drag / Inspector `child_label` 和 validator；新增 `tests/test_v0234_artprod001_asset_integration.gd` 并注册进 `tests/headless_runner.gd`；focused asset resolver、ARTPROD-001 focused 和 full runner 通过；所有首批资产仍为 production，不自动 approved；下一轮 Ready 为 `V02-RUNTIME-ANIM-001 动作操控运行时纵切`。2026-06-07 返修补记：Round141-151 图片来源核查确认仅 Round148 新增 bitmap PNG，10 张首批 production PNG 已全部使用 `/home/xionglei/GameProject/tools/image_generator.js` 重新生成并保持原 logical asset ID、尺寸和接入合同。

- [x] **V02-RUNTIME-ANIM-001 动作操控运行时纵切**
  Owner：Godot / UX / QA Agent；依赖：V02-ARTPROD-001、V02-CONTROLS-001；交付物：连续移动、4 向动画、镜头跟随、靠近 prompt、真实入口 smoke 和 1280 proof；验收：移动不显格子，prompt 优先级稳定，旧 NPC / resource / anchor / place 路径不退化。完成记录：新增 `docs/collaboration/Round149_V02.35_RUNTIME-ANIM-001动作操控运行时纵切.md`；`PlayerActor` 接入 player motion sheet runtime state 和 standing fallback；`Main` / `TownStage` 接入 keyboard hold、camera smoothing、prompt glow、tap ripple feedback 和 runtime motion snapshot；新增 `tests/test_v0235_runtime_anim_controls.gd` 并注册进 `tests/headless_runner.gd`；check-only、V02.35 focused、V02.20 controls、full runner 和 MCP 1280 viewport proof 通过；下一轮 Ready 为 `V02-STORYSLICE-001 故事线 + 美术 + 动作整合纵切`。

- [x] **V02-STORYSLICE-001 故事线 + 美术 + 动作整合纵切**
  Owner：Narrative / Godot / Art Direction / QA Agent；依赖：V02-RUNTIME-ANIM-001、V02-STORYLINE-003；交付物：第一批 P0 故事章节可玩、A-Z 回访、相册落账、NPC / resource / story object 联动和阶段 RC proof；验收：至少 1 条 P0 Home / Town / School 复合故事可玩，至少 6 个 A-Z anchor 通过新故事回访路径落账，不出现课程、测试、打卡或工程文案。完成记录：新增 `docs/collaboration/Round150_V02.36_STORYSLICE-001故事线美术动作整合纵切.md`；`data/life/story_props.json` 补齐 child feedback / environment words / Story Bear / branch context；`TownStage` 新增 `StoryPropLayer` 并渲染四个 P0 story prop production 资产；`Main` 新增 story prop loader、`look_story_prop`、prompt target、story slice save record、A-Z card state 落账和 `get_story_slice_snapshot()`；新增 `tests/test_v0236_storyslice001_runtime.gd` 并注册进 `tests/headless_runner.gd`；check-only、V02.36 focused、full runner、JSON、diff check 和 MCP 1280 viewport proof 通过；A/B/H/N/R/Y 六个 anchors 已通过 story prop 路径落账。

- [x] **V02-STORYBATCH-001 V02.37+ 内容批量生产与批准线规划**
  Owner：PM / Narrative / Art Direction / QA Agent；依赖：V02-STORYSLICE-001、Round142 故事总纲、Round143 地图适配、Round146 / 147 美术生产与接入规范；交付物：V02.37+ story batch 路线、任务队列、批准线、禁改边界、第二批内容建议和下一轮 Ready；验收：docs 12-15、`todo.md` 和协作记录同步；V02.29-V02.36 阶段可收口；下一轮唯一 Ready 明确；本轮不改 runtime、data、tests 或 assets。完成记录：新增 `docs/collaboration/Round151_V02.37_STORYBATCH-001内容批量生产与批准线规划.md`；同步 docs 12-15 和 `todo.md`；将后续队列拆为 `V02-STORYBATCH-002` 至 `005`，固定第二批 story prop / A-Z 回访内容包、production 资产接入、runtime smoke、1280 proof 与 approved 判定；下一轮 Ready 为 `V02-STORYBATCH-002 第二批 story prop / A-Z 回访内容包`。

- [x] **V02-STORYBATCH-002 第二批 story prop / A-Z 回访内容包**
  Owner：Narrative / Memory Palace / Art Direction / QA Agent；依赖：V02-STORYBATCH-001、Round142 故事总纲、Round143 当前地图适配、Round150 story slice；交付物：第二批 story prop / A-Z 回访候选清单、每条内容的 `core_anchor_id`、place、NPC / resource context、environment words、story memory、visual hook、review path、asset need 和 child feedback；验收：优先覆盖 Round150 未覆盖字母，不复用同一 `core_anchor_id` 造成覆盖风险，不扩远郊 P0，不出现课程、测试、背诵、打卡、分数、倒计时或工程文案。完成记录：新增 `docs/collaboration/Round152_V02.37_STORYBATCH-002第二批story_prop与AZ回访内容包.md`；第二批 P0 内容包覆盖 C Clock、D Dog、G Gate、K Kite、O Orange、S Sun、W Watch 七条候选；每条候选均记录 planned story prop ID、logical asset ID、anchor、place、context、environment words、story memory、visual hook、review path、asset need 和 child feedback；新增 `tests/test_v0237_storybatch002_content_pack.gd` 并注册进 `tests/headless_runner.gd` 轻量文档合同门槛；check-only、focused 和 full headless runner 均通过；下一轮 Ready 为 `V02-STORYBATCH-003 第二批 production 资产与接入`。

- [x] **V02-STORYBATCH-003 第二批 production 资产与接入**
  Owner：Asset / Tech Art / Godot / QA Agent；依赖：V02-STORYBATCH-002、V02-ARTPIPE-002；交付物：第二批 story prop / anchor refresh production 资产、logical asset ID、ThemeProfile / AssetResolver 映射、Map Editor marker / metadata 接入和 focused asset test；验收：资产进入 repo asset tree，使用 logical asset ID，不硬编码路径；`production` 不自动等同 `approved`。完成记录：新增 `docs/collaboration/Round153_V02.37_STORYBATCH-003第二批production资产与接入.md`；使用 `/home/xionglei/GameProject/tools/image_generator.js` 生成 7 张第二批 story prop source PNG，ImageMagick 抠底 / resize / transparent extent 后回写 `assets/art/story_props/**`，保留 `tmp/round153_storybatch003_sources/contact_sheet.png` 接触表证据；`data/themes/theme_sunshine_town_placeholder.json` 新增 7 个 `story_prop_assets` 映射和 production acceptance 记录，`data/life/story_props.json` 增至 11 个 marker 并绑定 C/D/G/K/O/S/W；新增 `tests/test_v0237_storybatch003_asset_integration.gd` 并注册进 `tests/headless_runner.gd`；focused check-only、focused、full runner check-only 和 full runner 均通过；7 项仍为 production，`viewport_evidence` 保持 `pending_1280_runtime_proof`；二次视觉复核后 `V02-STORYBATCH-004/005` 继续阻塞，等待 V02.39 达到 `runtime_visual_match`。

- [!] **V02-STORYBATCH-004 第二批 runtime 接入与真实入口 smoke**
  Owner：Godot / Narrative / QA Agent；依赖：V02-STORYBATCH-003、V02-VISUALREBUILD-006；交付物：第二批 story prop runtime 渲染、`look_story_prop` 或等价真实入口、story slice save record、A-Z card state 落账和 focused smoke；阻塞原因：V02.38 二次视觉复核后只达到 `visual_scaffold`，当前不得继续把新 story prop 叠到错误生产模型上；解除条件：V02.39 达到 `runtime_visual_match`，并由 PM / Art Direction 明确将本任务转为 Ready。

- [!] **V02-STORYBATCH-005 1280 proof、approved 判定与阶段收口**
  Owner：QA / PM / Art Direction Agent；依赖：V02-STORYBATCH-002、V02-STORYBATCH-003、V02-STORYBATCH-004、V02-VISUALREBUILD-006；交付物：focused / full runner、JSON、diff check、Godot 启动、1280 runtime proof、逐项 `production` / `functional_pass` / `visual_scaffold` / `runtime_visual_match` / `final_approved` / `needs_fix` 判定和阶段收口记录；阻塞原因：不得在 `visual_scaffold` 上做 approved 判定；解除条件：第二批 runtime smoke 被重新解锁并具备同轮 target/runtime proof。

- [x] **V02-VISUALRECOVERY-001 全面纠偏与文档重写**
  Owner：PM / Art Direction / QA Agent；依赖：用户确认的强纠偏、完整重写、full-map background 禁用目标；交付物：`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md`、`lessons.md` 和 Round154 collaboration 任务包；验收：当前 Ready 从 `V02-STORYBATCH-004` 切换为 V02.38 队列，Round119 `approved` 仅作 `functional_pass`，`artpass003_visual_direction` / Round92 写为硬门槛，`world_map_base_1280.png` 明确只能作 reference，本轮不改 runtime。完成记录：新增 `docs/collaboration/Round154_V02.38_VISUALRECOVERY-001全面纠偏与文档重写.md`；docs 12-15、`todo.md` 和 `lessons.md` 已同步 V02.38 纠偏事实；`V02-STORYBATCH-004/005` 保持 `[!]` 阻塞；下一轮 Ready 为 `V02-VISUALRECOVERY-002 Modular Visual System 规格`；静态一致性复核、`git diff --check` 和 `godot --headless --path . --quit` 通过。

- [x] **V02-VISUALRECOVERY-002 Modular Visual System 规格**
  Owner：Art Direction / Tech Art / Godot / QA Agent；依赖：V02-VISUALRECOVERY-001；交付物：terrain tile、region chunk、building prefab、world prop / anchor、actor、soft shadow、glass UI 的生产规格和首屏最小资产包；验收：`world_map_base_1280.png` 只作 reference，ThemeProfile / AssetResolver 后续类别规划清楚，runtime layer 目标可直接拆给 Godot。完成记录：新增并保留唯一权威文档 `docs/collaboration/Round155_V02.38_VISUALRECOVERY-002_ModularVisualSystem规格.md`；补充 Round159 delivered set 和 canonical category alias 说明；重复 Round155 无下划线文件已不存在。

- [x] **V02-VISUALRECOVERY-003 首屏统一资产包生产**
  Owner：Asset / Art Direction / Tech Art Agent；依赖：V02-VISUALRECOVERY-002；交付物：Town Plaza / Home / Shop / School line 首批 terrain tiles、region chunks、building prefabs、生活 props、统一 shadows 和 provenance；验收：所有 asset 有 logical asset ID、尺寸、透明背景、统一相机 / 光源 / 比例规则、接触表和生成 / 后处理证据。完成记录：`assets/art/visual_recovery/` 已包含 terrain / regions / buildings / props / ui / source 首屏资产；补齐 `region_school_line_chunk_v001.png`；`docs/collaboration/round156_visual_recovery_assets/provenance.md` 与 `round156_visual_recovery_contact_sheet_v001.png` 已同步实际 logical IDs 和 16 张最终 PNG。

- [x] **V02-VISUALRECOVERY-004 TownStage 无整图底图渲染纵切**
  Owner：Godot / Tech Art / QA Agent；依赖：V02-VISUALRECOVERY-002、V02-VISUALRECOVERY-003；交付物：TownStage modular layers 首屏纵切、AssetResolver 接入、focused smoke 和 1280 proof；验收：启动、移动、`看看`、NPC、资源、Shop、Home、A-Z 旧入口不退化，runtime proof 证明 full-map background 不再作为 final 主画面。完成记录：`ThemeProfileResource` / `AssetResolver` 支持 V02.38 categories 与 canonical aliases；`TownStage` 渲染 terrain tiles、region chunks、Home / Shop / School prefabs 和 prop-first world props，不创建 legacy `Ground` sprite；`place.world_map.base_1280` acceptance 改为 `reference_only`。

- [x] **V02-VISUALRECOVERY-005 HUD / Anchor / Actor 视觉降噪**
  Owner：UX / Art Direction / Godot / QA Agent；依赖：V02-VISUALRECOVERY-004；交付物：HUD / footer / prompt、A-Z badge、玩家 / Sunny / NPC 比例和层级返修；验收：A-Z 默认 prop-first，字母 badge 只作辅助，UI 不再用大白条压画面，孩子端不显示调试或编辑器术语。完成记录：glass HUD / footer 走 V02.38 assets，prompt glow / tap ripple / soft shadow 接入 logical IDs；A-Z badge alpha 保持 secondary；resolved 与 fallback 非 prefab place marker 均降为低 alpha context，`non_prefab_place_max_alpha <= 0.22` 已进入 focused / full runner，避免旧 place 图和 placeholder roof/window 噪声压过 modular ground。

- [x] **V02-VISUALRECOVERY-006 1280 Final Visual Gate**
  Owner：PM / Art Direction / UX / QA Agent；依赖：V02-VISUALRECOVERY-004、V02-VISUALRECOVERY-005；交付物：同轮 1280 proof、真实入口 smoke、artpass003 对照判定和 `functional_pass` / `visual_candidate` / `final_approved` 状态表；验收：只有通过 artpass003 贴近度、真实入口、儿童安全文本和 PM / Art Direction 复核的视图可标 `final_approved`。完成记录：新增并父级验证 `docs/collaboration/Round159_V02.38_VISUALRECOVERY-006_1280FinalVisualGate.md`；5 张 `1280x720` proof 已导出到 `docs/collaboration/round159_visual_recovery_gate/`；真实入口 smoke、focused tests、full runner 和 non-headless capture 通过；原 lane 结果为 `visual_candidate`，未授予 `final_approved`；二次视觉复核后项目级重解释为 `visual_scaffold`，不能恢复 V02-STORYBATCH-004。

- [x] **V02-VISUALREBUILD-001 Godot 视觉生产体系重建路线与任务包**
  Owner：PM / Art Direction / UX / QA Agent；依赖：用户二次视觉复核、V02-VISUALRECOVERY-006、artpass003 视觉方向；交付物：`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md`、`lessons.md` 和 Round160 collaboration 任务包；验收：确认问题是生产模型错误而非局部 polish，V02.38 重解释为 `visual_scaffold`，`V02-STORYBATCH-004/005` 阻塞，下一项 Ready 为 `V02-VISUALREBUILD-002`。完成记录：新增 `docs/collaboration/Round160_V02.39_VISUALREBUILD-001视觉生产体系重建路线与任务包.md`；docs 12-15、`todo.md` 和 `lessons.md` 已同步。

- [ ] **V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同**
  Owner：PM / Art Direction / Tech Art / UX Agent；依赖：V02-VISUALREBUILD-001、artpass003 视觉方向、Round92；交付物：1280 target gameplay frame、paintover 或等价目标图，Godot 可执行 visual layout 合同；验收：home-centered 构图、camera、depth bands、layer order、asset scale、negative space、UI safe area、A-Z 首屏优先级、forbidden remnants 和 proof checklist 明确，达到 `art_target_locked`。

- [ ] **V02-VISUALREBUILD-003 Logic Map / Visual Layout 分层方案**
  Owner：Tech Lead / Godot / Tooling / QA Agent；依赖：V02-VISUALREBUILD-002；交付物：Logic Map / Visual Layout 边界、visual anchor / depth / proxy / occlusion / focus state 合同和迁移策略；验收：`world_map` 继续管 cell / collision / interaction / A-Z ID / save，首屏视觉布局不再由 cell 全量直推。

- [ ] **V02-VISUALREBUILD-004 首屏统一环境资产包与 composition kit**
  Owner：Art Direction / Asset / Tech Art Agent；依赖：V02-VISUALREBUILD-002、V02-VISUALREBUILD-003；交付物：terrain、region、building、prop、shadow、actor scale、glass UI 统一资产包；验收：同相机、同光源、同比例、同透视，logical asset ID 完整，不混入旧 scene fragment。

- [ ] **V02-VISUALREBUILD-005 TownStage runtime visual match 纵切**
  Owner：Godot / Tech Art / QA Agent；依赖：V02-VISUALREBUILD-003、V02-VISUALREBUILD-004；交付物：Godot 1280 runtime frame、visual layout binding、必要交互代理和并排 proof；验收：runtime screenshot 与 target frame 并排复核达到 `runtime_visual_match`，真实入口不退化。

- [ ] **V02-VISUALREBUILD-006 Art-direction gate 与 StoryBatch 解锁判定**
  Owner：PM / Art Direction / UX / QA Agent；依赖：V02-VISUALREBUILD-005；交付物：final gate 记录、截图包、阻塞解除或继续返修结论；验收：只有 `runtime_visual_match`、真实入口、A-Z 稳定、儿童安全文本和 PM / Art Direction 通过后，`V02-STORYBATCH-004` 才能转 Ready。

## 阶段 0：框架与管理基线

- [x] **V02-BASE-001 产品定位与体验原则**
  Owner：PM Agent；交付物：`docs/01_产品总纲.md`、`docs/02_目标用户与体验原则.md`；验收：目标用户、产品边界、儿童端与家长端原则明确。
- [x] **V02-BASE-002 学习与 A-Z 基线**
  Owner：Curriculum / Memory Palace Agent；依赖：V02-BASE-001；交付物：`docs/03_英语学习与0基础进阶体系.md`、`docs/04_A-Z记忆宫殿与记忆卡系统.md`；验收：0 基础阶梯和稳定 A-Z 编码原则明确。
- [x] **V02-BASE-003 世界、玩法与系统设计基线**
  Owner：PM / Game Design Agent；依赖：V02-BASE-001；交付物：`docs/05` 至 `docs/10`；验收：地图、主循环、NPC/语音、小游戏、家长后台和美术边界明确。
- [x] **V02-BASE-004 技术架构与开发路线**
  Owner：Godot Dev / PM Agent；依赖：V02-BASE-003；交付物：`docs/11_Godot技术架构.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`；验收：技术分层、阶段路线、任务和测试标准明确。
- [x] **V02-BASE-005 首批内容基线**
  Owner：Curriculum / PM Agent；依赖：V02-BASE-002；交付物：`docs/14_内容基线整理与首批内容规划.md`；验收：首批场景、卡片、事件、NPC、语音和小游戏内容明确。
- [x] **V02-BASE-006 项目接管与首轮任务包**
  Owner：PM Agent；依赖：V02-BASE-004；交付物：`docs/15_项目经理接管与下一阶段执行计划.md`、`docs/collaboration/首轮任务包_阶段1启动.md`；验收：近期里程碑、优先级、风险和首轮任务明确。
- [x] **V02-BASE-007 协作与贡献规范**
  Owner：PM Agent；交付物：`AGENTS.md`、`docs/collaboration/多Agent协作规范_v0.2.md`、`docs/collaboration/任务交接模板.md`；验收：任务分配、交付和验收流程明确。
- [x] **V02-BASE-008 项目执行台账与经验库**
  Owner：PM Agent；依赖：V02-BASE-006；交付物：`todo.md`、`lessons.md`；验收：覆盖阶段 0-8，建立每轮状态与经验维护规则。
- [x] **V02-BASE-009 统一首批 anchor 数量描述**
  Owner：PM / Memory Palace Agent；依赖：V02-BASE-005；交付物：修正内容基线中的“8 个”为“9 个”；验收：文字数量与 A/B/C/D/K/O/S/T/W 一致，并复核相关文档。
- [x] **V02-BASE-010 确认首测设备与自动测试方案**
  Owner：PM / Godot Dev / QA Agent；依赖：V02-CORE-001；交付物：Android 屏幕基线和测试 runner 决策记录；验收：后续任务无需再决定测试入口与首测尺寸。

## 阶段 1：Godot 项目骨架

- [x] **V02-CORE-001 创建 Godot 4.x 移动端项目骨架**
  Owner：Godot Dev Agent；依赖：V02-BASE-006；交付物：`project.godot`、可运行主场景；验收：Godot 可打开，`godot --headless --path . --quit` 正常退出。
- [x] **V02-CORE-002 建立基础目录结构**
  Owner：Godot Dev Agent；依赖：V02-CORE-001；交付物：`scenes/`、`scripts/`、`data/`、`assets/`、`tests/`；验收：路径符合技术架构并有最小运行说明。
- [x] **V02-CORE-003 配置共享工具路径与 Git 忽略规则**
  Owner：Godot Dev Agent；交付物：`.gitignore`、`config/shared_tools_paths.env.example`、共享工具说明；验收：凭据、Godot 缓存、共享工具副本和日志被排除。
- [x] **V02-CORE-004 建立 Local SaveService stub**
  Owner：Godot Dev Agent；依赖：V02-CORE-001；交付物：SaveService 脚本与测试；验收：profile、GameState、LearningRecord 可往返保存。
- [x] **V02-CORE-005 建立 ThemeProfile 与 AssetResolver 占位**
  Owner：Asset / Godot Dev Agent；依赖：V02-CORE-002；交付物：主题数据和资源解析器；验收：玩法脚本不硬编码具体资产路径。

## 阶段 2：地图编辑与运行时生成

- [x] **V02-MAP-001 定义 WorldMap/Place/Road/District Resource 与最小 JSON**
  Owner：Map Tool Agent；依赖：V02-CORE-001/002；交付物：Resource、schema 说明、`world_map.json`；验收：Home/Town Start/Supermarket 和 9 个首批 anchor 可加载。
- [x] **V02-MAP-002 建立 EditorOnly proxy 节点结构**
  Owner：Map Tool Agent；依赖：V02-MAP-001；交付物：WorldOverviewScene 编辑层；验收：可拖动 place marker，运行时不依赖 EditorOnly。
- [x] **V02-MAP-003 实现 grid overlay**
  Owner：Map Tool Agent；依赖：V02-MAP-002；交付物：编辑器网格；验收：编辑 cell 与运行时逻辑 cell 一致。
- [x] **V02-MAP-004 实现 road cell 编辑**
  Owner：Map Tool Agent；依赖：V02-MAP-003；交付物：道路编辑工具；验收：可添加、删除道路 cell。
- [x] **V02-MAP-005 实现 occupied/interaction cell 编辑**
  Owner：Map Tool Agent；依赖：V02-MAP-003；交付物：碰撞与交互编辑工具；验收：interaction 不允许落在 occupied。
- [x] **V02-MAP-006 实现地图编辑撤销/重做**
  Owner：Map Tool Agent；依赖：V02-MAP-004/005；交付物：editor command stack；验收：地图编辑操作可撤销和重做。
- [x] **V02-MAP-007 实现地图 JSON 导入/导出**
  Owner：Map Tool Agent；依赖：V02-MAP-001/006；交付物：MapEditorSyncService；验收：JSON 往返后数据一致。
- [x] **V02-MAP-008 实现地图校验脚本**
  Owner：QA / Map Tool Agent；依赖：V02-MAP-001；交付物：校验服务和测试；验收：非法 ID、区域、道路连接、交互点和 A-Z 顺序可拦截。
- [x] **V02-RUNTIME-001 实现 RuntimeMapBuilder**
  Owner：Godot Dev Agent；依赖：V02-CORE-001/002、V02-MAP-001；交付物：运行时地图生成器；验收：从 JSON 显示 Home、Town Start、Supermarket 占位。
- [x] **V02-RUNTIME-002 生成 TileMapLayer 和 roads**
  Owner：Godot Dev Agent；依赖：V02-RUNTIME-001；交付物：运行时地面与道路；验收：地面和道路正确可见。
- [x] **V02-RUNTIME-003 生成 landmark、hotspot 和 collision**
  Owner：Godot Dev Agent；依赖：V02-RUNTIME-002、V02-MAP-005；交付物：运行时对象；验收：点击和碰撞与数据一致。
- [x] **V02-RUNTIME-004 生成完整 A-Z anchor markers**
  Owner：Godot Dev Agent；依赖：V02-RUNTIME-001、V02-AZ-001；交付物：anchor layer；验收：26 个 anchor 数据完整，首批 9 个可见或可互动。

## 阶段 3：A-Z 与 Memory Card

- [x] **V02-AZ-001 提取 A-Z core anchor 表**
  Owner：Memory Palace Agent；依赖：V02-BASE-009；交付物：26 个 core anchor 数据；验收：A=Apple，`route_order` 1-26 唯一。
- [x] **V02-AZ-002 绑定 0 基础词与教材来源**
  Owner：Curriculum Agent；依赖：V02-AZ-001；交付物：curriculum refs；验收：每张 core card 有来源或补齐标记。
- [x] **V02-CARD-001 实现 MemoryCardService**
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-AZ-001；交付物：卡片状态服务和测试；验收：Seen/Heard/Played/Collected/Shiny 可保存。
- [x] **V02-CARD-002 设计并实现 Memory Album 第一版**
  Owner：UI/UX / Godot Dev Agent；依赖：V02-CARD-001、V02-CORE-005；交付物：相册 UI；验收：孩子端像收藏相册，不像单词表。

## 阶段 4：Home / Pet / Shop / Coins 主循环

- [x] **V02-LOOP-001 定义宠物食物循环状态与奖励规则**
  Owner：Game Design Agent；依赖：V02-BASE-005；交付物：事件、状态变化、coins 和奖励规则；验收：完整闭环可实现且无强考核表达。
- [x] **V02-PET-001 实现 PetService**
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-LOOP-001；交付物：宠物状态服务和测试；验收：Sunny/Dog 可饿、可喂、可反馈。
- [x] **V02-SHOP-001 实现 ShopService**
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-LOOP-001；交付物：商店购买服务和测试；验收：coins 可购买食物并保存。
- [x] **V02-QUEST-001 实现 QuestEventService 最小版**
  Owner：Godot Dev Agent；依赖：V02-PET-001、V02-SHOP-001；交付物：事件服务；验收：宠物需求可触发小游戏和购买链。
- [x] **V02-UI-001 设计并实现触屏 Home/Pet UI**
  Owner：UI/UX / Godot Dev Agent；依赖：V02-CORE-005、V02-PET-001；交付物：Home/Pet 场景与 UI；验收：横屏手机和平板触控区域足够。
- [x] **V02-LOOP-002 接通主循环端到端流程**
  Owner：Godot Dev / QA Agent；依赖：V02-QUEST-001、V02-MINI-003、V02-CARD-001、V02-UI-001；交付物：可玩闭环和 smoke test；验收：从宠物饿到喂食、反馈、卡片和保存全链路通过。

## 阶段 5：小游戏框架与 Letter Snake

- [x] **V02-MINI-001 定义 Letter Snake 规则与配置**
  Owner：Minigame Agent；依赖：V02-LOOP-001、V02-AZ-002；交付物：四组目标、结果和奖励配置；验收：支持目标字母/单词且任意分数有奖励。
- [x] **V02-MINI-002 实现 MinigameService**
  Owner：Godot Dev Agent；依赖：V02-MINI-001、V02-CARD-001；交付物：小游戏服务；验收：可启动、返回结果、写学习记录和发奖励。
- [x] **V02-MINI-003 实现 Letter Snake 原型**
  Owner：Godot Dev Agent；依赖：V02-MINI-002；交付物：小游戏场景；验收：分数转换为 coins 和 card progress，能返回原场景。
- [x] **V02-MINI-004 测试奖励差异与无失败表达**
  Owner：QA Agent；依赖：V02-MINI-003；交付物：奖励测试；验收：低分有奖励、高分更多，孩子端无 failed/wrong/test。

## 阶段 6：语音、NPC 与 AI 本地桩

- [x] **V02-VOICE-001 定义 VoiceLine schema**
  Owner：Voice/AI Agent；依赖：V02-BASE-005；交付物：语音数据；验收：支持 text、audio_id、TTS/录音/跟读预留字段。
- [x] **V02-VOICE-002 实现 VoiceService stub**
  Owner：Godot Dev Agent；依赖：V02-VOICE-001；交付物：语音服务和测试；验收：mock 播放和录音调用不报错、不申请权限。
- [x] **V02-AI-001 定义 NPC profile/memory schema**
  Owner：Voice/AI / Narrative Agent；依赖：V02-BASE-005；交付物：NPC profile、memory 和固定对白数据；验收：首批 NPC 均有安全边界与本地数据。
- [x] **V02-AI-002 实现 LLMClient stub**
  Owner：Godot Dev Agent；依赖：V02-AI-001；交付物：AI client；验收：返回固定安全占位回复，不连接真实模型。
- [x] **V02-AI-003 实现 ConversationSummary stub**
  Owner：Godot Dev Agent；依赖：V02-AI-001/002；交付物：摘要服务；验收：可生成并保存家长端可读的本地摘要。
- [x] **V02-NPC-001 接入首批固定 NPC 对话**
  Owner：Narrative / Godot Dev Agent；依赖：V02-AI-001、V02-VOICE-002；交付物：Mina、Shopkeeper、Pet Buddy、Bus Helper、Story Bear 对话；验收：无真实 AI 时可完成首期互动。

## 阶段 7：家长后台与本地摘要

- [x] **V02-PARENT-001 定义家长入口与触屏流程**
  Owner：UI/UX Agent；依赖：V02-BASE-001；交付物：入口和 UI 规格；验收：不进入孩子主流程。
- [x] **V02-PARENT-002 实现 ParentDashboardStore stub**
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-AI-003、V02-MINI-002；交付物：dashboard 数据服务；验收：可读取 card/minigame/NPC 本地摘要。
- [x] **V02-PARENT-003 校验孩子端不显示后台内容**
  Owner：QA Agent；依赖：V02-PARENT-001/002；交付物：可见性测试；验收：主流程无家长报告 UI。
- [x] **V02-PARENT-004 实现本地家长摘要界面**
  Owner：UI/UX / Godot Dev Agent；依赖：V02-PARENT-001/002；交付物：本地 dashboard；验收：家长可查看摘要与设置，孩子端流程不受影响。

## 阶段 8：远期能力

> 本阶段任务必须在第一阶段主循环验收后才能进入 Ready；每项仍需单独设计、隐私评审和范围确认。

- [x] **V02-FUTURE-001 实现 AccountAdapter 与本地账号迁移接口**
  Owner：Godot Dev Agent；依赖：V02-CORE-004、V02-LOOP-002；验收：不改变现有本地 profile 行为，可替换账号后端。
- [x] **V02-FUTURE-002 实现 Cloud Save 与冲突处理**
  Owner：Godot Dev / QA Agent；依赖：V02-FUTURE-001；验收：多设备同步、离线恢复和冲突策略通过测试。
- [x] **V02-FUTURE-003 实现 ContentPackLoader 与内容包更新**
  Owner：Godot Dev / Curriculum Agent；依赖：V02-MAP-007、V02-CARD-001；验收：内容包可校验、安装、回滚且不覆盖核心 A-Z 编码。
- [x] **V02-FUTURE-004 接入真实 TTS、录音与跟读能力**
  Owner：Voice/AI / Godot Dev Agent；依赖：V02-VOICE-002、家长隐私审批；验收：权限、隐私、失败降级和移动端性能通过评审。
- [x] **V02-FUTURE-005 接入真实 AI NPC 与长期记忆**
  Owner：Voice/AI / Godot Dev Agent；依赖：V02-AI-003、家长隐私审批；验收：内容安全、角色边界、摘要和降级策略通过评审。
- [x] **V02-FUTURE-006 实现异步互访与家长批准好友**
  Owner：Godot Dev / QA Agent；依赖：V02-FUTURE-001/002；验收：无陌生人开放社交，权限和举报流程通过评审。
- [x] **V02-FUTURE-007 实现受控多人互动**
  Owner：Godot Dev / Game Design Agent；依赖：V02-FUTURE-006；验收：仅预设短语、表情或受控合作玩法，儿童安全通过评审。
- [x] **V02-FUTURE-008 实现第二主题与主题包切换**
  Owner：Asset / Godot Dev Agent；依赖：V02-CORE-005、V02-FUTURE-003；验收：无需修改玩法脚本即可切换主题。
- [x] **V02-FUTURE-009 完成 Android/iOS/平板深度适配**
  Owner：Godot Dev / UI/UX / QA Agent；依赖：V02-LOOP-002；验收：目标设备上的性能、触控、安全区、音频和存档通过测试。
- [x] **V02-FUTURE-010 建立 AI 辅助内容生产与人工审核管线**
  Owner：Curriculum / Voice/AI / QA Agent；依赖：V02-FUTURE-003；验收：候选内容可追溯、规则校验、人工批准后才可发布。

## 跨阶段质量门槛

- [x] **V02-QA-001 数据合同测试集**：schema load、JSON round-trip、ID 唯一、A-Z 顺序和地图校验全部通过。
- [x] **V02-QA-002 运行时 smoke 测试集**：地图加载、卡片状态、Pet/Shop/Coins、小游戏奖励、Voice/AI stub 全部通过。
- [x] **V02-QA-003 儿童体验检查**：孩子端无强考核、课程表、失败惩罚、家长报告或开放陌生人社交。
- [x] **V02-QA-004 移动端验收**：目标横屏设备上的触控区域、安全区、布局和性能通过。

## 完成记录

| 日期 | 轮次 | 完成事项 | 验证依据 |
|---|---|---|---|
| 2026-06-04 | 项目接管 | V02-BASE-001 至 V02-BASE-008、V02-CORE-003 | 对应文档与配置文件存在并完成内容复核；Godot `4.6.3.stable` 可用 |
| 2026-06-04 | Round 1 | V02-BASE-009、V02-BASE-010 | anchor 描述已统一为 9 个；测试 runner 与 Android 视口基线已写入执行计划 |
| 2026-06-04 | Stage 0 收尾 | V02-BASE-007 工作标准对齐 | `AGENTS.md` 已更新为阶段 1 目标、台账流程、技术标准与产品边界 |
| 2026-06-04 | Round 1 验收 | V02-CORE-001/002、V02-MAP-001/008、V02-RUNTIME-001 | Godot 主场景与编辑器加载通过；JSON 断言通过；headless 合同与运行时 loader 测试通过 |
| 2026-06-04 | Round 2 验收 | V02-CORE-004/005、V02-RUNTIME-002 | SaveService、AssetResolver、运行时道路/地点/anchor 可视化通过独立测试和统一 headless runner |
| 2026-06-04 | Round 3 验收 | V02-AZ-001、V02-LOOP-001、V02-MINI-001 | A-Z core、宠物食物循环、Letter Snake 配置与内容引用测试全部通过 |
| 2026-06-04 | Round 4 验收 | V02-AZ-002、V02-CARD-001、V02-PET-001、V02-SHOP-001 | 扩展卡、MemoryCardService、PetService、ShopService 通过独立测试与汇合引用测试 |
| 2026-06-04 | Round 5 验收 | V02-MINI-002、V02-QUEST-001 | MinigameService、QuestEventService 与服务级 Sunny 食物循环 smoke 通过；V02-LOOP-002 因缺 Letter Snake 场景和触屏 UI 保持待办 |
| 2026-06-04 | Round 6 验收 | V02-MINI-003、V02-UI-001、V02-LOOP-002、V02-MINI-004 | Letter Snake 原型、Home/Pet 触屏入口、可玩主循环 smoke、奖励差异与禁用词测试通过 |
| 2026-06-04 | Round 7 验收 | V02-CARD-002、V02-RUNTIME-003、V02-RUNTIME-004 | Memory Album、运行时 hotspot/collision、完整 26 个 A-Z anchor marker 通过全量回归 |
| 2026-06-04 | Round 8 验收 | V02-VOICE-001/002、V02-AI-001/002/003、V02-PARENT-002 | VoiceService、NPCMemoryStore、LLMClient、ConversationSummaryService、ParentDashboardStore 本地 stub 测试通过 |
| 2026-06-04 | Round 9 验收 | V02-LIFE-001/002/003 | 主场景新增 LifeRPGPanel、Player 移动/点击移动、碰撞阻挡、Mina/Shopkeeper/Pet Buddy 标记和 NPC 关系存档；`test_life_rpg_scene`、`headless_runner`、旧 playable loop smoke 通过 |
| 2026-06-04 | Round 10 验收 | V02-LIFE-004/005/006 | 新增 life item 数据、InventoryService、LifeShopService、HomeDecorationService；主场景可捡 branch、买 wooden_chair、摆放家具并保存；`test_life_services`、`test_life_rpg_scene`、`headless_runner` 通过 |
| 2026-06-04 | Round 11 验收 | V02-LIFE-007/009/010 | 生活 MVP smoke 已覆盖移动、NPC、收集、购买、摆放、保存；`world_map.memory_anchors` 扩展为 26 个 A-Z 锚点；`test_memory_palace_embedding` 校验锚点顺序和新词故事编码绑定 |
| 2026-06-04 | Round 12 验收 | V02-LIFE-008 | 主场景新增可选活动面板，Memory Album / Letter Snake 保留为 side activities；Sunny 主流程通过 Help Neighbor 生活动作获得 coins，不再要求 Letter Snake；`test_playable_loop_smoke`、`test_life_rpg_scene`、`headless_runner` 通过 |
| 2026-06-04 | Round 13 验收 | V02-LIFE-011 | 主场景 LifeRPGPanel 降级 Pick/Buy/Place 调试按钮为统一 `Interact`；`interact_nearby()` 覆盖 NPC 对话、branch 收集、超市购买、家门口摆放和空格无目标反馈；`test_life_rpg_scene` 通过 |
| 2026-06-04 | Round 14 验收 | V02-NPC-001 | 主场景生成 Mina、Shopkeeper、Pet Buddy、Bus Helper、Story Bear 五个 NPC marker；统一 `interact_nearby()` 使用 profile fallback 本地固定对白，写入 `npc_relationships` 和 `npc_memory.recent_events`，无网络/真实 AI；`test_life_rpg_scene`、`test_ai_npc_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 15 验收 | V02-PARENT-001/003 | 新增家长入口触屏流程合同和 `Main.get_parent_entry_spec()`；孩子端主导航移除 `Parent`，`test_life_rpg_scene` 与 `test_playable_loop_smoke` 扫描可见文本，验证主流程无家长后台/报告 UI |
| 2026-06-04 | Round 16 验收 | V02-PARENT-004 | 新增独立 `ParentDashboard` 场景和脚本，读取 `ParentDashboardStore` 展示本地概览、卡片、活动、NPC 摘要和隐私设置；`test_parent_dashboard_scene` 验证 parent-only、本地无账号/网络/录音且孩子端未挂载 dashboard |
| 2026-06-04 | Round 17 验收 | V02-MAP-002 | `WorldOverviewScene` 编辑层生成 `EditorOnlyProxyRoot` 和 place proxy marker，支持测试移动 marker 且不写回 JSON；运行时 `Main` 和 `RuntimeMapBuilder` 不依赖 EditorOnly；`test_world_overview_editor_proxy`、`headless_runner` 通过 |
| 2026-06-04 | Round 18 验收 | V02-LIFE-012 | Home、Town Start、Supermarket 入口统一返回 `place_entry`，只更新中性地点状态，不再自动发 coins、购买 `wooden_chair` 或摆放家具；显式 Help Neighbor、购买和摆放动作仍可用；`test_life_rpg_scene`、`test_playable_loop_smoke`、`test_life_services`、`headless_runner` 通过 |
| 2026-06-04 | Round 19 验收 | V02-LIFE-013 | 新增 `DailyRequestService` 和 `data/life/daily_requests.json`；Mina 可接取 branch 轻委托，收集后交付会消耗 branch、发 6 coins、写入 Mina 关系和 NPC memory，同日重复不重复奖励；`test_daily_request_service`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`test_life_services`、`headless_runner` 通过 |
| 2026-06-04 | Round 20 验收 | V02-MAP-003 | `WorldOverviewScene` 新增 `EditorOnlyGridOverlay`，网格尺寸与 `world_map.json` 的 `canvas_size` / `cell_size` 对齐；`test_world_overview_grid_overlay`、`test_world_overview_editor_proxy`、`headless_runner` 通过 |
| 2026-06-04 | Round 21 验收 | V02-MAP-004/005 | 编辑器支持 road cell 添加/删除、occupied cell 设置和 interaction cell 设置；interaction 落在 occupied 时返回 `interaction_over_occupied`；`test_world_overview_cell_editing`、`headless_runner` 通过 |
| 2026-06-04 | Round 22 验收 | V02-MAP-006 | 编辑器 command stack 覆盖 road、occupied、interaction 和 place marker move，支持 undo/redo；`test_world_overview_cell_editing`、`headless_runner` 通过 |
| 2026-06-04 | Round 23 验收 | V02-MAP-007 | 新增 `MapEditorSyncService`，支持 JSON 导入和 editor state 导出，导出结果通过 `WorldMapContract` 且保留 26 个 A-Z anchors；`test_world_overview_cell_editing`、`headless_runner` 通过 |
| 2026-06-04 | Round 24 验收 | V02-QA-001/002/003/004 | `headless_runner` 汇总数据合同、运行时 smoke、孩子端禁显文本、家长入口隔离、移动 viewport/renderer/safe area/touch nav 基线；`godot --headless --path . --quit` 与 `headless_runner` 通过 |
| 2026-06-04 | Round 25 验收 | V02-FUTURE-001 | 新增 `AccountAdapter` 本地账号 stub，暴露 `guest:local_profile`，迁移接口幂等且不改变 `SaveService`；`test_account_cloud_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 26 验收 | V02-FUTURE-002 | 新增 `CloudSaveAdapter` 本地云存档模拟，支持双 device slot、离线队列、冲突副本和 last-write，本地 stub 不联网不上传；`test_account_cloud_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 27 验收 | V02-FUTURE-003 | 新增 `ContentPackLoader`，支持本地内容包校验、安装、回滚，拒绝覆盖核心 A-Z anchor，新增词必须有记忆宫殿故事绑定字段；`test_content_theme_review_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 28 验收 | V02-FUTURE-004/005 | 新增 `VoiceProviderAdapter` 与 `AINPCProviderAdapter`，真实 provider 需要家长隐私 gate，默认走本地 voice/AI stub，不联网、不录音、不上传；`test_voice_ai_social_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 29 验收 | V02-FUTURE-006/007 | 新增 `FriendVisitService`，仅允许家长批准的本地 friend profile、预设短语、表情和合作事件，阻止陌生人和自由文本；`test_voice_ai_social_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 30 验收 | V02-FUTURE-008 | 新增第二主题 `theme_rainbow_garden_placeholder` 和 `ThemeSwitchService`，继续通过逻辑 asset ID 解析主题资源；`test_content_theme_review_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 31 验收 | V02-FUTURE-009 | 移动端基线纳入 `headless_runner`，验证 1280x720、mobile renderer、safe area、触控导航宽度和主场景性能 smoke；`godot --headless --path . --quit` 与 `headless_runner` 通过 |
| 2026-06-04 | Round 32 验收 | V02-FUTURE-010 | 新增 `ContentReviewPipeline`，候选内容必须人工批准后才能发布到 runtime，本地审核不联网；`test_content_theme_review_stubs`、`headless_runner` 通过 |
| 2026-06-04 | Round 33 验收 | Final Integration | `todo.md` 全部可执行项已完成，地图编辑器、远期本地 stub、跨阶段 QA 全量回归通过；`godot --headless --path . --quit`、focused tests、`tests/headless_runner.gd` 通过 |
| 2026-06-04 | Round 36 验收 | V02-UI-004 | `RuntimeMap` 改为 `Node2D`，地面、道路、建筑、物件化 A-Z anchors、动物居民和玩家均由 `Sprite2D` 风格节点组成；右侧状态面板收为左侧小气泡 HUD；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner`、`godot --headless --path . --quit` 通过；MCP 成功捕获 1280x720 首屏截图并确认小镇 playfield 节点结构可见 |
| 2026-06-04 | Round 37 验收 | V02-UI-005 | 孩子端主界面标题、导航、HUD 气泡、操作按钮、背包状态、地点进入、移动、收集、购买、喂养和 NPC 显示名改为中文；英文仅保留 `Sunny`、`Letter Snake` 等环境/系统资产名；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 38 验收 | V02-UI-006 | 移除覆盖地图的左侧 `LifeRPGPanel`、`HomePetLoopPanel`、`OptionalActivityPanel` 三块大面板；消息、生活状态和背包摘要集中到顶部 `TownHUD` 一排；所有操作与导航集中到底部 `TownFooter` 一排按钮；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner`、`godot --headless --path . --quit` 通过；MCP 截图与节点属性确认顶底栏布局生效 |
| 2026-06-04 | Round 39 验收 | V02-UI-007 | 删除独立 `Header` 顶部横幅，将“阳光小镇”、开放状态、今日提示、循环状态和背包摘要合并到 48px 高的单行 `TownHUD`；底部 `TownFooter` 保持一排操作按钮；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner` 通过；MCP 截图与节点属性确认首屏顶部只剩一条紧凑 HUD |
| 2026-06-04 | Round 40 验收 | V02-UI-008 | 底部 `TownFooter` 可见操作精简为 `看看`、`小镇`、`小屋`、`背包` 四个按钮；`StartButton`、`HelpNeighborButton`、`BuyFoodButton`、`FeedSunnyButton`、`MemoryAlbumButton`、`LetterSnakeButton` 移入隐藏 `FooterContractButtons` 保持测试/脚本入口；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner` 通过；MCP 截图与场景树确认孩子端底栏仅四个可见按钮 |
| 2026-06-04 | Round 41 验收 | V02-UI-009 | 底部 `TownFooter` 收窄居中并改为柔和暖色底托；四个可见按钮改为圆角胶囊，主操作/选中导航使用暖黄色强调，普通导航使用浅色，normal/hover/pressed/focus 状态齐全；`check-only`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`headless_runner` 通过；MCP 截图与节点属性确认底栏约 647px 居中显示 |
| 2026-06-04 | Round 42 验收 | V02-UI-010 | 底部 `背包` 按钮打开轻量 `BackpackBubble`，展示金币、Sunny 点心、树枝、木椅、相册和 Letter Snake 入口说明；顶部 HUD 新增独立 `CoinState` 金币 badge，并将 `PetState` 收为点心、饥饿、开心三项，金币和宠物状态视觉分组；`check-only`、`test_life_rpg_scene`、`headless_runner` 通过；MCP 场景树确认 `CoinState` / `PetState` 独立存在 |
| 2026-06-04 | Round 43 规划 | 长期路线 | 新增“长期路线：生活小镇从原型到长期可玩”章节，确定 V02.1 每日小镇、V02.2 我的小屋、V02.3 小镇记忆宫殿、V02.4 内容生产框架四个里程碑，并将 `V02-DAILY-001` 设为下一项 Ready |
| 2026-06-04 | Round 44 验收 | V02.1 每日小镇 | 新增 `LocalDayService`、每日问候、每日资源刷新、今日状态和多 NPC 轻委托；Mina、店长、Sunny、故事熊、巴士哥哥每日问候按 day_key 保存，树枝/小花/小石子按日刷新，店长/故事熊/Sunny 新增轻委托；`jq`、`test_daily_request_service`、`test_daily_town_services`、`test_v021_daily_town_contract`、`test_life_rpg_scene`、`test_playable_loop_smoke`、`test_life_services`、`test_memory_palace_embedding`、`check-only`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 45 验收 | V02.2 我的小屋 | 新增独立 `HomeRoom` 小屋视图，`小屋`/`小镇` 底栏可切换；家具目录扩展小桌、地毯、花盆、宠物碗、Sunny 小床和墙饰；`HomeDecorationService` 支持摆放、旋转、移动、收起、非法格温和反馈和 Sunny 家内反馈；`jq`、`test_v022_home_room_contract`、`test_life_services`、`test_life_rpg_scene`、`test_memory_palace_embedding`、`check-only`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 46 验收 | V02.3 小镇记忆宫殿 | 新增 `AnchorInteractionService` 和新词回访数据，靠近 A-Z anchor 使用 `看看` 会写入相册 seen/heard/collected 并显示温和故事；首批 A/B/C/D/K/O/S/T/W 保持 Sprite2D 场景物件表现；`test_v023_memory_palace_world`、`test_memory_album_scene`、`test_memory_palace_embedding`、`check-only`、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 47 验收 | V02.4 内容生产框架 | 新增 `ContentContractValidator` 和 V02.4 内容合同测试，覆盖每日委托、每日问候、家具商品、新词故事、核心 A-Z 覆盖拦截和数据化 loader 回归；`find data -name '*.json' -print0 | xargs -0 jq empty`、`test_v024_content_contracts`、`check-only`、`headless_runner`、`test_life_rpg_scene`、`test_v022_home_room_contract`、`test_v023_memory_palace_world`、`godot --headless --path . --quit` 通过 |
| 2026-06-04 | Round 48 验收 | 真实可玩路径修复 | 背包气泡新增可见相册入口并打开中文相册覆盖层；靠近商店 `看看` 打开可见货架，商品按钮可购买家具并刷新背包/HUD；小屋新增物件面板，可从可见按钮摆放、旋转、收起家具；新增 `test_playable_ui_operations` 并注册进 `headless_runner`；`check-only`、`test_memory_album_scene`、`test_playable_ui_operations`、`test_playable_loop_smoke`、`test_life_rpg_scene`、V02.1-V02.4 contract tests、`headless_runner`、`godot --headless --path . --quit` 通过 |
| 2026-06-05 | Round 49 规划 | PM 路线更新 | 更新 `todo.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/10_美术风格与换肤预留.md`、`docs/14_内容基线整理与首批内容规划.md`；新增 V02.5-V02.7 路线与 `V02-ART-001` 到 `V02-POLISH-004`，未运行 Godot 验证 |
| 2026-06-05 | Round 50 规划 | V02.5 美术素材生产线文档清单 | 完成 `V02-ART-001` 至 `V02-ART-005`：资产目录与命名规范、小镇场景、角色宠物、家具家园、UI 图标与状态素材清单均写入 `docs/10_美术风格与换肤预留.md`；未运行 Godot 验证 |
| 2026-06-05 | Round 51 PM 分派 | V02.6 策划内容生产线收口与 V02.7 小组任务安排 | 核对 `docs/14_内容基线整理与首批内容规划.md` 中 `V02-DESIGN-005` 已包含晴天、雨天/雨后、微风、集市日、儿童节、小镇庆祝等轻事件规划，并将 `V02-DESIGN-005` 标记完成；新增 `docs/collaboration/Round51_V02.7发布前质量门槛任务包.md`，分派 `V02-POLISH-001` 至 `V02-POLISH-004` 给 UX/Godot/QA、QA/UI/Art、QA/UX/Godot、Art/Asset/QA 小组；子小组补充 `Round51_UXQA_Polish001_002验收草案.md` 与 `Round51_V02-POLISH-003-004_QA-Asset验收草案.md`；文档一致性检查、`godot --headless --path . --quit`、`godot --headless --path . --script tests/headless_runner.gd` 通过 |
| 2026-06-05 | Round 52 验收 | V02.7 发布前体验门槛实现与验收表落地 | `scripts/main.gd` 新增顶部设置入口、`SettingsPanel`、声音开关、回到小镇安全位置、休息二次确认和退出入口；`tests/test_playable_ui_operations.gd` 与 `tests/headless_runner.gd` 覆盖设置真实可见路径、底栏不新增退出、二次确认和安全位置；新增 `docs/collaboration/Round52_V02.7发布前体验门槛执行记录.md`；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；`V02-POLISH-004` 因尚未接入正式素材保持进行中 |
| 2026-06-05 | Round 52 素材验收收口 | V02-POLISH-004 首批正式素材替换验收 | 接入 P0 production 素材：Town Plaza、Home、Shop、主路、树枝、玩家、Mina、Sunny、金币图标和背包图标；新增 `ThemeProfile` 分类、`AssetResolver` 查询、主场景逻辑 asset 纹理加载和运行时纹理断言；MCP 捕获 1280x720 首屏截图并抽查运行树；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过 |
| 2026-06-05 | Round 54 规划启动 | V02.7A 美术基线重建与 V02.8 每日小镇生活纵切 | 按 `AGENTS.md` 文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；将 `V02-POLISH-005` 并入 V02.7A 重评，新增 `V02-ARTBASE-001` 至 `005` 与 `V02-DAILYLIFE-001` 至 `005`；本轮只改 PM 文档和台账，未改运行时代码，未运行 Godot 验证 |
| 2026-06-05 | Round 54 PM 执行落地 | V02.7A 任务包、审计记录与 PM 节奏收口 | 新增 `docs/collaboration/Round54_V02.7A-V02.8_PM执行任务包.md` 与 `docs/collaboration/Round54_V02-ARTBASE-001首屏视觉目标与资产降级审计记录.md`；在 `docs/10_美术风格与换肤预留.md` 增补 `placeholder_plus` 状态定义；在 `docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md` 写入 Round 54 分派顺序、PM 节奏与 V02.8 开工门槛；仅改 PM 文档和台账，未改运行时代码，未运行 Godot 验证 |
| 2026-06-05 | Round 54 工作区核对 | V02.7A 候选实现与阶段门槛复核 | 核对未提交改动确认 `ThemeProfile` / `AssetResolver`、主场景和 `assets/art/` 已存在 Town Plaza、Home、Shop、主路、树枝、玩家、Mina、Sunny、店长、家具与部分 UI 图标的候选接入；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；因 `1280x720` / `960x540` V02.7A 截图尚未补齐，`V02-ARTBASE-002`、`003`、`004` 维持候选实现状态，`V02-ARTBASE-005` 仍是进入 V02.8 的唯一门槛 |
| 2026-06-05 | Round 54 截图证据复核 | V02-ARTBASE-005 运行时证据与工具链限制补记 | 通过 Godot MCP 捕获 `/root/Main` 的 `1280x720` 运行时截图，并核对 TownHUD、TownFooter 与主场景节点存在；旧截图 capture 脚本与截图证据已清理；dummy renderer 截图限制见 `LESSON-010`，当前视觉证据以 Round95/96 保留文件为准 |
| 2026-06-05 | Round 55 验收 / Round 56 启动 | V02-DAILYLIFE-001 三 NPC 日常入口收口与 V02-DAILYLIFE-002 分派 | Mina、店长、Sunny 均已从主场景真实可见路径靠近并用 `看看` 触发问候 / 轻委托入口，互动写入关系、最近事件或当日状态；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；新增 `docs/collaboration/Round56_V02.8_DAILYLIFE-002_PM执行任务包.md`，将下一轮唯一主任务置为 `V02-DAILYLIFE-002` |
| 2026-06-05 | Round 56 验收 / Round 57 启动 | V02-DAILYLIFE-002 三条 P0 轻委托可玩化收口与 V02-DAILYLIFE-003 分派 | 主场景测试新增 Mina、店长、Sunny 三条 P0 委托真实路径覆盖：`daily_mina_branch_001`、`daily_shopkeeper_flower_001`、`daily_sunny_flower_001` 分别映射路线中的三条 P0 目标；孩子端通过 `看看` 接取、采集资源、交付、获得奖励，并验证同日重复不重复奖励和重载保存状态；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；新增 `docs/collaboration/Round57_V02.8_DAILYLIFE-003_PM执行任务包.md`，将下一轮唯一主任务置为 `V02-DAILYLIFE-003` |
| 2026-06-05 | Round 57 验收 / Round 58 启动 | V02-DAILYLIFE-003 商店到小屋使用闭环收口与 V02-DAILYLIFE-004 分派 | 主场景新增小屋可见 `挪动` 按钮和 `move_home_item()` 路径；操作级测试覆盖从可见商店入口购买木椅、背包气泡即时显示、进入小屋摆放、Sunny 反馈、旋转、挪动并保存坐标、收起并恢复背包；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/test_v022_home_room_contract.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；新增 `docs/collaboration/Round58_V02.8_DAILYLIFE-004_PM执行任务包.md`，将下一轮唯一主任务置为 `V02-DAILYLIFE-004` |
| 2026-06-05 | Round 58 验收 / Round 59 启动 | V02-DAILYLIFE-004 三个 A-Z 地点回访收口与 V02-DAILYLIFE-005 分派 | `data/anchors/new_word_revisit_paths.json` 新增 `story_chair_clock_cozy_time`，补齐 `C Clock` 生活回访故事；`tests/test_v023_memory_palace_world.gd` 新增 C/O/S 三处主场景真实 `看看` 路径验证，确认 card state / 相册状态更新、HUD 显示生活化地点故事且无测验文案；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_v023_memory_palace_world.gd`、`godot --headless --path . --script tests/test_memory_palace_embedding.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；新增 `docs/collaboration/Round59_V02.8_DAILYLIFE-005_PM执行任务包.md`，将下一轮唯一主任务置为 `V02-DAILYLIFE-005` |
| 2026-06-05 | Round 59 验收 | V02-DAILYLIFE-005 5 分钟纵切 smoke 与 V02.8 阶段收口 | 新增并验证 `tests/test_v028_daily_life_slice.gd`，玩家从启动后通过真实可见入口完成 Mina 问候 / 轻委托、树枝采集、交付奖励、商店购买木椅、背包查看、小屋摆放、Sunny 反馈和 C/O/S 三处回访；同一路径已注册进 `tests/headless_runner.gd` 作为全量回归门槛；旧双视口截图证据已清理，当前保留 headless 回归与后续 Round95/96 视觉证据。`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_v028_daily_life_slice.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/test_v023_memory_palace_world.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过 |
| 2026-06-05 | Round 60 验收 / Round 61 Ready | V02-WEEKLY-001 一周回访内容合同与排期收口 | 更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`，新增 `docs/collaboration/Round60_V02.9_WEEKLY-001_PM执行任务包.md`；建立 `local_day_001` 至 `local_day_007` 的今日状态、主居民、轻目标、商店 / 小屋回访、A-Z 线索和儿童安全边界；将下一轮唯一 Ready 置为 `V02-WEEKLY-002 每日状态与商店轮换数据化`；本轮仅改 PM 文档和台账，`godot --headless --path . --script tests/headless_runner.gd` 与 `godot --headless --path . --quit` 通过 |
| 2026-06-05 | Round 61 验收 / Round 62 Ready | V02-WEEKLY-002 每日状态与商店轮换数据化收口 | `data/life/today_status.json` 升级为 7 天稳定状态合同，包含 `day_key`、`primary_npc`、`anchor_hint` 和 `shop_rotation_id`；`data/items/life_items.json` 新增 7 天 `shop_rotations`，覆盖 P0 常驻、P1 日常轮换和 P2 雨后轻变体；`TodayStatusService` 支持按 day_key 稳定命中，`LifeShopService` 支持按 day 或 rotation 读取 offer，`ContentContractValidator` 拦截 today status 与 shop rotation 合同错误；`tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`tests/test_life_services.gd` 和 `tests/headless_runner.gd` 已覆盖 7 天状态、P0 常驻、P1/P2 轮换、买不起不失败和儿童安全文案；验证命令与 `godot --headless --path . --quit` 通过；下一轮唯一 Ready 为 `V02-WEEKLY-003 P1 居民回访入口预收` |
| 2026-06-05 | Round 65 验收 / Round 66 Ready | V02-P1RETURN-001 Bookshop / Bus Stop 真实可见入口收口 | `data/maps/world_map.json` 新增 Bookshop 门口、Bear Corner、Bus Stop 站牌、Taxi marker 四个 P1 return hotspot；`scripts/main.gd` 新增 `look_p1_return_entry` 处理，孩子端通过底栏 `看看` 触发温和反馈并保存 `p1_return_entries`，不发金币、不打开出行或学习流程；新增 `tests/test_v0210_p1_return_entries.gd` 并注册 `tests/headless_runner.gd`，覆盖四个可见入口、P0 商店 / 小屋路径不阻断和儿童安全禁用文案；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --check-only --script tests/test_v0210_p1_return_entries.gd`、`godot --headless --path . --script tests/test_v0210_p1_return_entries.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；下一轮唯一 Ready 为 `V02-P1RETURN-002 故事熊 / 巴士哥哥 P1 轻回访` |
| 2026-06-05 | Round 66 验收 / Round 67 Ready | V02-P1RETURN-002 故事熊 / 巴士哥哥 P1 轻回访收口 | `data/life/daily_requests.json` 新增 `daily_story_bear_find_bear_corner_001` 与 `daily_bus_helper_taxi_spot_001`；`scripts/systems/daily_request_service.gd` 支持 `required_p1_entries`；`scripts/main.gd` 将 Story Bear / Bus Helper 可见 NPC 互动路由到 V02.10 P1 请求；`scripts/systems/content_contract_validator.gd` 允许每日请求使用 `required_items` 或 `required_p1_entries`；新增 `tests/test_v0210_p1_light_returns.gd` 并注册 `tests/headless_runner.gd`，覆盖两条 P1 支线接取、看入口、回 NPC 完成、同日去重和禁用文案；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/systems/daily_request_service.gd`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --check-only --script tests/test_v0210_p1_light_returns.gd`、`godot --headless --path . --script tests/test_v0210_p1_light_returns.gd`、`godot --headless --path . --script tests/test_daily_request_service.gd`、`godot --headless --path . --script tests/test_daily_town_services.gd`、`godot --headless --path . --script tests/test_v024_content_contracts.gd`、`godot --headless --path . --script tests/test_life_rpg_scene.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；下一轮唯一 Ready 为 `V02-P1RETURN-003 B Bear / T Taxi 相册与 A-Z 记录` |
| 2026-06-05 | Round 67 验收 / Round 68 Ready | V02-P1RETURN-003 B Bear / T Taxi 相册与 A-Z 记录收口 | `scripts/main.gd` 为 P1 return entry 增加 `linked_anchor_id -> card_id` 相册落账，Bookshop / Bear Corner 写入 `card_b_bear_core`，Bus Stop / Taxi marker 写入 `card_t_taxi_core`；`tests/test_v0210_p1_return_entries.gd` 与 `tests/test_v0210_p1_light_returns.gd` 覆盖入口查看、轻回访完成、card state seen/heard/collected 和小镇相册“已收藏”显示；`tests/headless_runner.gd` 已注册集成断言；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_v0210_p1_return_entries.gd`、`godot --headless --path . --script tests/test_v0210_p1_light_returns.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；下一轮唯一 Ready 为 `V02-P1RETURN-004 P1 回访 smoke 与截图` |
| 2026-06-05 | Round 68 验收 | V02-P1RETURN-004 P1 回访 smoke 与截图收口 | 新增 `tests/test_v0210_p1_return_smoke.gd`，并在 `tests/headless_runner.gd` 注册 `_check_v0210_p1_return_smoke()`；`godot --headless --path . --check-only --script tests/test_v0210_p1_return_smoke.gd`、`godot --headless --path . --script tests/test_v0210_p1_return_smoke.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；V02.10 P1 居民回访扩展可标记完成，下一轮应由 PM 建立下一阶段路线 |
| 2026-06-05 | Round 69 规划 / Ready | V02.11 天气与小镇轻事件纵切路线建立 | 按文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round69_V02.11_WEATHER-001_PM执行任务包.md`；将 V02.11 拆为 `V02-WEATHER-001` 至 `004`，并将下一轮唯一 Ready 置为 `V02-WEATHER-001 天气轻事件数据合同与今日状态接入`；本轮仅改 PM 文档和台账，验证命令通过 |
| 2026-06-05 | Round 69 验收 / Round 70 Ready | V02-WEATHER-001 天气轻事件数据合同与今日状态接入收口 | 新增 `data/life/weather_events.json`，包含 `event_weather_sunny_soft_001`、`event_weather_breezy_kite_001`、`event_weather_after_rain_001`、`event_weather_light_rain_001` 四个 P0 天气轻事件；`data/life/today_status.json` 为 7 个本地 day_key 增加 `weather_event_id`；`TodayStatusService` 输出天气事件与 HUD 短句；`ContentContractValidator` 拦截 required P0 event、天气标签、P0 优先级、安全文本和 today_status 引用；`tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`tests/headless_runner.gd` 已覆盖；新增 `docs/collaboration/Round70_V02.11_WEATHER-002_PM执行任务包.md`，下一轮唯一 Ready 为 `V02-WEATHER-002 NPC 问候与资源 / 商店轻变化`；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/systems/today_status_service.gd`、`godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd`、`godot --headless --path . --script tests/test_daily_town_services.gd`、`godot --headless --path . --script tests/test_v024_content_contracts.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；无残留 headless 测试进程 |
| 2026-06-05 | Round 70 验收 / Round 71 Ready | V02-WEATHER-002 NPC 问候与资源 / 商店轻变化收口 | `data/life/daily_greetings.json` 新增天气问候变体并用稳定 `variant_id` 回连 `weather_events.npc_greeting_refs`；`DailyGreetingService` 返回 `weather_event_id`、`weather_tag` 与 `greeting_variant_id`；`data/life/resource_points.json` 新增 `weather_hints`，`ResourceRefreshService` 只附加天气提示且不改变资源数量；`data/items/life_items.json` 新增 `weather_activity_corner`，`LifeShopService` 返回活动角说明但不覆盖 `offers`；`ContentContractValidator` 已拦截天气问候悬空引用、资源天气提示、商店活动角和 P0 `wooden_chair` 保留；`tests/test_v024_content_contracts.gd`、`tests/test_daily_town_services.gd`、`tests/test_life_services.gd` 与 `tests/headless_runner.gd` 已覆盖；新增 `docs/collaboration/Round71_V02.11_WEATHER-003_PM执行任务包.md`，下一轮唯一 Ready 为 `V02-WEATHER-003 A-Z 天气相册线索`；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v024_content_contracts.gd`、`godot --headless --path . --script tests/test_daily_town_services.gd`、`godot --headless --path . --script tests/test_life_services.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；无残留 headless 测试进程 |
| 2026-06-05 | Round 71 验收 / Round 72 Ready | V02-WEATHER-003 A-Z 天气相册线索收口 | `data/life/weather_events.json` 为晴天、微风、雨后、小雨四类 P0 天气新增 `album_clues`，分别绑定 S Sun、K Kite、U Umbrella、B Bear 的 `anchor_id`、`card_id`、天气相册标签、地点故事和环境词；`scripts/main.gd` 在孩子端真实 `看看` 路径中记录 `weather_album_clues`，直接 anchor 与 P1 look hotspot 均可点亮对应 card state，其中 B Bear 通过 Bear Corner 避开 Mina 树枝资源格；`scripts/ui/memory_album.gd` 将 U Umbrella 纳入相册显示；`ContentContractValidator` 拦截天气相册线索缺字段或未回连 `anchor_hints`；`tests/test_v023_memory_palace_world.gd` 覆盖四类天气 day_key 从可见 `看看` 路径落账、打开相册显示“已收藏”且无正确率 / 等级 / 打卡 / 测验文案；新增 `docs/collaboration/Round72_V02.11_WEATHER-004_PM执行任务包.md`，下一轮唯一 Ready 为 `V02-WEATHER-004 天气纵切 smoke 与双视口截图`；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd`、`godot --headless --path . --script tests/test_v023_memory_palace_world.gd`、`godot --headless --path . --script tests/test_v024_content_contracts.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；无残留 headless 测试进程 |
| 2026-06-05 | Round 72 验收 | V02-WEATHER-004 天气纵切 smoke 与双视口截图收口 | 新增 `tests/test_v0211_weather_slice_smoke.gd`，覆盖晴天、微风、小雨、雨后四类天气 day_key、HUD 天气状态、Mina 日常、P0 商店、小屋摆放、相册和 S/K/B/U 天气线索落账；`tests/headless_runner.gd` 注册 `_check_v0211_weather_slice_smoke()` 作为全量回归门槛；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script tests/test_v0211_weather_slice_smoke.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0211_weather_slice_smoke.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；无残留 headless 测试进程；V02.11 天气与小镇轻事件纵切可标记完成，下一步应由 PM 建立后续阶段路线 |
| 2026-06-05 | Round 73 验收 / Round 74 Ready | V02-AZWORLD-001 Home / School 中心地图原则与 26 anchor 分布合同收口 | 新增 `data/maps/az_world_plan.json`，以 Home / School 为世界地图双中心，定义 center / first_ring / second_ring / far_edge 四层结构、5 个规划 district 和 26 个 A-Z anchor 的路线分布、故事记忆、视觉钩子、相册记录、安全边界与 `future_curriculum_hooks`；新增 `scripts/data/az_world_plan_contract.gd`，拦截非 Home / School 中心、缺失 26 anchor、远郊成为主流程依赖、缺少未来挂接位和压力词；新增 `tests/test_v0212_az_world_plan.gd` 并在 `tests/headless_runner.gd` 注册 `_check_v0212_az_world_plan()`；同步 `docs/12`、`docs/13`、`docs/14`、`docs/15` 和 `todo.md`；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/data/az_world_plan_contract.gd`、`godot --headless --path . --check-only --script tests/test_v0212_az_world_plan.gd`、`godot --headless --path . --script tests/test_v0212_az_world_plan.gd`、`godot --headless --path . --script tests/test_az_core_data.gd`、`godot --headless --path . --script tests/test_memory_palace_embedding.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；下一轮 Ready 为 `V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划` |
| 2026-06-05 | Round 74 验收 | V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划收口 | 子 agent Franklin 新增 `docs/collaboration/Round74_V02.12_AZWORLD-002_PM执行任务包.md`；主 PM 集成新增 `docs/collaboration/Round74_V02.12_AZWORLD-002区域道路安全规划.md`；`data/maps/az_world_plan.json` 新增 `routes` 与 `safety_boundaries`，覆盖 `route_p0_home_school_walk`、first ring、second ring、far edge、safe return 和 far edge 不阻断 P0；`scripts/data/az_world_plan_contract.gd` 与 `tests/test_v0212_az_world_plan.gd` 已验证 |
| 2026-06-05 | Round 75 验收 | V02-AZWORLD-003 17 个 reserved anchor 升级为可制作级规格收口 | 子 agent Planck 新增 `docs/collaboration/Round75_V02.12_AZWORLD-003_PM执行任务包.md`；主 PM 集成新增 `docs/collaboration/Round75_V02.12_AZWORLD-003可制作级规格记录.md`；`data/maps/az_world_plan.json` 新增 17 条 `reserved_anchor_specs`，覆盖 E/F/G/H/I/J/L/M/N/P/Q/R/U/V/X/Y/Z 的 visible entry、album record、logical asset IDs、`make_ready` 和儿童安全说明；合同与 focused/headless 验证通过 |
| 2026-06-05 | Round 76 验收 | V02-AZWORLD-004 / 005 Home / School 0 基础挂接与 V02.12 阶段收口 | 子 agent Dewey 新增 `docs/collaboration/Round76_V02.12_AZWORLD-004_005_PM执行任务包.md`；主 PM 集成新增 `docs/collaboration/Round76_V02.12_AZWORLD-004_005挂接与验收记录.md`；`data/maps/az_world_plan.json` 新增 `foundation_story_hooks` 和 `screenshot_acceptance`，覆盖 family/home/room/clock/dog/bag/school/gate/play/look/go/good_morning、Home / School 生活场景、anchor 绑定、截图点和双视口口径；`scripts/data/az_world_plan_contract.gd`、`tests/test_v0212_az_world_plan.gd` 与 `tests/headless_runner.gd` 已扩展；JSON、check-only、focused、A-Z core、memory palace、headless runner 和 Godot headless 启动均通过；V02.12 学校-家庭中心世界地图与 A-Z 锚点规划可标记完成 |
| 2026-06-05 | Round 77 验收 | V02.13 全量课本内容世界化主线策划收口 | 新增 `curriculum/小学英语重点分析/三年级上册.txt`、`data/curriculum/textbook_world_plan.json`、`scripts/data/textbook_world_contract.gd`、`tests/test_v0213_textbook_world_plan.gd`、`docs/collaboration/Round77_V02.13_TEXTBOOK-001_005_PM执行任务包.md` 和验收记录；`tests/headless_runner.gd` 注册 `_check_v0213_textbook_world_plan()`；8 册 source ledger、85 个单元摘要、世界映射、P0/P1/P2 主线分层、缺册 / 远郊 / 压力文案拦截均通过；JSON、check-only、focused、headless runner 和 Godot headless 启动均通过；V02.13 可标记完成 |
| 2026-06-05 | Round 78 规划 / Ready | V02.14 Home / School P0 可玩纵切路线建立 | 按文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round78_V02.14_HOMESCHOOL-001_PM执行任务包.md`；将 V02.14 拆为 `V02-HOMESCHOOL-002` 至 `005`，并将下一轮唯一 Ready 置为 `V02-HOMESCHOOL-002 Home Morning Foundation 数据化与可见入口`；本轮仅改 PM 文档和台账，验证命令通过 |
| 2026-06-05 | Round 79 验收 | V02.14 Home / School P0 可玩纵切实现收口 | 新增 `data/life/homeschool_events.json`，覆盖 Home morning、Home-School Walk、School Gate、School Yard 和 Return / Sunny story 七个 P0 生活事件；`data/maps/world_map.json` 接入 Home / Sunny / Walk / School Gate / School Yard 可见 `看看` hotspot；`scripts/main.gd` 通过 `look_homeschool_event` 保存 `homeschool_events` 并点亮 A/C/D/W、G/K/S、E/G/K/N/R/Y 等 A-Z card state；新增 `tests/test_v0214_homeschool_slice.gd` 并在 `tests/headless_runner.gd` 补齐 `_check_v0214_homeschool_slice()` 集成注册；`godot --headless --path . --script tests/test_v0214_homeschool_slice.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 通过；Godot MCP 主场景启动、运行时场景树和 1280x720 截图抽查通过；V02.14 可标记完成，下一步应由 PM 建立 V02.15 路线与 Ready 队列 |
| 2026-06-05 | Round 80 规划 / Ready | V02.15 Home / School 日常回访与学校生活轻循环路线建立 | 按文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round80_V02.15_SCHOOLDAILY-001_PM执行任务包.md`；将 V02.15 拆为 `V02-SCHOOLDAILY-002` 至 `005`，首批差异维度固定为 School Gate greeting、School Yard discovery、Home-School Walk variation 和 Home Return story，并将下一轮唯一 Ready 置为 `V02-SCHOOLDAILY-002 School Day State Contract 数据化`；本轮仅改 PM 文档和台账，`godot --headless --path . --script tests/headless_runner.gd` 与 `godot --headless --path . --quit` 通过 |
| 2026-06-05 | Round 81 验收 | V02-SCHOOLDAILY-002 School Day State Contract 数据化收口 | 新增并核对 `data/life/school_day_states.json` 7 天 school day state，覆盖 `home_school_walk`、`school_gate`、`school_yard`、`return_home` 四阶段；`scripts/systems/school_day_state_service.gd` 已接入 day_key loader / entry 读取；`scripts/systems/content_contract_validator.gd` 新增 school day state 合同检查，拦截缺字段、重复 event_id、未知 anchor 和儿童压力文案；`tests/test_v024_content_contracts.gd` 已验证 7 天四阶段均可通过 service 加载并含地点、anchor、环境词、孩子端文本和安全说明；`godot --headless --path . --check-only --script scripts/systems/content_contract_validator.gd`、`godot --headless --path . --script tests/test_v024_content_contracts.gd`、`godot --headless --path . --script tests/headless_runner.gd` 通过；无新增已验证教训 |
| 2026-06-05 | Round 82 验收 | V02.15 Home / School 日常回访与学校生活轻循环收口 | 完成 `V02-SCHOOLDAILY-003` 至 `005`：`scripts/main.gd` 已通过 `look_homeschool_event` 使用当前 day_key 的 `SchoolDayStateService` entry 为 Home-School Walk、School Gate、School Yard、Return Home 追加每日差异文本、保存 `school_day_events` 并点亮 A-Z card state；新增 `tests/test_v0215_school_daily_slice.gd` 覆盖 7 天 x 4 阶段真实可见 `看看` 路径、28 条 school day event 保存、7 条 Sunny return 保存、商店 / 小屋旧路径不阻断和儿童安全禁词；`tests/headless_runner.gd` 注册 `_check_v0215_school_daily_slice()`；`godot --headless --path . --check-only --script tests/test_v0215_school_daily_slice.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0215_school_daily_slice.gd`、`godot --headless --path . --script tests/headless_runner.gd`和 `godot --headless --path . --quit` 通过；V02.15 可标记完成，下一步由 PM 建立后续阶段路线 |
| 2026-06-05 | Round 83 规划 / Ready | V02.16 可制作内容与体验抛光 / Playable RC Gate 路线建立 | 按文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round83_V02.16_PRODUCTION-001_PM执行任务包.md`；将 V02.16 拆为 `V02-PRODUCTION-002` 至 `005`，试玩范围固定为每日小镇、Home / School、天气、P1 轻回访、商店、小屋、Sunny、相册和设置，并将下一轮唯一 Ready 置为 `V02-PRODUCTION-002 孩子端文案、反馈语气和禁用词统一审校`；本轮仅改 PM 文档和台账，未改运行时代码 |
| 2026-06-05 | Round 85 规划 / Ready | V02.17 世界地图运行时落地与 26 Anchor 可视布局路线建立 | 按文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round85_V02.17_WORLDMAP-001_PM执行任务包.md`；将 V02.17 拆为 `V02-WORLDMAP-002` 至 `005`，阶段目标固定为 26 anchor 坐标蓝图、P0 Home / School 中心路线运行时接入、first / second ring 预览与 26 anchor QA 收口，并将下一轮唯一 Ready 置为 `V02-WORLDMAP-002 26 Anchor 地图坐标与分层可达蓝图`；本轮仅改 PM 文档和台账，未改运行时代码 |
| 2026-06-05 | Round 87 规划 / Ready | V02.18 世界地图视觉可读性与探索体验抛光路线建立 | 按文档路线顺序更新 `docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round87_V02.18_MAPREAD-001_PM执行任务包.md`；将 V02.18 拆为 `V02-MAPREAD-002` 至 `005`，阶段目标固定为 26 anchor 可读性审计、地图视觉层级 / 道路引导抛光、anchor 徽章 / 热点优先级 / 反馈短句抛光和地图探索 smoke / 双视口截图收口，并将下一轮唯一 Ready 置为 `V02-MAPREAD-002 26 Anchor 可读性审计与截图基线`；本轮仅改 PM 文档和台账，未改运行时代码 |
| 2026-06-05 | Round 88 验收 | V02.18 世界地图视觉可读性与探索体验抛光收口 | 完成 `V02-MAPREAD-002` 至 `005`：`scripts/main.gd` 新增 `MapReadabilityLayer`、Home / School / Town Ring / Far Edge 区域底纹、短路牌、anchor 可读性元数据和更清晰的字母徽章；新增 `tests/test_v0218_map_readability.gd` 并在 `tests/headless_runner.gd` 实际注册 V02.18 审计，覆盖 26 anchor 截图组、物件轮廓、徽章尺寸、真实 `看看` 路径、相册落账和儿童安全文案；新增 `docs/collaboration/Round88_V02.18_MAPREAD-002_005验收记录.md`；`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --check-only --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；V02.18 可标记完成，下一步由 PM 建立后续阶段路线 |
| 2026-06-05 | Round 89 规划 / Ready | V02.19 实际地图与 P0 美术资产生产替换路线建立 | 按文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round89_V02.19_ARTPASS-001_PM执行任务包.md`；将 V02.19 拆为 `V02-ARTPASS-002` 至 `005`，阶段目标固定为实际地图与 P0 资产清单 / 接入合同审计、P0 世界地图底图与区域块替换、P0 场景与 26 anchor 物件替换、角色 / 宠物 / UI 资产替换与截图收口，并将下一轮唯一 Ready 置为 `V02-ARTPASS-002 实际地图与 P0 资产清单 / 接入合同审计`；本轮仅改 PM 文档和台账，未改运行时代码 |
| 2026-06-06 | Round 90 验收 / Round 91 Ready | V02-ARTPASS-002 实际地图与 P0 资产清单 / 接入合同审计收口 | 完成 Home 居中运行时地图迁移与文档合同同步；新增 `docs/collaboration/Round90_V02.19_ARTPASS-002资产接入合同审计.md`，固定 runtime place 接入清单、26 anchor 建议 `anchor.*` logical asset ID、ARTPASS-003/004/005 分派建议、1280-only 后续验收门槛和 960 全量开发后适配专项口径；`data/themes/theme_sunshine_town_placeholder.json` 的当前 asset acceptance evidence 已从 960 pending 改为 1280 pending；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；原下一轮 Ready 为 `V02-ARTPASS-003 P0 世界地图底图与区域块替换`，Round91 已按新美术方向改为视觉方向确认包；无新增已验证教训 |
| 2026-06-06 | Round 91 规划对齐 | V02.19 美术方向与任务队列修正 | 按用户确认将后续正式美术方向改为 Animal Crossing-like cozy town 世界视觉和 Apple-like translucent glass UI，明确不采用绘本 / storybook / picture-book；更新 `docs/10_美术风格与换肤预留.md`、`docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、Round89 / Round90 协作文档和 `todo.md`；将 `V02-ARTPASS-003` 改为视觉方向确认包，原地图 / 场景 / 角色 UI 生产替换顺延为 `V02-ARTPASS-004` 至 `006`；本轮仅改 PM / 美术方向文档和台账，未改运行时代码；无新增已验证教训 |
| 2026-06-06 | Round 92 验收 / Round 93 Ready | V02-ARTPASS-003 视觉方向确认包收口 | 新增 `docs/collaboration/Round92_V02.19_ARTPASS-003视觉方向确认包.md`；使用项目本地 image generation fallback 生成 `docs/collaboration/artpass003_visual_direction/artpass003_main_gameplay_direction_1280.png`、`artpass003_glass_ui_direction_1280.png`、`artpass003_character_anchor_direction_1280.png` 三张 1280x720 方向样张；方向包固定 Animal Crossing-like cozy town 世界视觉、Apple-like translucent glass UI、anchor 物件化边界、禁用方向和后续 production 门槛；`file docs/collaboration/artpass003_visual_direction/*.png` 确认三张均为 1280x720 PNG；本轮未改 runtime、数据合同或 ThemeProfile 映射；下一轮 Ready 为 `V02-ARTPASS-004 P0 世界地图底图与区域块替换`；无新增已验证教训 |
| 2026-06-06 | Round 93 验收 / Round 94 Ready | V02-ARTPASS-004 P0 世界地图底图与区域块替换收口 | 新增 `docs/collaboration/Round93_V02.19_ARTPASS-004验收记录.md`；新增 `world_map_base_1280` 与 Home Yard、Home-School Walk、School Gate、School Yard、Shop Street、Animal Park、Coast Edge、Sun Scene、Story + Culture Bridge 共 9 个区域块 SVG/PNG 资产并生成 Godot import；`ThemeProfileResource` / `AssetResolver` / `ThemeSwitchService` 新增 `anchor_assets` 类别和 `get_anchor_asset()`；`data/themes/theme_sunshine_town_placeholder.json` 新增 10 个 `place.*` production 映射、26 个 `anchor.*` logical ID、ARTPASS-004 asset acceptance 和 `cozy_town_glass_placeholder` 风格字段；`scripts/main.gd` 将 Ground、9 个 MapRead zone 和 place marker body 接入 logical asset ID，production body 不再叠旧占位门窗；`tests/test_asset_resolver.gd`、`tests/test_v0218_map_readability.gd`、`tests/headless_runner.gd` 覆盖新资产解析和 runtime 贴图尺寸；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-ARTPASS-005 P0 场景与 26 Anchor 物件替换`；无新增已验证教训 |
| 2026-06-06 | Round 94 验收 / Round 95 Ready | V02-ARTPASS-005 P0 场景与 26 Anchor 物件替换收口 | 新增 `docs/collaboration/Round94_V02.19_ARTPASS-005验收记录.md`；新增 `assets/art/anchors/anchor_*.svg/.png` 26 个 A-Z 生活物件 production 资产和 Godot import；新增 `scripts/tools/generate_artpass005_anchor_assets.js`，可稳定生成 anchor 资产并同步主题 JSON；`data/themes/theme_sunshine_town_placeholder.json` 的 26 个 `anchor.*` logical ID 已映射到 `res://assets/art/anchors/*.png`，并新增 production acceptance records；`scripts/main.gd` 将 26 个 runtime anchor ObjectSprite texture key 接入 `anchor_assets`，字母仍只作为 badge 辅助；`tests/test_asset_resolver.gd` 与 `tests/headless_runner.gd` 覆盖 26 anchor 资产解析、文件存在和 acceptance；`tests/test_v0218_map_readability.gd` 要求每个 anchor ObjectSprite 使用 160px production texture，并继续覆盖真实 `看看` 路径、相册落账和徽章可读性；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-ARTPASS-006 角色 / 宠物 / UI 资产替换与截图收口`；无新增已验证教训 |
| 2026-06-06 | Round 95 验收 | V02-ARTPASS-006 样张驱动美术资产重生成与地图 / UI 替换收口 | 新增 `docs/collaboration/Round95_V02.19_ARTPASS-006样张驱动美术返工验收记录.md`；按 Round92 三张方向样张使用本地生图脚本优先重生成 runtime 世界地图底图、9 个区域资产、26 个 anchor 物件和 glass UI 皮肤，并保存 `docs/collaboration/round95_visual_acceptance/shot_round95_runtime_1280.png` 作为 1280x720 runtime proof；`data/themes/theme_sunshine_town_placeholder.json` 的 `place_assets`、`anchor_assets`、`ui_skin` 指向 production PNG；`scripts/main.gd` 通过 logical asset ID 加载底图、anchor 和 glass HUD / footer / panel / button skin，区域 / place production 贴图仅作为极淡 metadata，旧 SVG 不再作为正式美术方向基线；修正 UI skin loader 优先走 `ResourceLoader`，避免 raw PNG export warning；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；无残留 headless 测试进程；无新增已验证教训 |
| 2026-06-06 | Round 96 验收 | V02-ARTPASS-007 全屏构图与 UI 风格返修收口 | 针对用户反馈“游戏应该全屏、地图仍像在窗口里、UI / icons / overall style 仍需调整”，`scripts/main.gd` 移除主场景外层 SafeArea 边距，将 runtime 60x34 逻辑地图缩放铺满 1280x720 playfield，并把点击坐标反算回原逻辑格；旧 RoadCell 降为 20% 透明引导，常驻 TownHUD / TownFooter 改为轻玻璃 overlay，底栏上移并统一四个按钮和背包图标比例；新增 `docs/collaboration/Round96_V02.19_ARTPASS-007全屏构图与UI返修验收记录.md`，最终 proof 为 `docs/collaboration/round96_visual_acceptance/shot_production005_town_plaza_round96_final_1280.png`；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 和非 headless 1280 截图导出均通过；无新增已验证教训 |
| 2026-06-06 | Round 97 验收 | V02-ARTPASS-008 Round92 样张风格剩余 runtime 素材补齐收口 | 新增 `docs/collaboration/Round97_V02.19_ARTPASS-008剩余runtime素材补齐验收记录.md` 和 `docs/collaboration/round97_artpass008_preview.png`；使用项目约定外部生成脚本逐张生成并覆盖 27 个仍在 runtime 映射中使用的 PNG：`assets/art/places/` 13 个 place / zone / marker 贴图、`assets/art/ui/icons/` 5 个 icon、`assets/art/pets/sunny_standing.png`、3 个家具和 5 个角色；对角色、Sunny、家具、UI icon 和 home/shop exterior 做透明背景后处理；`data/themes/theme_sunshine_town_placeholder.json` 已更新 27 个 `asset_acceptance` 记录为 `production` / `pass`，不标 `approved`，并保持 logical asset ID、ThemeProfile / AssetResolver 映射、gameplay、地图坐标、A-Z anchor 结构和 UI 布局不变；`find data -name '*.json' -print0 \| xargs -0 jq empty`、mapped PNG existence check、orphan `.import` check、`godot --headless --path . --script tests/test_asset_resolver.gd`、`godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 均通过；无新增已验证教训 |
| 2026-06-06 | Round 98 验收 | V02-ARTPASS-009 资源 branch 漏项补齐收口 | 新增 `docs/collaboration/Round98_V02.19_ARTPASS-009资源branch漏项补齐验收记录.md` 和 `docs/collaboration/round98_artpass009_branch_preview.png`；使用项目约定外部生成脚本生成 branch raw，边缘连通背景抠除后覆盖 `assets/art/resources/branch.png`；`data/themes/theme_sunshine_town_placeholder.json` 已更新 `place.resource.branch` 的 `asset_acceptance` 为 `production` / `pass`；JSON、mapped PNG existence、orphan `.import`、AssetResolver、全量 headless runner 和 Godot 启动验证通过；无新增已验证教训 |
| 2026-06-06 | Round 99 验收 | V02-ARTPASS-010 运行时视觉验收与发布候选整理收口 | 新增 `docs/collaboration/Round99_V02.19_ARTPASS-010运行时视觉验收与发布候选记录.md` 和 `docs/collaboration/round99_runtime_visual_acceptance/` 1280x720 proof；`scripts/main.gd` 完成旧道路格 / hotspot glow / 花树辅助层降噪、anchor 物件满不透明、字母徽章合同恢复和 Album overlay 穿层修复；截图覆盖 Town Plaza、Home、Shop、Album、Settings，Round98 branch 漏项在 runtime map 中无突兀旧占位；JSON、main check-only、AssetResolver、V02.18 可读性、V02.17 anchor runtime、Playable UI、Playable RC、全量 headless runner、Godot 启动和残留进程检查均通过；V02.19 production art pass 可作为 1280x720 发布候选基线；无新增已验证教训 |
| 2026-06-06 | Round 100 规划 / 首批纵切 / Ready | V02.20 可居住小镇重建路线与首批可玩手感纵切建立 | 同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`，新增 `docs/collaboration/Round100_V02.20_PLAYGATE-001_PM执行任务包.md`；明确 V02.19 收口为 1280 art baseline 而非 product complete；建立 `V02-PLAYGATE-001` 至 `V02-PLAYGATE-009` 任务队列，并将下一轮唯一 Ready 置为 `V02-PLAYGATE-002 首屏可居住小镇 QA 审计与缺口清单`；`scripts/main.gd` 新增连续行走请求 / 多帧推进 / 到达保存、局部镜头跟随、上下文 `看看` 提示、HUD 文案降噪、A-Z quiet badge 和玩家可见坐标移除；新增 `tests/test_v0220_playgate_controls.gd` 并注册进 `tests/headless_runner.gd`；同步 `tests/test_v0218_map_readability.gd` 与 `tests/headless_runner.gd` 的 quiet badge / icon HUD 验收口径；`find data -name '*.json' -print0 \| xargs -0 jq empty`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --check-only --script tests/test_v0220_playgate_controls.gd`、`godot --headless --path . --script tests/test_v0220_playgate_controls.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd`、`godot --headless --path . --script tests/headless_runner.gd` 和 `godot --headless --path . --quit` 通过；本轮仍未完成 Home / Shop 直接操作、NPC routine 或 3-5 分钟完整新 smoke，后续按 V02-PLAYGATE-002 审计继续推进；无新增已验证教训，`lessons.md` 不更新 |
| 2026-06-06 | Round 101 审计 / 规格 / 判定 / 收口 | V02.20 PLAYGATE-002..009 文档队列收口与 V02.21 Ready | 调用并整合智能体完成 `docs/collaboration/Round101_V02.20_PLAYGATE-002首屏可居住小镇QA审计与缺口清单.md`、`Round101_V02.20_PLAYGATE-003_007自由生活smoke规格与旧路径回归矩阵.md`、`Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md`、`Round101_V02.20_PLAYGATE-006孩子端文本与生活反馈审校.md` 和 `Round101_V02.20_PLAYGATE-009收口与下一阶段决策.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；明确 V02.20 文档 playgate 完成但不标 product complete，Town / Shop / Album / Settings 仅为 1280 art baseline approved，Home / School Gate / School Yard 仍 needs_fix；下一阶段不进入内容扩展或 960x540 专项，继续 V02.21 居住感返修实现；下一轮唯一 Ready 为 `V02-LIVEGATE-001 空间分层与热点优先级返修`；本轮为文档 / 审计 / 规格 / 判定任务，未改 runtime、tests、assets 或 data，未运行 Godot；`rg` / `file` 静态证据检查通过；无新增已验证教训 |
| 2026-06-06 | Round 102 验收 / Ready | V02-LIVEGATE-001 空间分层与热点优先级返修收口 | `scripts/main.gd` 已将 `看看` 目标优先级显式化：exact place / resource / anchor 保持为有意操作，NPC 优先于附近非精确资源 / anchor，附近 anchor / resource 和 place fallback 继续保留；新增 `tests/test_v0221_livegate_hotspot_priority.gd` 与 Godot `.uid`，覆盖 Mina vs nearby anchor、Bus Helper vs nearby resource、exact Taxi anchor、exact stone resource、exact Home entry；`tests/headless_runner.gd` 已注册 V02.21 回归；`godot --headless --path . --script tests/test_v0221_livegate_hotspot_priority.gd`、`godot --headless --path . --script tests/test_v0218_map_readability.gd`、`godot --headless --path . --script tests/test_v0220_playgate_controls.gd`、`godot --headless --path . --check-only --script scripts/main.gd` 和 `godot --headless --path . --script tests/headless_runner.gd` 均通过；V02-LIVEGATE-001 可标记完成，下一轮 Ready 为 `V02-LIVEGATE-002 Home 居住感和直接家具操作返修`；无新增已验证教训 |
| 2026-06-06 | Round 105 验收 / Ready | V02-LIVEGATE-004 3-5 分钟自由生活 smoke 实现收口 | 新增 `tests/test_v0221_livegate_free_life_smoke.gd` 与 Godot `.uid`，通过真实可见入口覆盖启动 HUD、连续行走到 Mina、接取 / 完成树枝轻委托、资源同日去重、商店买 `wooden_chair`、背包打开 / 关闭相册、小屋摆放家具、Sunny 小屋反馈、School Gate 看看、设置休息确认 / 取消和安全位置返回；`tests/headless_runner.gd` 已注册 `_check_v0221_livegate_free_life_smoke()`，并按实际道路 waypoint 返回 Mina；`godot --headless --path . --script tests/test_v0221_livegate_hotspot_priority.gd`、`godot --headless --path . --script tests/test_v0221_livegate_shop_school_arrival.gd`、`godot --headless --path . --script tests/test_playable_ui_operations.gd`、`godot --headless --path . --script tests/test_v0221_livegate_free_life_smoke.gd`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；V02-LIVEGATE-004 可标记完成，下一轮 Ready 为 `V02-LIVEGATE-005 1280 RC 截图包与二次 approved 判定`；无新增已验证教训 |
| 2026-06-06 | Round 106 验收 / 阶段收口 | V02-LIVEGATE-005 1280 RC 截图包与二次 approved 判定收口 | 新增 `tests/capture_livegate005_rc.gd`，通过非 headless 显示驱动导出 `docs/collaboration/round106_livegate005_rc/` 七张同轮 1280x720 runtime proof：Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings；新增 `docs/collaboration/Round106_V02.21_LIVEGATE-005_1280_RC截图与二次判定.md`，二次判定 `Album` 为 V02.21 playgate approved，Town / Home / Shop / School Gate / School Yard / Settings 保留 `needs_fix`，明确不把 `production`、旧 Round96 / Round99 proof 或 headless 逻辑验证误写为 product approved；`godot --path . --script tests/capture_livegate005_rc.gd`、`file docs/collaboration/round106_livegate005_rc/*.png`、`godot --headless --path . --check-only --script tests/capture_livegate005_rc.gd`、`godot --headless --path . --script tests/test_v0221_livegate_free_life_smoke.gd`、`godot --headless --path . --script tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；V02-LIVEGATE-001 至 005 全部完成，V02.21 可居住小镇返修实现阶段收口；无新增已验证教训 |
| 2026-06-06 | Round 107 规划 / Ready | V02.22 隐藏网格生活小镇与 scenes 组件化路线建立 | 按文档路线顺序更新 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；新增 `docs/collaboration/Round107_V02.22_HIDDENGRID-001_PM执行任务包.md`；明确 V02.22 将 Animal Crossing-like 隐藏网格生活小镇和 Godot scenes 组件化合并推进，底层保留 cell / footprint / occupied cells，孩子端不显示格子、瓦块、坐标或调试术语；拆分 `TownStage`、Actor / Interactable、UI scenes，并进入户外装饰、资源 2.0、NPC routine 和 3-5 分钟回归收口；下一轮唯一 Ready 为 `V02-HIDDENGRID-002 TownStage scene 抽离`；本轮仅改 PM 文档和台账，未改 runtime、tests、assets 或 data；无新增已验证教训 |
| 2026-06-06 | Round 108 验收 / Ready | V02-HIDDENGRID-002 TownStage scene 抽离收口 | 新增 `scenes/world/town_stage.tscn` 与 `scripts/stages/town_stage.gd`；`scripts/main.gd` 实例化 `TownStage` 并注入 world map、A-Z 数据、资源点、NPC 清单和 renderer facade，旧 test-facing 字段 `runtime_map_frame`、`runtime_map_input`、`runtime_map_node`、`player_marker` 和玩家移动 / 交互查询 API 保持可用；TownStage 接管地图显示、输入、节点生成、player marker、点击到 cell 信号和镜头跟随，业务互动、保存结构、A-Z anchor ID / route_order 和 logical asset ID 均未迁移或重排；`godot --headless --path . --check-only --script scripts/stages/town_stage.gd`、`godot --headless --path . --check-only --script scripts/main.gd`、`godot --headless --path . --script tests/test_v0220_playgate_controls.gd`、`tests/test_v0221_livegate_free_life_smoke.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0217_worldmap_anchor_runtime.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v0221_livegate_shop_school_arrival.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-HIDDENGRID-003 Actor / Interactable scene 抽离`；无新增已验证教训 |
| 2026-06-06 | Round 109 验收 / Ready | V02-HIDDENGRID-003 Actor / Interactable scene 抽离收口 | 新增 Player / NPC / Resource / Anchor / Interactable 五类 actor prefab scene 和脚本；`TownStage` 从直接调用 `Main._create_*_marker()` 改为实例化 prefab，保持 `Player`、`npc_mina`、`resource_branch`、`anchor_a_apple`、`place_home`、`interaction_home_entry` 等旧节点名、actor metadata、逻辑 asset ID 和 `Main` 业务 facade；新增 `tests/test_v0222_actor_prefab_split.gd` 并在 `tests/headless_runner.gd` 注册，覆盖 prefab 脚本接入、旧 player marker 引用、走路 facade 和 Mina 互动优先级；`godot --headless --path . --check-only --script scripts/stages/player_actor.gd`、`npc_actor.gd`、`resource_object.gd`、`anchor_object.gd`、`interactable_object.gd`、`town_stage.gd`、`scripts/main.gd`、`tests/test_v0222_actor_prefab_split.gd`、`tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0222_actor_prefab_split.gd`、`tests/test_v0221_livegate_hotspot_priority.gd`、`tests/test_v0217_worldmap_anchor_runtime.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0221_livegate_free_life_smoke.gd`、`tests/test_playable_ui_operations.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-HIDDENGRID-004 UI scenes 抽离`；无新增已验证教训 |
| 2026-06-06 | Round 110 验收 / Ready | V02-HIDDENGRID-004 UI scenes 抽离收口 | 新增 `TownHUD` 与 `TownFooter` UI scene / scripts，`scripts/main.gd` 改为实例化 UI scene 并保留旧 label / button facade；背包、商店、小屋、相册、设置 panel 业务入口不迁移，继续通过可见路径回归保护；新增 `tests/test_v0222_ui_scene_split.gd` 并在 `tests/headless_runner.gd` 注册，覆盖 TownHUD / TownFooter scene script、HUD label facade、底栏背包入口、相册返回和设置打开 / 关闭；`godot --headless --path . --check-only --script scripts/ui/town_hud.gd`、`scripts/ui/town_footer.gd`、`scripts/main.gd`、`tests/test_v0222_ui_scene_split.gd`、`tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0222_ui_scene_split.gd`、`tests/test_playable_ui_operations.gd`、`tests/headless_runner.gd` 均通过；下一轮 Ready 为 `V02-HIDDENGRID-005 户外装饰、资源 2.0 与 NPC routine 隐藏网格纵切`；无新增已验证教训 |
| 2026-06-06 | Round 111 验收 / Ready | V02-HIDDENGRID-005 户外装饰、资源 2.0 与 NPC routine 隐藏网格纵切收口 | 新增 `scripts/systems/outdoor_decoration_service.gd`、`scripts/systems/npc_routine_service.gd`、`data/life/npc_routines.json`，并给 `data/life/resource_points.json` 补 `refresh_rule`；`ResourceRefreshService.get_refresh_summary()` 提供温和刷新摘要；`scripts/main.gd` 接入 `outdoor_decoration_service`、`npc_routine_service`、户外摆放 / 挪动 / 收起 facade、NPC routine snapshot 和 routine 后 NPC 列表；`TownStage` 新增 `OutdoorDecorLayer` 渲染；新增 `tests/test_v0222_hidden_grid_life_systems.gd` 并在 `tests/headless_runner.gd` 注册，覆盖服务层与主场景户外装饰、资源 2.0、NPC routine fallback 和旧 Mina 优先级；`godot --headless --path . --check-only --script scripts/systems/outdoor_decoration_service.gd`、`npc_routine_service.gd`、`resource_refresh_service.gd`、`scripts/main.gd`、`tests/test_v0222_hidden_grid_life_systems.gd`、`tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0222_hidden_grid_life_systems.gd`、`tests/test_v0221_livegate_hotspot_priority.gd`、`tests/test_v0221_livegate_free_life_smoke.gd`、`tests/test_playable_ui_operations.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-HIDDENGRID-006 3-5 分钟回归、1280 proof 和阶段收口`；无新增已验证教训 |
| 2026-06-06 | Round 112 验收 / 阶段收口 | V02-HIDDENGRID-006 3-5 分钟回归、1280 proof 和阶段收口 | 新增 `tests/test_v0222_hiddengrid_final_smoke.gd` 并注册进 `tests/headless_runner.gd`，覆盖 TownStage、Actor prefab、TownHUD / TownFooter scene、Mina / branch 真实路径、户外装饰、资源 2.0、NPC routine fallback、背包、相册和设置；新增 `tests/capture_hiddengrid006_rc.gd` 与 `docs/collaboration/round112_hiddengrid006_rc/` 六张 1280x720 runtime proof；新增 `docs/collaboration/Round112_V02.22_HIDDENGRID-006阶段收口与1280proof.md`，判定 scene split、hidden grid life systems、A-Z memory palace 和 child-facing text 为 pass，product complete 为 `not_approved`；`godot --headless --path . --check-only --script tests/test_v0222_hiddengrid_final_smoke.gd`、`tests/capture_hiddengrid006_rc.gd`、`tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0222_hiddengrid_final_smoke.gd`、`godot --path . --script tests/capture_hiddengrid006_rc.gd`、`file docs/collaboration/round112_hiddengrid006_rc/*.png`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 和残留进程检查均通过；V02.22 六项任务阶段收口；无新增已验证教训 |
| 2026-06-06 | Round 113 验收 / 阶段加固 | V02-HIDDENGRID-007 Scene-native map + UI panel refactor 收口 | 新增 Godot-native 地图 authoring scene 和 marker dictionary export 验证，固定 TownStage runtime layers，并将 Backpack / Settings / Shop / MemoryAlbumOverlay / HomeRoom panel scene 化；新增并注册 `tests/test_town_map_authoring_export.gd`、`tests/test_town_stage_layered_runtime.gd`、`tests/test_v0223_ui_panel_scene_split.gd`；修正 authoring export 不再重算 `occupied_cells`，避免 scene 拖拽首版破坏既有 `WorldMapContract`；修正 runner 中旧 `Header` 断言只拦截根级旧横幅，避免误伤 panel scene 内部 header 容器；`godot --headless --path . --script tests/test_town_map_authoring_export.gd`、`tests/test_town_stage_layered_runtime.gd`、`tests/test_v0223_ui_panel_scene_split.gd`、`tests/test_v0222_ui_scene_split.gd`、`tests/test_v0222_actor_prefab_split.gd`、`tests/test_v0222_hiddengrid_final_smoke.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0217_worldmap_anchor_runtime.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；runtime JSON、save key、A-Z anchor ID / route_order、logical asset ID 和孩子端真实入口不退化；无新增已验证教训 |
| 2026-06-06 | Round 114 规划 / Ready | V02-EXPAPPROVAL-001 体验批准线 PM 任务包与判定矩阵收口 | 新增 `docs/collaboration/Round114_V02.23_EXPAPPROVAL-001_PM执行任务包.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md` 和 `lessons.md`；固定 Album-only approved，Town Plaza / World Map、Home、Shop、School Gate、School Yard、Settings 保持 needs_fix；建立 V02-EXPAPPROVAL-001..006、V02.24 HOMEPLAZA、V02.25 MAPAUTH、V02.26 CONTENTBATCH 队列；明确 `tests/test_v0223_ui_panel_scene_split.gd` 仅属 Round113 回归证据，不作 V02.23 批准证据；`rg` 静态一致性检查和 `godot --headless --path . --quit` 通过；下一轮唯一 Ready 为 `V02-EXPAPPROVAL-002 Town Plaza 首屏生活密度与 anchor 降噪返修`；无新增已验证教训 |
| 2026-06-06 | Round 115 验收 / Ready | V02-EXPAPPROVAL-002 Town Plaza 首屏生活密度与 anchor 降噪返修收口 | 新增 `PlazaLifeLayer` 和 5 个非交互生活细节，anchor badge 保持可读但降低视觉噪声；新增 `tests/test_v0223_expapproval_town_plaza_density.gd`、`tests/capture_expapproval002_town_plaza.gd`、`docs/collaboration/round115_expapproval002_town_plaza/` 三张 1280x720 proof 和 `docs/collaboration/Round115_V02.23_EXPAPPROVAL-002_TownPlaza首屏生活密度与anchor降噪验收记录.md`；`godot --headless --path . --script tests/test_v0223_expapproval_town_plaza_density.gd`、`tests/test_town_stage_layered_runtime.gd`、`tests/test_v0221_livegate_hotspot_priority.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0223_ui_panel_scene_split.gd`、`tests/test_playable_ui_operations.gd`、`tests/headless_runner.gd`、`godot --headless --path . --quit`、`godot --path . --display-driver x11 --script tests/capture_expapproval002_town_plaza.gd` 和 `file docs/collaboration/round115_expapproval002_town_plaza/*.png` 均通过；Town Plaza 仍不标 approved，等待 `V02-EXPAPPROVAL-006` 逐项判定；下一轮唯一 Ready 为 `V02-EXPAPPROVAL-003 Home 居住密度与小屋视觉批准返修`；无新增已验证教训 |
| 2026-06-06 | Round 116 验收 / Ready | V02-EXPAPPROVAL-003 Home 居住密度与小屋视觉批准返修收口 | 新增 `HomeLifeLayer` 和 6 个非交互默认生活细节，Home 家具状态文案改为孩子端小角落语言，不显示格子 / 坐标 / 占格术语；新增 `get_expapproval_home_snapshot()`、`tests/test_v0223_expapproval_home_living_density.gd`、`tests/capture_expapproval003_home.gd`、`docs/collaboration/round116_expapproval003_home/` 三张 1280x720 proof 和 `docs/collaboration/Round116_V02.23_EXPAPPROVAL-003_Home居住密度与小屋视觉批准返修验收记录.md`；`godot --headless --path . --check-only --script scripts/stages/home_room.gd`、`scripts/main.gd`、`tests/test_v0223_expapproval_home_living_density.gd`、`tests/capture_expapproval003_home.gd`、`godot --headless --path . --script tests/test_v0223_expapproval_home_living_density.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v022_home_room_contract.gd`、`tests/test_v0223_ui_panel_scene_split.gd`、`tests/headless_runner.gd`、`godot --headless --path . --quit`、`godot --path . --display-driver x11 --script tests/capture_expapproval003_home.gd` 和 `file docs/collaboration/round116_expapproval003_home/*.png` 均通过；Home 仍不标 approved，等待 `V02-EXPAPPROVAL-006` 逐项判定；下一轮唯一 Ready 为 `V02-EXPAPPROVAL-004 Shop / Settings glass UI 可读可触批准返修`；无新增已验证教训 |
| 2026-06-06 | Round 117 验收 / Ready | V02-EXPAPPROVAL-004 Shop / Settings glass UI 可读可触批准返修收口 | Shop / Settings panel scene script 加固为更宽、更清楚的 glass panel，Shop 商品按钮和 Settings 控件统一 46px 触控高度；新增 `get_expapproval_shop_settings_snapshot()`、`tests/test_v0223_expapproval_shop_settings_glass.gd`、`tests/capture_expapproval004_shop_settings.gd`、`docs/collaboration/round117_expapproval004_shop_settings/` 三张 1280x720 proof 和 `docs/collaboration/Round117_V02.23_EXPAPPROVAL-004_ShopSettings玻璃UI可读可触批准返修验收记录.md`；`godot --headless --path . --script tests/test_v0223_expapproval_shop_settings_glass.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v0223_ui_panel_scene_split.gd`、`godot --headless --path . --quit`、`tests/headless_runner.gd`、`godot --path . --display-driver x11 --resolution 1280x720 --script tests/capture_expapproval004_shop_settings.gd` 和 `file docs/collaboration/round117_expapproval004_shop_settings/*.png` 均通过；Shop / Settings 仍不标 approved，等待 `V02-EXPAPPROVAL-006` 逐项判定；下一轮唯一 Ready 为 `V02-EXPAPPROVAL-005 School Gate / School Yard 生活地点化与噪声返修`；无新增已验证教训 |
| 2026-06-07 | Round 118 验收 / Ready | V02-EXPAPPROVAL-005 School Gate / School Yard 生活地点化与噪声返修收口 | 新增 School Gate / School Yard 非交互生活细节、短到达 proof 和 `get_expapproval_school_snapshot()`，School-line G/K/N/R/Y anchor 保留且 badge 继续降噪；新增 `tests/test_v0223_expapproval_school_gate_yard_life_noise.gd`、`tests/capture_expapproval005_school_gate_yard.gd`、`docs/collaboration/round118_expapproval005_school_gate_yard/` 四张 1280x720 proof 和 `docs/collaboration/Round118_V02.23_EXPAPPROVAL-005_SchoolGateYard生活地点化与噪声返修验收记录.md`；`godot --headless --path . --script tests/test_v0223_expapproval_school_gate_yard_life_noise.gd`、`godot --headless --path . --check-only --script scripts/stages/town_stage.gd`、`godot --headless --path . --check-only --script scripts/main.gd`、`tests/test_v0221_livegate_shop_school_arrival.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v0223_ui_panel_scene_split.gd`、`tests/headless_runner.gd`、`godot --headless --path . --quit`、`godot --path . --script tests/capture_expapproval005_school_gate_yard.gd` 和 `file docs/collaboration/round118_expapproval005_school_gate_yard/*.png` 均通过；School Gate / School Yard 仍不标 approved，等待 `V02-EXPAPPROVAL-006` 逐项判定；下一轮唯一 Ready 为 `V02-EXPAPPROVAL-006 1280 RC 截图包、真实入口 smoke 与逐项 approved 判定`；无新增已验证教训 |
| 2026-06-07 | Round 119 验收 / Ready | V02-EXPAPPROVAL-006 1280 RC 截图包、真实入口 smoke 与逐项 approved 判定收口 | 新增 `tests/test_v0223_expapproval006_rc_smoke.gd` 并注册 `tests/headless_runner.gd`，覆盖 Town Plaza / World Map、Home、Shop、Album、Settings、School Gate、School Yard 的真实可见入口、关闭路径、触控高度、儿童安全文本和 A-Z 稳定性；新增 `tests/capture_expapproval006_rc.gd` 和 `docs/collaboration/round119_expapproval006_rc/` 16 张同轮 1280x720 runtime proof；新增 `docs/collaboration/Round119_V02.23_EXPAPPROVAL-006_1280_RC截图包真实入口smoke与逐项判定记录.md`，逐项判定 Town Plaza / World Map、Home、Shop、School Gate、School Yard、Settings 为 approved，Album 经同轮回归 proof 无可见退化并保持 approved；`godot --headless --path . --script tests/test_v0223_expapproval006_rc_smoke.gd`、`godot --headless --path . --check-only --script tests/capture_expapproval006_rc.gd`、V02.21 free life、Playable UI、Shop-School arrival、map readability、panel split、V02.23 EXPAPPROVAL-002..005 focused tests、`tests/headless_runner.gd`、`godot --headless --path . --quit`、`godot --path . --display-driver x11 --resolution 1280x720 --script tests/capture_expapproval006_rc.gd` 和 `file docs/collaboration/round119_expapproval006_rc/*.png` 均通过；V02.23 体验批准线收口，下一轮 Ready 为 `V02-HOMEPLAZA-001 PM 路线与禁改边界`；无新增已验证教训 |
| 2026-06-07 | Round 120 规划 / Ready | V02-HOMEPLAZA-001 PM 路线与禁改边界收口 | 新增 `docs/collaboration/Round120_V02.24_HOMEPLAZA-001_PM路线与禁改边界.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md` 和 `lessons.md`；固定 V02.24 Home / Town Plaza 居住感加固队列、禁改范围、验收矩阵和测试计划，明确默认生活角不写入 `home_state.placed_furniture`、不改 HomeDecorationService 存档结构、不改 26 个 A-Z anchor / route_order / 相册语义、孩子端不显示格子 / 坐标 / 占格 / footprint / debug 术语；本轮仅改 PM 文档和台账，未改 runtime、tests、assets 或 data；静态一致性检查和 `godot --headless --path . --quit` 通过；下一轮 Ready 为 `V02-HOMEPLAZA-002 HomeRoom 居住感加固`；无新增已验证教训 |
| 2026-06-07 | Round 121 验收 / Ready | V02-HOMEPLAZA-002 HomeRoom 居住感加固收口 | `scenes/world/home/home_room.tscn` 和 `scripts/stages/home_room.gd` 新增 HomeDefaultBookStack、HomeDefaultSunnyToy、HomeDefaultWarmCup 三个非保存默认生活细节，Home 空状态与 Sunny 反馈文案更生活化；`scripts/main.gd` 新增 V02.24 Home living contract snapshot 标识和新默认细节 texture fallback；新增 `tests/test_v0224_home_room_living_contract.gd` 并注册 `tests/headless_runner.gd`，覆盖默认生活角不少于 9 个细节、默认细节不写入 `placed_furniture`、可见按钮摆放 pet bowl / Sunny bed、保存 state 只含玩家摆放家具和儿童文本无技术术语；`godot --headless --path . --script tests/test_v0224_home_room_living_contract.gd`、`godot --headless --path . --check-only --script scripts/stages/home_room.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0223_expapproval_home_living_density.gd`、`godot --headless --path . --quit` 和 `godot --headless --path . --script tests/headless_runner.gd` 均通过；不改 HomeDecorationService 存档结构，不改 A-Z anchor / route_order / 相册语义；下一轮 Ready 为 `V02-HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则`；无新增已验证教训 |
| 2026-06-07 | Round 122 验收 / Ready | V02-HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则收口 | `scripts/systems/outdoor_decoration_service.gd` 增加 plaza-side allowed zones、item footprint、protected anchor / interaction / resource / NPC / place 检查和 allowed-place summary；`scripts/stages/town_stage.gd` 增加 PlazaChatStool、PlazaSnackCrate 非交互停留点和 `plaza_stay_point_count` / `outdoor_decor_count` snapshot；`scripts/main.gd` 向 outdoor service 注入 world map、resource points 和 NPC context；新增 `tests/test_v0224_town_plaza_outdoor_decor_rules.gd` 并注册 `tests/headless_runner.gd`，覆盖安全角落摆放 / 挪动、非 plaza 区域拒绝、Home entry / Taxi anchor / Taxi stone / Mina / 大件 footprint 覆盖拒绝、重叠拒绝、runtime outdoor decor 渲染和 26 A-Z anchor 保持；`godot --headless --path . --check-only --script scripts/systems/outdoor_decoration_service.gd`、`scripts/stages/town_stage.gd`、`scripts/main.gd`、`tests/headless_runner.gd`、`godot --headless --path . --script tests/test_v0224_town_plaza_outdoor_decor_rules.gd`、`tests/test_v0222_hidden_grid_life_systems.gd`、`tests/test_v0223_expapproval_town_plaza_density.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-HOMEPLAZA-004 NPC routine 与广场到达感`；无新增已验证教训 |
| 2026-06-07 | Round 123 验收 / Ready | V02-HOMEPLAZA-004 NPC routine 与广场到达感收口 | `scripts/systems/npc_routine_service.gd` 增加 world map arrival safety、protected anchor / interaction / place / collision 检查、blocked routine fallback、arrival zone 和温和 arrival text；`scripts/main.gd` 向 routine service 注入 world map；新增 `tests/test_v0224_npc_routine_arrival_safety.gd` 并注册 `tests/headless_runner.gd`，覆盖安全 Plaza routine、坏数据 fallback、缺失 routine fallback、Mina / Shopkeeper 可达 prompt、anchor / interaction arrival 拒绝和 plaza arrival count；`godot --headless --path . --check-only --script scripts/systems/npc_routine_service.gd`、`scripts/main.gd`、`tests/headless_runner.gd`、`tests/test_v0224_npc_routine_arrival_safety.gd`、`godot --headless --path . --script tests/test_v0224_npc_routine_arrival_safety.gd`、`tests/test_v0222_hidden_grid_life_systems.gd`、`tests/test_v0221_livegate_hotspot_priority.gd`、`tests/headless_runner.gd` 和 `godot --headless --path . --quit` 均通过；下一轮 Ready 为 `V02-HOMEPLAZA-005 回归、截图与收口`；无新增已验证教训 |
| 2026-06-07 | Round 124 验收 / 阶段收口 | V02-HOMEPLAZA-005 回归、截图与收口 | 新增 `tests/test_v0224_homeplaza005_rc_smoke.gd` 并注册进 `tests/headless_runner.gd`，覆盖 Home living contract、Town Plaza stay points / outdoor decor、NPC routine plaza arrival、Mina prompt、Shop / Album / Settings 旧可见路径和儿童文本安全；新增 `tests/capture_homeplaza005_rc.gd` 和 `docs/collaboration/round124_homeplaza005_rc/` 五张 1280x720 proof；新增 `docs/collaboration/Round124_V02.24_HOMEPLAZA-005_回归截图与收口.md`；`godot --headless --path . --script tests/test_v0224_home_room_living_contract.gd`、`tests/test_v0224_town_plaza_outdoor_decor_rules.gd`、`tests/test_v0224_npc_routine_arrival_safety.gd`、`tests/test_v0224_homeplaza005_rc_smoke.gd`、`tests/headless_runner.gd`、`godot --headless --path . --quit`、`godot --path . --display-driver x11 --resolution 1280x720 --script tests/capture_homeplaza005_rc.gd` 和 `file docs/collaboration/round124_homeplaza005_rc/*.png` 均通过；V02.24 阶段收口但不标 product complete；下一轮 Ready 为 `V02-MAPAUTH-001 错误列表与验证按钮`；无新增已验证教训 |
| 2026-06-07 | Round 125 验收 / Ready | V02-MAPAUTH-001 错误列表与验证按钮收口 | `TownMapAuthoring` 新增 export validation panel、Validate button、状态文本和错误列表，验证候选 dictionary 时显式不写回 JSON；新增 `tests/test_v0225_mapauth001_validation_panel.gd` 并注册进 `tests/headless_runner.gd`；focused validation panel、authoring export、全量 headless runner 和 Godot 启动通过；下一轮 Ready 为 `V02-MAPAUTH-002 安全写回 JSON 服务`；无新增已验证教训 |
| 2026-06-07 | Round 126 验收 / Ready | V02-MAPAUTH-002 安全写回 JSON 服务收口 | `MapEditorSyncService` 新增 validate -> temp -> backup -> swap -> post-write load 的 `write_if_valid()` / `write_authoring_scene_if_valid()` / `write_valid_dictionary()`；新增 `tests/test_v0225_mapauth002_write_back_service.gd` 并注册进 `tests/headless_runner.gd`，覆盖合法写、非法不写、模拟失败不毁文件和 runtime load；MAPAUTH-001、authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动通过；下一轮 Ready 为 `V02-MAPAUTH-003 Place marker 新增 / 删除最小闭环`；无新增已验证教训 |
| 2026-06-07 | Round 127 验收 / Ready | V02-MAPAUTH-003 Place marker 新增 / 删除最小闭环收口 | `TownMapAuthoring` 新增 place candidate add / delete / summary API，只改候选 dictionary 和 marker layer，不写 runtime JSON；新增 place 自动带 interaction cell，删除同步移除 interaction，anchor-owned place 删除返回 `place_has_anchors`；新增 `tests/test_v0225_mapauth003_place_marker_loop.gd` 并注册进 `tests/headless_runner.gd`；`godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`、`tests/test_v0225_mapauth003_place_marker_loop.gd`、`tests/headless_runner.gd`、focused MAPAUTH-001/002/003、authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动通过；下一轮 Ready 为 `V02-MAPAUTH-004 A-Z anchor 删除保护与编辑限制`；无新增已验证教训 |
| 2026-06-07 | Round 128 验收 / Ready | V02-MAPAUTH-004 A-Z anchor 删除保护与编辑限制收口 | `TownMapAuthoring` 新增 A-Z anchor delete / locked-field edit guard 和 anchor summary；删除 `anchor_a_apple` 等核心 anchor 返回 `protected_core_anchor`，未知 anchor 返回 `unknown_anchor_id`，核心字段 `anchor_id` / `letter` / `core_word` / `route_order` / `place_id` / `card_id` / `audio_id` 返回 `anchor_field_locked`；新增 `tests/test_v0225_mapauth004_anchor_protection.gd` 并注册进 `tests/headless_runner.gd`；`godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`、`tests/test_v0225_mapauth004_anchor_protection.gd`、`tests/headless_runner.gd`、focused MAPAUTH-001/002/003/004、authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动通过；下一轮 Ready 为 `V02-MAPAUTH-005 Place 移动联动策略`；无新增已验证教训 |
| 2026-06-07 | Round 129 验收 / Ready | V02-MAPAUTH-005 Place 移动联动策略收口 | `TownMapAuthoring` 新增 `move_place_marker_candidate()` guarded move；合法移动同步更新 `position`、`occupied_cells`、主 `interaction_cell`、顶层 `interaction_cells` 和 footprint 镜像 `collision_cells`，经 move overlap 检查与 `MapEditorSyncService.export_to_dictionary()` 合同验证通过后才提交候选；非法移动保持上一份有效候选且不写 `world_map.json`；新增 `tests/test_v0225_mapauth005_place_move_linkage.gd` 并注册进 `tests/headless_runner.gd`；`godot --headless --path . --check-only --script scripts/editor/town_map_authoring.gd`、`tests/test_v0225_mapauth005_place_move_linkage.gd`、focused MAPAUTH-001/002/003/004/005、authoring export、A-Z runtime、map readability、全量 headless runner 和 Godot 启动通过；下一轮 Ready 为 `V02-MAPAUTH-006 回归与 runner 集成`；无新增已验证教训 |
| 2026-06-07 | Round 130 验收 / 阶段收口 | V02-MAPAUTH-006 回归与 runner 集成收口 | `tests/test_town_map_authoring_export.gd` 改用 `move_place_marker_candidate()` guarded move 并断言 linked interaction / collision、26 A-Z 和 runtime JSON 不变；新增 `tests/test_v0225_mapauth006_regression_pack.gd` 并注册进 `tests/headless_runner.gd`，覆盖 authoring scene 合法写临时 JSON、RuntimeMapBuilder load、26 A-Z 保持、Home linked move 落盘、raw invalid candidate `validation_failed` 不写、target 原文不变、无 `.tmp` 残留和真实 `world_map.json` 不变；`godot --headless --path . --check-only --script tests/test_v0225_mapauth006_regression_pack.gd`、`tests/test_town_map_authoring_export.gd`、`tests/test_v0225_mapauth006_regression_pack.gd`、focused MAPAUTH-001/002/003/004/005、A-Z runtime、map readability、全量 headless runner 和 Godot 启动通过；V02.25 阶段收口；下一轮 Ready 为 `V02-CONTENTBATCH-001 NPC routine 小批量`；无新增已验证教训 |
| 2026-06-07 | Round 131 验收 / Ready | V02-CONTENTBATCH-001 NPC routine 小批量收口 | `data/life/npc_routines.json` 扩展为 7 天五居民 routine 小批量，位置均通过 arrival safety 且文案避免赶路 / 迟到 / 错过 / 值班压力；新增 `tests/test_v026_contentbatch001_npc_routine_batch.gd` 并注册进 `tests/headless_runner.gd`，覆盖 7 天加载、五居民齐全、默认无 blocked / fallback、每位居民至少两处轻变化、fallback 坏数据保护、day 7 runtime snapshot 和 Mina 可达 prompt；同步更新 runner 旧 V02.22 routine 断言以适配默认数据完整后的无 blocked 状态；`godot --headless --path . --check-only --script scripts/systems/npc_routine_service.gd`、`tests/test_v026_contentbatch001_npc_routine_batch.gd`、`tests/test_v0224_npc_routine_arrival_safety.gd`、`tests/test_v024_content_contracts.gd`、`tests/headless_runner.gd` 和 Godot 启动通过；下一轮 Ready 为 `V02-CONTENTBATCH-002 资源刷新点小批量`；无新增已验证教训 |
| 2026-06-07 | Round 132 验收 / Ready | V02-CONTENTBATCH-002 资源刷新点小批量收口 | `data/life/resource_points.json` 新增 coast shell、school walk leaf、animal park pinecone、shop street ribbon 四个每日软刷新点；`data/items/life_items.json` 新增对应材料和 A-Z 记忆故事；新增 `tests/test_v026_contentbatch002_resource_points.gd` 并注册进 `tests/headless_runner.gd`，覆盖加载、目录、可达道路、protected cell 避让、无压力词、同日去重、跨日刷新和主场景真实 prompt；同步修正 `tests/test_v0222_hidden_grid_life_systems.gd` 旧 fallback 断言；focused、content contracts、daily services、资源 / 热点回归、全量 headless runner 和 Godot 启动通过；下一轮 Ready 为 `V02-CONTENTBATCH-003 A-Z 生活物件回访`；无新增已验证教训 |
| 2026-06-07 | Round 133 验收 / Ready | V02-CONTENTBATCH-003 A-Z 生活物件回访收口 | `data/anchors/new_word_revisit_paths.json` 新增 A/D/K/H/M/U 六条生活物件回访，分别绑定 photo、towel、leaf、ribbon、pinecone、shell；新增 `tests/test_v026_contentbatch003_anchor_revisits.gd` 并注册进 `tests/headless_runner.gd`，覆盖必填字段、story_id 唯一、`core_anchor_id` 全局唯一、核心 anchor / letter 匹配、儿童安全文案、service lookup、card state 和主场景六个真实 anchor prompt；memory palace 回归、content contracts、全量 headless runner 和 Godot 启动通过；下一轮 Ready 为 `V02-CONTENTBATCH-004 Shop front / School Yard 小事件 smoke`；无新增已验证教训 |
| 2026-06-07 | Round 134 验收 / 阶段收口 | V02-CONTENTBATCH-004 Shop front / School Yard 小事件 smoke 收口 | `data/life/homeschool_events.json` 新增 `homeschool_shop_front_window_001` 与 `homeschool_school_yard_chalk_flower_001` 两个生活化看一眼事件；`data/maps/world_map.json` 在 Shop Street `42,9` 与 School Yard `18,14` 新增真实 `look_homeschool_event` 入口，避开已有 exact anchor / resource / interaction / collision；新增 `tests/test_v026_contentbatch004_look_events.gd` 并注册进 `tests/headless_runner.gd`，覆盖 JSON、可达性、protected cell、儿童安全文本、主场景真实 `看看`、保存落账、相册 card state 和 Shop P0 入口不阻断；focused、V02.14 homeschool 回归、CONTENTBATCH-002/003 回归、content contracts、全量 headless runner 和 Godot 启动通过；V02.26 内容生产小批量阶段收口，当前无 Ready；无新增已验证教训 |
| 2026-06-07 | Round 135 验收 / 阶段收口 | V02-MAPEDITOR-001..007 Map Editor 完整化收口 | `TownMapAuthoring` 增加 toolbar、七类图层开关、tool mode、Inspector、底部状态、Place 属性编辑 / 拖动 / Save Map、road / collision / interaction 单 cell 画笔、resource marker 编辑与 Save Resources、NPC routine day selector / marker 编辑与 Save Routines、A-Z anchor `move_anchor` 专门迁移模式；`MapEditorSyncService` 增加 resource_points / npc_routines 分文件 validate 与安全写入；新增 `tests/test_v027_mapeditor_layers_inspector.gd`、`test_v027_mapeditor_place_save.gd`、`test_v027_mapeditor_cell_painting.gd`、`test_v027_mapeditor_resource_save.gd`、`test_v027_mapeditor_npc_routine_save.gd`、`test_v027_mapeditor_anchor_migration_guard.gd`、`test_v027_mapeditor_full_regression.gd` 并注册进 `tests/headless_runner.gd`；同步 docs 12-15 和 `docs/collaboration/Round135_V02.27_MAPEDITOR-001-007验收记录.md`；focused、全量 headless runner 和 Godot 启动通过；V02.27 阶段收口，当前无 Ready；无新增已验证教训 |
| 2026-06-07 | Round 136 验收 / 返修收口 | V02-MAPEDITOR-008 Map Editor 可用性降噪收口 | `scenes/map_editor/town_map_authoring.tscn` 和 `TownMapAuthoring` 固定地图画布 origin、顶部验证 / 工具工作带、右侧 Inspector / 状态工作栏，缩短 toolbar 按钮和 layer toggle 文案；`MapAuthoringMarker` 改为短 badge 标签和类型配色，降低 resource / NPC / A-Z / place marker 长文本重叠；新增 `tests/test_v027_mapeditor_usability_declutter.gd` 并注册进 `tests/headless_runner.gd`，覆盖布局 origin、工作栏位置、marker label 长度和既有默认图层可见性；`scripts/editor/town_map_authoring.gd`、`scripts/editor/map_authoring_marker.gd` check-only、V02.27 focused tests、`tests/headless_runner.gd`、`godot --headless --path . --quit`、`git diff --check` 和 `.tmp/.bak` 残留检查均通过；不改三份 JSON 保存合同，不进入孩子端 runtime；当前无 Ready；无新增已验证教训 |
| 2026-06-07 | Round 137 验收 / 返修收口 | V02-MAPEDITOR-009 Map Editor 视觉布局二次整理收口 | `TownMapAuthoring` 改为左侧控制侧栏 + 右侧地图画布布局，`MAP_CELL_SIZE` 保持 15px，地图 origin 为 `(252, 52)`，60x34 canvas 在 1280x720 内完整显示；验证、工具、Inspector、状态面板固定高度并启用 `clip_contents`，sidebar label 限制行数，避免面板扩成超高黑块；`tests/test_v027_mapeditor_usability_declutter.gd` 增加 validation / toolbar / inspector / status 高度与 viewport 断言；MCP runtime 测量确认 `ExportValidationPanel=228x116`、`EditorToolbar=228x272`、`InspectorPanel=228x130`、`EditorStatusPanel=228x142`，截图返回 1280x720；check-only、V02.27 focused tests、`tests/headless_runner.gd`、`godot --headless --path . --quit` 和 `git diff --check` 均通过；不改三份 JSON 保存合同，不进入孩子端 runtime；当前无 Ready；无新增已验证教训 |
| 2026-06-07 | Round 138 验收 / 返修收口 | V02-MAPEDITOR-010 Map Editor 直接拖拽编辑与字母可见性返修收口 | `MapAuthoringMarker` 改为按下后全局追踪拖拽和释放，避免鼠标离开小 marker 后拖拽中断；`TownMapAuthoring` 将 marker drag finish 接入候选 move 验证，并新增场景内 Inspector 输入框 / Apply，可直接编辑 Place / resource / NPC routine 字段；A-Z marker 字号增大、颜色不透明、z 顺序提高并保持 Move A-Z 专门模式保护；新增 `tests/test_v027_mapeditor_direct_edit_drag.gd` 并注册进 `tests/headless_runner.gd`，更新 `tests/test_v027_mapeditor_usability_declutter.gd` 覆盖字母可见性；check-only、focused tests、`tests/headless_runner.gd`、`godot --headless --path . --quit` 和 `git diff --check` 均通过；不改三份 JSON 保存合同，不进入孩子端 runtime；当前无 Ready；无新增已验证教训 |
| 2026-06-07 | Round 139 规划 / Ready | V02-MAPDOGFOOD-001 PM 路线、禁改边界和任务包收口 | 新增 `docs/collaboration/Round139_V02.28_MAPDOGFOOD-001_PM路线与任务包.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；固定 V02.28 Map Editor 实战生产验证队列、禁改边界、验收矩阵和下一轮 Ready；明确正式 dogfood 必须通过场景内 Map Editor 候选 state、Validate、`MapEditorSyncService` 安全写回、post-load verify 和孩子端真实入口证明，手工 JSON 调试不能算交付；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-MAPDOGFOOD-002 Map Editor 小批量生产实战`；无新增已验证教训 |
| 2026-06-07 | Round 140 验收 / 阶段收口 | V02-MAPDOGFOOD-002..005 Map Editor 实战生产验证收口 | 用场景内 `TownMapAuthoring` 候选 API 完成 Story Bench / Ribbon Corner 两个 Place、`resource_ribbon_shop_street` 移动和 `routine_shopkeeper_shop_003` 微调，经 Validate 和 `MapEditorSyncService` 安全写回正式 JSON；`TownMapAuthoring` 补齐 `place_action` Inspector 编辑并同步 interaction action；新增 `tests/test_v028_mapdogfood_production.gd` 并注册进 `tests/headless_runner.gd`，覆盖正式数据、孩子端真实移动 / `看看` / resource / NPC 路径、禁用文本和 26 A-Z 稳定；新增 `docs/collaboration/Round140_V02.28_MAPDOGFOOD-002-005实战生产验证收口.md`；`godot --headless --path . --script tests/test_v028_mapdogfood_production.gd`、`godot --headless --path . --check-only --script tests/headless_runner.gd`、`godot --headless --path . --script tests/headless_runner.gd`、`godot --headless --path . --quit` 和 `git diff --check` 均通过；非 headless 1280 proof 曾导出并复核，临时 PNG / capture / apply 脚本已按仓库清理要求移除；V02.28 阶段收口但不标 product complete；新增 `LESSON-012` |
| 2026-06-07 | Round 141 规划 / Ready | V02-STORYMOTIONART-001 V02.29-V02.36 长远路线与任务包收口 | 新增 `docs/collaboration/Round141_V02.29-V02.36_STORYMOTIONART长远路线与任务包.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；将完整故事线、当前地图适配、行走动画、Animal Crossing-like 操控、美术资产生产与接入、动作操控纵切和故事整合纵切拆成 V02.29-V02.36 多轮长线规划；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-STORYLINE-002 全量故事线总纲与章节骨架`；无新增已验证教训 |
| 2026-06-07 | Round 142 规划 / Ready | V02-STORYLINE-002 全量故事线总纲与章节骨架收口 | 新增 `docs/collaboration/Round142_V02.29_STORYLINE-002全量故事线总纲与章节骨架.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；故事总纲覆盖 P0 Home / School / Shop / Story Plaza、P1 Animal Park / Coast Edge、26 个 A-Z anchor 故事索引、每个 anchor 的地点 / 触发者 / 环境词 / story memory / visual hook / review path / 首批资产需求；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-STORYLINE-003 当前地图适配与内容生产蓝图`；无新增已验证教训 |
| 2026-06-07 | Round 143 规划 / Ready | V02-STORYLINE-003 当前地图适配与内容生产蓝图收口 | 新增 `docs/collaboration/Round143_V02.30_STORYLINE-003当前地图适配与内容生产蓝图.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；将故事总纲映射到当前 Place / interaction / resource / NPC routine / A-Z anchor，分为 `direct_runtime`、`asset_only` 和 `map_editor_candidate`；列出 Story Bench、School Yard、Home story wall、Animal Park、Coast X box 和 routine 候选；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-MOTION-001 行走动画与角色动作规格`；无新增已验证教训 |
| 2026-06-07 | Round 144 规划 / Ready | V02-MOTION-001 行走动画与角色动作规格收口 | 新增 `docs/collaboration/Round144_V02.31_MOTION-001行走动画与角色动作规格.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；基于当前 `Main` 连续移动、`TownStage` 渲染、`PlayerActor` / `NPCActor` Sprite2D 拼装和 ThemeProfile standing fallback，固定 Player / Sunny / Mina / Shopkeeper / Story Bear / Bus Helper 动作优先级、4 向基础动作、8 向预留、sprite sheet、metadata、logical animation ID、fallback 和 runtime proof 口径；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-CONTROLS-001 Animal Crossing-like 操控规格`；无新增已验证教训 |
| 2026-06-07 | Round 145 规划 / Ready | V02-CONTROLS-001 Animal Crossing-like 操控规格收口 | 新增 `docs/collaboration/Round145_V02.32_CONTROLS-001动森式操控规格.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；基于当前 tap-to-cell、keyboard 单步、`move_toward()` 连续显示、`TownStage` camera clamp 和 prompt 系统，固定 unified motion intent、输入仲裁、keyboard hold、tap-to-move 替换、virtual joystick / gamepad、速度曲线、prompt 锁定、camera smoothing、隐藏网格边界和 V02.35 proof 口径；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格`；无新增已验证教训 |
| 2026-06-07 | Round 146 规划 / Ready | V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格收口 | 新增 `docs/collaboration/Round146_V02.33_ARTPIPE-001美术资产生产规格.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；输出 P0/P1/P2 tile / edge、story prop、anchor refresh、character motion、UI feedback、production batch、asset acceptance 字段和禁用风格清单；本轮未生成资产、未改 ThemeProfile、未改 runtime / data / tests；下一轮 Ready 为 `V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范`；无新增已验证教训 |
| 2026-06-07 | Round 147 规划 / Ready | V02-ARTPIPE-002 Map Editor / ThemeProfile / AssetResolver 接入规范收口 | 新增 `docs/collaboration/Round147_V02.34_ARTPIPE-002_MapEditor_ThemeProfile_AssetResolver接入规范.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；固定新增 ThemeProfile / AssetResolver 类别、story prop marker、sprite sheet metadata、Map Editor 接入流程、asset acceptance、runtime proof 和 validator 规则；本轮未生成资产、未改 runtime / data / tests；下一轮 Ready 为 `V02-ARTPROD-001 首批美术资产生产与接入`；无新增已验证教训 |
| 2026-06-07 | Round 148 验收 / Ready | V02-ARTPROD-001 首批美术资产生产与接入收口 | 新增 `docs/collaboration/Round148_V02.34_ARTPROD-001首批美术资产生产与接入.md`；新增 4 个 P0 story prop PNG、player / Sunny motion sheet、motion metadata、3 个 UI feedback PNG、1 个 tile edge PNG 和 `data/life/story_props.json`；`ThemeProfileResource`、`AssetResolver`、`MapEditorSyncService`、`TownMapAuthoring` 和 `tests/headless_runner.gd` 完成扩展接入；新增 `tests/test_v0234_artprod001_asset_integration.gd`，覆盖 extended resolver、production acceptance、metadata、story prop validator、Map Editor marker / Inspector / drag；`tests/test_asset_resolver.gd`、ARTPROD-001 focused、full headless runner 和 check-only 均通过；首批资产仅标 production，不自动 approved；下一轮 Ready 为 `V02-RUNTIME-ANIM-001 动作操控运行时纵切`；后续 Round141-151 图片来源返修已确认仅 Round148 新增 bitmap PNG，并用 `/home/xionglei/GameProject/tools/image_generator.js` 重生 10 张同名 PNG，focused、full runner、Godot 启动和 `git diff --check` 通过；新增 `LESSON-013` |
| 2026-06-07 | Round 149 验收 / Ready | V02-RUNTIME-ANIM-001 动作操控运行时纵切收口 | 新增 `docs/collaboration/Round149_V02.35_RUNTIME-ANIM-001动作操控运行时纵切.md`；`PlayerActor` 接入 `anim_sheet.player.p0_motion` 的 idle / walk runtime state 和 standing fallback；`Main` / `TownStage` 接入 keyboard hold、camera smoothing、prompt glow、tap ripple feedback、`FeedbackLayer` 和 runtime motion snapshot；新增 `tests/test_v0235_runtime_anim_controls.gd` 并注册进 `tests/headless_runner.gd`；`godot --headless --path . --check-only --script scripts/main.gd`、`scripts/stages/player_actor.gd`、`scripts/stages/town_stage.gd`、`tests/test_v0235_runtime_anim_controls.gd`、`tests/test_v0220_playgate_controls.gd`、`tests/headless_runner.gd` check-only/full 和 MCP 1280x720 viewport proof 均通过；下一轮 Ready 为 `V02-STORYSLICE-001 故事线 + 美术 + 动作整合纵切`；无新增已验证教训 |
| 2026-06-07 | Round 150 验收 / V02.36 收口 | V02-STORYSLICE-001 故事线 + 美术 + 动作整合纵切收口 | 新增 `docs/collaboration/Round150_V02.36_STORYSLICE-001故事线美术动作整合纵切.md`；`data/life/story_props.json` 补齐 child feedback、environment words、Story Bear / branch context；`scenes/world/town_stage.tscn` / `scripts/stages/town_stage.gd` 新增 `StoryPropLayer` 并在 runtime 渲染四个 P0 story prop production 资产；`scripts/main.gd` 新增 story prop loader、`look_story_prop`、story prop prompt、story slice save record、A-Z card state 落账和 `get_story_slice_snapshot()`；新增 `tests/test_v0236_storyslice001_runtime.gd` 并注册进 `tests/headless_runner.gd`；Home apple photo、Town Plaza bear book branch、School Yard net / robot / yo-yo corner、Shop hat ribbon window 四条路径可玩，A/B/H/N/R/Y 六个 anchors 落账到相册；`godot --headless --path . --check-only --script scripts/main.gd`、`scripts/stages/town_stage.gd`、`tests/test_v0236_storyslice001_runtime.gd`、`tests/headless_runner.gd`、V02.36 focused、full runner、JSON、diff check 和 MCP 1280x720 viewport proof 均通过；无新增已验证教训 |
| 2026-06-07 | Round 151 规划 / Ready | V02-STORYBATCH-001 内容批量生产与批准线规划收口 | 新增 `docs/collaboration/Round151_V02.37_STORYBATCH-001内容批量生产与批准线规划.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md` 和 `todo.md`；确认 V02.29-V02.36 可阶段收口，并将后续拆为第二批 story prop / A-Z 回访内容包、production 资产接入、runtime smoke、1280 proof 与 approved 判定；固定 production 不自动 approved、同轮 1280 proof 和 PM / Art Direction 判定规则；本轮未改 runtime、data、tests 或 assets；下一轮 Ready 为 `V02-STORYBATCH-002 第二批 story prop / A-Z 回访内容包`；无新增已验证教训 |
| 2026-06-07 | Round 152 验收 / Ready | V02-STORYBATCH-002 第二批 story prop / A-Z 回访内容包收口 | 新增 `docs/collaboration/Round152_V02.37_STORYBATCH-002第二批story_prop与AZ回访内容包.md`；第二批 P0 内容包覆盖 C Clock、D Dog、G Gate、K Kite、O Orange、S Sun、W Watch 七条候选，均绑定 stable anchor、place、context、environment words、story memory、visual hook、review path、asset need 和 child feedback；新增 `tests/test_v0237_storybatch002_content_pack.gd` 并在 `tests/headless_runner.gd` 注册轻量文档合同门槛；本轮未生成图片、未改 ThemeProfile / AssetResolver、未改 runtime、未写正式 JSON；focused、full runner 和 check-only 均通过；下一轮 Ready 为 `V02-STORYBATCH-003 第二批 production 资产与接入`；无新增已验证教训 |
| 2026-06-07 | Round 153 验收 / V02.38 阻塞输入 | V02-STORYBATCH-003 第二批 production 资产与接入收口 | 新增 `docs/collaboration/Round153_V02.37_STORYBATCH-003第二批production资产与接入.md`；使用 `/home/xionglei/GameProject/tools/image_generator.js` 生成 7 张 C/D/G/K/O/S/W story prop source PNG，并用 ImageMagick 完成 chroma-key 抠底、resize、transparent extent 和接触表目检；新增 / 覆盖 `assets/art/story_props/home/clock_chair_corner_v001.png`、`sunny_towel_dog_corner_v001.png`、`watch_wall_charm_v001.png`、`school/gate_bell_sign_v001.png`、`walk/kite_leaf_path_v001.png`、`shop/orange_bowl_window_v001.png`、`plaza/sun_flower_patch_v001.png`；`ThemeProfile` / `AssetResolver`、`data/life/story_props.json`、Map Editor story prop marker 和 `tests/test_v0237_storybatch003_asset_integration.gd` 均通过；focused check-only、focused、full runner check-only 和 full runner 均通过；production 未自动 approved；原计划下一轮 `V02-STORYBATCH-004` 后续被 V02.38 / V02.39 视觉门槛继续阻塞，当前需等待 `runtime_visual_match`；无新增已验证教训 |
| 2026-06-07 | Round 154 验收 / Ready | V02-VISUALRECOVERY-001 全面纠偏与文档重写收口 | 新增 `docs/collaboration/Round154_V02.38_VISUALRECOVERY-001全面纠偏与文档重写.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md` 和 `lessons.md`；V02.37 后续 runtime / approved 推进暂停，Round153 第二批 production 资产仅作库存；Round119 旧 `approved` 改按 `functional_pass` 管理；`artpass003_visual_direction` / Round92 成为硬门槛；`world_map_base_1280.png` 只能作 reference；静态一致性复核、`git diff --check` 和 `godot --headless --path . --quit` 通过；下一轮 Ready 为 `V02-VISUALRECOVERY-002 Modular Visual System 规格`；新增 `LESSON-014` |
| 2026-06-07 | Round 155-Round159 验收 / visual scaffold | V02-VISUALRECOVERY-002..006 全面视觉恢复收口 | 新增唯一权威 `Round155_V02.38_VISUALRECOVERY-002_ModularVisualSystem规格.md`；新增 / 补齐 `assets/art/visual_recovery/**` 首屏 modular asset pack、School-line chunk、Round156 provenance 和 864x878 contact sheet；`ThemeProfileResource` / `AssetResolver` 支持 V02.38 modular categories 与 canonical aliases；`TownStage` 改为 terrain tiles + region chunks + Home / Shop / School prefabs + prop-first world props，不再创建 legacy `Ground` 或使用 `place.world_map.base_1280` 作 final runtime ground；HUD / prompt / actor shadows / A-Z badge / resolved 和 fallback non-prefab place marker 完成降噪，并以 `non_prefab_place_max_alpha <= 0.22` 防回归；新增 `tests/test_v0238_visual_recovery_runtime.gd`、`tests/capture_v0238_visual_recovery_gate.gd` 并注册 full runner；Round159 5 张 1280 proof 已导出，原 gate 结果为 `visual_candidate`，未授予 `final_approved`；二次视觉复核后项目级重解释为 `visual_scaffold`，不足以解锁 StoryBatch；验证：`git diff --check`、`jq empty data/themes/theme_sunshine_town_placeholder.json`、`godot --headless --path . --quit`、`tests/test_asset_resolver.gd`、`tests/test_town_stage_layered_runtime.gd`、`tests/test_v0238_visual_recovery_runtime.gd`、`tests/test_v0218_map_readability.gd`、`tests/headless_runner.gd`、capture check-only 和 non-headless x11 capture 均通过；新增 `LESSON-015` |
| 2026-06-07 | Round 160 规划 / Ready | V02-VISUALREBUILD-001 Godot 视觉生产体系重建路线与任务包收口 | 新增 `docs/collaboration/Round160_V02.39_VISUALREBUILD-001视觉生产体系重建路线与任务包.md`；同步 `docs/12_V02开发路线.md`、`docs/13_V02详细开发计划.md`、`docs/14_内容基线整理与首批内容规划.md`、`docs/15_项目经理接管与下一阶段执行计划.md`、`todo.md` 和 `lessons.md`；确认问题是生产模型错误而非局部截图 polish，固定 V02.39 队列、状态语义、Logic Map / Visual Layout 分离、target frame 优先和 StoryBatch 阻塞；本轮不改 runtime / data / tests / assets；下一轮 Ready 为 `V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同`；新增 `LESSON-016` |
