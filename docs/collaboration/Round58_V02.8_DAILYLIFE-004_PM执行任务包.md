# Round 58 V02.8 `DAILYLIFE-004` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-DAILYLIFE-003` 商店到小屋使用闭环已通过 focused/headless 验证。

## 本轮目标

让 `C Clock`、`O Orange`、`S Sun` 成为孩子日常散步中会自然回访的地点故事 / 相册发现，而不是单词测试、课程或背诵任务。

## Owner

Memory Palace / Narrative / Godot Dev Agent

## Scope

允许修改：

- `scripts/main.gd`
- `data/anchors/new_word_revisit_paths.json`
- `data/cards/az_core_cards.json`
- `tests/test_v023_memory_palace_world.gd`
- `tests/test_memory_palace_embedding.gd`
- `tests/test_life_rpg_scene.gd`
- `tests/headless_runner.gd`
- 相关协作文档和 `todo.md`

暂不修改：

- Bookshop / Bus Stop 新场景
- 更多 NPC、更多天气或节日系统
- 商店到小屋闭环，已由 `V02-DAILYLIFE-003` 收口
- 5 分钟端到端截图总验收，留给 `V02-DAILYLIFE-005`
- 真实 AI、联网、账号或云存档

## Inputs

- `todo.md`
- `docs/collaboration/Round57_V02.8_DAILYLIFE-003_PM执行任务包.md`
- `data/anchors/new_word_revisit_paths.json`
- `tests/test_v023_memory_palace_world.gd`
- `tests/test_memory_palace_embedding.gd`
- `lessons.md` 中 `LESSON-005`、`LESSON-009`

## Deliverables

- `C Clock`、`O Orange`、`S Sun` 三处 anchor 从孩子端真实 `看看` 路径触发。
- 三处触发后写入相册 / card state / 记忆状态中的至少一种可验证记录。
- 三处文本保持生活化地点故事或短句，不作为测验。
- 操作级测试覆盖真实入口，不只调用服务方法。

## Acceptance Criteria

- `C Clock`、`O Orange`、`S Sun` 位置和核心编码保持稳定。
- 三处均可通过当前主场景移动到附近并按 `看看` 触发。
- 触发结果包含地点故事、相册发现或温和生活短句。
- 不出现单词测验、课程、背诵、评分、倒计时或失败惩罚。
- 不依赖隐藏 contract 按钮、脚本直调或纯服务测试作为完成依据。
- 不破坏 Mina、店长、Sunny 日常入口、三条 P0 委托和商店到小屋闭环。

## Required Validation

```bash
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_v023_memory_palace_world.gd
godot --headless --path . --script tests/test_memory_palace_embedding.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

UI 改动后，继续沿用 `V02-ARTBASE-005` 的双视口截图要求。若本轮只强化操作级测试和已有 anchor 互动，可先用 headless 回归收口，截图放到 `V02-DAILYLIFE-005` 端到端纵切统一取证。

## Handoff Notes

完成后填写：

- 修改文件：
- 新增内容：
- 验证方式：
- 风险：
- 待确认问题：
