extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const SCHOOL_DAILY_PATH: Array[Dictionary] = [
	{"event_id": "homeschool_walk_gate_sign_001", "cell": Vector2i(8, 11), "stage": "home_school_walk"},
	{"event_id": "homeschool_school_gate_hello_001", "cell": Vector2i(11, 13), "stage": "school_gate"},
	{"event_id": "homeschool_school_yard_play_001", "cell": Vector2i(11, 15), "stage": "school_yard"},
	{"event_id": "homeschool_return_sunny_story_001", "cell": Vector2i(5, 8), "stage": "return_home"},
]

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0215_school_daily_slice.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.15 school daily save should clear before scene startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_seven_day_school_daily_path(main)
	_check_existing_paths_after_school_daily(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_seven_day_school_daily_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var seen_school_day_events: Dictionary = {}
	var seen_return_events: Dictionary = {}
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")
		var school_state: Dictionary = main.school_day_state_service.get_today_school_state()
		_expect(school_state.get("ok", false), "V02.15 should resolve school day state: %s" % day_key)
		_expect(str(school_state.get("day_key", "")) == day_key, "V02.15 should keep requested school day key: %s" % day_key)

		for step in SCHOOL_DAILY_PATH:
			var stage := str(step.get("stage", ""))
			var event_id := str(step.get("event_id", ""))
			var entry: Dictionary = main.school_day_state_service.get_entry(stage)
			_expect(not entry.is_empty(), "V02.15 should resolve stage entry: %s %s" % [day_key, stage])
			_expect(str(entry.get("day_key", "")) == day_key, "V02.15 stage entry should inherit day key: %s %s" % [day_key, stage])
			_expect(str(entry.get("stage", "")) == stage, "V02.15 stage entry should keep stage: %s %s" % [day_key, stage])
			_expect(main.find_child(event_id, true, false) != null, "V02.15 hotspot should exist for stage: %s" % event_id)
			_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.15 should move to school daily step: %s %s" % [day_key, stage])
			_press(interact_button, "V02.15 visible Interact should trigger school daily step: %s %s" % [day_key, stage])
			_expect(str(main.life_status_label.text).contains(str(entry.get("child_facing_text", ""))), "V02.15 HUD should show day-specific school text: %s %s" % [day_key, stage])

			var state: Dictionary = main.save_service.load_game_state()
			var school_record: Dictionary = state.get("school_day_events", {}).get(str(entry.get("event_id", "")), {})
			_expect(bool(school_record.get("seen", false)), "V02.15 should persist school day event: %s" % entry.get("event_id", ""))
			_expect(str(school_record.get("day_key", "")) == day_key, "V02.15 persisted school event should keep day: %s" % entry.get("event_id", ""))
			_expect(str(school_record.get("stage", "")) == stage, "V02.15 persisted school event should keep stage: %s" % entry.get("event_id", ""))
			_expect(not (school_record.get("anchor_ids", []) as Array).is_empty(), "V02.15 persisted school event should keep anchors: %s" % entry.get("event_id", ""))
			_expect(not (school_record.get("environment_words", []) as Array).is_empty(), "V02.15 persisted school event should keep environment words: %s" % entry.get("event_id", ""))
			seen_school_day_events[str(entry.get("event_id", ""))] = true
			if stage == "return_home":
				seen_return_events[str(entry.get("event_id", ""))] = true
				_expect(str(entry.get("display_prefix", "")).contains("Sunny"), "V02.15 return entry should stay tied to Sunny: %s" % day_key)
			for anchor_id_value in entry.get("anchor_ids", []):
				var card_id := _card_id_for_anchor(str(anchor_id_value))
				if not card_id.is_empty():
					var card_state: Dictionary = main.memory_card_service.get_card_state(card_id)
					_expect(bool(card_state.get("collected", false)), "V02.15 school entry should collect linked card: %s %s" % [day_key, card_id])
	_expect(seen_school_day_events.size() == 28, "V02.15 should persist 7 days x 4 school day events")
	_expect(seen_return_events.size() == 7, "V02.15 should persist seven Sunny return events")


func _card_id_for_anchor(anchor_id: String) -> String:
	var letter := anchor_id.trim_prefix("anchor_").split("_")[0]
	match letter:
		"a":
			return "card_a_apple_core"
		"c":
			return "card_c_clock_core"
		"d":
			return "card_d_dog_core"
		"e":
			return "card_e_elephant_core"
		"g":
			return "card_g_gate_core"
		"k":
			return "card_k_kite_core"
		"n":
			return "card_n_net_core"
		"o":
			return "card_o_orange_core"
		"r":
			return "card_r_robot_core"
		"s":
			return "card_s_sun_core"
		"u":
			return "card_u_umbrella_core"
		"w":
			return "card_w_watch_core"
		"y":
			return "card_y_yo_yo_core"
	return ""


func _check_existing_paths_after_school_daily(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.15 should keep shop hotspot walkable after 7 days")
	_press(interact_button, "V02.15 visible Interact should open shop after 7 days")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.15 should keep shop panel available after school daily path")
	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "V02.15 should keep Home hotspot walkable after 7 days")
	_press(interact_button, "V02.15 visible Interact should open Home after 7 days")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.15 should keep Home room available after school daily path")


func _check_child_safe_visible_text(main) -> void:
	for forbidden in ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "倒计时", "迟到", "作业", "老师评价", "家长报告", "独自远行", "上车", "必须", "打卡"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.15 visible UI should not contain forbidden text: %s" % forbidden)


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


func _finish() -> void:
	if failures.is_empty():
		print("V02.15 SCHOOL DAILY SLICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
