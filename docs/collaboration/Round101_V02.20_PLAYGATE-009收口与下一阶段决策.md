# Round101 V02.20 PLAYGATE-009 收口与下一阶段决策

> 日期：2026-06-06
> 任务：`V02-PLAYGATE-009 V02.20 playgate 收口与下一阶段决策`
> 结论：V02.20 PLAYGATE-002..009 文档队列完成；当前不进入内容扩展，也不进入 960x540 移动适配专项，下一阶段应继续 `V02.21 可居住小镇返修实现`。

## 输入交付

| 任务 | 交付物 | 结论 |
|---|---|---|
| V02-PLAYGATE-002 | `Round101_V02.20_PLAYGATE-002首屏可居住小镇QA审计与缺口清单.md` | V02.19 只能作为 1280 art baseline；Town / Home / Shop / School line 仍有居住感和动线缺口 |
| V02-PLAYGATE-003 | `Round101_V02.20_PLAYGATE-003_007自由生活smoke规格与旧路径回归矩阵.md` | 已固定 3-5 分钟真实入口 smoke 规格；后续需新增实现测试 |
| V02-PLAYGATE-004 | `Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md` | 已固定居民、资源、家具、anchor 空间分层返修规则 |
| V02-PLAYGATE-005 | `Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md` | 已固定 HUD / 底栏 / 弹层 / 相册 1280 可读可触返修规则 |
| V02-PLAYGATE-006 | `Round101_V02.20_PLAYGATE-006孩子端文本与生活反馈审校.md` | 孩子端文本不阻塞 playgate；后续继续弱化 Letter Snake / 格子术语 |
| V02-PLAYGATE-007 | `Round101_V02.20_PLAYGATE-003_007自由生活smoke规格与旧路径回归矩阵.md` | 旧路径矩阵完成；V02.8 smoke 与 V02.19 art/map 作为当前 playgate 证据退化 |
| V02-PLAYGATE-008 | `Round101_V02.20_PLAYGATE-004_005_008空间UI返修与1280批准判定.md` | Town / Shop / Album / Settings 仅可标 1280 art baseline approved；Home、School Gate、School Yard 仍 needs_fix |

## 阻塞判断

V02.20 playgate 的审计 / 规格 / 判定任务可以收口，但产品体验不能标 complete。当前阻塞项已经从“未知缺口”变成“明确返修队列”：

- 首屏仍偏全景地图叠字母 / 热点，生活用途优先级不够清楚。
- Home 居住感不足，小屋仍偏功能型网格和物件面板。
- Shop / School line 缺少同轮 Round101 1280 release-candidate proof 和更明确的到达感。
- 完整 3-5 分钟自由生活 smoke 尚未实现成 focused test。
- NPC routine、资源 2.0、Home / Shop 直接操作仍是后续实现项。

这些不是新的已验证故障，而是本轮 playgate 审计发现并分级的产品缺口；无需新增 `lessons.md` 条目，只需在轮次复盘写明无新增已验证教训。

## Approved 判定

| 画面 | 当前判定 | 说明 |
|---|---|---|
| Town Plaza / World Map | 1280 art baseline approved；product approved 待返修 | 有 Round99 proof，但空间分层和 anchor 降噪仍需继续 |
| Home | needs_fix | Round99 已明确不标最终美术 approved |
| Shop | 1280 art baseline approved；product approved 待返修 | 商品面板可读，但店铺空间感和触控复核仍需继续 |
| School Gate | needs_fix | 只有 Round96 proof，缺 Round101 / Round99 同口径 RC proof |
| School Yard | needs_fix | 只有 Round96 proof，缺 Round101 / Round99 同口径 RC proof |
| Album | 1280 art baseline approved；文本 / 触控继续优化 | 相册 overlay 已解决穿层，不是课程测试 |
| Settings | 1280 art baseline approved；小视口待专项 | 1280 可读，960 等留到全部开发完成后的适配专项 |

## 下一阶段决策

选择：继续居住感返修。

不进入内容扩展：因为 Home、Shop、School line、NPC routine、资源 2.0 和完整自由生活 smoke 尚未形成 product approved 证据。

不进入移动适配专项：因为 960x540 已明确暂缓到全部开发完成后；当前应先把 1280 主体验修到可居住。

建议下一阶段为 `V02.21 可居住小镇返修实现`，第一批 Ready 任务：

| 建议任务 | Owner | 完成门槛 |
|---|---|---|
| V02-LIVEGATE-001 空间分层与热点优先级返修 | Map / UX / Godot / QA | Town / Home / Shop / School line 的居民、资源、anchor、place 不互吞；真实 `看看` prompt 稳定 |
| V02-LIVEGATE-002 Home 居住感和直接家具操作返修 | Home Design / Godot / UI / QA | 小屋不再只是功能网格；家具选择 / 摆放 / Sunny 反馈来自可见操作 |
| V02-LIVEGATE-003 Shop / School line 到达感与局部 proof | Map / Art Direction / QA | Shop、School Gate、School Yard 导出同轮 1280 RC proof |
| V02-LIVEGATE-004 3-5 分钟自由生活 smoke 实现 | QA / Godot | 新增 focused test，覆盖启动、移动、看看、NPC、资源、商店、小屋、Sunny、相册、设置真实入口 |
| V02-LIVEGATE-005 1280 RC 截图包与二次 approved 判定 | PM / Art Direction / QA | Town、Home、Shop、School Gate、School Yard、Album、Settings 同轮截图判定 |

## 收口验证

本轮为文档 / 审计 / 规格 / 判定任务，不运行 Godot。验证使用：

```bash
rg -n "V02-PLAYGATE-00[2-9]|needs_fix|approved|真实入口|1280" docs/collaboration/Round101_V02.20_PLAYGATE-*.md
file docs/collaboration/round99_runtime_visual_acceptance/*.png docs/collaboration/round96_visual_acceptance/*round96_final_1280.png
```

## Lessons

无新增已验证教训。继续复用既有规则：`production` 不等于 `approved`，headless 通过不等于玩家可玩，隐藏 contract 按钮不能证明孩子端真实入口。
