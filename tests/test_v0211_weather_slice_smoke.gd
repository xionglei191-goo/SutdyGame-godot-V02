extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const WEATHER_PATHS: Array[Dictionary] = [
	{"day_key": "local_day_001", "event_id": "event_weather_sunny_soft_001", "anchor_id": "anchor_s_sun", "card_id": "card_s_sun_core", "cell": Vector2i(17, 2), "weather_text": "阳光", "album_tag": "Sunny day."},
	{"day_key": "local_day_002", "event_id": "event_weather_breezy_kite_001", "anchor_id": "anchor_k_kite", "card_id": "card_k_kite_core", "cell": Vector2i(7, 11), "weather_text": "小风", "album_tag": "Windy Kite."},
	{"day_key": "local_day_004", "event_id": "event_weather_light_rain_001", "anchor_id": "anchor_b_bear", "card_id": "card_b_bear_core", "cell": Vector2i(13, 7), "weather_text": "小雨", "album_tag": "Light Rain."},
	{"day_key": "local_day_006", "event_id": "event_weather_after_rain_001", "anchor_id": "anchor_u_umbrella", "card_id": "card_u_umbrella_core", "cell": Vector2i(33, 13), "weather_text": "雨后", "album_tag": "After Rain."},
]

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0211_weather_slice_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.11 weather slice save should clear before startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_run_weather_slice(main)
	_check_shop_and_home_path(main)
	_check_child_safe_visible_text(main)

	_expect(main.save_service.clear_for_test(), "V02.11 weather slice save should clean up")
	root.remove_child(main)
	main.queue_free()
	_finish()


func _run_weather_slice(main) -> void:
	var seen_weather_events: Dictionary = {}
	for path in WEATHER_PATHS:
		var day_key := str(path.get("day_key", ""))
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")

		var status: Dictionary = main.today_status_service.get_today_status()
		var weather_event_id := str(status.get("weather_event_id", ""))
		_expect(status.get("ok", false), "V02.11 weather slice should resolve today status: %s" % day_key)
		_expect(weather_event_id == str(path.get("event_id", "")), "V02.11 weather slice should use expected weather event: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("today_status_text", ""))), "V02.11 weather HUD should show weather text: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("event", ""))), "V02.11 weather HUD should keep daily event text: %s" % day_key)
		_expect(str(status.get("today_status_text", "")).contains(str(path.get("weather_text", ""))), "V02.11 weather text should match path label: %s" % day_key)
		seen_weather_events[weather_event_id] = true

		_check_shop_rotation(main, status, day_key)
		_complete_visible_mina_path(main, day_key)
		_check_weather_album_path(main, path)

	_expect(seen_weather_events.size() == 4, "V02.11 weather slice should cover four P0 weather events")
	_expect(main.open_memory_album().get("ok", false), "V02.11 weather slice should open album after all weather clues")
	for path in WEATHER_PATHS:
		_expect(_visible_text_for_card(main, str(path.get("card_id", ""))).contains("已收藏"), "V02.11 weather album should show collected card: %s" % path.get("card_id", ""))
	main.close_memory_album()


func _check_shop_rotation(main, status: Dictionary, day_key: String) -> void:
	var rotation: Dictionary = main.life_shop_service.get_shop_rotation(str(status.get("shop_rotation_id", "")))
	_expect(rotation.get("ok", false), "V02.11 weather slice should resolve shop rotation: %s" % day_key)
	_expect(str(rotation.get("weather_activity_corner", {}).get("weather_event_id", "")) == str(status.get("weather_event_id", "")), "V02.11 shop weather corner should match weather event: %s" % day_key)
	_expect(_rotation_has_item(rotation, "wooden_chair"), "V02.11 weather should not hide P0 chair: %s" % day_key)
	_expect(_rotation_has_tier(rotation, "P0"), "V02.11 weather should keep P0 shop offers: %s" % day_key)


func _complete_visible_mina_path(main, day_key: String) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.11 weather slice should move near Mina: %s" % day_key)
	_press(interact_button, "V02.11 weather slice should greet or advance Mina: %s" % day_key)
	_press(interact_button, "V02.11 weather slice should start Mina request: %s" % day_key)
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.11 weather slice should show Mina branch request: %s" % day_key)
	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.11 weather slice should move to branch resource: %s" % day_key)
	_press(interact_button, "V02.11 weather slice should collect branch resource: %s" % day_key)
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.11 weather slice should return to Mina: %s" % day_key)
	_press(interact_button, "V02.11 weather slice should complete Mina request: %s" % day_key)
	var daily_state: Dictionary = main.save_service.load_game_state().get("daily_requests", {}).get(day_key, {}).get("daily_mina_branch_001", {})
	_expect(bool(daily_state.get("completed_today", false)), "V02.11 weather slice should persist Mina completion: %s" % day_key)


func _check_weather_album_path(main, path: Dictionary) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var day_key := str(path.get("day_key", ""))
	var event_id := str(path.get("event_id", ""))
	var anchor_id := str(path.get("anchor_id", ""))
	var card_id := str(path.get("card_id", ""))
	_expect(main.move_player_to_cell(path.get("cell", Vector2i.ZERO)).get("ok", false), "V02.11 weather slice should move to weather clue: %s" % anchor_id)
	_press(interact_button, "V02.11 weather slice should trigger weather clue through visible Interact: %s" % anchor_id)
	_expect(str(main.life_status_label.text).contains("天气相册"), "V02.11 weather clue HUD should mention album: %s" % anchor_id)
	var record_id := "%s:%s" % [event_id, anchor_id]
	var record: Dictionary = main.save_service.load_game_state().get("weather_album_clues", {}).get(record_id, {})
	_expect(bool(record.get("seen", false)), "V02.11 weather clue should persist record: %s" % record_id)
	_expect(str(record.get("day_key", "")) == day_key, "V02.11 weather clue should persist day key: %s" % record_id)
	_expect(str(record.get("album_tag", "")) == str(path.get("album_tag", "")), "V02.11 weather clue should persist album tag: %s" % record_id)
	var card_state: Dictionary = main.memory_card_service.get_card_state(card_id)
	_expect(bool(card_state.get("seen", false)) and bool(card_state.get("collected", false)), "V02.11 weather clue should collect card: %s" % card_id)


func _check_shop_and_home_path(main) -> void:
	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(12, int(state.get("coins", 0)))
	_expect(main.save_service.save_game_state(state), "V02.11 weather slice should prepare coins for shop/home check")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.11 weather slice should move to shop shelf")
	_press(interact_button, "V02.11 weather slice should open shop through visible Interact")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.11 weather slice should show shop panel")
	_press(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.11 weather slice should buy P0 chair")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.11 weather slice should add chair to backpack")
	_press(main.find_child("HomeNavButton", true, false) as Button, "V02.11 weather slice should open home view")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.11 weather slice should show HomeRoom")
	_press(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.11 weather slice should place chair at home")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.11 weather slice should persist home placement")


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


func _visible_text_for_card(main, card_id: String) -> String:
	var card_node: Node = main.find_child(card_id, true, false)
	if card_node == null:
		return ""
	return _collect_visible_text(card_node)


func _collect_visible_text(node: Node) -> String:
	var parts: Array[String] = []
	if node is Control and not (node as Control).visible:
		return ""
	if node is Label:
		parts.append((node as Label).text)
	elif node is Button:
		parts.append((node as Button).text)
	for child in node.get_children():
		parts.append(_collect_visible_text(child))
	return " ".join(parts)


func _check_child_safe_visible_text(main) -> void:
	var visible_text := _collect_visible_text(main)
	for forbidden in ["Godot skeleton", "Loaded places", "课程", "测验", "考试", "评分", "背诵", "倒计时", "失败惩罚", "陌生人带走", "独自远行", "赶时间", "打卡", "补签", "连续登录", "错过"]:
		_expect(not visible_text.contains(forbidden), "V02.11 weather slice visible UI should not contain forbidden text: %s" % forbidden)


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


func _finish() -> void:
	if failures.is_empty():
		print("V02.11 WEATHER SLICE SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
