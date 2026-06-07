@tool
extends PanelContainer
class_name MapAuthoringMarker

@export var stable_id: String = "":
	set(value):
		stable_id = value
		_refresh_label()
@export var runtime_type: String = "":
	set(value):
		runtime_type = value
		_refresh_label()
@export var cell: Vector2i = Vector2i.ZERO:
	set(value):
		cell = value
		_update_position()
@export var footprint: Vector2i = Vector2i.ONE
@export var display_label: String = "":
	set(value):
		display_label = value
		_refresh_label()
@export var cell_size: int = 18:
	set(value):
		cell_size = max(1, value)
		_update_position()

var _dragging := false
var _drag_offset := Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_update_position()
	_refresh_label()


func set_cell(value: Vector2i) -> void:
	cell = value


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
		_dragging = mouse_event.pressed
		_drag_offset = mouse_event.position
	elif event is InputEventMouseMotion and _dragging:
		var mouse_motion: InputEventMouseMotion = event
		var target := position + mouse_motion.relative - _drag_offset
		cell = Vector2i(roundi(target.x / cell_size), roundi(target.y / cell_size))


func _update_position() -> void:
	position = Vector2(cell.x * cell_size, cell.y * cell_size)
	custom_minimum_size = Vector2(max(1, footprint.x) * cell_size, max(1, footprint.y) * cell_size)
	size = custom_minimum_size


func _refresh_label() -> void:
	var label := find_child("Label", false, false) as Label
	if label == null:
		return
	var title := display_label if not display_label.is_empty() else stable_id
	label.text = "%s\n%s" % [title, runtime_type]
