extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const HOMESCHOOL_PATH: Array[Dictionary] = [
	{"event_id": "homeschool_home_morning_bag_001", "cell": Vector2i(4, 7), "stage": "home_morning", "text": "Good morning", "cards": ["card_a_apple_core", "card_c_clock_core", "card_w_watch_core"]},
	{"event_id": "homeschool_home_sunny_good_morning_001", "cell": Vector2i(6, 8), "stage": "home_morning", "text": "Sunny", "cards": ["card_d_dog_core", "card_c_clock_core"]},
	{"event_id": "homeschool_walk_gate_sign_001", "cell": Vector2i(8, 11), "stage": "home_school_walk", "text": "school gate", "cards": ["card_g_gate_core", "card_w_watch_core"]},
	{"event_id": "homeschool_walk_kite_sky_001", "cell": Vector2i(9, 12), "stage": "home_school_walk", "text": "Kite", "cards": ["card_k_kite_core", "card_s_sun_core"]},
	{"event_id": "homeschool_school_gate_hello_001", "cell": Vector2i(11, 13), "stage": "school_gate", "text": "Hello", "cards": ["card_e_elephant_core", "card_g_gate_core"]},
	{"event_id": "homeschool_school_yard_play_001", "cell": Vector2i(11, 15), "stage": "school_yard", "text": "Robot", "cards": ["card_n_net_core", "card_r_robot_core", "card_y_yo_yo_core", "card_k_kite_core"]},
	{"event_id": "homeschool_return_sunny_story_001", "cell": Vector2i(5, 8), "stage": "return_home", "text": "回到小屋", "cards": ["card_d_dog_core", "card_a_apple_core", "card_o_orange_core"]},
]

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0214_homeschool_slice.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.14 homeschool save should clear before scene startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_homeschool_visible_path(main)
	_check_album_records(main)
	_check_existing_p0_paths(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_homeschool_visible_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	for step in HOMESCHOOL_PATH:
		var event_id := str(step.get("event_id", ""))
		_expect(main.find_child(event_id, true, false) != null, "V02.14 hotspot should be visible in runtime map: %s" % event_id)
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "Player should move to homeschool step: %s" % event_id)
		_press(interact_button, "Visible Interact should trigger homeschool step: %s" % event_id)
		_expect(str(main.life_status_label.text).contains(str(step.get("text", ""))), "Homeschool HUD should show gentle step feedback: %s" % event_id)
		var result: Dictionary = main.save_service.load_game_state().get("homeschool_events", {}).get(event_id, {})
		_expect(bool(result.get("seen", false)), "Homeschool step should persist seen state: %s" % event_id)
		_expect(str(result.get("stage", "")) == str(step.get("stage", "")), "Homeschool step should persist stage: %s" % event_id)
		_expect(not (result.get("anchor_ids", []) as Array).is_empty(), "Homeschool step should persist anchor ids: %s" % event_id)
		for card_id in step.get("cards", []):
			var card_state: Dictionary = main.memory_card_service.get_card_state(str(card_id))
			_expect(bool(card_state.get("seen", false)), "Homeschool step should mark card seen: %s" % card_id)
			_expect(bool(card_state.get("heard", false)), "Homeschool step should mark card heard: %s" % card_id)
			_expect(bool(card_state.get("collected", false)), "Homeschool step should mark card collected: %s" % card_id)


func _check_album_records(main) -> void:
	_expect(main.open_memory_album().get("ok", false), "Homeschool slice should open child-facing album")
	for card_id in ["card_a_apple_core", "card_c_clock_core", "card_d_dog_core", "card_g_gate_core", "card_k_kite_core", "card_n_net_core", "card_r_robot_core", "card_y_yo_yo_core"]:
		_expect(_card_visible_text(main, card_id).contains("已收藏"), "Homeschool album should show collected card: %s" % card_id)
	_expect(not _collect_visible_text(main).contains("正确率"), "Homeschool album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "Homeschool album should not show level wording")
	main.close_memory_album()


func _check_existing_p0_paths(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "P0 shop hotspot should remain walkable")
	_press(interact_button, "Visible Interact should still open shop after homeschool path")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "P0 shop panel should still open")
	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "P0 Home hotspot should remain walkable")
	_press(interact_button, "Visible Interact should still open Home after homeschool path")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "P0 Home room should still open")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "Home room should keep Sunny feedback")


func _check_child_safe_visible_text(main) -> void:
	for forbidden in ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "倒计时", "迟到", "作业", "老师评价", "家长报告", "独自远行", "上车", "必须"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "Visible homeschool UI should not contain forbidden text: %s" % forbidden)


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
		print("V02.14 HOMESCHOOL SLICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
