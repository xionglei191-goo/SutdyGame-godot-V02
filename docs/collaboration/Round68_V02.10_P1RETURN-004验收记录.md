# Round 68 `V02-P1RETURN-004` P1 回访 smoke 与截图验收记录

> 日期：2026-06-05  
> 范围：V02.10 P1 居民回访扩展收口。  
> PM 结论：`pass`，P1 回访 smoke 与双视口截图证据已具备。

## 逻辑验证

新增 `tests/test_v0210_p1_return_smoke.gd`，并在 `tests/headless_runner.gd` 中以 `_check_v0210_p1_return_smoke()` 注册统一回归。

覆盖内容：

- 玩家从孩子端真实可见 `看看` 路径接取故事熊 P1 轻回访，前往 Bear Corner，再回故事熊完成。
- 玩家从孩子端真实可见 `看看` 路径接取巴士哥哥 P1 轻回访，前往 Taxi marker，再回巴士哥哥完成。
- B Bear / T Taxi 均写入 card state，并在小镇相册中显示“已收藏”。
- P1 路径后，Mina P0 日常、商店入口和小屋入口仍可用。
- 可见文本检查不出现工程文案、课程、测验、考试、评分、背诵、正确率、等级、倒计时、赶车压力、独自远行、陌生人带走、上车或错过班车。

## 截图取证

截图脚本：`tests/capture_p1return004_screens.gd`

按 `LESSON-010`，本轮使用非 headless `x11` 路径取证，headless 只作为逻辑回归与脚本语法验证。

输出目录：`docs/collaboration/p1return004_captures/`

取证命令：

```bash
godot --display-driver x11 --path . --resolution 1280x720 --script tests/capture_p1return004_screens.gd -- --output-dir docs/collaboration/p1return004_captures --suffix 1280
godot --display-driver x11 --path . --resolution 960x540 --script tests/capture_p1return004_screens.gd -- --output-dir docs/collaboration/p1return004_captures --suffix 960
```

截图清单：

| 文件 | 视口 | 场景 | 结论 |
|---|---:|---|---|
| `shot_p1return004_story_bear_request_1280.png` | `1280x720` | Story Bear 请求 | pass |
| `shot_p1return004_story_bear_request_960.png` | `960x540` | Story Bear 请求 | pass |
| `shot_p1return004_bear_corner_1280.png` | `1280x720` | Bear Corner 查看 | pass |
| `shot_p1return004_bear_corner_960.png` | `960x540` | Bear Corner 查看 | pass |
| `shot_p1return004_bus_helper_request_1280.png` | `1280x720` | Bus Helper 请求 | pass |
| `shot_p1return004_bus_helper_request_960.png` | `960x540` | Bus Helper 请求 | pass |
| `shot_p1return004_taxi_marker_1280.png` | `1280x720` | Taxi marker 查看 | pass |
| `shot_p1return004_taxi_marker_960.png` | `960x540` | Taxi marker 查看 | pass |

## 抽查判断

- `shot_p1return004_bear_corner_960.png`：HUD 与底栏可读，Bear Corner 反馈温和，地图主体未被 UI 遮挡。
- `shot_p1return004_taxi_marker_960.png`：Bus Stop / Taxi marker 区域可见，反馈停留在“看一眼”的安心表达，没有出行压力。
- PNG 文件尺寸已核对为 `1280x720` 或 `960x540`，没有空文件或错误分辨率。

## 验证命令

```bash
godot --headless --path . --check-only --script tests/capture_p1return004_screens.gd
godot --headless --path . --check-only --script tests/test_v0210_p1_return_smoke.gd
godot --headless --path . --script tests/test_v0210_p1_return_smoke.gd
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --quit
```

以上命令已通过。

## PM 判断

- `V02-P1RETURN-004` 可以标记完成。
- V02.10 P1 居民回访扩展可以作为当前阶段收口：入口、轻回访、B/T 相册记录、smoke 和双视口截图证据均已具备。
- 下一轮建议由 PM 建立下一个阶段路线，不要继续自动扩大 P1 出行或阅读范围。
