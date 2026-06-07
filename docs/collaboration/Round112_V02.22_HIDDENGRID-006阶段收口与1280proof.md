# Round112 V02.22 HIDDENGRID-006 阶段收口与 1280 proof

> 日期：2026-06-06
> 对应任务：`V02-HIDDENGRID-006 3-5 分钟回归、1280 proof 和阶段收口`
> 结论：V02.22 可作为隐藏网格生活小镇与 scenes 组件化阶段收口；不标 product complete。

## 范围

- 收口 V02-HIDDENGRID-001 至 006。
- 证明 TownStage、Actor / Interactable prefab、TownHUD / TownFooter scene、户外装饰、资源 2.0 和 NPC routine fallback 不破坏旧玩家路径。
- 继续保留 1280x720 为当前阻塞性视觉验收口径；960x540 留到后续专项。

## 1280 Proof

截图目录：`docs/collaboration/round112_hiddengrid006_rc/`

| 画面 | Proof |
|---|---|
| Town / Stage split | `shot_round112_hiddengrid006_town_1280.png` |
| Outdoor decor | `shot_round112_hiddengrid006_outdoor_decor_1280.png` |
| Home | `shot_round112_hiddengrid006_home_1280.png` |
| Shop | `shot_round112_hiddengrid006_shop_1280.png` |
| Album | `shot_round112_hiddengrid006_album_1280.png` |
| Settings | `shot_round112_hiddengrid006_settings_1280.png` |

截图脚本：`tests/capture_hiddengrid006_rc.gd`

## PM / QA 判定

| 项目 | 判定 | 说明 |
|---|---|---|
| Scene split | `pass` | TownStage、actors、HUD / footer 已 scene 化，旧 facade 和真实入口保留。 |
| Hidden grid life systems | `pass` | 户外装饰、资源刷新摘要、NPC routine fallback 已可保存 / 回归。 |
| A-Z memory palace | `pass` | 未改 A-Z ID、route_order、核心坐标语义或相册路径。 |
| Child-facing text | `pass` | 本阶段未新增格子、坐标、调试、课程、测验、评分或倒计时可见文案。 |
| Product complete | `not_approved` | V02.22 是架构与隐藏网格生活系统阶段收口，不等同产品完成。 |

## 验证

```bash
godot --path . --script tests/capture_hiddengrid006_rc.gd
file docs/collaboration/round112_hiddengrid006_rc/*.png
godot --headless --path . --check-only --script tests/capture_hiddengrid006_rc.gd
godot --headless --path . --script tests/test_v0222_hiddengrid_final_smoke.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## 收口结论

`V02-HIDDENGRID-006` 完成后，V02.22 的六项任务可以收口。后续应继续基于 1280 proof 中仍存在的视觉与生活密度问题规划下一阶段，不把重构完成、production 素材或本轮 proof 误写为 product complete / approved。
