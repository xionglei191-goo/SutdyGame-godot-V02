# Round166 V02.39 VISUALREBUILD-002 Tile-editable Visual Spec

> 日期：2026-06-08
> 任务：`V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同`
> Owner：PM / Art Direction / Tech Art / UX
> 状态：返修规格；不授予 `art_target_locked`，不解锁 `V02-VISUALREBUILD-004`

## 1. 返修结论

Round161 和 Round166 的自由生图 / image-to-image 目标图均未通过用户复核。主要失败点不是“好不好看”，而是生产方式不适合 Godot runtime：

- 1024 方图不满足 1280x720 gameplay target frame。
- 1280x720 生图偏高精 3D，Home 体量过大，压缩可走空间。
- 进一步压低房屋比例后仍不够 tile-editable，难以转成 Map Editor 可编辑瓦块和 prefab。
- 手工 flat mock 虽然可切块，但偏离 `artpass003_main_gameplay_direction_1280.png` 的温暖 cozy town 质感。

因此后续不得继续靠自由生图直接追最终画面。下一步必须先把 canonical 参考翻译成 Godot 可编辑规则，再做 whitebox / spec-driven target。

## 2. Canonical Reference Retarget

正向参考仍是：

`docs/collaboration/artpass003_visual_direction/artpass003_main_gameplay_direction_1280.png`

它的作用是定义画面语言，不是 runtime 背景、切图来源或外部 IP 复制依据。Sunshine Town 需要继承：

- 温暖日光、圆润低压力小镇、轻 2.5D / flat-friendly 视角。
- Home-centered 首屏、清楚道路、树篱 / 花园 / 水岸 / 生活道具形成密度。
- 轻 glass HUD 与底部 dock 浮在世界上，而不是把世界压成应用页面。

同时必须收敛为 Godot 可执行结构：

- terrain / path / water / fence 使用重复 tile 或 4x4 chunk。
- Home / tree / garden / mailbox / companion 使用 prefab。
- A-Z 首屏只出现 prop-first 生活线索，不显示全量字母索引。
- Logic Map 继续管 cell / collision / interaction / A-Z stable ID；Visual Layout 管视觉位置、比例、层级、遮挡和显隐。

## 3. 1280 Whitebox 尺度合同

当前阻塞视口固定为 1280x720。whitebox 以现有 16px logic cell 为内部单位，但视觉镜头约 `1 logic cell ~= 24-32px screen`，孩子端不得看到 cell、grid、坐标、footprint 或编辑器术语。

| 项 | 规格 |
|---|---|
| Camera | Home-centered first screen；focus cell 约 `Vector2(31, 20)`；scale 不高于 1.6，避免旧近景裁切 |
| Home | 约 3.0-3.4 cell 宽、2.3-2.7 cell 高；首屏焦点但不占满 |
| Main path | 2-3 cells 宽的连续可走曲线；不少于 30 个可复用 path tile |
| Open grass | Home 前和中心路口保留 2 个以上 open walkable zones |
| Terrain base | 草地用 4x4 / 大块 chunk 组合，不铺裸 grid |
| Water edge | 右下或远边用 3 个以上水岸片组合，证明可拼接边界 |
| Trees | 首屏 4 个左右，作为边界和层次，不堆成森林 |
| Flowers / garden | 小花、菜园、花盆作生活密度，每组仍是可复用 prefab |
| Actor / companion | player 比 Home 小；Sunny / companion 由多个部件组成，有接触阴影 |
| HUD / footer | 顶部轻信息、底部五按钮 dock；图标优先，短中文辅助 |

## 4. Tile / Prefab 分组

### Terrain Tiles

- `v0239_grass_patch`：大块草地、Home yard、open walkable grass。
- `v0239_path_tile`：主路、Home 门口支路、Town / Shop 方向路。
- `v0239_pond_edge`：水岸角和岸边拼接。
- `v0239_grass_tuft`、`v0239_path_pebble`、`v0239_bank_stone`、`v0239_lily_pad`：地面细节，可重复摆放。

### Building Prefab

Home 必须由可替换部件组成：

- body、roof、door、steps。
- chimney、window、round window、lantern、flower box。
- soft shadow 独立于建筑主体，后续可替换统一阴影资产。

### World Props

- fence segment、mailbox、flower patch、garden bed、crop leaf、tree trunk/crown。
- 每个 prop 有明确接地点；不能像贴纸漂浮。
- A-Z 线索优先落在 Apple / Clock / Dog / Watch 等 Home 周边生活物件，badge 只在 focus 状态辅助。

### Actors

- Player / NPC / Sunny 保持 feet baseline。
- whitebox companion 允许由简单部件组成，但必须证明“角色可由 prefab 部件统一比例搭出”。

## 5. Godot Runtime Whitebox 要求

当前实现应满足：

- `TownStage` 创建 `VisualRebuildBlockoutLayer`。
- 旧 V02.38 road / place / anchor / NPC / resource / story prop / outdoor decor 可在 whitebox proof 下隐藏，不作为首屏视觉依据。
- Player layer 在 blockout 之上，真实入口仍可用。
- `get_visual_rebuild_blockout_snapshot()` 暴露 layer、tile count、prefab count、camera、legacy hidden、resolver mapping 等 QA 字段。
- V02.39 失败 PNG 样张不得通过 ThemeProfile / AssetResolver 映射回 runtime；程序 whitebox 可使用临时 `v0239_` texture key，但不得把它们标为 production asset。

Focused 验收入口：

```bash
godot --headless --path . --script tests/test_v0239_visual_rebuild_blockout.gd
```

## 6. 策划与 UX 边界

- 首屏证明“孩子回到家和小镇”，不证明完整世界索引。
- A-Z 仍是稳定 memory palace，但首屏不显示 26 个 anchor，也不把字母当主视觉。
- 英语只作为物件名、短环境线索或相册层，不进入课程面板、词表、测验、打卡或分数。
- Map Editor / Visual Layout 可使用 tile、cell、footprint 等术语；孩子端 runtime 不得显示。
- StoryBatch 继续阻塞，第二批 production story prop 不得叠到 whitebox 或未通过 target 的 runtime 上。

## 7. 下一步

Round166 规格只证明生产方法转向，不证明最终画面通过。下一步应按本规格推进：

1. 用 Godot whitebox / paintover 做 1280 gameplay target frame。
2. 由 PM / Art Direction / 用户复核是否重新达到 `art_target_locked`。
3. 通过后再进入 `V02-VISUALREBUILD-004` 首屏统一环境资产包。
4. 资产包完成后由 `V02-VISUALREBUILD-005` 做 runtime target match 和 side-by-side proof。

当前状态仍为 `V02-VISUALREBUILD-002 [~]`，不得标 `runtime_visual_match` 或 `final_approved`。
