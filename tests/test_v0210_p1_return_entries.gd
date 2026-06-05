extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0210_p1_return_entries.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "P1 return entry save should clear before scene startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	_check_visible_p1_entries(main)
	_check_p0_paths_still_open(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_visible_p1_entries(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	for entry in [
		{"id": "p1_entry_story_bear_bookshop_door", "cell": Vector2i(12, 6), "kind": "bookshop_door", "text": "书店门口", "npc": "story_bear", "anchor": "anchor_b_bear", "card": "card_b_bear_core"},
		{"id": "p1_entry_story_bear_corner", "cell": Vector2i(13, 7), "kind": "bear_corner", "text": "熊形书牌", "npc": "story_bear", "anchor": "anchor_b_bear", "card": "card_b_bear_core"},
		{"id": "p1_entry_bus_helper_stop_sign", "cell": Vector2i(32, 11), "kind": "bus_stop_sign", "text": "站牌", "npc": "bus_helper", "anchor": "anchor_t_taxi", "card": "card_t_taxi_core"},
		{"id": "p1_entry_bus_helper_taxi_marker", "cell": Vector2i(31, 10), "kind": "taxi_marker", "text": "黄色小标记", "npc": "bus_helper", "anchor": "anchor_t_taxi", "card": "card_t_taxi_core"},
	]:
		_expect(main.find_child(str(entry.get("id", "")), true, false) != null, "P1 entry hotspot should be visible: %s" % entry.get("id", ""))
		_expect(main.move_player_to_cell(entry.get("cell", Vector2i.ZERO)).get("ok", false), "Player should move to P1 entry hotspot: %s" % entry.get("id", ""))
		_press(interact_button, "Visible Interact should trigger P1 entry: %s" % entry.get("id", ""))
		_expect(str(main.life_status_label.text).contains(str(entry.get("text", ""))), "P1 entry should show gentle feedback: %s" % entry.get("id", ""))
		var saved: Dictionary = main.save_service.load_game_state().get("p1_return_entries", {}).get(str(entry.get("id", "")), {})
		_expect(bool(saved.get("seen", false)), "P1 entry should persist seen state: %s" % entry.get("id", ""))
		_expect(str(saved.get("entry_kind", "")) == str(entry.get("kind", "")), "P1 entry should persist entry kind: %s" % entry.get("id", ""))
		_expect(str(saved.get("npc_id", "")) == str(entry.get("npc", "")), "P1 entry should bind resident: %s" % entry.get("id", ""))
		_expect(str(saved.get("linked_anchor_id", "")) == str(entry.get("anchor", "")), "P1 entry should preserve A-Z anchor link: %s" % entry.get("id", ""))
		var card_state: Dictionary = main.memory_card_service.get_card_state(str(entry.get("card", "")))
		_expect(bool(card_state.get("seen", false)), "P1 entry should mark linked A-Z card seen: %s" % entry.get("card", ""))
		_expect(bool(card_state.get("heard", false)), "P1 entry should mark linked A-Z card heard: %s" % entry.get("card", ""))
		_expect(bool(card_state.get("collected", false)), "P1 entry should mark linked A-Z card collected: %s" % entry.get("card", ""))

	_expect(main.open_memory_album().get("ok", false), "P1 entry album records should open from child-facing album")
	_expect(_card_visible_text(main, "card_b_bear_core").contains("已收藏"), "B Bear album tile should show collected after P1 entry")
	_expect(_card_visible_text(main, "card_t_taxi_core").contains("已收藏"), "T Taxi album tile should show collected after P1 entry")
	_expect(not _collect_visible_text(main).contains("正确率"), "P1 album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "P1 album should not show level wording")
	main.close_memory_album()


func _check_p0_paths_still_open(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(int(main.save_service.load_game_state().get("coins", 0)) == 0, "P1 entries should not award coins")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "Player should still move to P0 shop hotspot")
	_press(interact_button, "Visible Interact should still open P0 shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "P0 shop panel should still open after P1 entry checks")
	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "Player should still move to Home hotspot")
	_press(interact_button, "Visible Interact should still open Home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "P0 Home view should still open after P1 entry checks")


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
		print("V02.10 P1 RETURN ENTRY TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
