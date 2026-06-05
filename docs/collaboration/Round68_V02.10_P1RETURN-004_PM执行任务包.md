# Round 68 V02.10 P1RETURN-004 PM 执行任务包

> 日期：2026-06-05  
> Owner：QA / PM / Godot Dev Agent  
> 状态：Ready  
> 任务：`V02-P1RETURN-004 P1 回访 smoke 与截图`

## 任务目标

在 `V02-P1RETURN-001` 至 `003` 已完成的基础上，补齐 P1 居民回访的玩家路径 smoke 与截图证据，证明故事熊 / Bookshop、巴士哥哥 / Bus Stop 支线可玩、温和、可见，并且不会阻断 P0 每日生活路径。

## 输入

- `V02-P1RETURN-001`：Bookshop 门口、Bear Corner、Bus Stop 站牌、Taxi marker 四个真实可见 `看看` 入口。
- `V02-P1RETURN-002`：`daily_story_bear_find_bear_corner_001` 与 `daily_bus_helper_taxi_spot_001` 两条 P1 看一眼类轻回访。
- `V02-P1RETURN-003`：B Bear / T Taxi 入口查看与支线完成后写入 `card_b_bear_core` / `card_t_taxi_core` 的 card state 与小镇相册。
- `LESSON-009`：隐藏 contract 按钮不能证明孩子端可玩。
- `LESSON-010`：截图验收不要依赖 headless dummy renderer，优先用 MCP 或非 headless 显示路径。

## 交付物

- P1 支线玩家路径 smoke，覆盖故事熊与巴士哥哥两条 P1 路径。
- `tests/headless_runner.gd` 中的统一回归注册或已覆盖证据复核。
- 1280x720 与 960x540 代表截图，至少覆盖 Bookshop / Bear Corner 与 Bus Stop / Taxi marker。
- `todo.md` 完成记录与截图证据路径。

## 验收标准

- 玩家从当前孩子端真实可见 UI 出发，可以通过 `看看` 接取、查看入口、回 NPC 完成两条 P1 支线。
- B Bear / T Taxi 相册记录仍能在 P1 路径后显示为“已收藏”。
- P0 商店、小屋、Mina 日常路径不被 P1 支线阻断。
- 截图无明显遮挡、工程文案、课程化文案、正确率、等级、测试、倒计时、赶车压力、独自远行或陌生人带走暗示。
- 截图如果走自动脚本失败，必须记录工具链原因；不要把 headless dummy renderer 的空纹理当成布局失败。

## 建议执行顺序

1. 复核现有 `tests/test_v0210_p1_return_entries.gd`、`tests/test_v0210_p1_light_returns.gd` 与 `tests/headless_runner.gd` 是否已覆盖 smoke 需求。
2. 如覆盖不足，新增或扩展 P1 smoke，避免直接调用隐藏方法代替可见 `InteractButton`。
3. 使用 MCP 或非 headless `x11` 路径导出 1280x720 与 960x540 代表截图。
4. 更新截图验收记录、`todo.md` 完成记录和 `lessons.md` 轮次复盘。

## 不做范围

- 不新增完整出行系统、真实巴士乘坐、离镇路线或时间表。
- 不新增阅读测验、背诵、评分、正确率、等级或课程入口。
- 不把 P1 支线变成 P0 每日主流程硬依赖。
- 不重做 Bookshop / Bus Stop 美术资产，仅对当前可见路径做截图验收。
