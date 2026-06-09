# Repository Guidelines

## Project Goal & Current Stage

StudyGame V02 is now a Godot 4.6.x mobile life RPG / cozy town simulation for children. The target feel is closer to a warm Animal Crossing-style routine: live in Sunshine Town, meet animal residents, collect resources, decorate a home, care for a companion, and return daily.

English is an ambient layer, not the main loop. Use English in item names, signs, short NPC lines, album labels, voice clips, and optional minigames. The A-Z memory palace is still a core learning method: every letter needs a stable world-map anchor so memory encoding takes root subconsciously through exploration. Every new word must have a story tied to its memory-palace anchor, place, visual hook, and revisit path. Do not rebuild the project around tests, lessons, word drilling, or Letter Snake progression.

## Project Structure & Module Organization

- `docs/`: product direction, architecture, contracts, plans, and collaboration rules.
- `data/`: runtime JSON source of truth for maps, NPCs, items, quests, cards, voice, and future home data.
- `scenes/`: Godot runtime and UI scenes.
- `scripts/data/`: Resource and contract loaders.
- `scripts/systems/`: save, map, NPC, voice, pet, shop, minigame, and future life-sim services.
- `scripts/ui/` and `scripts/minigames/`: user-facing UI and optional activities.
- `tests/`: headless contract, service, UI, and smoke tests.

## Build, Test, and Development Commands

```bash
godot --editor project.godot
godot --path .
godot --headless --path . --quit
godot --headless --path . --script tests/headless_runner.gd
```

Run focused tests for touched systems, for example `tests/test_ai_npc_stubs.gd`, `tests/test_pet_shop_services.gd`, or future home-decoration tests.

## Coding Style & Naming Conventions

Use GDScript tabs, `snake_case` files/functions/variables, and `PascalCase` classes/resources. Runtime code must not depend on EditorOnly nodes or hardcode concrete asset paths; request logical assets through `AssetResolver`. Every core object needs a stable ID.

## Testing Guidelines

Mark tasks complete only after deliverables exist and Godot headless checks pass. Validate JSON loading, unique IDs, movement/collision, saving, NPC relationship state, inventory, shop transactions, home decoration persistence, A-Z anchor placement/order, new-word story bindings, and child-facing text safety.

## Commit & Pull Request Guidelines

Use concise imperative commits such as `feat: add home decoration state`. PRs should include scope, changed files, validation commands/results, child-safety impact, and screenshots for UI changes.

## Agent-Specific Instructions

Read `todo.md` before work and `lessons.md` before risky changes. Set selected tasks to `[~]`, keep scope narrow, do not revert other agents' work, then update task status, completion records, and lessons after validation. Preserve A-Z memory anchors as world structure; preserve other learning systems as optional/collection features unless a task explicitly removes them.

## Documentation Route & Ledger Sync

For new stage routes or next-stage planning, update documents in this order by default: `docs/12_V02开发路线.md` -> `docs/13_V02详细开发计划.md` -> `docs/14_内容基线整理与首批内容规划.md` -> `docs/15_项目经理接管与下一阶段执行计划.md` -> `todo.md`.

During execution and closeout, `todo.md` is the status source of truth. When a task enters Ready, `[~]`, `[x]`, or `[!]`, check and keep these `todo.md` areas consistent: current status panel, current-round assignment table, formal stage task list, completion records, and `lessons.md` only when there is a verified lesson or failure. Do not update only the status panel or assignment table while leaving the formal stage task list missing or stale.

## Image Generation Fallback

When bitmap image generation is needed, prefer the built-in image generation tool if available. If the built-in tool is unavailable or blocked, use the local fallback script at `/home/xionglei/GameProject/tools/image_generator.js`.

Text-to-image:

```bash
node /home/xionglei/GameProject/tools/image_generator.js text "prompt" "output.png" "1024x1024"
```

Image-to-image:

```bash
node /home/xionglei/GameProject/tools/image_generator.js edit "source.png" "prompt" "mask.png" "output.png"
```

Use `null` for the mask argument when no mask is needed. Save generated project assets under the repo asset tree with stable, descriptive filenames, then register them through logical asset IDs and `AssetResolver` rather than hardcoding paths in runtime code.

## Image-Heavy Task Context Control

Visual production rounds can quickly overload the main conversation context. For image-heavy tasks, prefer local scripts, manifests, and delegated agents/tools over repeatedly loading many bitmap previews in the main chat.

- Do not open or inline large batches of images in the main conversation unless visual inspection is essential.
- For crop, alpha, margin, size, component, pivot, and atlas checks, use scripts to produce numeric reports, manifests, and proof PNGs first.
- When multi-agent tooling is available, delegate broad image audits or repetitive visual checks to sub-agents and ask them to return concise findings, paths, and pass/fail tables instead of full image dumps.
- Keep the main thread focused on decisions, gate results, and a small number of representative proof images.
- Store generated images, contact sheets, manifests, and previews under stable project paths; summarize them by path rather than embedding every asset in the conversation.
- If a previous round already contains many images, do not reload them by default. Inspect only the current task's explicitly relevant files.
