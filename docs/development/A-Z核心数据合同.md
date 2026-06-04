# A-Z 核心数据合同

> 任务：V02-AZ-001  
> 数据文件：`data/anchors/az_core_anchors.json`、`data/cards/az_core_cards.json`

## 定位

A-Z core 数据是 V02 的固定记忆编码底座。普通扩展词、任务和地图表现可以后续增加，但 26 个 core anchor 的 `letter`、`core_word`、`route_order`、`anchor_id`、`card_id` 不应被随意改写。

当前文件不替代 `data/maps/world_map.json`。地图仍只承载第一阶段最小可运行 marker；本合同提供完整 A-Z 内容事实来源，供后续 RuntimeMapBuilder、MemoryCardService、Letter Snake 和内容包校验接入。

## Anchor JSON

路径：`data/anchors/az_core_anchors.json`

顶层字段：

| 字段 | 类型 | 说明 |
|---|---|---|
| `schema_id` | String | 固定为 `az_core_anchors_v1` |
| `version` | Number | 数据版本 |
| `source` | String | A-Z 策划来源 |
| `first_batch_letters` | Array[String] | 首批启用字母，固定为 A/B/C/D/K/O/S/T/W |
| `anchors` | Array[Dictionary] | 26 个 core anchor |

每个 anchor 必填：`anchor_id`、`letter`、`core_word`、`route_order`、`card_id`、`enabled`、`phase`、`anchor_type`、`placement_hint`、`source`。

## Core Card JSON

路径：`data/cards/az_core_cards.json`

每张 core card 必填：`card_id`、`word`、`letter`、`anchor_id`、`story_memory`、`collection_state`、`source`。

`collection_state` 初始值固定为：

```json
{
  "seen": false,
  "heard": false,
  "played": false,
  "collected": false,
  "shiny": false,
  "spark": 0
}
```

## 固定 A-Z 编码

| Letter | Core Word | route_order | Phase |
|---|---|---:|---|
| A | Apple | 1 | first_batch |
| B | Bear | 2 | first_batch |
| C | Clock | 3 | first_batch |
| D | Dog | 4 | first_batch |
| E | Elephant | 5 | reserved |
| F | Fox | 6 | reserved |
| G | Gate | 7 | reserved |
| H | Hat | 8 | reserved |
| I | Ice cream | 9 | reserved |
| J | Jacket | 10 | reserved |
| K | Kite | 11 | first_batch |
| L | Lion | 12 | reserved |
| M | Monkey | 13 | reserved |
| N | Net | 14 | reserved |
| O | Orange | 15 | first_batch |
| P | Panda | 16 | reserved |
| Q | Queen | 17 | reserved |
| R | Robot | 18 | reserved |
| S | Sun | 19 | first_batch |
| T | Taxi | 20 | first_batch |
| U | Umbrella | 21 | reserved |
| V | Violin | 22 | reserved |
| W | Watch | 23 | first_batch |
| X | X-mark Box | 24 | reserved |
| Y | Yo-yo | 25 | reserved |
| Z | Zebra | 26 | reserved |

## 验证

```bash
godot --headless --path . --script tests/test_az_core_data.gd
```

测试覆盖：26 个 anchors/cards、A-Z `route_order` 唯一且顺序一致、A=Apple、首批 9 个为 A/B/C/D/K/O/S/T/W、anchor-card 互相绑定、core card 必填字段和收藏初始值。
