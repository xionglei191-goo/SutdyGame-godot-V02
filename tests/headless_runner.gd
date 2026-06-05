extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const ConversationSummaryServiceScript := preload("res://scripts/systems/conversation_summary_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const HomeDecorationServiceScript := preload("res://scripts/systems/home_decoration_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const DailyGreetingServiceScript := preload("res://scripts/systems/daily_greeting_service.gd")
const ResourceRefreshServiceScript := preload("res://scripts/systems/resource_refresh_service.gd")
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")
const AnchorInteractionServiceScript := preload("res://scripts/systems/anchor_interaction_service.gd")
const AccountAdapterScript := preload("res://scripts/systems/account_adapter.gd")
const CloudSaveAdapterScript := preload("res://scripts/systems/cloud_save_adapter.gd")
const ContentPackLoaderScript := preload("res://scripts/systems/content_pack_loader.gd")
const ThemeSwitchServiceScript := preload("res://scripts/systems/theme_switch_service.gd")
const ContentReviewPipelineScript := preload("res://scripts/systems/content_review_pipeline.gd")
const ContentContractValidatorScript := preload("res://scripts/systems/content_contract_validator.gd")
const VoiceProviderAdapterScript := preload("res://scripts/systems/voice_provider_adapter.gd")
const AINPCProviderAdapterScript := preload("res://scripts/systems/ai_npc_provider_adapter.gd")
const FriendVisitServiceScript := preload("res://scripts/systems/friend_visit_service.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const WorldMapContractScript := preload("res://scripts/data/world_map_contract.gd")
const MainScene := preload("res://scenes/main.tscn")
const WorldOverviewScene := preload("res://scenes/map_editor/world_overview.tscn")

var failures: Array[String] = []


func _init() -> void:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "world_map.json must load and validate: %s" % [result.get("errors", [])])

	var data: Dictionary = result.get("data", {})
	var summary: Dictionary = RuntimeMapBuilderScript.build_summary(data)
	_expect(summary.get("place_count") == 3, "minimum map must contain Home, Town Start, and Supermarket")
	_expect(summary.get("anchor_count") == 26, "minimum map must contain all 26 A-Z memory palace anchors")
	_expect(_letters(data) == _az_letters(), "memory anchors must follow A-Z route order")

	var invalid: Dictionary = data.duplicate(true)
	invalid["places"][0]["interaction_cell"] = invalid["places"][0]["occupied_cells"][0]
	var invalid_errors: Array[String] = WorldMapContractScript.validate_map(invalid)
	_expect(not invalid_errors.is_empty(), "invalid interaction overlap must be rejected")

	var main := MainScene.instantiate()
	root.add_child(main)
	main.call("_ready")
	_expect(main.find_child("RuntimeMap", true, false) != null, "main scene must create RuntimeMap")
	_expect(main.find_children("RoadCell", "", true, false).size() > 0, "main scene must create visible road cells")
	_expect(main.find_child("place_home", true, false) != null, "main scene must create Home marker")
	_expect(main.find_child("place_town_start", true, false) != null, "main scene must create Town Start marker")
	_expect(main.find_child("place_supermarket", true, false) != null, "main scene must create Supermarket marker")
	_expect(main.find_child("anchor_a_apple", true, false) != null, "main scene must create anchor markers")
	_expect(main.find_child("anchor_e_elephant", true, false) != null, "main scene must create reserved A-Z anchor markers")
	_expect(main.find_child("interaction_home_entry", true, false) != null, "main scene must create hotspot markers")
	_expect(main.find_children("CollisionCell", "", true, false).size() > 0, "main scene must create collision markers")
	_expect(main.find_child("TownHUD", true, false) != null, "main scene must expose top message HUD")
	_expect(main.find_child("TownFooter", true, false) != null, "main scene must expose bottom action bar")
	_expect(main.find_child("Player", true, false) != null, "main scene must create player marker")
	for npc_id in ["mina", "shopkeeper", "pet_buddy", "bus_helper", "story_bear"]:
		_expect(main.find_child("npc_%s" % npc_id, true, false) != null, "main scene must create NPC marker: %s" % npc_id)
	_check_asset_resolver()
	_check_save_service()
	_check_service_loop_smoke()
	_check_ai_npc_stubs()
	_check_voice_ai_social_stubs()
	_check_life_services()
	_check_daily_requests()
	_check_anchor_interactions()
	_check_map_editor_round_trip()
	_check_child_experience_and_mobile_acceptance(main)
	_check_account_cloud_stubs()
	_check_content_theme_review_stubs()
	_check_content_contracts()
	_check_playable_ui_operations()
	_check_voice_ai_social_stubs()

	if failures.is_empty():
		print("HEADLESS TESTS PASSED: map contract and runtime loader")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _letters(data: Dictionary) -> Array[String]:
	var letters: Array[String] = []
	for anchor in data.get("memory_anchors", []):
		letters.append(anchor.get("letter", ""))
	return letters


func _az_letters() -> Array[String]:
	var letters: Array[String] = []
	for code in range(65, 91):
		letters.append(char(code))
	return letters


func _check_save_service() -> void:
	var service = SaveServiceScript.new("user://headless_runner_save_stub.json")
	_expect(service.clear_for_test(), "SaveService test save should clear")
	var profile := service.load_profile()
	profile["display_name"] = "Headless"
	_expect(service.save_profile(profile), "SaveService should save profile")
	_expect(service.save_game_state({"coins": 7, "current_place_id": "place_home", "pet": {}, "inventory": {}, "flags": {}}), "SaveService should save game_state")
	var reloaded = SaveServiceScript.new("user://headless_runner_save_stub.json")
	_expect(reloaded.load_profile().get("display_name", "") == "Headless", "SaveService profile should round-trip in main runner")
	_expect(int(reloaded.load_game_state().get("coins", -1)) == 7, "SaveService game_state should round-trip in main runner")
	_expect(reloaded.clear_for_test(), "SaveService test save should clean up")


func _check_asset_resolver() -> void:
	var loaded: Dictionary = AssetResolverScript.load_theme_profile("theme_sunshine_town_placeholder")
	_expect(loaded.get("ok", false), "AssetResolver should load placeholder theme: %s" % [loaded.get("errors", [])])
	var landmark: Dictionary = AssetResolverScript.get_landmark_asset("landmark_home_placeholder")
	_expect(landmark.get("ok", false), "AssetResolver should resolve home landmark")
	_expect(str(landmark.get("placeholder_path", "")).begins_with("placeholder://"), "AssetResolver must return logical placeholder path")


func _check_service_loop_smoke() -> void:
	var service := SaveServiceScript.new("user://headless_runner_loop_stub.json")
	_expect(service.clear_for_test(), "service loop save should clear")
	var quest := QuestEventServiceScript.new(service)
	var minigame := MinigameServiceScript.new(service)
	_expect(quest.start_chain().get("ok", false), "service loop should start quest chain")
	for event_id in ["event_welcome_home", "event_meet_sunny", "event_snack_time", "event_food_trip"]:
		_expect(quest.advance_event(event_id).get("ok", false), "service loop should advance: %s" % event_id)
	_expect(minigame.complete_minigame({"config_set_id": "food", "score": 80}).get("ok", false), "service loop should complete Letter Snake service result")
	for event_id in ["event_letter_snake_food", "event_food_basket", "event_feed_sunny"]:
		_expect(quest.advance_event(event_id).get("ok", false), "service loop should advance: %s" % event_id)
	var state: Dictionary = service.load_game_state()
	_expect(bool(state.get("flags", {}).get("sunny_first_snack_done", false)), "service loop should set completion flag")
	_expect(service.clear_for_test(), "service loop save should clean up")


func _check_ai_npc_stubs() -> void:
	var service := SaveServiceScript.new("user://headless_runner_ai_stub.json")
	_expect(service.clear_for_test(), "AI stub save should clear")
	_expect(service.reset_for_test(), "AI stub save should reset")
	var memory_store = NPCMemoryStoreScript.new(service)
	_expect(memory_store.load_all().get("ok", false), "NPCMemoryStore should load first batch profiles")
	var client = LLMClientScript.new(memory_store)
	var reply: Dictionary = client.complete_chat("mina", "hello", {"event_id": "event_welcome_home"})
	_expect(reply.get("ok", false), "LLMClient should return local stub reply")
	_expect(not bool(reply.get("network_used", true)), "LLMClient should not use network")
	var summary_service = ConversationSummaryServiceScript.new(service, memory_store)
	var summary: Dictionary = summary_service.record_interaction("pet_buddy", {
		"event_id": "event_feed_sunny",
		"title": "Feed Sunny",
		"summary": "Child fed Sunny after earning local coins.",
		"words": ["feed", "food"],
	})
	_expect(summary.get("ok", false), "ConversationSummaryService should record local summary")
	_expect(service.load_learning_record().get("npc_summary_refs", []).size() == 1, "NPC summary ref should persist")
	_expect(service.clear_for_test(), "AI stub save should clean up")


func _check_life_services() -> void:
	var service := SaveServiceScript.new("user://headless_runner_life_services.json")
	_expect(service.clear_for_test(), "life services save should clear")
	_expect(service.reset_for_test(), "life services save should reset")
	var inventory = InventoryServiceScript.new(service)
	_expect(inventory.is_loaded(), "InventoryService should load life item catalog")
	_expect(inventory.collect_item("branch", 1).get("ok", false), "InventoryService should collect branch")
	var game_state: Dictionary = service.load_game_state()
	game_state["coins"] = 10
	_expect(service.save_game_state(game_state), "life services should save coins setup")
	var shop = LifeShopServiceScript.new(service, inventory)
	_expect(shop.buy_life_item("wooden_chair").get("ok", false), "LifeShopService should buy wooden chair")
	var home = HomeDecorationServiceScript.new(service, inventory)
	var placed: Dictionary = home.place_furniture("wooden_chair", Vector2i(2, 2))
	_expect(placed.get("ok", false), "HomeDecorationService should place wooden chair")
	_expect(home.get_home_state().get("placed_furniture", []).size() == 1, "HomeDecorationService should persist furniture")
	var instance_id := str(placed.get("furniture", {}).get("instance_id", ""))
	_expect(home.rotate_furniture(instance_id).get("ok", false), "HomeDecorationService should rotate furniture")
	_expect(home.pickup_furniture(instance_id).get("ok", false), "HomeDecorationService should pick up furniture")
	game_state = service.load_game_state()
	game_state["coins"] = 12
	_expect(service.save_game_state(game_state), "life services should save pet furniture coins setup")
	_expect(shop.buy_life_item("pet_bowl").get("ok", false), "LifeShopService should buy pet bowl")
	_expect(home.place_furniture("pet_bowl", Vector2i(0, 0)).get("ok", false), "HomeDecorationService should place pet bowl")
	var feedback: Dictionary = home.get_sunny_feedback()
	_expect(feedback.get("ok", false) and str(feedback.get("text", "")).contains("Sunny"), "HomeDecorationService should provide Sunny home feedback")
	_expect(service.clear_for_test(), "life services save should clean up")


func _check_daily_requests() -> void:
	var service := SaveServiceScript.new("user://headless_runner_daily_requests.json")
	_expect(service.clear_for_test(), "daily request save should clear")
	_expect(service.reset_for_test(), "daily request save should reset")
	var day = LocalDayServiceScript.new("2026-06-04")
	var inventory = InventoryServiceScript.new(service)
	var greetings = DailyGreetingServiceScript.new(service, day)
	var resources = ResourceRefreshServiceScript.new(service, inventory, day)
	var today = TodayStatusServiceScript.new(day)
	var daily = DailyRequestServiceScript.new(service, inventory, day)
	_expect(greetings.is_loaded(), "DailyGreetingService should load greeting data")
	_expect(resources.is_loaded(), "ResourceRefreshService should load resource data")
	_expect(today.is_loaded(), "TodayStatusService should load today status data")
	_expect(daily.is_loaded(), "DailyRequestService should load request data")
	_expect(daily.get_request("daily_shopkeeper_flower_001").get("ok", false), "DailyRequestService should load shopkeeper request")
	_expect(daily.get_request("daily_story_bear_stone_001").get("ok", false), "DailyRequestService should load story bear request")
	_expect(daily.get_request("daily_sunny_flower_001").get("ok", false), "DailyRequestService should load Sunny request")
	var greeting: Dictionary = greetings.interact_for_npc("mina", false)
	_expect(greeting.get("ok", false) and bool(greeting.get("first_today", false)), "daily greeting should persist first NPC greeting")
	_expect(bool(service.load_game_state().get("daily_greetings", {}).get("2026-06-04", {}).get("mina", {}).get("greeted", false)), "daily greeting should save by day key")
	_expect(daily.interact_for_npc("mina").get("request_status", "") == "active", "daily request should start with Mina")
	_expect(resources.collect_resource("resource_branch_bear_corner").get("ok", false), "daily branch resource should be collectable")
	_expect(not resources.collect_resource("resource_branch_bear_corner").get("ok", true), "daily branch resource should not repeat same day")
	var complete: Dictionary = daily.interact_for_npc("mina")
	_expect(complete.get("request_status", "") == "completed", "daily request should complete with branch")
	_expect(int(service.load_game_state().get("coins", -1)) == 6, "daily request should award coins")
	_expect(bool(service.load_game_state().get("daily_requests", {}).get("2026-06-04", {}).get("daily_mina_branch_001", {}).get("completed_today", false)), "daily request completion should persist by day key")
	day.set_day_key_for_test("2026-06-05")
	_expect(resources.collect_resource("resource_branch_bear_corner").get("ok", false), "daily resources should refresh on next day key")
	_expect(str(today.get_today_status().get("hud_text", "")).contains("Sunny"), "today status should expose a soft Sunny hint")
	_expect(service.clear_for_test(), "daily request save should clean up")


func _check_anchor_interactions() -> void:
	var service := SaveServiceScript.new("user://headless_runner_anchor_interactions.json")
	_expect(service.clear_for_test(), "anchor interaction save should clear")
	_expect(service.reset_for_test(), "anchor interaction save should reset")
	var card_service = MemoryCardServiceScript.new(service)
	var anchor_service = AnchorInteractionServiceScript.new(service, card_service)
	_expect(anchor_service.is_loaded(), "AnchorInteractionService should load new-word revisit data")
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	var anchor: Dictionary = _anchor_by_id(map_result.get("data", {}).get("memory_anchors", []), "anchor_a_apple")
	var result: Dictionary = anchor_service.interact_with_anchor(anchor)
	_expect(result.get("ok", false), "AnchorInteractionService should interact with a world anchor")
	_expect(bool(card_service.get_card_state("card_a_apple_core").get("collected", false)), "anchor interaction should update album collected state")
	for story in anchor_service.get_all_stories():
		for field in ["letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]:
			_expect(not str(story.get(field, "")).is_empty(), "new-word revisit story should include %s" % field)
	_expect(service.clear_for_test(), "anchor interaction save should clean up")


func _anchor_by_id(anchors: Array, anchor_id: String) -> Dictionary:
	for anchor in anchors:
		if anchor is Dictionary and str(anchor.get("anchor_id", "")) == anchor_id:
			return anchor
	return {}


func _check_map_editor_round_trip() -> void:
	var scene: Control = WorldOverviewScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var grid: Dictionary = scene.call("get_grid_summary")
	_expect(grid.get("canvas_w") == 40 and grid.get("canvas_h") == 24, "Map editor grid should match 40x24 world canvas")
	_expect(grid.get("logical_cell_w") == 32 and grid.get("logical_cell_h") == 32, "Map editor grid should preserve runtime logical cell size")
	var road_add: Dictionary = scene.call("toggle_road_cell_for_test", "road_home_to_town", Vector2i(6, 8))
	_expect(road_add.get("ok", false), "Map editor should add road cell")
	_expect(bool(scene.call("has_road_cell", "road_home_to_town", Vector2i(6, 8))), "Map editor should read added road cell")
	var occupied: Dictionary = scene.call("set_occupied_cell_for_test", Vector2i(2, 2), true)
	_expect(occupied.get("ok", false), "Map editor should set occupied cell")
	var blocked: Dictionary = scene.call("set_interaction_cell_for_test", "interaction_headless_blocked", "place_home", Vector2i(2, 2))
	_expect(not blocked.get("ok", true), "Map editor should reject interaction over occupied cell")
	var moved: Dictionary = scene.call("move_place_marker_for_test", "place_home", Vector2i(8, 9))
	_expect(moved.get("ok", false), "Map editor should command-track place moves")
	_expect(scene.call("undo_for_test").get("ok", false), "Map editor should undo place move")
	_expect(scene.call("redo_for_test").get("ok", false), "Map editor should redo place move")
	scene.call("undo_for_test")
	scene.call("undo_for_test")
	scene.call("undo_for_test")
	var exported: Dictionary = MapEditorSyncServiceScript.export_to_dictionary(scene.call("get_editor_state"))
	_expect(exported.get("ok", false), "Map editor state should export as valid world map: %s" % [exported.get("errors", [])])
	_expect(exported.get("data", {}).get("memory_anchors", []).size() == 26, "Map editor export should preserve all A-Z anchors")
	root.remove_child(scene)
	scene.queue_free()


func _check_child_experience_and_mobile_acceptance(main: Control) -> void:
	var visible_text := _collect_visible_text(main).to_lower()
	for blocked in ["failed", "wrong", "test", "exam", "report", "dashboard", "parent"]:
		_expect(not visible_text.contains(blocked), "child flow should not show blocked text: %s" % blocked)
	for placeholder in ["studygame v02", "godot", "skeleton", "loaded places", "from json"]:
		_expect(not visible_text.contains(placeholder), "child flow should not show engineering placeholder text: %s" % placeholder)
	_expect(visible_text.contains("阳光小镇"), "child flow should present a localized Sunshine Town identity")
	var parent_spec: Dictionary = main.call("get_parent_entry_spec")
	_expect(not bool(parent_spec.get("child_flow_visible", true)), "parent entry should not be visible in child flow")
	_expect(not bool(parent_spec.get("network_required", true)), "parent entry should not require network")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_width") == 1280, "mobile baseline viewport width should be 1280")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_height") == 720, "mobile baseline viewport height should be 720")
	_expect(str(ProjectSettings.get_setting("rendering/renderer/rendering_method")) == "mobile", "Godot renderer should stay mobile-oriented")
	var nav := main.find_child("Navigation", true, false)
	_expect(nav != null and (nav as Control).custom_minimum_size.x >= 220.0, "touch navigation should reserve a usable width")
	_expect(nav != null and not (nav as Control).visible, "legacy left navigation should be hidden behind the playfield HUD")
	_expect(main.find_child("TownStage", true, false) != null, "main scene should expose a full playfield stage")
	var hud := main.find_child("TownHUD", true, false)
	_expect(hud != null, "main scene should keep only lightweight town HUD")
	_expect(hud != null and hud is Control and (hud as Control).anchor_top <= 0.03 and (hud as Control).anchor_right >= 0.95, "town HUD should be a top message bar, not a side status panel")
	var coin_state := main.find_child("CoinState", true, false) as Label
	var pet_state := main.find_child("PetState", true, false) as Label
	_expect(coin_state != null and coin_state.get_theme_stylebox("normal") != null and str(coin_state.text).contains("币"), "coin HUD state should be a separate icon badge")
	_expect(pet_state != null and pet_state.get_theme_stylebox("normal") != null and not str(pet_state.text).contains("金币"), "pet HUD state should keep Sunny snack, hunger, and happy separate from coins")
	_expect(main.find_child("Header", true, false) == null, "town title should be folded into the single-line HUD, not a second top banner")
	_expect(hud != null and hud is Control and (hud as Control).offset_bottom <= 52.0, "town HUD should stay compact enough to leave the playfield visible")
	var footer := main.find_child("TownFooter", true, false)
	_expect(footer != null and footer is Control and (footer as Control).anchor_top == 1.0, "main actions should sit in a bottom button bar")
	_expect(footer != null and footer is Control and (footer as Control).anchor_left >= 0.2 and (footer as Control).anchor_right <= 0.8, "bottom footer should be compact and centered, not a wide empty strip")
	var visible_footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(visible_footer_actions != null and visible_footer_actions.get_child_count() == 4, "bottom footer should keep only Interact, Town, Home, and Backpack visible")
	var backpack_button := main.find_child("BackpackNavButton", true, false) as Button
	var backpack_bubble := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack_button != null and backpack_bubble != null, "backpack navigation should expose a lightweight content bubble")
	_expect(backpack_bubble != null and not backpack_bubble.visible and backpack_bubble.anchor_left >= 0.5, "backpack bubble should be hidden by default and stay compact on the right")
	if visible_footer_actions != null:
		for child in visible_footer_actions.get_children():
			var footer_button := child as Button
			_expect(footer_button != null and footer_button.custom_minimum_size.x <= 110.0 and footer_button.custom_minimum_size.y <= 50.0, "footer buttons should stay compact and stable")
			_expect(footer_button != null and footer_button.get_theme_stylebox("normal") != null and footer_button.get_theme_stylebox("hover") != null and footer_button.get_theme_stylebox("pressed") != null, "footer buttons should expose normal, hover, and pressed visual states")
	for hidden_button_name in ["StartButton", "HelpNeighborButton", "BuyFoodButton", "FeedSunnyButton", "MemoryAlbumButton", "LetterSnakeButton"]:
		var hidden_button := main.find_child(hidden_button_name, true, false) as Button
		_expect(hidden_button != null and not hidden_button.is_visible_in_tree(), "legacy/test shortcut should be hidden from child footer: %s" % hidden_button_name)
	_expect(main.find_child("LifeRPGPanel", true, false) == null, "life status should not cover the playfield as a large panel")
	_expect(main.find_child("HomePetLoopPanel", true, false) == null, "pocket state should not cover the playfield as a large panel")
	_expect(main.find_child("OptionalActivityPanel", true, false) == null, "optional activities should not cover the playfield as a large panel")
	var runtime_map := main.find_child("RuntimeMap", true, false)
	_expect(runtime_map != null and runtime_map is Node2D, "RuntimeMap must be a Node2D playfield layer")
	_expect(runtime_map != null and _count_nodes_of_type(runtime_map, "Sprite2D") >= 30, "RuntimeMap should be built from Sprite2D-style assets")
	_expect(runtime_map != null and runtime_map.find_child("Ground", true, false) is Sprite2D, "RuntimeMap ground should be a sprite asset")
	_expect(runtime_map != null and runtime_map.find_child("RoadCell", true, false) is Sprite2D, "RuntimeMap roads should be sprite assets")
	var player := main.find_child("Player", true, false)
	_expect(player != null and player is Node2D and not player is Label, "player marker should be a sprite character, not text")
	_expect(player != null and player.find_child("Body", true, false) is Sprite2D, "player should include sprite body art")
	for npc_id in ["mina", "shopkeeper", "pet_buddy", "bus_helper", "story_bear"]:
		var npc := main.find_child("npc_%s" % npc_id, true, false)
		_expect(npc != null and npc is Node2D and not npc is Label, "NPC should be an animal resident sprite, not a text dot: %s" % npc_id)
		_expect(npc != null and npc.find_child("Head", true, false) is Sprite2D, "NPC should include sprite head art: %s" % npc_id)
	for anchor_id in ["anchor_a_apple", "anchor_c_clock", "anchor_d_dog", "anchor_o_orange"]:
		var anchor := main.find_child(anchor_id, true, false)
		var object_sprite := anchor.find_child("ObjectSprite", true, false) if anchor != null else null
		var object_label := anchor.find_child("ObjectLabel", true, false) if anchor != null else null
		_expect(anchor != null and anchor is Node2D, "anchor should be hidden in a world object: %s" % anchor_id)
		_expect(object_sprite != null and object_sprite is Sprite2D, "anchor should use a sprite object: %s" % anchor_id)
		_expect(not (object_label is Label), "anchor should not be represented by a bare text label: %s" % anchor_id)
	var safe_area := main.find_child("SafeArea", true, false)
	_expect(safe_area != null, "main scene should include a safe area container")


func _count_nodes_of_type(node: Node, type_name: String) -> int:
	var count := 0
	if node.get_class() == type_name:
		count += 1
	for child in node.get_children():
		count += _count_nodes_of_type(child, type_name)
	return count


func _collect_visible_text(node: Node) -> String:
	var parts: Array[String] = []
	if node is Label:
		parts.append((node as Label).text)
	if node is Button:
		parts.append((node as Button).text)
	for child in node.get_children():
		parts.append(_collect_visible_text(child))
	return " ".join(parts)


func _check_playable_ui_operations() -> void:
	var save_path := "user://headless_runner_playable_ui.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "playable UI save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("2026-06-04")
	root.add_child(main)
	main.call("_ready")

	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "visible backpack button should open backpack")
	var backpack_bubble := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack_bubble != null and backpack_bubble.visible, "visible backpack button should show backpack bubble")
	_press_visible_button(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "visible backpack bubble should open album")
	var album_overlay := main.find_child("MemoryAlbumOverlay", true, false) as Control
	var album_title := main.find_child("AlbumTitle", true, false) as Label
	_expect(album_overlay != null and album_overlay.visible, "visible album button should open album overlay")
	_expect(album_title != null and str(album_title.text) == "小镇相册", "album overlay should expose child-facing title")
	_press_visible_button(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "visible album return button should close album")
	_expect(album_overlay != null and not album_overlay.visible, "album return button should close overlay")

	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "visible top settings button should open settings")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "settings panel should open from visible top entry")
	var visible_footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(visible_footer_actions != null and visible_footer_actions.get_child_count() == 4, "settings should not add quit or settings into the bottom footer")
	var settings_status := main.find_child("SettingsStatus", true, false) as Label
	_expect(settings_status != null and str(settings_status.text).contains("安全位置"), "settings panel should use child-facing safety copy")
	var confirm_exit_button := main.find_child("ConfirmExitButton", true, false) as Button
	_expect(confirm_exit_button != null and not confirm_exit_button.visible, "exit confirm button should stay hidden before rest confirmation")
	_press_visible_button(main.find_child("RequestRestButton", true, false) as Button, "visible rest button should request a confirmation step")
	_expect(confirm_exit_button != null and confirm_exit_button.visible, "exit confirm button should appear after rest request")
	_press_visible_button(main.find_child("CancelRestButton", true, false) as Button, "visible continue button should cancel rest confirmation")
	_expect(confirm_exit_button != null and not confirm_exit_button.visible, "continue button should hide exit confirmation")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "playable UI should move away before safe-place action")
	_press_visible_button(main.find_child("SafePlaceButton", true, false) as Button, "visible safe-place button should return to a safe town cell")
	_expect(main.player_cell == Vector2i(5, 8), "safe-place button should move player back to the town safe cell")
	_expect(settings_panel != null and not settings_panel.visible, "safe-place action should close settings panel")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(2, 3)).get("ok", false), "playable UI should move near an anchor")
	_press_visible_button(interact_button, "visible Interact should work near anchor")
	var apple_state: Dictionary = main.save_service.load_learning_record().get("card_states", {}).get("card_a_apple_core", {})
	_expect(bool(apple_state.get("collected", false)), "visible Interact should update album card state")
	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "playable UI should move near a resource")
	_press_visible_button(interact_button, "visible Interact should work near resource")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 1, "visible Interact should collect resource")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "playable UI should move to shop hotspot")
	_press_visible_button(interact_button, "visible Interact should open shop panel")
	var shop_panel_local := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel_local != null and shop_panel_local.visible, "shop panel should open from visible Interact")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 30
	_expect(main.save_service.save_game_state(game_state), "playable UI should save local coins for purchase path")
	main.call("_update_loop_status", "金币准备好")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "visible shop item button should buy furniture")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "visible shop purchase should add furniture")

	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "visible Home button should open home room")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "visible Home button should show home room")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "visible home item button should place furniture")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 1, "visible home item button should place furniture")
	_press_visible_button(main.find_child("HomeRotateFirstFurnitureButton", true, false) as Button, "visible home rotate button should rotate furniture")
	_press_visible_button(main.find_child("HomePickupFirstFurnitureButton", true, false) as Button, "visible home pickup button should pick up furniture")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).is_empty(), "visible home pickup button should clear placed furniture")
	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "visible Town button should return to town")
	var town_stage_local := main.find_child("TownStage", true, false) as Control
	_expect(town_stage_local != null and town_stage_local.visible, "visible Town button should show town playfield")

	_expect(main.save_service.clear_for_test(), "playable UI save should clean up")
	root.remove_child(main)
	main.queue_free()


func _press_visible_button(button: Button, message: String) -> void:
	_expect(button != null and _control_path_visible(button) and not button.disabled, message)
	if button != null and _control_path_visible(button) and not button.disabled:
		button.emit_signal("pressed")


func _control_path_visible(node: Node) -> bool:
	var current := node
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _check_account_cloud_stubs() -> void:
	var account_save := SaveServiceScript.new("user://headless_runner_account_cloud.json")
	_expect(account_save.clear_for_test(), "account/cloud save should clear")
	_expect(account_save.reset_for_test(), "account/cloud save should reset")
	var account = AccountAdapterScript.new()
	var current: Dictionary = account.get_current_account(account_save)
	_expect(current.get("account_id", "") == "guest:local_profile", "AccountAdapter should expose local guest id")
	_expect(account_save.load_profile().get("profile_id", "") == "local_profile", "AccountAdapter should preserve SaveService profile id")

	var cloud = CloudSaveAdapterScript.new()
	var device_a := SaveServiceScript.new("user://headless_runner_cloud_a.json")
	var device_b := SaveServiceScript.new("user://headless_runner_cloud_b.json")
	_expect(device_a.clear_for_test(), "cloud device A should clear")
	_expect(device_b.clear_for_test(), "cloud device B should clear")
	_expect(device_a.reset_for_test(), "cloud device A should reset")
	_expect(device_b.reset_for_test(), "cloud device B should reset")
	var state_a: Dictionary = device_a.load_game_state()
	state_a["coins"] = 4
	_expect(device_a.save_game_state(state_a), "cloud device A should save setup")
	_expect(cloud.capture_from_save_service(CloudSaveAdapterScript.DEVICE_A, device_a).get("ok", false), "CloudSaveAdapter should capture device A")
	var sync_a: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_A)
	_expect(sync_a.get("ok", false), "CloudSaveAdapter should sync device A")
	_expect(not bool(sync_a.get("network_used", true)), "CloudSaveAdapter should not use network in runner")
	_expect(not bool(sync_a.get("data_uploaded", true)), "CloudSaveAdapter should not upload data in runner")
	_expect(cloud.sync_device(CloudSaveAdapterScript.DEVICE_B).get("ok", false), "CloudSaveAdapter should sync device B")
	_expect(cloud.restore_to_save_service(CloudSaveAdapterScript.DEVICE_B, device_b).get("ok", false), "CloudSaveAdapter should restore device B")
	_expect(int(device_b.load_game_state().get("coins", -1)) == 4, "CloudSaveAdapter should copy coins to second device")
	_expect(account_save.clear_for_test(), "account/cloud save should clean up")
	_expect(device_a.clear_for_test(), "cloud device A should clean up")
	_expect(device_b.clear_for_test(), "cloud device B should clean up")


func _check_content_theme_review_stubs() -> void:
	var loader = ContentPackLoaderScript.new()
	var pack := {
		"pack_id": "pack_headless_runner_words_001",
		"new_words": [
			{
				"word_id": "word_ant",
				"word": "ant",
				"letter": "A",
				"core_anchor_id": "anchor_a_apple",
				"world_place_id": "place_home",
				"story_memory": "An ant carries a tiny apple crumb beside the Home welcome box.",
				"visual_hook": "tiny ant trail under the red apple sign",
				"review_path": "Home welcome box -> Town Start flower path -> Home welcome box"
			}
		],
	}
	_expect(loader.install_pack(pack).get("ok", false), "ContentPackLoader should install legal local pack")
	_expect(loader.rollback_pack("pack_headless_runner_words_001").get("ok", false), "ContentPackLoader should rollback local pack")
	var illegal := pack.duplicate(true)
	illegal["anchors"] = [{"anchor_id": "anchor_a_apple"}]
	_expect(not loader.validate_pack(illegal).get("ok", true), "ContentPackLoader should reject A-Z core anchor override")

	var theme = ThemeSwitchServiceScript.new()
	var switched: Dictionary = theme.switch_theme("theme_rainbow_garden_placeholder", [{"category": "tile_atlas", "asset_id": "world"}])
	_expect(switched.get("ok", false), "ThemeSwitchService should resolve second placeholder theme")

	var review = ContentReviewPipelineScript.new()
	_expect(review.submit_candidate({"candidate_id": "candidate_headless_pack", "payload": pack}).get("ok", false), "ContentReviewPipeline should store candidate")
	_expect(not review.publish_for_runtime("candidate_headless_pack").get("ok", true), "ContentReviewPipeline should block unapproved content")
	_expect(review.set_manual_status("candidate_headless_pack", "approved").get("ok", false), "ContentReviewPipeline should accept manual approval")
	_expect(review.publish_for_runtime("candidate_headless_pack").get("ok", false), "ContentReviewPipeline should publish approved content")


func _check_content_contracts() -> void:
	var validator = ContentContractValidatorScript.new()
	var result: Dictionary = validator.validate_all()
	_expect(result.get("ok", false), "ContentContractValidator should pass all content data: %s" % [result.get("errors", [])])
	var blocked: Dictionary = validator.validate_candidate_content_pack({
		"anchors": [{"anchor_id": "anchor_a_apple"}],
		"new_word_stories": [],
	})
	_expect(not blocked.get("ok", true), "ContentContractValidator should block core A-Z anchor overrides")


func _check_voice_ai_social_stubs() -> void:
	var voice = VoiceProviderAdapterScript.new()
	var voice_gate: Dictionary = voice.configure_provider(VoiceProviderAdapterScript.REAL_PROVIDER, false)
	_expect(not voice_gate.get("ok", true), "VoiceProviderAdapter should require privacy approval for real provider")
	var played: Dictionary = voice.play_line("voice_home_good_morning")
	_expect(played.get("ok", false), "VoiceProviderAdapter should play local stub line")
	_expect(not bool(played.get("network_used", true)), "VoiceProviderAdapter should not use network")
	_expect(not voice.request_recording("voice_home_good_morning").get("ok", true), "VoiceProviderAdapter should keep recording disabled")

	var ai = AINPCProviderAdapterScript.new()
	_expect(not ai.configure_provider("real_ai_provider_reserved", false).get("ok", true), "AINPCProviderAdapter should require privacy approval")
	var reply: Dictionary = ai.complete_npc_chat("mina", "hello", {})
	_expect(reply.get("ok", false), "AINPCProviderAdapter should return local NPC reply")
	_expect(not bool(reply.get("network_used", true)), "AINPCProviderAdapter should not use network")

	var visits = FriendVisitServiceScript.new()
	_expect(not visits.start_async_visit("unknown_friend").get("ok", true), "FriendVisitService should block unknown friends")
	_expect(visits.approve_local_friend({"friend_id": "friend_headless", "display_name": "Headless Friend"}, true).get("ok", false), "FriendVisitService should allow parent-approved local friend")
	_expect(visits.send_preset_phrase("friend_headless", "Hi!").get("ok", false), "FriendVisitService should allow preset phrase")
	_expect(not visits.send_preset_phrase("friend_headless", "come to my school").get("ok", true), "FriendVisitService should block free text")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
