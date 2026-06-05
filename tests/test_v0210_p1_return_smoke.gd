extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0210_p1_return_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "P1 return smoke save should clear before scene startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	_complete_story_bear_path(main)
	main.set_day_key_for_test("local_day_005")
	main.call("_update_today_status")
	_complete_bus_helper_path(main)
	_check_album_records(main)
	_check_p0_paths_still_open(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _complete_story_bear_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "P1 smoke should move near Story Bear")
	_press(interact_button, "P1 smoke should greet Story Bear through visible Interact")
	_press(interact_button, "P1 smoke should start Story Bear request through visible Interact")
	_expect(str(main.life_status_label.text).contains("Bear Corner"), "P1 smoke Story Bear request should mention Bear Corner")

	_expect(main.move_player_to_cell(Vector2i(13, 7)).get("ok", false), "P1 smoke should move to Bear Corner")
	_press(interact_button, "P1 smoke should see Bear Corner through visible Interact")
	_expect(str(main.life_status_label.text).contains("熊形书牌"), "P1 smoke Bear Corner should show gentle feedback")

	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "P1 smoke should return to Story Bear")
	_press(interact_button, "P1 smoke should complete Story Bear request")
	var state: Dictionary = main.save_service.load_game_state()
	var request_state: Dictionary = state.get("daily_requests", {}).get("local_day_004", {}).get("daily_story_bear_find_bear_corner_001", {})
	_expect(bool(request_state.get("completed_today", false)), "P1 smoke should persist Story Bear request completion")
	_expect(bool(main.memory_card_service.get_card_state("card_b_bear_core").get("collected", false)), "P1 smoke should collect B Bear album card")


func _complete_bus_helper_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "P1 smoke should move near Bus Helper")
	_press(interact_button, "P1 smoke should greet Bus Helper through visible Interact")
	_press(interact_button, "P1 smoke should start Bus Helper request through visible Interact")
	_expect(str(main.life_status_label.text).contains("taxi"), "P1 smoke Bus Helper request should mention taxi marker")

	_expect(main.move_player_to_cell(Vector2i(31, 10)).get("ok", false), "P1 smoke should move to Taxi marker")
	_press(interact_button, "P1 smoke should see Taxi marker through visible Interact")
	_expect(str(main.life_status_label.text).contains("黄色小标记"), "P1 smoke Taxi marker should show gentle feedback")

	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "P1 smoke should return to Bus Helper")
	_press(interact_button, "P1 smoke should complete Bus Helper request")
	var state: Dictionary = main.save_service.load_game_state()
	var request_state: Dictionary = state.get("daily_requests", {}).get("local_day_005", {}).get("daily_bus_helper_taxi_spot_001", {})
	_expect(bool(request_state.get("completed_today", false)), "P1 smoke should persist Bus Helper request completion")
	_expect(bool(main.memory_card_service.get_card_state("card_t_taxi_core").get("collected", false)), "P1 smoke should collect T Taxi album card")


func _check_album_records(main) -> void:
	_expect(main.open_memory_album().get("ok", false), "P1 smoke should open child-facing album")
	_expect(_card_visible_text(main, "card_b_bear_core").contains("已收藏"), "P1 smoke album should show B Bear collected")
	_expect(_card_visible_text(main, "card_t_taxi_core").contains("已收藏"), "P1 smoke album should show T Taxi collected")
	_expect(not _collect_visible_text(main).contains("正确率"), "P1 smoke album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "P1 smoke album should not show level wording")
	main.close_memory_album()


func _check_p0_paths_still_open(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "P1 smoke should still move near Mina")
	_press(interact_button, "P1 smoke should still greet or advance Mina")
	_press(interact_button, "P1 smoke should still start Mina request")
	_expect(str(main.life_status_label.text).contains("树枝"), "P1 smoke should keep Mina P0 request visible")

	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(12, int(state.get("coins", 0)))
	_expect(main.save_service.save_game_state(state), "P1 smoke should prepare gentle coins for P0 shop check")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "P1 smoke should still move to shop")
	_press(interact_button, "P1 smoke should still open shop through visible Interact")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "P1 smoke should keep P0 shop panel available")

	_press(main.find_child("HomeNavButton", true, false) as Button, "P1 smoke should still open HomeRoom from visible footer")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "P1 smoke should keep HomeRoom available")


func _check_child_safe_visible_text(main) -> void:
	for forbidden in ["Godot skeleton", "Loaded places", "阅读测验", "测验", "考试", "评分", "背诵", "倒计时", "赶时间", "陌生人带走", "独自远行", "上车", "错过班车", "正确率", "等级"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "P1 smoke visible UI should not contain forbidden text: %s" % forbidden)


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
		print("V02.10 P1 RETURN SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
