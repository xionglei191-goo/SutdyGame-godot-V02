extends Node2D
class_name InteractableObject

var renderer: Object
var map_cell_size := 16


func configure_place(config: Dictionary) -> void:
	renderer = config.get("renderer", null)
	var place: Dictionary = config.get("place", {})
	map_cell_size = int(config.get("map_cell_size", map_cell_size))
	name = str(place.get("place_id", "place"))
	set_meta("actor_type", "place")
	set_meta("place_id", name)
	_hide_all()
	var size_data: Dictionary = place.get("size", {"w": 2, "h": 2})
	var building_size := Vector2(
		int(size_data.get("w", 2)) * map_cell_size,
		int(size_data.get("h", 2)) * map_cell_size
	)
	position = _cell_position(place.get("position", {})) + building_size * 0.5
	var body_texture_key := "place_%s_body" % name
	_configure_sprite("Shadow", Vector2(3, building_size.y * 0.45), Vector2(building_size.x * 0.95, 15), "shadow")
	if _can_resolve_texture_key(body_texture_key):
		_configure_sprite("Building", Vector2.ZERO, building_size, body_texture_key)
		(get_node("Building") as CanvasItem).modulate = Color(1, 1, 1, 0.0)
		return
	_configure_sprite("Building", Vector2(0, 8), Vector2(building_size.x, building_size.y - 8), body_texture_key)
	_configure_sprite("Roof", Vector2(0, -building_size.y * 0.32), Vector2(building_size.x * 0.92, 22), "place_%s_roof" % name)
	_configure_sprite("Door", Vector2(0, building_size.y * 0.25), Vector2(14, 18), "door_%s" % name)
	_configure_sprite("WindowLeft", Vector2(-building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_left" % name)
	_configure_sprite("WindowRight", Vector2(building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_right" % name)
	if name == "place_supermarket":
		_configure_sprite("ShopSignAnchor", Vector2(0, -building_size.y * 0.08), Vector2(48, 14), "anchor_shop_sign")
	elif name == "place_town_start":
		_configure_sprite("PlazaFlag", Vector2(building_size.x * 0.28, -building_size.y * 0.22), Vector2(14, 26), "plaza_flag")


func configure_hotspot(config: Dictionary) -> void:
	renderer = config.get("renderer", null)
	var interaction: Dictionary = config.get("interaction", {})
	map_cell_size = int(config.get("map_cell_size", map_cell_size))
	name = str(interaction.get("interaction_id", "interaction"))
	position = _cell_center(interaction.get("cell", {}))
	modulate = Color(1, 1, 1, 0.18)
	set_meta("actor_type", "hotspot")
	set_meta("interaction_id", name)
	set_meta("place_id", str(interaction.get("place_id", "")))
	_hide_all()
	_configure_sprite("Glow", Vector2.ZERO, Vector2(map_cell_size * 0.9, map_cell_size * 0.55), "hotspot_glow")


func _hide_all() -> void:
	for child in get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false


func _configure_sprite(sprite_name: String, sprite_position: Vector2, sprite_size: Vector2, texture_key: String) -> void:
	var sprite := get_node(sprite_name) as Sprite2D
	var built := renderer.call("_create_sprite", sprite_name, sprite_position, sprite_size, texture_key) as Sprite2D
	sprite.position = built.position
	sprite.texture = built.texture
	sprite.scale = built.scale
	sprite.modulate = built.modulate
	sprite.visible = true
	built.free()


func _can_resolve_texture_key(texture_key: String) -> bool:
	if renderer == null or not renderer.has_method("_can_resolve_texture_key"):
		return false
	return bool(renderer.call("_can_resolve_texture_key", texture_key))


func _cell_position(cell: Dictionary) -> Vector2:
	return Vector2(
		int(cell.get("x", 0)) * map_cell_size,
		int(cell.get("y", 0)) * map_cell_size
	)


func _cell_center(cell: Dictionary) -> Vector2:
	return _cell_position(cell) + Vector2(map_cell_size, map_cell_size) * 0.5
