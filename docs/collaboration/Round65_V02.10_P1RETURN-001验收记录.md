# Round 65 `V02-P1RETURN-001` Bookshop / Bus Stop 真实可见入口验收记录

> 日期：2026-06-05  
> 范围：V02.10 P1 居民回访扩展第一项实现。  
> PM 结论：`pass`，`V02-P1RETURN-001` 可以标记完成，下一项 Ready 为 `V02-P1RETURN-002 故事熊 / 巴士哥哥 P1 轻回访`。

## 背景澄清

`docs/collaboration/Round64_V02.10_P1RETURN-001_PM执行任务包.md` 是路线与分派包，只负责把 `V02-P1RETURN-001` 置为 Ready，不允许改运行时代码。

本记录对应 Round 65 的实现与验收。Round 65 以 `todo.md` 当前状态和 `docs/14_内容基线整理与首批内容规划.md` 的 V02.10 任务拆分为事实来源，正式执行 `V02-P1RETURN-001`。

## 实现范围

- `data/maps/world_map.json` 新增四个 P1 可见 hotspot：
  - `p1_entry_story_bear_bookshop_door`
  - `p1_entry_story_bear_corner`
  - `p1_entry_bus_helper_stop_sign`
  - `p1_entry_bus_helper_taxi_marker`
- `scripts/main.gd` 新增 `look_p1_return_entry` 互动处理。
- 孩子端仍通过底栏真实可见 `看看` 按钮触发入口。
- 互动只保存 `p1_return_entries` 和显示温和反馈，不发金币、不打开真实出行、不打开阅读或学习流程。
- `tests/test_v0210_p1_return_entries.gd` 新增 focused 验证。
- `tests/headless_runner.gd` 注册同等回归覆盖。

## 验收覆盖

- 四个入口均能从主场景移动到对应格子后按可见 `看看` 触发。
- HUD 显示 Bookshop、Bear Corner、Bus Stop、Taxi marker 的温和反馈。
- `p1_return_entries` 保存入口 seen 状态、入口类型、居民 ID 和 A-Z anchor 关联。
- P0 商店和小屋路径仍可打开，不被 P1 入口阻断。
- 可见文本不出现阅读测验、考试、评分、背诵、倒计时、赶时间、陌生人带走、独自远行、上车或错过班车。

## 验证命令

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --check-only --script tests/test_v0210_p1_return_entries.gd
godot --headless --path . --script tests/test_v0210_p1_return_entries.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

以上命令已通过。

## PM 判断

- `V02-P1RETURN-001` 没有偏离 V02.10 主线：它是 P1 支线入口实现，不是 P0 主流程扩张。
- Bookshop / Bus Stop 未成为 Home、Shop、小屋、相册或一周 P0 日常的硬依赖。
- 后续不得把入口查看直接等同于支线完成；轻回访、相册 / A-Z 记录和截图 smoke 仍分别由 `V02-P1RETURN-002`、`003`、`004` 承担。
