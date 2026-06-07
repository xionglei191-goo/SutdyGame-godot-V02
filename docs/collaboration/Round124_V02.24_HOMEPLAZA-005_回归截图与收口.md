# Round124 V02.24 HOMEPLAZA-005 回归、截图与收口

> 日期：2026-06-07  
> 结论：已完成。V02.24 阶段收口，但不标 product complete。下一项 Ready：`V02-MAPAUTH-001 错误列表与验证按钮`。

## 1. 范围

本轮只做 V02.24 回归、1280 proof 和阶段收口。验证 Home living contract、Town Plaza outdoor decor rules、NPC routine safety、旧可见路径和儿童文本安全；不新增内容批量，不改 HomeDecorationService 存档结构，不改 A-Z `anchor_id` / `letter` / `core_word` / `route_order` / `card_id` / 相册语义。

## 2. 交付物

- `tests/test_v0224_homeplaza005_rc_smoke.gd`：聚合 Home、Town Plaza、outdoor decor、NPC routine、Shop / Album / Settings 旧路径和可见文本安全。
- `tests/capture_homeplaza005_rc.gd`：导出 Round124 1280x720 proof。
- `docs/collaboration/round124_homeplaza005_rc/`：五张 1280x720 proof。
- `tests/headless_runner.gd`：注册 HOMEPLAZA-005 RC smoke。

## 3. 1280 Proof

| 文件 | 内容 |
|---|---|
| `shot_round124_homeplaza005_town_plaza_living_1280.png` | Town Plaza 停留感 |
| `shot_round124_homeplaza005_town_plaza_outdoor_decor_1280.png` | 安全户外装饰 |
| `shot_round124_homeplaza005_npc_arrival_prompt_1280.png` | NPC arrival prompt |
| `shot_round124_homeplaza005_home_living_1280.png` | Home living details |
| `shot_round124_homeplaza005_home_furniture_feedback_1280.png` | Home 家具反馈 |

## 4. 验证

| 验证项 | 结果 |
|---|---|
| `godot --headless --path . --script tests/test_v0224_home_room_living_contract.gd` | 通过 |
| `godot --headless --path . --script tests/test_v0224_town_plaza_outdoor_decor_rules.gd` | 通过 |
| `godot --headless --path . --script tests/test_v0224_npc_routine_arrival_safety.gd` | 通过 |
| `godot --headless --path . --script tests/test_v0224_homeplaza005_rc_smoke.gd` | 通过 |
| `godot --headless --path . --script tests/headless_runner.gd` | 通过 |
| `godot --headless --path . --quit` | 通过 |
| `godot --path . --display-driver x11 --resolution 1280x720 --script tests/capture_homeplaza005_rc.gd` | 通过 |
| `file docs/collaboration/round124_homeplaza005_rc/*.png` | 5 张均为 1280 x 720 PNG |

## 5. 收口判断

`V02-HOMEPLAZA-005` 可收口。V02.24 已完成 HomeRoom、Town Plaza、outdoor decor rules、NPC routine arrival safety 和同轮 1280 proof。下一阶段进入 V02.25 地图 Authoring 工具实用化，首项 `V02-MAPAUTH-001` 只做错误列表与验证按钮，不写回 `world_map.json`。
