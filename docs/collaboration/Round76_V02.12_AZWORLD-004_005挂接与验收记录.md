# Round 76 V02.12 AZWORLD-004 / 005 挂接与验收记录

> 日期：2026-06-05  
> 任务：`V02-AZWORLD-004 Home / School 0 基础主线挂接位`、`V02-AZWORLD-005 合同测试、回归验证和截图验收口径`  
> 状态：验收通过  
> 事实数据：`data/maps/az_world_plan.json`

## 0 基础挂接结论

首批 0 基础词 / 短句已进入 `foundation_story_hooks`，全部绑定生活场景、主 A-Z anchor、孩子端温和表达、回访路径和安全说明。孩子端不显示课程、单元、测试、背诵或词表。

| tag | phrase_or_word | scene | anchor | 孩子端表达 |
|---|---|---|---|---|
| `home` | home | `place_home` | `anchor_a_apple` | 从家门口慢慢出发。 |
| `family` | family | `place_home` | `anchor_a_apple` | 家里的照片在等你回来。 |
| `room` | room | `place_home_watch_table` | `anchor_w_watch` | 小屋角落今天也很温暖。 |
| `clock` | clock | `place_home_watch_table` | `anchor_c_clock` | 圆钟说今天慢慢开始。 |
| `dog` | dog | `place_home_sunny_corner` | `anchor_d_dog` | Sunny 在家里摇尾巴。 |
| `bag` | bag | `place_home_school_walk` | `anchor_g_gate` | 小包包陪你走到校门。 |
| `school` | school | `place_school_gate` | `anchor_g_gate` | 学校门口的小旗亮起来。 |
| `gate` | gate | `place_school_gate` | `anchor_g_gate` | 校门的小铃铛轻轻响。 |
| `play` | play | `place_school_yard` | `anchor_k_kite` | 风筝在操场上挥手。 |
| `look` | look | `place_school_yard` | `anchor_k_kite` | 看一眼，记在相册里。 |
| `go` | go | `place_home_school_walk` | `anchor_g_gate` | 我们慢慢走过去。 |
| `good_morning` | good morning | `place_school_gate` | `anchor_c_clock` | 早上好，今天也慢慢来。 |

## 截图验收口径

`screenshot_acceptance` 已定义 5 个后续实现截图点：

- `shot_v0212_home_morning`：Home、Clock、Dog、Room 生活物件。
- `shot_v0212_home_school_walk`：Home-School Walk 安全路线和 Bag / Go / Look 语义。
- `shot_v0212_school_gate`：School Gate、Gate、Good morning 和安全入口。
- `shot_v0212_school_yard`：School Yard、Play、Kite、Elephant 等学校生活锚点。
- `shot_v0212_far_edge_reserve`：X / Z 远郊只作为预留边界和相册世界感。

每个截图点都要求 1280x720 和 960x540。截图取证走 MCP 或非 headless 显示路径；headless 只作为合同和逻辑回归。

## 验收证据

- `scripts/data/az_world_plan_contract.gd` 已验证 `foundation_story_hooks` 覆盖 `family/home/room/clock/dog/bag/school/gate/play/look/go/good_morning`。
- 合同会拦截缺失 anchor、缺失 scene、缺失孩子端表达、缺失回访路径和压力词。
- `tests/test_v0212_az_world_plan.gd` 覆盖 0 基础挂接、截图验收点和坏数据拒绝。
- `tests/headless_runner.gd` 已注册 `_check_v0212_az_world_plan()`。

## V02.12 阶段收口条件

- `V02-AZWORLD-001` 至 `V02-AZWORLD-005` 均有交付物和验收记录。
- `az_world_plan` 覆盖 Home / School 双中心、四层环线、26 anchor、17 个 reserved anchor 规格、0 基础挂接和截图口径。
- JSON、focused test、A-Z core、memory palace、headless runner 和 Godot headless 启动通过。
- 后续运行时实现不得把英语重新变成课程、测试、背诵、词表或主流程门槛。
