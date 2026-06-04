extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const ParentDashboardScene := preload("res://scenes/parent_dashboard/parent_dashboard.tscn")
const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_parent_dashboard_scene.json")
	_expect(save_service.clear_for_test(), "test save should clear")
	_expect(save_service.reset_for_test(), "test save should reset")
	_seed_parent_summary_data(save_service)

	var scene: Control = ParentDashboardScene.instantiate()
	root.add_child(scene)
	scene.call("set_save_service", save_service)
	scene.call("_ready")
	scene.call("refresh")

	_expect(scene.find_child("ParentDashboardContent", true, false) != null, "parent dashboard should create content stack")
	_expect(scene.find_child("OverviewPanel", true, false) != null, "parent dashboard should show overview panel")
	_expect(scene.find_child("CardsSummaryPanel", true, false) != null, "parent dashboard should show cards panel")
	_expect(scene.find_child("ActivitySummaryPanel", true, false) != null, "parent dashboard should show activity panel")
	_expect(scene.find_child("NpcSummaryPanel", true, false) != null, "parent dashboard should show NPC panel")
	_expect(scene.find_child("PrivacySettingsPanel", true, false) != null, "parent dashboard should show privacy settings panel")
	_expect(bool(scene.call("is_local_only")), "parent dashboard should stay local only")

	var summary: Dictionary = scene.call("get_dashboard_summary")
	_expect(int(summary.get("learning_time", {}).get("minutes", 0)) == 4, "dashboard scene should read learning minutes")
	_expect(int(summary.get("cards", {}).get("contacted_count", 0)) == 2, "dashboard scene should read contacted cards")
	_expect(int(summary.get("cards", {}).get("collected_count", 0)) == 1, "dashboard scene should read collected cards")
	_expect(int(summary.get("minigames", {}).get("result_count", 0)) == 1, "dashboard scene should read minigame count")
	_expect(int(summary.get("npc_summaries", {}).get("count", 0)) == 1, "dashboard scene should read NPC summary count")

	var visible_text := str(scene.call("get_visible_text"))
	for expected in ["Parent Dashboard", "Local family summary", "Profile: Sunny", "Time: 4 min", "Contacted: 2", "Collected: 1", "Minigames: 1", "Summaries: 1", "Network: off", "Recording: off", "Account: off"]:
		_expect(visible_text.contains(expected), "parent dashboard visible text should include: %s" % expected)

	root.remove_child(scene)
	scene.queue_free()

	var main = MainScene.instantiate()
	main.configure_for_test("user://test_parent_dashboard_scene_main.json")
	root.add_child(main)
	main.call("_ready")
	_expect(main.find_child("ParentDashboard", true, false) == null, "child main scene should not mount parent dashboard")
	_expect(main.find_child("ParentDashboardContent", true, false) == null, "child main scene should not mount parent dashboard content")
	main.save_service.clear_for_test()

	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _seed_parent_summary_data(save_service) -> void:
	_expect(save_service.save_profile({
		"profile_id": "local_profile",
		"display_name": "Sunny",
		"local_settings": {"recording_enabled": false},
	}), "profile should save")
	_expect(save_service.save_game_state({
		"coins": 14,
		"current_place_id": "home",
		"pet": {"pet_id": "sunny_dog", "hunger": 1, "food_count": 0},
		"inventory": {},
		"flags": {},
		"learning_seconds": 185,
		"session_count": 2,
		"local_settings": {"ai_enabled": false, "network_enabled": false},
	}), "game_state should save")
	_expect(save_service.save_learning_record({
		"profile_id": "local_profile",
		"card_states": {
			"card_a_apple": {"seen": true, "heard": true, "card_progress": 1},
			"card_shop_egg": {"seen": true, "played": true, "collected": true, "shiny": true, "card_progress": 4},
		},
		"minigame_results": [
			{
				"minigame_id": "letter_snake",
				"config_set_id": "food",
				"score": 35,
				"duration_seconds": 70,
				"reward": {"coins": 6},
			},
		],
		"npc_summary_refs": [
			{"summary_id": "summary_mina_001", "npc_id": "mina", "title": "Mina greeted Sunny near Home."},
		],
		"local_settings": {"parent_summary_enabled": true},
	}), "learning_record should save")


func _finish() -> void:
	if failures.is_empty():
		print("PARENT DASHBOARD SCENE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
