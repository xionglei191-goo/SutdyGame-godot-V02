# Round134 V02.26 CONTENTBATCH-004 Shop front / School Yard 小事件 smoke

## 任务

- Task ID：`V02-CONTENTBATCH-004`
- Owner：Narrative / QA / Godot
- 目标：新增 Shop front / School Yard 两个生活化看一眼小事件，必须来自孩子端真实 `看看` 入口，不课程化，不阻断 P0。

## 交付

- `data/life/homeschool_events.json`
  - 新增 `homeschool_shop_front_window_001`：Shop Street 窗边 Hat / Ice cream / Orange 轻观察。
  - 新增 `homeschool_school_yard_chalk_flower_001`：School Yard 粉笔花、Net / Yo-yo / Robot 轻观察。
- `data/maps/world_map.json`
  - 新增 Shop Street 入口：`42,9`，`look_homeschool_event`。
  - 新增 School Yard 入口：`18,14`，`look_homeschool_event`。
  - 两个入口均落在可达 road cell，避开已有 exact anchor、resource、interaction 和 collision cell。
- `tests/test_v026_contentbatch004_look_events.gd`
  - 覆盖 JSON、可达性、protected cell 避让、儿童安全文本、主场景真实 `看看`、保存落账、相册 card state 和 Shop P0 入口不阻断。
- `tests/headless_runner.gd`
  - 注册 CONTENTBATCH-004 编译与运行时集成检查。
- `todo.md`、`docs/12`、`docs/13`、`docs/14`、`docs/15`、`lessons.md`
  - 同步 Round134 完成、V02.26 内容生产小批量收口和无新增已验证教训。

## 验证

- `godot --headless --path . --script tests/test_v026_contentbatch004_look_events.gd`
- `godot --headless --path . --script tests/test_v0214_homeschool_slice.gd`
- `godot --headless --path . --script tests/test_v026_contentbatch002_resource_points.gd`
- `godot --headless --path . --script tests/test_v026_contentbatch003_anchor_revisits.gd`
- `godot --headless --path . --script tests/test_v024_content_contracts.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

## 风险与边界

- 复用既有 `look_homeschool_event` 路径，没有新增事件系统。
- 不改 26 A-Z anchor ID、route_order、card ID 或 world map authoring 写回策略。
- 不把 Shop 或 School Yard 写成课程、任务表、购买压力或技巧评分。
- 入口坐标后续如由 authoring 工具迁移，需同步 CONTENTBATCH-004 focused test 的固定 cell。

## Lessons

无新增已验证教训。Focused test 首轮发现安全说明中含压力词，已改为正向生活化安全说明，属于既有儿童安全规则内收敛。
