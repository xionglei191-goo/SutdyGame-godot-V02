# StudyGame V02 Godot Prototype

Godot 4.6.x prototype for a mobile life RPG / cozy town simulation. The current codebase still contains an earlier English-learning loop prototype; that work is retained as technical infrastructure while the product direction moves toward town exploration, animal residents, resource collection, shops, home decoration, companion care, and ambient English.

## Run

```bash
godot --path .
```

## Headless Check

```bash
godot --headless --path . --quit
godot --headless --path . --script tests/headless_runner.gd
godot --headless --path . --script tests/test_save_service.gd
godot --headless --path . --script tests/test_asset_resolver.gd
godot --headless --path . --script tests/test_letter_snake_config.gd
godot --headless --path . --script tests/test_pet_food_loop_config.gd
godot --headless --path . --script tests/test_pet_shop_services.gd
godot --headless --path . --script tests/test_az_core_data.gd
godot --headless --path . --script tests/test_first_batch_extension_cards.gd
godot --headless --path . --script tests/test_content_references.gd
godot --headless --path . --script tests/test_memory_card_service.gd
godot --headless --path . --script tests/test_memory_album_scene.gd
godot --headless --path . --script tests/test_minigame_service.gd
godot --headless --path . --script tests/test_letter_snake_scene.gd
godot --headless --path . --script tests/test_quest_event_service.gd
godot --headless --path . --script tests/test_playable_loop_smoke.gd
godot --headless --path . --script tests/test_life_services.gd
godot --headless --path . --script tests/test_daily_request_service.gd
godot --headless --path . --script tests/test_life_rpg_scene.gd
godot --headless --path . --script tests/test_memory_palace_embedding.gd
godot --headless --path . --script tests/test_world_overview_editor_proxy.gd
godot --headless --path . --script tests/test_ai_npc_stubs.gd
godot --headless --path . --script tests/test_voice_service.gd
godot --headless --path . --script tests/test_parent_dashboard_store.gd
godot --headless --path . --script tests/test_parent_dashboard_scene.gd
```

The current main scene loads and validates `data/maps/world_map.json`, then shows explorable Home/Town Plaza/Shop placeholders, roads, A-Z anchor markers, a player marker, five first-batch NPC markers, neutral place entries, resource collection, Mina's first daily light request, explicit life actions, optional activity entry points, and child-flow isolation from parent-only UI.

`tests/test_save_service.gd` verifies the local `user://` SaveService stub for profile, GameState, and LearningRecord round trips. It does not use real assets, account login, cloud save, network access, recording, or AI services.

`tests/test_letter_snake_config.gd` validates `data/minigames/letter_snake_config.json` for the Home/Food/Weather/Transport target sets, reward tier differences, result schema fields, and blocked child-facing assessment terms.

`tests/test_pet_food_loop_config.gd` validates `data/quests/pet_food_loop.json` for the Sunny food loop event order, non-punitive rewards, food purchase/feed state changes, and child-facing blocked terms.

`tests/test_pet_shop_services.gd` verifies `PetService` and `ShopService` against `data/quests/pet_food_loop.json`, including successful snack purchase, insufficient coins without penalty, successful feeding, and no-food feeding without punishment.

`tests/test_az_core_data.gd` validates `data/anchors/az_core_anchors.json` and `data/cards/az_core_cards.json` for 26 A-Z anchors/cards, unique route order, the first batch A/B/C/D/K/O/S/T/W, anchor-card bindings, and initial collection state.

`tests/test_first_batch_extension_cards.gd` validates `data/cards/first_batch_extension_cards.json` for required first-loop extension card IDs, source mapping, minigame/quest references, and initial collection state.

`tests/test_content_references.gd` checks that first-loop card references resolve to either A-Z core cards or real first-batch extension cards.

`tests/test_memory_card_service.gd` verifies `MemoryCardService` core-card loading, optional extension-card skip warnings, SaveService `learning_record.card_states` round trips, and Letter Snake reward progress for card state.

`tests/test_memory_album_scene.gd` verifies the Memory Album scene can instantiate with injected SaveService, show the first 9 core cards plus extension cards, reflect collected/played card states, and avoid blocked child-facing assessment terms.

`tests/test_minigame_service.gd` verifies service-level Letter Snake start/complete behavior, coins, card progress, and saved minigame results.

`tests/test_letter_snake_scene.gd` verifies the runnable Letter Snake prototype scene can instantiate, show the Food target set, accept a score, complete through `MinigameService`, update coins/card progress, and expose `world_overview` as the return target.

`tests/test_quest_event_service.gd` verifies the service-level Sunny food loop from Welcome Home through Feed Sunny, including the non-punitive low-coins branch.

`tests/test_playable_loop_smoke.gd` verifies the main Home/Pet touch panel can drive the first playable loop from Sunny becoming hungry through a non-learning town errand, buying food, feeding Sunny, saved completion flags, and optional Letter Snake card progress only when the optional activity is chosen.

`tests/test_life_services.gd` verifies the life RPG resource, furniture shop, and home decoration services, including memory-palace story bindings for new items.

`tests/test_daily_request_service.gd` verifies `DailyRequestService` for Mina's branch request: local data loading, start/progress/completion, branch consumption, coins, relationship state, same-day no-repeat rewards, and save reload behavior.

`tests/test_life_rpg_scene.gd` verifies the life RPG layer in the main scene: player marker, walkable movement, blocked collision cells, five first-batch NPC markers, visible A-Z anchors, unified `interact_nearby()` behavior for Mina's daily request, fixed local NPC dialogue, branch collection, neutral Home/Town Start/Supermarket place entries without purchase/reward/decoration side effects, explicit shop and home actions, empty-cell no-target feedback, debug button downgrade, life-first coin action, learning systems presented as side activities, and no visible parent dashboard/report UI in the child flow.

`tests/test_memory_palace_embedding.gd` verifies all 26 A-Z memory palace anchors are embedded in the world map in route order, and new life items include memory-palace story bindings.

`tests/test_world_overview_editor_proxy.gd` verifies the editor-only `WorldOverviewScene` proxy creates place markers from `world_map.json`, supports marker movement without writing JSON, and stays out of the runtime main scene and `RuntimeMapBuilder`.

`tests/test_ai_npc_stubs.gd` verifies the Mina, Shopkeeper, Pet Buddy, Bus Helper, and Story Bear local profile/memory data, fixed no-network `LLMClient` replies for all five NPCs, and NPC memory plus parent-readable conversation summary round trips through `SaveService`.

`tests/test_voice_service.gd` verifies `data/voice/voice_lines.json`, `VoiceService` loading and lookup by `audio_id`, and local mock TTS/play/recording results without network or permission requests.

`tests/test_parent_dashboard_store.gd` verifies the local-only `ParentDashboardStore` can summarize learning time placeholders, contacted cards, Letter Snake results, NPC summary refs, and local settings without account, network, recording, or child-flow UI behavior.

`tests/test_parent_dashboard_scene.gd` verifies the independent parent-only dashboard scene can render local overview, cards, activities, neighbor summaries, and privacy settings from `ParentDashboardStore`, while the child main scene still does not mount parent dashboard UI. The parent entry contract is documented in `docs/development/家长入口触屏流程合同.md`; `Main.get_parent_entry_spec()` keeps that entry outside child navigation.

## Logical Assets

Runtime gameplay code should request art through `scripts/systems/asset_resolver.gd` using the map `theme_id` and a logical asset id. The current `data/themes/theme_sunshine_town_placeholder.json` profile only returns `placeholder://...` logical paths; it does not add or require real image, audio, or UI skin assets.
