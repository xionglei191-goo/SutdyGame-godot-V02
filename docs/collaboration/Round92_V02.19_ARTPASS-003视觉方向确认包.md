# Round92 V02.19 ARTPASS-003 视觉方向确认包

> 日期：2026-06-06  
> 任务：`V02-ARTPASS-003 视觉方向确认包`  
> 状态：方向包建立，供 `V02-ARTPASS-004` 起的 production 资产生成与接入使用。  
> 验收视口：本轮只以 `1280x720` 作为阻塞性视觉确认；`960x540` 留到全部开发完成后的版本适配专项。

## 1. 方向结论

V02.19 后续正式资产生产方向固定为：

- 世界视觉：Animal Crossing-like cozy town，但不复制任何外部 IP。落地表达为圆润、可生活、可回访、轻 2.5D、玩具感比例和清晰安全边界。
- UI 视觉：Apple-like translucent glass UI。落地表达为轻透明、柔和模糊、清晰边界、稳定触控态、图标 + 短文本组合和足够对比。
- Anchor 表达：A-Z anchor 首先是生活物件、地点装置或环境线索，字母徽章只能辅助识别，不能变成大字母牌、课程入口或打卡目标。
- 英文表达：继续作为环境层、物件名、短句和相册标签，不成为课程页、练习、测试、评分或主流程门槛。

正式生产禁用方向：

- 绘本内页、storybook / picture-book 叙事插画、纸张纹理、水彩边缘、厚重纸质卡片。
- 课程应用面板、单元页、词表墙、测验、正确率、分数、排名、打卡或完成率。
- 黑暗、恐吓、危险攀爬、独自远行压力、限时运营或强消费暗示。
- 大面积单一米色 / 棕橙 / 深蓝主题；后续配色必须保持明亮但有多色平衡。

## 2. 方向样张

| 样张 | 文件 | 用途 | 判断 |
|---|---|---|---|
| 主玩法屏方向稿 | `docs/collaboration/artpass003_visual_direction/artpass003_main_gameplay_direction_1280.png` | 说明 Home-centered 地图、School / Shop / Animal Park / Coast Edge、道路层级和 glass HUD 的同屏关系 | 可作为整体世界方向参考；偏精致 3D 渲染，后续 production 资产可降低细节密度以适配 Godot runtime |
| Glass UI 方向稿 | `docs/collaboration/artpass003_visual_direction/artpass003_glass_ui_direction_1280.png` | 说明顶部 HUD、底部按钮、轻弹层、背包 / 相册 / 商店类面板的 translucent glass 方向 | 可作为 UI 皮肤方向参考；正式实现必须替换成项目图标、Sunny 头像和中文短文本，不保留生成图里的占位符 |
| 角色 / Anchor 物件样张 | `docs/collaboration/artpass003_visual_direction/artpass003_character_anchor_direction_1280.png` | 说明角色比例、Sunny / 居民友好度、Apple / Clock / Gate / Kite / Orange / Bear / Umbrella / Panda 等 anchor 的物件化边界 | 可作为角色与物件比例参考；正式 Sunny、NPC 和 anchor 需按 logical asset ID 单独生产，不直接切图复用 |

三张样张都只是 visual direction reference，不是 runtime 资产，不标记为 `production` 或 `approved`。后续若生成可接入素材，必须另存到资产目录并通过 `ThemeProfile` / `AssetResolver` 映射。

## 3. 风格规则

### 世界地图

- 摄像机和构图：轻 2.5D / 俯视斜角，能看清道路、门口、地块边界和可互动对象。
- 比例：玩家和 Sunny 必须小而可读；Home、School、Shop、Animal Park 不应压住 anchor 热点。
- 区域层级：Home Core 最清楚；Home-School Walk 是安全主路；Shop Street 和 Story Bridge 是第一圈生活地点；Animal Park / Coast Edge 是回访或边界预览。
- 材质：干净圆润、柔和阴影、边缘清楚；避免纸质纹理、涂抹笔触或插画页装饰。
- 配色：暖但不泛黄，绿地、屋顶、道路、水边、UI 高光需要分层；不得让整屏读成单一奶油 / 棕橙色。

### UI / HUD

- 容器：半透明白 / 冷白 glass，轻微模糊，1px-2px 高光边，柔和阴影；面板不做厚重卡片。
- 顶部 HUD：只承载小镇状态、金币 / 宠物 / 今日提示等高频信息；短文本必须可读，不堆大段说明。
- 底部操作栏：继续服务 `看看`、`小镇`、`小屋`、`背包` 等真实入口；图标优先，短标签辅助。
- 弹层：背包、相册、商店、设置都用轻 glass 面板；关闭按钮位置稳定，触控目标不低于既有移动端门槛。
- 状态：normal / pressed / disabled 必须有轻微但明确反馈；禁止红色警报、倒计时、任务强提醒。

### 角色 / 宠物

- 角色：圆润、日常服装、友好表情、孩子可代入；不成人化、战斗化、病弱化或过度夸张。
- Sunny：小型友好陪伴宠物，轮廓和玩家 / NPC / UI 图标区分清楚；不表现疾病、受伤、惩罚或攻击。
- NPC：Mina、Shopkeeper、Story Bear、Bus Helper 都是温和居民；店长不制造强消费，Bus Helper 不引导独自远行。

### Anchor 物件

- A/C/D/W/T Home Core：像家附近生活物件，不被 Home 外观和回家按钮遮挡。
- G/K/N/R/Y/S School line：像校门、操场玩具、软网、工具角和晨光地标，不像课堂道具或资格检查。
- H/I/O/J Shop Street：像橱窗、果摊、小车和生活商品，不强制购买。
- B/Q/V Story Bridge：像故事角、海报、音乐角，不做阅读测验或表演评分。
- E/F/L/M/P/Z Animal Park：像安全园区装置、休息角、雕塑或远景，不引导危险模仿。
- U/X Coast Edge：只作边界预览和相册世界感，不做每日必到或独自远行目标。

## 4. 后续生产门槛

`V02-ARTPASS-004` 开始生成和接入 production 资产前，必须满足：

- 资产有 stable logical asset ID、目标目录、建议尺寸、用途、状态和截图验收点。
- 资产路径只能通过 `ThemeProfile` / `AssetResolver` 接入，runtime 不硬编码 `res://assets/...`。
- 每批接入后先做 1280x720 截图判断：不遮挡 HUD / 底栏、不压住玩家和热点、不退回裸字母牌、不出现课程化视觉。
- `production` 只表示可集成；`approved` 需要 1280x720 证据和 PM / Art Direction 判断。
- 若生成资产与本方向包冲突，以本方向包的禁用方向和 `todo.md` 的生活 RPG / 小镇养成边界为准。

## 5. 生成记录

本轮使用项目本地 fallback 脚本生成方向样张：

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "<prompt>" "<output.png>" "1280x720"
```

输出目录：

```text
docs/collaboration/artpass003_visual_direction/
```

本轮未改运行时代码、数据合同或 `ThemeProfile` 映射。样张不会被 Godot runtime 直接加载。
