extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const FORBIDDEN_TEXT: Array[String] = ["课程", "作业", "测试", "测验", "考试", "背诵", "打卡", "分数", "正确率", "等级", "迟到", "必须", "倒计时"]

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0221_livegate_shop_school_arrival.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.21 arrival save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_shop_arrival(main)
	_check_school_arrival(main, Vector2i(21, 12), "place_school_gate", "school_gate", "ArrivalProofSchoolGate")
	_check_school_arrival(main, Vector2i(19, 15), "place_school_yard", "school_yard", "ArrivalProofSchoolYard")

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_shop_arrival(main) -> void:
	_expect(main.request_player_walk_to_cell(Vector2i(41, 11)).get("ok", false), "V02.21 should walk to Shop entry")
	var before_camera: Vector2 = main.runtime_map_node.position
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.21 should finish Shop arrival walk")
	_expect(main.player_cell == Vector2i(41, 11), "V02.21 Shop arrival should save player at Shop entry")
	_expect(main.runtime_map_node.position != before_camera, "V02.21 Shop arrival should use local camera follow")
	_expect(_arrival_visible(main, "ArrivalProofShop"), "V02.21 Shop arrival proof should be visible after walking")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "place", "V02.21 Shop prompt should resolve exact place entry")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_press(interact_button, "V02.21 visible Interact should open Shop")
	_expect(main.find_child("ShopPanel", true, false) != null and (main.find_child("ShopPanel", true, false) as Control).visible, "V02.21 Shop arrival should open visible Shop panel")
	_expect(main.find_child("CloseShopButton", true, false) != null, "V02.21 Shop panel should keep visible close button")
	_expect(main.find_child("ShopBuyWoodenChairButton", true, false) != null, "V02.21 Shop panel should expose visible goods")
	_expect(_arrival_visible(main, "ArrivalProofShop"), "V02.21 Shop proof should remain visible beside Shop panel")
	_check_safe_text(str(main.life_status_label.text), "Shop arrival status")


func _check_school_arrival(main, cell: Vector2i, place_id: String, stage: String, proof_node: String) -> void:
	main.close_shop_panel()
	_expect(main.request_player_walk_to_cell(cell).get("ok", false), "V02.21 should walk to %s" % place_id)
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.21 should finish %s arrival walk" % place_id)
	_expect(main.player_cell == cell, "V02.21 %s arrival should save player cell" % place_id)
	_expect(_arrival_visible(main, proof_node), "V02.21 %s arrival proof should be visible after walking" % place_id)
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "place", "V02.21 %s prompt should resolve school place event" % place_id)
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_press(interact_button, "V02.21 visible Interact should trigger %s event" % place_id)
	var record: Dictionary = main.save_service.load_game_state().get("homeschool_events", {}).values().back()
	_expect(str(record.get("stage", "")) == stage, "V02.21 %s event should persist stage" % place_id)
	_expect(str(record.get("place_id", "")) == place_id, "V02.21 %s event should persist place_id" % place_id)
	_expect(_arrival_visible(main, proof_node), "V02.21 %s proof should remain visible after event" % place_id)
	_check_safe_text(str(main.life_status_label.text), "%s status" % place_id)


func _arrival_visible(main, node_name: String) -> bool:
	var panel := main.find_child("ArrivalProofPanel", true, false) as Control
	var label := main.find_child(node_name, true, false) as Label
	return panel != null and panel.visible and label != null and label.visible and not str(label.text).is_empty()


func _press(button: Button, message: String) -> void:
	_expect(button != null and button.visible and not button.disabled, message)
	if button != null and button.visible and not button.disabled:
		button.emit_signal("pressed")


func _check_safe_text(text: String, context: String) -> void:
	for forbidden in FORBIDDEN_TEXT:
		_expect(not text.contains(forbidden), "V02.21 %s should avoid pressure text: %s" % [context, forbidden])


func _finish() -> void:
	if failures.is_empty():
		print("V02.21 LIVEGATE SHOP SCHOOL ARRIVAL TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
