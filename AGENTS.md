# Repository Guidelines

## Project Goal & Current Stage

StudyGame V02 is a Godot 4.6.x mobile English-life adventure for children around age 10, including true beginners. The first playable loop is:

```text
Meet pet -> pet is hungry -> play Letter Snake -> earn coins/card progress
-> buy food -> feed pet -> update pet, Memory Card, and local save
```

Stage 0 management baselines and the first playable loop are complete. Current work is local voice, NPC, AI, and parent-summary stubs, then NPC dialogue and parent-entry UI. Do not add real AI, recording, networking, cloud saves, open social features, school-mode gameplay, or final art before local stub acceptance passes.

## Project Structure & Module Organization

- `docs/`: product plans, architecture, contracts, collaboration rules, and handoff templates.
- `curriculum/小学英语重点分析/`: curriculum source material.
- `data/`: runtime JSON source of truth, including `data/npcs/<npc_id>/profile.json` and `memory.json`.
- `scenes/`: Godot runtime and UI scenes.
- `scripts/data/`: Resource and contract loaders.
- `scripts/systems/`: gameplay, save, map, voice, NPC, AI, and parent-summary services.
- `scripts/ui/` and `scripts/minigames/`: user-facing UI and minigame logic.
- `tests/`: headless contract, service, UI, and smoke tests.

## Build, Test, and Development Commands

```bash
godot --editor project.godot
godot --path .
godot --headless --path . --quit
godot --headless --path . --script tests/headless_runner.gd
```

Run focused tests for touched systems, for example `tests/test_voice_service.gd`, `tests/test_ai_npc_stubs.gd`, or `tests/test_parent_dashboard_store.gd`.

## Coding Style & Naming Conventions

Use GDScript tabs, `snake_case` files/functions/variables, and `PascalCase` classes/resources. Runtime code must not depend on EditorOnly nodes or hardcode concrete asset paths; request logical assets through `AssetResolver`. Every core object needs a stable ID.

## Testing Guidelines

Mark tasks complete only after deliverables exist and stated Godot headless checks pass. Validate unique IDs, map placement, road connections, interaction/occupied separation, A-Z order, JSON loading, the playable loop, and local Voice/AI/ParentDashboard stubs.

## Commit & Pull Request Guidelines

This directory has no Git history. Use concise imperative commits such as `feat: add npc stub summary`. PRs should include scope, changed files, validation commands/results, child-safety impact, and screenshots for UI changes.

## Agent-Specific Instructions

Read `todo.md` before work and `lessons.md` before risky changes. Set selected tasks to `[~]`, keep scope narrow, do not revert other agents' work, then update task status, completion records, and lessons after validation. Use `docs/collaboration/任务交接模板.md` for delegated tasks.
