extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const HOMESCHOOL_EVENTS_PATH := "res://data/life/homeschool_events.json"
const WORLD_MAP_PATH := "res://data/maps/world_map.json"
const NEW_EVENTS: Array[Dictionary] = [
	{
		"event_id": "homeschool_shop_front_window_001",
		"cell": Vector2i(42, 9),
		"place_id": "place_supermarket",
		"stage": "shop_front",
		"text": "Hat",
		"cards": ["card_h_hat_core", "card_i_ice_cream_core", "card_o_orange_core"],
	},
	{
		"event_id": "homeschool_school_yard_chalk_flower_001",
		"cell": Vector2i(18, 14),
		"place_id": "place_school_yard",
		"stage": "school_yard_extra",
		"text": "Yo-yo",
		"cards": ["card_n_net_core", "card_y_yo_yo_core", "card_r_robot_core"],
	},
]
const FORBIDDEN_TERMS: Array[String] = ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "等级", "倒计时", "迟到", "作业", "老师评价", "家长报告", "必须", "售罄", "排名"]

var failures: Array[String] = []


func _init() -> void:
	_check_data_contract()
	_check_visible_runtime_path()
	_finish()


func _check_data_contract() -> void:
	var events_data: Dictionary = _load_json(HOMESCHOOL_EVENTS_PATH)
	var map_data: Dictionary = _load_json(WORLD_MAP_PATH)
	var events_by_id: Dictionary = {}
	for event_value in events_data.get("events", []):
		if event_value is Dictionary:
			var event: Dictionary = event_value
			events_by_id[str(event.get("event_id", ""))] = event
	var road_cells := _road_cells(map_data)
	var protected_cells := _protected_cells(map_data)
	var interactions_by_id: Dictionary = {}
	for interaction_value in map_data.get("interaction_cells", []):
		if interaction_value is Dictionary:
			var interaction: Dictionary = interaction_value
			interactions_by_id[str(interaction.get("interaction_id", ""))] = interaction
	for spec in NEW_EVENTS:
		var event_id := str(spec.get("event_id", ""))
		_expect(events_by_id.has(event_id), "V02.26 CONTENTBATCH-004 event should exist: %s" % event_id)
		var event: Dictionary = events_by_id.get(event_id, {})
		_expect(str(event.get("tier", "")) == "P0", "V02.26 CONTENTBATCH-004 event should stay P0-soft: %s" % event_id)
		_expect(str(event.get("stage", "")) == str(spec.get("stage", "")), "V02.26 CONTENTBATCH-004 event stage should match: %s" % event_id)
		_expect(str(event.get("place_id", "")) == str(spec.get("place_id", "")), "V02.26 CONTENTBATCH-004 event place should match: %s" % event_id)
		_expect(not (event.get("anchor_ids", []) as Array).is_empty(), "V02.26 CONTENTBATCH-004 event should bind anchors: %s" % event_id)
		_expect(_child_safe(event), "V02.26 CONTENTBATCH-004 event text should stay child-safe: %s" % event_id)
		_expect(interactions_by_id.has(event_id), "V02.26 CONTENTBATCH-004 map interaction should exist: %s" % event_id)
		var interaction: Dictionary = interactions_by_id.get(event_id, {})
		var cell := spec.get("cell", Vector2i.ZERO) as Vector2i
		_expect(str(interaction.get("action", "")) == "look_homeschool_event", "V02.26 CONTENTBATCH-004 interaction should use homeschool event action: %s" % event_id)
		_expect(str(interaction.get("event_id", "")) == event_id, "V02.26 CONTENTBATCH-004 interaction should link event: %s" % event_id)
		_expect(_cell_matches(interaction.get("cell", {}), cell), "V02.26 CONTENTBATCH-004 interaction cell should match: %s" % event_id)
		_expect(road_cells.has(_cell_key(cell)), "V02.26 CONTENTBATCH-004 event should sit on reachable path: %s" % event_id)
		_expect(not protected_cells.has(_cell_key(cell)), "V02.26 CONTENTBATCH-004 event should avoid protected exact cells: %s" % event_id)


func _check_visible_runtime_path() -> void:
	var save_path := "user://test_v026_contentbatch004_look_events.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-004 save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	for spec in NEW_EVENTS:
		var event_id := str(spec.get("event_id", ""))
		_expect(main.find_child(event_id, true, false) != null, "V02.26 CONTENTBATCH-004 hotspot should exist in runtime map: %s" % event_id)
		_expect(main.move_player_to_cell(spec.get("cell", Vector2i.ZERO)).get("ok", false), "V02.26 CONTENTBATCH-004 player should reach event: %s" % event_id)
		_press(interact_button, "V02.26 CONTENTBATCH-004 visible Interact should trigger event: %s" % event_id)
		_expect(str(main.life_status_label.text).contains(str(spec.get("text", ""))), "V02.26 CONTENTBATCH-004 HUD should show event feedback: %s" % event_id)
		var record: Dictionary = main.save_service.load_game_state().get("homeschool_events", {}).get(event_id, {})
		_expect(bool(record.get("seen", false)), "V02.26 CONTENTBATCH-004 event should persist seen state: %s" % event_id)
		_expect(str(record.get("stage", "")) == str(spec.get("stage", "")), "V02.26 CONTENTBATCH-004 event should persist stage: %s" % event_id)
		for card_id in spec.get("cards", []):
			var card_state: Dictionary = main.memory_card_service.get_card_state(str(card_id))
			_expect(bool(card_state.get("seen", false)) and bool(card_state.get("collected", false)), "V02.26 CONTENTBATCH-004 event should collect linked card: %s" % card_id)
	_expect(main.move_player_to_cell(Vector2i(41, 11)).get("ok", false), "V02.26 CONTENTBATCH-004 should keep shop entry reachable")
	_press(interact_button, "V02.26 CONTENTBATCH-004 visible Interact should still open shop entry")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.26 CONTENTBATCH-004 should keep shop panel available")
	_expect(not _has_forbidden_visible_text(main), "V02.26 CONTENTBATCH-004 visible UI should remain child-safe")
	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _road_cells(map_data: Dictionary) -> Dictionary:
	var cells: Dictionary = {}
	for road_value in map_data.get("roads", []):
		if road_value is Dictionary:
			for cell_value in (road_value as Dictionary).get("cells", []):
				if cell_value is Dictionary:
					cells[_cell_key_from_dict(cell_value)] = true
	return cells


func _protected_cells(map_data: Dictionary) -> Dictionary:
	var cells: Dictionary = {}
	for collision_value in map_data.get("collision_cells", []):
		if collision_value is Dictionary:
			cells[_cell_key_from_dict(collision_value)] = true
	for anchor_value in map_data.get("memory_anchors", []):
		if anchor_value is Dictionary:
			cells[_cell_key_from_dict((anchor_value as Dictionary).get("position", {}))] = true
	for interaction_value in map_data.get("interaction_cells", []):
		if interaction_value is Dictionary:
			var interaction: Dictionary = interaction_value
			if not ["homeschool_shop_front_window_001", "homeschool_school_yard_chalk_flower_001"].has(str(interaction.get("interaction_id", ""))):
				cells[_cell_key_from_dict(interaction.get("cell", {}))] = true
	return cells


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "V02.26 CONTENTBATCH-004 should read JSON: %s" % path)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	_expect(parsed is Dictionary, "V02.26 CONTENTBATCH-004 JSON should parse as object: %s" % path)
	return parsed if parsed is Dictionary else {}


func _child_safe(data: Dictionary) -> bool:
	var text := JSON.stringify(data)
	for forbidden in FORBIDDEN_TERMS:
		if text.contains(forbidden):
			return false
	return true


func _cell_matches(value: Variant, expected: Vector2i) -> bool:
	return value is Dictionary and int((value as Dictionary).get("x", -1)) == expected.x and int((value as Dictionary).get("y", -1)) == expected.y


func _cell_key(cell: Vector2i) -> String:
	return "%d,%d" % [cell.x, cell.y]


func _cell_key_from_dict(value: Variant) -> String:
	if not value is Dictionary:
		return ""
	var data: Dictionary = value
	return "%d,%d" % [int(data.get("x", -999)), int(data.get("y", -999))]


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


func _has_forbidden_visible_text(node: Node) -> bool:
	return _visible_text_has_forbidden(node)


func _visible_text_has_forbidden(node: Node) -> bool:
	if node is Control and not (node as Control).visible:
		return false
	var text := ""
	if node is Label:
		text = (node as Label).text
	elif node is Button:
		text = (node as Button).text
	for forbidden in FORBIDDEN_TERMS:
		if text.contains(forbidden):
			return true
	for child in node.get_children():
		if _visible_text_has_forbidden(child):
			return true
	return false


func _finish() -> void:
	if failures.is_empty():
		print("V02.26 CONTENTBATCH-004 LOOK EVENT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
