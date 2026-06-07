# Round133 V02.26 CONTENTBATCH-003 A-Z 生活物件回访

## 任务

- Task：`V02-CONTENTBATCH-003 A-Z 生活物件回访`
- Owner：Memory Palace / Narrative / QA
- 状态：已完成
- 下一项 Ready：`V02-CONTENTBATCH-004 Shop front / School Yard 小事件 smoke`

## 交付

- `data/anchors/new_word_revisit_paths.json`
  - 新增 `story_photo_apple_welcome`：`photo` / A / `anchor_a_apple` / Home。
  - 新增 `story_towel_dog_corner`：`towel` / D / `anchor_d_dog` / Home。
  - 新增 `story_leaf_kite_path`：`leaf` / K / `anchor_k_kite` / Home-School Walk。
  - 新增 `story_ribbon_hat_window`：`ribbon` / H / `anchor_h_hat` / Shop Street。
  - 新增 `story_pinecone_monkey_tree`：`pinecone` / M / `anchor_m_monkey` / Animal Park。
  - 新增 `story_shell_umbrella_coast`：`shell` / U / `anchor_u_umbrella` / Coast Edge。
- `tests/test_v026_contentbatch003_anchor_revisits.gd`
  - 覆盖必填字段、`story_id` 唯一、`core_anchor_id` 全局唯一、核心 anchor / letter 匹配、儿童安全文案、`AnchorInteractionService` lookup、card state 和主场景真实 anchor prompt。
- `tests/headless_runner.gd`
  - 注册 CONTENTBATCH-003 focused test，并加入 runner 级 expanded story / Hat ribbon runtime 检查。

## 验证

- `godot --headless --path . --check-only --script tests/test_v026_contentbatch003_anchor_revisits.gd`
- `godot --headless --path . --script tests/test_v026_contentbatch003_anchor_revisits.gd`
- `godot --headless --path . --script tests/test_v023_memory_palace_world.gd`
- `godot --headless --path . --script tests/test_v024_content_contracts.gd`
- `godot --headless --path . --script tests/headless_runner.gd`
- `godot --headless --path . --quit`

## 风险处理

- 当前 `AnchorInteractionService` 以 `core_anchor_id` 作为字典 key，同一 anchor 多故事会覆盖。
- 本轮新增故事全部使用此前 `new_word_revisit_paths.json` 未占用的 anchor，并在 focused test 中加入全局唯一 `core_anchor_id` 断言。

## 儿童安全与产品边界

- 文案保持生活物件回访，不包含测验、考试、背诵、评分、正确率、等级、倒计时、错过、必须、打卡、任务、作业或分数。
- 不移动 A-Z anchor，不改 route_order，不把回访做成课程或主流程门槛。

## 经验复核

- 无新增已验证教训。
- 唯一 `core_anchor_id` 测试已覆盖已知一对一映射风险。
