extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var service = SaveServiceScript.new("user://test_save_service_stub.json")
	_expect(service.get_save_path().begins_with("user://"), "SaveService must use a user:// path")
	_expect(service.clear_for_test(), "clear_for_test should remove existing test save")

	var default_profile: Dictionary = service.load_profile()
	_expect(default_profile.get("profile_id") == "local_profile", "default profile should be local")

	var profile := {
		"profile_id": "local_profile",
		"display_name": "Sunny",
		"created_at": "2026-06-04T00:00:00Z",
		"updated_at": "2026-06-04T00:00:00Z",
	}
	var game_state := {
		"coins": 25,
		"current_place_id": "supermarket",
		"pet": {
			"pet_id": "sunny_dog",
			"hunger": 3,
			"food_count": 1,
		},
		"inventory": {
			"apple_snack": 2,
		},
		"flags": {
			"met_pet": true,
		},
	}
	var learning_record := {
		"profile_id": "local_profile",
		"card_states": {
			"card_a_apple": {
				"seen": true,
				"heard": true,
				"played": true,
				"collected": false,
				"shiny": false,
			},
		},
		"word_exposures": {
			"apple": 2,
		},
		"voice_attempts": [],
		"minigame_results": [
			{
				"minigame_id": "letter_snake",
				"target": "A",
				"coins_earned": 5,
			},
		],
		"npc_summary_refs": [],
	}

	_expect(service.save_profile(profile), "profile should save")
	_expect(service.save_game_state(game_state), "game_state should save")
	_expect(service.save_learning_record(learning_record), "learning_record should save")

	var reloaded = SaveServiceScript.new("user://test_save_service_stub.json")
	_expect(reloaded.load_profile() == profile, "profile should round-trip")
	var loaded_game_state: Dictionary = reloaded.load_game_state()
	_expect(int(loaded_game_state.get("coins", -1)) == 25, "game_state coins should round-trip")
	_expect(loaded_game_state.get("current_place_id", "") == "supermarket", "game_state current place should round-trip")
	_expect(int(loaded_game_state.get("pet", {}).get("food_count", -1)) == 1, "game_state nested pet data should round-trip")
	_expect(int(loaded_game_state.get("inventory", {}).get("apple_snack", -1)) == 2, "game_state inventory should round-trip")
	_expect(bool(loaded_game_state.get("flags", {}).get("met_pet", false)), "game_state flags should round-trip")

	var loaded_learning_record: Dictionary = reloaded.load_learning_record()
	_expect(loaded_learning_record.get("profile_id", "") == "local_profile", "learning_record profile id should round-trip")
	_expect(bool(loaded_learning_record.get("card_states", {}).get("card_a_apple", {}).get("played", false)), "learning_record card state should round-trip")
	_expect(int(loaded_learning_record.get("word_exposures", {}).get("apple", -1)) == 2, "learning_record word exposures should round-trip")
	_expect(loaded_learning_record.get("minigame_results", []).size() == 1, "learning_record minigame results should round-trip")

	_expect(reloaded.reset_for_test(), "reset_for_test should write defaults")
	_expect(reloaded.load_game_state().get("coins") == 0, "reset_for_test should restore default game_state")
	_expect(reloaded.clear_for_test(), "clear_for_test should remove test save after run")

	if failures.is_empty():
		print("SAVE SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
