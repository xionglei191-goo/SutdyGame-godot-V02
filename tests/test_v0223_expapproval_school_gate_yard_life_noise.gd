extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const FORBIDDEN_TEXT: Array[String] = ["课程", "作业", "测试", "测验", "考试", "背诵", "打卡", "分数", "正确率", "等级", "迟到", "必须", "倒计时", "debug", "grid", "cell", "坐标", "格子"]

var failures: Array[String] = []
var main: Node


func _init() -> void:
	var save_path := "user://test_v0223_expapproval_school_gate_yard_life_noise.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.23 EXPAPPROVAL-005 save should clear before startup")
	main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	await process_frame
	await process_frame

	_check_school_life_density_snapshot()
	_check_school_gate_arrival_and_feedback()
	_check_school_yard_arrival_and_feedback()

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_school_life_density_snapshot() -> void:
	_expect(main.has_method("get_expapproval_school_snapshot"), "V02.23 School proof should expose approval snapshot")
	if not main.has_method("get_expapproval_school_snapshot"):
		return
	var snapshot: Dictionary = main.get_expapproval_school_snapshot()
	_expect(bool(snapshot.get("town_stage_visible", false)), "V02.23 School proof should inspect the visible town stage")
	_expect(int(snapshot.get("school_gate_life_detail_count", 0)) >= 2, "V02.23 School Gate should add quiet arrival life details")
	_expect(int(snapshot.get("school_yard_life_detail_count", 0)) >= 4, "V02.23 School Yard should add play-corner life details")
	for node_name in ["SchoolGateBellPot", "SchoolGateWelcomeMat", "SchoolYardSoftNetCorner", "SchoolYardKiteRibbon", "SchoolYardRobotSign", "SchoolYardYoYoBasket"]:
		_expect((snapshot.get("school_life_detail_names", []) as Array).has(node_name), "V02.23 School life detail should include %s" % node_name)
	_expect(int(snapshot.get("anchor_count", 0)) == 26, "V02.23 School proof should keep all A-Z anchors")
	_expect(int(snapshot.get("school_line_anchor_count", 0)) == 5, "V02.23 School proof should keep local G/K/N/R/Y anchors visible")
	_expect(int(snapshot.get("muted_school_line_badge_count", 0)) == int(snapshot.get("school_line_anchor_count", -1)), "V02.23 School-line badges should remain muted helper marks")
	_expect(not bool(snapshot.get("collision_debug_visible", true)), "V02.23 School proof should keep collision debug hidden")
	_expect(int(snapshot.get("school_child_text_banned_count", -1)) == 0, "V02.23 School visible text should avoid course/debug pressure wording")


func _check_school_gate_arrival_and_feedback() -> void:
	_expect(main.request_player_walk_to_cell(Vector2i(21, 12)).get("ok", false), "V02.23 School Gate proof should request walk to gate")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 School Gate proof should finish walk")
	_expect(main.player_cell == Vector2i(21, 12), "V02.23 School Gate proof should arrive at gate cell")
	var snapshot: Dictionary = main.get_expapproval_school_snapshot()
	_expect(bool(snapshot.get("arrival_school_gate_visible", false)), "V02.23 School Gate arrival proof should be visible")
	_expect(str(snapshot.get("visible_arrival_text", "")).contains("校门到了"), "V02.23 School Gate proof should use short child-facing arrival text")
	_expect(str(snapshot.get("visible_arrival_text", "")).length() <= 24, "V02.23 School Gate proof text should stay short for 1280 screenshot")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "place" and str(target.get("target_id", "")) == "homeschool_school_gate_hello_001", "V02.23 School Gate prompt should resolve the school place event")
	_press(main.find_child("InteractButton", true, false) as Button, "V02.23 School Gate proof should trigger from visible Interact")
	var result_text := str(main.life_status_label.text)
	_expect(result_text.contains("校门") or result_text.contains("School Gate"), "V02.23 School Gate feedback should name the place")
	_check_safe_text(result_text, "School Gate feedback")
	var state: Dictionary = main.save_service.load_game_state()
	_expect(state.get("homeschool_events", {}).has("homeschool_school_gate_hello_001"), "V02.23 School Gate proof should persist homeschool event")
	_expect(state.get("school_day_events", {}).has("schoolday_gate_bell_001_day_001"), "V02.23 School Gate proof should persist day-specific event")


func _check_school_yard_arrival_and_feedback() -> void:
	_expect(main.request_player_walk_to_cell(Vector2i(19, 15)).get("ok", false), "V02.23 School Yard proof should request walk to yard")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 School Yard proof should finish walk")
	_expect(main.player_cell == Vector2i(19, 15), "V02.23 School Yard proof should arrive at yard cell")
	var snapshot: Dictionary = main.get_expapproval_school_snapshot()
	_expect(bool(snapshot.get("arrival_school_yard_visible", false)), "V02.23 School Yard arrival proof should be visible")
	_expect(str(snapshot.get("visible_arrival_text", "")).contains("操场到了"), "V02.23 School Yard proof should use short child-facing arrival text")
	_expect(str(snapshot.get("visible_arrival_text", "")).length() <= 24, "V02.23 School Yard proof text should stay short for 1280 screenshot")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "place" and str(target.get("target_id", "")) == "homeschool_school_yard_play_001", "V02.23 School Yard prompt should resolve the yard place event")
	_press(main.find_child("InteractButton", true, false) as Button, "V02.23 School Yard proof should trigger from visible Interact")
	var result_text := str(main.life_status_label.text)
	_expect(result_text.contains("操场") or result_text.contains("School Yard"), "V02.23 School Yard feedback should name the place")
	_check_safe_text(result_text, "School Yard feedback")
	var state: Dictionary = main.save_service.load_game_state()
	_expect(state.get("homeschool_events", {}).has("homeschool_school_yard_play_001"), "V02.23 School Yard proof should persist homeschool event")
	_expect(state.get("school_day_events", {}).has("schoolday_yard_net_robot_001_day_001"), "V02.23 School Yard proof should persist day-specific event")


func _press(button: Button, message: String) -> void:
	_expect(button != null and _is_visible_in_tree(button) and not button.disabled, message)
	if button != null and _is_visible_in_tree(button) and not button.disabled:
		button.pressed.emit()


func _is_visible_in_tree(control: Control) -> bool:
	var current: Node = control
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _check_safe_text(text: String, context: String) -> void:
	for forbidden in FORBIDDEN_TEXT:
		_expect(not text.contains(forbidden), "V02.23 %s should avoid pressure/debug text: %s" % [context, forbidden])


func _finish() -> void:
	if failures.is_empty():
		print("V02.23 EXPAPPROVAL SCHOOL GATE / YARD LIFE NOISE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
