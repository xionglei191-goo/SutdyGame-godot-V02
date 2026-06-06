extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MainScene := preload("res://scenes/main.tscn")

const HOME_LINE: Array[String] = ["A", "C", "D", "T", "W"]
const SCHOOL_LINE: Array[String] = ["G", "K", "N", "R", "Y"]
const STORY_BRIDGE: Array[String] = ["B", "Q", "V"]
const SHOP_STREET: Array[String] = ["H", "I", "J", "O"]
const ANIMAL_PARK: Array[String] = ["E", "F", "L", "M", "P", "Z"]
const SUN_SCENE: Array[String] = ["S"]
const COAST_EDGE: Array[String] = ["U", "X"]
const FORBIDDEN_TEXT: Array[String] = ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "等级", "打卡", "倒计时", "迟到", "必须", "错过", "独自远行", "赶车"]

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "V02.17 world map should load: %s" % [map_result.get("errors", [])])
	var world_map: Dictionary = map_result.get("data", {})
	_check_runtime_anchor_blueprint(world_map)
	_check_main_scene_anchor_nodes_and_album(world_map)
	_finish()


func _check_runtime_anchor_blueprint(world_map: Dictionary) -> void:
	var anchors: Array = world_map.get("memory_anchors", [])
	_expect(anchors.size() == 26, "V02.17 runtime map should include 26 memory anchors")
	var seen_letters: Array[String] = []
	var seen_ids: Dictionary = {}
	var occupied: Dictionary = {}
	for place in world_map.get("places", []):
		if place is Dictionary:
			for occupied_cell in (place as Dictionary).get("occupied_cells", []):
				occupied[_cell_key(_dict_to_cell(occupied_cell))] = true
	for anchor_value in anchors:
		_expect(anchor_value is Dictionary, "V02.17 anchor record should be dictionary")
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var anchor_id := str(anchor.get("anchor_id", ""))
		var letter := str(anchor.get("letter", ""))
		var route_order := int(anchor.get("route_order", 0))
		var position := _dict_to_cell(anchor.get("position", {}))
		_expect(not seen_ids.has(anchor_id), "V02.17 anchor id should be unique: %s" % anchor_id)
		seen_ids[anchor_id] = true
		seen_letters.append(letter)
		_expect(route_order == _expected_route_order(letter), "V02.17 route_order should match A-Z: %s" % anchor_id)
		_expect(not str(anchor.get("card_id", "")).is_empty(), "V02.17 anchor should keep card_id: %s" % anchor_id)
		_expect(_cell_in_canvas(position, world_map), "V02.17 anchor position should be inside canvas: %s" % anchor_id)
		_expect(not occupied.has(_cell_key(position)), "V02.17 anchor should not sit on occupied place cell: %s" % anchor_id)
		_check_anchor_layer(letter, position, anchor_id)
	_expect(seen_letters == _az_letters(), "V02.17 runtime anchors should preserve A-Z order")


func _check_anchor_layer(letter: String, position: Vector2i, anchor_id: String) -> void:
	if HOME_LINE.has(letter):
		_expect(position.x >= 27 and position.x <= 34 and position.y >= 15 and position.y <= 20, "Home anchor should stay around Home Core: %s at %s" % [anchor_id, position])
	elif SCHOOL_LINE.has(letter):
		_expect(position.x >= 14 and position.x <= 21 and position.y >= 8 and position.y <= 15, "School anchor should stay near Morning School: %s at %s" % [anchor_id, position])
	elif STORY_BRIDGE.has(letter):
		_expect(position.x >= 14 and position.x <= 19 and position.y >= 18 and position.y <= 25, "Story bridge anchor should connect School and Home: %s at %s" % [anchor_id, position])
	elif SHOP_STREET.has(letter):
		_expect(position.x >= 43 and position.x <= 53 and position.y >= 8 and position.y <= 13, "Shop anchor should stay in Shop Street: %s at %s" % [anchor_id, position])
	elif ANIMAL_PARK.has(letter):
		_expect(position.x >= 41 and position.x <= 52 and position.y >= 20 and position.y <= 28, "Animal anchor should stay in Animal Park: %s at %s" % [anchor_id, position])
	elif SUN_SCENE.has(letter):
		_expect(position.x >= 5 and position.x <= 9 and position.y >= 2 and position.y <= 4, "Sun anchor should stay in the standalone Sun Scene: %s at %s" % [anchor_id, position])
	elif COAST_EDGE.has(letter):
		_expect(position.x >= 54 and position.y >= 30, "Coast anchor should remain at Beach / Coast Edge: %s at %s" % [anchor_id, position])


func _check_main_scene_anchor_nodes_and_album(world_map: Dictionary) -> void:
	var save_path := "user://test_v0217_worldmap_anchor_runtime.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.17 runtime save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	root.add_child(main)
	main.call("_ready")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(interact_button != null and interact_button.visible, "V02.17 runtime should expose visible Interact button")
	for anchor_value in world_map.get("memory_anchors", []):
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var anchor_id := str(anchor.get("anchor_id", ""))
		var letter := str(anchor.get("letter", ""))
		var card_id := str(anchor.get("card_id", ""))
		var core_word := str(anchor.get("core_word", ""))
		var node := main.find_child(anchor_id, true, false)
		_expect(node != null and node is Node2D, "V02.17 anchor should exist as runtime Node2D: %s" % anchor_id)
		_expect(node != null and node.find_child("ObjectSprite", true, false) is Sprite2D, "V02.17 anchor should use object sprite: %s" % anchor_id)
		var badge := node.find_child("LetterBadge", true, false) as Label if node != null else null
		_expect(badge != null and badge.text == letter, "V02.17 anchor should show its map letter badge: %s" % anchor_id)
		var anchor_cell := _dict_to_cell(anchor.get("position", {}))
		var look_cell := _best_look_cell(main, anchor_cell)
		_expect(main.move_player_to_cell(look_cell).get("ok", false), "V02.17 player should move near anchor: %s at %s" % [anchor_id, look_cell])
		var result: Dictionary = main.interact_nearby()
		_expect(result.get("ok", false), "V02.17 visible Interact should trigger anchor: %s got %s" % [anchor_id, result])
		_expect(str(result.get("interaction_type", "")) == "anchor", "V02.17 Interact should keep anchor context: %s got %s" % [anchor_id, result.get("interaction_type", "")])
		_expect(str(result.get("anchor_id", "")) == anchor_id, "V02.17 Interact should preserve anchor id: %s" % anchor_id)
		_expect(str(result.get("card_id", "")) == card_id, "V02.17 Interact should preserve card id: %s" % anchor_id)
		_expect(str(result.get("text", "")).contains(core_word), "V02.17 feedback should mention core object: %s" % anchor_id)
		var state: Dictionary = main.memory_card_service.get_card_state(card_id)
		_expect(bool(state.get("seen", false)) and bool(state.get("collected", false)), "V02.17 anchor should update album state: %s" % anchor_id)
		for forbidden in FORBIDDEN_TEXT:
			_expect(not str(result.get("text", "")).contains(forbidden), "V02.17 anchor text should avoid pressure wording %s: %s" % [forbidden, anchor_id])
	_expect(main.open_memory_album().get("ok", false), "V02.17 album should open after anchor pass")
	var visible_text := _collect_visible_text(main)
	for forbidden in FORBIDDEN_TEXT:
		_expect(not visible_text.contains(forbidden), "V02.17 album visible text should avoid pressure wording: %s" % forbidden)
	main.close_memory_album()
	_expect(main.save_service.clear_for_test(), "V02.17 runtime save should clean up")
	root.remove_child(main)
	main.queue_free()


func _best_look_cell(main, anchor_cell: Vector2i) -> Vector2i:
	var candidates: Array[Vector2i] = [
		anchor_cell,
		anchor_cell + Vector2i(1, 0),
		anchor_cell + Vector2i(-1, 0),
		anchor_cell + Vector2i(0, 1),
		anchor_cell + Vector2i(0, -1),
	]
	for candidate in candidates:
		if main.move_player_to_cell(candidate).get("ok", false):
			var nearest_anchor: Dictionary = main.call("_find_nearest_anchor", 1)
			if str(nearest_anchor.get("anchor_id", "")) != "":
				return candidate
	return anchor_cell


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


func _expected_route_order(letter: String) -> int:
	if letter.length() != 1:
		return -1
	return letter.unicode_at(0) - 64


func _az_letters() -> Array[String]:
	var letters: Array[String] = []
	for code in range(65, 91):
		letters.append(char(code))
	return letters


func _cell_in_canvas(cell: Vector2i, world_map: Dictionary) -> bool:
	var canvas: Dictionary = world_map.get("canvas_size", {})
	return cell.x >= 0 and cell.y >= 0 and cell.x < int(canvas.get("w", 0)) and cell.y < int(canvas.get("h", 0))


func _dict_to_cell(cell: Variant) -> Vector2i:
	if cell is Vector2i:
		return cell
	if cell is Dictionary:
		var dict: Dictionary = cell
		return Vector2i(int(dict.get("x", 0)), int(dict.get("y", 0)))
	return Vector2i.ZERO


func _cell_key(cell: Vector2i) -> String:
	return "%s,%s" % [cell.x, cell.y]


func _finish() -> void:
	if failures.is_empty():
		print("V02.17 WORLDMAP ANCHOR RUNTIME TESTS PASSED")
		call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	call_deferred("quit", 1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
