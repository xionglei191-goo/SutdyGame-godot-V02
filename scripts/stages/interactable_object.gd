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
	_configure_sprite("Shadow", Vector2(3, building_size.y * 0.45), Vector2(building_size.x * 0.95, 15), "shadow")
	var prefab_texture_key := _place_prefab_texture_key(name)
	if not prefab_texture_key.is_empty() and _can_resolve_texture_key(prefab_texture_key):
		set_meta("place_marker_visual", "prefab")
		_configure_sprite("Building", Vector2.ZERO, building_size * _prefab_scale_for_place(name), prefab_texture_key)
		(get_node("Building") as CanvasItem).modulate = Color(1, 1, 1, 0.98)
		return
	var body_texture_key := "place_%s_body" % name
	if _can_resolve_texture_key(body_texture_key):
		set_meta("place_marker_visual", "context_resolved_body")
		_configure_sprite("Building", Vector2.ZERO, building_size, body_texture_key)
		(get_node("Building") as CanvasItem).modulate = Color(1, 1, 1, 0.18)
		return
	set_meta("place_marker_visual", "context_fallback")
	_configure_sprite("Building", Vector2(0, 8), Vector2(building_size.x, building_size.y - 8), body_texture_key)
	_configure_sprite("Roof", Vector2(0, -building_size.y * 0.32), Vector2(building_size.x * 0.92, 22), "place_%s_roof" % name)
	_configure_sprite("Door", Vector2(0, building_size.y * 0.25), Vector2(14, 18), "door_%s" % name)
	_configure_sprite("WindowLeft", Vector2(-building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_left" % name)
	_configure_sprite("WindowRight", Vector2(building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_right" % name)
	if name == "place_supermarket":
		_configure_sprite("ShopSignAnchor", Vector2(0, -building_size.y * 0.08), Vector2(48, 14), "anchor_shop_sign")
	elif name == "place_town_start":
		_configure_sprite("PlazaFlag", Vector2(building_size.x * 0.28, -building_size.y * 0.22), Vector2(14, 26), "plaza_flag")
	_mute_context_marker_parts()


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
	for meta_key in built.get_meta_list():
		sprite.set_meta(str(meta_key), built.get_meta(str(meta_key)))
	sprite.visible = true
	built.free()


func _mute_context_marker_parts() -> void:
	for marker_name in ["Building", "Roof", "Door", "WindowLeft", "WindowRight", "ShopSignAnchor", "PlazaFlag"]:
		if not has_node(marker_name):
			continue
		var item := get_node(marker_name) as CanvasItem
		if item == null or not item.visible:
			continue
		var current := item.modulate
		item.modulate = Color(current.r, current.g, current.b, 0.18)


func _can_resolve_texture_key(texture_key: String) -> bool:
	if renderer == null or not renderer.has_method("_can_resolve_texture_key"):
		return false
	return bool(renderer.call("_can_resolve_texture_key", texture_key))


func _place_prefab_texture_key(place_id: String) -> String:
	if renderer == null or not renderer.has_method("_place_prefab_texture_key_for_place"):
		return ""
	return str(renderer.call("_place_prefab_texture_key_for_place", place_id))


func _prefab_scale_for_place(place_id: String) -> Vector2:
	match place_id:
		"place_home":
			return Vector2(1.9, 2.15)
		"place_supermarket":
			return Vector2(2.0, 2.0)
		"place_school_gate":
			return Vector2(2.35, 1.9)
		_:
			return Vector2.ONE


func _cell_position(cell: Dictionary) -> Vector2:
	return Vector2(
		int(cell.get("x", 0)) * map_cell_size,
		int(cell.get("y", 0)) * map_cell_size
	)


func _cell_center(cell: Dictionary) -> Vector2:
	return _cell_position(cell) + Vector2(map_cell_size, map_cell_size) * 0.5
