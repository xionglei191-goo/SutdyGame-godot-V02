extends Node2D
class_name PlayerActor

var renderer: Object


func configure(config: Dictionary) -> void:
	renderer = config.get("renderer", null)
	name = "Player"
	_configure_sprite("Shadow", Vector2(0, 14), Vector2(22, 7), "shadow")
	if _can_resolve_texture_key("player_body"):
		_configure_sprite("Body", Vector2(0, -4), Vector2(34, 43), "player_body")
		_set_visible("Head", false)
		_set_visible("FaceDotLeft", false)
		_set_visible("FaceDotRight", false)
	else:
		_configure_sprite("Body", Vector2(0, 4), Vector2(20, 24), "player_body")
		_configure_sprite("Head", Vector2(0, -12), Vector2(22, 20), "player_head")
		_configure_sprite("FaceDotLeft", Vector2(-4, -13), Vector2(3, 3), "face_dot")
		_configure_sprite("FaceDotRight", Vector2(4, -13), Vector2(3, 3), "face_dot")


func _configure_sprite(sprite_name: String, sprite_position: Vector2, sprite_size: Vector2, texture_key: String) -> void:
	var sprite := get_node(sprite_name) as Sprite2D
	var built := renderer.call("_create_sprite", sprite_name, sprite_position, sprite_size, texture_key) as Sprite2D
	sprite.position = built.position
	sprite.texture = built.texture
	sprite.scale = built.scale
	sprite.modulate = built.modulate
	sprite.visible = true
	built.free()


func _set_visible(node_name: String, visible: bool) -> void:
	var node := get_node(node_name) as CanvasItem
	node.visible = visible


func _can_resolve_texture_key(texture_key: String) -> bool:
	if renderer == null or not renderer.has_method("_can_resolve_texture_key"):
		return false
	return bool(renderer.call("_can_resolve_texture_key", texture_key))
