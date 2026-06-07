# Round106 V02.21 LIVEGATE-005 1280 RC 截图包与二次 approved 判定

> 日期：2026-06-06
> 对应任务：`V02-LIVEGATE-005 1280 RC 截图包与二次 approved 判定`
> 结论：同轮 1280x720 runtime proof 已产出；`Album` 可标 V02.21 playgate approved，其余六项保留 `needs_fix`，不把 `production` 或旧轮次 art baseline 误写为 product approved。

## 范围

- 只做 V02.21 当前 runtime 的 1280x720 截图取证和 PM / Art Direction / QA 二次判定。
- 不新增课程 UI、不扩远郊 P0、不重排 A-Z 编码、不进入 960x540 专项。
- 960x540 继续留到全部开发完成后的版本适配专项，不作为本轮阻塞门槛。

## 证据目录

截图目录：`docs/collaboration/round106_livegate005_rc/`

| 画面 | Proof |
|---|---|
| Town Plaza / World Map | `shot_round106_livegate005_town_plaza_1280.png` |
| Home | `shot_round106_livegate005_home_1280.png` |
| Shop | `shot_round106_livegate005_shop_1280.png` |
| School Gate | `shot_round106_livegate005_school_gate_1280.png` |
| School Yard | `shot_round106_livegate005_school_yard_1280.png` |
| Album | `shot_round106_livegate005_album_1280.png` |
| Settings | `shot_round106_livegate005_settings_1280.png` |

截图脚本：`tests/capture_livegate005_rc.gd`

```bash
godot --path . --script tests/capture_livegate005_rc.gd
file docs/collaboration/round106_livegate005_rc/*.png
```

`file` 已确认七张 PNG 均为 `1280 x 720`。

## 二次判定

| 画面 | 判定 | 原因 |
|---|---|---|
| Town Plaza / World Map | `needs_fix` | 小镇底图和散步感成立，真实入口和底栏可见；但 A-Z anchor、NPC、资源和底部提示仍偏拥挤，局部可读性不足，不能标 product / playgate approved。 |
| Home | `needs_fix` | 已比 Round99 更有居住感，具备窗、阳光、墙面小物、门垫、宠物角、家具状态和 Sunny 反馈；但整体仍偏稀疏摆放板，大面积空白和装饰密度不足，暂不标 approved。 |
| Shop | `needs_fix` | 商店用途、商品购买和关闭路径可见；但 glass panel 在复杂地图上透明度偏高，底部 HUD / 字母标记与商店 UI 仍有视觉碰撞。 |
| School Gate | `needs_fix` | 已有同轮到达 proof，地点反馈温和，无测试 / 评分 / 倒计时；但画面拥挤，顶部长句和 School line anchor 叠加后可读性不足。 |
| School Yard | `needs_fix` | 操场 / 活动角语义可见，无课程测试压力；但 anchor 密度、顶部长句和底部提示仍让画面偏噪，需更清晰的生活地点呈现。 |
| Album | `approved` | 全屏 overlay 清晰，地图元素不穿层，卡片和关闭路径可读；英语只作为收藏 / 故事氛围，不形成 drilling 或课程评价。 |
| Settings | `needs_fix` | 设置用途和休息 / 安全位置等路径可见；但 translucent panel 压在复杂地图和 anchor 标签上，Apple-like glass 可读性不足，控件仍显漂浮。 |

## 对照输入

- `docs/collaboration/Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md`
- `docs/collaboration/Round101_V02.20_PLAYGATE-002首屏可居住小镇QA审计与缺口清单.md`
- `docs/collaboration/Round101_V02.20_PLAYGATE-003_007自由生活smoke规格与旧路径回归矩阵.md`
- `docs/collaboration/Round101_V02.20_PLAYGATE-009收口与下一阶段决策.md`
- `docs/collaboration/Round99_V02.19_ARTPASS-010运行时视觉验收与发布候选记录.md`
- `docs/collaboration/Round92_V02.19_ARTPASS-003视觉方向确认包.md`

## 自动化验证

已通过：

```bash
godot --path . --script tests/capture_livegate005_rc.gd
godot --headless --path . --check-only --script tests/capture_livegate005_rc.gd
godot --headless --path . --script tests/test_v0221_livegate_free_life_smoke.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## 收口结论

`V02-LIVEGATE-005` 的交付物已经成立：同轮 1280 RC proof 存在，七项均有明确 approved / needs_fix 判定，且没有把 `production` 或旧轮次截图证据误写为 V02.21 product approved。

V02.21 LIVEGATE-001 至 005 均可收口；后续若继续推进，应基于本轮六项 `needs_fix` 新建下一阶段任务，而不是继续扩大 V02-LIVEGATE-005 的完成定义。
