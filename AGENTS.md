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
