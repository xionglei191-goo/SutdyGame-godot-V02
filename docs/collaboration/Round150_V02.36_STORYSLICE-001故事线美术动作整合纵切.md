# Round150 V02.36 STORYSLICE-001 故事线 + 美术 + 动作整合纵切

日期：2026-06-07

## 目标

在 Round142 / Round143 故事规划、Round148 首批 story prop production 资产和 Round149 动作操控运行时纵切之上，交付第一批 P0 故事可玩纵切：故事资产出现在 runtime，A-Z 回访落账到相册状态，NPC / resource / story object 形成温和联动，并保留隐藏网格和原有移动 / 交互规则。

## 交付

- `data/life/story_props.json` 补齐四个 P0 story prop 的孩子端反馈、环境词和 plaza book 的 `story_bear` / `branch` 轻联动字段。
- `TownStage` 新增 `StoryPropLayer`，在 runtime 渲染四个 story prop production 资产，使用 logical story prop asset ID，不硬编码项目贴图路径。
- `Main` 载入 story prop 数据，新增 `look_story_prop` 交互路径、prompt target、story slice save record、A-Z card state 落账和 `get_story_slice_snapshot()`。
- 首批可玩路径覆盖 Home apple photo、Town Plaza bear book branch、School Yard net / robot / yo-yo corner、Shop hat ribbon window。
- 首批 story prop 路径累计点亮 6 个 A-Z anchors：A Apple、B Bear、H Hat、N Net、R Robot、Y Yo-yo。
- Story Bench / Bear Book 记录保留 Story Bear NPC 和 branch resource context；不消耗资源、不强迫收集、不出现课程、测试、打卡或工程文案。
- 新增 `tests/test_v0236_storyslice001_runtime.gd`，并在 `tests/headless_runner.gd` 注册轻量 Round150 smoke。

## 验证

- `godot --headless --path . --check-only --script scripts/main.gd`
- `godot --headless --path . --check-only --script scripts/stages/town_stage.gd`
- `godot --headless --path . --check-only --script tests/test_v0236_storyslice001_runtime.gd`
- `godot --headless --path . --check-only --script tests/headless_runner.gd`
- `godot --headless --path . --script tests/test_v0236_storyslice001_runtime.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `find data -name '*.json' -print0 | xargs -0 jq empty`
- `git diff --check`
- Godot MCP main scene runtime proof：1280x720 viewport captured after pressing the real `看看` button at the Story Bench story prop.

## 边界

- 未重排、移动或覆盖 26 个 A-Z core anchors。
- 未把 English 改成课程、测验、背诵或主循环门槛。
- 未改变底层 hidden grid / pathing / collision / save 规则；story prop 互动叠加在既有 runtime priority 链上。
- 首批 Round148 production 资产仍不因文件存在自动标 approved；本轮只提供 runtime proof 证据。
