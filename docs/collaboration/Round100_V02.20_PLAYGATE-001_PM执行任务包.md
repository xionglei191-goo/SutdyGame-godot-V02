# Round100 V02.20 PLAYGATE-001 PM 执行任务包

> 日期：2026-06-06
> 任务：`V02-PLAYGATE-001 V02.20 可居住小镇重建路线、任务队列和 Ready 规划`
> 状态：规划完成，并追加完成首批可玩手感纵切；下一轮唯一 Ready 为 `V02-PLAYGATE-002 首屏可居住小镇 QA 审计与缺口清单`

## 1. 阶段判断

V02.19 已完成 1280x720 production art baseline：地图底图、区域块、26 anchor 物件、首批 runtime 素材、glass UI 和 Round99 runtime proof 均已可作为美术接入基线。但 V02.19 只证明“资产已按 logical asset ID 接入并在 1280 proof 中可用”，不等同于产品完成、移动端完成或可发布完成。

V02.20 的目标是把当前 1280 art baseline 推进为“可居住小镇”playgate：孩子第一眼要看到能生活、能移动、能回访、能理解入口的 Sunshine Town，而不是只看到一张合格底图和若干可点击物件。本阶段仍不新增课程 UI、不扩远郊 P0、不重排 A-Z、不把 Letter Snake 重新变成主线。

## 2. 任务队列

| 顺序 | Task ID | Owner | 交付物 | 完成门槛 |
|---|---|---|---|---|
| 1 | V02-PLAYGATE-001 | PM / QA / Art Direction | V02.20 路线、任务队列、V02.19 收口口径和下一轮 Ready | `docs/12`、`docs/13`、`docs/15`、`todo.md` 同步；V02.19 明确为 1280 art baseline 而非 product complete |
| 2 | V02-PLAYGATE-002 | QA / UX / Art Direction | 首屏可居住小镇审计、截图缺口、玩家感知问题清单 | 只审计不改 runtime；列出 Town Plaza、Home、Shop、School line、Album、Settings 的阻塞 / 非阻塞问题 |
| 3 | V02-PLAYGATE-003 | UX / Godot / QA | 启动到 5 分钟自由生活 playgate smoke 规格和验证入口 | 覆盖移动、看看、NPC、资源、商店、小屋、Sunny、相册、设置；必须来自孩子端真实可见入口 |
| 4 | V02-PLAYGATE-004 | Map / UX / Art Direction / QA | 居民、资源、家具和 anchor 的空间分层返修方案 | 不改 A-Z ID / route_order；不让热点互相吞；P0 地点能一眼区分生活用途 |
| 5 | V02-PLAYGATE-005 | UI / UX / QA | HUD、底栏、弹层和相册的可读可触摸返修方案 | 1280x720 无遮挡、文字不溢出、关闭路径清楚；960x540 仍留到全量开发完成后专项适配 |
| 6 | V02-PLAYGATE-006 | Narrative / Child Safety / QA | 孩子端文本和生活反馈 playgate 审校 | 可见文本温暖、短句、生活化；无课程、测试、评分、打卡、倒计时、错过或工程文案 |
| 7 | V02-PLAYGATE-007 | QA / Godot | V02.8-V02.19 旧玩家路径回归矩阵 | 每条旧路径说明保留、退化或待返修；不得用隐藏 contract 入口代替真实入口 |
| 8 | V02-PLAYGATE-008 | Art Direction / PM / QA | 1280 release-candidate 截图包和 approved 判定 | 区分 `production` 与 `approved`；只在 PM / Art Direction 截图判断后批准 |
| 9 | V02-PLAYGATE-009 | PM / QA | V02.20 playgate 收口与下一阶段决策 | 明确是否进入内容扩展、移动适配专项或继续居住感返修；同步完成记录和 lessons 复核 |

## 3. 下一轮 Ready：V02-PLAYGATE-002

> Round100 附加实现记录：在 PM 队列建立后，本轮同步落地了首批 V02.20 运行时纵切，作为后续审计的真实基线，而不是替代 `V02-PLAYGATE-002` 审计。

已落地：

- `scripts/main.gd`：点击 / 键盘移动改为 `request_player_walk_to_cell()` 行走请求，`_process()` 多帧推进，到达后保存 `player_cell`；旧 `move_player_to_cell()` 保留给旧测试和迁移 helper。
- `scripts/main.gd`：地图从全图压缩改为局部街区镜头，`RuntimeMap` 跟随玩家并 clamp；地图点击会按当前镜头偏移反算回世界坐标。
- `scripts/main.gd`：新增 `InteractionPrompt` 和 `get_current_interaction_target()`，保留一个儿童端 `看看`，但显示当前 NPC / resource / anchor / place 目标。
- `scripts/main.gd`：HUD、背包文案和 A-Z `LetterBadge` 降噪，移除孩子端可见格子坐标。
- `tests/test_v0220_playgate_controls.gd`：新增 focused test，证明行走不是瞬移、镜头跟随、靠近 Mina 后提示解析为 NPC。
- `tests/headless_runner.gd`、`tests/test_v0218_map_readability.gd`：同步 V02.20 quiet badge 和 icon HUD 验收口径，并把 V02.20 controls focused test 注册进全量 runner。

验证已通过：

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --check-only --script tests/headless_runner.gd
godot --headless --path . --check-only --script tests/test_v0220_playgate_controls.gd
godot --headless --path . --script tests/test_v0220_playgate_controls.gd
godot --headless --path . --script tests/test_v0218_map_readability.gd
godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

未完成范围：Home / Shop 直接操作、NPC routine、资源 2.0 和完整 3-5 分钟新 smoke 仍按 `V02-PLAYGATE-002` 审计结果继续拆分推进。

输入：

- `todo.md`
- `docs/12_V02开发路线.md`
- `docs/13_V02详细开发计划.md`
- `docs/15_项目经理接管与下一阶段执行计划.md`
- `docs/collaboration/Round99_V02.19_ARTPASS-010运行时视觉验收与发布候选记录.md`
- `docs/collaboration/round99_runtime_visual_acceptance/`
- `LESSON-007`、`LESSON-009`、`LESSON-010`、`LESSON-011`

交付：

- 首屏和关键视图审计表，至少覆盖 Town Plaza、Home、Shop、School Gate、School Yard、Album、Settings。
- 可居住小镇判断：是否有可生活空间、清楚动线、居民存在感、资源 / 家具用途感、A-Z anchor 自然嵌入和儿童安全视觉。
- 缺口分级：阻塞 playgate、可后续优化、版本适配专项。
- 下一步实现任务建议，不直接改 runtime、数据、素材或测试。

验收：

- V02.19 不被写成 product complete；只作为 1280 art baseline 和接入证据。
- 审计必须基于现有 proof / 文档 / 台账，不凭空扩大玩法范围。
- 不新增课程 UI、测试、背诵、打卡、远郊 P0、真实联网或商业化任务。
- 只设置一个 Ready：`V02-PLAYGATE-002`。

## 4. 禁用范围

- `V02-PLAYGATE-002` 下一轮审计不编辑 runtime code、tests、assets 或 data。
- 不重排 26 个 A-Z anchor，不改变 `anchor_id`、`core_word`、`route_order`、坐标语义或相册语义。
- 不把 960x540 作为本阶段中间任务阻塞门槛；全部开发完成后再开版本适配专项。
- 不把 `production` 自动写成 `approved`。
