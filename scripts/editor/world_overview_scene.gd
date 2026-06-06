@tool
extends Control
class_name WorldOverviewScene

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")

const MAP_CELL_SIZE := 18
const BACKGROUND_COLOR := Color("#edf3ef")
const GRID_MAJOR_COLOR := Color("#b7c8c1")
const GRID_MINOR_COLOR := Color("#d9e4df")
const PLACE_COLOR := Color("#ffffff")
const PRIMARY_COLOR := Color("#2f6f73")
const ROAD_COLOR := Color("#d7c894")
const OCCUPIED_COLOR := Color("#c46a5c")
const INTERACTION_COLOR := Color("#6a9f7b")
const TEXT_COLOR := Color("#1f2d2f")

var world_map: Dictionary = {}
var editor_state: Dictionary = {}
var load_errors: Array = []
var selected_road_id := "road_home_plaza_ring"
var _proxy_root: Control
var _grid_root: Control
var _cell_overlay_root: Control
var _dragging_marker: Control
var _drag_offset := Vector2.ZERO
var _undo_stack: Array[Dictionary] = []
var _redo_stack: Array[Dictionary] = []


func _ready() -> void:
	build_from_world_map()


func build_from_world_map(path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH) -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map(path)
	world_map = result.get("data", {})
	editor_state = world_map.duplicate(true)
	load_errors = result.get("errors", [])
	_build_proxy_nodes()
	return {
		"ok": result.get("ok", false),
		"errors": load_errors.duplicate(),
		"place_marker_count": get_place_marker_ids().size(),
		"grid_cell_count": get_grid_summary().get("cell_count", 0),
	}


func is_editor_only_proxy_scene() -> bool:
	return true


func get_place_marker_ids() -> Array[String]:
	var ids: Array[String] = []
	if not is_instance_valid(_proxy_root):
		return ids
	for child in _proxy_root.get_children():
		if child.has_meta("place_id"):
			ids.append(str(child.get_meta("place_id")))
	ids.sort()
	return ids


func get_place_marker_cell(place_id: String) -> Vector2i:
	var marker := _find_place_marker(place_id)
	if marker == null:
		return Vector2i(-1, -1)
	if marker.has_meta("cell"):
		var cell = marker.get_meta("cell")
		if cell is Vector2i:
			return cell
	return Vector2i(int(marker.position.x / MAP_CELL_SIZE), int(marker.position.y / MAP_CELL_SIZE))


func get_grid_summary() -> Dictionary:
	var canvas_size: Dictionary = editor_state.get("canvas_size", world_map.get("canvas_size", {"w": 0, "h": 0}))
	var logical_cell_size: Dictionary = editor_state.get("cell_size", world_map.get("cell_size", {"w": 0, "h": 0}))
	var width := int(canvas_size.get("w", 0))
	var height := int(canvas_size.get("h", 0))
	return {
		"canvas_w": width,
		"canvas_h": height,
		"cell_count": width * height,
		"display_cell_px": MAP_CELL_SIZE,
		"logical_cell_w": int(logical_cell_size.get("w", 0)),
		"logical_cell_h": int(logical_cell_size.get("h", 0)),
		"line_count": (width + 1) + (height + 1),
	}


func get_road_cell_count(road_id: String) -> int:
	for road in editor_state.get("roads", []):
		if str(road.get("road_id", "")) == road_id:
			return road.get("cells", []).size()
	return 0


func has_road_cell(road_id: String, cell: Vector2i) -> bool:
	var road := _find_road(road_id)
	if road.is_empty():
		return false
	for road_cell in road.get("cells", []):
		if _dict_to_cell(road_cell) == cell:
			return true
	return false


func has_occupied_cell(cell: Vector2i) -> bool:
	for occupied in editor_state.get("collision_cells", []):
		if _dict_to_cell(occupied) == cell:
			return true
	for place in editor_state.get("places", []):
		for occupied in place.get("occupied_cells", []):
			if _dict_to_cell(occupied) == cell:
				return true
	return false


func get_interaction_cell(interaction_id: String) -> Vector2i:
	for interaction in editor_state.get("interaction_cells", []):
		if str(interaction.get("interaction_id", "")) == interaction_id:
			return _dict_to_cell(interaction.get("cell", {}))
	return Vector2i(-1, -1)


func move_place_marker_for_test(place_id: String, cell: Vector2i) -> Dictionary:
	var marker := _find_place_marker(place_id)
	if marker == null:
		return {"ok": false, "reason": "unknown_place", "place_id": place_id}
	var before := editor_state.duplicate(true)
	_apply_place_marker_cell(place_id, cell)
	_set_marker_cell(marker, cell)
	_commit_command("move_place", before)
	return {"ok": true, "place_id": place_id, "cell": _cell_to_dict(cell)}


func toggle_road_cell_for_test(road_id: String, cell: Vector2i) -> Dictionary:
	var road := _find_road(road_id)
	if road.is_empty():
		return {"ok": false, "reason": "unknown_road", "road_id": road_id}
	var before := editor_state.duplicate(true)
	var cells: Array = road.get("cells", [])
	var removed := false
	for index in range(cells.size() - 1, -1, -1):
		if _dict_to_cell(cells[index]) == cell:
			cells.remove_at(index)
			removed = true
			break
	if not removed:
		cells.append(_cell_to_dict(cell))
	_sort_cells(cells)
	road["cells"] = cells
	_commit_command("toggle_road_cell", before)
	_rebuild_cell_overlays()
	return {"ok": true, "road_id": road_id, "cell": _cell_to_dict(cell), "mode": "removed" if removed else "added"}


func set_occupied_cell_for_test(cell: Vector2i, occupied: bool) -> Dictionary:
	var before := editor_state.duplicate(true)
	var cells: Array = editor_state.get("collision_cells", [])
	var found_index := -1
	for index in range(cells.size()):
		if _dict_to_cell(cells[index]) == cell:
			found_index = index
			break
	if occupied and found_index == -1:
		cells.append(_cell_to_dict(cell))
		_sort_cells(cells)
	elif not occupied and found_index != -1:
		cells.remove_at(found_index)
	editor_state["collision_cells"] = cells
	_commit_command("set_occupied_cell", before)
	_rebuild_cell_overlays()
	return {"ok": true, "cell": _cell_to_dict(cell), "occupied": occupied}


func set_interaction_cell_for_test(interaction_id: String, place_id: String, cell: Vector2i, action_id: String = "editor_interact") -> Dictionary:
	if has_occupied_cell(cell):
		return {"ok": false, "reason": "interaction_over_occupied", "interaction_id": interaction_id, "cell": _cell_to_dict(cell)}
	var before := editor_state.duplicate(true)
	var interactions: Array = editor_state.get("interaction_cells", [])
	var updated := false
	for interaction in interactions:
		if str(interaction.get("interaction_id", "")) == interaction_id:
			interaction["place_id"] = place_id
			interaction["cell"] = _cell_to_dict(cell)
			interaction["action_id"] = action_id
			updated = true
			break
	if not updated:
		interactions.append({
			"interaction_id": interaction_id,
			"place_id": place_id,
			"cell": _cell_to_dict(cell),
			"action_id": action_id,
		})
	editor_state["interaction_cells"] = interactions
	_commit_command("set_interaction_cell", before)
	_rebuild_cell_overlays()
	return {"ok": true, "interaction_id": interaction_id, "cell": _cell_to_dict(cell)}


func undo_for_test() -> Dictionary:
	if _undo_stack.is_empty():
		return {"ok": false, "reason": "empty_undo"}
	var command: Dictionary = _undo_stack.pop_back()
	_redo_stack.append({"label": command.get("label", ""), "state": editor_state.duplicate(true)})
	editor_state = command.get("state", {}).duplicate(true)
	_build_proxy_nodes()
	return {"ok": true, "label": command.get("label", ""), "undo_depth": _undo_stack.size(), "redo_depth": _redo_stack.size()}


func redo_for_test() -> Dictionary:
	if _redo_stack.is_empty():
		return {"ok": false, "reason": "empty_redo"}
	var command: Dictionary = _redo_stack.pop_back()
	_undo_stack.append({"label": command.get("label", ""), "state": editor_state.duplicate(true)})
	editor_state = command.get("state", {}).duplicate(true)
	_build_proxy_nodes()
	return {"ok": true, "label": command.get("label", ""), "undo_depth": _undo_stack.size(), "redo_depth": _redo_stack.size()}


func get_editor_state() -> Dictionary:
	return editor_state.duplicate(true)


func _build_proxy_nodes() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var canvas_size: Dictionary = editor_state.get("canvas_size", world_map.get("canvas_size", {"w": 40, "h": 24}))
	var map_size := Vector2(
		int(canvas_size.get("w", 40)) * MAP_CELL_SIZE,
		int(canvas_size.get("h", 24)) * MAP_CELL_SIZE
	)

	var background := ColorRect.new()
	background.name = "EditorOnlyMapBackground"
	background.color = BACKGROUND_COLOR
	background.position = Vector2.ZERO
	background.size = map_size
	add_child(background)

	_grid_root = Control.new()
	_grid_root.name = "EditorOnlyGridOverlay"
	_grid_root.custom_minimum_size = map_size
	_grid_root.add_to_group("editor_only_proxy")
	add_child(_grid_root)
	_build_grid_overlay(canvas_size, map_size)

	_cell_overlay_root = Control.new()
	_cell_overlay_root.name = "EditorOnlyCellOverlay"
	_cell_overlay_root.custom_minimum_size = map_size
	_cell_overlay_root.add_to_group("editor_only_proxy")
	add_child(_cell_overlay_root)

	_proxy_root = Control.new()
	_proxy_root.name = "EditorOnlyProxyRoot"
	_proxy_root.custom_minimum_size = map_size
	_proxy_root.add_to_group("editor_only_proxy")
	add_child(_proxy_root)

	_rebuild_cell_overlays()
	for place in editor_state.get("places", []):
		_proxy_root.add_child(_create_place_marker(place))


func _build_grid_overlay(canvas_size: Dictionary, map_size: Vector2) -> void:
	var width := int(canvas_size.get("w", 40))
	var height := int(canvas_size.get("h", 24))
	for x in range(width + 1):
		var line := ColorRect.new()
		line.name = "GridV_%02d" % x
		line.color = GRID_MAJOR_COLOR if x % 5 == 0 else GRID_MINOR_COLOR
		line.position = Vector2(x * MAP_CELL_SIZE, 0)
		line.size = Vector2(1, map_size.y)
		_grid_root.add_child(line)
	for y in range(height + 1):
		var line := ColorRect.new()
		line.name = "GridH_%02d" % y
		line.color = GRID_MAJOR_COLOR if y % 5 == 0 else GRID_MINOR_COLOR
		line.position = Vector2(0, y * MAP_CELL_SIZE)
		line.size = Vector2(map_size.x, 1)
		_grid_root.add_child(line)


func _rebuild_cell_overlays() -> void:
	if not is_instance_valid(_cell_overlay_root):
		return
	for child in _cell_overlay_root.get_children():
		_cell_overlay_root.remove_child(child)
		child.queue_free()
	for road in editor_state.get("roads", []):
		for cell in road.get("cells", []):
			_cell_overlay_root.add_child(_create_cell_rect("RoadCell_%s" % str(road.get("road_id", "")), _dict_to_cell(cell), ROAD_COLOR))
	for cell in editor_state.get("collision_cells", []):
		_cell_overlay_root.add_child(_create_cell_rect("OccupiedCell", _dict_to_cell(cell), OCCUPIED_COLOR))
	for interaction in editor_state.get("interaction_cells", []):
		_cell_overlay_root.add_child(_create_cell_rect("InteractionCell_%s" % str(interaction.get("interaction_id", "")), _dict_to_cell(interaction.get("cell", {})), INTERACTION_COLOR))


func _create_cell_rect(base_name: String, cell: Vector2i, color: Color) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = "%s_%d_%d" % [base_name, cell.x, cell.y]
	rect.color = Color(color.r, color.g, color.b, 0.68)
	rect.position = Vector2(cell.x * MAP_CELL_SIZE + 2, cell.y * MAP_CELL_SIZE + 2)
	rect.size = Vector2(MAP_CELL_SIZE - 4, MAP_CELL_SIZE - 4)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.add_to_group("editor_only_proxy")
	return rect


func _create_place_marker(place: Dictionary) -> Control:
	var marker := PanelContainer.new()
	var place_id := str(place.get("place_id", "place"))
	marker.name = "proxy_%s" % place_id
	marker.mouse_filter = Control.MOUSE_FILTER_STOP
	marker.add_to_group("editor_only_proxy")
	marker.set_meta("place_id", place_id)
	marker.set_meta("place_label", str(place.get("label", place_id)))
	marker.add_theme_stylebox_override("panel", _rounded_box(PLACE_COLOR, 4, PRIMARY_COLOR))

	var size_data: Dictionary = place.get("size", {"w": 2, "h": 2})
	marker.size = Vector2(
		int(size_data.get("w", 2)) * MAP_CELL_SIZE,
		int(size_data.get("h", 2)) * MAP_CELL_SIZE
	)
	_set_marker_cell(marker, _dict_to_cell(place.get("position", {})))
	marker.gui_input.connect(_on_place_marker_gui_input.bind(marker))

	var label := Label.new()
	label.name = "Label"
	label.text = str(place.get("label", place_id))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", TEXT_COLOR)
	label.add_theme_font_size_override("font_size", 12)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	marker.add_child(label)

	return marker


func _on_place_marker_gui_input(event: InputEvent, marker: Control) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return
		if mouse_event.pressed:
			_dragging_marker = marker
			_drag_offset = mouse_event.position
		elif _dragging_marker == marker:
			_dragging_marker = null
	elif event is InputEventMouseMotion and _dragging_marker == marker:
		var mouse_motion: InputEventMouseMotion = event
		var target := marker.position + mouse_motion.relative
		var cell := Vector2i(roundi(target.x / MAP_CELL_SIZE), roundi(target.y / MAP_CELL_SIZE))
		_set_marker_cell(marker, cell)
		_apply_place_marker_cell(str(marker.get_meta("place_id")), cell)


func _find_place_marker(place_id: String) -> Control:
	if not is_instance_valid(_proxy_root):
		return null
	for child in _proxy_root.get_children():
		if child.has_meta("place_id") and str(child.get_meta("place_id")) == place_id:
			return child as Control
	return null


func _set_marker_cell(marker: Control, cell: Vector2i) -> void:
	marker.position = Vector2(cell.x * MAP_CELL_SIZE, cell.y * MAP_CELL_SIZE)
	marker.set_meta("cell", cell)


func _apply_place_marker_cell(place_id: String, cell: Vector2i) -> void:
	for place in editor_state.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			place["position"] = _cell_to_dict(cell)
			return


func _find_road(road_id: String) -> Dictionary:
	for road in editor_state.get("roads", []):
		if str(road.get("road_id", "")) == road_id:
			return road
	return {}


func _commit_command(label: String, before_state: Dictionary) -> void:
	_undo_stack.append({"label": label, "state": before_state})
	_redo_stack.clear()


func _dict_to_cell(cell: Dictionary) -> Vector2i:
	return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))


func _cell_to_dict(cell: Vector2i) -> Dictionary:
	return {"x": cell.x, "y": cell.y}


func _sort_cells(cells: Array) -> void:
	cells.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ac := _dict_to_cell(a)
		var bc := _dict_to_cell(b)
		if ac.y == bc.y:
			return ac.x < bc.x
		return ac.y < bc.y
	)


func _rounded_box(fill: Color, radius: int, border: Color = Color.TRANSPARENT) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.corner_radius_top_left = radius
	box.corner_radius_top_right = radius
	box.corner_radius_bottom_left = radius
	box.corner_radius_bottom_right = radius
	if border.a > 0.0:
		box.border_color = border
		box.border_width_left = 1
		box.border_width_top = 1
		box.border_width_right = 1
		box.border_width_bottom = 1
	return box
