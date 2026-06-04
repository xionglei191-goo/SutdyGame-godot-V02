extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const ParentDashboardStoreScript := preload("res://scripts/systems/parent_dashboard_store.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_parent_dashboard_store.json")
	_expect(save_service.clear_for_test(), "test save should clear")
	_expect(save_service.reset_for_test(), "test save should reset")

	_expect(save_service.save_profile({
		"profile_id": "local_profile",
		"display_name": "Sunny",
		"local_settings": {
			"recording_enabled": false,
		},
	}), "profile should save")
	_expect(save_service.save_game_state({
		"coins": 14,
		"current_place_id": "home",
		"pet": {
			"pet_id": "sunny_dog",
			"hunger": 1,
			"food_count": 0,
		},
		"inventory": {},
		"flags": {},
		"learning_seconds": 185,
		"session_count": 2,
		"local_settings": {
			"ai_enabled": false,
			"network_enabled": false,
		},
	}), "game_state should save")
	_expect(save_service.save_learning_record({
		"profile_id": "local_profile",
		"card_states": {
			"card_a_apple": {
				"seen": true,
				"heard": true,
				"played": false,
				"collected": false,
				"shiny": false,
				"card_progress": 1,
			},
			"card_shop_egg": {
				"seen": true,
				"heard": false,
				"played": true,
				"collected": true,
				"shiny": true,
				"card_progress": 4,
			},
		},
		"word_exposures": {
			"apple": 2,
			"egg": 1,
		},
		"voice_attempts": [],
		"minigame_results": [
			{
				"minigame_id": "letter_snake",
				"config_set_id": "food",
				"score": 35,
				"duration_seconds": 70,
				"reward": {
					"coins": 6,
				},
			},
		],
		"npc_summary_refs": [
			{
				"summary_id": "summary_mina_001",
				"npc_id": "mina",
				"title": "Mina greeted Sunny near Home.",
			},
		],
		"local_settings": {
			"parent_summary_enabled": true,
		},
	}), "learning_record should save")

	var store = ParentDashboardStoreScript.new(save_service)
	var summary: Dictionary = store.build_dashboard_summary()

	_expect(summary.get("source", "") == "local_stub", "summary should be local stub")
	_expect(summary.get("profile", {}).get("profile_id", "") == "local_profile", "profile id should come from save")
	_expect(int(summary.get("learning_time", {}).get("seconds", 0)) == 185, "learning seconds should come from save")
	_expect(int(summary.get("learning_time", {}).get("minutes", 0)) == 4, "learning minutes should round up")
	_expect(int(summary.get("cards", {}).get("contacted_count", 0)) == 2, "contacted card count should include constructed card states")
	_expect(int(summary.get("cards", {}).get("collected_count", 0)) == 1, "collected card count should be summarized")
	_expect(summary.get("cards", {}).get("contacted_card_ids", []).has("card_shop_egg"), "contacted card ids should include extension card")
	_expect(int(summary.get("minigames", {}).get("result_count", 0)) == 1, "minigame result count should be summarized")
	_expect(int(summary.get("minigames", {}).get("total_coins", 0)) == 6, "minigame reward coins should be summarized")
	_expect(summary.get("minigames", {}).get("minigame_ids", []).has("letter_snake"), "minigame ids should include Letter Snake")
	_expect(int(summary.get("npc_summaries", {}).get("count", 0)) == 1, "NPC summary refs should be summarized")
	_expect(summary.get("npc_summaries", {}).get("latest_ref", {}).get("summary_id", "") == "summary_mina_001", "latest NPC summary ref should be exposed")
	_expect(bool(summary.get("local_settings", {}).get("settings", {}).get("parent_summary_enabled", false)), "learning local settings should be exposed")
	_expect(not bool(summary.get("privacy", {}).get("network_enabled", true)), "dashboard stub must not enable network")
	_expect(not bool(summary.get("privacy", {}).get("account_enabled", true)), "dashboard stub must not enable real account")

	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("PARENT DASHBOARD STORE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
