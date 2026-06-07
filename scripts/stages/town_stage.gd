extends Control
class_name TownStage

signal map_cell_requested(cell: Vector2i)

const PlayerActorScene := preload("res://scenes/world/actors/player_actor.tscn")
const NPCActorScene := preload("res://scenes/world/actors/npc_actor.tscn")
const ResourceObjectScene := preload("res://scenes/world/actors/resource_object.tscn")
const AnchorObjectScene := preload("res://scenes/world/actors/anchor_object.tscn")
const InteractableObjectScene := preload("res://scenes/world/actors/interactable_object.tscn")

var renderer: Object
var world_map: Dictionary = {}
var az_core_data: Dictionary = {}
var resource_points: Array = []
var first_npcs: Array = []
var outdoor_items: Array = []
var map_cell_size := 16
var map_render_size := Vector2(1280, 720)
var local_camera_scale := Vector2(2.05, 2.05)

var runtime_map_frame: Control
var runtime_map_input: Control
var runtime_map_node: Node2D
var player_marker: Node2D
var ground_layer: Node2D
var road_visual_layer: Node2D
var place_layer: Node2D
var plaza_life_layer: Node2D
var hotspot_layer: Node2D
var collision_debug_layer: Node2D
var anchor_layer: Node2D
var resource_layer: Node2D
var npc_actor_layer: Node2D
var outdoor_decor_layer: Node2D
var player_layer: Node2D


func setup(config: Dictionary) -> Dictionary:
	renderer = config.get("renderer")
	world_map = config.get("world_map", {})
	az_core_data = config.get("az_core_data", {})
	resource_points = config.get("resource_points", [])
	first_npcs = config.get("first_npcs", [])
	outdoor_items = config.get("outdoor_items", [])
	map_cell_size = int(config.get("map_cell_size", map_cell_size))
	map_render_size = config.get("map_render_size", map_render_size)
	local_camera_scale = config.get("local_camera_scale", local_camera_scale)

	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 40, "h": 24})
	var map_width := int(canvas_size.get("w", 40)) * map_cell_size
	var map_height := int(canvas_size.get("h", 24)) * map_cell_size

	runtime_map_frame = get_node("RuntimeMapFrame") as Control
	runtime_map_frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	runtime_map_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	runtime_map_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL

	runtime_map_input = get_node("RuntimeMapFrame/RuntimeMapInput") as Control
	runtime_map_input.set_anchors_preset(Control.PRESET_FULL_RECT)
	runtime_map_input.custom_minimum_size = Vector2(map_width, map_height)
	runtime_map_input.mouse_filter = Control.MOUSE_FILTER_STOP
	if not runtime_map_input.gui_input.is_connected(_on_map_gui_input):
		runtime_map_input.gui_input.connect(_on_map_gui_input)

	runtime_map_node = get_node("RuntimeMapFrame/RuntimeMap") as Node2D
	runtime_map_node.position = Vector2.ZERO
	runtime_map_node.scale = local_camera_scale
	_bind_runtime_layers()
	_clear_runtime_layers()

	var ground := _call_renderer("_create_sprite", ["Ground", Vector2(map_width, map_height) * 0.5, Vector2(map_width, map_height), "ground"]) as Node
	ground_layer.add_child(ground)
	_call_renderer("_add_town_scenery", [ground_layer, map_width, map_height])

	for road in world_map.get("roads", []):
		for cell in road.get("cells", []):
			var road_cell := _call_renderer("_create_sprite", ["RoadCell", cell_center(cell), Vector2(map_cell_size + 6, map_cell_size + 4), "road"]) as CanvasItem
			road_cell.modulate = Color(1, 1, 1, 0.05)
			road_visual_layer.add_child(road_cell)

	for place in world_map.get("places", []):
		place_layer.add_child(_create_place_object(place))

	_render_plaza_life_details()
	_render_school_life_details()

	for interaction in world_map.get("interaction_cells", []):
		hotspot_layer.add_child(_create_hotspot_object(interaction))

	for cell in world_map.get("collision_cells", []):
		collision_debug_layer.add_child(_call_renderer("_create_collision_marker", [cell]) as Node)

	for anchor in world_map.get("memory_anchors", []):
		anchor_layer.add_child(_create_anchor_object(anchor, false))

	for anchor in az_core_data.get("anchors", []):
		if _map_anchor_letters().has(anchor.get("letter", "")):
			continue
		anchor_layer.add_child(_create_anchor_object(anchor, true))

	for point in resource_points:
		resource_layer.add_child(_create_resource_object(point))

	for npc in first_npcs:
		npc_actor_layer.add_child(_create_npc_actor(npc))

	render_outdoor_items(outdoor_items)

	player_marker = _create_player_actor()
	player_layer.add_child(player_marker)

	return {
		"frame": runtime_map_frame,
		"input": runtime_map_input,
		"map": runtime_map_node,
		"player_marker": player_marker,
	}


func update_player_marker(player_world_position: Vector2) -> void:
	if is_instance_valid(player_marker):
		player_marker.position = player_world_position
	update_camera_for_player(player_world_position)


func render_outdoor_items(items: Array) -> void:
	outdoor_items = items.duplicate(true)
	if not is_instance_valid(outdoor_decor_layer):
		return
	for child in outdoor_decor_layer.get_children():
		outdoor_decor_layer.remove_child(child)
		child.queue_free()
	for value in outdoor_items:
		if not value is Dictionary:
			continue
		outdoor_decor_layer.add_child(_create_outdoor_decor(value))


func get_expapproval_snapshot() -> Dictionary:
	var anchor_badge_count := 0
	var muted_anchor_badge_count := 0
	var school_line_anchor_count := 0
	var muted_school_line_badge_count := 0
	var school_line_letters: Array[String] = []
	for anchor_node in anchor_layer.get_children():
		if not anchor_node is Node:
			continue
		var letter := str((anchor_node as Node).get_meta("letter", ""))
		var is_school_line := ["G", "K", "N", "R", "Y"].has(letter)
		if is_school_line:
			school_line_anchor_count += 1
			school_line_letters.append(letter)
		var badge := (anchor_node as Node).find_child("LetterBadge", true, false) as CanvasItem
		if badge == null:
			continue
		anchor_badge_count += 1
		if float(badge.modulate.a) <= 0.72:
			muted_anchor_badge_count += 1
			if is_school_line:
				muted_school_line_badge_count += 1
	var school_detail_names: Array[String] = []
	var plaza_stay_point_names: Array[String] = []
	var school_gate_detail_count := 0
	var school_yard_detail_count := 0
	for detail_node in plaza_life_layer.get_children():
		if not detail_node is Node:
			continue
		if str((detail_node as Node).get_meta("actor_type", "")) == "plaza_life_detail":
			var role := str((detail_node as Node).get_meta("approval_role", ""))
			if ["rest_spot", "shop_wait_spot", "chat_spot", "snack_spot"].has(role):
				plaza_stay_point_names.append(str(detail_node.name))
		if str((detail_node as Node).get_meta("actor_type", "")) != "school_life_detail":
			continue
		school_detail_names.append(str(detail_node.name))
		match str((detail_node as Node).get_meta("place_id", "")):
			"place_school_gate":
				school_gate_detail_count += 1
			"place_school_yard":
				school_yard_detail_count += 1
	return {
		"place_count": place_layer.get_child_count(),
		"plaza_life_detail_count": plaza_life_layer.get_child_count(),
		"plaza_stay_point_count": plaza_stay_point_names.size(),
		"plaza_stay_point_names": plaza_stay_point_names,
		"outdoor_decor_count": outdoor_decor_layer.get_child_count(),
		"school_life_detail_count": school_detail_names.size(),
		"school_life_detail_names": school_detail_names,
		"school_gate_life_detail_count": school_gate_detail_count,
		"school_yard_life_detail_count": school_yard_detail_count,
		"hotspot_count": hotspot_layer.get_child_count(),
		"anchor_count": anchor_layer.get_child_count(),
		"resource_count": resource_layer.get_child_count(),
		"npc_count": npc_actor_layer.get_child_count(),
		"anchor_badge_count": anchor_badge_count,
		"muted_anchor_badge_count": muted_anchor_badge_count,
		"school_line_anchor_count": school_line_anchor_count,
		"school_line_letters": school_line_letters,
		"muted_school_line_badge_count": muted_school_line_badge_count,
		"collision_debug_visible": collision_debug_layer.visible,
	}


func _bind_runtime_layers() -> void:
	ground_layer = runtime_map_node.get_node("GroundLayer") as Node2D
	road_visual_layer = runtime_map_node.get_node("RoadVisualLayer") as Node2D
	place_layer = runtime_map_node.get_node("PlaceLayer") as Node2D
	plaza_life_layer = runtime_map_node.get_node("PlazaLifeLayer") as Node2D
	hotspot_layer = runtime_map_node.get_node("HotspotLayer") as Node2D
	collision_debug_layer = runtime_map_node.get_node("CollisionDebugLayer") as Node2D
	anchor_layer = runtime_map_node.get_node("AnchorLayer") as Node2D
	resource_layer = runtime_map_node.get_node("ResourceLayer") as Node2D
	npc_actor_layer = runtime_map_node.get_node("NPCActorLayer") as Node2D
	outdoor_decor_layer = runtime_map_node.get_node("OutdoorDecorLayer") as Node2D
	player_layer = runtime_map_node.get_node("PlayerLayer") as Node2D
	collision_debug_layer.visible = false


func _clear_runtime_layers() -> void:
	for layer in [
		ground_layer,
		road_visual_layer,
		place_layer,
		plaza_life_layer,
		hotspot_layer,
		collision_debug_layer,
		anchor_layer,
		resource_layer,
		npc_actor_layer,
		outdoor_decor_layer,
		player_layer,
	]:
		for child in layer.get_children():
			layer.remove_child(child)
			child.queue_free()


func update_camera_for_player(player_world_position: Vector2) -> void:
	if not is_instance_valid(runtime_map_node) or not is_instance_valid(runtime_map_frame):
		return
	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 40, "h": 24})
	var map_width := int(canvas_size.get("w", 40)) * map_cell_size
	var map_height := int(canvas_size.get("h", 24)) * map_cell_size
	var frame_size := runtime_map_frame.size
	if frame_size.x <= 1.0 or frame_size.y <= 1.0:
		frame_size = map_render_size
	var scaled_map_size := Vector2(map_width, map_height) * runtime_map_node.scale
	var desired := frame_size * 0.5 - player_world_position * runtime_map_node.scale
	desired.x = clampf(desired.x, min(0.0, frame_size.x - scaled_map_size.x), 0.0)
	desired.y = clampf(desired.y, min(0.0, frame_size.y - scaled_map_size.y), 0.0)
	runtime_map_node.position = desired


func screen_to_map_position(screen_position: Vector2) -> Vector2:
	if not is_instance_valid(runtime_map_node):
		return screen_position
	return (screen_position - runtime_map_node.position) / runtime_map_node.scale


func cell_position(cell: Dictionary) -> Vector2:
	return Vector2(
		int(cell.get("x", 0)) * map_cell_size,
		int(cell.get("y", 0)) * map_cell_size
	)


func cell_center(cell: Dictionary) -> Vector2:
	return cell_position(cell) + Vector2(map_cell_size, map_cell_size) * 0.5


func _on_map_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			var map_position := screen_to_map_position(mouse_event.position)
			map_cell_requested.emit(Vector2i(int(map_position.x / map_cell_size), int(map_position.y / map_cell_size)))


func _map_anchor_letters() -> Array[String]:
	var letters: Array[String] = []
	for anchor in world_map.get("memory_anchors", []):
		letters.append(anchor.get("letter", ""))
	return letters


func _create_place_object(place: Dictionary) -> Node2D:
	var object := InteractableObjectScene.instantiate() as Node2D
	object.call("configure_place", {
		"renderer": renderer,
		"place": place,
		"map_cell_size": map_cell_size,
	})
	return object


func _render_plaza_life_details() -> void:
	var details := [
		{"name": "PlazaBenchHome", "cell": {"x": 29, "y": 17}, "size": Vector2(map_cell_size * 1.6, map_cell_size * 0.55), "texture": "plaza_bench", "role": "rest_spot"},
		{"name": "PlazaBenchShop", "cell": {"x": 41, "y": 14}, "size": Vector2(map_cell_size * 1.5, map_cell_size * 0.55), "texture": "plaza_bench", "role": "shop_wait_spot"},
		{"name": "PlazaFlowerBasket", "cell": {"x": 37, "y": 20}, "size": Vector2(map_cell_size * 0.9, map_cell_size * 0.8), "texture": "plaza_flower_basket", "role": "resource_hint"},
		{"name": "PlazaNoticeBoard", "cell": {"x": 33, "y": 18}, "size": Vector2(map_cell_size * 1.0, map_cell_size * 1.15), "texture": "plaza_notice_board", "role": "place_hint"},
		{"name": "PlazaTinyLamp", "cell": {"x": 30, "y": 20}, "size": Vector2(map_cell_size * 0.75, map_cell_size * 1.0), "texture": "plaza_tiny_lamp", "role": "evening_life"},
		{"name": "PlazaChatStool", "cell": {"x": 32, "y": 22}, "size": Vector2(map_cell_size * 0.85, map_cell_size * 0.75), "texture": "plaza_stool", "role": "chat_spot"},
		{"name": "PlazaSnackCrate", "cell": {"x": 42, "y": 16}, "size": Vector2(map_cell_size * 0.95, map_cell_size * 0.75), "texture": "plaza_snack_crate", "role": "snack_spot"},
	]
	for detail in details:
		plaza_life_layer.add_child(_create_plaza_life_detail(detail))


func _render_school_life_details() -> void:
	var details := [
		{"name": "SchoolGateBellPot", "place_id": "place_school_gate", "cell": {"x": 20, "y": 12}, "size": Vector2(map_cell_size * 0.95, map_cell_size * 0.95), "texture": "plaza_tiny_lamp", "role": "quiet_arrival"},
		{"name": "SchoolGateWelcomeMat", "place_id": "place_school_gate", "cell": {"x": 22, "y": 12}, "size": Vector2(map_cell_size * 1.45, map_cell_size * 0.48), "texture": "road", "role": "soft_threshold"},
		{"name": "SchoolYardSoftNetCorner", "place_id": "place_school_yard", "cell": {"x": 14, "y": 14}, "size": Vector2(map_cell_size * 1.25, map_cell_size * 1.1), "texture": "anchor_n_soft_net", "role": "play_prop"},
		{"name": "SchoolYardKiteRibbon", "place_id": "place_school_yard", "cell": {"x": 16, "y": 9}, "size": Vector2(map_cell_size * 1.15, map_cell_size * 1.15), "texture": "anchor_k_kite", "role": "sky_play"},
		{"name": "SchoolYardRobotSign", "place_id": "place_school_yard", "cell": {"x": 20, "y": 13}, "size": Vector2(map_cell_size * 1.0, map_cell_size * 1.05), "texture": "anchor_r_robot_sign", "role": "gentle_wayfinding"},
		{"name": "SchoolYardYoYoBasket", "place_id": "place_school_yard", "cell": {"x": 18, "y": 16}, "size": Vector2(map_cell_size * 0.95, map_cell_size * 0.95), "texture": "anchor_y_yo_yo_corner", "role": "toy_storage"},
	]
	for detail in details:
		plaza_life_layer.add_child(_create_school_life_detail(detail))


func _create_plaza_life_detail(detail: Dictionary) -> Node2D:
	var marker := Node2D.new()
	var detail_size: Vector2 = detail.get("size", Vector2(map_cell_size, map_cell_size))
	marker.name = str(detail.get("name", "PlazaLifeDetail"))
	marker.position = cell_center(detail.get("cell", {}))
	marker.set_meta("actor_type", "plaza_life_detail")
	marker.set_meta("approval_role", str(detail.get("role", "")))
	marker.add_child(_call_renderer("_create_sprite", ["SoftShadow", Vector2(0, 8), Vector2(detail_size.x * 0.9, 7), "shadow"]) as Node)
	marker.add_child(_call_renderer("_create_sprite", ["DetailSprite", Vector2.ZERO, detail_size, str(detail.get("texture", "plaza_detail"))]) as Node)
	return marker


func _create_school_life_detail(detail: Dictionary) -> Node2D:
	var marker := Node2D.new()
	var detail_size: Vector2 = detail.get("size", Vector2(map_cell_size, map_cell_size))
	marker.name = str(detail.get("name", "SchoolLifeDetail"))
	marker.position = cell_center(detail.get("cell", {}))
	marker.set_meta("actor_type", "school_life_detail")
	marker.set_meta("place_id", str(detail.get("place_id", "")))
	marker.set_meta("approval_role", str(detail.get("role", "")))
	marker.add_child(_call_renderer("_create_sprite", ["SchoolDetailShadow", Vector2(0, 8), Vector2(detail_size.x * 0.85, 7), "shadow"]) as Node)
	marker.add_child(_call_renderer("_create_sprite", ["SchoolDetailSprite", Vector2.ZERO, detail_size, str(detail.get("texture", "plaza_detail"))]) as Node)
	return marker


func _create_hotspot_object(interaction: Dictionary) -> Node2D:
	var object := InteractableObjectScene.instantiate() as Node2D
	object.call("configure_hotspot", {
		"renderer": renderer,
		"interaction": interaction,
		"map_cell_size": map_cell_size,
	})
	return object


func _create_anchor_object(anchor: Dictionary, reserved: bool) -> Node2D:
	var object := AnchorObjectScene.instantiate() as Node2D
	object.call("configure", {
		"renderer": renderer,
		"anchor": anchor,
		"reserved": reserved,
		"map_cell_size": map_cell_size,
	})
	return object


func _create_resource_object(point: Dictionary) -> Node2D:
	var object := ResourceObjectScene.instantiate() as Node2D
	object.call("configure", {
		"renderer": renderer,
		"point": point,
		"map_cell_size": map_cell_size,
	})
	return object


func _create_npc_actor(npc: Dictionary) -> Node2D:
	var actor := NPCActorScene.instantiate() as Node2D
	actor.call("configure", {
		"renderer": renderer,
		"npc": npc,
		"map_cell_size": map_cell_size,
	})
	return actor


func _create_player_actor() -> Node2D:
	var actor := PlayerActorScene.instantiate() as Node2D
	actor.call("configure", {
		"renderer": renderer,
	})
	return actor


func _create_outdoor_decor(item: Dictionary) -> Node2D:
	var marker := Node2D.new()
	var item_id := str(item.get("item_id", "outdoor_item"))
	marker.name = "outdoor_%s" % str(item.get("instance_id", item_id))
	marker.position = cell_center(item.get("cell", {}))
	marker.set_meta("actor_type", "outdoor_decor")
	marker.set_meta("item_id", item_id)
	marker.add_child(_call_renderer("_create_sprite", ["OutdoorShadow", Vector2(0, 12), Vector2(map_cell_size * 1.3, 8), "shadow"]) as Node)
	marker.add_child(_call_renderer("_create_sprite", ["OutdoorSprite", Vector2.ZERO, Vector2(map_cell_size * 1.35, map_cell_size * 1.2), "home_item_%s" % item_id]) as Node)
	return marker


func _call_renderer(method_name: String, args: Array) -> Variant:
	if renderer == null:
		push_error("TownStage renderer is missing: %s" % method_name)
		return null
	return renderer.callv(method_name, args)
