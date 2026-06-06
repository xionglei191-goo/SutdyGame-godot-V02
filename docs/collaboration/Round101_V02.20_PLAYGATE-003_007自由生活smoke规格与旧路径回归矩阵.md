# Round101 V02.20 PLAYGATE-003 / 007 自由生活 smoke 规格与旧路径回归矩阵

> 日期：2026-06-06
> 任务：`V02-PLAYGATE-003 启动到 5 分钟自由生活 playgate smoke 规格`、`V02-PLAYGATE-007 V02.8-V02.19 旧玩家路径回归矩阵`
> 范围：只做文档规格和矩阵，不改 runtime、assets、data 或 tests。

## 1. 输入与约束

本轮读取并核对：

- `todo.md`：Round101 当前状态为 V02.20 可居住小镇重建，`V02-PLAYGATE-003` 与 `V02-PLAYGATE-007` 仍为进行中。
- `lessons.md`：本规格必须落实 `LESSON-005` 生活 RPG 主循环、`LESSON-009` 真实可见入口、`LESSON-010` 截图工具链分离、`LESSON-011` 热点优先级回归。
- `docs/collaboration/Round100_V02.20_PLAYGATE-001_PM执行任务包.md`：V02.20 已有连续行走、局部镜头、上下文 `看看` 提示、HUD / anchor 降噪和 `tests/test_v0220_playgate_controls.gd`。
- 既有测试与记录：`tests/test_v028_daily_life_slice.gd`、`tests/test_playable_ui_operations.gd`、`tests/test_v022_home_room_contract.gd`、`tests/test_v023_memory_palace_world.gd`、`tests/test_v0211_weather_slice_smoke.gd`、`tests/test_v0214_homeschool_slice.gd`、`tests/test_v0215_school_daily_slice.gd`、`tests/test_v0216_playable_rc_gate.gd`、`tests/test_v0217_worldmap_anchor_runtime.gd`、`tests/test_v0218_map_readability.gd`、`tests/test_v0220_playgate_controls.gd`、`tests/headless_runner.gd`。

不可用作完成证据：

- 隐藏 `FooterContractButtons` 内的 `StartButton`、`HelpNeighborButton`、`BuyFoodButton`、`FeedSunnyButton`、`MemoryAlbumButton`、`LetterSnakeButton`。
- 直接调用服务方法完成玩家动作，如 `daily_request_service.interact_for_npc()`、`inventory_service.collect_item()`、`home_decoration_service.place_furniture()`。
- 只通过 JSON / service / contract 证明内容存在，而不经过孩子端真实可见入口。

允许的测试辅助边界：

- 可以清空测试存档、设置 `day_key`、实例化主场景。
- 可以用测试 helper 等待行走完成，前提是动作由孩子端可见入口发起或等价模拟真实输入。
- 可以为测试准备金币或初始存档，但 5 分钟 playgate smoke 的主规格应优先证明孩子真实路径；若需要预置，必须在断言中标明原因，不能替代经济闭环。

## 2. PLAYGATE-003：启动到 5 分钟自由生活 smoke 规格

### 2.1 目标

从启动主场景开始，用孩子端真实可见入口完成一段 3-5 分钟自由生活路径。路径要像在 Sunshine Town 中生活：走一走、看一看、问候居民、捡资源、去商店、回小屋摆放、看 Sunny 反馈、打开相册、打开设置再回到安全位置。

这不是课程 smoke、不是任务考试、不是隐藏按钮兼容性测试。它必须覆盖：

| 覆盖项 | 必须经过的孩子端入口 | 期望结果 |
|---|---|---|
| 移动 | 地图点击、键盘 / 输入动作或等价可见移动请求 | 玩家不是瞬移；镜头跟随；到达后保存位置 |
| `看看` | 底栏可见 `InteractButton` | 触发当前上下文目标 |
| NPC | 靠近 Mina 或 Sunny / 店长后按 `看看` | 显示儿童可读短句，写入关系或日常状态 |
| 资源 | 靠近 branch / flower / stone 后按 `看看` | 资源进入背包，同日重复不刷 |
| 商店 | 走到商店热点后按 `看看`，再点可见商品按钮 | 打开货架，购买或给出温和金币不足反馈 |
| 小屋 | 底栏可见 `小屋` 或 Home 热点进入 | 显示 HomeRoom 和家具操作入口 |
| Sunny | 小屋内反馈或 Sunny 相关 `看看` | 显示 Sunny 温暖反馈，不出现照护惩罚 |
| 相册 | 背包气泡可见 `相册` 按钮 | 打开 `小镇相册`，可关闭返回 |
| 设置 | 顶部设置按钮 | 打开设置，休息确认、继续逛、安全位置可见 |

### 2.2 推荐玩家路径

初始条件：

- 使用 `local_day_001` 或现有 V02.8 smoke 可稳定的 day key。
- 从默认安全位置启动，不使用隐藏 contract 按钮。
- 测试实现时优先使用 `request_player_walk_to_cell()` 或真实点击输入来发起移动，并等待行走完成；不要用 `move_player_to_cell()` 作为最终 playgate 证据。

步骤：

1. 启动主场景。
   - 断言：`TownHUD`、`TownFooter`、`InteractButton`、`TownNavButton`、`HomeNavButton`、`BackpackNavButton`、`SettingsButton` 可见。
   - 断言：隐藏 contract 按钮不可见。
   - 断言：首屏无 `Godot skeleton`、`Loaded places`、课程、测试、评分、打卡、倒计时、家长报告等文案。

2. 自由移动到 Mina 附近。
   - 操作：从孩子端移动入口发起行走，到达 Mina 附近。
   - 断言：移动过程中 `player_cell` 不提前跳到终点；到达后保存；局部镜头跟随；`InteractionPrompt` 显示米娜或 NPC 类型。

3. 按底栏 `看看` 问候 Mina。
   - 操作：点击可见 `InteractButton`。
   - 断言：HUD 显示米娜问候或轻委托文本；关系 / greeting / daily request 状态有本地保存；文本生活化。

4. 移动到资源点并按 `看看` 收集。
   - 操作：走到 branch / flower / stone 的可见资源位置，点击 `看看`。
   - 断言：背包数量增加；资源点写入当日已收集；再次 `看看` 不重复发放，反馈温和。

5. 返回 Mina 或当前 NPC 完成一次轻委托。
   - 操作：移动回 NPC，点击 `看看`。
   - 断言：完成文本显示；奖励金币或关系变化保存；不要求 Letter Snake、不出现学习结果。

6. 移动到商店热点并打开货架。
   - 操作：走到商店入口 / counter hotspot，点击 `看看`。
   - 断言：`ShopPanel` 可见；商品按钮可见；金币不足时不扣款且给温和反馈；金币足够时购买 furniture 进入背包。

7. 打开背包并打开相册。
   - 操作：点击底栏 `背包`，再点击气泡中的 `相册`。
   - 断言：`MemoryAlbumOverlay` 可见，标题为 `小镇相册`；已有 A-Z 或天气线索能显示收藏状态；点击返回关闭。

8. 进入小屋并摆放一件家具。
   - 操作：点击底栏 `小屋`，从可见 `HomeInventoryList` 的物件按钮摆放家具。
   - 断言：`HomeRoom` 可见；家具出现在 `HomeFurnitureLayer`；家具从背包消耗；保存后可读取；旋转 / 挪动 / 收起按钮状态合理。

9. 查看 Sunny 小屋反馈。
   - 操作：进入小屋后观察 `SunnyHomeFeedback`，或若测试路径包含 Sunny NPC，则靠近 Sunny 后按 `看看`。
   - 断言：反馈包含 Sunny，表达陪伴和居住感，不出现惩罚、健康焦虑或必须照顾。

10. 打开设置并回到安全位置。
    - 操作：点击顶部 `SettingsButton`，点击 `休息一下`、`继续逛`，再点击 `回到小镇`。
    - 断言：退出确认只在休息确认后出现；安全位置动作关闭设置并回到小镇；底栏不新增退出按钮。

11. 返回小镇完成收束。
    - 断言：TownStage 可见；HUD 状态仍是生活化反馈；存档中至少包含 player_cell、inventory、daily request / relationship、home_state、album card state 中的若干有效变化。

### 2.3 完成判定

`V02-PLAYGATE-003` 后续测试实现通过时，至少应满足：

- 全路径不使用隐藏 contract 按钮。
- 全路径至少一次经过连续行走和局部镜头，而不是全程直接改坐标。
- `看看` 由可见 `InteractButton` 发起。
- Shop、Home、Album、Settings 均由可见按钮或可见 hotspot 进入。
- 所有存档变化来自可见路径。
- 儿童安全文本扫描通过。
- 截图如需纳入验收，应走 MCP / 非 headless 工具链；headless 只证明逻辑和 UI 可见路径。

## 3. PLAYGATE-007：V02.8-V02.19 旧玩家路径回归矩阵

标记说明：

- `保留`：已有证据仍能支撑当前路径，后续只需纳入新 playgate 总 smoke。
- `退化`：功能仍可达，但可居住感或新 V02.20 控制口径不足，需要升级测试或体验。
- `待返修`：当前路径不应作为 playgate 完成证据，需后续实现修复或新测试。

| 阶段 / 路径 | 当前标记 | 现有证据 | 判定说明 |
|---|---|---|---|
| V02.8 每日小镇：Mina -> 资源 -> Mina 完成轻委托 -> 商店 -> 小屋 -> C/O/S 回访 | 退化 | `tests/test_v028_daily_life_slice.gd`、`tests/test_playable_ui_operations.gd`、`todo.md` V02-DAILYLIFE-005 完成记录 | 旧 smoke 经过可见 `InteractButton`、商店、小屋和相册相关路径，但大量移动仍用 `move_player_to_cell()`。在 V02.20 playgate 下功能保留，居住感证据退化，需改为行走 / 输入驱动。 |
| V02.2 小屋：买家具、进入小屋、摆放 / 旋转 / 挪动 / 收起、Sunny 反馈、持久化 | 保留 | `tests/test_v022_home_room_contract.gd`、`tests/test_life_services.gd`、`tests/test_playable_ui_operations.gd`、Round45 / Round48 记录 | 服务合同和可见 UI 操作均存在；作为功能路径保留。体验层仍可后续升级为直接拖放或房间内选择，但不阻断旧路径。 |
| V02.3 A-Z：靠近 anchor 按 `看看` 写入相册、新词故事绑定、相册显示 | 保留 | `tests/test_v023_memory_palace_world.gd`、`tests/test_memory_palace_embedding.gd`、`tests/test_memory_album_scene.gd`、LESSON-011 | Anchor 真实 `看看`、相册落账和故事绑定已有证据；V02.20 quiet badge 降噪后仍由 `tests/test_v0218_map_readability.gd` 保护可读性。 |
| V02.11 天气：多天气 day_key、天气问候、资源提示、商店轻变化、S/K/B/U 天气相册线索 | 保留 | `tests/test_v0211_weather_slice_smoke.gd`、`tests/test_v023_memory_palace_world.gd`、`docs/collaboration/Round72_V02.11_WEATHER-004_PM执行任务包.md` | 天气系统是生活氛围层，未强制登录或打卡；旧坐标回归已在 LESSON-011 后修复。后续总 smoke 应抽取至少一个天气线索。 |
| V02.14 Home-School：Home morning、Home-School Walk、School Gate、School Yard、Return / Shop bridge | 保留 | `tests/test_v0214_homeschool_slice.gd`、`docs/collaboration/Round78_V02.14_HOMESCHOOL-001_PM执行任务包.md`、`todo.md` V02-HOMESCHOOL-005 完成记录 | 路线仍是生活地点故事，不是课程页；真实 `看看` 路径和旧 P0 商店 / 小屋不阻断已有证据。 |
| V02.15 Home-School 日常：7 天 gate / yard / walk / return 差异和 Sunny return | 保留 | `tests/test_v0215_school_daily_slice.gd`、`docs/collaboration/Round80_V02.15_SCHOOLDAILY-001_PM执行任务包.md`、`todo.md` V02-SCHOOLDAILY-005 完成记录 | 7 天差异来自环境线索和 Sunny 反馈，符合生活回访；不应升级为课程或打卡。 |
| V02.10 P1：Story Bear / Bear Corner、Bus Helper / Taxi marker 轻回访、B/T 相册记录 | 保留 | `tests/test_v0210_p1_return_entries.gd`、`tests/test_daily_request_service.gd`、todo V02-P1RETURN-001..004 完成记录 | P1 支线不阻断 P0，且明确不赶车、不独自远行、不阅读测验；作为可选回访保留。后续总 smoke 可抽样，不应成为 5 分钟主路径硬依赖。 |
| V02.16 RC：可见文本安全、核心操作动线、相册 / 商店 / 小屋 / 设置路径 | 保留 | `tests/test_v0216_playable_rc_gate.gd`、`tests/test_playable_ui_operations.gd`、`docs/collaboration/Round83_V02.16_PRODUCTION-001_PM执行任务包.md` | RC gate 的儿童文本与可见入口扫描仍是 V02.20 playgate 的底线，应作为总 runner 保留。 |
| V02.17 26 Anchor runtime：26 个 anchor 可见布局、中心 / first ring / second ring / far edge、相册落账 | 保留 | `tests/test_v0217_worldmap_anchor_runtime.gd`、`docs/collaboration/Round86_V02.17_WORLDMAP-002_005运行时布局与验收记录.md`、LESSON-011 | 26 anchor 结构和 route_order 必须保留；V02.20 不重排 A-Z。热点优先级回归必须继续跑。 |
| V02.18 地图可读性：区域层级、anchor 物件、徽章、热点优先级、相册复核 | 保留 | `tests/test_v0218_map_readability.gd`、`docs/collaboration/Round88_V02.18_MAPREAD-002_005验收记录.md` | V02.20 已对 HUD 和 badge 降噪，且 Round100 同步了 quiet badge 口径；旧可读性路径保留。 |
| V02.19 art/map：1280 art baseline、production assets、glass UI、Town/Home/Shop/Album/Settings proof | 退化 | `docs/collaboration/Round99_V02.19_ARTPASS-010运行时视觉验收与发布候选记录.md`、Round95 / Round96 / Round99 记录、`tests/test_asset_resolver.gd`、`tests/test_v0218_map_readability.gd` | 资产接入和 1280 proof 保留，但 V02.19 明确不是 product complete，也不是 `approved`。作为 art baseline 保留，作为可发布 / 可居住完成证据退化。 |
| V02.20 首批 controls：连续行走、局部镜头、上下文 `看看` prompt | 保留 | `tests/test_v0220_playgate_controls.gd`、`docs/collaboration/Round100_V02.20_PLAYGATE-001_PM执行任务包.md` | 首批控制纵切已通过，但只覆盖 movement / camera / Mina prompt。它是新 smoke 的基础，不等同完整 5 分钟自由生活 smoke。 |
| Home / Shop 直接操作、NPC routine、资源 2.0、完整 3-5 分钟新 smoke | 待返修 | Round100 未完成范围、当前本文档规格 | 这些是 V02.20 可居住感缺口。旧路径能证明功能存在，但不能证明 Animal Crossing-like 日常手感已完成。 |

## 4. 阻塞与风险

- 完整 PLAYGATE-003 自动化尚未实现。当前已有 `tests/test_v0220_playgate_controls.gd` 和旧 V02.8 smoke，但还没有一个单独测试覆盖启动到 5 分钟自由生活全路径。
- 旧 V02.8 smoke 的移动证据退化。它使用 `move_player_to_cell()` 准备坐标，不能满足 V02.20 “行走不是瞬移、局部镜头跟随”的 playgate 口径。
- Home / Shop 仍以面板操作为主。功能保留，但居住感、直接操作和空间角色感需要后续返修。
- NPC routine 尚未进入当前证据矩阵。现有 NPC 更像静态可交互点，关系状态有保存但行为变化弱。
- 资源循环仍是静态日刷点。资源可收集、可持久化，但缺少可见刷新 / 已采状态变化 / 采集动效等居住感证据。
- 视觉 approved 不应由本矩阵自动给出。V02.19 是 1280 art baseline；PLAYGATE-008 仍需 PM / Art Direction 截图判断。

## 5. 后续测试实现建议

建议新增 focused test，但本轮不写测试代码：

- `tests/test_v0220_free_life_smoke.gd`
  - 覆盖本文第 2 节完整路径。
  - 使用可见按钮 `_press()` 和行走请求 / 输入模拟，不使用隐藏 contract 按钮。
  - 将 `move_player_to_cell()` 限制为测试初始化或旧兼容路径，不作为主动作证据。
  - 断言 `InteractionPrompt` 随 NPC、资源、商店、anchor 切换。
  - 断言存档变化包含 `player_cell`、`inventory`、`daily_requests` 或 `npc_relationships`、`home_state`、`card_states`。

- 扩展 `tests/headless_runner.gd`
  - 由主集成 agent 统一注册，避免 LESSON-006 的共享 runner 冲突。
  - 注册前先 `rg` 检查同名 preload / helper。

- 截图验收
  - 逻辑 smoke 使用 headless。
  - 1280 release-candidate 截图使用 MCP 或非 headless 显示驱动，交给 `V02-PLAYGATE-008` 判定。

## 6. 本轮结论

`V02-PLAYGATE-003` 已形成可执行规格：后续实现必须从孩子端真实可见入口覆盖移动、`看看`、NPC、资源、商店、小屋、Sunny、相册和设置，并明确排除隐藏 contract 按钮。

`V02-PLAYGATE-007` 已形成旧路径矩阵：V02.2 / V02.3 / V02.10 / V02.11 / V02.14 / V02.15 / V02.16 / V02.17 / V02.18 功能路径保留；V02.8 日常 smoke 和 V02.19 art/map 作为当前 playgate 证据退化；Home / Shop 直接操作、NPC routine、资源 2.0 和完整新 smoke 待返修。
