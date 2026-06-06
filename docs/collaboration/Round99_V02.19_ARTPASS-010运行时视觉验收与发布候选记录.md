# Round99 V02.19 ARTPASS-010 运行时视觉验收与发布候选记录

> 日期：2026-06-06
> 任务：`V02-ARTPASS-010 运行时视觉验收与发布候选整理`
> 结论：通过，V02.19 production art pass 可作为 1280x720 发布候选基线继续推进。

## 范围

- 只做运行时视觉验收和接入层小修。
- 不改 gameplay、地图坐标、A-Z anchor 稳定 ID / route_order、logical asset ID、资源采集、商店经济、小屋服务或相册数据合同。
- 视觉验收口径继续固定为 1280x720；960x540 等留到全部开发完成后的版本适配专项。

## 接入层修正

- `scripts/main.gd` 将旧 runtime 道路格从 20% 透明降到 5%，保留节点与测试合同，让 production 地图底图成为主视觉。
- 将旧花丛 / 树木辅助装饰降到 8%，减少覆盖在新底图上的半透明块感。
- 将 hotspot glow 降到 18%，保留可见交互暗示，不再大面积盖住 Shop / Animal Park / Coast Edge 区域。
- 将 anchor 物件恢复满不透明，同时保持 V02.18 要求的 28px / 16 字号字母徽章。
- `MemoryAlbumOverlay` 提升为高层级全屏 overlay，并在打开相册时暂时隐藏 `TownStage`，修复地图字母徽章穿透到相册卡片上的视觉问题。

## Runtime Proof

截图目录：`docs/collaboration/round99_runtime_visual_acceptance/`

| 画面 | Proof |
|---|---|
| Town Plaza / World Map | `shot_round99_town_plaza_denoised_1280.png` |
| Home | `shot_round99_home_denoised_1280.png` |
| Shop | `shot_round99_shop_denoised_1280.png` |
| Album | `shot_round99_album_denoised_1280.png` |
| Settings | `shot_round99_settings_denoised_1280.png` |

保留早期对比图：`shot_round99_town_plaza_1280.png`。

## 审查结论

- Town Plaza / World Map：production 底图铺满 1280x720，旧路格和辅助装饰已降噪；A-Z anchor 和角色 / 资源仍可见，无课堂、成绩、战斗或警报视觉。
- Home：小屋视图可打开，家具操作区和 Sunny 反馈不被 HUD / footer 遮挡；当前小屋仍是功能型可玩视图，不标最终美术 approved。
- Shop：商店面板使用 glass UI，商品列表可读，未出现强消费、倒计时、售罄或运营压力。
- Album：相册全屏清晰显示，地图字母徽章不再穿层，文本无课程 / 测试 / 背诵压力。
- Settings：设置面板 glass overlay 可读，关闭 / 声音 / 回安全位置 / 休息入口可见，不遮挡核心操作。
- Resource branch：Round98 已完成 `place.resource.branch` 96x96 透明 PNG 替换；本轮 runtime map 中资源点无突兀旧占位。

## 验证

已通过：

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_asset_resolver.gd
godot --headless --path . --script tests/test_v0218_map_readability.gd
godot --headless --path . --script tests/test_v0217_worldmap_anchor_runtime.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_v0216_playable_rc_gate.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
ps -ef | rg 'godot --headless --path \. --script tests/' || true
```

残留 headless 测试进程：无。

## Lessons

本轮发现并修复了相册 overlay 层级穿透和生产底图上旧辅助层过重的问题；问题均在本轮内通过接入层微调解决，未形成新的已验证教训。`lessons.md` 仅补 Round99 复盘行。
