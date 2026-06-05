# Round 52 V02.7 发布前体验门槛执行记录

> 日期：2026-06-05  
> 范围：落实 Round 52 剩余 todo 推进计划。  
> 结论：`V02-POLISH-001` 已进入 Godot 实现并通过自动化；`V02-POLISH-002` / `003` 的验收清单已固定；`V02-POLISH-004` 的 P0 production 素材已通过逻辑 asset ID 接入并完成自动化与运行时截图抽查。

## V02-POLISH-001 退出与设置入口

- 顶部 `TownHUD` 新增低干扰 `设置` 入口，不进入底部 `看看` / `小镇` / `小屋` / `背包` 主操作栏。
- 新增 `SettingsPanel`，首批只包含声音开关、回到小镇安全位置、休息确认、继续逛和退出游戏。
- 退出需要先点击 `休息一下` 才显示 `退出游戏`，避免移动端一键误触。
- `回到小镇` 会把玩家送回起始安全格并关闭设置面板。
- 设置面板打开时会收起背包、商店和相册覆盖层，避免弹层互相遮挡。
- 孩子端文案保持生活小镇语气，不显示 Godot、debug、runner、JSON、contract、test、script 等工程词。

## V02-POLISH-002 玩家路径截图验收

- 继续采用 `Round51_UXQA_Polish001_002验收草案.md` 作为截图验收规范。
- 固定 12 个截图点：小镇首屏、NPC 对话、资源收集、背包气泡、商店货架、购买反馈、小屋视图、家具操作、相册覆盖层、anchor 互动、每日轻委托、设置 / 安全入口。
- 截图必须来自孩子端真实可见入口；隐藏 contract 按钮、脚本直调和服务调用不能作为可玩证据。
- 本轮已把设置 / 安全入口纳入玩家操作级自动化测试。

## V02-POLISH-003 移动端触控与布局复核

- 继续采用 `Round51_V02-POLISH-003-004_QA-Asset验收草案.md` 作为移动端布局复核规范。
- 固定 `1280x720` 与 `960x540` 横屏检查表。
- 检查重点包括顶部 HUD、底部主操作栏、背包气泡、商店面板、小屋视图、家具操作、相册覆盖层、NPC 对话和 anchor 互动。
- 设置 / 退出明确不放入底部主操作误触区，退出需要二次确认或安全位置入口。

## V02-POLISH-004 首批素材替换验收

- P0 素材替换验收表已固定，覆盖：
  `place.town_plaza.day`、`place.home.exterior`、`place.shop.exterior`、`place.road.main`、`place.resource.branch`、`character.player.standing`、`character.mina.standing`、`pet.sunny.standing`、`ui_icon.coin`、`ui_icon.bag`。
- 素材接入记录字段已固定：逻辑 asset ID、类别、对象 ID、状态、resolver 映射 owner、映射路径、替换目标、截图证据、验收结论、儿童安全记录和 A-Z 稳定性记录。
- 素材只能通过 `ThemeProfile` / `AssetResolver` 映射进入 runtime，玩法脚本不得新增硬编码素材路径。
- 本轮已接入 P0 production 素材：Town Plaza、Home、Shop、主路、树枝、玩家、Mina、Sunny、金币图标和背包图标。
- `ThemeProfile` 新增 `place_assets`、`character_assets`、`ui_icon_assets` 和接入记录；`AssetResolver` 可按逻辑 asset ID 解析 P0 素材。
- 主场景通过 `AssetResolver` / `ResourceLoader` 加载 P0 纹理；玩法脚本没有直接硬编码具体 PNG 路径作为业务逻辑来源。
- `tests/test_life_rpg_scene.gd` 已加入运行时纹理断言，确认金币、背包、玩家和 Mina 使用 P0 资源而不是 8x8 程序占位。
- MCP 已捕获 `1280x720` 首屏截图并抽查运行树；A-Z anchor 节点和路线未被移动或重写。

## 验证结果

```bash
godot --headless --path . --check-only --script scripts/main.gd
godot --headless --path . --script tests/test_asset_resolver.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/test_playable_ui_operations.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

结果：全部通过。

## 后续 Owner

- Art Direction / Asset / QA：下一阶段补 P1 素材，并按 `960x540` 较小横屏截图补验。
- QA / UI：UI 或美术大改后，按 12 个截图点补截图记录。
- Godot / UX：若设置入口、HUD、底栏或弹层位置继续调整，必须同步更新操作级测试。
