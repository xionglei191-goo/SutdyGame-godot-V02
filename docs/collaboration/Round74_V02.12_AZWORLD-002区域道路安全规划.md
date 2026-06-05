# Round 74 V02.12 AZWORLD-002 区域道路安全规划

> 日期：2026-06-05  
> 任务：`V02-AZWORLD-002 世界地图区域、道路、环线和安全边界规划`  
> 状态：验收通过  
> 事实数据：`data/maps/az_world_plan.json`

## 规划结论

V02.12 世界地图采用 Home / School 双中心。Home 是出发、回家、小屋和 Sunny 的安全中心；School 是 Home-School Walk、School Gate、School Yard 和第一主线 0 基础挂接中心。Town、Bookshop、Shop、Garden、Park、Theatre、Music Corner、Transport Edge 和 Far Edge 都围绕 Home / School 展开。

## 区域与环线

| ring | 承载区域 | 作用 | P0 依赖 |
|---|---|---|---|
| `center` | Home Center、School Center | Home-School Walk、Home、School、School Yard、Home 小屋 / Sunny / Watch / Clock | 是 |
| `first_ring` | Daily Town Ring | Shop、Bookshop、Garden、Bus Stop 和日常小镇回访 | 否 |
| `second_ring` | Town Expansion Ring | Park、Theatre、Music Corner、Sports Corner 和 P1 / P2 探索 | 否 |
| `far_edge` | Far Edge Reserve | X-mark Box、Zebra Edge、远期交通 / 动物预留 | 否 |

## 道路规划

| route_id | 路线 | 用途 | 安全返回 |
|---|---|---|---|
| `route_p0_home_school_walk` | Home -> Home-School Walk -> School Gate -> School Yard | 第一主线安全步行路，串联 A/C/D/W 与 E/G/K/N/R/Y | `place_home` |
| `route_first_ring_daily_town` | School Gate -> Shop Street -> Supermarket -> Bookshop -> Garden -> Bus Stop -> Home | 日常小镇回访、Shop / Food / Book / Transport 近场 anchor | `place_school_gate` |
| `route_second_ring_story_nature` | Bookshop -> Park -> Theatre -> Music Corner -> Sports Corner | 故事、自然、音乐、天气和可选回访 | `place_bookshop` |
| `route_far_edge_reserve` | Bus Stop -> Airport Cargo -> Zoo Edge | 远郊预留和相册世界感 | `place_bus_stop` |

## 安全边界

- Home-School Walk 必须短、可往返、入口明显，沿途不出现赶路、惩罚、陌生人护送或封锁感。
- First Ring 缺席时不影响 Home、School、Shop、小屋、Mina、Sunny、基础资源和近场 A-Z。
- Second Ring 只提供深度回访；未开放时不阻断 P0。
- Far Edge 只作为远期预览，X / Z 不进入 P0 主线，也不触发真实离开小镇。
- 所有边界提示使用“慢慢走回家”“以后一起看远处风景”这类陪伴式表达。

## 验收证据

- `data/maps/az_world_plan.json` 已新增 `routes` 与 `safety_boundaries`。
- `scripts/data/az_world_plan_contract.gd` 已验证四条 route、Home-School Walk、Far Edge 不阻断 P0 和安全边界字段。
- `tests/test_v0212_az_world_plan.gd` 已覆盖 `route_p0_home_school_walk`、first / second / far edge 路线和安全边界。

## 下一步

进入 `V02-AZWORLD-003`，把 17 个 reserved anchor 升级为可制作级规格；后续运行时实现必须优先保护 Home / School 中心和 Home-School Walk。
