extends Node2D
class_name PlayerActor

const FRAME_SIZE := Vector2i(64, 64)
const FRAME_ROWS := {
	"idle_down": 0,
	"walk_down": 1,
	"walk_left": 2,
	"walk_up": 3,
}
const WALK_FRAME_COUNT := 4
const WALK_FPS := 8.0

var renderer: Object
var facing := Vector2i(0, 1)
var walking := false
var animation_key := "idle_down"
var animation_time := 0.0
var motion_sheet: Texture2D
var body_sprite: Sprite2D


func configure(config: Dictionary) -> void:
	renderer = config.get("renderer", null)
	name = "Player"
	set_process(true)
	_configure_sprite("Shadow", Vector2(0, 14), Vector2(22, 7), "shadow")
	body_sprite = get_node("Body") as Sprite2D
	if _can_resolve_texture_key("player_motion_sheet"):
		motion_sheet = renderer.call("_get_texture", "player_motion_sheet") as Texture2D
		body_sprite.position = Vector2(0, -5)
		body_sprite.scale = Vector2(42.0 / FRAME_SIZE.x, 42.0 / FRAME_SIZE.y)
		body_sprite.visible = true
		_set_visible("Head", false)
		_set_visible("FaceDotLeft", false)
		_set_visible("FaceDotRight", false)
		_apply_animation_frame()
		return
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


func _process(delta: float) -> void:
	if motion_sheet == null:
		return
	if walking:
		animation_time += delta
		_apply_animation_frame()


func set_motion_state(next_facing: Vector2i, is_walking: bool) -> void:
	if next_facing != Vector2i.ZERO:
		facing = next_facing
	walking = is_walking
	var next_key := _animation_key_for_state()
	if next_key != animation_key:
		animation_key = next_key
		animation_time = 0.0
	_apply_animation_frame()


func get_motion_snapshot() -> Dictionary:
	return {
		"animation_key": animation_key,
		"facing": {"x": facing.x, "y": facing.y},
		"walking": walking,
		"uses_motion_sheet": motion_sheet != null,
		"frame_index": _current_frame_index(),
	}


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


func _set_visible(node_name: String, visible: bool) -> void:
	var node := get_node(node_name) as CanvasItem
	node.visible = visible


func _can_resolve_texture_key(texture_key: String) -> bool:
	if renderer == null or not renderer.has_method("_can_resolve_texture_key"):
		return false
	return bool(renderer.call("_can_resolve_texture_key", texture_key))


func _animation_key_for_state() -> String:
	if facing.y < 0:
		return "walk_up" if walking else "idle_up"
	if facing.x != 0:
		return "walk_left" if walking else "idle_side"
	return "walk_down" if walking else "idle_down"


func _current_frame_index() -> int:
	if not walking:
		return 0
	return int(floor(animation_time * WALK_FPS)) % WALK_FRAME_COUNT


func _apply_animation_frame() -> void:
	if motion_sheet == null or body_sprite == null:
		return
	var row_key := animation_key
	if row_key == "idle_up":
		row_key = "walk_up"
	elif row_key == "idle_side":
		row_key = "walk_left"
	var row := int(FRAME_ROWS.get(row_key, 0))
	var frame := _current_frame_index()
	var atlas := AtlasTexture.new()
	atlas.atlas = motion_sheet
	atlas.region = Rect2(frame * FRAME_SIZE.x, row * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
	body_sprite.texture = atlas
	body_sprite.flip_h = facing.x > 0
