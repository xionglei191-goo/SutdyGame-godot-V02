extends Node2D
class_name ResourceObject

var renderer: Object
var map_cell_size := 16


func configure(config: Dictionary) -> void:
	renderer = config.get("renderer", null)
	var point: Dictionary = config.get("point", {})
	map_cell_size = int(config.get("map_cell_size", map_cell_size))
	var item_id := str(point.get("item_id", "resource"))
	name = "resource_%s" % item_id
	position = _cell_center(point.get("cell", {}))
	set_meta("actor_type", "resource")
	set_meta("item_id", item_id)
	set_meta("point_id", str(point.get("point_id", item_id)))
	_configure_sprite("ResourceSprite", Vector2.ZERO, Vector2(map_cell_size * 1.2, map_cell_size * 1.2), "resource_%s" % item_id)


func _configure_sprite(sprite_name: String, sprite_position: Vector2, sprite_size: Vector2, texture_key: String) -> void:
	var sprite := get_node(sprite_name) as Sprite2D
	var built := renderer.call("_create_sprite", sprite_name, sprite_position, sprite_size, texture_key) as Sprite2D
	sprite.position = built.position
	sprite.texture = built.texture
	sprite.scale = built.scale
	sprite.modulate = built.modulate
	sprite.visible = true
	built.free()


func _cell_center(cell: Dictionary) -> Vector2:
	return Vector2(
		int(cell.get("x", 0)) * map_cell_size + map_cell_size * 0.5,
		int(cell.get("y", 0)) * map_cell_size + map_cell_size * 0.5
	)
