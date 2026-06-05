# Round 66 `V02-P1RETURN-002` 故事熊 / 巴士哥哥 P1 轻回访验收记录

> 日期：2026-06-05  
> 范围：V02.10 P1 居民回访扩展第二项实现。  
> PM 结论：`pass`，`V02-P1RETURN-002` 可以标记完成，下一项 Ready 为 `V02-P1RETURN-003 B Bear / T Taxi 相册与 A-Z 记录`。

## 实现范围

- `data/life/daily_requests.json` 新增两条 P1 看一眼类轻回访：
  - `daily_story_bear_find_bear_corner_001`
  - `daily_bus_helper_taxi_spot_001`
- `scripts/systems/daily_request_service.gd` 支持 `required_p1_entries`，允许轻回访通过已看见的 P1 入口完成。
- `scripts/main.gd` 将 Story Bear / Bus Helper 的孩子端真实 NPC 互动路由到 V02.10 P1 请求。
- `scripts/systems/content_contract_validator.gd` 允许每日请求使用 `required_items` 或 `required_p1_entries` 作为完成要求。
- `tests/test_v0210_p1_light_returns.gd` 新增 focused 验证。
- `tests/headless_runner.gd` 注册 P1 轻回访回归。

## 验收覆盖

- 故事熊可通过可见 `看看` 接取 Bear Corner 看一眼轻回访。
- 玩家到 Bear Corner 按 `看看` 后返回故事熊，可完成 `daily_story_bear_find_bear_corner_001`。
- 巴士哥哥可通过可见 `看看` 接取 Taxi marker 看一眼轻回访。
- 玩家到 Taxi marker 按 `看看` 后返回巴士哥哥，可完成 `daily_bus_helper_taxi_spot_001`。
- 两条支线均按 day_key 保存完成状态，关系 `+1`，金币奖励只发一次。
- P0 日常、商店和小屋路径不受影响。
- 可见文本不出现阅读测验、考试、评分、背诵、倒计时、赶时间、陌生人带走、独自远行、上车或错过班车。

## 验证命令

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script scripts/systems/daily_request_service.gd
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --check-only --script tests/test_v0210_p1_light_returns.gd
godot --headless --path . --script tests/test_v0210_p1_light_returns.gd
godot --headless --path . --script tests/test_daily_request_service.gd
godot --headless --path . --script tests/test_daily_town_services.gd
godot --headless --path . --script tests/test_v024_content_contracts.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

以上命令已通过。

## PM 判断

- `V02-P1RETURN-002` 没有把 Bookshop / Bus Stop 扩成 P0 主流程；两条轻回访仍是可选 P1 支线。
- 本轮没有接入相册点亮或 A-Z card state 写入；该范围保留给 `V02-P1RETURN-003`。
- 本轮没有做截图取证；代表截图与 P1 smoke 仍由 `V02-P1RETURN-004` 承担。
