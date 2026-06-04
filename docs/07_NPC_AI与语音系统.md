# NPC、AI 与语音系统

## NPC 定位

NPC 是英语环境的重要组成部分。初期可以使用固定对白和 TTS，后期接入 AI 大模型，提高开放互动体验。

NPC 阵容应根据现有 curriculum 和 A-Z 记忆宫殿素材策划，不在早期凭空扩展过多角色。

## NPC 记忆文件

每个 NPC 预留独立记忆文件：

```text
npcs/mina/
  profile.json
  memory.json
  dialogue_rules.json
  voice_profile.json
```

记忆内容可以包括：

- NPC 角色设定。
- 与孩子最近的共同事件。
- 孩子已收集的卡片。
- 宠物相关状态。
- 可使用的词汇范围。
- 家长允许的互动范围。

## AI 接口

V02 不绑定具体模型。预留通用 LLM 接口，后续根据成本、效果、延迟和安全能力选择模型。

建议抽象：

```text
LLMClient
PromptBuilder
NPCMemoryStore
ConversationSummaryService
SafetyPolicy
```

## AI 安全与开放探索

目标是鼓励孩子多方向探索和互动，但产品仍需要儿童产品级边界。

模型自带安全边界不是全部。V02 还需要：

- NPC 角色边界。
- 年龄友好表达。
- 不收集真实地址、电话、学校等敏感信息。
- 家长可查看交流摘要。
- AI 失败兜底。
- 对话记录策略。

## 语音系统

阶段规划：

1. 初期：TTS + 录音。
2. 中期：预录素材和角色声音管理。
3. 后期：跟读、发音反馈、AI 语音互动。

数据结构应预留：

- `audio_id`
- `tts_voice_id`
- `recording_enabled`
- `repeat_after_me_enabled`
- `speech_eval_enabled`

移动端还需要考虑麦克风权限、离线兜底、网络延迟和音频缓存。

