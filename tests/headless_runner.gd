extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const ConversationSummaryServiceScript := preload("res://scripts/systems/conversation_summary_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const HomeDecorationServiceScript := preload("res://scripts/systems/home_decoration_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const AccountAdapterScript := preload("res://scripts/systems/account_adapter.gd")
const CloudSaveAdapterScript := preload("res://scripts/systems/cloud_save_adapter.gd")
const ContentPackLoaderScript := preload("res://scripts/systems/content_pack_loader.gd")
const ThemeSwitchServiceScript := preload("res://scripts/systems/theme_switch_service.gd")
const ContentReviewPipelineScript := preload("res://scripts/systems/content_review_pipeline.gd")
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
	_expect(main.find_child("LifeRPGPanel", true, false) != null, "main scene must expose life RPG panel")
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
	_check_map_editor_round_trip()
	_check_child_experience_and_mobile_acceptance(main)
	_check_account_cloud_stubs()
	_check_content_theme_review_stubs()
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
	_expect(home.place_furniture("wooden_chair", Vector2i(2, 2)).get("ok", false), "HomeDecorationService should place wooden chair")
	_expect(home.get_home_state().get("placed_furniture", []).size() == 1, "HomeDecorationService should persist furniture")
	_expect(service.clear_for_test(), "life services save should clean up")


func _check_daily_requests() -> void:
	var service := SaveServiceScript.new("user://headless_runner_daily_requests.json")
	_expect(service.clear_for_test(), "daily request save should clear")
	_expect(service.reset_for_test(), "daily request save should reset")
	var inventory = InventoryServiceScript.new(service)
	var daily = DailyRequestServiceScript.new(service, inventory)
	_expect(daily.is_loaded(), "DailyRequestService should load request data")
	_expect(daily.interact_for_npc("mina").get("request_status", "") == "active", "daily request should start with Mina")
	_expect(inventory.collect_item("branch", 1).get("ok", false), "daily request branch should be collectable")
	var complete: Dictionary = daily.interact_for_npc("mina")
	_expect(complete.get("request_status", "") == "completed", "daily request should complete with branch")
	_expect(int(service.load_game_state().get("coins", -1)) == 6, "daily request should award coins")
	_expect(bool(service.load_game_state().get("daily_requests", {}).get("daily_mina_branch_001", {}).get("completed_today", false)), "daily request completion should persist")
	_expect(service.clear_for_test(), "daily request save should clean up")


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
	var parent_spec: Dictionary = main.call("get_parent_entry_spec")
	_expect(not bool(parent_spec.get("child_flow_visible", true)), "parent entry should not be visible in child flow")
	_expect(not bool(parent_spec.get("network_required", true)), "parent entry should not require network")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_width") == 1280, "mobile baseline viewport width should be 1280")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_height") == 720, "mobile baseline viewport height should be 720")
	_expect(str(ProjectSettings.get_setting("rendering/renderer/rendering_method")) == "mobile", "Godot renderer should stay mobile-oriented")
	var nav := main.find_child("Navigation", true, false)
	_expect(nav != null and (nav as Control).custom_minimum_size.x >= 220.0, "touch navigation should reserve a usable width")
	var safe_area := main.find_child("SafeArea", true, false)
	_expect(safe_area != null, "main scene should include a safe area container")


func _collect_visible_text(node: Node) -> String:
	var parts: Array[String] = []
	if node is Label:
		parts.append((node as Label).text)
	if node is Button:
		parts.append((node as Button).text)
	for child in node.get_children():
		parts.append(_collect_visible_text(child))
	return " ".join(parts)


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
