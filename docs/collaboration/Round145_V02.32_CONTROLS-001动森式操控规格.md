# Round145 V02.32 CONTROLS-001 Animal Crossing-like 操控规格

> 日期：2026-06-07
> 任务：`V02-CONTROLS-001 Animal Crossing-like 操控规格`
> 状态：完成
> 下一轮 Ready：`V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格`

## 本轮范围

本轮只输出操控规格，不改 runtime、不新增输入 UI、不生成资产。规格目标是让后续 Godot 实现能把当前“点击目标 cell 后沿路径移动”的系统推进成更接近 Animal Crossing-like 的慢生活操控：玩家感知上是连续走路、自然转向、镜头柔和跟随、靠近物件自动出现 `看看` prompt；底层仍保留 `world_map` cell / collision / interaction / resource / NPC routine / A-Z anchor 作为稳定事实来源，但孩子端不显示格子、坐标、占格、debug 或编辑器术语。

## 当前架构事实

| 项目 | 当前事实 | 规格影响 |
|---|---|---|
| 地图输入 | `TownStage.map_cell_requested(cell)` 和 `_on_town_stage_cell_requested()` 支持 tap-to-cell | tap-to-move 可保留，但后续应支持点按地面后的路径预览 / 取消规则 |
| 键盘输入 | `_unhandled_key_input()` 里方向键 / WASD 触发 `move_player_by_cells()` | 当前是单步 cell request；后续应改成按住连续 intent |
| 连续显示 | `_advance_player_walk(delta)` 用 `move_toward()` 更新 `player_world_position` | 可保留显示连续性，但要加入加减速、转向和 motion intent |
| 寻路 | `_build_walk_path()` 先走 x 再走 y，遇阻直接失败 | P0 可保留简单路径，V02.35 实现时需补“短距离绕路 / 失败反馈”规格 |
| 镜头 | `TownStage.update_camera_for_player()` 直接 clamp 到玩家中心 | 后续应平滑跟随，避免点击远点时镜头抽动 |
| Prompt | `get_current_interaction_target()` 已覆盖 NPC / resource / anchor / place 优先级 | 操控规格要固定 prompt 的稳定半径、锁定、遮挡和输入冲突 |
| 动作规格 | Round144 已固定 4 向动作、8 向预留和 logical animation ID | 操控必须输出统一 `motion_intent` 给动画，不让键盘 / 触控各自驱动 |

## 体验目标

| 目标 | 玩家感知 | 工程边界 |
|---|---|---|
| 慢走生活感 | 角色像在小镇散步，不是棋子瞬移 | 底层仍可保存 cell，显示层连续 |
| 方向自然 | 按住方向时持续走，松手轻停 | 输入 intent 与 path request 分离 |
| Tap-to-move 温柔 | 点地面后角色慢慢走过去，点新位置可改目标 | 不显示路径线、格子或坐标 |
| Prompt 稳定 | 靠近 NPC / 资源 / anchor / place 自动显示一个清楚目标 | prompt 不闪烁、不被远处热点抢走 |
| 镜头跟随 | 镜头追随玩家但不突然跳 | camera smoothing 和边界 clamp |
| 动画可接 | 任何输入都能给 Round144 动作状态机同一套方向 / moving 状态 | 统一 `ControlIntent` / `MotionIntent` 数据 |

## 输入模式

| 输入 | P0 规则 | P1 预留 |
|---|---|---|
| Tap-to-move | 点击可走位置，生成短路径并慢走；点击不可走位置给温和反馈 | 点住地面持续朝该方向走；长距离路径分段 |
| Keyboard / WASD | 按住方向连续移动 intent；松开 decelerate 到停止 | 斜向输入、手柄左摇杆 |
| Virtual joystick | 左下角隐形 / 半透明 joystick，拖动输出方向和强度 | 自适应大拇指区域、触控无障碍 |
| Gamepad | 左摇杆移动，A / Cross 触发 `看看` | 右摇杆无需求；肩键不进入 P0 |
| Mouse / desktop | 点击地图移动，键盘可覆盖点击移动 | hover 不作为孩子端必需入口 |

输入优先级：

1. Modal / panel 打开时，地图移动输入暂停；关闭 panel 后恢复。
2. Keyboard / joystick 按住时取消当前 tap-to-move path。
3. Tap-to-move 新目标会替换旧 path，不把旧 path 排队。
4. `看看` 按钮触发时，移动 intent 暂停 0.25-0.4 秒，播放 interact / greet。
5. 到达 interaction target 附近后不自动触发动作，只显示 prompt，必须由可见 `看看` 入口触发。

## Motion Intent 合同

后续实现建议在 `Main` 内部生成统一 motion intent，而不是让每个输入入口直接改 actor：

```gdscript
{
	"source": "keyboard" | "tap" | "joystick" | "gamepad",
	"move_vector": Vector2.ZERO,
	"target_cell": Vector2i(-1, -1),
	"strength": 0.0,
	"is_moving": false,
	"is_tap_path": false,
	"facing": Vector2i(0, 1),
	"interaction_lock_seconds": 0.0
}
```

规则：

- `move_vector` 是显示层方向，不能直接显示给孩子。
- `target_cell` 只给内部寻路 / 保存 / prompt 使用。
- `strength < 0.25` 视为停止输入；joystick / gamepad 支持 0.25-1.0。
- 方向折算：P0 输出 4 向；如果 `abs(x) > abs(y)` 则 left / right，否则 up / down；8 向留给 P1。
- `facing` 必须在停止后保留，供 idle / interact 动画使用。

## 移动手感参数

| 参数 | P0 建议值 | 说明 |
|---|---:|---|
| `walk_speed` | 120-150 px/s | 当前为 150 px/s，可先保留；虚拟摇杆低强度降到 80 px/s |
| `acceleration` | 600 px/s² | 起步 0.2 秒内进入慢走 |
| `deceleration` | 700 px/s² | 松手后 0.18-0.25 秒内停住 |
| `turn_snap_threshold` | 0.35 | 方向变化明显才转向，避免抖动 |
| `arrival_radius` | 2 px | 到目标中心 2 px 以内吸附 |
| `blocked_feedback_cooldown` | 0.45 s | 不可走反馈不能每帧刷屏 |
| `interact_lock` | 0.35 s | `看看` 动作期间暂停移动 |
| `tap_max_path_cells_p0` | 18 cells | 太远目标分段或给温和反馈 |

P0 可以继续使用当前 `_build_walk_path()` 的轴向路径，但操控体验上要满足：

- 每个路径段之间不能停顿超过 1 帧。
- 中途收到新输入时，旧路径立即取消。
- 如果目标不可走，角色不移动，反馈使用生活化短句。
- 如果路径中途被 blocked，停在最后安全点并刷新 prompt。

## 隐藏网格规则

底层允许继续使用 cell：

- collision_cells：阻挡移动。
- interaction_cells：可触发 place / story prop / home / shop。
- resource_points：资源目标。
- NPC routine cell：NPC 站位和 prompt 目标。
- memory_anchors：A-Z anchor 稳定位置。

孩子端禁止显示：

- grid、cell、tile、坐标、占格、footprint、collision、debug、editor、authoring。
- 路径线、目标 cell 高亮、寻路失败代码。
- “你不能走到 x,y” 这类技术反馈。

允许显示：

- 柔和脚步 / 小光点 / 轻微地面反馈，但不能像任务箭头。
- `看看 米娜`、`看看 Apple corner`、`捡起小树枝` 这类生活化 prompt。
- 地点到达短句，比如“来到 School Yard，操场角落可以慢慢看看。”

## Prompt 稳定规则

Prompt 是操控手感的一部分，优先级必须稳定：

| 优先级 | 类型 | 触发规则 | 说明 |
|---:|---|---|---|
| 1 | exact place / story prop interaction | 玩家所在 cell 或 facing 前方 cell 有 interaction | 门口、Story Bench、Shop front 等优先 |
| 2 | NPC | 距离 <= 2 cells，且未被 exact interaction 覆盖 | Mina / Shopkeeper / Sunny / Story Bear |
| 3 | resource | 距离 <= 1.5 cells | branch / flower / leaf / ribbon / pinecone / shell |
| 4 | A-Z anchor | 距离 <= 1.5 cells | 只显示生活物件，不强调学习任务 |
| 5 | nearby place | 距离 <= 2 cells | 到达感和地点看看 |

稳定性要求：

- 当前 prompt 锁定 0.25 秒，除非更高优先级目标进入 exact cell。
- 移动中 prompt 可以更新，但文字不应每帧闪烁。
- `看看` 触发目标必须与当前可见 prompt 一致。
- NPC / resource / anchor 重叠时，按优先级，不随机。
- UI panel 打开时 prompt 隐藏或冻结，不响应地图输入。

## 镜头规格

当前镜头直接将玩家置于局部视野中心并 clamp。后续 V02.35 建议：

| 参数 | P0 建议 |
|---|---:|
| camera smoothing | 8-12 lerp speed 或 0.12s smooth time |
| look-ahead | 移动方向 24-36 px |
| edge clamp | 保留当前地图边界 clamp |
| panel open behavior | panel 打开时镜头冻结，不追随隐藏移动 |
| tap target behavior | 镜头跟玩家，不提前跳向目标 |

镜头 proof：

- Home -> School Gate 连续走动时，玩家不被 HUD / footer 遮挡。
- Shop Street 横向走动时，镜头不抖、不越界。
- Coast Edge / far edge 只作边界预览，不突然露出空地图。

## 动画联动

操控层必须向 Round144 动作规格输出：

| 操控状态 | 动画状态 |
|---|---|
| `current_speed <= 2` | `idle.<facing>` |
| `current_speed > 2` | `walk.<direction>` |
| 方向变化 | P0 直接切方向；P1 播 `turn` |
| prompt triggered | player `interact.<facing>`；target NPC / Sunny `greet` |
| Sunny follow | Sunny `follow` 或 `walk` |

任何输入模式都只通过 motion intent 改动画，不直接调用不同 actor 分支。

## V02.35 实现拆分建议

| 子任务 | 内容 | 验收 |
|---|---|---|
| `RUNTIME-CONTROL-001` | 新增 motion intent 和输入仲裁 | keyboard / tap / panel lock 行为一致 |
| `RUNTIME-CONTROL-002` | 按住键盘连续移动，支持加减速 | 不再每次 keydown 只走一格 |
| `RUNTIME-CONTROL-003` | tap-to-move 替换目标 / 取消 / 失败反馈 | 点击新位置立即改目标，不排队 |
| `RUNTIME-CONTROL-004` | prompt 锁定与优先级稳定 | NPC / resource / anchor / place 不闪烁 |
| `RUNTIME-CONTROL-005` | camera smoothing / look-ahead | 1280 proof 无抽动和遮挡 |
| `RUNTIME-CONTROL-006` | virtual joystick prototype | 移动端可拖动慢走，不显示格子 |
| `RUNTIME-CONTROL-007` | controls + animation integration | 输出 motion state，standing fallback 不退化 |

## QA 与 Proof 口径

Focused tests：

- 按住 keyboard intent 60 帧，player position 连续变化，`player_cell` 只在跨 cell 或到达时更新。
- tap 新目标覆盖旧目标，不排队。
- panel 打开时地图输入无效。
- blocked target 返回温和反馈，不能刷屏。
- prompt 在 Mina / branch / anchor / Shop front 重叠场景下按优先级稳定。
- camera position 使用 smoothing 后仍 clamp 在地图边界。

1280 proof：

| Proof ID | 路线 | 必须证明 |
|---|---|---|
| `controls_proof_home_walk_school_1280` | Home -> Home-School Walk -> School Gate | 连续走路、镜头跟随、School prompt |
| `controls_proof_shop_prompt_1280` | Shop Street -> Ribbon Corner | Shopkeeper / ribbon / shop front prompt 稳定 |
| `controls_proof_story_bench_1280` | Town Plaza -> Story Bench | Story Bear / branch / Story Bench 优先级 |
| `controls_proof_panel_lock_1280` | 打开 Shop / Album / Settings | panel 打开时地图不误触 |
| `controls_proof_mobile_joystick_1280` | 虚拟摇杆原型 | 拖动区域可达，HUD/footer 不遮挡 |

## 禁改边界

- 不重排 A-Z anchor，不改 `anchor_id` / `letter` / `core_word` / `route_order`。
- 不让操控实现绕过现有 save / resource / NPC / album 合同。
- 不把 School 做成课程流程，不把 prompt 写成任务打卡。
- 不新增孩子端可见的格子、坐标、debug、editor 术语。
- 不为了手感重写所有 `TownStage` / UI panel；V02.35 应小步接入。

## 交付给后续任务的输入

`V02-ARTPIPE-001`：

- 地面 tile、edge、road 和 story prop 需要支持连续走动时的脚底读感。
- Prompt / collect / album badge 需要有轻反馈资产，但不能变成任务 UI。
- Mobile joystick 需要 UI skin / touch affordance backlog。

`V02-RUNTIME-ANIM-001`：

- 使用 motion intent 作为移动、动画、镜头和 prompt 的统一输入。
- 先实现 keyboard hold + tap replace + prompt lock + camera smoothing，再接 virtual joystick。
- 1280 proof 与 focused movement sampling 必须同时通过。

## 验收结论

- 连续移动、速度曲线、转向 / 停止：通过。
- 镜头跟随、look-ahead、edge clamp：通过。
- 靠近 prompt 优先级、锁定和 panel lock：通过。
- 虚拟摇杆、tap-to-move、键盘 / 手柄输入策略：通过。
- 隐藏网格规则和孩子端禁用术语：通过。
- 可拆分为后续 Godot 实现任务：通过。
- 不改 runtime、data、tests、assets，不新增输入 UI：通过。

下一轮 Ready：`V02-ARTPIPE-001 Tile map / 场景 / 故事资产生产规格`。
