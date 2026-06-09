# Round167 V02.39 VISUALREBUILD-002 Img2Img Style Reference Test

> 日期：2026-06-08
> 任务：`V02-VISUALREBUILD-002 1280 目标画面与 Godot 可执行视觉合同`
> 范围：图生图资产 sheet 测试；不接 runtime，不改 ThemeProfile，不授予 `art_target_locked`

## 1. 输入

用户指定的 style reference：

`/home/xionglei/.codex/generated_images/019ea1f9-af6a-74a1-95f8-8ba7a1f4db32/ig_0d7553c9c33ca64f016a257d184bb8819dbd188a1d01cc3df4.png`

文件事实：

- `1672x941`
- `PNG`
- `RGB`
- 用途：style reference / visual lock
- 禁止：直接截图切 runtime、作为 full-map background、作为 target frame 通过证据

## 2. 生成方式

使用项目本地脚本：

```bash
node /home/xionglei/GameProject/tools/image_generator.js edit <source.png> "<prompt>" null <output.png>
```

本轮生成三张 1024x1024 RGB sheet：

| Sheet | 文件 | 目的 |
|---|---|---|
| Terrain | `round167_img2img_terrain_tile_sheet_v001.png` | grass / path / edge / water-bank / detail tile 风格测试 |
| Environment Props | `round167_img2img_environment_prop_sheet_v001.png` | Home / tree / fence / mailbox / garden / pond / A-Z prop 风格测试 |
| UI Icons | `round167_img2img_ui_icon_sheet_v001.png` | glass button 与 dock icon 风格测试 |

三张原图均为 RGB，无 alpha。

## 3. 后处理

使用 `imagegen` skill 的 chroma-key helper 对白 / 暖白背景做一次清底候选：

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/imagegen/scripts/remove_chroma_key.py" \
  --input <rgb_sheet.png> \
  --out <rgba_candidate.png> \
  --auto-key border \
  --soft-matte \
  --transparent-threshold 12 \
  --opaque-threshold 220 \
  --despill
```

输出：

| Sheet | RGBA candidate | 结果 |
|---|---|---|
| Terrain | `round167_img2img_terrain_tile_sheet_v001_rgba_candidate.png` | 可生成 alpha，但 tile 边缘与暖白底混合较多，需要人工切片和 tileability 复核 |
| Environment Props | `round167_img2img_environment_prop_sheet_v001_rgba_candidate.png` | 清底相对可用，适合作为 manual crop 候选 |
| UI Icons | `round167_img2img_ui_icon_sheet_v001_rgba_candidate.png` | 失败；白底清底破坏浅色 glass 内部和高光 |

## 4. 视觉复核结论

### Terrain

优点：

- 不再是完整 gameplay 场景。
- 草地、道路、水岸、细节 tile 独立分格。
- 颜色和参考图接近，适合作为 tile style direction。

问题：

- 尚未证明无缝重复。
- 部分 tile 有绘制边缘，不一定适合 TileSet 自动拼接。
- alpha 候选半透明像素过多，不能直接进 runtime。

状态：`promising_style_test_needs_tileability_review`

### Environment Props

优点：

- Home、tree、fence、mailbox、flower、garden、pond、apple basket、clock、companion 均独立可见。
- 风格统一，最接近可进入手工 crop / scale review 的方向。
- 没有文字、UI 或完整场景污染。

问题：

- Home 仍偏精细，需要确认是否降到 Godot first-screen 可编辑 prefab 粒度。
- 需要人工 crop、统一 pivot、feet / ground baseline 和 shadow 策略。

状态：`best_candidate_for_manual_crop_and_scale_review`

### UI Icons

优点：

- RGB 原图的 icon 识别度较好。
- 五按钮 dock 所需 look / town / home / backpack / album 方向基本可读。

问题：

- 白底清底不适合 glass UI：浅色按钮底和高光会被错误扣掉。
- 后续 UI icon 不能用白底清底，应改用非主体色 chroma key 或真正透明输出。

状态：`rgb_style_ok_rgba_candidate_failed_for_glass`

## 5. Gate 判定

本轮不授予：

- `art_target_locked`
- `runtime_visual_match`
- `final_approved`
- `production`
- `asset_acceptance.pass`

本轮只确认：

- 图生图 + style reference 是可行的资产生产主路径候选。
- 输出必须是独立 sheet，而不是完整 gameplay PNG patch。
- RGB 输出仍需 alpha / crop / manifest / tileability / scale / runtime screenshot 复核。
- UI glass 资产不能用白底清底作为默认透明化方案。

## 6. 下一步

1. 对 environment props 人工挑选 10-20 个候选 crop。
2. terrain sheet 先做 tileability 复核，不直接进入 TileSet。
3. UI icon sheet 重新生成，prompt 明确使用 chroma-key 背景或透明路径，避免白色 glass 被扣掉。
4. 任何候选进入 runtime 前，必须经过 logical asset ID、ThemeProfile 映射、AssetResolver、1280 first-screen screenshot 和 no-full-map / no-scene-patch 回归。
