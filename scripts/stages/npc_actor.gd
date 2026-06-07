extends Node2D
class_name NPCActor

var renderer: Object
var npc_id := ""
var map_cell_size := 16


func configure(config: Dictionary) -> void:
	renderer = config.get("renderer", null)
	var npc: Dictionary = config.get("npc", {})
	map_cell_size = int(config.get("map_cell_size", map_cell_size))
	npc_id = str(npc.get("npc_id", "neighbor"))
	name = "npc_%s" % npc_id
	position = _cell_center(npc.get("cell", {}))
	set_meta("actor_type", "npc")
	set_meta("npc_id", npc_id)
	_configure_sprite("Shadow", Vector2(0, 14), Vector2(24, 7), "shadow")
	_configure_sprite("Body", Vector2(0, 2), Vector2(22, 26), "npc_%s_body" % npc_id)
	_configure_sprite("Head", Vector2(0, -13), Vector2(24, 22), "npc_%s_head" % npc_id)
	_configure_sprite("EarLeft", Vector2(-9, -24), Vector2(8, 10), "npc_%s_ear_left" % npc_id)
	_configure_sprite("EarRight", Vector2(9, -24), Vector2(8, 10), "npc_%s_ear_right" % npc_id)
	_configure_sprite("FaceDotLeft", Vector2(-4, -15), Vector2(3, 3), "face_dot")
	_configure_sprite("FaceDotRight", Vector2(4, -15), Vector2(3, 3), "face_dot")


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
