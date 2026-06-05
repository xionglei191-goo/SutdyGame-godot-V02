# Round 57 V02.8 `DAILYLIFE-003` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-DAILYLIFE-002` 三条 P0 轻委托可玩化已通过 focused/headless 验证。

## 本轮目标

把商店、背包、小屋和 Sunny 反馈串成一段孩子端连续生活路径：看商品 / 购买小物 -> 背包或 HUD 更新 -> 回小屋摆放、移动或收起 -> Sunny 给出温和反馈。

## Owner

Godot Dev / Economy / Home Design Agent

## Scope

允许修改：

- `scripts/main.gd`
- `data/items/life_items.json`
- `tests/test_playable_ui_operations.gd`
- `tests/test_life_rpg_scene.gd`
- `tests/test_v022_home_room_contract.gd`
- `tests/headless_runner.gd`
- 相关协作文档和 `todo.md`

暂不修改：

- Bookshop / Bus Stop 新场景
- 更多 NPC、更多天气或节日系统
- `C/O/S` 三地点回访强化，留给 `V02-DAILYLIFE-004`
- 5 分钟端到端截图总验收，留给 `V02-DAILYLIFE-005`
- 真实 AI、联网、账号或云存档

## Inputs

- `todo.md`
- `docs/collaboration/Round56_V02.8_DAILYLIFE-002_PM执行任务包.md`
- `tests/test_playable_ui_operations.gd`
- `tests/test_life_rpg_scene.gd`
- `tests/test_v022_home_room_contract.gd`
- `lessons.md` 中 `LESSON-009`

## Deliverables

- 至少 1 件家具或生活小物从可见商店入口购买。
- 购买后背包或 HUD 能立即反映变化。
- 小屋中能从可见入口摆放、移动或收起该物品，并持久保存。
- Sunny 在小屋中给出可见、温和、儿童友好的反馈。
- 操作级测试覆盖真实可见路径，不只调用服务方法。

## Acceptance Criteria

- 商店入口必须通过孩子端当前可见 UI 或 `看看` 打开。
- 至少 1 件商品可通过可见按钮购买，金币扣减、背包 / HUD 更新均可验证。
- 回到小屋后，可通过可见按钮摆放、移动或收起已购买物品。
- 重载或重新读取服务状态后，家具位置 / 背包变化仍保留。
- Sunny 反馈可见、生活化、无学习压力，不出现考试、评分、课程、背诵、倒计时或强消费压力。
- 不依赖隐藏 contract 按钮、脚本直调或纯服务测试作为完成依据。
- 不破坏 `C/O/S` anchor 位置、A-Z 路线顺序和新词故事绑定。

## Required Validation

```bash
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/test_v022_home_room_contract.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

UI 改动后，继续沿用 `V02-ARTBASE-005` 的双视口截图要求。若本轮只强化操作级测试和已有 UI 反馈，可先用 headless 回归收口，截图放到 `V02-DAILYLIFE-005` 端到端纵切统一取证。

## Handoff Notes

完成后填写：

- 修改文件：
- 新增内容：
- 验证方式：
- 风险：
- 待确认问题：
