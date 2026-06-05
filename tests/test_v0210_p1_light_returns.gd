extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0210_p1_light_returns.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "P1 light return save should clear before scene startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	_check_story_bear_light_return(main)
	main.set_day_key_for_test("local_day_005")
	main.call("_update_today_status")
	_check_bus_helper_light_return(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_story_bear_light_return(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "Player should move near Story Bear")
	_press(interact_button, "Story Bear should greet through visible Interact")
	_press(interact_button, "Story Bear P1 request should start through visible Interact")
	_expect(str(main.life_status_label.text).contains("Bear Corner"), "Story Bear request should mention Bear Corner")

	_expect(main.move_player_to_cell(Vector2i(13, 7)).get("ok", false), "Player should move to Bear Corner entry")
	_press(interact_button, "Bear Corner should be seen through visible Interact")
	_expect(str(main.life_status_label.text).contains("熊形书牌"), "Bear Corner entry should show gentle feedback")
	var bear_card_state: Dictionary = main.memory_card_service.get_card_state("card_b_bear_core")
	_expect(bool(bear_card_state.get("collected", false)), "Bear Corner P1 entry should write B Bear album card")

	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "Player should return to Story Bear")
	_press(interact_button, "Story Bear P1 request should complete after Bear Corner seen")
	var game_state: Dictionary = main.save_service.load_game_state()
	var request_state: Dictionary = game_state.get("daily_requests", {}).get("local_day_004", {}).get("daily_story_bear_find_bear_corner_001", {})
	_expect(bool(request_state.get("completed_today", false)), "Story Bear P1 request should persist completion")
	_expect(int(game_state.get("coins", 0)) == 5, "Story Bear P1 request should award gentle coins once")
	var relationship: Dictionary = main.save_service.load_learning_record().get("npc_relationships", {}).get("story_bear", {})
	_expect(int(relationship.get("favor", 0)) == 1, "Story Bear P1 request should add relationship favor")
	_expect(main.open_memory_album().get("ok", false), "Story Bear P1 path should expose album UI")
	_expect(_card_visible_text(main, "card_b_bear_core").contains("已收藏"), "Story Bear P1 path should show B Bear collected in album")
	main.close_memory_album()
	_press(interact_button, "Story Bear P1 repeat should stay gentle")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) == 5, "Story Bear P1 repeat should not duplicate coins")


func _check_bus_helper_light_return(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "Player should move near Bus Helper")
	_press(interact_button, "Bus Helper should greet through visible Interact")
	_press(interact_button, "Bus Helper P1 request should start through visible Interact")
	_expect(str(main.life_status_label.text).contains("taxi"), "Bus Helper request should mention taxi marker")

	_expect(main.move_player_to_cell(Vector2i(31, 10)).get("ok", false), "Player should move to Taxi marker entry")
	_press(interact_button, "Taxi marker should be seen through visible Interact")
	_expect(str(main.life_status_label.text).contains("黄色小标记"), "Taxi marker entry should show gentle feedback")
	var taxi_card_state: Dictionary = main.memory_card_service.get_card_state("card_t_taxi_core")
	_expect(bool(taxi_card_state.get("collected", false)), "Taxi marker P1 entry should write T Taxi album card")

	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "Player should return to Bus Helper")
	_press(interact_button, "Bus Helper P1 request should complete after Taxi marker seen")
	var game_state: Dictionary = main.save_service.load_game_state()
	var request_state: Dictionary = game_state.get("daily_requests", {}).get("local_day_005", {}).get("daily_bus_helper_taxi_spot_001", {})
	_expect(bool(request_state.get("completed_today", false)), "Bus Helper P1 request should persist completion")
	_expect(int(game_state.get("coins", 0)) == 11, "Bus Helper P1 request should add gentle coins once")
	var relationship: Dictionary = main.save_service.load_learning_record().get("npc_relationships", {}).get("bus_helper", {})
	_expect(int(relationship.get("favor", 0)) == 1, "Bus Helper P1 request should add relationship favor")
	_expect(main.open_memory_album().get("ok", false), "Bus Helper P1 path should expose album UI")
	_expect(_card_visible_text(main, "card_t_taxi_core").contains("已收藏"), "Bus Helper P1 path should show T Taxi collected in album")
	_expect(not _collect_visible_text(main).contains("正确率"), "P1 album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "P1 album should not show level wording")
	main.close_memory_album()
	_press(interact_button, "Bus Helper P1 repeat should stay gentle")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) == 11, "Bus Helper P1 repeat should not duplicate coins")


func _check_child_safe_visible_text(main) -> void:
	for forbidden in ["阅读测验", "测验", "考试", "评分", "背诵", "倒计时", "赶时间", "陌生人带走", "独自远行", "上车", "错过班车"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "Visible UI should not contain forbidden text: %s" % forbidden)


func _press(button: Button, message: String) -> void:
	_expect(button != null and _is_control_path_visible(button) and not button.disabled, message)
	if button != null and _is_control_path_visible(button) and not button.disabled:
		button.emit_signal("pressed")


func _is_control_path_visible(node: Node) -> bool:
	var current := node
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _collect_visible_text(node: Node) -> String:
	if node is Control and not (node as Control).visible:
		return ""
	var text := ""
	if node is Label:
		text += (node as Label).text + "\n"
	elif node is Button:
		text += (node as Button).text + "\n"
	for child in node.get_children():
		text += _collect_visible_text(child)
	return text


func _card_visible_text(main, card_id: String) -> String:
	var card: Node = main.find_child(card_id, true, false)
	return _collect_visible_text(card) if card != null else ""


func _finish() -> void:
	if failures.is_empty():
		print("V02.10 P1 LIGHT RETURN TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
