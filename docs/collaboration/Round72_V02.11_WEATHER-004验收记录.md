# Round 72 V02.11 WEATHER-004 验收记录

> 日期：2026-06-05  
> 任务：`V02-WEATHER-004 天气纵切 smoke 与双视口截图`  
> 结论：通过  

## 验收范围

- 多天气 day_key 玩家路径 smoke，覆盖晴天、微风、小雨、雨后四类 P0 天气事件。
- P0 Home / Shop / 小屋 / Mina / 相册 / A-Z 天气线索路径不阻断。
- S Sun、K Kite、B Bear、U Umbrella 天气相册线索继续通过真实 `看看` 路径落账。
- 1280x720 与 960x540 代表截图取证。

## 交付物

- `tests/test_v0211_weather_slice_smoke.gd`
- `tests/capture_weather004_screens.gd`
- `tests/headless_runner.gd` 中 `_check_v0211_weather_slice_smoke()` 集成断言
- `docs/collaboration/weather004_captures/`

## 验证命令

```bash
find data -name '*.json' -print0 | xargs -0 jq empty
godot --headless --path . --check-only --script tests/test_v0211_weather_slice_smoke.gd
godot --headless --path . --check-only --script tests/capture_weather004_screens.gd
godot --headless --path . --check-only --script tests/headless_runner.gd
godot --headless --path . --script tests/test_v0211_weather_slice_smoke.gd
godot --headless --path . --script tests/headless_runner.gd
godot --display-driver x11 --rendering-driver opengl3 --resolution 1280x720 --path . --script tests/capture_weather004_screens.gd -- --output-dir docs/collaboration/weather004_captures --suffix 1280
godot --display-driver x11 --rendering-driver opengl3 --resolution 960x540 --path . --script tests/capture_weather004_screens.gd -- --output-dir docs/collaboration/weather004_captures --suffix 960
godot --headless --path . --quit
ps -ef | rg 'godot --headless --path \. --script tests/' || true
```

## 验证结果

- JSON、check-only、focused smoke、全量 headless runner 和 Godot headless 启动均通过。
- 非 headless `x11` / `opengl3` 路径成功导出 12 张截图，覆盖 1280x720 与 960x540。
- 无残留 headless 测试进程。

## 截图清单

- `shot_weather004_sunny_sun_1280.png` / `shot_weather004_sunny_sun_960.png`
- `shot_weather004_breezy_kite_1280.png` / `shot_weather004_breezy_kite_960.png`
- `shot_weather004_light_rain_bear_1280.png` / `shot_weather004_light_rain_bear_960.png`
- `shot_weather004_after_rain_album_1280.png` / `shot_weather004_after_rain_album_960.png`
- `shot_weather004_shop_1280.png` / `shot_weather004_shop_960.png`
- `shot_weather004_home_1280.png` / `shot_weather004_home_960.png`

## 人工抽查

- 1280x720 相册截图显示 B Bear、K Kite、S Sun、U Umbrella 已收藏；未见正确率、等级、测验或打卡文案。
- 960x540 微风 / Kite 截图中 HUD、底栏和天气相册反馈可见，未见明显贴边遮挡。
- 960x540 Shop 截图中 P0 商品仍可见，未见售罄、限时、倒计时或运营压力。
- 960x540 Home 截图中小屋入口和反馈可见，天气未阻断小屋路径。

## 风险与备注

- 截图脚本使用非 headless 显示路径取证，符合 `LESSON-010`；headless 仍只用于逻辑和合同回归。
- Godot 自动为截图生成 `.png.import` 文件，属于资源导入副产物。
