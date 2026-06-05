# Round88 V02.18 MAPREAD-002-005 验收记录

> 日期：2026-06-05  
> 状态：已完成  
> 范围：`V02-MAPREAD-002` 至 `V02-MAPREAD-005`

## 审计结论

V02.18 在不改变 26 个核心 `anchor_id`、`letter`、`core_word`、`route_order` 和 `card_id` 的前提下，完成世界地图可读性抛光：26 anchor 都有运行时物件、可读字母徽章、地图分层元数据、可触发的真实 `看看` 路径和相册落账。

## 26 Anchor 截图基线

| 截图组 | Letters | 关注点 | 结论 |
|---|---|---|---|
| Home anchors | A/C/D/W | Home 线物件、回家路牌、徽章可读 | 已覆盖 |
| School line | E/G/K/N/R/Y | School / Walk / Yard 区域层次、学校不课程化 | 已覆盖 |
| First ring | B/F/H/I/J/O/T | 小镇支线、商店 / 书店 / 巴士边界 | 已覆盖 |
| Second ring | L/M/P/Q/S/U/V | 预览物件、天气 / 自然 / 声音回访 | 已覆盖 |
| Far edge | X/Z | 远郊边界提示、不进入 P0 | 已覆盖 |

## 运行时抛光

- 新增 `MapReadabilityLayer`，包含 Home / School、Town Ring 和 Far Edge 三组柔和区域底纹。
- 新增 `MapReadSignHome`、`MapReadSignSchool`、`MapReadSignTownRing`、`MapReadSignFarEdge` 四个短路牌，帮助孩子理解回家、学校、小镇圈和远处边界。
- Anchor 节点新增 `mapread_layer`、`mapread_screenshot_group` 和 `mapread_core_word` 元数据，供 QA 稳定审计。
- 字母徽章从 24px 提升到 28px，字体从 15 提升到 16，并加强边框对比；字母仍是辅助识别，生活物件仍是主视觉。
- `tests/test_v0218_map_readability.gd` 验证 26 anchor 的物件、徽章、分组、热点优先级、反馈短句和相册落账。
- `tests/headless_runner.gd` 已注册并实际执行 V02.18 可读性审计逻辑。

## 验收结果

- `godot --headless --path . --check-only --script scripts/main.gd`：通过。
- `godot --headless --path . --check-only --script tests/test_v0218_map_readability.gd`：通过。
- `godot --headless --path . --check-only --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --script tests/test_v0218_map_readability.gd`：通过。
- `godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd`：通过。
- `godot --headless --path . --script tests/headless_runner.gd`：通过。
- `godot --headless --path . --quit`：通过。

## 截图口径

本轮自动化已覆盖 26 anchor 分组、徽章尺寸、热点优先级、真实 `看看` 路径和儿童安全文本。实际 1280x720 / 960x540 视觉截图仍按既有规则使用 MCP 或非 headless 显示驱动取证，截图应覆盖 Home anchors、School line、First ring、Second ring、Far edge 和 Album 六组。

## 禁用范围复核

- 未新增课程页、单元页、测试、背诵、分数、正确率、完成率或字母打卡路线。
- 未改变 26 个核心 A-Z 编码。
- 未把 X/Z 远郊写入 P0、今日状态高频池或每日必到路线。
- 未绕过 `AssetResolver` 硬编码新素材路径。
