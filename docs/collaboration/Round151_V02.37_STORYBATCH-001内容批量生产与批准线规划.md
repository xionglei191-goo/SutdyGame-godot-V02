# Round151 V02.37 STORYBATCH-001 内容批量生产与批准线规划

日期：2026-06-07

## 目标

在 Round150 已经证明故事线、美术资产、动作操控和 A-Z 相册落账可以形成可玩纵切之后，建立 V02.37+ 的小批量故事内容生产与批准线。下一阶段不再重新规划 A-Z、不扩远郊 P0、不把 English 做成课程，而是把 story prop / story revisit / NPC context / resource context / asset approval 变成稳定、可重复、可验证的生产队列。

## 阶段结论

V02.29-V02.36 可阶段收口：故事总纲、当前地图适配、动作规格、操控规格、美术生产规格、接入规范、首批 production 资产、动作运行时纵切和故事整合纵切均已完成。

Round150 的四个 P0 story prop 是后续批量生产模板，但不代表所有 story prop 或 production 资产自动 approved。后续批准仍需要同轮 1280x720 runtime proof、真实入口 smoke、儿童安全文本复核和 PM / Art Direction 判定。

## V02.37 队列

| Task ID | Owner | 交付物 | 验收 |
|---|---|---|---|
| `V02-STORYBATCH-001` | PM / Narrative / Art Direction / QA | V02.37+ 内容批量生产路线、禁改边界、任务队列、批准线和下一项 Ready | docs 12-15、`todo.md` 和本任务包同步；本轮不改 runtime / data / tests / assets；下一轮 Ready 为 `V02-STORYBATCH-002` |
| `V02-STORYBATCH-002` | Narrative / Memory Palace / Art Direction / QA | 第二批 story prop / A-Z 回访内容包 | 优先覆盖 Round150 未覆盖字母；每条新词故事绑定 `core_anchor_id`、place、visual hook、review path、child feedback 和 asset need；不复用同一 `core_anchor_id` 造成覆盖风险 |
| `V02-STORYBATCH-003` | Asset / Tech Art / Godot / QA | 第二批 story prop production 资产与 AssetResolver / ThemeProfile / Map Editor marker 接入 | 资产有 logical asset ID、acceptance 状态、尺寸、用途和 runtime proof 点；`production` 不自动等同 `approved` |
| `V02-STORYBATCH-004` | Godot / Narrative / QA | 第二批 runtime 接入、真实入口 smoke 和相册落账 | 新内容从孩子端真实移动 / `看看` 路径触发；A-Z card state / story slice save record 可查；旧 P0 路径不退化 |
| `V02-STORYBATCH-005` | QA / PM / Art Direction | 1280 proof、asset approved 判定和阶段收口 | focused / full runner、JSON、diff check、Godot 启动和 1280 proof 通过；逐项记录 `production` / `approved` / `needs_fix` |

## 第二批建议范围

优先补 Round150 未覆盖的 P0 / first-ring anchor，避免继续堆 A/B/H/N/R/Y：

| 优先级 | Anchor / 地点 | 内容方向 | 生产类型 |
|---|---|---|---|
| P0 | C Clock / Home story wall | 回家墙角的时间 / 整理 / Sunny 轻反馈 | story prop + A-Z revisit |
| P0 | D Dog / Sunny yard toy | Sunny 院子玩具与照看反馈 | story prop + pet context |
| P0 | G Gate / School Gate | 校门生活标识和晨间短句 | story prop / asset refresh |
| P0 | K Kite / Home-School Walk | 风筝 / 叶子 / 微风回访 | story prop + weather context |
| P0 | O Orange / Shop window | 橱窗水果 / 店长短句 | story prop + shop context |
| P0 | S Sun / Town Plaza or School Yard | 阳光地面记号 / 轻天气线索 | story prop + album clue |
| P1 | E/F/L/M/P/Z Animal Park group | 动物公园标识组与第一圈预览 | asset-only or Map Editor candidate |
| P1 | U/X Coast Edge | 海边伞 / shell / X box preview | asset-only or optional story prop |

## 批准线

每个候选内容进入 `approved` 前必须满足：

- 有 stable logical asset ID，不硬编码图片路径。
- 有绑定的 `core_anchor_id`、`world_place_id`、`story_memory`、`visual_hook` 和 `review_path`。
- 孩子端真实入口可触发，不依赖隐藏 contract 按钮、脚本直调或编辑器入口。
- 文案短、温和、生活化；不出现课程、测试、背诵、打卡、分数、倒计时、错过、家长报告或工程术语。
- 通过 focused test、full headless runner、JSON 校验、`git diff --check` 和同轮 1280x720 runtime proof。
- PM / Art Direction 在同轮证据上逐项判定 `approved`，不得因资产已存在或 `production` 状态自动批准。

## 禁改边界

- 不重排 26 个 A-Z anchor，不改 `anchor_id`、`letter`、`core_word`、`route_order`、`card_id` 或 `audio_id`。
- 不把 School Gate / School Yard 做成课堂、测验、作业、迟到或分数空间。
- 不把 Bookshop、Bus Stop、Animal Park、Coast Edge、X/Z far edge 扩成 P0 必经路线。
- 不把 Letter Snake、Memory Card 或英语词条重新做成主循环门槛。
- 不把 Map Editor、格子、坐标、collision、footprint、debug 等术语暴露给孩子端 runtime。
- 不用手工 JSON 修改冒充 Map Editor 或 AssetResolver 接入证据。

## 下一轮 Ready

下一轮唯一 Ready：`V02-STORYBATCH-002 第二批 story prop / A-Z 回访内容包`。

开工输入：

- `docs/collaboration/Round150_V02.36_STORYSLICE-001故事线美术动作整合纵切.md`
- `docs/collaboration/Round142_V02.29_STORYLINE-002全量故事线总纲与章节骨架.md`
- `docs/collaboration/Round143_V02.30_STORYLINE-003当前地图适配与内容生产蓝图.md`
- `docs/collaboration/Round146_V02.33_ARTPIPE-001美术资产生产规格.md`
- `docs/collaboration/Round147_V02.34_ARTPIPE-002_MapEditor_ThemeProfile_AssetResolver接入规范.md`
- `data/life/story_props.json`
- `data/anchors/new_word_revisit_paths.json`
- `data/maps/world_map.json`

