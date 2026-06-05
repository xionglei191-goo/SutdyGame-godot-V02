# Round 51 V02-POLISH-003 / 004 QA-Asset 验收草案

> 日期：2026-06-05  
> Owner：QA / UX / Godot、Art Direction / Asset / QA  
> 范围：发布前移动端触控与布局复核、首批正式 / 半正式素材替换验收。  
> 本草案只定义验收门槛和记录模板，不改运行时代码、`data/`、`tests/`、`todo.md` 或 `lessons.md`。

## 通用约束

- 所有截图验收以孩子端真实可见入口为准，不能使用隐藏 contract 按钮、脚本直接调用或调试面板作为通过证据。
- 视口至少覆盖 `1280x720` 横屏和较小横屏视口。较小横屏建议先固定为 `960x540`；如后续目标设备另定分辨率，以 PM 指定值补充。
- UI 与素材只能引用逻辑 asset ID。具体 `res://...` 路径必须由 `ThemeProfile` / `AssetResolver` 映射，玩法脚本不得新增 `load()`、`preload()` 或字符串拼接硬编码素材路径。
- A-Z anchor 必须保持核心 `anchor_id`、路线顺序、世界地点和故事编码稳定。素材替换只能替换表现，不得移动核心路线、重写核心编码或把 anchor 改成裸字母测验牌。
- 英语只作为环境短句、地点标识、相册标签或语音片段；检查中发现课程、测试、单词背诵、打卡、排名、家长报告或失败惩罚文案即判失败。

## V02-POLISH-003 移动端触控与布局复核

### 1280x720 横屏检查表

| 检查区域 | 入口 / 场景 | 必须通过 | 失败判定 |
|---|---|---|---|
| 顶部 HUD | 小镇首屏、Home Room、Shop 面板打开前后 | 今日状态、金币、宠物状态和设置入口保持在安全区内；不遮挡玩家、Mina、Sunny、核心建筑和 A-Z anchor。 | HUD 双层堆叠、文字压到地图主体、金币 / 状态挤压设置按钮、出现工程文案。 |
| 底部操作栏 | 小镇首屏 | 常驻主按钮保持精简，触控目标建议不低于 `56x56`，按钮间距稳定，pressed 状态不造成布局跳动。 | 底栏横跨过多空白、按钮贴边、点击态导致按钮或文字位移遮挡地图。 |
| 背包气泡 | 点击 `背包` | 气泡不覆盖大半地图；金币、Sunny 点心、树枝、家具、相册 / 可选入口可读；关闭路径可见。 | 气泡遮住底栏主按钮、关闭按钮不可见、文字溢出或需要滚动才能关闭。 |
| 商店面板 | 靠近 Shop / 店长打开货架 | 商品图标、名称、价格、购买按钮和关闭按钮不重叠；买不起状态温和；金币图标可读。 | 商品卡片挤压、价格遮挡按钮、关闭路径被标题 / 商品覆盖、出现限时促销压力。 |
| 小屋视图 | 进入 Home Room | Sunny、家具、房间网格、底栏和返回路径不互相遮挡；家具操作条不压住 Sunny 或核心家具。 | 家具按钮盖住宠物碗 / 小床，底栏挡住摆放格，返回路径不可见。 |
| 家具操作 | 选择 / 摆放 / 旋转 / 收起家具 | 操作按钮触控目标建议不低于 `48x48`；非法位置反馈温和；按钮含义清楚。 | 旋转 / 收起 / 关闭混淆，按钮太小，反馈像失败惩罚或工程错误。 |
| 相册覆盖层 | 打开相册 | 相册标题、卡片、故事短句和关闭按钮可读；A-Z 表现为小镇发现，不是测验。 | 卡片文字溢出，关闭按钮被卡片挡住，出现正确率 / 测试 / 背词表达。 |
| NPC 对话 | Mina、店长、Sunny、故事熊、巴士哥哥 | 头像 / 名字 / 短句 / 关闭或继续按钮不重叠；文本 1-2 行优先。 | 对话框挡住所有地图上下文，文本过长溢出，NPC 像老师或打卡监督。 |
| Anchor 互动 | A/B/C/D/K/O/S/T/W 任一核心 anchor | Anchor 物件、互动提示、相册提示不被 HUD / 底栏遮挡；英文只作标签。 | Anchor 变成裸字母牌、课程入口或 Letter Snake 主线提示。 |

### 较小横屏视口检查表

建议先用 `960x540` 作为较小横屏复核基准。该视口不是只看缩放是否能显示，而是检查布局是否仍适合儿童触屏。

| 检查项 | 通过标准 | 失败判定 |
|---|---|---|
| 安全区 | 顶部 HUD、设置入口、关闭按钮与屏幕边缘保持可触控余量；不贴边到容易误触或被系统手势覆盖。 | 按钮贴屏幕边缘、关闭按钮半截不可见、HUD 被裁切。 |
| 主按钮尺寸 | 常驻按钮目标建议不低于 `56x56`；二级关闭 / 返回按钮建议不低于 `48x48`。 | 需要精细点击才能命中，按钮与相邻按钮间距不足。 |
| 文本溢出 | HUD 今日状态、按钮短标签、商品名、相册标题、对话短句不越界；必要时换行或省略，但不能遮挡下一项。 | 文本压到图标 / 按钮 / 价格 / 关闭路径上，或出现不可读的压缩字。 |
| 地图可见性 | 小镇首屏仍能看出 Home、Town Plaza、Shop、主路、玩家 / Mina / Sunny 和至少一个资源点或 anchor。 | UI 占据主要画面，地图退回信息面板感。 |
| 弹层尺寸 | 背包、商店、相册、小屋操作面板在较小视口下保留关闭路径，内容可滚动时关闭按钮固定可见。 | 弹层超出屏幕且无法关闭，底栏和弹层互相抢点击。 |
| 遮挡关系 | 任何弹层不得同时遮挡地图主体和唯一返回路径；HUD / 底栏不遮挡关键 NPC / 资源 / anchor 互动点。 | 需要先盲点或重启才能离开弹层。 |
| 设置 / 退出 | 设置不放入底部主操作误触区；退出需要明确确认或安全位置入口。 | 退出和 `看看`、`小镇`、`小屋`、`背包` 混淆，或一键误退。 |

### 与截图清单的对应关系

| 截图路径 | 复核重点 | 关联任务 |
|---|---|---|
| 小镇首屏 | HUD、底栏、地图主体、P0 场景 / 角色素材、A-Z anchor 可见性 | `V02-POLISH-002`、`003`、`004` |
| 背包气泡 | 气泡尺寸、关闭路径、`ui_icon.bag`、物品 / 家具图标 | `V02-POLISH-002`、`003`、`004` |
| 商店货架 / 购买反馈 | 商品卡片、价格、金币、购买按钮、店长 / Shop 素材 | `V02-POLISH-002`、`003`、`004` |
| 小屋视图 / 家具操作 | Sunny、家具、宠物用品、操作按钮、返回路径 | `V02-POLISH-002`、`003`、`004` |
| 相册覆盖层 / anchor 互动 | 关闭路径、卡片文字、anchor 表现不测验化 | `V02-POLISH-002`、`003`、`004` |
| NPC 对话 / 资源收集 | 对话短句、收集反馈、资源图标可读 | `V02-POLISH-002`、`003`、`004` |

## V02-POLISH-004 首批素材替换验收

### 替换优先级

P0 是发布前最小替换包，必须优先进入 `production` 或 `approved` 状态并完成截图验收。

| 优先级 | 逻辑 asset ID | 对象 | 验收场景 | 通过标准 |
|---|---|---|---|---|
| P0 | `place.town_plaza.day` | Town Plaza 白天场景 | 小镇首屏 `1280x720`、较小横屏 | 首屏像温暖 storybook / cozy town，不像调试网格或程序色块；给角色、NPC、anchor 留出空间。 |
| P0 | `place.home.exterior` | Home 外观 | 小镇首屏 / Home 附近 | Home 是清楚的归属入口，不遮挡 HUD / 底栏，门口触发区可读。 |
| P0 | `place.shop.exterior` | Shop 外观 | Shop 附近 / 商店打开前 | 孩子能判断这里可以买生活物品；入口不被 NPC、底栏或资源点遮挡。 |
| P0 | `place.road.main` | 主道路 | 小镇首屏 | 可走方向自然，连接 Home、Town Plaza、Shop；道路不抢过角色和 anchor 层级。 |
| P0 | `place.resource.branch` | 树枝资源点 | 资源收集截图 | 树枝可被识别为地图材料，不像 UI 图标贴片；收集前后反馈温和。 |
| P0 | `character.player.standing` | 玩家地图形象 | 小镇首屏 / 资源点附近 | 尺寸、脚底锚点和道路层级自然；不遮挡 HUD、底栏或资源点。 |
| P0 | `character.mina.standing` | Mina 地图形象 | Town Plaza / NPC 对话前 | 与玩家同屏比例协调，像小镇朋友，不像老师或系统助手。 |
| P0 | `pet.sunny.standing` | Sunny 地图 / 小屋形象 | Home / Town Plaza / Home Room | Sunny 可爱清楚，不与资源点或 UI 图标混淆；不遮挡交互热点。 |
| P0 | `ui_icon.coin` | 金币图标 | HUD / Shop 面板 | 小尺寸清楚，和数值至少留出稳定间距；不像成绩徽章。 |
| P0 | `ui_icon.bag` | 背包按钮图标 | 底栏 / 背包气泡 | 入口语义清楚，normal / pressed / disabled 或等价状态稳定，不和商店 / 相册混淆。 |

P1 应紧跟 P0，用于核心路径完整观感：

| 优先级 | 逻辑 asset ID | 对象 | 验收场景 |
|---|---|---|---|
| P1 | `place.bookshop.exterior` | Bookshop 外观 | Bookshop / 故事熊 / B Bear 回访 |
| P1 | `place.bus_stop.exterior` | Bus Stop 外观 | Bus Stop / T Taxi 回访 |
| P1 | `character.shopkeeper.standing` | 店长 | Shop 附近 |
| P1 | `character.story_bear.standing` | 故事熊 | Bookshop / Bear Corner |
| P1 | `character.bus_helper.standing` | 巴士哥哥 | Bus Stop |
| P1 | `furniture.small_table.placed` | 小桌 | Home Room 家具摆放 |
| P1 | `furniture.pet_bowl.placed` | 宠物碗 | Home Room / Sunny 照顾 |
| P1 | `furniture.sunny_bed.placed` | Sunny 小床 | Home Room / Sunny 等待 |
| P1 | `ui_icon.shop` | 商店图标 | Shop 入口 / 商店面板 |
| P1 | `ui_icon.close` | 轻关闭图标 | 背包 / 商店 / 相册弹层 |
| P1 | `ui_icon.settings` | 设置图标 | HUD 安全位置 / 设置弹层 |

P2 可在 P0 / P1 稳定后补齐，例如 `place.road.side_path`、`place.resource.pebble`、`place.resource.wildflower`、`furniture.rug_round.placed`、`furniture.flower_pot.placed`、`ui_icon.album`、`ui_icon.exit`、天气 / 节日轻物件和角色头像 / 表情变体。

### A-Z Anchor 替换边界

- 首批 A/B/C/D/K/O/S/T/W anchor 可替换为更完整素材，但逻辑 ID、核心地点和回访路径必须稳定。
- Anchor 素材应是小镇生活物件，例如 Apple Tree、Bear Corner、Clock Tower、Kite、Orange Shelf、Sun Patch、Taxi Marker、Watch Table。
- 不得把 anchor 做成悬浮字母、测验牌、课程门、成绩墙或 Letter Snake 主线入口。
- 替换后必须在 `1280x720` 和较小横屏截图中确认：anchor 可见但不抢主 UI，不遮挡玩家、NPC、资源点和返回路径。

### 素材接入记录字段

后续每个接入条目至少记录以下字段。资源路径只允许作为 `ThemeProfile` / `AssetResolver` 映射记录，不得成为玩法脚本引用依据。

| 字段 | 说明 |
|---|---|
| `record_id` | 稳定接入记录 ID，例如 `asset_accept_2026_06_05_place_town_plaza_day`。 |
| `logical_asset_id` | 必填，例如 `place.town_plaza.day`、`character.mina.standing`、`ui_icon.bag`。 |
| `category` | 角色 / 宠物 / 小镇场景 / A-Z anchor / 家具 / UI 图标 / 音效。 |
| `object_id` | 稳定对象 ID，例如 `town_plaza`、`mina`、`sunny`、`a.apple_tree`。 |
| `status` | `placeholder`、`draft`、`production`、`approved`。 |
| `resolver_mapping_owner` | 负责维护 `ThemeProfile` / `AssetResolver` 映射的小组或人员。 |
| `resource_path_for_mapping` | 可选，供 resolver 映射使用的资源路径；不得被玩法脚本硬编码。 |
| `replacement_target` | 替换的占位对象、现有逻辑 ID 或截图中的问题区域。 |
| `viewport_evidence` | `1280x720`、较小横屏或录屏证据路径 / 编号。 |
| `screenshot_area` | 小镇首屏、Shop、Home Room、Album、Anchor route 等。 |
| `acceptance_result` | `pass`、`needs_fix`、`blocked`。 |
| `notes_child_safety` | 是否存在压力文案、陌生人社交、课程 / 测验表达或不适合儿童的视觉。 |
| `notes_anchor_integrity` | 若涉及 A-Z，记录是否保持核心路线、地点、故事和逻辑 ID。 |

### `production` / `approved` 验收标准

| 状态 | 进入条件 | 截图 / 记录要求 | 不通过条件 |
|---|---|---|---|
| `production` | 尺寸、透明边缘、锚点、状态切图和导出规范基本稳定；可进入游戏集成和较完整体验验证。 | 至少有 `1280x720` 截图；移动端触控不被该素材遮挡；`ThemeProfile` / `AssetResolver` 有映射记录或明确待接入记录。 | 素材比例明显错、透明边缘脏、锚点漂移、遮挡关键 UI / 角色、风格偏离 storybook / cozy town。 |
| `approved` | Art Direction / PM 确认可作为当前 V02 正式素材；只允许修 bug、压缩和适配。 | 至少通过 `1280x720` 和较小横屏截图；接入记录完整；若是 UI 图标，还需 normal / pressed / disabled 或等价状态验收。 | 仍像占位、需要重画、未授权 IP / 商标 / 照片、A-Z 编码被破坏、玩法脚本硬编码路径。 |

### 发布前截图门槛

首批素材替换后至少补以下证据：

| 截图编号 | 视口 | 场景 | 必须可见 | 不能出现 |
|---|---|---|---|---|
| `shot_polish004_town_1280` | `1280x720` | 小镇首屏 | `place.town_plaza.day`、`place.home.exterior`、`place.shop.exterior`、`place.road.main`、玩家、Mina、Sunny、HUD、底栏 | 调试网格感、工程文案、A-Z 裸字母测验牌、HUD / 底栏遮挡主路。 |
| `shot_polish004_town_small` | `960x540` 或 PM 指定较小横屏 | 小镇首屏 | P0 场景和角色仍可读，主按钮可触控 | 文本溢出、按钮贴边、地图主体被 UI 吃掉。 |
| `shot_polish004_shop_1280` | `1280x720` | Shop / 商店面板 | Shop 外观、店长或货架、金币、商品图标、购买按钮、关闭按钮 | 价格遮挡、限时压力、硬促销、买不起羞辱。 |
| `shot_polish004_home_1280` | `1280x720` | Home Room / 家具操作 | Sunny、宠物碗 / 小床 / 小桌、家具操作按钮、返回路径 | 家具穿层、按钮遮挡 Sunny、关闭路径不可见。 |
| `shot_polish004_album_anchor_1280` | `1280x720` | Anchor 互动 / 相册 | 一个核心 anchor、相册卡片、关闭按钮、中文短故事 | 测验、正确率、课程入口、重写核心 anchor。 |

## 验收结论模板

```text
任务：
视口：
场景 / 入口路径：
关联截图编号：
检查结论：pass / needs_fix / blocked
发现问题：
涉及逻辑 asset ID：
AssetResolver / ThemeProfile 映射是否合规：
A-Z anchor 是否保持稳定：
儿童安全文案 / 视觉风险：
下一步 Owner：
```

## 本草案完成判定

- `V02-POLISH-003`：已具备 `1280x720` 与较小横屏检查表，覆盖按钮尺寸、遮挡、安全区、文字溢出、弹层关闭路径和 HUD / 底栏检查项，可转换为 focused UI test 或 MCP 截图验收。
- `V02-POLISH-004`：已具备首批素材替换优先级、接入记录字段、`production` / `approved` 验收标准和截图门槛；P0 覆盖任务包要求的 10 个逻辑 asset ID。
- 本草案未生成素材、未改运行时代码、未改 JSON、未修改 A-Z 核心 anchor。
