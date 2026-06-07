# Round121 V02.24 HOMEPLAZA-002 HomeRoom 居住感加固验收记录

> 日期：2026-06-07
> 对应任务：`V02-HOMEPLAZA-002 HomeRoom 居住感加固`
> 结论：已完成。下一项 Ready：`V02-HOMEPLAZA-003 Town Plaza 停留点与户外装饰规则`。

## 1. 范围

本轮只加固 HomeRoom 的居住感，不改变 `HomeDecorationService` 存档结构，不改 A-Z anchor ID、letter、core_word、route_order、card_id 或相册语义。

实现内容：

- `HomeLifeLayer` 新增 `HomeDefaultBookStack`、`HomeDefaultSunnyToy`、`HomeDefaultWarmCup` 三个默认生活细节。
- Home 空状态和 Sunny 小屋反馈改为更生活化的短句。
- `get_expapproval_home_snapshot()` 增加 `home_living_contract_version = v02.24_homeplaza_002`，供 focused / runner 验证。
- 新增 `tests/test_v0224_home_room_living_contract.gd` 并注册 `tests/headless_runner.gd`。

## 2. 禁改边界复核

- 默认生活细节只存在于 `HomeLifeLayer`，不写入 `home_state.placed_furniture`。
- 玩家通过可见按钮摆放的 `pet_bowl` / `sunny_bed` 仍按既有 `placed_furniture` 持久化。
- 孩子端文案不显示格子、坐标、占格、footprint、debug 或路径术语。
- 本轮不做 V02.23 approved 重新判定，也不写 product complete。

## 3. 验证

已通过：

```bash
godot --headless --path . --script tests/test_v0224_home_room_living_contract.gd
godot --headless --path . --check-only --script scripts/stages/home_room.gd
godot --headless --path . --check-only --script tests/headless_runner.gd
godot --headless --path . --script tests/test_v0223_expapproval_home_living_density.gd
godot --headless --path . --quit
godot --headless --path . --script tests/headless_runner.gd
```

## 4. 后续输入

`V02-HOMEPLAZA-003` 进入 Ready。下一轮应聚焦 Town Plaza 停留点和户外装饰规则，补 allowed place / footprint / 禁覆盖核心 anchor、place、interaction 的 focused test；不要把 HomeRoom 存档结构或 A-Z 编码纳入返工。
