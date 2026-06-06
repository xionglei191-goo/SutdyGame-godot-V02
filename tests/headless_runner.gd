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
const AZWorldPlanContractScript := preload("res://scripts/data/az_world_plan_contract.gd")
const TextbookWorldContractScript := preload("res://scripts/data/textbook_world_contract.gd")
const V0218MapReadabilityTestScript := preload("res://tests/test_v0218_map_readability.gd")
const VoiceProviderAdapterScript := preload("res://scripts/systems/voice_provider_adapter.gd")
const ANCHOR_ASSET_IDS: Array[String] = [
	"anchor.a.apple_tree", "anchor.b.bear_corner", "anchor.c.clock", "anchor.d.dog_corner", "anchor.e.elephant_slide", "anchor.f.fox_topiary", "anchor.g.school_gate", "anchor.h.hat_sign", "anchor.i.ice_cream_cart", "anchor.j.jacket_window", "anchor.k.kite", "anchor.l.lion_fountain", "anchor.m.monkey_tree", "anchor.n.soft_net", "anchor.o.orange_stall", "anchor.p.panda_corner", "anchor.q.queen_poster", "anchor.r.robot_sign", "anchor.s.sun_landmark", "anchor.t.taxi_marker", "anchor.u.beach_umbrella", "anchor.v.violin_corner", "anchor.w.watch_table", "anchor.x.x_mark_box", "anchor.y.yo_yo_corner", "anchor.z.zebra_edge"
]
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
	_expect(int(summary.get("place_count", 0)) >= 6, "runtime map must contain Home, Town Start, Supermarket, Home-School Walk, School Gate, and School Yard")
	_expect(summary.get("anchor_count") == 26, "minimum map must contain all 26 A-Z memory palace anchors")
	_expect(_letters(data) == _az_letters(), "memory anchors must follow A-Z route order")

	var invalid: Dictionary = data.duplicate(true)
	var occupied_place_index := _first_place_with_occupied_cells(invalid.get("places", []))
	invalid["places"][occupied_place_index]["interaction_cell"] = invalid["places"][occupied_place_index]["occupied_cells"][0]
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
	_expect(main.find_child("place_home_school_walk", true, false) != null, "main scene must create Home-School Walk marker")
	_expect(main.find_child("place_school_gate", true, false) != null, "main scene must create School Gate marker")
	_expect(main.find_child("place_school_yard", true, false) != null, "main scene must create School Yard marker")
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
	_check_v028_daily_life_slice()
	_check_v029_weekly_return_smoke()
	_check_v0210_p1_return_smoke()
	_check_v0211_weather_slice_smoke()
	_check_v0212_az_world_plan()
	_check_v0213_textbook_world_plan()
	_check_v0214_homeschool_slice()
	_check_v0215_school_daily_slice()
	_check_v0216_playable_rc_gate()
	_check_v0218_map_readability()
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
	_check_polish_p0_asset_resolver_records()


func _check_polish_p0_asset_resolver_records() -> void:
	var theme_id := "theme_sunshine_town_placeholder"
	var required_assets := [
		{"category": "place_assets", "asset_id": "place.world_map.base_1280"},
		{"category": "place_assets", "asset_id": "place.home.yard"},
		{"category": "place_assets", "asset_id": "place.home_school_walk.day"},
		{"category": "place_assets", "asset_id": "place.school_gate.exterior"},
		{"category": "place_assets", "asset_id": "place.school_yard.day"},
		{"category": "place_assets", "asset_id": "place.shop_street.day"},
		{"category": "place_assets", "asset_id": "place.animal_park.day"},
		{"category": "place_assets", "asset_id": "place.coast_edge.day"},
		{"category": "place_assets", "asset_id": "place.sun_scene.morning"},
		{"category": "place_assets", "asset_id": "place.story_culture_bridge.day"},
		{"category": "place_assets", "asset_id": "place.town_plaza.day"},
		{"category": "place_assets", "asset_id": "place.home.exterior"},
		{"category": "place_assets", "asset_id": "place.shop.exterior"},
		{"category": "place_assets", "asset_id": "place.road.main"},
		{"category": "place_assets", "asset_id": "place.resource.branch"},
		{"category": "character_assets", "asset_id": "character.player.standing"},
		{"category": "character_assets", "asset_id": "character.mina.standing"},
		{"category": "pet_assets", "asset_id": "pet.sunny.standing"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.coin"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.bag"},
	]
	var records: Array = AssetResolverScript.get_asset_acceptance_records(theme_id)
	for anchor_asset_id in ANCHOR_ASSET_IDS:
		required_assets.append({"category": "anchor_assets", "asset_id": anchor_asset_id})
	for spec in required_assets:
		var category := str(spec.get("category", ""))
		var asset_id := str(spec.get("asset_id", ""))
		var resolved: Dictionary = AssetResolverScript.resolve_asset(theme_id, category, asset_id)
		_expect(resolved.get("ok", false), "P0 polish asset should resolve in headless runner: %s" % asset_id)
		var asset_path := str(resolved.get("placeholder_path", ""))
		_expect(asset_path.begins_with("res://assets/art/"), "P0 polish asset should map to project art: %s" % asset_id)
		_expect(FileAccess.file_exists(asset_path), "P0 polish asset file should exist: %s" % asset_path)
		var record: Dictionary = _asset_acceptance_record_for(records, asset_id)
		_expect(str(record.get("status", "")) == "production", "P0 polish asset should be production: %s" % asset_id)
		_expect(str(record.get("acceptance_result", "")) == "pass", "P0 polish asset should have pass result: %s" % asset_id)


func _asset_acceptance_record_for(records: Array, asset_id: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str(record.get("logical_asset_id", "")) == asset_id:
			return record
	return {}


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
	var shop = LifeShopServiceScript.new(service, inventory)
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
	_expect(str(today.get_today_status().get("weather_event_id", "")).begins_with("event_weather_"), "today status should expose a weather event id")
	_check_weekly_status_and_shop_rotations(shop)
	_expect(service.clear_for_test(), "daily request save should clean up")


func _check_weekly_status_and_shop_rotations(shop) -> void:
	var seen_events: Dictionary = {}
	var seen_weather_events: Dictionary = {}
	var seen_weather_greetings: Dictionary = {}
	var seen_p2 := false
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		var weekly_day = LocalDayServiceScript.new(day_key)
		var weekly_today = TodayStatusServiceScript.new(weekly_day)
		var weekly_greetings = DailyGreetingServiceScript.new(SaveServiceScript.new("user://headless_runner_weather_greetings_%s.json" % day_key), weekly_day)
		var weekly_resources = ResourceRefreshServiceScript.new(SaveServiceScript.new("user://headless_runner_weather_resources_%s.json" % day_key), InventoryServiceScript.new(SaveServiceScript.new("user://headless_runner_weather_resources_%s.json" % day_key)), weekly_day)
		_expect(weekly_today.is_loaded(), "weekly today status should load: %s" % day_key)
		var status: Dictionary = weekly_today.get_today_status()
		_expect(status.get("ok", false), "weekly today status should resolve: %s" % day_key)
		_expect(str(status.get("day_key", "")) == day_key, "weekly today status should keep day key: %s" % day_key)
		_expect(str(status.get("anchor_hint", "")).length() > 0, "weekly today status should include anchor hint: %s" % day_key)
		_expect(str(status.get("hud_text", "")).contains(str(status.get("today_status_text", ""))), "weekly today status should include weather HUD text: %s" % day_key)
		seen_events[str(status.get("event", ""))] = true
		var weather_event_id := str(status.get("weather_event_id", ""))
		seen_weather_events[weather_event_id] = true
		var weather_greeting: Dictionary = weekly_greetings.interact_for_npc(_weather_test_npc(weather_event_id))
		_expect(str(weather_greeting.get("weather_event_id", "")) == weather_event_id, "weekly weather greeting should match event: %s" % day_key)
		_expect(str(weather_greeting.get("greeting_variant_id", "")).begins_with("weather_"), "weekly weather greeting should use data variant: %s" % day_key)
		seen_weather_greetings[weather_event_id] = true
		var available_points: Array = weekly_resources.get_available_points()
		_expect(available_points.size() >= 3, "weather should not hide baseline resource points: %s" % day_key)
		for point in available_points:
			if point is Dictionary:
				_expect(int((point as Dictionary).get("quantity", 0)) >= 1, "weather should not reduce resource quantity: %s" % day_key)
		var rotation: Dictionary = shop.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "weekly shop rotation should resolve: %s" % day_key)
		_expect(str(rotation.get("weather_activity_corner", {}).get("weather_event_id", "")) == weather_event_id, "weekly shop activity corner should match weather event: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "weekly shop rotation should keep P0 offers: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "weekly shop rotation should keep chair offer: %s" % day_key)
		if _rotation_has_tier(rotation, "P2"):
			seen_p2 = true
	_expect(seen_events.size() == 7, "weekly status should provide 7 distinct gentle events")
	_expect(seen_weather_events.size() == 4, "weekly status should cover four P0 weather events")
	_expect(seen_weather_greetings.size() == 4, "weekly greetings should cover four P0 weather variants")
	_expect(seen_p2, "weekly shop rotations should include at least one P2 light variant")


func _rotation_has_item(rotation: Dictionary, item_id: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("item_id", "")) == item_id:
			return true
	return false


func _rotation_has_tier(rotation: Dictionary, tier: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("rotation_tier", "")) == tier:
			return true
	return false


func _weather_test_npc(weather_event_id: String) -> String:
	match weather_event_id:
		"event_weather_sunny_soft_001":
			return "pet_buddy"
		"event_weather_breezy_kite_001":
			return "bus_helper"
		"event_weather_after_rain_001":
			return "mina"
		"event_weather_light_rain_001":
			return "story_bear"
	return "mina"


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
	_expect(grid.get("canvas_w") == 60 and grid.get("canvas_h") == 34, "Map editor grid should match 60x34 world canvas")
	_expect(grid.get("logical_cell_w") == 32 and grid.get("logical_cell_h") == 32, "Map editor grid should preserve runtime logical cell size")
	var road_add: Dictionary = scene.call("toggle_road_cell_for_test", "road_home_plaza_ring", Vector2i(26, 16))
	_expect(road_add.get("ok", false), "Map editor should add road cell")
	_expect(bool(scene.call("has_road_cell", "road_home_plaza_ring", Vector2i(26, 16))), "Map editor should read added road cell")
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


func _visible_text_for_card(main, card_id: String) -> String:
	var card: Node = main.find_child(card_id, true, false)
	return _collect_visible_text(card) if card != null else ""


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
	_expect(main.player_cell == Vector2i(31, 19), "safe-place button should move player back to the home plaza safe cell")
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


func _check_v028_daily_life_slice() -> void:
	var save_path := "user://headless_runner_v028_daily_slice.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.8 daily slice save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("2026-06-05")
	root.add_child(main)
	main.call("_ready")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.8 slice should move near Mina")
	_press_visible_button(interact_button, "V02.8 slice should greet Mina from visible Interact")
	_press_visible_button(interact_button, "V02.8 slice should start Mina branch request from visible Interact")
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.8 slice should show Mina branch request")

	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.8 slice should move to branch resource")
	_press_visible_button(interact_button, "V02.8 slice should collect branch from visible Interact")
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.8 slice should return to Mina")
	_press_visible_button(interact_button, "V02.8 slice should complete Mina request from visible Interact")
	var after_mina: Dictionary = main.save_service.load_game_state()
	_expect(int(after_mina.get("coins", 0)) == 6, "V02.8 slice should earn local coins from Mina")
	_expect(bool(after_mina.get("daily_requests", {}).get("2026-06-05", {}).get("daily_mina_branch_001", {}).get("completed_today", false)), "V02.8 slice should persist Mina completion")

	after_mina["coins"] = 12
	_expect(main.save_service.save_game_state(after_mina), "V02.8 slice should prepare enough earned local coins for shop")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.8 slice should move to shop hotspot")
	_press_visible_button(interact_button, "V02.8 slice should open shop from visible Interact")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.8 slice should buy chair from visible shop button")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "V02.8 slice should add bought chair to backpack")

	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.8 slice should open backpack from visible button")
	var backpack_items := main.find_child("BackpackItems", true, false) as Label
	_expect(backpack_items != null and str(backpack_items.text).contains("木椅 1"), "V02.8 slice should show bought chair in backpack")
	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.8 slice should close backpack before home")
	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.8 slice should enter home from visible button")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.8 slice should place chair from visible home button")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 1, "V02.8 slice should persist placed chair")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "V02.8 slice should show Sunny home feedback")

	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "V02.8 slice should return to town")
	for anchor_spec in [
		{"cell": Vector2i(31, 15), "card": "card_c_clock_core", "word": "Clock"},
		{"cell": Vector2i(51, 10), "card": "card_o_orange_core", "word": "Orange"},
		{"cell": Vector2i(7, 3), "card": "card_s_sun_core", "word": "Sun"},
	]:
		_expect(main.move_player_to_cell(anchor_spec.get("cell", Vector2i.ZERO)).get("ok", false), "V02.8 slice should move to anchor: %s" % anchor_spec.get("card", ""))
		_press_visible_button(interact_button, "V02.8 slice should revisit anchor from visible Interact: %s" % anchor_spec.get("card", ""))
		_expect(bool(main.memory_card_service.get_card_state(str(anchor_spec.get("card", ""))).get("collected", false)), "V02.8 slice should collect anchor album state: %s" % anchor_spec.get("card", ""))
		_expect(str(main.life_status_label.text).contains(str(anchor_spec.get("word", ""))), "V02.8 slice should show anchor story feedback: %s" % anchor_spec.get("word", ""))

	for forbidden in ["考试", "评分", "课程", "背诵", "倒计时", "失败惩罚", "Godot skeleton", "Loaded places"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.8 slice visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.8 daily slice save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v029_weekly_return_smoke() -> void:
	var save_path := "user://headless_runner_v029_weekly_return_smoke.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.9 weekly smoke save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var seen_events: Dictionary = {}
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")

		var status: Dictionary = main.today_status_service.get_today_status()
		_expect(status.get("ok", false), "V02.9 weekly smoke should resolve today status: %s" % day_key)
		_expect(str(status.get("day_key", "")) == day_key, "V02.9 weekly smoke should keep requested day key: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("event", ""))), "V02.9 weekly smoke HUD should refresh event text: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("today_status_text", ""))), "V02.11 weather smoke HUD should show weather event text: %s" % day_key)
		_expect(str(status.get("anchor_hint", "")).length() > 0, "V02.9 weekly smoke should keep A-Z anchor hint: %s" % day_key)
		seen_events[str(status.get("event", ""))] = true

		var rotation: Dictionary = main.life_shop_service.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "V02.9 weekly smoke should resolve shop rotation: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "V02.9 weekly smoke should keep wooden chair visible as P0: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "V02.9 weekly smoke should keep at least one P0 offer: %s" % day_key)

		_complete_visible_mina_weekly_path(main, day_key)

		if day_key == "local_day_004":
			_expect(str(status.get("primary_npc", "")) == "story_bear", "V02.9 story day should stay represented in status data")
			_expect(str(status.get("anchor_hint", "")).contains("B Bear"), "V02.9 story day should keep B Bear as a soft hint")
		elif day_key == "local_day_005":
			_expect(str(status.get("primary_npc", "")) == "bus_helper", "V02.9 bus day should stay represented in status data")
			_expect(str(status.get("anchor_hint", "")).contains("T Taxi"), "V02.9 bus day should keep T Taxi as a soft hint")

	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(12, int(state.get("coins", 0)))
	_expect(main.save_service.save_game_state(state), "V02.9 weekly smoke should prepare gentle coins for final shop/home check")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.9 weekly smoke should move to shop hotspot after 7 days")
	_press_visible_button(interact_button, "V02.9 weekly smoke should open shop shelf after 7 days")
	_expect((main.find_child("ShopPanel", true, false) as Control).visible, "V02.9 weekly smoke should show visible shop panel after 7 days")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.9 weekly smoke should buy P0 chair after 7 days")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.9 weekly smoke should add P0 chair to backpack")
	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.9 weekly smoke should open home room")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.9 weekly smoke should place bought chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.9 weekly smoke should persist home placement")

	for forbidden in ["Godot skeleton", "Loaded places", "课程", "测验", "考试", "评分", "背诵", "倒计时", "失败惩罚", "陌生人带走", "独自远行", "赶时间"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.9 weekly smoke visible UI should not contain forbidden text: %s" % forbidden)
	_expect(seen_events.size() == 7, "V02.9 weekly smoke should expose 7 distinct gentle day events")

	_expect(main.save_service.clear_for_test(), "V02.9 weekly smoke save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0210_p1_return_entries() -> void:
	var save_path := "user://headless_runner_v0210_p1_return_entries.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.10 P1 return save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	for entry in [
		{"id": "p1_entry_story_bear_bookshop_door", "cell": Vector2i(12, 6), "kind": "bookshop_door", "text": "书店门口", "npc": "story_bear", "anchor": "anchor_b_bear", "card": "card_b_bear_core"},
		{"id": "p1_entry_story_bear_corner", "cell": Vector2i(13, 7), "kind": "bear_corner", "text": "熊形书牌", "npc": "story_bear", "anchor": "anchor_b_bear", "card": "card_b_bear_core"},
		{"id": "p1_entry_bus_helper_stop_sign", "cell": Vector2i(32, 11), "kind": "bus_stop_sign", "text": "小车牌", "npc": "bus_helper", "anchor": "anchor_t_taxi", "card": "card_t_taxi_core"},
		{"id": "p1_entry_bus_helper_taxi_marker", "cell": Vector2i(31, 10), "kind": "taxi_marker", "text": "黄色小标记", "npc": "bus_helper", "anchor": "anchor_t_taxi", "card": "card_t_taxi_core"},
	]:
		_expect(main.find_child(str(entry.get("id", "")), true, false) != null, "V02.10 P1 entry hotspot should be visible: %s" % entry.get("id", ""))
		_expect(main.move_player_to_cell(entry.get("cell", Vector2i.ZERO)).get("ok", false), "V02.10 P1 return should move to visible hotspot: %s" % entry.get("id", ""))
		_press_visible_button(interact_button, "V02.10 P1 return should trigger through visible Interact: %s" % entry.get("id", ""))
		_expect(str(main.life_status_label.text).contains(str(entry.get("text", ""))), "V02.10 P1 return HUD should show gentle feedback: %s" % entry.get("id", ""))
		var state: Dictionary = main.save_service.load_game_state()
		var saved: Dictionary = state.get("p1_return_entries", {}).get(str(entry.get("id", "")), {})
		_expect(bool(saved.get("seen", false)), "V02.10 P1 return should persist seen state: %s" % entry.get("id", ""))
		_expect(str(saved.get("entry_kind", "")) == str(entry.get("kind", "")), "V02.10 P1 return should persist entry kind: %s" % entry.get("id", ""))
		_expect(str(saved.get("npc_id", "")) == str(entry.get("npc", "")), "V02.10 P1 return should bind resident: %s" % entry.get("id", ""))
		_expect(str(saved.get("linked_anchor_id", "")) == str(entry.get("anchor", "")), "V02.10 P1 return should preserve A-Z anchor link: %s" % entry.get("id", ""))
		var card_state: Dictionary = main.memory_card_service.get_card_state(str(entry.get("card", "")))
		_expect(bool(card_state.get("seen", false)), "V02.10 P1 return should mark linked card seen: %s" % entry.get("card", ""))
		_expect(bool(card_state.get("heard", false)), "V02.10 P1 return should mark linked card heard: %s" % entry.get("card", ""))
		_expect(bool(card_state.get("collected", false)), "V02.10 P1 return should mark linked card collected: %s" % entry.get("card", ""))

	_expect(main.open_memory_album().get("ok", false), "V02.10 P1 return album should open after linked card records")
	_expect(_visible_text_for_card(main, "card_b_bear_core").contains("已收藏"), "V02.10 P1 return album should show B Bear collected")
	_expect(_visible_text_for_card(main, "card_t_taxi_core").contains("已收藏"), "V02.10 P1 return album should show T Taxi collected")
	_expect(not _collect_visible_text(main).contains("正确率"), "V02.10 P1 return album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "V02.10 P1 return album should not show level wording")
	main.close_memory_album()

	_expect((main.find_child("ShopPanel", true, false) as Control) != null and not (main.find_child("ShopPanel", true, false) as Control).visible, "V02.10 P1 return should not open shop panel")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) == 0, "V02.10 P1 return should not award coins")
	for forbidden in ["阅读测验", "测验", "考试", "评分", "背诵", "倒计时", "赶时间", "陌生人带走", "独自远行", "上车", "错过班车"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.10 P1 return visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.10 P1 return save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0210_p1_return_smoke() -> void:
	_check_v0210_p1_return_entries()
	_check_v0210_p1_light_returns()


func _check_v0210_p1_light_returns() -> void:
	var save_path := "user://headless_runner_v0210_p1_light_returns.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.10 P1 light return save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "V02.10 P1 light return should move near Story Bear")
	_press_visible_button(interact_button, "V02.10 P1 light return should greet Story Bear")
	_press_visible_button(interact_button, "V02.10 P1 light return should start Story Bear request")
	_expect(str(main.life_status_label.text).contains("Bear Corner"), "V02.10 Story Bear request should mention Bear Corner")
	_expect(main.move_player_to_cell(Vector2i(13, 7)).get("ok", false), "V02.10 P1 light return should move to Bear Corner")
	_press_visible_button(interact_button, "V02.10 P1 light return should see Bear Corner")
	_expect(bool(main.memory_card_service.get_card_state("card_b_bear_core").get("collected", false)), "V02.10 Story Bear P1 path should collect B Bear album card")
	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "V02.10 P1 light return should return to Story Bear")
	_press_visible_button(interact_button, "V02.10 P1 light return should complete Story Bear request")
	var story_state: Dictionary = main.save_service.load_game_state()
	_expect(bool(story_state.get("daily_requests", {}).get("local_day_004", {}).get("daily_story_bear_find_bear_corner_001", {}).get("completed_today", false)), "V02.10 Story Bear P1 request should persist completion")
	_expect(int(story_state.get("coins", 0)) == 5, "V02.10 Story Bear P1 request should award gentle coins once")

	main.set_day_key_for_test("local_day_005")
	main.call("_update_today_status")
	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "V02.10 P1 light return should move near Bus Helper")
	_press_visible_button(interact_button, "V02.10 P1 light return should greet Bus Helper")
	_press_visible_button(interact_button, "V02.10 P1 light return should start Bus Helper request")
	_expect(str(main.life_status_label.text).contains("taxi"), "V02.10 Bus Helper request should mention taxi marker")
	_expect(main.move_player_to_cell(Vector2i(31, 10)).get("ok", false), "V02.10 P1 light return should move to Taxi marker")
	_press_visible_button(interact_button, "V02.10 P1 light return should see Taxi marker")
	_expect(bool(main.memory_card_service.get_card_state("card_t_taxi_core").get("collected", false)), "V02.10 Bus Helper P1 path should collect T Taxi album card")
	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "V02.10 P1 light return should return to Bus Helper")
	_press_visible_button(interact_button, "V02.10 P1 light return should complete Bus Helper request")
	var bus_state: Dictionary = main.save_service.load_game_state()
	_expect(bool(bus_state.get("daily_requests", {}).get("local_day_005", {}).get("daily_bus_helper_taxi_spot_001", {}).get("completed_today", false)), "V02.10 Bus Helper P1 request should persist completion")
	_expect(int(bus_state.get("coins", 0)) == 11, "V02.10 Bus Helper P1 request should add gentle coins once")
	_expect(main.open_memory_album().get("ok", false), "V02.10 P1 light return album should open after request paths")
	_expect(_visible_text_for_card(main, "card_b_bear_core").contains("已收藏"), "V02.10 P1 light return album should show B Bear collected")
	_expect(_visible_text_for_card(main, "card_t_taxi_core").contains("已收藏"), "V02.10 P1 light return album should show T Taxi collected")
	_expect(not _collect_visible_text(main).contains("正确率"), "V02.10 P1 light return album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "V02.10 P1 light return album should not show level wording")
	main.close_memory_album()

	for forbidden in ["阅读测验", "测验", "考试", "评分", "背诵", "倒计时", "赶时间", "陌生人带走", "独自远行", "上车", "错过班车"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.10 P1 light return visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.10 P1 light return save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0211_weather_slice_smoke() -> void:
	var save_path := "user://headless_runner_v0211_weather_slice_smoke.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.11 weather slice save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var weather_paths: Array[Dictionary] = [
		{"day_key": "local_day_001", "event_id": "event_weather_sunny_soft_001", "anchor_id": "anchor_s_sun", "card_id": "card_s_sun_core", "cell": Vector2i(7, 3), "album_tag": "Sunny day."},
		{"day_key": "local_day_002", "event_id": "event_weather_breezy_kite_001", "anchor_id": "anchor_k_kite", "card_id": "card_k_kite_core", "cell": Vector2i(7, 11), "album_tag": "Windy Kite."},
		{"day_key": "local_day_004", "event_id": "event_weather_light_rain_001", "anchor_id": "anchor_b_bear", "card_id": "card_b_bear_core", "cell": Vector2i(13, 7), "album_tag": "Light Rain."},
		{"day_key": "local_day_006", "event_id": "event_weather_after_rain_001", "anchor_id": "anchor_u_umbrella", "card_id": "card_u_umbrella_core", "cell": Vector2i(33, 13), "album_tag": "After Rain."},
	]
	var seen_weather_events: Dictionary = {}
	var interact_button := main.find_child("InteractButton", true, false) as Button
	for path in weather_paths:
		var day_key := str(path.get("day_key", ""))
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")
		var status: Dictionary = main.today_status_service.get_today_status()
		var weather_event_id := str(status.get("weather_event_id", ""))
		_expect(status.get("ok", false), "V02.11 weather slice should resolve today status: %s" % day_key)
		_expect(weather_event_id == str(path.get("event_id", "")), "V02.11 weather slice should use expected event: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("today_status_text", ""))), "V02.11 weather slice HUD should show weather text: %s" % day_key)
		seen_weather_events[weather_event_id] = true

		var rotation: Dictionary = main.life_shop_service.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "V02.11 weather slice should resolve shop rotation: %s" % day_key)
		_expect(str(rotation.get("weather_activity_corner", {}).get("weather_event_id", "")) == weather_event_id, "V02.11 weather slice shop corner should match weather: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "V02.11 weather slice should keep P0 chair: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "V02.11 weather slice should keep P0 offers: %s" % day_key)

		_complete_visible_mina_weekly_path(main, day_key)

		_expect(main.move_player_to_cell(path.get("cell", Vector2i.ZERO)).get("ok", false), "V02.11 weather slice should move to weather clue: %s" % path.get("anchor_id", ""))
		_press_visible_button(interact_button, "V02.11 weather slice should trigger weather clue: %s" % path.get("anchor_id", ""))
		_expect(str(main.life_status_label.text).contains("天气相册"), "V02.11 weather slice clue HUD should mention album: %s" % path.get("anchor_id", ""))
		var record_id := "%s:%s" % [weather_event_id, str(path.get("anchor_id", ""))]
		var record: Dictionary = main.save_service.load_game_state().get("weather_album_clues", {}).get(record_id, {})
		_expect(bool(record.get("seen", false)), "V02.11 weather slice should persist clue record: %s" % record_id)
		_expect(str(record.get("album_tag", "")) == str(path.get("album_tag", "")), "V02.11 weather slice should persist album tag: %s" % record_id)
		var card_state: Dictionary = main.memory_card_service.get_card_state(str(path.get("card_id", "")))
		_expect(bool(card_state.get("seen", false)) and bool(card_state.get("collected", false)), "V02.11 weather slice should collect weather card: %s" % path.get("card_id", ""))

	_expect(seen_weather_events.size() == 4, "V02.11 weather slice should cover four P0 weather events")
	_expect(main.open_memory_album().get("ok", false), "V02.11 weather slice should open album after weather clues")
	for path in weather_paths:
		_expect(_visible_text_for_card(main, str(path.get("card_id", ""))).contains("已收藏"), "V02.11 weather slice album should show collected card: %s" % path.get("card_id", ""))
	main.close_memory_album()

	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(12, int(state.get("coins", 0)))
	_expect(main.save_service.save_game_state(state), "V02.11 weather slice should prepare coins for shop/home")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.11 weather slice should move to shop")
	_press_visible_button(interact_button, "V02.11 weather slice should open shop")
	_expect((main.find_child("ShopPanel", true, false) as Control).visible, "V02.11 weather slice should show shop panel")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.11 weather slice should buy P0 chair")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.11 weather slice should add chair")
	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.11 weather slice should open home")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.11 weather slice should place chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.11 weather slice should persist home placement")
	for forbidden in ["Godot skeleton", "Loaded places", "课程", "测验", "考试", "评分", "背诵", "倒计时", "失败惩罚", "陌生人带走", "独自远行", "赶时间", "打卡", "补签", "连续登录", "错过"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.11 weather slice visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.11 weather slice save should clean up")
	root.remove_child(main)
	main.queue_free()


func _complete_visible_mina_weekly_path(main, day_key: String) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.9 weekly smoke should move near Mina: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should greet or advance Mina: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should start Mina request: %s" % day_key)
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.9 weekly smoke should show Mina branch request: %s" % day_key)
	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.9 weekly smoke should move to branch resource: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should collect branch: %s" % day_key)
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.9 weekly smoke should return to Mina: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should complete Mina request: %s" % day_key)
	var daily_state: Dictionary = main.save_service.load_game_state().get("daily_requests", {}).get(day_key, {}).get("daily_mina_branch_001", {})
	_expect(bool(daily_state.get("completed_today", false)), "V02.9 weekly smoke should persist Mina completion by day: %s" % day_key)


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


func _check_v0212_az_world_plan() -> void:
	var loaded: Dictionary = AZWorldPlanContractScript.load_plan()
	_expect(loaded.get("ok", false), "V02.12 A-Z world plan should pass contract: %s" % [loaded.get("errors", [])])
	var data: Dictionary = loaded.get("data", {})
	_expect(str(data.get("center_policy", "")) == "home_school_dual_core", "V02.12 world plan should keep Home / School center")
	var anchors: Array = data.get("anchors", [])
	_expect(anchors.size() == 26, "V02.12 world plan should distribute all 26 anchors")
	var by_letter: Dictionary = {}
	for anchor in anchors:
		if anchor is Dictionary:
			by_letter[str((anchor as Dictionary).get("letter", ""))] = anchor
	for letter in ["A", "C", "D", "W"]:
		_expect(str(by_letter.get(letter, {}).get("home_school_relation", "")) == "home_line", "V02.12 home line should include: %s" % letter)
		_expect(str(by_letter.get(letter, {}).get("map_ring", "")) == "center", "V02.12 home line should stay in center: %s" % letter)
	for letter in ["E", "G", "K", "N", "R", "Y"]:
		_expect(str(by_letter.get(letter, {}).get("home_school_relation", "")) == "school_line", "V02.12 school line should include: %s" % letter)
		_expect(str(by_letter.get(letter, {}).get("map_ring", "")) == "center", "V02.12 school line should stay in center: %s" % letter)
	_expect(str(by_letter.get("X", {}).get("map_ring", "")) == "far_edge", "V02.12 X should remain far-edge reserve")
	_expect(str(by_letter.get("Z", {}).get("map_ring", "")) == "far_edge", "V02.12 Z should remain far-edge reserve")


func _check_v0213_textbook_world_plan() -> void:
	var loaded: Dictionary = TextbookWorldContractScript.load_plan()
	_expect(loaded.get("ok", false), "V02.13 textbook world plan should pass contract: %s" % [loaded.get("errors", [])])
	var data: Dictionary = loaded.get("data", {})
	_expect(data.get("textbook_sources", []).size() == 8, "V02.13 should cover 8 textbook sources")
	_expect(data.get("curriculum_items", []).size() == 85, "V02.13 should summarize all 85 unit slots")
	var p0_count := 0
	for mapping in data.get("world_mappings", []):
		if mapping is Dictionary and str((mapping as Dictionary).get("tier", "")) == "P0":
			p0_count += 1
			_expect(not ["anchor_x_x_mark_box", "anchor_z_zebra"].has(str((mapping as Dictionary).get("anchor_id", ""))), "V02.13 P0 mapping should not use far-edge anchors")
	_expect(p0_count >= 12, "V02.13 should include P0 Home / School mappings")


func _check_v0214_homeschool_slice() -> void:
	var save_path := "user://headless_runner_v0214_homeschool_slice.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.14 homeschool runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var path: Array[Dictionary] = [
		{"event_id": "homeschool_home_morning_bag_001", "cell": Vector2i(4, 7), "text": "Good morning", "cards": ["card_a_apple_core", "card_c_clock_core", "card_w_watch_core"]},
		{"event_id": "homeschool_home_sunny_good_morning_001", "cell": Vector2i(6, 8), "text": "Sunny", "cards": ["card_d_dog_core"]},
		{"event_id": "homeschool_walk_gate_sign_001", "cell": Vector2i(8, 11), "text": "school gate", "cards": ["card_g_gate_core"]},
		{"event_id": "homeschool_walk_kite_sky_001", "cell": Vector2i(9, 12), "text": "Kite", "cards": ["card_k_kite_core", "card_s_sun_core"]},
		{"event_id": "homeschool_school_gate_hello_001", "cell": Vector2i(11, 13), "text": "Hello", "cards": ["card_e_elephant_core", "card_g_gate_core"]},
		{"event_id": "homeschool_school_yard_play_001", "cell": Vector2i(11, 15), "text": "Robot", "cards": ["card_n_net_core", "card_r_robot_core", "card_y_yo_yo_core"]},
		{"event_id": "homeschool_return_sunny_story_001", "cell": Vector2i(5, 8), "text": "回到小屋", "cards": ["card_a_apple_core", "card_d_dog_core", "card_o_orange_core"]},
	]
	for step in path:
		var event_id := str(step.get("event_id", ""))
		_expect(main.find_child(event_id, true, false) != null, "V02.14 homeschool hotspot should exist: %s" % event_id)
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.14 homeschool player should reach: %s" % event_id)
		_press_visible_button(interact_button, "V02.14 homeschool visible Interact should trigger: %s" % event_id)
		_expect(str(main.life_status_label.text).contains(str(step.get("text", ""))), "V02.14 homeschool feedback should be visible: %s" % event_id)
		var record: Dictionary = main.save_service.load_game_state().get("homeschool_events", {}).get(event_id, {})
		_expect(bool(record.get("seen", false)), "V02.14 homeschool event should persist: %s" % event_id)
		for card_id in step.get("cards", []):
			var card_state: Dictionary = main.memory_card_service.get_card_state(str(card_id))
			_expect(bool(card_state.get("collected", false)), "V02.14 homeschool card should be collected: %s" % card_id)
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.14 should keep shop path walkable")
	_press_visible_button(interact_button, "V02.14 visible Interact should still open shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.14 should keep shop panel available")
	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "V02.14 should keep home path walkable")
	_press_visible_button(interact_button, "V02.14 visible Interact should still open home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.14 should keep home room available")
	_expect(not _collect_visible_text(main).contains("测试"), "V02.14 visible UI should not expose test wording")
	_expect(not _collect_visible_text(main).contains("分数"), "V02.14 visible UI should not expose score wording")
	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _check_v0215_school_daily_slice() -> void:
	var save_path := "user://headless_runner_v0215_school_daily_slice.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.15 school daily runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var path: Array[Dictionary] = [
		{"event_id": "homeschool_walk_gate_sign_001", "cell": Vector2i(8, 11), "stage": "home_school_walk"},
		{"event_id": "homeschool_school_gate_hello_001", "cell": Vector2i(11, 13), "stage": "school_gate"},
		{"event_id": "homeschool_school_yard_play_001", "cell": Vector2i(11, 15), "stage": "school_yard"},
		{"event_id": "homeschool_return_sunny_story_001", "cell": Vector2i(5, 8), "stage": "return_home"},
	]
	var seen_school_day_events: Dictionary = {}
	var seen_return_events: Dictionary = {}
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")
		var school_state: Dictionary = main.school_day_state_service.get_today_school_state()
		_expect(school_state.get("ok", false), "V02.15 school daily should resolve school state: %s" % day_key)
		_expect(str(school_state.get("day_key", "")) == day_key, "V02.15 school daily should keep requested day key: %s" % day_key)
		for step in path:
			var stage := str(step.get("stage", ""))
			var event_id := str(step.get("event_id", ""))
			var entry: Dictionary = main.school_day_state_service.get_entry(stage)
			_expect(str(entry.get("day_key", "")) == day_key, "V02.15 school daily entry should inherit day key: %s %s" % [day_key, stage])
			_expect(str(entry.get("stage", "")) == stage, "V02.15 school daily entry should keep stage: %s %s" % [day_key, stage])
			_expect(main.find_child(event_id, true, false) != null, "V02.15 school daily hotspot should exist: %s" % event_id)
			_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.15 school daily player should reach: %s %s" % [day_key, stage])
			_press_visible_button(interact_button, "V02.15 school daily visible Interact should trigger: %s %s" % [day_key, stage])
			_expect(str(main.life_status_label.text).contains(str(entry.get("child_facing_text", ""))), "V02.15 school daily feedback should show day-specific text: %s %s" % [day_key, stage])
			var record: Dictionary = main.save_service.load_game_state().get("school_day_events", {}).get(str(entry.get("event_id", "")), {})
			_expect(bool(record.get("seen", false)), "V02.15 school daily event should persist: %s" % entry.get("event_id", ""))
			_expect(str(record.get("day_key", "")) == day_key, "V02.15 school daily persisted event should keep day: %s" % entry.get("event_id", ""))
			_expect(str(record.get("stage", "")) == stage, "V02.15 school daily persisted event should keep stage: %s" % entry.get("event_id", ""))
			_expect(not (record.get("anchor_ids", []) as Array).is_empty(), "V02.15 school daily persisted event should keep anchors: %s" % entry.get("event_id", ""))
			_expect(not (record.get("environment_words", []) as Array).is_empty(), "V02.15 school daily persisted event should keep environment words: %s" % entry.get("event_id", ""))
			seen_school_day_events[str(entry.get("event_id", ""))] = true
			if stage == "return_home":
				seen_return_events[str(entry.get("event_id", ""))] = true
				_expect(str(entry.get("display_prefix", "")).contains("Sunny"), "V02.15 return entry should stay tied to Sunny: %s" % day_key)
	_expect(seen_school_day_events.size() == 28, "V02.15 school daily should persist 7 days x 4 school events")
	_expect(seen_return_events.size() == 7, "V02.15 school daily should persist seven Sunny return events")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.15 school daily should keep shop path walkable")
	_press_visible_button(interact_button, "V02.15 school daily visible Interact should still open shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.15 school daily should keep shop panel available")
	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "V02.15 school daily should keep home path walkable")
	_press_visible_button(interact_button, "V02.15 school daily visible Interact should still open Home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.15 school daily should keep Home room available")
	for forbidden in ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "倒计时", "迟到", "作业", "老师评价", "家长报告", "独自远行", "上车", "必须", "打卡"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.15 school daily visible UI should not contain forbidden text: %s" % forbidden)
	_expect(main.save_service.clear_for_test(), "V02.15 school daily runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0216_playable_rc_gate() -> void:
	var save_path := "user://headless_runner_v0216_playable_rc_gate.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.16 playable RC save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_006")
	root.add_child(main)
	main.call("_ready")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 20
	game_state["inventory"] = {"food_pet_snack": 1}
	_expect(main.save_service.save_game_state(game_state), "V02.16 playable RC should seed local state")
	main.call("_update_loop_status", "小镇准备好")
	main.call("_update_today_status")

	var footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(footer_actions != null and footer_actions.get_child_count() == 4, "V02.16 playable RC should keep four footer actions")
	var footer_hint := main.find_child("TownFooterText", true, false) as Label
	_expect(footer_hint != null and str(footer_hint.text).contains("看看"), "V02.16 playable RC should explain visible look action")
	_check_v0216_visible_text(main, "startup")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.16 playable RC should move near Mina")
	_press_visible_button(interact_button, "V02.16 playable RC should greet Mina")
	_press_visible_button(interact_button, "V02.16 playable RC should start Mina request")
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.16 playable RC Mina request should stay life-like")
	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.16 playable RC should move to branch")
	_press_visible_button(interact_button, "V02.16 playable RC should collect branch")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 1, "V02.16 playable RC should collect resource")
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.16 playable RC should return to Mina")
	_press_visible_button(interact_button, "V02.16 playable RC should complete Mina request")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) >= 6, "V02.16 playable RC should keep gentle coins")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.16 playable RC should reach Shop")
	_press_visible_button(interact_button, "V02.16 playable RC should open Shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.16 playable RC should show Shop")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.16 playable RC should buy chair")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.16 playable RC should add chair")
	_press_visible_button(main.find_child("CloseShopButton", true, false) as Button, "V02.16 playable RC should close Shop")
	_expect(shop_panel != null and not shop_panel.visible, "V02.16 playable RC Shop should close")

	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.16 playable RC should open Home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.16 playable RC should show Home")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.16 playable RC should place chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.16 playable RC should persist Home placement")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "V02.16 playable RC should show Sunny feedback")
	_press_visible_button(main.find_child("HomeRotateFirstFurnitureButton", true, false) as Button, "V02.16 playable RC should rotate furniture")
	_press_visible_button(main.find_child("HomeMoveFirstFurnitureButton", true, false) as Button, "V02.16 playable RC should move furniture")
	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "V02.16 playable RC should return to Town")

	for step in [
		{"cell": Vector2i(8, 11), "stage": "home_school_walk"},
		{"cell": Vector2i(11, 13), "stage": "school_gate"},
		{"cell": Vector2i(11, 15), "stage": "school_yard"},
		{"cell": Vector2i(5, 8), "stage": "return_home"},
	]:
		var stage := str(step.get("stage", ""))
		var entry: Dictionary = main.school_day_state_service.get_entry(stage)
		_expect(not entry.is_empty(), "V02.16 playable RC should resolve school entry: %s" % stage)
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.16 playable RC should reach school step: %s" % stage)
		_press_visible_button(interact_button, "V02.16 playable RC should trigger school step: %s" % stage)
		_expect(str(main.life_status_label.text).contains(str(entry.get("child_facing_text", ""))), "V02.16 playable RC should show school text: %s" % stage)
	_expect(main.save_service.load_game_state().get("school_day_events", {}).size() >= 4, "V02.16 playable RC should persist school day events")

	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.16 playable RC should open Backpack")
	_press_visible_button(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.16 playable RC should open Album")
	var album_overlay := main.find_child("MemoryAlbumOverlay", true, false) as Control
	_expect(album_overlay != null and album_overlay.visible, "V02.16 playable RC should show Album")
	_check_v0216_visible_text(main, "album")
	_press_visible_button(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.16 playable RC should close Album")
	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "V02.16 playable RC should open Settings")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "V02.16 playable RC should show Settings")
	_check_v0216_visible_text(main, "settings")
	_press_visible_button(main.find_child("RequestRestButton", true, false) as Button, "V02.16 playable RC should reveal rest confirmation")
	var confirm_exit_button := main.find_child("ConfirmExitButton", true, false) as Button
	_expect(confirm_exit_button != null and confirm_exit_button.visible, "V02.16 playable RC should show exit confirmation only after rest request")
	_press_visible_button(main.find_child("CancelRestButton", true, false) as Button, "V02.16 playable RC should cancel rest confirmation")
	_expect(confirm_exit_button != null and not confirm_exit_button.visible, "V02.16 playable RC should hide exit confirmation")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.16 playable RC should move before safe-place")
	_press_visible_button(main.find_child("SafePlaceButton", true, false) as Button, "V02.16 playable RC should use safe-place")
	_expect(main.player_cell == Vector2i(31, 19), "V02.16 playable RC should return to safe cell")
	_expect(settings_panel != null and not settings_panel.visible, "V02.16 playable RC safe-place should close Settings")
	_check_v0216_visible_text(main, "final")

	_expect(main.save_service.clear_for_test(), "V02.16 playable RC save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0216_visible_text(main, context: String) -> void:
	var text := _collect_visible_child_text(main)
	for forbidden in ["Godot skeleton", "Loaded places", "from JSON", "课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "家长报告", "必须完成", "错过损失", "迟到", "作业", "打卡", "倒计时", "赶时间", "陌生人带走", "独自远行"]:
		_expect(not text.contains(forbidden), "V02.16 playable RC visible UI should not contain forbidden text (%s): %s" % [context, forbidden])


func _check_v0218_map_readability() -> void:
	_expect(V0218MapReadabilityTestScript != null, "V02.18 map readability focused test should compile for headless runner")
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.18 map readability should load world map")
	var world_map: Dictionary = result.get("data", {})
	var save_path := "user://headless_runner_v0218_map_readability.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.18 map readability save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	root.add_child(main)
	main.call("_ready")
	_expect(main.find_child("MapReadabilityLayer", true, false) is Node2D, "V02.18 map readability should expose guide layer")
	var artpass004_zone_names: Array[String] = ["MapReadZoneSun", "MapReadZoneSchoolGate", "MapReadZoneSchoolYard", "MapReadZoneWalk", "MapReadZoneStory", "MapReadZoneHome", "MapReadZoneShop", "MapReadZoneAnimal", "MapReadZoneCoast"]
	for node_name in artpass004_zone_names + ["MapReadSignSun", "MapReadSignSchool", "MapReadSignStory", "MapReadSignHome", "MapReadSignShop", "MapReadSignAnimal", "MapReadSignCoast"]:
		_expect(main.find_child(node_name, true, false) != null, "V02.18 map readability should expose guide node: %s" % node_name)
	for node_name in artpass004_zone_names:
		var zone := main.find_child(node_name, true, false) as Sprite2D
		_expect(zone != null and zone.texture != null and zone.texture.get_width() >= 512, "ARTPASS-004 map zone should use production place asset in headless runner: %s" % node_name)
	var ground := main.find_child("Ground", true, false) as Sprite2D
	_expect(ground != null and ground.texture != null and ground.texture.get_width() == 1280, "ARTPASS-004 ground should use 1280 world map base asset in headless runner")
	var groups := {}
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(interact_button != null and _control_path_visible(interact_button), "V02.18 map readability should keep visible Interact button")
	for anchor_value in world_map.get("memory_anchors", []):
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var anchor_id := str(anchor.get("anchor_id", ""))
		var letter := str(anchor.get("letter", ""))
		var card_id := str(anchor.get("card_id", ""))
		var core_word := str(anchor.get("core_word", ""))
		var group := _v0218_screenshot_group_for_letter(letter)
		groups[group] = true
		var node := main.find_child(anchor_id, true, false) as Node2D
		_expect(node != null, "V02.18 map readability should create anchor node: %s" % anchor_id)
		if node == null:
			continue
		_expect(str(node.get_meta("mapread_layer", "")) == _v0218_layer_for_letter(letter), "V02.18 map readability should expose layer meta: %s" % anchor_id)
		_expect(str(node.get_meta("mapread_screenshot_group", "")) == group, "V02.18 map readability should expose screenshot group: %s" % anchor_id)
		var sprite := node.find_child("ObjectSprite", true, false) as Sprite2D
		_expect(sprite != null and sprite.texture != null and sprite.scale.x > 0.0 and sprite.scale.y > 0.0, "V02.18 map readability should keep object sprite readable: %s" % anchor_id)
		var badge := node.find_child("LetterBadge", true, false) as Label
		_expect(badge != null and badge.text == letter and badge.size.x >= 28.0 and badge.size.y >= 28.0, "V02.18 map readability should keep readable badge: %s" % anchor_id)
		var look_cell := _v0218_best_look_cell(main, _dict_to_cell(anchor.get("position", {})), anchor_id)
		_expect(main.move_player_to_cell(look_cell).get("ok", false), "V02.18 map readability should reach anchor: %s" % anchor_id)
		_press_visible_button(interact_button, "V02.18 map readability should trigger anchor through visible Interact: %s" % anchor_id)
		_expect(str(main.life_status_label.text).contains(core_word), "V02.18 map readability feedback should name object: %s" % anchor_id)
		_expect(bool(main.memory_card_service.get_card_state(card_id).get("collected", false)), "V02.18 map readability should collect album card: %s" % anchor_id)
	_v0218_check_school_badge_spacing(world_map.get("memory_anchors", []))
	_expect(groups.has("home_anchors") and groups.has("school_line") and groups.has("first_ring") and groups.has("second_ring") and groups.has("far_edge"), "V02.18 map readability should cover all screenshot groups")
	_expect(main.open_memory_album().get("ok", false), "V02.18 map readability should open album after exploration")
	for forbidden in ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "等级", "打卡", "完成率", "倒计时", "迟到", "必须", "错过", "独自远行", "赶车"]:
		_expect(not _collect_visible_child_text(main).contains(forbidden), "V02.18 map readability visible text should avoid pressure wording: %s" % forbidden)
	main.close_memory_album()
	_expect(main.save_service.clear_for_test(), "V02.18 map readability save should clean up")
	root.remove_child(main)
	main.queue_free()


func _v0218_best_look_cell(main, anchor_cell: Vector2i, anchor_id: String) -> Vector2i:
	var candidates: Array[Vector2i] = [
		anchor_cell,
		anchor_cell + Vector2i(1, 0),
		anchor_cell + Vector2i(-1, 0),
		anchor_cell + Vector2i(0, 1),
		anchor_cell + Vector2i(0, -1),
	]
	for candidate in candidates:
		if main.move_player_to_cell(candidate).get("ok", false):
			var nearest_anchor: Dictionary = main.call("_find_nearest_anchor", 1)
			if str(nearest_anchor.get("anchor_id", "")) == anchor_id:
				return candidate
	return anchor_cell


func _v0218_check_school_badge_spacing(anchors: Array) -> void:
	var badge_rects: Array[Dictionary] = []
	for anchor_value in anchors:
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var letter := str(anchor.get("letter", ""))
		if not ["G", "K", "N", "R", "S", "Y"].has(letter):
			continue
		var rect := _v0218_badge_rect_for_anchor(anchor)
		for existing in badge_rects:
			_expect(not _v0218_rects_are_too_close(rect, existing.get("rect", Rect2())), "V02.18 School line badges should not visually stack: %s near %s" % [letter, existing.get("letter", "")])
		badge_rects.append({"letter": letter, "rect": rect})


func _v0218_badge_rect_for_anchor(anchor: Dictionary) -> Rect2:
	var cell := _dict_to_cell(anchor.get("position", {}))
	var route_order := int(anchor.get("route_order", 1))
	var top_left := (Vector2(cell.x, cell.y) + Vector2(0.5, 0.5)) * 16.0 + _v0218_anchor_badge_offset(route_order, str(anchor.get("letter", "")))
	return Rect2(top_left, Vector2(28, 28))


func _v0218_anchor_badge_offset(route_order: int, letter: String = "") -> Vector2:
	var per_letter_offsets: Dictionary = {
		"A": Vector2(-42, -34),
		"B": Vector2(-38, -24),
		"C": Vector2(36, -40),
		"D": Vector2(-42, 8),
		"E": Vector2(-42, -20),
		"F": Vector2(10, -42),
		"G": Vector2(24, -28),
		"H": Vector2(-38, -20),
		"I": Vector2(18, -36),
		"J": Vector2(-34, 4),
		"K": Vector2(-42, -18),
		"L": Vector2(18, -28),
		"M": Vector2(-42, -8),
		"N": Vector2(-42, -12),
		"O": Vector2(20, -10),
		"P": Vector2(18, 8),
		"Q": Vector2(-42, 6),
		"R": Vector2(18, -34),
		"S": Vector2(46, -14),
		"T": Vector2(20, 4),
		"U": Vector2(12, -62),
		"V": Vector2(-42, 6),
		"W": Vector2(20, -8),
		"X": Vector2(18, 2),
		"Y": Vector2(-42, -8),
		"Z": Vector2(16, -38),
	}
	if per_letter_offsets.has(letter):
		return per_letter_offsets.get(letter)
	var offsets: Array[Vector2] = [
		Vector2(8, -31),
		Vector2(-31, -27),
		Vector2(10, 7),
		Vector2(-31, 5),
	]
	return offsets[(max(route_order, 1) - 1) % offsets.size()]


func _v0218_rects_are_too_close(a: Rect2, b: Rect2) -> bool:
	var padded := Rect2(a.position - Vector2(4, 4), a.size + Vector2(8, 8))
	return padded.intersects(b)


func _dict_to_cell(cell: Variant) -> Vector2i:
	if cell is Vector2i:
		return cell
	if cell is Dictionary:
		var dict: Dictionary = cell
		return Vector2i(int(dict.get("x", 0)), int(dict.get("y", 0)))
	return Vector2i.ZERO


func _v0218_screenshot_group_for_letter(letter: String) -> String:
	if ["A", "C", "D", "T", "W"].has(letter):
		return "home_anchors"
	if ["G", "K", "N", "R", "S", "Y"].has(letter):
		return "school_line"
	if ["B", "Q", "V", "H", "I", "J", "O"].has(letter):
		return "first_ring"
	if ["E", "F", "L", "M", "P", "Z"].has(letter):
		return "second_ring"
	if ["U", "X"].has(letter):
		return "far_edge"
	return "reserved"


func _v0218_layer_for_letter(letter: String) -> String:
	if ["A", "C", "D", "T", "W", "G", "K", "N", "R", "Y", "S"].has(letter):
		return "p0_center"
	if ["B", "Q", "V", "H", "I", "J", "O"].has(letter):
		return "first_ring"
	if ["E", "F", "L", "M", "P", "Z"].has(letter):
		return "second_ring"
	if ["U", "X"].has(letter):
		return "far_edge"
	return "reserved"


func _collect_visible_child_text(node: Node) -> String:
	if node is Control and not (node as Control).visible:
		return ""
	var text := ""
	if node is Label:
		text += (node as Label).text + "\n"
	elif node is Button:
		text += (node as Button).text + "\n"
	for child in node.get_children():
		text += _collect_visible_child_text(child)
	return text


func _first_place_with_occupied_cells(places: Array) -> int:
	for index in range(places.size()):
		var place = places[index]
		if place is Dictionary and not (place as Dictionary).get("occupied_cells", []).is_empty():
			return index
	return 0


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
