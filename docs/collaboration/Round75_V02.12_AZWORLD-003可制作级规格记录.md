# Round 75 V02.12 AZWORLD-003 可制作级规格记录

> 日期：2026-06-05  
> 任务：`V02-AZWORLD-003 17 个 reserved anchor 升级为可制作级规格`  
> 状态：验收通过  
> 事实数据：`data/maps/az_world_plan.json`

## 规格结论

17 个 reserved anchor 已进入 `reserved_anchor_specs`，状态统一为 `make_ready`。每个规格都包含真实可见入口、相册记录 ID、主视觉 logical asset ID、相册缩略图 logical asset ID 和儿童安全说明。

## 覆盖清单

| letter | anchor_id | 入口方向 | asset 要求 | 相册记录 |
|---|---|---|---|---|
| E | `anchor_e_elephant` | School Yard / Playground `看看` | `az_anchor_e_elephant_main`、`album_az_e_elephant_thumb` | `album_anchor_e_elephant_slide` |
| F | `anchor_f_fox` | Garden 转角 / 采花路线 `看看` | `az_anchor_f_fox_main`、`album_az_f_fox_thumb` | `album_anchor_f_fox_topiary` |
| G | `anchor_g_gate` | Home-School Walk / School Gate `看看` | `az_anchor_g_gate_main`、`album_az_g_gate_thumb` | `album_anchor_g_school_gate` |
| H | `anchor_h_hat` | Shop Street / Clothes Shop `看看` | `az_anchor_h_hat_main`、`album_az_h_hat_thumb` | `album_anchor_h_hat_sign` |
| I | `anchor_i_ice_cream` | Shop Street 冰淇淋车 `看看` | `az_anchor_i_ice_cream_main`、`album_az_i_ice_cream_thumb` | `album_anchor_i_ice_cream_cart` |
| J | `anchor_j_jacket` | Clothes Shop 橱窗 `看看` | `az_anchor_j_jacket_main`、`album_az_j_jacket_thumb` | `album_anchor_j_jacket_window` |
| L | `anchor_l_lion` | Bookshop Plaza `看看` | `az_anchor_l_lion_main`、`album_az_l_lion_thumb` | `album_anchor_l_lion_fountain` |
| M | `anchor_m_monkey` | Park 资源点旁 `看看` | `az_anchor_m_monkey_main`、`album_az_m_monkey_thumb` | `album_anchor_m_park_monkey` |
| N | `anchor_n_net` | School Sports Corner `看看` | `az_anchor_n_net_main`、`album_az_n_net_thumb` | `album_anchor_n_soft_net` |
| P | `anchor_p_panda` | Bookshop 休息角 `看看` | `az_anchor_p_panda_main`、`album_az_p_panda_thumb` | `album_anchor_p_panda_corner` |
| Q | `anchor_q_queen` | Theatre 海报 `看看` | `az_anchor_q_queen_main`、`album_az_q_queen_thumb` | `album_anchor_q_queen_poster` |
| R | `anchor_r_robot` | School 工具角 `看看` | `az_anchor_r_robot_main`、`album_az_r_robot_thumb` | `album_anchor_r_robot_sign` |
| U | `anchor_u_umbrella` | Park 长椅 `看看` | `az_anchor_u_umbrella_main`、`album_az_u_umbrella_thumb` | `album_anchor_u_umbrella_bench` |
| V | `anchor_v_violin` | Music Corner 小舞台 `看看` | `az_anchor_v_violin_main`、`album_az_v_violin_thumb` | `album_anchor_v_violin_corner` |
| X | `anchor_x_x_mark_box` | Far Edge 失物箱预览 `看看` | `az_anchor_x_x_mark_box_main`、`album_az_x_x_mark_box_thumb` | `album_anchor_x_mark_box` |
| Y | `anchor_y_yo_yo` | School 活动角 `看看` | `az_anchor_y_yo_yo_main`、`album_az_y_yo_yo_thumb` | `album_anchor_y_yo_yo_corner` |
| Z | `anchor_z_zebra` | Zoo Edge 花坛预览 `看看` | `az_anchor_z_zebra_main`、`album_az_z_zebra_thumb` | `album_anchor_z_zebra_edge` |

## 安全边界

- School 线 E/G/N/R/Y 可服务 Home / School 第一主线，但不得变成资格、评分或顺序检查。
- First / Second Ring anchor 只做生活回访、相册发现和环境词。
- X / Z 只作为 Far Edge 预留，不阻断 P0，也不触发独自出行。
- 运行时接入必须使用 logical asset ID；不允许在玩法脚本中硬编码图片路径。

## 验收证据

- `reserved_anchor_specs` 数量为 17。
- `scripts/data/az_world_plan_contract.gd` 验证每条规格的 visible entry、album record、logical asset IDs、`make_ready` 状态和安全文本。
- `tests/test_v0212_az_world_plan.gd` 验证 17 个 reserved anchor 均存在制作级字段。

## 下一步

进入 `V02-AZWORLD-004`，把 Home / School 0 基础词和短句挂到生活事件与 anchor 上。
