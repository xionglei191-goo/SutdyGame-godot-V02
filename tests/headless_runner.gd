extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const ConversationSummaryServiceScript := preload("res://scripts/systems/conversation_summary_service.gd")
const WorldMapContractScript := preload("res://scripts/data/world_map_contract.gd")
const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "world_map.json must load and validate: %s" % [result.get("errors", [])])

	var data: Dictionary = result.get("data", {})
	var summary: Dictionary = RuntimeMapBuilderScript.build_summary(data)
	_expect(summary.get("place_count") == 3, "minimum map must contain Home, Town Start, and Supermarket")
	_expect(summary.get("anchor_count") == 9, "minimum map must contain 9 enabled anchors")
	_expect(_letters(data) == ["A", "B", "C", "D", "K", "O", "S", "T", "W"], "enabled anchors must match the approved list")

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
	_check_asset_resolver()
	_check_save_service()
	_check_service_loop_smoke()
	_check_ai_npc_stubs()

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


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
