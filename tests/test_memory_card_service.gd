extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const LETTER_SNAKE_CONFIG_PATH := "res://data/minigames/letter_snake_config.json"

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_memory_card_service.json")
	_expect(save_service.clear_for_test(), "test save should clear before run")

	var card_service = MemoryCardServiceScript.new(save_service)
	var load_result: Dictionary = card_service.load_cards()
	_expect(load_result.get("ok", false), "core cards should load")
	_expect(card_service.has_card("card_a_apple_core"), "core card A should be available")
	_expect(card_service.has_card("card_shop_egg"), "extension card egg should be available after V02-AZ-002")
	if not FileAccess.file_exists(MemoryCardServiceScript.EXTENSION_CARDS_PATH):
		_expect(not load_result.get("warnings", []).is_empty(), "missing extension cards should be reported as a warning")

	_check_state_round_trip(save_service, card_service)
	_check_letter_snake_reward_progress(save_service, card_service)
	_check_extension_card_reward_progress(save_service, card_service)

	_expect(save_service.clear_for_test(), "test save should clear after run")
	if failures.is_empty():
		print("MEMORY CARD SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _check_state_round_trip(save_service, card_service) -> void:
	var card_id := "card_a_apple_core"
	_expect(card_service.set_card_flags(card_id, {
		"seen": true,
		"heard": true,
		"played": true,
		"collected": true,
		"shiny": true,
		"spark": 2,
		"card_progress": 3,
	}), "card state should save")

	var reloaded_service = MemoryCardServiceScript.new(save_service)
	var state: Dictionary = reloaded_service.get_card_state(card_id)
	_expect(bool(state.get("seen", false)), "seen should round-trip")
	_expect(bool(state.get("heard", false)), "heard should round-trip")
	_expect(bool(state.get("played", false)), "played should round-trip")
	_expect(bool(state.get("collected", false)), "collected should round-trip")
	_expect(bool(state.get("shiny", false)), "shiny should round-trip")
	_expect(int(state.get("spark", 0)) == 2, "spark should round-trip")
	_expect(int(state.get("card_progress", 0)) == 3, "card_progress should round-trip")

	var learning_record: Dictionary = save_service.load_learning_record()
	var saved_state: Dictionary = learning_record.get("card_states", {}).get(card_id, {})
	_expect(bool(saved_state.get("heard", false)), "state should be written under SaveService learning_record.card_states")


func _check_letter_snake_reward_progress(save_service, card_service) -> void:
	var config := _load_json(LETTER_SNAKE_CONFIG_PATH)
	var home_set := _set_by_id(config.get("sets", []), "home")
	var reward := _tier_by_id(config.get("reward_profile", {}).get("tiers", []), "gold")
	reward["collected_chance"] = 1.0
	reward["shiny_chance"] = 1.0

	var result := {
		"minigame_id": "letter_snake",
		"config_set_id": "home",
		"score": 80,
		"target_letters_seen": home_set.get("target_letters", []),
		"target_words_seen": home_set.get("target_words", []),
		"target_hits": 6,
		"distractor_touches": 0,
		"duration_seconds": 60,
		"card_ids": home_set.get("card_ids", []),
		"reward": reward,
	}

	var applied: Dictionary = card_service.apply_minigame_reward(result)
	_expect(applied.get("ok", false), "home Letter Snake reward should apply without skipped core cards")
	for card_id in home_set.get("card_ids", []):
		var state: Dictionary = card_service.get_card_state(str(card_id))
		_expect(bool(state.get("seen", false)), "reward should mark seen: %s" % card_id)
		_expect(bool(state.get("played", false)), "reward should mark played: %s" % card_id)
		_expect(bool(state.get("collected", false)), "reward should collect card: %s" % card_id)
		_expect(bool(state.get("shiny", false)), "reward should set shiny when chance is guaranteed: %s" % card_id)
		_expect(int(state.get("spark", 0)) >= 1, "reward should add spark: %s" % card_id)
		_expect(int(state.get("card_progress", 0)) >= int(reward.get("card_progress", 0)), "reward should add card_progress: %s" % card_id)

	var learning_record: Dictionary = save_service.load_learning_record()
	_expect(learning_record.get("minigame_results", []).size() == 1, "minigame result should be appended to learning_record")


func _check_extension_card_reward_progress(save_service, card_service) -> void:
	var config := _load_json(LETTER_SNAKE_CONFIG_PATH)
	var food_set := _set_by_id(config.get("sets", []), "food")
	var reward := _tier_by_id(config.get("reward_profile", {}).get("tiers", []), "bright")

	var result := {
		"minigame_id": "letter_snake",
		"config_set_id": "food",
		"score": 35,
		"target_letters_seen": food_set.get("target_letters", []),
		"target_words_seen": food_set.get("target_words", []),
		"target_hits": 3,
		"distractor_touches": 1,
		"duration_seconds": 60,
		"card_ids": food_set.get("card_ids", []),
		"reward": reward,
	}

	var applied: Dictionary = card_service.apply_minigame_reward(result)
	_expect(applied.get("ok", false), "food Letter Snake reward should apply to core and extension cards")
	var egg_state: Dictionary = card_service.get_card_state("card_shop_egg")
	_expect(bool(egg_state.get("seen", false)), "reward should mark extension card seen")
	_expect(bool(egg_state.get("played", false)), "reward should mark extension card played")
	_expect(int(egg_state.get("card_progress", 0)) >= int(reward.get("card_progress", 0)), "reward should add progress to extension card")


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		failures.append("Cannot open JSON: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		failures.append("JSON root must be a dictionary: %s" % path)
		return {}
	return parsed


func _set_by_id(sets: Array, set_id: String) -> Dictionary:
	for item in sets:
		if item is Dictionary and item.get("set_id", "") == set_id:
			return item.duplicate(true)
	failures.append("Missing Letter Snake set: %s" % set_id)
	return {}


func _tier_by_id(tiers: Array, tier_id: String) -> Dictionary:
	for item in tiers:
		if item is Dictionary and item.get("tier_id", "") == tier_id:
			return item.duplicate(true)
	failures.append("Missing Letter Snake reward tier: %s" % tier_id)
	return {}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
