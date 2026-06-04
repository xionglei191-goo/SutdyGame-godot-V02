# 多 Agent 协作规范 v0.2

> 项目：StudyGame V02  
> 目的：在 V02 后续策划、编辑工具、Godot 实现、内容生产、语音、AI、小游戏和 QA 工作中，继续采用子 agent 分工协作模式。

## 1. 协作原则

- 主 Agent 负责拆解目标、分配任务、整合结果和最终验收。
- 子 Agent 只处理被分配的明确范围，不擅自改动无关文件。
- 所有产出必须落到仓库文件中，避免只停留在口头结论。
- 任何设计、内容、素材、数据或代码变更都要说明来源、影响范围和验证方式。
- 涉及儿童内容、英语知识点、语音、AI 对话、联网和图片素材时，必须遵守适龄、隐私、版权和产品边界。
- V02 以文档基线和数据合同为准，不能把临时实现反向变成产品方向。

## 2. 推荐子 Agent 分组

| Agent | 职责 | 主要输入 | 主要输出 |
|---|---|---|---|
| PM Agent | 需求拆解、版本规划、验收标准 | V02 框架文档、用户目标 | 任务列表、里程碑、验收清单 |
| Game Design Agent | 玩法循环、宠物/商店/任务/奖励设计 | 产品总纲、核心玩法循环 | 生活事件、开放循环、Quest 草案 |
| Curriculum Agent | 0 基础英语阶梯、教材映射、词句审核 | `curriculum/小学英语重点分析/` | 学习目标、词句清单、教材映射 |
| Memory Palace Agent | A-Z 编码、记忆卡、故事记忆设计 | A-Z 记忆宫殿文档 | Anchor 设计、Memory Card 数据草案 |
| Narrative Agent | 世界观、NPC、对话文本、故事记忆 | 产品设定、NPC 目标 | NPC 台词、故事事件、记忆文本 |
| Voice/AI Agent | TTS、录音、AI NPC、记忆文件和摘要设计 | NPC/AI 文档、语音目标 | 语音配置、NPC profile、AI 接口草案 |
| Minigame Agent | 小游戏规则和接入接口 | 小游戏框架、学习目标 | 小游戏配置、奖励规则、结果数据 |
| Godot Dev Agent | Godot 工程、场景、脚本、编辑器工具 | 技术架构、任务范围 | Godot 场景、脚本、运行说明 |
| Map Tool Agent | 地图编辑代理节点、数据同步、校验工具 | 地图编辑架构 | Editor tool、map schema、校验脚本 |
| UI/UX Agent | 儿童触屏界面、家长后台入口 | 目标用户、移动端约束 | UI 流程、界面规格、触控规范 |
| Asset Agent | 美术风格、换肤、素材清单、提示词 | 美术风格文档 | 资产清单、prompt、审核记录 |
| QA Agent | 测试用例、验收、风险回归 | 版本范围、实现结果 | 测试清单、问题列表、验收结论 |

## 3. 任务分配格式

给子 Agent 分配任务时，使用以下结构：

```markdown
## Task
一句话说明目标。

## Scope
允许修改或产出的文件范围。

## Inputs
必须阅读的文档或数据。

## Deliverables
需要提交的文件、表格、代码或结论。

## Acceptance Criteria
可验证的完成标准。

## Constraints
不能触碰的范围、风格、安全、隐私和版权限制。
```

## 4. 子 Agent 交付格式

子 Agent 完成后必须说明：

- 修改了哪些文件。
- 新增了哪些内容。
- 哪些需求已经满足。
- 如何验证。
- 还有哪些风险或待确认问题。

## 5. 文件所有权

| 路径 | 主要负责 Agent |
|---|---|
| `docs/` | PM Agent、主 Agent |
| `docs/collaboration/` | PM Agent、主 Agent |
| `curriculum/` | Curriculum Agent |
| `data/maps/` | Map Tool Agent、Godot Dev Agent |
| `data/quests/` | Game Design Agent、Curriculum Agent、Godot Dev Agent |
| `data/cards/` | Memory Palace Agent、Curriculum Agent |
| `data/npcs/` | Narrative Agent、Voice/AI Agent |
| `data/minigames/` | Minigame Agent、Curriculum Agent |
| `data/voice/` | Voice/AI Agent |
| `scenes/` | Godot Dev Agent、UI/UX Agent |
| `scripts/editor/` | Map Tool Agent、Godot Dev Agent |
| `scripts/systems/` | Godot Dev Agent |
| `assets/` | Asset Agent、UI/UX Agent |
| `tests/` | QA Agent、Godot Dev Agent |

## 6. 冲突处理

- 产品目标冲突：以 V02 产品总纲和主 Agent 决策为准。
- 学习内容冲突：以 `curriculum/小学英语重点分析/` 和 Curriculum Agent 审核为准。
- A-Z 编码冲突：以 A-Z 记忆宫殿核心编码为准，扩展词不得覆盖核心编码。
- 地图编辑冲突：以 Godot editor proxy + 数据同步 + 运行时数据驱动为准。
- AI 互动冲突：以儿童适龄、NPC 人设、家长摘要和产品边界为准。
- 美术风格冲突：以 V02 初期统一风格和 ThemeProfile 方案为准。
- 技术实现冲突：优先保证移动端触屏体验、数据合同和可测试性。

## 7. 验收顺序

1. 子 Agent 自检。
2. 主 Agent 检查文件和范围。
3. QA Agent 执行测试或文档审核。
4. PM Agent 对照 V02 框架和任务验收。
5. 主 Agent 汇总状态并决定是否进入下一轮。

## 8. V02 特别约束

- 不把强考核、课表、单词列表、学校导览作为孩子端主体验。
- 不把家长后台放进孩子主流程。
- 不把所有运行时真数据只塞进 `.tscn`。
- 不让小游戏孤立于 Memory Card、学习记录和奖励系统。
- 不让 AI NPC 脱离角色、年龄友好表达和家长摘要机制。
- 不在第一阶段引入商业化、开放陌生人社交或真实账号强依赖。

