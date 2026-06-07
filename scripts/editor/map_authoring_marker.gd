@tool
extends PanelContainer
class_name MapAuthoringMarker

signal marker_selected(runtime_type: String, stable_id: String)
signal marker_drag_finished(runtime_type: String, stable_id: String, from_cell: Vector2i, to_cell: Vector2i)

@export var stable_id: String = "":
	set(value):
		stable_id = value
		_refresh_label()
		queue_redraw()
@export var runtime_type: String = "":
	set(value):
		runtime_type = value
		_refresh_label()
		queue_redraw()
@export var cell: Vector2i = Vector2i.ZERO:
	set(value):
		cell = value
		_update_position()
@export var footprint: Vector2i = Vector2i.ONE
@export var display_label: String = "":
	set(value):
		display_label = value
		_refresh_label()
		queue_redraw()
@export var cell_size: int = 18:
	set(value):
		cell_size = max(1, value)
		_update_position()

var _dragging := false
var _drag_offset := Vector2.ZERO
var _drag_start_cell := Vector2i.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_update_position()
	_update_marker_style(false)
	_refresh_label()
	set_process_input(true)


func set_cell(value: Vector2i) -> void:
	cell = value


func set_selected(value: bool) -> void:
	_update_marker_style(value)


func to_dictionary() -> Dictionary:
	return {
		"stable_id": stable_id,
		"runtime_type": runtime_type,
		"cell": {"x": cell.x, "y": cell.y},
		"footprint": {"w": footprint.x, "h": footprint.y},
		"label": display_label,
	}


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return
		if mouse_event.pressed:
			_dragging = true
			_drag_start_cell = cell
			_drag_offset = mouse_event.position
			marker_selected.emit(runtime_type, stable_id)
			accept_event()


func _input(event: InputEvent) -> void:
	if not _dragging:
		return
	if event is InputEventMouseMotion:
		_update_drag_cell()
	elif event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and not mouse_event.pressed:
			_update_drag_cell()
			var ended_from := _drag_start_cell
			var ended_to := cell
			_dragging = false
			_drag_offset = Vector2.ZERO
			if ended_from != ended_to:
				marker_drag_finished.emit(runtime_type, stable_id, ended_from, ended_to)


func _update_drag_cell() -> void:
	var parent_control := get_parent() as Control
	if parent_control == null:
		return
	var target := parent_control.get_local_mouse_position() - _drag_offset
	cell = Vector2i(roundi(target.x / cell_size), roundi(target.y / cell_size))


func _update_position() -> void:
	position = Vector2(cell.x * cell_size, cell.y * cell_size)
	var min_size := Vector2(max(1, footprint.x) * cell_size, max(1, footprint.y) * cell_size)
	if runtime_type == "anchor":
		min_size = Vector2(max(min_size.x, 48.0), max(min_size.y, 42.0))
	elif runtime_type != "place":
		min_size = Vector2(max(min_size.x, 30.0), max(min_size.y, 22.0))
	else:
		min_size = Vector2(max(min_size.x, 44.0), max(min_size.y, 24.0))
	custom_minimum_size = min_size
	size = custom_minimum_size
	queue_redraw()


func _refresh_label() -> void:
	var label := find_child("Label", false, false) as Label
	if label == null:
		return
	label.text = _compact_label()
	label.clip_text = true
	label.add_theme_font_size_override("font_size", 24 if runtime_type == "anchor" else 10)
	label.add_theme_color_override("font_color", Color("#1d2417") if runtime_type == "anchor" else Color("#fff8df"))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.tooltip_text = "%s: %s" % [runtime_type, stable_id]
	tooltip_text = label.tooltip_text
	queue_redraw()


func _draw() -> void:
	if runtime_type != "anchor":
		return
	var text := _compact_label()
	if text.is_empty():
		return
	var font := get_theme_default_font()
	if font == null:
		return
	var font_size := 26
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var origin := Vector2(
		(size.x - text_size.x) * 0.5,
		(size.y - text_size.y) * 0.5 + font.get_ascent(font_size)
	)
	draw_string(font, origin + Vector2(1, 1), text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color("#fff2a899"))
	draw_string(font, origin, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color("#1d2417"))


func _compact_label() -> String:
	if runtime_type == "anchor":
		return display_label.substr(0, 1).to_upper()
	if runtime_type == "resource":
		return "R"
	if runtime_type == "npc_routine":
		return "N"
	var title := display_label if not display_label.is_empty() else stable_id
	if title.length() <= 8:
		return title
	var parts := title.split(" ", false)
	if parts.size() > 1:
		var initials := ""
		for part in parts:
			if str(part).length() > 0:
				initials += str(part).substr(0, 1).to_upper()
		if not initials.is_empty() and initials.length() <= 5:
			return initials
	return title.substr(0, 8)


func _update_marker_style(selected: bool) -> void:
	z_index = _z_index_for_type()
	add_theme_stylebox_override("panel", _stylebox_for_type(selected))
	queue_redraw()


func _z_index_for_type() -> int:
	if runtime_type == "anchor":
		return 90
	if runtime_type == "npc_routine":
		return 30
	if runtime_type == "resource":
		return 25
	if runtime_type == "place":
		return 10
	return 0


func _stylebox_for_type(selected: bool) -> StyleBoxFlat:
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = _marker_color()
	stylebox.border_color = Color("#f8f1d7") if selected else Color("#3f4b3f99")
	var border_width := 3 if selected else 1
	stylebox.border_width_left = border_width
	stylebox.border_width_top = border_width
	stylebox.border_width_right = border_width
	stylebox.border_width_bottom = border_width
	stylebox.corner_radius_top_left = 4
	stylebox.corner_radius_top_right = 4
	stylebox.corner_radius_bottom_left = 4
	stylebox.corner_radius_bottom_right = 4
	return stylebox


func _marker_color() -> Color:
	if runtime_type == "place":
		return Color("#527c62cc")
	if runtime_type == "anchor":
		return Color("#ffd94fff")
	if runtime_type == "resource":
		return Color("#68a98ecc")
	if runtime_type == "npc_routine":
		return Color("#7f79b8cc")
	return Color("#d7c894cc")
