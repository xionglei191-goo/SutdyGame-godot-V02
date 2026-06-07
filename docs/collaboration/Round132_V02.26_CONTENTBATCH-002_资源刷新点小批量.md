# Round132 V02.26 CONTENTBATCH-002 资源刷新点小批量

## 任务

- Task：`V02-CONTENTBATCH-002 资源刷新点小批量`
- Owner：Economy / Map / QA
- 状态：已完成
- 下一项 Ready：`V02-CONTENTBATCH-003 A-Z 生活物件回访`

## 交付

- `data/life/resource_points.json`
  - 新增 `resource_shell_coast_edge`、`resource_leaf_school_walk`、`resource_pinecone_animal_park`、`resource_ribbon_shop_street`。
  - 4 个资源点均为 `daily_soft`、`baseline_available: true`、`player_pressure: none`，数量为 1。
  - 位置分别落在 coast、Home-School Walk、Animal Park、Shop Street 的可达路径上，并避开 A-Z anchor、place interaction 和 collision cell。
- `data/items/life_items.json`
  - 新增 `shell`、`leaf`、`pinecone`、`ribbon` 4 个材料条目。
  - 每个条目都包含 `memory_story`，绑定稳定 `core_anchor_id`、place、visual hook 和 review path。
- `tests/test_v026_contentbatch002_resource_points.gd`
  - 覆盖资源点加载、物品目录存在、道路可达、protected cell 避让、无压力词、同日去重、跨日刷新和主场景真实 resource prompt。
- `tests/headless_runner.gd`
  - 注册 CONTENTBATCH-002 focused test，并加入 runner 级资源加载 / coast shell 可达采集检查。
- `tests/test_v0222_hidden_grid_life_systems.gd`
  - 同步旧 V02.22 routine fallback 断言：CONTENTBATCH-001 后默认 routine 数据完整，默认 snapshot 应无 blocked / fallback。

## 验证

- `godot --headless --path . --check-only --script tests/test_v026_contentbatch002_resource_points.gd`
- `godot --headless --path . --script tests/test_v026_contentbatch002_resource_points.gd`
- `godot --headless --path . --script tests/test_v024_content_contracts.gd`
- `godot --headless --path . --script tests/test_daily_town_services.gd`
- `godot --headless --path . --script tests/test_v0222_hidden_grid_life_systems.gd`
- `godot --headless --path . --script tests/test_v0223_expapproval_town_plaza_density.gd`
- `godot --headless --path . --script tests/test_v0221_livegate_hotspot_priority.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

## 儿童安全与产品边界

- 没有新增限时、错过、倒计时、打卡、刷材料、枯竭或惩罚表达。
- 新资源点只作为散步时的小发现，不改变 P0 主流程或经济压力。
- 不改 A-Z anchor ID / route_order，不重排地图结构，不把资源采集变成课程化目标。

## 经验复核

- 无新增已验证教训。
- 旧 V02.22 focused test 的 fallback 期望属于 Round131 后合同变化的同步修正，已通过 focused 和 full runner 验证。
