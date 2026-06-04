extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_minigame_service.json")
	_expect(save_service.clear_for_test(), "test save should clear")
	_expect(save_service.reset_for_test(), "test save should reset")
	var service = MinigameServiceScript.new(save_service)

	var start: Dictionary = service.start_minigame("food")
	_expect(start.get("ok", false), "food set should start")
	_expect(start.get("set", {}).get("target_words", []).has("egg"), "food set should include egg")

	var low: Dictionary = service.complete_minigame(_result("food", 0))
	_expect(low.get("ok", false), "low score should still complete")
	_expect(int(low.get("reward", {}).get("coins", 0)) == 3, "low score should earn floor coins")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 3, "low score coins should save")

	var high: Dictionary = service.complete_minigame(_result("food", 80))
	_expect(high.get("ok", false), "high score should complete")
	_expect(int(high.get("reward", {}).get("coins", 0)) == 12, "high score should earn gold coins")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 15, "coins should accumulate")
	var egg_state: Dictionary = save_service.load_learning_record().get("card_states", {}).get("card_shop_egg", {})
	_expect(bool(egg_state.get("played", false)), "minigame should mark extension card played")
	_expect(int(egg_state.get("card_progress", 0)) >= 5, "minigame should add card progress across runs")

	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _result(set_id: String, score: int) -> Dictionary:
	return {
		"config_set_id": set_id,
		"score": score,
		"target_letters_seen": [],
		"target_words_seen": [],
		"target_hits": 0,
		"distractor_touches": 0,
		"duration_seconds": 60,
	}


func _finish() -> void:
	if failures.is_empty():
		print("MINIGAME SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
