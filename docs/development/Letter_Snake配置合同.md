# Letter Snake 配置合同

> 范围：`V02-MINI-001` 只定义规则、运行时配置、结果结构和奖励差异，不实现 `MinigameService`、场景、存档写入或 UI。

## 1. 配置文件

运行时配置源：

```text
data/minigames/letter_snake_config.json
```

顶层字段：

| 字段 | 类型 | 说明 |
|---|---|---|
| `schema_version` | int | 当前为 `1`。 |
| `minigame_id` | string | 固定为 `letter_snake`。 |
| `display_name` | string | 孩子端可显示名称。 |
| `return_scene` | string | 完成后返回的场景 ID，当前为 `world_overview`。 |
| `round_defaults` | object | 首版回合默认值，供原型读取。 |
| `result_schema` | object | 完成结果必须包含的字段列表。 |
| `reward_profile` | object | 分数到 coins、卡片进度和概率奖励的转换。 |
| `sets` | array | Home/Food/Weather/Transport 四组目标。 |

## 2. 目标组

| Set | Target Letters | Target Words | 用途 |
|---|---|---|---|
| `home` | A, C, D | apple, clock, dog | Welcome/Home/Pet |
| `food` | A, O, E | apple, orange, egg | Supermarket |
| `weather` | S, K, W | sun, kite, windy | 出门环境 |
| `transport` | B, T, W | bus, taxi, watch | 交通入口 |

每组必须包含：

| 字段 | 类型 | 说明 |
|---|---|---|
| `set_id` | string | 稳定 ID。 |
| `child_title` | string | 孩子端标题，必须避免强考核表达。 |
| `event_id` | string | 生活事件入口。 |
| `target_letters` | string[] | 本轮目标字母，使用大写 A-Z。 |
| `target_words` | string[] | 本轮目标单词，使用小写。 |
| `card_ids` | string[] | 本轮可推进的 Memory Card。 |
| `prompt_templates` | string[] | 孩子端提示模板，可用 `{target}` 替换字母或单词。 |

## 3. 结果 Schema

小游戏完成后返回一个 Dictionary。`result_schema.required_fields` 定义首版必填字段：

| 字段 | 类型 | 说明 |
|---|---|---|
| `minigame_id` | string | `letter_snake`。 |
| `config_set_id` | string | 使用的目标组，如 `food`。 |
| `score` | int | 本局表现分。任意非负分都进入奖励计算。 |
| `target_letters_seen` | string[] | 本局出现过的目标字母。 |
| `target_words_seen` | string[] | 本局出现过的目标单词。 |
| `target_hits` | int | 命中目标数量。 |
| `distractor_touches` | int | 碰到干扰项数量，只用于内部调节。 |
| `duration_seconds` | float | 本局时长。 |
| `reward` | Dictionary | 奖励结果，字段见 `reward_fields`。 |

`reward` 必须包含：

| 字段 | 类型 | 说明 |
|---|---|---|
| `coins` | int | 任意分数都大于 0。 |
| `card_progress` | int | 卡片进度增量。 |
| `collected_chance` | float | 0 到 1，高分更高。 |
| `shiny_chance` | float | 0 到 1，高分可大于 0。 |
| `spark` | bool | 是否显示卡片光点反馈。 |

## 4. 奖励规则

`reward_profile.tiers` 按 `min_score` 升序解释，取不超过当前 `score` 的最高档：

| Tier | Min Score | Coins | Card Progress | Collected Chance | Shiny Chance |
|---|---:|---:|---:|---:|---:|
| `spark` | 0 | 3 | 1 | 0.0 | 0.0 |
| `bright` | 30 | 7 | 2 | 0.25 | 0.0 |
| `gold` | 70 | 12 | 4 | 0.75 | 0.12 |

要求：

- 任意非负分数都有 coins。
- 高分 coins 大于低分。
- 高分 `card_progress` 大于低分。
- 高分 `collected_chance` 大于中低分。
- 只有高分档可提供 `shiny_chance`。

## 5. 儿童端文案边界

孩子端可见字段包括：

```text
display_name
child_title
prompt_templates
child_feedback
```

这些字段不得出现以下强考核表达：

```text
failed
wrong
test
```

首版可以在内部记录干扰项触碰和分数，但 UI 只表达发现、光点、coins、卡片进度和生活事件反馈。
