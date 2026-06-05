# Round 77 V02.13 TEXTBOOK-001 至 005 PM 执行任务包

> 阶段：`V02.13 全量课本内容世界化主线策划`  
> 范围：小学三上至六下 8 册课本内容补齐、结构化、世界化映射和合同验证  
> 原则：只做到数据可加载，不接入孩子端 runtime，不做课程页、单元门、背诵表、测试路线或截图验收

## 任务拆分

| 任务 | 目标 | 交付物 |
|---|---|---|
| `V02-TEXTBOOK-001` | 补齐三上来源并核对 8 册 ledger | `curriculum/小学英语重点分析/三年级上册.txt`、`textbook_sources` |
| `V02-TEXTBOOK-002` | 将 8 册整理为结构化清单 | `curriculum_items` 85 个单元摘要 |
| `V02-TEXTBOOK-003` | 建立世界化主线映射 | `world_mappings` 绑定地点、NPC、anchor、故事和回访 |
| `V02-TEXTBOOK-004` | 建立 Home / School 第一主线分层 | `mainline_segments` P0/P1/P2 |
| `V02-TEXTBOOK-005` | 建立合同与回归 | `TextbookWorldContract`、focused test、headless runner 注册 |

## 执行边界

- 三上只保存公开来源摘要、主题和词句结构，不复制整本教材原文。
- 三下至六下沿用现有本地分析文件，不在本轮大规模改写原始资料。
- P0 只覆盖 Home、Home-School Walk、School Gate、School Yard、Shop 和 Sunny 角落的 0 基础 / 低年级高频内容。
- P1/P2 只作为 Bookshop、Garden、Bus Stop、Clothes Shop、Park、Theatre、Music Corner 和 Far Edge 预留。
- 不修改 `scripts/main.gd`，不新增孩子端 UI，不进行截图验收。

## 验收命令

```bash
find data curriculum -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script scripts/data/textbook_world_contract.gd
godot --headless --path . --script tests/test_v0213_textbook_world_plan.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

## 收口标准

- 8 册来源齐备，三上保留来源 URL 和抓取日期。
- 85 个单元摘要可加载并与册数 / 单元数 ledger 一致。
- P0 映射不少于 12 条，且不使用 `anchor_x_x_mark_box`、`anchor_z_zebra` 或 far edge 地点。
- 合同测试能拒绝缺册、P0 远郊依赖和压力文案。
- `todo.md`、`docs/12`、`docs/13`、`docs/14`、`docs/15` 和 `lessons.md` 同步。
