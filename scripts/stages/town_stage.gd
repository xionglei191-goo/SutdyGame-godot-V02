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
var story_props: Array = []
var first_npcs: Array = []
var outdoor_items: Array = []
var map_cell_size := 16
var map_render_size := Vector2(1280, 720)
var local_camera_scale := Vector2(2.05, 2.05)
var visual_rebuild_camera_scale := Vector2(1.55, 1.55)
var visual_rebuild_focus_cell := Vector2(31.0, 20.0)

var runtime_map_frame: Control
var runtime_map_input: Control
var runtime_map_node: Node2D
var player_marker: Node2D
var ground_layer: Node2D
var road_visual_layer: Node2D
var visual_rebuild_blockout_layer: Node2D
var place_layer: Node2D
var plaza_life_layer: Node2D
var hotspot_layer: Node2D
var story_prop_layer: Node2D
var collision_debug_layer: Node2D
var anchor_layer: Node2D
var resource_layer: Node2D
var npc_actor_layer: Node2D
var outdoor_decor_layer: Node2D
var player_layer: Node2D
var feedback_layer: Node2D
var desired_camera_position := Vector2.ZERO
var camera_smoothing := 0.32
var camera_initialized := false
var tap_feedback_count := 0


func setup(config: Dictionary) -> Dictionary:
	renderer = config.get("renderer")
	world_map = config.get("world_map", {})
	az_core_data = config.get("az_core_data", {})
	resource_points = config.get("resource_points", [])
	story_props = config.get("story_props", [])
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
	_ensure_feedback_layer()

	_render_modular_ground(map_width, map_height)
	_render_region_chunks()
	_call_renderer("_add_town_scenery", [ground_layer, map_width, map_height])

	for road in world_map.get("roads", []):
		for cell in road.get("cells", []):
			var road_cell := _call_renderer("_create_sprite", ["RoadCell", cell_center(cell), Vector2(map_cell_size + 6, map_cell_size + 4), "road"]) as CanvasItem
			road_cell.modulate = Color(1, 1, 1, 0.52)
			road_cell.z_index = -1
			road_visual_layer.add_child(road_cell)

	_render_visual_rebuild_blockout()

	for place in world_map.get("places", []):
		place_layer.add_child(_create_place_object(place))

	_render_plaza_life_details()
	_render_school_life_details()
	_render_visual_recovery_world_props()

	for interaction in world_map.get("interaction_cells", []):
		hotspot_layer.add_child(_create_hotspot_object(interaction))

	for story_prop in story_props:
		if story_prop is Dictionary and bool((story_prop as Dictionary).get("visible_in_child_runtime", false)):
			story_prop_layer.add_child(_create_story_prop_object(story_prop))

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
	_apply_visual_rebuild_first_screen_gate()

	player_marker = _create_player_actor()
	player_layer.add_child(player_marker)
	_apply_visual_rebuild_camera()

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


func set_player_motion_state(facing: Vector2i, is_walking: bool) -> void:
	if is_instance_valid(player_marker) and player_marker.has_method("set_motion_state"):
		player_marker.call("set_motion_state", facing, is_walking)


func get_runtime_motion_snapshot() -> Dictionary:
	var player_snapshot: Dictionary = {}
	if is_instance_valid(player_marker) and player_marker.has_method("get_motion_snapshot"):
		player_snapshot = player_marker.call("get_motion_snapshot")
	return {
		"camera_position": runtime_map_node.position if is_instance_valid(runtime_map_node) else Vector2.ZERO,
		"desired_camera_position": desired_camera_position,
		"camera_smoothing": camera_smoothing,
		"tap_feedback_count": tap_feedback_count,
		"feedback_layer_count": feedback_layer.get_child_count() if is_instance_valid(feedback_layer) else 0,
		"player": player_snapshot,
	}


func show_tap_feedback_at_cell(cell: Vector2i) -> void:
	if not is_instance_valid(feedback_layer):
		return
	var sprite := _call_renderer("_create_sprite", [
		"TapRippleFeedback",
		cell_center({"x": cell.x, "y": cell.y}),
		Vector2(map_cell_size * 2.6, map_cell_size * 1.55),
		"ui_feedback_tap_ripple",
	]) as Sprite2D
	sprite.modulate = Color(1, 1, 1, 0.78)
	sprite.z_index = 14
	feedback_layer.add_child(sprite)
	tap_feedback_count += 1


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
		"story_prop_count": story_prop_layer.get_child_count(),
		"story_prop_names": _story_prop_names(),
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


func get_visual_rebuild_blockout_snapshot() -> Dictionary:
	return {
		"layer_exists": is_instance_valid(visual_rebuild_blockout_layer),
		"blockout_tile_path_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_path_tile"),
		"blockout_grass_base_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_grass_base"),
		"blockout_open_space_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_open_space"),
		"blockout_house_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_small_house"),
		"blockout_house_detail_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_house_detail"),
		"blockout_tree_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_tree"),
		"blockout_flower_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_flower"),
		"blockout_fence_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_fence"),
		"blockout_garden_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_garden"),
		"blockout_water_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_water_edge"),
		"blockout_detail_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_ground_detail"),
		"blockout_companion_detail_count": _count_visual_role(visual_rebuild_blockout_layer, "blockout_companion_detail"),
		"blockout_avatar_scale_cell": Vector2(0.72, 1.08),
		"blockout_house_scale_cell": Vector2(3.2, 2.55),
		"has_walkable_center": visual_rebuild_blockout_layer.find_child("BlockoutCenterWalkableGrass", true, false) != null if is_instance_valid(visual_rebuild_blockout_layer) else false,
		"bottom_dock_button_target_count": 5,
		"legacy_visual_layers_hidden": _legacy_visual_layers_hidden(),
		"assetized_texture_count": _count_texture_key_prefix(visual_rebuild_blockout_layer, "v0239_"),
		"resolver_mapped_v0239_count": _count_resolver_mapped_v0239_nodes(visual_rebuild_blockout_layer),
		"camera_scale": runtime_map_node.scale if is_instance_valid(runtime_map_node) else Vector2.ZERO,
		"camera_position": runtime_map_node.position if is_instance_valid(runtime_map_node) else Vector2.ZERO,
		"visual_focus_cell": visual_rebuild_focus_cell,
		"player_layer_above_blockout": player_layer.z_index > visual_rebuild_blockout_layer.z_index if is_instance_valid(player_layer) and is_instance_valid(visual_rebuild_blockout_layer) else false,
	}


func get_visual_recovery_snapshot() -> Dictionary:
	var prefab_logical_ids := _collect_visible_logical_asset_ids(place_layer, "building_prefab_assets")
	var terrain_ids := _collect_visible_logical_asset_ids(ground_layer, "terrain_tile_assets")
	var region_ids := _collect_visible_logical_asset_ids(ground_layer, "region_chunk_assets")
	var world_prop_ids := _collect_visible_logical_asset_ids(plaza_life_layer, "world_prop_assets")
	var anchor_badge_max_alpha := 0.0
	for anchor_node in anchor_layer.get_children():
		if not anchor_node is Node:
			continue
		var badge := (anchor_node as Node).find_child("LetterBadge", true, false) as CanvasItem
		if badge != null:
			anchor_badge_max_alpha = max(anchor_badge_max_alpha, float(badge.modulate.a))
	return {
		"terrain_tile_count": _count_visual_role(ground_layer, "terrain_tile"),
		"region_chunk_count": _count_visual_role(ground_layer, "region_chunk"),
		"world_prop_count": _count_visual_role(plaza_life_layer, "visual_recovery_world_prop"),
		"building_prefab_count": prefab_logical_ids.size(),
		"terrain_logical_ids": terrain_ids,
		"region_logical_ids": region_ids,
		"building_prefab_logical_ids": prefab_logical_ids,
		"world_prop_logical_ids": world_prop_ids,
			"uses_full_map_background": _has_visible_logical_asset(runtime_map_node, "place.world_map.base_1280"),
			"has_legacy_ground_sprite": runtime_map_node.find_child("Ground", true, false) != null,
			"fallback_place_count": _count_place_markers("context_fallback"),
			"non_prefab_place_max_alpha": _max_non_prefab_place_marker_alpha(),
			"road_visual_count": road_visual_layer.get_child_count(),
			"road_visual_alpha": _first_canvas_alpha(road_visual_layer),
			"anchor_badge_max_alpha": anchor_badge_max_alpha,
			"collision_debug_visible": collision_debug_layer.visible,
	}


func _bind_runtime_layers() -> void:
	ground_layer = runtime_map_node.get_node("GroundLayer") as Node2D
	road_visual_layer = runtime_map_node.get_node("RoadVisualLayer") as Node2D
	visual_rebuild_blockout_layer = runtime_map_node.get_node_or_null("VisualRebuildBlockoutLayer") as Node2D
	if visual_rebuild_blockout_layer == null:
		visual_rebuild_blockout_layer = Node2D.new()
		visual_rebuild_blockout_layer.name = "VisualRebuildBlockoutLayer"
		runtime_map_node.add_child(visual_rebuild_blockout_layer)
	visual_rebuild_blockout_layer.z_index = 1
	place_layer = runtime_map_node.get_node("PlaceLayer") as Node2D
	plaza_life_layer = runtime_map_node.get_node("PlazaLifeLayer") as Node2D
	hotspot_layer = runtime_map_node.get_node("HotspotLayer") as Node2D
	story_prop_layer = runtime_map_node.get_node("StoryPropLayer") as Node2D
	collision_debug_layer = runtime_map_node.get_node("CollisionDebugLayer") as Node2D
	anchor_layer = runtime_map_node.get_node("AnchorLayer") as Node2D
	resource_layer = runtime_map_node.get_node("ResourceLayer") as Node2D
	npc_actor_layer = runtime_map_node.get_node("NPCActorLayer") as Node2D
	outdoor_decor_layer = runtime_map_node.get_node("OutdoorDecorLayer") as Node2D
	player_layer = runtime_map_node.get_node("PlayerLayer") as Node2D
	player_layer.z_index = 8
	collision_debug_layer.visible = false


func _clear_runtime_layers() -> void:
	for layer in [
		ground_layer,
		road_visual_layer,
		visual_rebuild_blockout_layer,
		place_layer,
		plaza_life_layer,
		hotspot_layer,
		story_prop_layer,
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
	_apply_visual_rebuild_camera()


func _apply_visual_rebuild_camera() -> void:
	if not is_instance_valid(runtime_map_node) or not is_instance_valid(runtime_map_frame):
		return
	var frame_size := runtime_map_frame.size
	if frame_size.x <= 1.0 or frame_size.y <= 1.0:
		frame_size = map_render_size
	runtime_map_node.scale = visual_rebuild_camera_scale
	var focus_world := visual_rebuild_focus_cell * float(map_cell_size)
	runtime_map_node.position = frame_size * 0.5 - focus_world * visual_rebuild_camera_scale
	desired_camera_position = runtime_map_node.position
	camera_initialized = true


func _update_camera_for_player_scrolling(player_world_position: Vector2) -> void:
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
	desired_camera_position = desired
	if not camera_initialized:
		runtime_map_node.position = desired
		camera_initialized = true
		return
	runtime_map_node.position = runtime_map_node.position.lerp(desired, camera_smoothing)


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


func _ensure_feedback_layer() -> void:
	if is_instance_valid(feedback_layer):
		return
	feedback_layer = Node2D.new()
	feedback_layer.name = "FeedbackLayer"
	runtime_map_node.add_child(feedback_layer)


func _map_anchor_letters() -> Array[String]:
	var letters: Array[String] = []
	for anchor in world_map.get("memory_anchors", []):
		letters.append(anchor.get("letter", ""))
	return letters


func _render_modular_ground(map_width: int, map_height: int) -> void:
	var tile_size := map_cell_size * 4
	var columns := int(ceil(float(map_width) / float(tile_size)))
	var rows := int(ceil(float(map_height) / float(tile_size)))
	for y in range(rows):
		for x in range(columns):
			var texture_key := _terrain_texture_key_for_tile(Vector2i(x * 4, y * 4))
			var tile := _call_renderer("_create_sprite", [
				"TerrainTile_%02d_%02d" % [x, y],
				Vector2(x * tile_size + tile_size * 0.5, y * tile_size + tile_size * 0.5),
				Vector2(tile_size + 2, tile_size + 2),
				texture_key,
			]) as CanvasItem
			tile.z_index = -7
			tile.set_meta("visual_role", "terrain_tile")
			ground_layer.add_child(tile)


func _terrain_texture_key_for_tile(tile_cell: Vector2i) -> String:
	if tile_cell.x >= 12 and tile_cell.x <= 24 and tile_cell.y >= 17 and tile_cell.y <= 24:
		return "terrain_plaza_tile"
	if tile_cell.x >= 42 and tile_cell.x <= 56 and tile_cell.y >= 8 and tile_cell.y <= 17:
		return "terrain_path_tile"
	if tile_cell.x >= 14 and tile_cell.x <= 28 and tile_cell.y >= 8 and tile_cell.y <= 18:
		return "terrain_path_tile"
	if tile_cell.y >= 13 and tile_cell.y <= 22 and tile_cell.x >= 22 and tile_cell.x <= 42:
		return "terrain_path_tile"
	return "terrain_grass_tile"


func _render_region_chunks() -> void:
	var chunks := [
		{"name": "RegionTownPlazaChunk", "cell": Vector2(16.2, 20.0), "size": Vector2(map_cell_size * 12.2, map_cell_size * 6.2), "texture": "region_town_plaza_chunk"},
		{"name": "RegionHomeEdgeChunk", "cell": Vector2(31.0, 18.9), "size": Vector2(map_cell_size * 10.8, map_cell_size * 7.0), "texture": "region_home_edge_chunk"},
		{"name": "RegionShopStreetChunk", "cell": Vector2(48.0, 11.8), "size": Vector2(map_cell_size * 12.8, map_cell_size * 7.2), "texture": "region_shop_street_chunk"},
		{"name": "RegionSchoolLineChunk", "cell": Vector2(19.7, 12.8), "size": Vector2(map_cell_size * 13.2, map_cell_size * 8.0), "texture": "region_school_line_chunk"},
	]
	for chunk in chunks:
		var chunk_cell: Vector2 = chunk.get("cell", Vector2.ZERO)
		var sprite := _call_renderer("_create_sprite", [
			str(chunk.get("name", "RegionChunk")),
			chunk_cell * map_cell_size,
			chunk.get("size", Vector2(map_cell_size * 8, map_cell_size * 6)),
			str(chunk.get("texture", "region_town_plaza_chunk")),
		]) as CanvasItem
		sprite.z_index = -5
		sprite.set_meta("visual_role", "region_chunk")
		ground_layer.add_child(sprite)


func _render_visual_rebuild_blockout() -> void:
	for grass in _v0239_grass_base_specs():
		visual_rebuild_blockout_layer.add_child(_create_blockout_sprite(
			str(grass.get("name", "BlockoutGrassBase")),
			grass.get("cell", Vector2.ZERO),
			grass.get("size", Vector2.ONE),
			"v0239_grass_patch",
			"blockout_grass_base",
			-7,
			grass.get("modulate", Color("#e6f5d4f2"))
		))
	visual_rebuild_blockout_layer.add_child(_create_blockout_sprite(
		"BlockoutCenterWalkableGrass",
		Vector2(31.0, 20.8),
		Vector2(13.5, 7.2),
		"v0239_grass_patch",
		"blockout_open_space",
		-4,
		Color(1, 1, 1, 0.88)
	))
	visual_rebuild_blockout_layer.add_child(_create_blockout_sprite(
		"BlockoutHomeYardSoftTile",
		Vector2(29.5, 16.3),
		Vector2(8.2, 4.8),
		"v0239_grass_patch",
		"blockout_open_space",
		-4,
		Color("#f0f8d8ee")
	))
	var path_cells := _v0239_first_screen_path_cells()
	for index in range(path_cells.size()):
		var cell: Vector2 = path_cells[index]
		var path_tile := _create_blockout_sprite(
			"BlockoutPathTile_%02d" % index,
			Vector2(cell.x + 0.5, cell.y + 0.5),
			Vector2(1.52, 1.12),
			"v0239_path_tile",
			"blockout_path_tile",
			-2,
			Color(1, 1, 1, 0.98)
		)
		(path_tile.get_child(0) as CanvasItem).rotation = 0.12 if index % 2 == 0 else -0.09
		visual_rebuild_blockout_layer.add_child(path_tile)
	visual_rebuild_blockout_layer.add_child(_create_blockout_house())
	for tree_cell in [Vector2(24.1, 22.1), Vector2(28.3, 15.7), Vector2(36.3, 16.3), Vector2(38.4, 23.2)]:
		visual_rebuild_blockout_layer.add_child(_create_blockout_tree(tree_cell))
	for flower_cell in [Vector2(25.5, 20.8), Vector2(27.0, 18.4), Vector2(34.8, 18.0), Vector2(36.7, 21.0)]:
		visual_rebuild_blockout_layer.add_child(_create_blockout_sprite("BlockoutFlowerPatch", flower_cell, Vector2(1.15, 0.8), "v0239_flower_patch", "blockout_flower", 5, Color(1, 1, 1, 0.96)))
	for fence in [
		{"name": "BlockoutFenceHome", "cell": Vector2(32.4, 15.2), "size": Vector2(2.8, 0.42)},
		{"name": "BlockoutFenceGardenTop", "cell": Vector2(36.2, 18.0), "size": Vector2(2.35, 0.42)},
		{"name": "BlockoutFenceRight", "cell": Vector2(38.2, 19.8), "size": Vector2(2.6, 0.42)},
	]:
		visual_rebuild_blockout_layer.add_child(_create_blockout_sprite(str(fence.get("name")), fence.get("cell", Vector2.ZERO), fence.get("size", Vector2.ONE), "v0239_fence", "blockout_fence", 5, Color(1, 1, 1, 0.96)))
	visual_rebuild_blockout_layer.add_child(_create_blockout_mailbox())
	for garden in [
		{"name": "BlockoutHomeGardenBed", "cell": Vector2(27.5, 16.8), "size": Vector2(1.55, 0.86)},
		{"name": "BlockoutVegetablePatchA", "cell": Vector2(36.2, 18.8), "size": Vector2(1.35, 0.86)},
		{"name": "BlockoutVegetablePatchB", "cell": Vector2(37.35, 18.8), "size": Vector2(1.35, 0.86)},
	]:
		visual_rebuild_blockout_layer.add_child(_create_blockout_sprite(str(garden.get("name")), garden.get("cell", Vector2.ZERO), garden.get("size", Vector2.ONE), "v0239_garden_bed", "blockout_garden", 5, Color(1, 1, 1, 0.94)))
	for water in [
		{"name": "BlockoutPondCornerA", "cell": Vector2(39.2, 20.8), "size": Vector2(2.4, 1.5)},
		{"name": "BlockoutPondCornerB", "cell": Vector2(40.0, 21.9), "size": Vector2(2.8, 1.6)},
		{"name": "BlockoutPondCornerC", "cell": Vector2(38.9, 22.8), "size": Vector2(2.0, 1.15)},
	]:
		visual_rebuild_blockout_layer.add_child(_create_blockout_sprite(str(water.get("name")), water.get("cell", Vector2.ZERO), water.get("size", Vector2.ONE), "v0239_pond_edge", "blockout_water_edge", 3, Color(1, 1, 1, 0.86)))
	_render_v0239_first_screen_details()


func _v0239_grass_base_specs() -> Array[Dictionary]:
	return [
		{"name": "BlockoutGrassBaseHome", "cell": Vector2(28.4, 16.2), "size": Vector2(10.5, 5.2), "modulate": Color("#e8f6d5f4")},
		{"name": "BlockoutGrassBaseCenter", "cell": Vector2(31.7, 20.7), "size": Vector2(12.5, 6.2), "modulate": Color("#e2f3cff0")},
		{"name": "BlockoutGrassBaseLeft", "cell": Vector2(24.3, 22.2), "size": Vector2(6.0, 5.3), "modulate": Color("#dff0c8ee")},
		{"name": "BlockoutGrassBaseRight", "cell": Vector2(38.0, 19.2), "size": Vector2(7.6, 6.0), "modulate": Color("#e7f6d3f2")},
		{"name": "BlockoutGrassBaseWaterBank", "cell": Vector2(38.7, 23.0), "size": Vector2(5.8, 3.1), "modulate": Color("#d8edc4ea")},
		{"name": "BlockoutGrassBaseTopPath", "cell": Vector2(33.7, 15.2), "size": Vector2(6.0, 4.0), "modulate": Color("#e9f7d6f2")},
	]


func _v0239_first_screen_path_cells() -> Array[Vector2]:
	return [
		Vector2(23.0, 25.0), Vector2(24.0, 24.0), Vector2(25.0, 23.0), Vector2(26.0, 22.0),
		Vector2(27.0, 21.0), Vector2(28.0, 20.0), Vector2(29.0, 19.0), Vector2(30.0, 19.0),
		Vector2(31.0, 19.0), Vector2(32.0, 19.0), Vector2(33.0, 19.0), Vector2(34.0, 20.0),
		Vector2(35.0, 21.0), Vector2(30.0, 18.0), Vector2(30.0, 17.0), Vector2(30.0, 16.0),
		Vector2(31.0, 15.0), Vector2(32.0, 14.0), Vector2(33.0, 13.0), Vector2(34.0, 12.0),
		Vector2(34.8, 11.0), Vector2(31.0, 20.0), Vector2(31.0, 21.0), Vector2(31.0, 22.0),
		Vector2(31.0, 23.0), Vector2(32.0, 20.0), Vector2(33.0, 20.0), Vector2(34.0, 20.0),
		Vector2(35.0, 20.0), Vector2(36.0, 20.0), Vector2(37.0, 20.0), Vector2(38.0, 20.5),
	]


func _render_v0239_first_screen_details() -> void:
	for index in range(_v0239_ground_detail_specs().size()):
		var detail: Dictionary = _v0239_ground_detail_specs()[index]
		var marker := _create_blockout_sprite(
			str(detail.get("name", "BlockoutGroundDetail_%02d" % index)),
			detail.get("cell", Vector2.ZERO),
			detail.get("size", Vector2.ONE),
			str(detail.get("texture", "v0239_grass_tuft")),
			"blockout_ground_detail",
			int(detail.get("z", 4)),
			detail.get("modulate", Color(1, 1, 1, 0.92))
		)
		var child := marker.get_child(0) as CanvasItem
		child.rotation = float(detail.get("rotation", 0.0))
		visual_rebuild_blockout_layer.add_child(marker)


func _v0239_ground_detail_specs() -> Array[Dictionary]:
	return [
		{"name": "BlockoutGrassTuftLeftA", "cell": Vector2(24.6, 19.0), "size": Vector2(0.42, 0.32), "texture": "v0239_grass_tuft", "rotation": -0.18},
		{"name": "BlockoutGrassTuftLeftB", "cell": Vector2(26.2, 22.4), "size": Vector2(0.46, 0.34), "texture": "v0239_grass_tuft", "rotation": 0.12},
		{"name": "BlockoutGrassTuftHomeA", "cell": Vector2(28.2, 17.9), "size": Vector2(0.38, 0.3), "texture": "v0239_grass_tuft", "rotation": 0.08},
		{"name": "BlockoutGrassTuftHomeB", "cell": Vector2(33.6, 16.4), "size": Vector2(0.44, 0.32), "texture": "v0239_grass_tuft", "rotation": -0.1},
		{"name": "BlockoutGrassTuftCenterA", "cell": Vector2(30.1, 21.7), "size": Vector2(0.38, 0.3), "texture": "v0239_grass_tuft", "rotation": 0.18},
		{"name": "BlockoutGrassTuftCenterB", "cell": Vector2(34.4, 21.9), "size": Vector2(0.46, 0.34), "texture": "v0239_grass_tuft", "rotation": -0.16},
		{"name": "BlockoutPebblePathA", "cell": Vector2(29.8, 19.8), "size": Vector2(0.34, 0.2), "texture": "v0239_path_pebble", "z": 0},
		{"name": "BlockoutPebblePathB", "cell": Vector2(32.8, 19.6), "size": Vector2(0.36, 0.22), "texture": "v0239_path_pebble", "z": 0, "rotation": 0.2},
		{"name": "BlockoutPebblePathC", "cell": Vector2(35.8, 20.4), "size": Vector2(0.32, 0.2), "texture": "v0239_path_pebble", "z": 0, "rotation": -0.1},
		{"name": "BlockoutPondRockA", "cell": Vector2(38.1, 20.5), "size": Vector2(0.58, 0.38), "texture": "v0239_bank_stone", "z": 5},
		{"name": "BlockoutPondRockB", "cell": Vector2(39.8, 20.2), "size": Vector2(0.52, 0.36), "texture": "v0239_bank_stone", "z": 5, "rotation": 0.12},
		{"name": "BlockoutPondLilyA", "cell": Vector2(40.1, 21.5), "size": Vector2(0.5, 0.32), "texture": "v0239_lily_pad", "z": 6},
		{"name": "BlockoutPondLilyB", "cell": Vector2(39.2, 22.3), "size": Vector2(0.42, 0.28), "texture": "v0239_lily_pad", "z": 6, "rotation": -0.18},
		{"name": "BlockoutCropLeafA", "cell": Vector2(36.0, 18.45), "size": Vector2(0.38, 0.42), "texture": "v0239_crop_leaf", "z": 6},
		{"name": "BlockoutCropLeafB", "cell": Vector2(36.55, 18.95), "size": Vector2(0.36, 0.4), "texture": "v0239_crop_leaf", "z": 6, "rotation": 0.2},
		{"name": "BlockoutCropLeafC", "cell": Vector2(37.35, 18.5), "size": Vector2(0.38, 0.42), "texture": "v0239_crop_leaf", "z": 6, "rotation": -0.12},
	]


func _create_place_object(place: Dictionary) -> Node2D:
	var object := InteractableObjectScene.instantiate() as Node2D
	object.call("configure_place", {
		"renderer": renderer,
		"place": place,
		"map_cell_size": map_cell_size,
	})
	return object


func _create_blockout_house() -> Node2D:
	var house := Node2D.new()
	house.name = "BlockoutSmallHome"
	house.position = cell_center({"x": 29, "y": 15})
	house.set_meta("visual_role", "blockout_small_house")
	house.add_child(_call_renderer("_create_sprite", ["HouseSoftShadow", Vector2(4, map_cell_size * 1.18), Vector2(map_cell_size * 3.0, 9), "shadow"]) as Node)
	var body := _call_renderer("_create_sprite", ["HouseBody", Vector2(0, map_cell_size * 0.28), Vector2(map_cell_size * 3.2, map_cell_size * 1.8), "v0239_house_body"]) as CanvasItem
	body.modulate = Color(1, 1, 1, 0.96)
	house.add_child(body)
	var roof := _call_renderer("_create_sprite", ["HouseFlatRoof", Vector2(0, -map_cell_size * 0.72), Vector2(map_cell_size * 3.35, map_cell_size * 0.95), "v0239_house_roof"]) as CanvasItem
	roof.modulate = Color(1, 1, 1, 0.96)
	house.add_child(roof)
	house.add_child(_create_house_detail("HouseChimney", Vector2(map_cell_size * 1.08, -map_cell_size * 1.17), Vector2(map_cell_size * 0.42, map_cell_size * 0.64), "v0239_house_chimney", 1))
	house.add_child(_create_house_detail("HouseRoundWindow", Vector2(0, -map_cell_size * 0.88), Vector2(map_cell_size * 0.5, map_cell_size * 0.44), "v0239_house_round_window", 2))
	house.add_child(_create_house_detail("HouseLeftWindow", Vector2(-map_cell_size * 0.92, map_cell_size * 0.22), Vector2(map_cell_size * 0.62, map_cell_size * 0.62), "v0239_house_window", 3))
	house.add_child(_create_house_detail("HouseRightLantern", Vector2(map_cell_size * 0.95, map_cell_size * 0.2), Vector2(map_cell_size * 0.3, map_cell_size * 0.46), "v0239_house_lantern", 4))
	house.add_child(_create_house_detail("HouseFlowerBox", Vector2(-map_cell_size * 0.92, map_cell_size * 0.58), Vector2(map_cell_size * 0.78, map_cell_size * 0.28), "v0239_flower_box", 5))
	var door := _call_renderer("_create_sprite", ["HouseDoor", Vector2(0, map_cell_size * 0.72), Vector2(map_cell_size * 0.55, map_cell_size * 0.92), "v0239_house_door"]) as CanvasItem
	door.modulate = Color(1, 1, 1, 0.96)
	house.add_child(door)
	house.add_child(_create_house_detail("HouseFrontSteps", Vector2(0, map_cell_size * 1.29), Vector2(map_cell_size * 1.22, map_cell_size * 0.42), "v0239_house_steps", 0))
	return house


func _create_house_detail(detail_name: String, offset: Vector2, size: Vector2, texture_key: String, z: int) -> Node2D:
	var detail := Node2D.new()
	detail.name = detail_name
	detail.position = offset
	detail.z_index = z
	detail.set_meta("visual_role", "blockout_house_detail")
	var sprite := _call_renderer("_create_sprite", ["DetailSprite", Vector2.ZERO, size, texture_key]) as CanvasItem
	sprite.modulate = Color(1, 1, 1, 0.96)
	detail.add_child(sprite)
	return detail


func _create_blockout_mailbox() -> Node2D:
	var mailbox := _create_blockout_sprite("BlockoutMailbox", Vector2(32.2, 17.2), Vector2(0.78, 1.02), "v0239_mailbox", "blockout_ground_detail", 6, Color(1, 1, 1, 0.96))
	return mailbox


func _create_blockout_tree(cell: Vector2) -> Node2D:
	var tree := Node2D.new()
	tree.name = "BlockoutRoundTree"
	tree.position = cell * map_cell_size
	tree.set_meta("visual_role", "blockout_tree")
	tree.add_child(_call_renderer("_create_sprite", ["TreeShadow", Vector2(0, 17), Vector2(map_cell_size * 1.4, 8), "shadow"]) as Node)
	tree.add_child(_call_renderer("_create_sprite", ["TreeTrunk", Vector2(0, 13), Vector2(8, 18), "v0239_tree_trunk"]) as Node)
	tree.add_child(_call_renderer("_create_sprite", ["TreeCrown", Vector2(0, -3), Vector2(map_cell_size * 1.62, map_cell_size * 1.46), "v0239_tree_crown"]) as Node)
	return tree


func _create_blockout_sprite(sprite_name: String, center_cell: Vector2, size_cells: Vector2, texture_key: String, visual_role: String, z: int, modulate_color: Color) -> Node2D:
	var marker := Node2D.new()
	marker.name = sprite_name
	marker.position = center_cell * map_cell_size
	marker.z_index = z
	marker.set_meta("visual_role", visual_role)
	var sprite := _call_renderer("_create_sprite", ["Sprite", Vector2.ZERO, size_cells * map_cell_size, texture_key]) as CanvasItem
	sprite.modulate = modulate_color
	marker.add_child(sprite)
	return marker


func _apply_visual_rebuild_first_screen_gate() -> void:
	for layer in [
		road_visual_layer,
		place_layer,
		plaza_life_layer,
		hotspot_layer,
		story_prop_layer,
		anchor_layer,
		resource_layer,
		npc_actor_layer,
		outdoor_decor_layer,
	]:
		if layer is CanvasItem:
			(layer as CanvasItem).visible = false
	var mapread_layer := ground_layer.find_child("MapReadabilityLayer", true, false) as CanvasItem
	if mapread_layer != null:
		mapread_layer.visible = false
	visual_rebuild_blockout_layer.add_child(_create_blockout_companion())


func _create_blockout_companion() -> Node2D:
	var companion := Node2D.new()
	companion.name = "BlockoutTinyCompanion"
	companion.position = Vector2(32.4, 20.2) * map_cell_size
	companion.set_meta("visual_role", "blockout_companion")
	companion.add_child(_call_renderer("_create_sprite", ["CompanionShadow", Vector2(0, 10), Vector2(18, 6), "shadow"]) as Node)
	companion.add_child(_create_companion_detail("CompanionTail", Vector2(10, -1), Vector2(9, 8), "v0239_companion_tail", 1))
	companion.add_child(_create_companion_detail("CompanionLeftEar", Vector2(-6, -8), Vector2(8, 8), "v0239_companion_ear", 3))
	companion.add_child(_create_companion_detail("CompanionRightEar", Vector2(5, -8), Vector2(8, 8), "v0239_companion_ear", 3))
	var body := _call_renderer("_create_sprite", ["CompanionBody", Vector2(0, 0), Vector2(20, 19), "v0239_companion"]) as CanvasItem
	body.modulate = Color(1, 1, 1, 0.95)
	companion.add_child(body)
	companion.add_child(_create_companion_detail("CompanionCollar", Vector2(0, 4), Vector2(15, 4), "v0239_companion_collar", 5))
	return companion


func _create_companion_detail(detail_name: String, offset: Vector2, size: Vector2, texture_key: String, z: int) -> Node2D:
	var detail := Node2D.new()
	detail.name = detail_name
	detail.position = offset
	detail.z_index = z
	detail.set_meta("visual_role", "blockout_companion_detail")
	var sprite := _call_renderer("_create_sprite", ["CompanionDetailSprite", Vector2.ZERO, size, texture_key]) as CanvasItem
	sprite.modulate = Color(1, 1, 1, 0.95)
	detail.add_child(sprite)
	return detail


func _legacy_visual_layers_hidden() -> bool:
	for layer in [
		road_visual_layer,
		place_layer,
		plaza_life_layer,
		hotspot_layer,
		story_prop_layer,
		anchor_layer,
		resource_layer,
		npc_actor_layer,
		outdoor_decor_layer,
	]:
		if layer is CanvasItem and (layer as CanvasItem).visible:
			return false
	var mapread_layer := ground_layer.find_child("MapReadabilityLayer", true, false) as CanvasItem
	return mapread_layer == null or not mapread_layer.visible


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


func _render_visual_recovery_world_props() -> void:
	var props := [
		{"name": "VisualRecoveryAppleBasket", "cell": {"x": 31, "y": 16}, "size": Vector2(map_cell_size * 2.0, map_cell_size * 1.7), "texture": "world_prop_apple_basket_anchor", "role": "prop_first_anchor"},
		{"name": "VisualRecoveryClockCorner", "cell": {"x": 33, "y": 17}, "size": Vector2(map_cell_size * 1.65, map_cell_size * 2.15), "texture": "world_prop_clock_corner_anchor", "role": "prop_first_anchor"},
		{"name": "VisualRecoverySunnyCorner", "cell": {"x": 29, "y": 20}, "size": Vector2(map_cell_size * 2.4, map_cell_size * 1.85), "texture": "world_prop_sunny_corner", "role": "home_life_prop"},
	]
	for prop in props:
		plaza_life_layer.add_child(_create_visual_recovery_prop(prop))


func _create_visual_recovery_prop(prop: Dictionary) -> Node2D:
	var marker := Node2D.new()
	var prop_size: Vector2 = prop.get("size", Vector2(map_cell_size, map_cell_size))
	marker.name = str(prop.get("name", "VisualRecoveryProp"))
	marker.position = cell_center(prop.get("cell", {}))
	marker.set_meta("actor_type", "visual_recovery_world_prop")
	marker.set_meta("visual_role", "visual_recovery_world_prop")
	marker.set_meta("approval_role", str(prop.get("role", "")))
	marker.add_child(_call_renderer("_create_sprite", ["VisualRecoveryPropShadow", Vector2(0, prop_size.y * 0.42), Vector2(prop_size.x * 0.82, 8), "shadow"]) as Node)
	marker.add_child(_call_renderer("_create_sprite", ["VisualRecoveryPropSprite", Vector2.ZERO, prop_size, str(prop.get("texture", "world_prop_apple_basket_anchor"))]) as Node)
	return marker


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


func _create_story_prop_object(story_prop: Dictionary) -> Node2D:
	var marker := Node2D.new()
	var prop_id := str(story_prop.get("story_prop_id", "story_prop"))
	var size_data: Dictionary = story_prop.get("size", {"w": 1, "h": 1})
	var prop_size := Vector2(
		max(1, int(size_data.get("w", 1))) * map_cell_size,
		max(1, int(size_data.get("h", 1))) * map_cell_size
	)
	marker.name = prop_id
	marker.position = cell_position(story_prop.get("cell", {})) + prop_size * 0.5
	marker.set_meta("actor_type", "story_prop")
	marker.set_meta("story_prop_id", prop_id)
	marker.set_meta("storyline_id", str(story_prop.get("storyline_id", "")))
	marker.set_meta("place_id", str(story_prop.get("place_id", "")))
	marker.set_meta("core_anchor_ids", story_prop.get("core_anchor_ids", []).duplicate(true))
	marker.add_child(_call_renderer("_create_sprite", ["StoryPropShadow", Vector2(0, prop_size.y * 0.42), Vector2(prop_size.x * 0.86, 7), "shadow"]) as Node)
	marker.add_child(_call_renderer("_create_sprite", ["StoryPropSprite", Vector2.ZERO, prop_size, _story_prop_texture_key(prop_id)]) as Node)
	return marker


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


func _story_prop_names() -> Array[String]:
	var names: Array[String] = []
	if not is_instance_valid(story_prop_layer):
		return names
	for child in story_prop_layer.get_children():
		names.append(str(child.name))
	return names


func _story_prop_texture_key(story_prop_id: String) -> String:
	return "story_prop_%s" % story_prop_id


func _count_visual_role(root_node: Node, visual_role: String) -> int:
	var count := 0
	if not is_instance_valid(root_node):
		return count
	for child in root_node.get_children():
		if child is Node:
			if str((child as Node).get_meta("visual_role", "")) == visual_role:
				count += 1
			count += _count_visual_role(child, visual_role)
	return count


func _count_texture_key_prefix(root_node: Node, texture_key_prefix: String) -> int:
	var count := 0
	if not is_instance_valid(root_node):
		return count
	for child in root_node.get_children():
		if child is CanvasItem and str((child as CanvasItem).get_meta("texture_key", "")).begins_with(texture_key_prefix):
			count += 1
		if child is Node:
			count += _count_texture_key_prefix(child as Node, texture_key_prefix)
	return count


func _count_resolver_mapped_v0239_nodes(root_node: Node) -> int:
	var count := 0
	if not is_instance_valid(root_node):
		return count
	for child in root_node.get_children():
		if child is CanvasItem:
			var logical_asset_id := str((child as CanvasItem).get_meta("logical_asset_id", ""))
			if logical_asset_id.begins_with("terrain.v0239.") or logical_asset_id.begins_with("building_part.v0239.") or logical_asset_id.begins_with("world_prop.v0239.") or logical_asset_id.begins_with("pet.v0239."):
				count += 1
		if child is Node:
			count += _count_resolver_mapped_v0239_nodes(child as Node)
	return count


func _collect_visible_logical_asset_ids(root_node: Node, category: String) -> Array[String]:
	var ids: Array[String] = []
	_collect_visible_logical_asset_ids_recursive(root_node, category, ids)
	return ids


func _collect_visible_logical_asset_ids_recursive(root_node: Node, category: String, ids: Array[String]) -> void:
	if not is_instance_valid(root_node):
		return
	for child in root_node.get_children():
		if child is CanvasItem:
			var canvas := child as CanvasItem
			var logical_asset_id := str(canvas.get_meta("logical_asset_id", ""))
			if canvas.visible and canvas.modulate.a > 0.01 and str(canvas.get_meta("asset_category", "")) == category and not ids.has(logical_asset_id):
				ids.append(logical_asset_id)
		if child is Node:
			_collect_visible_logical_asset_ids_recursive(child, category, ids)


func _has_visible_logical_asset(root_node: Node, logical_asset_id: String) -> bool:
	if not is_instance_valid(root_node):
		return false
	for child in root_node.get_children():
		if child is CanvasItem:
			var canvas := child as CanvasItem
			if canvas.visible and canvas.modulate.a > 0.01 and str(canvas.get_meta("logical_asset_id", "")) == logical_asset_id:
				return true
		if child is Node and _has_visible_logical_asset(child, logical_asset_id):
			return true
	return false


func _count_place_markers(marker_visual: String) -> int:
	var count := 0
	if not is_instance_valid(place_layer):
		return count
	for place_node in place_layer.get_children():
		if place_node is Node and str((place_node as Node).get_meta("place_marker_visual", "")) == marker_visual:
			count += 1
	return count


func _max_non_prefab_place_marker_alpha() -> float:
	var max_alpha := 0.0
	if not is_instance_valid(place_layer):
		return max_alpha
	for place_node in place_layer.get_children():
		if not place_node is Node:
			continue
		if str((place_node as Node).get_meta("place_marker_visual", "")) == "prefab":
			continue
		max_alpha = max(max_alpha, _max_visible_descendant_alpha(place_node as Node, true))
	return max_alpha


func _max_visible_descendant_alpha(root_node: Node, skip_shadow: bool) -> float:
	var max_alpha := 0.0
	if not is_instance_valid(root_node):
		return max_alpha
	for child in root_node.get_children():
		if child is CanvasItem:
			var canvas := child as CanvasItem
			if canvas.visible and (not skip_shadow or not str(canvas.name).to_lower().contains("shadow")):
				max_alpha = max(max_alpha, float(canvas.modulate.a))
		if child is Node:
			max_alpha = max(max_alpha, _max_visible_descendant_alpha(child as Node, skip_shadow))
	return max_alpha


func _first_canvas_alpha(root_node: Node) -> float:
	if not is_instance_valid(root_node):
		return 0.0
	for child in root_node.get_children():
		if child is CanvasItem:
			return float((child as CanvasItem).modulate.a)
	return 0.0


func _call_renderer(method_name: String, args: Array) -> Variant:
	if renderer == null:
		push_error("TownStage renderer is missing: %s" % method_name)
		return null
	return renderer.callv(method_name, args)
