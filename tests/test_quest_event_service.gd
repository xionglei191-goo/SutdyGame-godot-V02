extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_quest_event_service.json")
	_expect(save_service.clear_for_test(), "test save should clear")
	var quest = QuestEventServiceScript.new(save_service)
	var minigame = MinigameServiceScript.new(save_service)

	_expect(quest.start_chain().get("ok", false), "quest chain should start")
	for event_id in ["event_welcome_home", "event_meet_sunny", "event_snack_time", "event_food_trip"]:
		_expect(quest.advance_event(event_id).get("ok", false), "event should advance: %s" % event_id)

	var blocked: Dictionary = quest.advance_event("event_food_basket")
	_expect(not blocked.get("ok", true), "food basket should wait when coins are low")
	_expect(blocked.get("needs", "") == "letter_snake_food", "low coins should request Letter Snake")

	var mini_result: Dictionary = minigame.complete_minigame({"config_set_id": "food", "score": 80})
	_expect(mini_result.get("ok", false), "Letter Snake food run should complete")
	_expect(quest.advance_event("event_letter_snake_food").get("ok", false), "Letter Snake quest event should advance")
	_expect(quest.advance_event("event_food_basket").get("ok", false), "food basket should purchase after coins")
	_expect(quest.advance_event("event_feed_sunny").get("ok", false), "feed event should complete after purchase")

	var state: Dictionary = save_service.load_game_state()
	_expect(state.get("current_event_id", "not-empty") == "", "quest chain should end after Feed Sunny")
	_expect(bool(state.get("pet", {}).get("fed_today", false)), "pet should be fed")
	_expect(bool(state.get("flags", {}).get("sunny_first_snack_done", false)), "completion flag should save")
	_expect(bool(save_service.load_learning_record().get("card_states", {}).get("card_pet_food", {}).get("played", false)), "pet food card should be played")

	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("QUEST EVENT SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
