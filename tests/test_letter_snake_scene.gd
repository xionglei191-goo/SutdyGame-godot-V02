extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const LetterSnakeScene := preload("res://scenes/minigames/letter_snake.tscn")

var failures: Array[String] = []
var emitted_completion: Dictionary = {}
var emitted_return_scene: String = ""


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_letter_snake_scene.json")
	_expect(save_service.clear_for_test(), "test save should clear before run")
	_expect(save_service.reset_for_test(), "test save should reset")

	var scene: Control = LetterSnakeScene.instantiate()
	root.add_child(scene)
	scene.call("set_save_service", save_service)
	scene.connect("completed", _on_completed)
	scene.connect("return_requested", _on_return_requested)

	var start: Dictionary = scene.call("start_round", "food")
	_expect(start.get("ok", false), "food set should start in scene")
	_expect(scene.call("get_target_letters") == ["A", "O", "E"], "scene should expose food target letters")
	_expect(scene.call("get_target_words") == ["apple", "orange", "egg"], "scene should expose food target words")
	_expect(_label_text(scene, "GroupLabel") == "Food Trail", "scene should display food target group")
	_expect(_label_text(scene, "WordLabel").contains("egg"), "scene should display food words")

	scene.call("set_score", 80)
	var completion: Dictionary = scene.call("complete_round")
	_expect(completion.get("ok", false), "scene completion should succeed")
	_expect(completion.get("return_scene", "") == "world_overview", "scene completion should expose world_overview return")
	_expect(emitted_completion.get("return_scene", "") == "world_overview", "scene should emit completion")
	_expect(int(completion.get("reward", {}).get("coins", 0)) == 12, "scene score should convert to gold coins")
	_expect(int(completion.get("reward", {}).get("card_progress", 0)) == 4, "scene score should convert to card progress")

	var game_state: Dictionary = save_service.load_game_state()
	_expect(int(game_state.get("coins", 0)) == 12, "scene completion should save coins")
	var egg_state: Dictionary = save_service.load_learning_record().get("card_states", {}).get("card_shop_egg", {})
	_expect(bool(egg_state.get("played", false)), "scene completion should update extension card played state")
	_expect(int(egg_state.get("card_progress", 0)) >= 4, "scene completion should update card progress")
	_expect(save_service.load_learning_record().get("minigame_results", []).size() == 1, "scene completion should append result")

	scene.call("request_return")
	_expect(emitted_return_scene == "world_overview", "scene should emit return target")

	root.remove_child(scene)
	scene.queue_free()
	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _label_text(scene: Node, node_name: String) -> String:
	var label := scene.find_child(node_name, true, false) as Label
	if label == null:
		failures.append("Missing label: %s" % node_name)
		return ""
	return label.text


func _on_completed(completion: Dictionary) -> void:
	emitted_completion = completion.duplicate(true)


func _on_return_requested(return_scene: String) -> void:
	emitted_return_scene = return_scene


func _finish() -> void:
	if failures.is_empty():
		print("LETTER SNAKE SCENE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
