# Round 56 V02.8 `DAILYLIFE-002` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-DAILYLIFE-001` 三 NPC 日常入口已通过 focused/headless 验证。

## 本轮目标

把 Mina、店长、Sunny 的日常入口推进成三条 P0 轻委托可玩路径：孩子从真实可见入口接取小事，完成对应行动，获得温和反馈和本地保存记录。

## Owner

Godot Dev / Game Design / QA Agent

## Scope

允许修改：

- `scripts/main.gd`
- `data/life/daily_requests.json`
- `tests/test_life_rpg_scene.gd`
- `tests/test_playable_ui_operations.gd`
- `tests/headless_runner.gd`
- 相关协作文档和 `todo.md`

暂不修改：

- Bookshop / Bus Stop 新场景
- 更多 NPC、更多天气或节日系统
- 商店到小屋完整购买摆放闭环，留给 `V02-DAILYLIFE-003`
- `C/O/S` 三地点回访强化，留给 `V02-DAILYLIFE-004`
- 真实 AI、联网、账号或云存档

## Inputs

- `todo.md`
- `docs/collaboration/Round55_V02.8_DAILYLIFE-001_PM执行任务包.md`
- `data/life/daily_requests.json`
- `tests/test_life_rpg_scene.gd`
- `tests/test_playable_ui_operations.gd`
- `lessons.md` 中 `LESSON-009`

## Deliverables

- 三条 P0 轻委托从孩子端真实入口接取、行动和完成。
- 三条委托的奖励、关系、同日去重和保存重载验证。
- 操作级测试覆盖可见路径，不只调用服务方法。
- 若沿用现有内容 ID，必须在交付说明中记录与路线命名的映射关系。

## Acceptance Criteria

- Mina 轻委托可从 Mina 的 `看看` 入口接取，并通过收集 / 交付路径完成。
- 店长轻委托可从店长的 `看看` 入口接取，并通过当前已存在的地图资源或最小生活动作完成。
- Sunny 轻委托可从 Sunny 的 `看看` 入口接取，并通过当前已存在的地图资源或小屋内温和动作完成。
- 三条委托均验证接取、进度反馈、完成反馈、奖励、同日去重、保存重载。
- 不依赖隐藏 contract 按钮、脚本直调或纯服务测试作为完成依据。
- 文本短、温和、生活化，不出现考试、评分、课程、背诵、羞辱、倒计时或强消费压力。
- 不破坏 `C/O/S` anchor 位置、A-Z 路线顺序和新词故事绑定。

## PM 命名口径

路线里写的 P0 目标名是：

- `daily_mina_branch_walk_001`
- `daily_shopkeeper_tiny_home_item_001`
- `daily_sunny_room_tidy_001`

当前数据中已经存在的相近内容包括：

- `daily_mina_branch_001`
- `daily_shopkeeper_flower_001`
- `daily_sunny_flower_001`

本轮允许小组二选一：

- 保留现有 ID，但在交付说明和测试中明确它们就是三条 P0 轻委托的实现映射。
- 新增 / 重命名为路线 ID，但必须同步所有引用、测试和内容合同，避免破坏既有 V02.1-V02.4 回归。

## Required Validation

```bash
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

UI 改动后，继续沿用 `V02-ARTBASE-005` 的双视口截图要求。若本轮只改逻辑和操作级测试，可先用 headless 回归收口，截图放到 `V02-DAILYLIFE-005` 端到端纵切统一取证。

## Handoff Notes

完成后填写：

- 修改文件：
- 新增内容：
- 验证方式：
- 风险：
- 待确认问题：
