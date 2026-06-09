# Round183 V02.39 VISUALREPLACE-001 Runtime Bitmap Promotion

> 日期：2026-06-08
> 状态：completed
> 用户方向：先把 Round169-Round179 visual rebuild 资产替换进运行时，不符合要求的再修改。

## Scope

- 将 TownStage 第一屏当前实际使用的 `v0239_*` runtime texture keys 从程序化白盒纹理改为 ThemeProfile / AssetResolver 解析的 PNG。
- 保留原程序化纹理作为路径失效 fallback。
- 本轮不声明 `final_approved`；新增状态为 `runtime_promoted_for_review`。
- 不读改 `docs/问答纪要.md`。

## Runtime Promotion

- 新增 31 个 runtime-promoted logical asset mappings：
  - `terrain.v0239.*`
  - `building_part.v0239.*`
  - `world_prop.v0239.*`
  - `pet.v0239.*`
  - `ui_icon.v0239.*`
- 来源覆盖 Round169-Round178 候选包，包括 ground regions、path sheet、home components、trees、flowers、fences、water、home yard props、resources/shop items、companion care props 和 UI icons。
- `scripts/main.gd` 的 `_logical_asset_texture_keys` 已为这些 `v0239_*` keys 绑定 logical asset ID，runtime sprite 会优先走 `AssetResolver` 加载 PNG。

## Gate Result

- ThemeProfile JSON parses.
- All 31 promoted resource paths exist.
- `AssetResolver` focused test passes.
- `TownStage.get_visual_rebuild_blockout_snapshot()` now reports resolver-mapped v0239 runtime assets.
- Home real interaction, five-button footer, player layer ordering, and A-Z anchor stability remain covered by focused / full runner gates.
- MCP runtime viewport screenshot was captured from the live main scene after promotion; the scene tree contains `/root/Main/SafeArea/Layout/Body/Content/TownStage/RuntimeMapFrame/RuntimeMap/VisualRebuildBlockoutLayer`.

## Validation

```bash
python3 -m json.tool data/themes/theme_sunshine_town_placeholder.json
python3 - <<'PY' ... promoted path audit ...
timeout 120 godot --headless --path . --script tests/test_asset_resolver.gd
timeout 120 godot --headless --path . --script tests/test_v0239_visual_rebuild_blockout.gd
timeout 120 godot --headless --path . --script tests/test_v0239_visual_rebuild_mainline_gate.gd
timeout 240 godot --headless --path . --script tests/headless_runner.gd
timeout 120 godot --headless --path . --quit
git diff --check
```

All validation commands passed.

## Follow-up Review Inputs

- Some promoted mappings intentionally use closest available candidates rather than exact production parts, especially house sub-parts and companion sub-parts.
- Next visual pass should review 1280 runtime composition for scale, crop, repetition, tileability, and visual identity, then regenerate or crop any weak assets.
