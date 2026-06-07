# Round144 V02.31 MOTION-001 行走动画与角色动作规格

> 日期：2026-06-07
> 任务：`V02-MOTION-001 行走动画与角色动作规格`
> 状态：完成
> 下一轮 Ready：`V02-CONTROLS-001 Animal Crossing-like 操控规格`

## 本轮范围

本轮只输出动画与接入规格，不生成正式动画资产、不改 runtime、不改正式 JSON。规格必须贴合当前 Godot 架构：`scripts/main.gd` 已用隐藏网格生成路径，用 `player_world_position.move_toward()` 做连续世界坐标移动；`TownStage` 负责渲染和镜头；`PlayerActor` / `NPCActor` 当前是 `Node2D + Sprite2D` 拼装，还没有 `AnimatedSprite2D`、`SpriteFrames` 或 `AnimationPlayer`。

因此 V02.31 的目标不是立刻实现动画，而是让美术团队和 Godot 运行时都能按同一份合同推进：

- 美术团队能生产 player / NPC / Sunny 的首批 4 向基础动作 sprite sheet。
- Godot 后续能通过 logical animation ID 接入，不硬编码具体文件路径。
- 旧 standing PNG 保留为 fallback，不阻断当前孩子端可玩路径。
- 动作服务于生活 RPG 体验，不把格子、坐标、调试、学习闯关或 Letter Snake 重新放回主流程。

## 当前架构事实

| 项目 | 当前事实 | 对动作规格的影响 |
|---|---|---|
| 移动源 | `Main.request_player_walk_to_cell()` 生成 path，`_advance_player_walk(delta)` 逐帧移动 | 动画状态应由 moving / facing / interaction intent 驱动 |
| 速度 | `PLAYER_WALK_SPEED = 150.0`，当前每步按 cell center 过渡 | walk loop 需要支持 150 px/s 的慢走读感 |
| 方向 | `player_facing: Vector2i` 已存在，当前由下一步 cell delta 更新 | 4 向可立即落地；8 向仅预留命名和 sheet 空间 |
| 渲染 | `TownStage.update_player_marker(player_world_position)` 设置 PlayerActor 位置并跟镜头 | actor 内部只负责动画帧、朝向、局部偏移，不负责寻路 |
| Actor scene | `scenes/world/actors/player_actor.tscn`、`npc_actor.tscn` 是 Sprite2D 拼装 | 后续可升级为 `AnimatedSprite2D` 或局部 `AnimationPlayer`，但保留同名 actor scene |
| AssetResolver | 当前有 `character_assets` / `pet_assets` standing 图 | 新增 animation 类别时应保留 standing fallback |
| NPC routine | `npc_routines.json` 给 daily cell 和 label，但 NPC 当前不连续走动 | 本规格定义 NPC idle / greet / short_walk，后续 runtime 可先播放 idle / greet，再接 short walk |

## 动作优先级

| 优先级 | 角色 | 动作范围 | 原因 |
|---|---|---|---|
| P0 | Player | idle / walk / turn / interact | 支撑 Home -> Walk -> School -> Shop -> Story Bench 连续移动读感 |
| P0 | Sunny / `pet_buddy` | idle / walk / wag / greet / follow / rest | Sunny 是 Home 与陪伴感核心，优先于复杂 NPC 表演 |
| P0 | Mina | idle / greet / short_walk / point | 第一周 Home / Plaza / School path 的温柔引导角色 |
| P0 | Shopkeeper | idle / greet / tidy / short_walk | Shop Street 和 Ribbon Corner 的生活动作 |
| P0 | Story Bear | idle / greet / read / short_walk | Story Bench / branch bookmark 的故事动作 |
| P1 | Bus Helper | idle / greet / sign_check | Plaza edge / Taxi / Coast 安全边界氛围 |
| P1 | Animal Park ambient characters | idle only | 先作为场景资产，不进入 P0 动作纵切 |

## 状态机总则

动作状态必须由运行时状态派生，不要求美术知道隐藏网格：

| Runtime 输入 | 动作状态 | 说明 |
|---|---|---|
| `is_walking == false` 且无交互 | `idle_<direction>` | 呼吸 / 轻摆动循环 |
| `is_walking == true` | `walk_<direction>` | 方向来自移动向量或 `player_facing` |
| 方向变化但未移动超过阈值 | `turn_<from>_to_<to>` 或直接切 idle | P0 可直接切，P1 再补 turn 帧 |
| 触发 `看看` / NPC 对话 / 资源拾取 | `interact_<direction>` | 0.35-0.5 秒一次性动作，然后回 idle |
| NPC 被靠近或对话 | `greet_<direction>` | 轻挥手、点头、尾巴摇，不做强反馈 |
| Sunny 跟随玩家 | `follow_<direction>` | 复用 walk loop，尾巴 wag 可叠加 |
| NPC routine 短距离移动 | `short_walk_<direction>` | 后续可由 routine cell 变化驱动，不阻塞 P0 |

方向命名：

- 4 向必须：`down`、`left`、`right`、`up`。
- 8 向预留：`down_left`、`down_right`、`up_left`、`up_right`。
- P0 运行时若只有 4 向，斜向输入按主轴或上一 facing 折算；美术 sheet 先可不交付 8 向帧。

## Player 动作规格

| Animation ID | 必须 | 帧数 | FPS | Loop | 用途 |
|---|---|---:|---:|---|---|
| `anim.player.idle.down` | 是 | 4 | 6 | yes | 默认站立、面向屏幕 |
| `anim.player.idle.left` | 是 | 4 | 6 | yes | 停止后面向左 |
| `anim.player.idle.right` | 是 | 4 | 6 | yes | 停止后面向右 |
| `anim.player.idle.up` | 是 | 4 | 6 | yes | 面向上方 |
| `anim.player.walk.down` | 是 | 8 | 10 | yes | 慢走，步幅小 |
| `anim.player.walk.left` | 是 | 8 | 10 | yes | 左向慢走 |
| `anim.player.walk.right` | 是 | 8 | 10 | yes | 右向慢走，可镜像左向但 sheet 仍需独立 ID |
| `anim.player.walk.up` | 是 | 8 | 10 | yes | 上向慢走 |
| `anim.player.interact.down` | 是 | 4 | 10 | no | 看看 / 捡起 / 点头 |
| `anim.player.interact.left` | 是 | 4 | 10 | no | 左向互动 |
| `anim.player.interact.right` | 是 | 4 | 10 | no | 右向互动 |
| `anim.player.interact.up` | 是 | 4 | 10 | no | 上向互动 |
| `anim.player.turn.*` | 预留 | 2-3 | 12 | no | P1 平滑转向 |

Player 视觉要求：

- 站立高度建议 48 px 以内，当前 runtime 显示约 `34x43`，P0 sheet frame 建议 `64x64`，给头发、背包和阴影留边。
- pivot / origin：脚底中心，frame 坐标建议 `(32, 52)`；角色脚底落在 cell center 附近。
- shadow 不建议烘进角色 sheet；继续由 actor scene 或单独 `shadow` sprite 管理，避免换角色时阴影乱跳。
- walk cycle 应该像慢慢散步，不做跑步、冲刺、跳跃或胜利动作。
- interact 动作只表达轻伸手 / 点头 / 看看，不做答题、打卡、奖励展示或夸张成功动作。

## Sunny 动作规格

Sunny 对应当前 `npc_id = pet_buddy`，ThemeProfile 里已有 `pet.sunny.standing`。后续应改用 pet animation logical IDs，standing 图保留 fallback。

| Animation ID | 必须 | 帧数 | FPS | Loop | 用途 |
|---|---|---:|---:|---|---|
| `anim.pet.sunny.idle.down` | 是 | 6 | 6 | yes | Home 门边、Sunny 休息 |
| `anim.pet.sunny.idle.left` | 是 | 6 | 6 | yes | 侧向等待 |
| `anim.pet.sunny.idle.right` | 是 | 6 | 6 | yes | 侧向等待 |
| `anim.pet.sunny.idle.up` | 是 | 6 | 6 | yes | 跟随或看物件 |
| `anim.pet.sunny.walk.*` | 是 | 8 | 10 | yes | 慢慢跟随 |
| `anim.pet.sunny.wag.down` | 是 | 6 | 8 | yes | 开心但不过度兴奋 |
| `anim.pet.sunny.greet.*` | 是 | 4 | 8 | no | 玩家回家、互动问候 |
| `anim.pet.sunny.follow.*` | 预留 | 8 | 10 | yes | 可复用 walk，但独立 ID |
| `anim.pet.sunny.rest.down` | 预留 | 6 | 5 | yes | Sunny 小床 / 阳光地 |

Sunny 视觉要求：

- frame 建议 `64x48`，pivot 脚底 / 身体底部中心 `(32, 40)`。
- 尾巴 wag 可在同一 sheet 中完成；P1 可拆 tail overlay。
- 不做饥饿、哭泣、警告、失败或责备动作。
- Home / Sun patch / pet bowl 场景优先，复杂表演推迟。

## NPC 动作规格

NPC 首批覆盖 Mina、Shopkeeper、Story Bear。Bus Helper 作为 P1。当前 `NPCActor` 使用 body / head / ears / face dots 拼装，后续动画可整图替换，也可逐层动画；P0 建议整图 sheet，降低接入风险。

| NPC | P0 Animation ID 前缀 | 必须动作 | 角色个性 |
|---|---|---|---|
| Mina | `anim.npc.mina.*` | idle 4 向、greet 4 向、short_walk 4 向、point/down-left 预留 | 轻挥手、看花、慢慢指向小路 |
| Shopkeeper | `anim.npc.shopkeeper.*` | idle 4 向、greet 4 向、tidy.down/left/right、short_walk 4 向 | 整理小篮子、点头欢迎 |
| Story Bear | `anim.npc.story_bear.*` | idle 4 向、greet 4 向、read.down、short_walk 4 向 | 抱书、翻页、轻点头 |
| Bus Helper | `anim.npc.bus_helper.*` | idle 4 向、greet 4 向、sign_check.down/left/right | 擦小车牌、指路但不引导独自远行 |

NPC 通用帧规则：

- idle：4-6 帧，6 FPS，loop。
- greet：4 帧，8 FPS，non-loop。
- short_walk：8 帧，8-10 FPS，loop。
- special idle：4-8 帧，6 FPS，loop 或短循环。
- frame 建议 `64x64`，Story Bear 可用 `80x72`，但 pivot 仍必须脚底中心。
- NPC 不做“任务完成欢呼”“失败摇头”“催促”等压力动作。

## Sprite Sheet 与文件命名

推荐 P0 使用统一 horizontal strip 或 atlas grid。每个动作可一张 strip，也可一个角色一张 atlas，但必须提供 machine-readable metadata。

| 项 | 规格 |
|---|---|
| 色彩 / 风格 | 延续 Round92 / Round95 cozy town、温暖生活化、无强警告色 |
| 透明背景 | 必须 PNG alpha |
| 单帧尺寸 | Player / NPC `64x64`；Sunny `64x48`；Story Bear 可 `80x72` |
| pivot | 写入 metadata；没有 metadata 时默认脚底中心 |
| spacing / margin | 建议 0；若有必须写入 metadata |
| 方向顺序 | `down,left,right,up`；8 向预留追加 `down_left,down_right,up_left,up_right` |
| 动作顺序 | `idle,walk,interact/greet,special` |
| 文件命名 | `char_<character_id>_<motion_pack>_v001.png` |
| metadata 命名 | 同名 `.json`：`char_<character_id>_<motion_pack>_v001.json` |

示例：

```json
{
  "logical_animation_id": "anim.player.walk.down",
  "source_png": "res://assets/art/characters/animation/player_p0_motion_v001.png",
  "frame_size": {"w": 64, "h": 64},
  "pivot": {"x": 32, "y": 52},
  "frames": [0, 1, 2, 3, 4, 5, 6, 7],
  "fps": 10,
  "loop": true,
  "direction": "down",
  "fallback_asset_id": "character.player.standing"
}
```

## Logical Animation ID Backlog

| Category | Logical ID pattern | Asset path target |
|---|---|---|
| `character_animation_assets` | `anim.player.<state>.<direction>` | `res://assets/art/characters/animation/player_p0_motion_v001.png` |
| `character_animation_assets` | `anim.npc.mina.<state>.<direction>` | `res://assets/art/characters/animation/mina_p0_motion_v001.png` |
| `character_animation_assets` | `anim.npc.shopkeeper.<state>.<direction>` | `res://assets/art/characters/animation/shopkeeper_p0_motion_v001.png` |
| `character_animation_assets` | `anim.npc.story_bear.<state>.<direction>` | `res://assets/art/characters/animation/story_bear_p0_motion_v001.png` |
| `character_animation_assets` | `anim.npc.bus_helper.<state>.<direction>` | `res://assets/art/characters/animation/bus_helper_p1_motion_v001.png` |
| `pet_animation_assets` | `anim.pet.sunny.<state>.<direction>` | `res://assets/art/pets/animation/sunny_p0_motion_v001.png` |

ThemeProfile 后续建议增加：

- `character_animation_assets`
- `pet_animation_assets`
- `animation_metadata_assets`

AssetResolver 后续建议增加：

- `get_character_animation(logical_animation_id, theme_id)`
- `get_pet_animation(logical_animation_id, theme_id)`
- `get_animation_metadata(logical_animation_id, theme_id)`

旧接口 `get_character_sprite()` / `get_pet_sprite()` 保持 standing fallback。

## Godot 接入建议

P0 接入时优先小步升级，不重写 TownStage：

1. 在 `PlayerActor` / `NPCActor` 内新增 `set_motion_state(state, direction, intent = "")`。
2. Actor scene 内新增 `AnimatedSprite2D` 或 `Sprite2D + AnimationPlayer`，保留旧 `Body` 等节点作为 fallback。
3. `Main._advance_player_walk()` 在移动开始 / 方向变化 / 到达时通知 player actor：`walk_<direction>` -> `idle_<direction>`。
4. `get_current_interaction_target()` 或 `看看` 触发时通知 player / NPC / Sunny 播放 `interact` / `greet`。
5. NPC routine P0 先只在当前位置播放 idle / greet；short_walk 由 V02.35 或后续 routine 纵切实现。
6. Sunny follow 可以先作为规格和资产预留，runtime 纵切只需 Home greet / wag proof。

禁止事项：

- 不把 animation state 写入 save 作为长期状态；保存仍只保存必要位置和生活进度。
- 不让美术文件路径进入 runtime 逻辑；必须经 logical ID。
- 不为动画新增孩子端可见的格子、坐标、调试或 editor 文案。
- 不以动作资产缺失阻断当前 standing fallback 可玩路径。

## Runtime Proof 口径

后续 V02.35 实现时至少验证：

| Proof ID | 场景 | 必须可见 | 通过标准 |
|---|---|---|---|
| `motion_proof_player_walk_home_school_1280` | Home -> Home-School Walk -> School Gate | Player 4 向 walk / idle 切换、镜头跟随 | 连续移动无瞬移，停下后方向正确 |
| `motion_proof_player_interact_shop_1280` | Shop Street / Ribbon Corner | Player interact、Shopkeeper greet 或 tidy | 互动动作播放后回 idle，prompt 不漂移 |
| `motion_proof_sunny_home_greet_1280` | Home / Sunny | Sunny idle / wag / greet | Sunny 动作温和，不遮挡 Home 操作 |
| `motion_proof_story_bench_1280` | Story Bench | Story Bear idle / read / greet | Story Bear 与 branch / bench 关系清楚 |
| `motion_proof_fallback_missing_asset` | 任意角色缺 animation asset | standing fallback | 缺失动画不崩溃、不黑块、不阻断移动 |

自动化建议：

- focused test 断言 actor 暴露 `set_motion_state`、fallback 可用、movement state 与 `player_is_walking` 同步。
- sampling test 记录连续 60 帧 player position、motion state、direction，确认移动期间 state 为 walk，到达后为 idle。
- 1280 proof 仍走非 headless 或 MCP 截图路径；headless 逻辑测试只验证状态，不拿空纹理当视觉证据。

## 交付给后续任务的输入

`V02-CONTROLS-001`：

- 连续移动手感应提供稳定 moving vector / facing，供 animation state 使用。
- 虚拟摇杆、tap-to-move、键盘 / 手柄都必须统一到同一 motion intent，不让每种输入单独驱动动画。
- 转向 / 停止应给动画 80-160ms 的温和过渡空间，但 P0 可直接切换。

`V02-ARTPIPE-001`：

- 建立 player、Sunny、Mina、Shopkeeper、Story Bear 首批 motion pack。
- 每个 motion pack 提供 PNG + metadata + logical animation ID。
- Standing 图仍作为 fallback asset acceptance 的一部分。

`V02-RUNTIME-ANIM-001`：

- 在 `PlayerActor` / `NPCActor` 接入 animation resolver 和 fallback。
- `Main._advance_player_walk()` 与交互入口发 motion state。
- 导出 P0 1280 proof 和 focused/headless 状态验证。

## 验收结论

- player / NPC / Sunny 的 idle / walk / turn / interact / greet / follow 状态机：通过。
- 4 向必须 / 8 向预留：通过。
- sprite sheet 命名、帧数、尺寸、pivot、scale、loop 规则：通过。
- logical animation ID 与 AssetResolver 接入边界：通过。
- runtime proof 口径明确：通过。
- 不改 runtime、data、tests、assets，不生成正式动画资产：通过。

下一轮 Ready：`V02-CONTROLS-001 Animal Crossing-like 操控规格`。
