extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MainScene := preload("res://scenes/main.tscn")

const HOME_ANCHORS: Array[String] = ["A", "C", "D", "W"]
const SCHOOL_LINE: Array[String] = ["E", "G", "K", "N", "R", "Y"]
const FIRST_RING: Array[String] = ["B", "F", "H", "I", "J", "O", "T"]
const SECOND_RING: Array[String] = ["L", "M", "P", "Q", "S", "U", "V"]
const FAR_EDGE: Array[String] = ["X", "Z"]
const FORBIDDEN_TEXT: Array[String] = ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "等级", "打卡", "完成率", "倒计时", "迟到", "必须", "错过", "独自远行", "赶车"]

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "V02.18 world map should load: %s" % [map_result.get("errors", [])])
	var world_map: Dictionary = map_result.get("data", {})
	_check_blueprint_readability(world_map)
	_check_runtime_readability(world_map)
	_finish()


func _check_blueprint_readability(world_map: Dictionary) -> void:
	var groups := {
		"home_anchors": 0,
		"school_line": 0,
		"first_ring": 0,
		"second_ring": 0,
		"far_edge": 0,
	}
	var anchors: Array = world_map.get("memory_anchors", [])
	_expect(anchors.size() == 26, "V02.18 audit should cover all 26 anchors")
	for anchor_value in anchors:
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var letter := str(anchor.get("letter", ""))
		var group := _screenshot_group_for_letter(letter)
		_expect(groups.has(group), "V02.18 screenshot group should be known: %s" % group)
		groups[group] = int(groups.get(group, 0)) + 1
		_expect(not str(anchor.get("anchor_id", "")).is_empty(), "V02.18 anchor should keep stable id")
		_expect(not str(anchor.get("card_id", "")).is_empty(), "V02.18 anchor should keep card id")
		_expect(not str(anchor.get("core_word", "")).is_empty(), "V02.18 anchor should keep core object")
		_expect(_cell_has_visible_neighbor(_dict_to_cell(anchor.get("position", {})), world_map), "V02.18 anchor should have a nearby look cell: %s" % anchor.get("anchor_id", ""))
	_check_school_badge_spacing(anchors)
	_expect(int(groups.get("home_anchors", 0)) == HOME_ANCHORS.size(), "V02.18 screenshot baseline should cover Home anchors")
	_expect(int(groups.get("school_line", 0)) == SCHOOL_LINE.size(), "V02.18 screenshot baseline should cover School line")
	_expect(int(groups.get("first_ring", 0)) == FIRST_RING.size(), "V02.18 screenshot baseline should cover first ring")
	_expect(int(groups.get("second_ring", 0)) == SECOND_RING.size(), "V02.18 screenshot baseline should cover second ring")
	_expect(int(groups.get("far_edge", 0)) == FAR_EDGE.size(), "V02.18 screenshot baseline should cover far edge")


func _check_runtime_readability(world_map: Dictionary) -> void:
	var save_path := "user://test_v0218_map_readability.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.18 readability save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	root.add_child(main)
	main.call("_ready")

	_expect(main.find_child("MapReadabilityLayer", true, false) is Node2D, "V02.18 map should expose readability layer")
	for node_name in ["MapReadZoneHomeSchool", "MapReadZoneTownRing", "MapReadZoneFarEdge", "MapReadSignHome", "MapReadSignSchool", "MapReadSignTownRing", "MapReadSignFarEdge"]:
		_expect(main.find_child(node_name, true, false) != null, "V02.18 map should expose guide node: %s" % node_name)

	var seen_groups := {}
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(interact_button != null and _control_path_visible(interact_button), "V02.18 visible Interact button should stay available")
	for anchor_value in world_map.get("memory_anchors", []):
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var anchor_id := str(anchor.get("anchor_id", ""))
		var letter := str(anchor.get("letter", ""))
		var core_word := str(anchor.get("core_word", ""))
		var card_id := str(anchor.get("card_id", ""))
		var group := _screenshot_group_for_letter(letter)
		seen_groups[group] = true

		var node := main.find_child(anchor_id, true, false) as Node2D
		_expect(node != null, "V02.18 anchor should be visible runtime node: %s" % anchor_id)
		if node == null:
			continue
		_expect(str(node.get_meta("mapread_layer", "")) == _layer_for_letter(letter), "V02.18 anchor should expose layer meta: %s" % anchor_id)
		_expect(str(node.get_meta("mapread_screenshot_group", "")) == group, "V02.18 anchor should expose screenshot group: %s" % anchor_id)
		var sprite := node.find_child("ObjectSprite", true, false) as Sprite2D
		_expect(sprite != null and sprite.scale.x > 0.0 and sprite.scale.y > 0.0, "V02.18 anchor should have readable object sprite: %s" % anchor_id)
		_expect(sprite != null and sprite.texture != null and sprite.texture.get_width() > 0, "V02.18 anchor sprite should have texture: %s" % anchor_id)
		var badge := node.find_child("LetterBadge", true, false) as Label
		_expect(badge != null and badge.text == letter, "V02.18 anchor should keep letter badge: %s" % anchor_id)
		_expect(badge != null and badge.size.x >= 28.0 and badge.size.y >= 28.0, "V02.18 letter badge should be readable size: %s" % anchor_id)
		_expect(badge != null and int(badge.get_theme_font_size("font_size")) >= 16, "V02.18 letter badge should use readable font: %s" % anchor_id)

		var anchor_cell := _dict_to_cell(anchor.get("position", {}))
		var look_cell := _best_look_cell(main, anchor_cell, anchor_id)
		_expect(main.move_player_to_cell(look_cell).get("ok", false), "V02.18 player should reach readable anchor look cell: %s" % anchor_id)
		_press_visible_button(interact_button, "V02.18 visible Interact should trigger anchor: %s" % anchor_id)
		_expect(str(main.life_status_label.text).contains(core_word), "V02.18 anchor feedback should name life object: %s" % anchor_id)
		_expect(bool(main.memory_card_service.get_card_state(card_id).get("collected", false)), "V02.18 anchor should still collect album card: %s" % anchor_id)
		for forbidden in FORBIDDEN_TEXT:
			_expect(not str(main.life_status_label.text).contains(forbidden), "V02.18 anchor feedback should avoid pressure text %s: %s" % [forbidden, anchor_id])

	_expect(seen_groups.size() == 5, "V02.18 runtime pass should cover all screenshot groups")
	_expect(main.open_memory_album().get("ok", false), "V02.18 album should open after full map exploration")
	var album_text := _collect_visible_child_text(main)
	for forbidden in FORBIDDEN_TEXT:
		_expect(not album_text.contains(forbidden), "V02.18 album text should avoid pressure wording: %s" % forbidden)
	main.close_memory_album()
	_expect(main.save_service.clear_for_test(), "V02.18 readability save should clean up")
	root.remove_child(main)
	main.queue_free()


func _best_look_cell(main, anchor_cell: Vector2i, anchor_id: String) -> Vector2i:
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
			if str(nearest_anchor.get("anchor_id", "")) == anchor_id:
				return candidate
	return anchor_cell


func _cell_has_visible_neighbor(cell: Vector2i, world_map: Dictionary) -> bool:
	var candidates: Array[Vector2i] = [
		cell,
		cell + Vector2i(1, 0),
		cell + Vector2i(-1, 0),
		cell + Vector2i(0, 1),
		cell + Vector2i(0, -1),
	]
	for candidate in candidates:
		if _cell_in_canvas(candidate, world_map):
			return true
	return false


func _check_school_badge_spacing(anchors: Array) -> void:
	var badge_rects: Array[Dictionary] = []
	for anchor_value in anchors:
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var letter := str(anchor.get("letter", ""))
		if not SCHOOL_LINE.has(letter):
			continue
		var rect := _badge_rect_for_anchor(anchor)
		for existing in badge_rects:
			_expect(not _rects_are_too_close(rect, existing.get("rect", Rect2())), "V02.18 School line badges should not visually stack: %s near %s" % [letter, existing.get("letter", "")])
		badge_rects.append({"letter": letter, "rect": rect})


func _badge_rect_for_anchor(anchor: Dictionary) -> Rect2:
	var cell := _dict_to_cell(anchor.get("position", {}))
	var route_order := int(anchor.get("route_order", 1))
	var top_left := (Vector2(cell.x, cell.y) + Vector2(0.5, 0.5)) * 32.0 + _anchor_badge_offset(route_order)
	return Rect2(top_left, Vector2(28, 28))


func _anchor_badge_offset(route_order: int) -> Vector2:
	var offsets: Array[Vector2] = [
		Vector2(8, -31),
		Vector2(-31, -27),
		Vector2(10, 7),
		Vector2(-31, 5),
	]
	return offsets[(max(route_order, 1) - 1) % offsets.size()]


func _rects_are_too_close(a: Rect2, b: Rect2) -> bool:
	var padded := Rect2(a.position - Vector2(4, 4), a.size + Vector2(8, 8))
	return padded.intersects(b)


func _screenshot_group_for_letter(letter: String) -> String:
	if HOME_ANCHORS.has(letter):
		return "home_anchors"
	if SCHOOL_LINE.has(letter):
		return "school_line"
	if FIRST_RING.has(letter):
		return "first_ring"
	if SECOND_RING.has(letter):
		return "second_ring"
	if FAR_EDGE.has(letter):
		return "far_edge"
	return "reserved"


func _layer_for_letter(letter: String) -> String:
	if HOME_ANCHORS.has(letter) or SCHOOL_LINE.has(letter):
		return "p0_center"
	if FIRST_RING.has(letter):
		return "first_ring"
	if SECOND_RING.has(letter):
		return "second_ring"
	if FAR_EDGE.has(letter):
		return "far_edge"
	return "reserved"


func _press_visible_button(button: Button, message: String) -> void:
	_expect(button != null and _control_path_visible(button) and not button.disabled, message)
	if button != null and _control_path_visible(button) and not button.disabled:
		button.emit_signal("pressed")


func _control_path_visible(node: Node) -> bool:
	var current := node
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _collect_visible_child_text(node: Node) -> String:
	if node is Control and not (node as Control).visible:
		return ""
	var text := ""
	if node is Label:
		text += (node as Label).text + "\n"
	elif node is Button:
		text += (node as Button).text + "\n"
	for child in node.get_children():
		text += _collect_visible_child_text(child)
	return text


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


func _finish() -> void:
	if failures.is_empty():
		print("V02.18 MAP READABILITY TESTS PASSED")
		call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	call_deferred("quit", 1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
