@tool
extends Control
class_name WorldOverviewScene

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")

const MAP_CELL_SIZE := 18
const BACKGROUND_COLOR := Color("#edf3ef")
const PLACE_COLOR := Color("#ffffff")
const PRIMARY_COLOR := Color("#2f6f73")
const TEXT_COLOR := Color("#1f2d2f")

var world_map: Dictionary = {}
var load_errors: Array = []
var _proxy_root: Control
var _dragging_marker: Control
var _drag_offset := Vector2.ZERO


func _ready() -> void:
	build_from_world_map()


func build_from_world_map(path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH) -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map(path)
	world_map = result.get("data", {})
	load_errors = result.get("errors", [])
	_build_proxy_nodes()
	return {
		"ok": result.get("ok", false),
		"errors": load_errors.duplicate(),
		"place_marker_count": get_place_marker_ids().size(),
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


func move_place_marker_for_test(place_id: String, cell: Vector2i) -> Dictionary:
	var marker := _find_place_marker(place_id)
	if marker == null:
		return {"ok": false, "reason": "unknown_place", "place_id": place_id}
	_set_marker_cell(marker, cell)
	return {"ok": true, "place_id": place_id, "cell": _cell_to_dict(cell)}


func _build_proxy_nodes() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 40, "h": 24})
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

	_proxy_root = Control.new()
	_proxy_root.name = "EditorOnlyProxyRoot"
	_proxy_root.custom_minimum_size = map_size
	_proxy_root.add_to_group("editor_only_proxy")
	add_child(_proxy_root)

	for place in world_map.get("places", []):
		_proxy_root.add_child(_create_place_marker(place))


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


func _dict_to_cell(cell: Dictionary) -> Vector2i:
	return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))


func _cell_to_dict(cell: Vector2i) -> Dictionary:
	return {"x": cell.x, "y": cell.y}


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
