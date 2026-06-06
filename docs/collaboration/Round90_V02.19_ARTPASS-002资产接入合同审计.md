# Round90 V02.19 ARTPASS-002 资产接入合同审计

> 日期：2026-06-06  
> 任务：`V02-ARTPASS-002 实际地图与 P0 资产清单 / 接入合同审计`  
> 状态：审计记录建立；后续可进入 P0 资产生产 / 接入分派  
> 验收视口：后续所有未完成验收只以 `1280x720` 为阻塞门槛；`960x540` 等全部开发完成后再做版本适配专项。

## 1. 审计结论

当前 runtime 地图已经迁移到 Home 居中的 `60x34` 网格，`cell_size` 为 `32x32`。V02.19 art pass 不再重排 A-Z，不改 `anchor_id`、`letter`、`core_word`、`route_order`、`card_id` 或相册语义。

已有 production 映射覆盖了：

- P0/P1 基础场景：`place.town_plaza.day`、`place.home.exterior`、`place.shop.exterior`、`place.road.main`、`place.resource.branch`
- 首批角色 / 宠物：`character.player.standing`、`character.mina.standing`、`character.shopkeeper.standing`、`character.story_bear.standing`、`character.bus_helper.standing`、`pet.sunny.standing`
- 小屋家具：`furniture.small_table.placed`、`furniture.pet_bowl.placed`、`furniture.sunny_bed.placed`
- UI 图标：`ui_icon.coin`、`ui_icon.bag`、`ui_icon.shop`、`ui_icon.close`、`ui_icon.settings`

主要缺口是：

- 地图 9 个 place 仍使用 `landmark_*_placeholder` 字段，没有统一的 `place.*` runtime asset contract。
- 26 个 A-Z anchor 还没有 `anchor.*` 主题映射；当前地图只靠 runtime 程序对象和字母徽章表达。
- Home-centered 区域块、School / Morning Walk、Story + Culture Bridge、Animal Park、Coast Edge 仍缺 production 底图或区域块逻辑 ID。
- UI 图标还缺 `ui_icon.album`、宠物状态 / 点心等后续高频入口图标。

## 2. Runtime Place 接入清单

| runtime place | 当前角色 | 当前占位 | 建议 logical asset ID | 优先级 | 后续接入方式 | 1280 验收点 |
|---|---|---|---|---|---|---|
| `place_home` | Home Core / 回家中心 | `landmark_home_placeholder` | `place.home.exterior`、`place.home.yard` | P0 | 已有 `place.home.exterior` 映射；补 `place.home.yard` 用于 Home 周边地块 | Home 居中清楚，A/C/D/W/T 不被房子压住 |
| `place_home_school_walk` | 晨路 / 上学路 | `landmark_home_school_walk_placeholder` | `place.home_school_walk.day` | P0 | 新增 place asset；接入晨路区域块和路牌 | 从 Home 到 School 的主路可读，不像课程路线 |
| `place_school_gate` | School Gate | `landmark_school_gate_placeholder` | `place.school_gate.exterior` | P0 | 新增 place asset；与 G Gate anchor 协同 | 校门是生活入口，不是封锁或迟到压力 |
| `place_school_yard` | School Yard | `landmark_school_yard_placeholder` | `place.school_yard.day` | P0 | 新增 place asset；保留 K/N/R/Y 空间 | 操场 / 活动角可读，不像课堂或考试 |
| `place_sun_scene` | Morning Sun Landmark | `landmark_sun_scene_placeholder` | `place.sun_scene.morning` | P1 | 新增小型晨光地标；不做独立区域 | S Sun 是晨路视觉地标，不抢 P0 路线 |
| `place_town_start` | Story + Culture Bridge | `landmark_town_start_placeholder` | `place.story_culture_bridge.day` | P1 | 新增区域块，后续拆 Bookshop / Theatre / Music Corner | B/Q/V 有故事感，不像阅读测验 |
| `place_supermarket` | Shop Street | `landmark_supermarket_placeholder` | `place.shop_street.day`、`place.shop.exterior` | P1 | 已有 shop 外观；补整条街区底图 | H/I/O/J 作为商店街生活物件可读 |
| `place_animal_park` | Animal Park + Zoo Corner | `landmark_town_start_placeholder` | `place.animal_park.day` | P1 | 新增动物公园区域块 | E/F/L/M/P/Z 聚合成公园，不变远郊主线 |
| `place_coast_edge` | Beach / Coast Edge | `landmark_town_start_placeholder` | `place.coast_edge.day` | P2 | 新增边缘预览底图 | U/X 是边界预览，不引导独自远行 |

## 3. A-Z Anchor Asset Contract

建议在 `ThemeProfile` 增加 `anchor_assets` 分类，并在 `AssetResolver` 增加 `get_anchor_asset()`；若短期不改 loader，也可以先把 `anchor.*` 放入 `place_assets`，但后续正式接入建议独立分类，避免锚点物件和区域底图混在一起。

| letter | anchor_id | core word | zone | 建议 logical asset ID | 状态 | 1280 验收点 |
|---|---|---|---|---|---|---|
| A | `anchor_a_apple` | Apple | Home Core | `anchor.a.apple_tree` | missing | 先像苹果树 / 苹果物件，不靠裸 A |
| B | `anchor_b_bear` | Bear | Story Bridge | `anchor.b.bear_corner` | missing | Bear Corner 是故事角，不像阅读测试 |
| C | `anchor_c_clock` | Clock | Home Core | `anchor.c.clock` | missing | Clock 靠近 Home，避开“回家”标识遮挡 |
| D | `anchor_d_dog` | Dog | Home Core | `anchor.d.dog_corner` | missing | 与 Sunny / 宠物照顾自然绑定 |
| E | `anchor_e_elephant` | Elephant | Animal Park | `anchor.e.elephant_slide` | missing | 动物公园装置，不引导危险攀爬 |
| F | `anchor_f_fox` | Fox | Animal Park | `anchor.f.fox_topiary` | missing | 狐狸灌木 / 小雕塑，温和不惊吓 |
| G | `anchor_g_gate` | Gate | School Gate | `anchor.g.school_gate` | missing | Gate 是安全入口，不是资格检查 |
| H | `anchor_h_hat` | Hat | Shop Street | `anchor.h.hat_sign` | missing | 橱窗 / 招牌物件，不评价穿着 |
| I | `anchor_i_ice_cream` | Ice cream | Shop Street | `anchor.i.ice_cream_cart` | missing | 像小车 / 贴纸，不强制消费 |
| J | `anchor_j_jacket` | Jacket | Shop Street | `anchor.j.jacket_window` | missing | 商店橱窗生活物件 |
| K | `anchor_k_kite` | Kite | School Yard | `anchor.k.kite` | missing | 天空 / 操场可读，避开校区标签 |
| L | `anchor_l_lion` | Lion | Animal Park | `anchor.l.lion_fountain` | missing | 安静景物，不引导靠近水边 |
| M | `anchor_m_monkey` | Monkey | Animal Park | `anchor.m.monkey_tree` | missing | 不表现爬树或危险模仿 |
| N | `anchor_n_net` | Net | School Yard | `anchor.n.soft_net` | missing | 软网 / 活动角，不做输赢比赛 |
| O | `anchor_o_orange` | Orange | Shop Street | `anchor.o.orange_stall` | missing | 果摊 / 橙子箱，不被商店牌遮挡 |
| P | `anchor_p_panda` | Panda | Animal Park | `anchor.p.panda_corner` | missing | 休息角，不评价表现 |
| Q | `anchor_q_queen` | Queen | Story Bridge | `anchor.q.queen_poster` | missing | 故事海报，不涉及身份优劣 |
| R | `anchor_r_robot` | Robot | School Yard | `anchor.r.robot_sign` | missing | 工具角导视，不开放聊天或评分 |
| S | `anchor_s_sun` | Sun | Sun Scene | `anchor.s.sun_landmark` | missing | 小晨光地标，不压住“太阳”区域名 |
| T | `anchor_t_taxi` | Taxi | Home Core | `anchor.t.taxi_marker` | missing | Home 车道 / 小标记，不引导离开 |
| U | `anchor_u_umbrella` | Umbrella | Coast Edge | `anchor.u.beach_umbrella` | missing | 海边伞，避开 coast sign |
| V | `anchor_v_violin` | Violin | Story Bridge | `anchor.v.violin_corner` | missing | 音乐角，不做演奏评分 |
| W | `anchor_w_watch` | Watch | Home Core | `anchor.w.watch_table` | missing | Home 日常物件，和 Clock 区分 |
| X | `anchor_x_x_mark_box` | X-mark Box | Coast Edge | `anchor.x.x_mark_box` | missing | 失物箱预览，不写宝藏竞争 |
| Y | `anchor_y_yo_yo` | Yo-yo | School Yard | `anchor.y.yo_yo_corner` | missing | 玩具收纳角，不做技巧挑战 |
| Z | `anchor_z_zebra` | Zebra | Animal Park | `anchor.z.zebra_edge` | missing | 动物园边缘预览，不进 P0 每日路线 |

## 4. P0/P1 资产分派建议

### ARTPASS-003：视觉方向确认包

正式生产前先补视觉方向确认：

- 主玩法屏：Animal Crossing-like cozy town，Home-centered world map，区域层级和道路像可生活的小镇，不像绘本内页、故事书插画或课程地图。
- UI：Apple-like translucent glass，覆盖顶部 HUD、底部操作栏、轻弹层、关闭 / 返回按钮、图标 + 短文本组合；透明但必须可读。
- 样张：至少覆盖一组角色 / Sunny、一组 P0 anchor 物件、一组地图区域块和一组 glass UI 控件。
- 规则：明确色彩、线条、材质、阴影、透明度、触控态、禁用方向和 1280x720 截图判断口径。

### ARTPASS-004：世界地图底图与区域块

必须先接：

- `place.home.yard`
- `place.home_school_walk.day`
- `place.school_gate.exterior`
- `place.school_yard.day`
- `place.shop_street.day`
- `place.animal_park.day`
- `place.coast_edge.day`

可沿用已有：

- `place.town_plaza.day`
- `place.home.exterior`
- `place.shop.exterior`
- `place.road.main`
- `place.resource.branch`

### ARTPASS-005：26 Anchor 物件

先做 P0/P1 高可见组：

- Home Core：A/C/D/W/T
- School line：G/K/N/R/Y/S
- Shop Street：H/I/O/J
- Story Bridge：B/Q/V

再做 Animal Park / Coast Edge：

- Animal Park：E/F/L/M/P/Z
- Coast Edge：U/X

### ARTPASS-006：角色 / 宠物 / UI

已有 standing 生产映射可继续使用。新增建议：

- `character.player.portrait`
- `character.mina.portrait`
- `character.shopkeeper.portrait`
- `character.story_bear.portrait`
- `character.bus_helper.portrait`
- `pet.sunny.happy`
- `pet.sunny.waiting`
- `pet.sunny.portrait`
- `ui_icon.album`
- `ui_icon.pet_status`
- `ui_icon.pet_snack`

## 5. 接入与验证门槛

- 不批量生成不可接入素材；先补 logical asset ID、目标目录和 ThemeProfile 映射。
- 不硬编码 `res://assets/art/...` 到 runtime 脚本；运行时只通过 `AssetResolver` 请求 logical asset ID。
- 不把 `production` 自动等同于 `approved`；`approved` 至少需要 1280x720 证据和 PM / Art Direction 判断。
- 不移动或重命名 26 个核心 anchor；换图只能换视觉，不换记忆宫殿编码。
- 960x540 不作为后续未完成任务验收阻塞；全部开发完成后作为独立版本适配专项处理。

建议验证命令：

```bash
godot --headless --path . --script tests/test_asset_resolver.gd
godot --headless --path . --script tests/test_v0218_map_readability.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```
