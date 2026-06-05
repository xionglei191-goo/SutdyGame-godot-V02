# Round 64 V02.10 `P1RETURN-001` PM 执行任务包

> 日期：2026-06-05  
> 当前事实来源：`todo.md`。  
> 进入条件：V02.9 一周回访节奏已完成，`V02-WEEKLY-004` 已通过 7 天 smoke 与代表截图。

## 本轮目标

建立 V02.10 P1 居民回访扩展路线，并把第一项可执行任务置为 Ready：让故事熊 / Bookshop、巴士哥哥 / Bus Stop 从“入口预收”进入真实可见入口实现准备。

本轮先做路线、范围、验收和分派，不直接扩大主流程。Bookshop / Bus Stop 仍是 P1 支线回访，不成为每日 P0 主路径硬依赖。

## Owner

PM / Game Design / UX / QA Agent

## Scope

允许修改：

- `docs/12_V02开发路线.md`
- `docs/13_V02详细开发计划.md`
- `docs/14_内容基线整理与首批内容规划.md`
- `docs/15_项目经理接管与下一阶段执行计划.md`
- `docs/collaboration/Round64_V02.10_P1RETURN-001_PM执行任务包.md`
- `todo.md`
- `lessons.md`（仅当出现已验证新教训）

暂不修改：

- Bookshop / Bus Stop 运行时代码
- `data/maps/world_map.json`
- `scripts/main.gd`
- `tests/headless_runner.gd`
- 真实天气系统、真实 AI、联网、账号或云存档

## Inputs

- `docs/collaboration/Round62_V02.9_WEEKLY-003_PM执行任务包.md`
- `docs/collaboration/Round63_V02.9_WEEKLY-004验收记录.md`
- `docs/14_内容基线整理与首批内容规划.md` 中 V02-WEEKLY-003 P1 入口预收、B Bear / T Taxi anchor 规划
- `LESSON-005`、`LESSON-008`、`LESSON-009`、`LESSON-010`

## Deliverables

- V02.10 阶段目标：P1 居民回访扩展，不扩完整全镇。
- 正式任务拆分：至少包含真实可见入口、两条 P1 轻回访、相册 / A-Z 记录、截图与 smoke 收口。
- 下一轮唯一 Ready：`V02-P1RETURN-001 Bookshop / Bus Stop 真实可见入口`。
- 每项任务的 Owner、依赖、交付物和验收标准。
- 明确安全边界：不出现阅读测验、赶车压力、陌生人带走、独自远行、倒计时或主线阻断。

## Acceptance Criteria

- `todo.md` 当前状态面板、本轮分工、正式任务列表和完成记录保持一致。
- `docs/12`、`docs/13`、`docs/14`、`docs/15` 的当前阶段口径一致，均指向 V02.10。
- 第一项 Ready 有清晰输入、输出、不可改范围和验证命令。
- 不把 Bookshop / Bus Stop 写成 P0 主流程硬依赖。
- 不新增运行时代码，因此只需要文档一致性检查、JSON 校验和 Godot headless 启动回归。

## Required Validation

```bash
rg -n "V02.10|V02-P1RETURN-001|P1 居民回访扩展|Bookshop / Bus Stop" docs/12_V02开发路线.md docs/13_V02详细开发计划.md docs/14_内容基线整理与首批内容规划.md docs/15_项目经理接管与下一阶段执行计划.md todo.md
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## Handoff Notes

完成后填写：

- 修改文件：
- 新增内容：
- 验证方式：
- 风险：
- 待确认问题：

