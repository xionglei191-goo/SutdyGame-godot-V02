# NPC AI Stub 合同

## 范围

Round 8 只提供本地 NPC profile、memory、LLMClient stub 和 ConversationSummary stub。它不连接真实模型，不申请录音或网络权限，不做开放聊天。

## 数据位置

每个首批 NPC 使用独立目录：

```text
data/npcs/<npc_id>/profile.json
data/npcs/<npc_id>/memory.json
```

首批 `npc_id` 固定为：

```text
mina
shopkeeper
pet_buddy
bus_helper
story_bear
```

`profile.json` 必须包含稳定 `npc_id`、`display_name`、角色用途、固定孩子端对白、`fallback_reply` 和 `safety_boundary`。`safety_boundary.network_allowed` 必须为 `false`，`collect_personal_data` 必须为 `false`。

`memory.json` 是初始本地记忆 stub，包含 `recent_events`、关联卡片、宠物状态占位和家长可见摘要开关。

## 服务合同

`NPCMemoryStore`：

- 加载五个固定 NPC 的 profile/memory。
- `record_event()` 把最近 NPC 事件写入 `SaveService.load_learning_record().npc_memory`。
- `get_recent_events()` 供摘要和后续家长后台读取。

`LLMClient`：

- `is_stub()` 恒为 `true`。
- `network_enabled()` 恒为 `false`。
- `complete_chat()` 只返回固定安全占位回复，`model` 为 `none`，`network_used` 为 `false`。
- 遇到地址、电话、学校名等输入，只返回本地安全兜底句。

`ConversationSummaryService`：

- `record_interaction()` 生成家长端可读摘要。
- 摘要写入 `learning_record.npc_parent_summaries`。
- 摘要 ID 同步写入 `learning_record.npc_summary_refs`。
- 同一事件也写入 `NPCMemoryStore`，用于最近事件读取。

## 验证

```bash
godot --headless --path . --script tests/test_ai_npc_stubs.gd
```
