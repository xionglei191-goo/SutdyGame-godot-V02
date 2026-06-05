extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v029_weekly_return_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.9 weekly smoke save should clear before scene startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_run_weekly_return_path(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _run_weekly_return_path(main) -> void:
	var seen_events: Dictionary = {}
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")

		var status: Dictionary = main.today_status_service.get_today_status()
		_expect(status.get("ok", false), "Weekly smoke should resolve today status: %s" % day_key)
		_expect(str(status.get("day_key", "")) == day_key, "Weekly smoke should keep requested day key: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("event", ""))), "Weekly smoke HUD should refresh event text: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("sunny_hint", ""))), "Weekly smoke HUD should refresh Sunny hint: %s" % day_key)
		_expect(str(status.get("anchor_hint", "")).length() > 0, "Weekly smoke should keep A-Z anchor hint: %s" % day_key)
		seen_events[str(status.get("event", ""))] = true

		var rotation: Dictionary = main.life_shop_service.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "Weekly smoke should resolve shop rotation: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "Weekly smoke should keep wooden chair visible as P0: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "Weekly smoke should keep at least one P0 offer: %s" % day_key)

		_complete_visible_mina_path_for_day(main, day_key)

		if day_key == "local_day_004":
			_expect(str(status.get("primary_npc", "")) == "story_bear", "Story Bear day should stay represented in status data")
			_expect(str(status.get("anchor_hint", "")).contains("B Bear"), "Story Bear day should keep B Bear as a soft hint")
		elif day_key == "local_day_005":
			_expect(str(status.get("primary_npc", "")) == "bus_helper", "Bus Helper day should stay represented in status data")
			_expect(str(status.get("anchor_hint", "")).contains("T Taxi"), "Bus Helper day should keep T Taxi as a soft hint")

	_check_visible_shop_and_home_after_week(main)
	_expect(seen_events.size() == 7, "Weekly smoke should expose 7 distinct gentle day events")


func _complete_visible_mina_path_for_day(main, day_key: String) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button

	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "Weekly smoke should move near Mina: %s" % day_key)
	_press(interact_button, "Weekly smoke visible Interact should greet or advance Mina: %s" % day_key)
	_press(interact_button, "Weekly smoke visible Interact should start Mina request: %s" % day_key)
	_expect(str(main.life_status_label.text).contains("树枝"), "Weekly smoke should show Mina branch request: %s" % day_key)

	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "Weekly smoke should move to branch resource: %s" % day_key)
	_press(interact_button, "Weekly smoke visible Interact should collect branch: %s" % day_key)
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "Weekly smoke should return to Mina: %s" % day_key)
	_press(interact_button, "Weekly smoke visible Interact should complete Mina request: %s" % day_key)

	var state: Dictionary = main.save_service.load_game_state()
	var daily_state: Dictionary = state.get("daily_requests", {}).get(day_key, {}).get("daily_mina_branch_001", {})
	_expect(bool(daily_state.get("completed_today", false)), "Weekly smoke should persist Mina completion by day: %s" % day_key)


func _check_visible_shop_and_home_after_week(main) -> void:
	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(12, int(state.get("coins", 0)))
	_expect(main.save_service.save_game_state(state), "Weekly smoke should prepare gentle coins for final shop/home check")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "Weekly smoke should move to shop hotspot after 7 days")
	_press(interact_button, "Weekly smoke visible Interact should open shop shelf after 7 days")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "Weekly smoke should open visible shop panel after 7 days")
	_press(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "Weekly smoke visible shop button should buy P0 chair after 7 days")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "Weekly smoke should add P0 chair to backpack")

	_press(main.find_child("HomeNavButton", true, false) as Button, "Weekly smoke visible Home button should open home room")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "Weekly smoke should show HomeRoom after 7 days")
	_press(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "Weekly smoke visible home button should place chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "Weekly smoke should persist home placement after weekly path")


func _rotation_has_item(rotation: Dictionary, item_id: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("item_id", "")) == item_id:
			return true
	return false


func _rotation_has_tier(rotation: Dictionary, tier: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("rotation_tier", "")) == tier:
			return true
	return false


func _check_child_safe_visible_text(main) -> void:
	for forbidden in ["Godot skeleton", "Loaded places", "课程", "测验", "考试", "评分", "背诵", "倒计时", "失败惩罚", "陌生人带走", "独自远行", "赶时间"]:
		_expect(_visible_texts_containing(main, forbidden).is_empty(), "Weekly smoke visible UI should not contain forbidden text: %s" % forbidden)


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


func _visible_texts_containing(node: Node, forbidden: String) -> Array[String]:
	var matches: Array[String] = []
	if node is Control and not (node as Control).visible:
		return matches
	var text := ""
	if node is Label:
		text = (node as Label).text
	elif node is Button:
		text = (node as Button).text
	if not text.is_empty() and text.contains(forbidden):
		matches.append(text)
	for child in node.get_children():
		matches.append_array(_visible_texts_containing(child, forbidden))
	return matches


func _finish() -> void:
	if failures.is_empty():
		print("V02.9 WEEKLY RETURN SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

