# Round 55 V02.8 `DAILYLIFE-001` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：`V02-ARTBASE-005` 双视口截图验收已通过。

## 本轮目标

让 Mina、店长、Sunny 的日常入口从“已有基础互动”升级为 V02.8 的三 NPC 纵切起点：孩子从真实可见入口靠近居民、按 `看看`，能获得生活化问候或轻委托提示。

## Owner

Godot Dev / Narrative / QA Agent

## Scope

允许修改：

- `scripts/main.gd`
- `data/life/daily_requests.json`
- `data/npcs/*/profile.json`
- `tests/test_life_rpg_scene.gd`
- `tests/test_playable_ui_operations.gd`
- `tests/headless_runner.gd`
- 相关协作文档和 `todo.md`

暂不修改：

- Bookshop / Bus Stop 新场景
- 更多 NPC
- 复杂天气或节日系统
- 真实 AI、联网、账号或云存档

## Deliverables

- Mina、店长、Sunny 三个孩子端可见入口的交互路径说明。
- 三位 NPC 的短问候或轻委托入口文本，保持生活化、无学习压力。
- 操作级测试：从玩家可见路径移动到三位 NPC 并按 `看看` 触发。
- V02.8 后续 `DAILYLIFE-002` 至 `005` 的接口不被提前锁死。

## Acceptance Criteria

- 三位 NPC 都能从当前孩子端主场景靠近并用 `看看` 触发。
- 不依赖隐藏 contract 按钮、脚本直调或仅服务级测试作为完成依据。
- 文本短、温和、生活化；不出现考试、评分、课程、背诵、羞辱或强消费压力。
- 互动结果能写入本地关系 / 最近事件 / 当日状态中的至少一种可验证记录。
- 不破坏 `C/O/S` anchor 位置、A-Z 路线顺序和新词故事绑定。

## Required Validation

```bash
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

UI 改动后，继续沿用 `V02-ARTBASE-005` 的双视口截图要求。
