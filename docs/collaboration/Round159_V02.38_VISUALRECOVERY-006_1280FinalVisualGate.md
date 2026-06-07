# Round159 V02.38 VISUALRECOVERY-006 1280 Final Visual Gate

> 日期：2026-06-07
> 任务：`V02-VISUALRECOVERY-006 1280 Final Visual Gate`
> 当前状态：父级验证完成， lane 结果为 `visual_candidate`
> 写入范围：QA / gate lane 文档；父级集成另行同步 runtime、tests、assets、data、`todo.md`、docs 12-15 和 `lessons.md`。

## Gate 目标

本 gate 只负责定义 V02.38 最终视觉批准口径。任何视图要从旧阶段 `functional_pass` 或本阶段 `visual_candidate` 升级为 `final_approved`，必须同时满足同轮 1280 proof、孩子端真实入口 smoke、artpass003 贴近度、full-map background 缺席、A-Z prop-first、HUD / actor 降噪和儿童安全文本复核。

Round119 及更早的 `approved` 在本轮只作为 `functional_pass` 历史证据，不得自动继承为 `final_approved`。

## 状态语义

| 状态 | 可授予条件 | 不代表 |
|---|---|---|
| `production` | 资产或实现可被项目接入，有 stable logical asset ID / provenance / 接入记录。 | 不代表能玩、不代表视觉通过、不代表孩子端可见。 |
| `functional_pass` | 真实入口、基础交互、保存 / 回归 / headless smoke 成立。 | 不代表接近 artpass003，不代表最终视觉批准。 |
| `visual_candidate` | 同轮 proof 显示方向接近 artpass003，且没有明显 full-map background、裸字母牌、大白条或角色比例噪声。 | 不代表已由 PM / Art Direction 最终批准。 |
| `final_approved` | 同轮 1280 proof、真实入口 smoke、artpass003 贴近度、儿童安全文本、full-map background 缺席、A-Z prop-first、HUD / actor 降噪和 PM / Art Direction 复核全部通过。 | 不得由旧 proof、单项测试、架构完成或 `production` 状态自动升级。 |

## Final Gate Checklist

| Gate 项 | 必须提交的父级证据 | 通过标准 | 失败即保持 | 当前结果 |
|---|---|---|---|---|
| 1280 proof | `1280x720` 同轮 runtime PNG proof；至少覆盖 Town Plaza / Home / Shop / School line / Album or UI panel / Settings or HUD state。 | 每张 proof 尺寸为 `1280 x 720`；画面可读，无明显遮挡、拉伸、空白、debug overlay 或文字溢出。 | `functional_pass` 或 `visual_candidate` | 通过：5 张 `1280x720` proof 已导出到 `docs/collaboration/round159_visual_recovery_gate/`。 |
| Real-entry smoke | 从孩子端真实入口触发的 smoke 记录；不能只调用 service 或直接打开内部 panel。 | 启动、移动、`看看`、NPC / resource、Shop、Home、Album / UI、Settings / safe path 至少覆盖一条完整生活路径。 | `functional_pass` | 通过：`tests/test_v0238_visual_recovery_runtime.gd` 覆盖 Home / Shop / School line 真实 `看看` 入口，full runner 通过。 |
| artpass003 closeness | 对照 `docs/collaboration/artpass003_visual_direction/` 三张方向样张和 Round92 规则的人工复核记录。 | 读感为 cozy town、轻 2.5D、圆润生活物件、Apple-like translucent glass UI；不回到课程页、绘本页、单色厚卡片或工程占位。 | `visual_candidate` 以下 | 通过到 `visual_candidate`：已脱离整图底图，形成 modular 层级；仍保留淡化旧 place context 和功能性 HomeRoom，不授予 `final_approved`。 |
| Child-safety text | 可见文本扫描和人工抽查记录。 | 无课程、作业、测试、分数、排名、打卡、倒计时、家长报告、debug、grid、cell、坐标、格子、占格、强消费、独自远行压力或恐吓文案。 | `functional_pass` | 通过：focused / full runner 与人工 proof 抽查未发现禁用文本。 |
| Full-map background absence | TownStage / ThemeProfile / AssetResolver / runtime proof 的父级复核。 | `place.world_map.base_1280` / `world_map_base_1280.png` 只能作为 reference；final runtime 主画面必须由 modular layers 组成，不以整张地图底图承载最终观感。 | `functional_pass` | 通过：`TownStage` 不创建 legacy `Ground`，snapshot 证明 `uses_full_map_background == false`；base 资产 acceptance 已标 `reference_only`。 |
| A-Z prop-first | 26 个 A-Z anchor 的视觉和可见入口抽查。 | Anchor 首先表现为生活物件、地点装置或环境线索；字母 badge 只作辅助，不能成为裸字母牌、打卡牌或课程目标。 | `visual_candidate` 以下 | 通过到 `visual_candidate`：A-Z 常驻、badge alpha <= 0.5；首屏新增 apple / clock / Sunny prop-first 资产，完整 26 prop 迁移留后续扩展。 |
| HUD / actor denoise | HUD、footer、prompt、player、Sunny、NPC、resource、anchor 同屏 proof。 | HUD / footer 是轻 glass 和图标优先；prompt 不压住地图；player / Sunny / NPC 比例统一；热点、badge、阴影和 actor 层级清楚。 | `visual_candidate` 以下 | 通过到 `visual_candidate`：glass HUD / footer、prompt glow、tap ripple、actor shadows 和 non-prefab place marker alpha 上限成立；仍需后续 final art polish。 |
| Status semantics | 本文、父级验收记录和后续 `todo.md` 更新前的状态复核。 | 只允许 `production`、`functional_pass`、`visual_candidate`、`final_approved` 四类语义；旧 `approved` 必须说明为历史 `functional_pass`，不得混用。 | 不得收口 | 通过：本轮只授予 `visual_candidate`，不继承旧 `approved`，不声称 `final_approved`。 |

## 逐项判定

父级已完成同轮验证；本文件不授予 `final_approved`。

| 视图 / 区域 | 1280 proof | 真实入口 smoke | artpass003 贴近度 | 儿童安全文本 | full-map background 缺席 | A-Z prop-first | HUD / actor 降噪 | 建议状态 | 父级结果 |
|---|---|---|---|---|---|---|---|---|---|
| Town Plaza / World Map | 通过：`shot_round159_visualrecovery_town_modular_1280.png` | 通过：启动 / 移动 / `看看` | 候选：modular 地面 + chunk + prefab 成立，淡化旧 context 仍可见 | 通过 | 通过 | 候选：badge 辅助化，新增 prop-first A/C/Home props | 通过到候选 | `visual_candidate` | `visual_candidate` |
| Home | 通过：`shot_round159_visualrecovery_home_entry_1280.png` | 通过：Home 真实入口 | 候选：HomeRoom 功能可读但仍非 final art interior | 通过 | 通过 | 不适用 / 保持 A-Z 记录 | 通过到候选 | `visual_candidate` | `visual_candidate` |
| Shop | 通过：`shot_round159_visualrecovery_shop_entry_1280.png` | 通过：Shop 真实入口 | 候选：glass panel 可读，背景 modular | 通过 | 通过 | 不退化 | 通过到候选 | `visual_candidate` | `visual_candidate` |
| School line | 通过：`shot_round159_visualrecovery_school_gate_1280.png` | 通过：School Gate 真实 `看看` | 候选：school line chunk / gate prefab 成立，仍需后续 polish | 通过 | 通过 | 通过到候选 | 通过到候选 | `visual_candidate` | `visual_candidate` |
| Album / UI panel | 由 Shop / Home / Settings panel 代表覆盖 | full runner 覆盖 album / UI 旧路径 | 候选 | 通过 | 通过 | 不退化 | 通过到候选 | `visual_candidate` | `visual_candidate` |
| Settings / HUD state | 通过：`shot_round159_visualrecovery_settings_hud_1280.png` | 通过：Settings / safe path | 候选：glass 设置 panel 可读 | 通过 | 通过 | 不退化 | 通过到候选 | `visual_candidate` | `visual_candidate` |

## Validation Commands

父级验证命令和结果如下。

| Command | Purpose | Result |
|---|---|---|
| `git diff --check` | Static whitespace / patch sanity. | Pass |
| `jq empty data/themes/theme_sunshine_town_placeholder.json` | Theme JSON validity. | Pass |
| `godot --headless --path . --script tests/test_asset_resolver.gd` | ThemeProfile / AssetResolver V02.38 mapping and reference-only base map. | Pass |
| `godot --headless --path . --script tests/test_town_stage_layered_runtime.gd` | TownStage modular layers and no legacy Ground sprite. | Pass |
| `godot --headless --path . --script tests/test_v0238_visual_recovery_runtime.gd` | V02.38 real-entry Home / Shop / School smoke. | Pass |
| `godot --headless --path . --script tests/test_v0218_map_readability.gd` | A-Z readability and old exploration regression. | Pass |
| `godot --headless --path . --script tests/headless_runner.gd` | Full functional regression before status promotion. | Pass |
| `godot --headless --path . --quit` | Project boot sanity. | Pass |
| `godot --headless --path . --check-only --script tests/capture_v0238_visual_recovery_gate.gd` | Capture script syntax / load check. | Pass |
| `godot --path . --display-driver x11 --resolution 1280x720 --script tests/capture_v0238_visual_recovery_gate.gd` | Non-headless 1280 runtime proof capture, following LESSON-010. | Pass; 5 PNGs regenerated. |
| `file docs/collaboration/round159_visual_recovery_gate/*.png` / `identify ...` | Confirm every proof PNG is `1280 x 720`. | Pass; all five PNGs are `1280x720`. |

## Parent Validation Result

| 项目 | 结果 |
|---|---|
| Gate owner | PM / Art Direction / UX / QA |
| Current lane result | `visual_candidate` |
| `final_approved` | Not granted in Round159; requires a later polish pass or explicit human PM / Art Direction approval after reviewing remaining legacy context and HomeRoom final-art gaps. |
| Story batch unblock rule | V02.38 no-full-map runtime blocker is cleared for future story batch planning, but any future approved判定 must still use `production` / `functional_pass` / `visual_candidate` / `final_approved` semantics. |
| Runtime / test changes in this file | Document records parent validation results; runtime / tests are tracked in the main diff. |

## Closeout Note

Round159 closes the V02.38 recovery lane as a modular `visual_candidate`: runtime no longer depends on `world_map_base_1280.png` as final ground, first-screen modular assets are mapped through logical IDs, Home / Shop / School real-entry smoke passes, and 1280 proof exists. It does not claim `final_approved`.
