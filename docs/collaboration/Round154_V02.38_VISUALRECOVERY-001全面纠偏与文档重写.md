# Round154 V02.38 VISUALRECOVERY-001 全面纠偏与文档重写

> 日期：2026-06-07
> 任务：`V02-VISUALRECOVERY-001 全面纠偏与文档重写`
> 状态：已完成，验证通过
> 下一轮 Ready：`V02-VISUALRECOVERY-002 Modular Visual System 规格`

## 本轮判断

V02.37 在 Round153 第二批 story prop production 资产接入后暂停。当前最大风险不是内容不足，而是 runtime 仍依赖 `place.world_map.base_1280` / `world_map_base_1280.png` 作为整张主底图，遮盖了 tile / chunk / prefab / prop / actor 的统一美术系统缺失。

`docs/collaboration/artpass003_visual_direction/` 和 `docs/collaboration/Round92_V02.19_ARTPASS-003视觉方向确认包.md` 升级为当前视觉硬门槛：

- 世界视觉：Animal Crossing-like cozy town，但不复制外部 IP。
- UI 视觉：Apple-like translucent glass UI。
- A-Z 表达：prop-first 生活物件 / 地点装置 / 环境线索，字母 badge 只作辅助。
- 禁止方向：课程面板、词表墙、测试 / 打卡 / 分数、厚重卡片、绘本内页、裸字母牌和大面积单一色调。

## 当前状态语义

| 状态 | 含义 |
|---|---|
| `production` | 资产可集成，有 logical asset ID 和接入记录。 |
| `functional_pass` | 能玩、入口通、测试过，但不代表最终视觉。 |
| `visual_candidate` | 接近 artpass003，可进入人工视觉复核。 |
| `final_approved` | 同轮 1280 proof、真实入口、artpass003 贴近度和 PM / Art Direction 判定均通过。 |

Round119 历史 `approved` 从 V02.38 起只按 `functional_pass` 使用。任何视图要恢复 `final_approved`，必须通过 V02-VISUALRECOVERY-006。

## 本轮交付

- `docs/12_V02开发路线.md`：新增 V02.38 当前纠偏事实，暂停 V02.37 后续 Ready，写入 modular visual system 和状态语义。
- `docs/13_V02详细开发计划.md`：把当前执行入口改为 V02-VISUALRECOVERY-001，并新增 V02.38 任务队列。
- `docs/14_内容基线整理与首批内容规划.md`：冻结新增 story prop / A-Z 回访扩张，要求 Narrative 只服务 prop-first 视觉恢复。
- `docs/15_项目经理接管与下一阶段执行计划.md`：PM 接管计划切换为 V02.38，明确 full-map background 是当前最大风险。
- `todo.md`：当前状态面板、分工表和正式任务列表同步；`V02-STORYBATCH-004/005` 标为 `[!]`，新增 `V02-VISUALRECOVERY-001..006`。
- `lessons.md`：新增 `LESSON-014`，记录全图底图和宽松 approved 会掩盖模块化视觉系统缺失。

## 分组重新对齐

| 小组 | 当前职责 |
|---|---|
| PM / Art Direction / QA | 守住 V02.38 当前事实、状态语义和 final visual gate。 |
| Art Direction / Tech Art | 定义 terrain tile、region chunk、building prefab、prop-first anchor、actor、shadow 和 glass UI 统一规则。 |
| Asset | 后续只按 modular visual system 生产首屏统一资产包，不再单独堆 story prop。 |
| Godot | 后续将 TownStage 从 full-map background 主渲染迁移到 modular layers，保持旧可玩入口不退化。 |
| UX | HUD / footer / prompt / panel 从大白条和长文本转向轻 glass、图标优先、短文本辅助。 |
| Narrative / Memory Palace | 冻结内容扩张，只提供 prop-first 生活物件名、儿童短反馈和 A-Z 稳定绑定。 |
| QA | 验收从“入口存在 / 截图尺寸正确”升级为“是否更接近 artpass003、是否不依赖整图底图、是否能标 final_approved”。 |

## 后续 Ready

`V02-VISUALRECOVERY-002 Modular Visual System 规格`：

- 固定新增 ThemeProfile / AssetResolver 后续类别建议：`terrain_tile_assets`、`region_chunk_assets`、`building_prefab_assets`、`world_prop_assets`。
- 定义首屏最小资产包：Town Plaza、Home、Shop、School line 的 terrain、chunk、prefab、props、shadow 和 UI proof 点。
- 明确 `world_map_base_1280.png` 只作 reference，不作为 final runtime 主画面。

## 验收命令

```bash
rg -n "V02-STORYBATCH-004.*Ready|当前均为 approved|product complete" docs todo.md
rg -n "artpass003_visual_direction|Round92|final_approved|functional_pass|world_map_base_1280|full-map background" docs/12_V02开发路线.md docs/13_V02详细开发计划.md docs/14_内容基线整理与首批内容规划.md docs/15_项目经理接管与下一阶段执行计划.md todo.md
git diff --check
godot --headless --path . --quit
```

第一条 `rg` 允许命中历史追溯段落，但不得命中“当前 Ready 为 V02-STORYBATCH-004”或“当前均为 approved”的未纠偏口径。

## 验证结果

- 静态一致性复核已确认：当前状态文件中没有未纠偏的“`V02-STORYBATCH-004` 为当前 Ready”或“当前均为 approved”口径。
- `git diff --check` 通过。
- `godot --headless --path . --quit` 通过。
