# Godot 技术架构

## 技术目标

V02 使用 Godot，移动端手机和平板优先。PC 主要作为开发调试平台。

推荐基线：

- Godot 4.x。
- 触屏优先。
- 横屏优先。
- 1280x720 逻辑分辨率起步，适配手机和平板安全区。
- 数据驱动运行时。
- Godot 内编辑工具。
- 生图脚本和 Godot MCP 服务使用 `/home/xionglei/GameProject/tools` 下的共享工具，不复制进项目 Git 仓库。

## 分层架构

```text
Editor Layer
  地图编辑代理节点、同步工具、校验工具。

Data Layer
  地图、A-Z、任务、NPC、卡片、小游戏、语音、学习记录。

Runtime Layer
  根据数据生成地图、热点、碰撞、交互、UI。

Game Systems
  Quest、Pet、Shop、MemoryCard、Minigame、Voice、NPC。

Parent/Admin Layer
  本地后台、摘要、设置。

Tests
  数据合同、地图校验、运行时 smoke、内容校验。
```

## 移动端要求

- 大触控区域。
- 少小字。
- 点击、拖拽、滑动、长按、双指缩放。
- 虚拟摇杆或点地移动需要后续选型。
- 音频按需加载。
- 地图分块或图集化。
- 避免大量超大 PNG。
- AI/TTS/录音异步处理。

## 数据格式原则

数据应服务于编辑和运行时：

- 每个地图对象有稳定 id。
- 每个对象能对应 Godot 编辑代理节点。
- 运行时不直接依赖 EditorOnly 节点。
- 保存时写回数据。
- 测试校验数据。

## 预留服务接口

即使第一阶段本地单机，也预留：

- SaveService。
- AccountAdapter。
- VoiceService。
- LLMClient。
- NPCMemoryStore。
- ParentDashboardStore。
- ContentPackLoader。
- NetworkService。

初期全部使用 Local 实现。

## 共享开发工具

共享工具使用与配置见：

```text
docs/development/共享工具使用与配置.md
```

V02 默认使用：

- `/home/xionglei/GameProject/tools/image_generator.js`
- `/home/xionglei/GameProject/tools/godot_mcp/bridge/mcp_godot_bridge.js`
- `/home/xionglei/GameProject/tools/godot_mcp/addon_template`

这些工具不进入 GitHub；项目内只保留路径模板、说明和必要接入步骤。
