extends Node2D
class_name AnchorObject

var renderer: Object
var map_cell_size := 16


func configure(config: Dictionary) -> void:
	renderer = config.get("renderer", null)
	var anchor: Dictionary = config.get("anchor", {})
	map_cell_size = int(config.get("map_cell_size", map_cell_size))
	var reserved := bool(config.get("reserved", false))
	name = str(anchor.get("anchor_id", "anchor"))
	set_meta("actor_type", "anchor")
	set_meta("anchor_id", name)
	set_meta("letter", str(anchor.get("letter", "")))
	if reserved:
		_configure_reserved(anchor)
	else:
		_configure_runtime(anchor)


func _configure_runtime(anchor: Dictionary) -> void:
	var letter := str(anchor.get("letter", ""))
	position = _cell_center(anchor.get("position", {}))
	set_meta("mapread_layer", str(renderer.call("_mapread_layer_for_anchor", letter)))
	set_meta("mapread_screenshot_group", str(renderer.call("_mapread_screenshot_group_for_anchor", letter)))
	set_meta("mapread_core_word", str(anchor.get("core_word", "")))
	_configure_anchor_sprite(letter)
	(get_node("ObjectSprite") as CanvasItem).visible = true
	(get_node("FutureObject") as CanvasItem).visible = false
	_configure_letter_badge(anchor)
	get_node("ObjectLabel").show()


func _configure_reserved(anchor: Dictionary) -> void:
	var route_order := int(anchor.get("route_order", 1))
	position = Vector2(
		(((route_order - 1) % 13) * map_cell_size * 2) + map_cell_size,
		((20 + int(float(route_order - 1) / 13.0)) * map_cell_size) + map_cell_size
	)
	_configure_sprite("FutureObject", Vector2.ZERO, Vector2(map_cell_size * 1.15, map_cell_size * 0.9), "reserved_anchor_%s" % str(anchor.get("letter", "")))
	(get_node("ObjectSprite") as CanvasItem).visible = false
	(get_node("FutureObject") as CanvasItem).visible = true
	_configure_letter_badge(anchor)
	get_node("ObjectLabel").show()


func _configure_anchor_sprite(letter: String) -> void:
	var sprite := get_node("ObjectSprite") as Sprite2D
	var built := renderer.call("_create_anchor_object_sprite", letter) as Sprite2D
	sprite.position = built.position
	sprite.texture = built.texture
	sprite.scale = built.scale
	sprite.modulate = built.modulate
	sprite.z_index = built.z_index
	built.free()


func _configure_letter_badge(anchor: Dictionary) -> void:
	var badge := get_node("LetterBadge") as Label
	var built := renderer.call("_create_anchor_letter_badge", anchor) as Label
	badge.text = built.text
	badge.custom_minimum_size = built.custom_minimum_size
	badge.size = built.size
	badge.position = built.position
	badge.modulate = built.modulate
	badge.horizontal_alignment = built.horizontal_alignment
	badge.vertical_alignment = built.vertical_alignment
	badge.mouse_filter = built.mouse_filter
	badge.z_index = built.z_index
	badge.add_theme_color_override("font_color", Color("#44584fcc"))
	badge.add_theme_font_size_override("font_size", 12)
	badge.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#fff8cf55"), 7, Color("#9f7a2e33")))
	badge.visible = true
	built.free()


func _configure_sprite(sprite_name: String, sprite_position: Vector2, sprite_size: Vector2, texture_key: String) -> void:
	var sprite := get_node(sprite_name) as Sprite2D
	var built := renderer.call("_create_sprite", sprite_name, sprite_position, sprite_size, texture_key) as Sprite2D
	sprite.position = built.position
	sprite.texture = built.texture
	sprite.scale = built.scale
	sprite.modulate = built.modulate
	sprite.z_index = built.z_index
	sprite.visible = true
	built.free()


func _cell_center(cell: Dictionary) -> Vector2:
	return Vector2(
		int(cell.get("x", 0)) * map_cell_size + map_cell_size * 0.5,
		int(cell.get("y", 0)) * map_cell_size + map_cell_size * 0.5
	)
