# Round181 V02.39 Mainline Remaining Tasks Closeout

> 日期：2026-06-08
> 范围：`V02-VISUALREBUILD-002`、`004`、`005`、`006`
> 状态：白盒目标与 runtime static-frame match 主线收口；不代表最终 bitmap 美术批准。

## 1. 结论

按用户要求，本轮停止继续扩展 proof-only asset warehouse，回到 V02.39 主线顺序：

`target 1280 frame -> visual layout contract -> unified asset kit -> runtime static-frame match -> gameplay binding -> art-direction gate`

Round180 的 Godot 白盒目标已推进为 `art_target_locked_whitebox_by_user_instruction`。该锁定范围只覆盖白盒构图、层级、比例、UI safe area、A-Z prop-first 和 runtime static-frame match；不把 Round169-Round179 proof-only 资产、已驳回 Round161 target、或 V02.39 generated scene-like PNG 样张升级为 final runtime art。

## 2. 交付物

| 任务 | 交付物 |
|---|---|
| `V02-VISUALREBUILD-002` | `docs/collaboration/round180_v0239_mainline_visual_layout_target/visual_layout_contract_v001.json`、`round180_v0239_visual_layout_target_1280x720_v001.png` |
| `V02-VISUALREBUILD-004` | `docs/collaboration/round181_v0239_mainline_closeout/unified_environment_composition_kit_v001.json` |
| `V02-VISUALREBUILD-005` | `docs/collaboration/round181_v0239_mainline_closeout/runtime_visual_match_report_v001.json`、`round181_v0239_runtime_match_side_by_side_1280x720_v001.png` |
| `V02-VISUALREBUILD-006` | `docs/collaboration/round181_v0239_mainline_closeout/art_direction_gate_v001.json` |

## 3. Gate

- `art_target_locked`: true, whitebox scope only.
- `runtime_visual_match`: true, based on `TownStage.get_visual_rebuild_blockout_snapshot()` and 1280 side-by-side evidence.
- `V02-STORYBATCH-004`: can return to Ready after this gate.
- `V02-STORYBATCH-005`: can return to Ready only after StoryBatch-004 runtime smoke / proof remains green.

## 4. Validation

```bash
godot --headless --path . --script tests/capture_round181_v0239_runtime_match_gate.gd
godot --headless --path . --script tests/test_v0239_visual_rebuild_mainline_gate.gd
godot --headless --path . --script tests/test_v0239_visual_layout_target.gd
godot --headless --path . --script tests/test_v0239_visual_rebuild_blockout.gd
godot --headless --path . --script tests/test_v0237_storybatch004_runtime_smoke.gd
timeout 180 godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
git diff --check
```

## 5. Boundaries

- 不接 `ThemeProfile` / `AssetResolver` 新映射。
- 不恢复 `world_map_base_1280.png` 作为 final runtime 主画面。
- 不显示 child-facing grid / cell / debug / editor wording。
- 不把 proof-only generated asset packs 视作 final approval evidence。
- 不处理 960x540 适配；当前仍以 1280x720 为 V02.39 gate。
