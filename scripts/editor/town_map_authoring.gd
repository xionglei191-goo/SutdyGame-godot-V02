@tool
extends Control
class_name TownMapAuthoring

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const MapAuthoringMarkerScene := preload("res://scenes/map_editor/map_authoring_marker.tscn")
const MAP_CELL_SIZE := 15
const MAP_VIEW_ORIGIN := Vector2(252, 52)
const TOOL_SELECT := "select"
const TOOL_MOVE_PLACE := "move_place"
const TOOL_PAINT_ROAD := "paint_road"
const TOOL_PAINT_COLLISION := "paint_collision"
const TOOL_PAINT_INTERACTION := "paint_interaction"
const TOOL_PLACE_RESOURCE := "place_resource"
const TOOL_PLACE_NPC_ROUTINE := "place_npc_routine"
const TOOL_PLACE_STORY_PROP := "place_story_prop"
const TOOL_MOVE_ANCHOR := "move_anchor"
const LAYER_KEYS: Array[String] = ["road", "collision", "interaction", "place", "anchor", "resource", "npc", "story_prop"]
const LOCKED_ANCHOR_FIELDS: Array[String] = [
	"anchor_id",
	"letter",
	"core_word",
	"route_order",
	"place_id",
	"card_id",
	"audio_id",
]

var world_map: Dictionary = {}
var editor_state: Dictionary = {}
var resource_points_state: Dictionary = {"schema_version": 1, "resource_points": []}
var npc_routine_state: Dictionary = {"schema_version": 1, "routine_days": []}
var story_props_state: Dictionary = {"schema_version": 1, "story_props": []}
var current_tool_mode := TOOL_SELECT
var current_day_key := "local_day_001"
var selected_runtime_type := ""
var selected_stable_id := ""
var last_resource_validation_result: Dictionary = {"ok": false, "errors": ["not_validated"], "wrote_file": false}
var last_routine_validation_result: Dictionary = {"ok": false, "errors": ["not_validated"], "wrote_file": false}
var layer_toggles: Dictionary = {}

var ground_preview_layer: Control
var road_layer: Control
var collision_layer: Control
var interaction_layer: Control
var place_marker_layer: Control
var anchor_marker_layer: Control
var resource_marker_layer: Control
var npc_spawn_layer: Control
var story_prop_marker_layer: Control
var export_validation_panel: Control
var validate_export_button: Button
var validation_status_label: Label
var validation_errors_label: Label
var toolbar_panel: Control
var tool_mode_option: OptionButton
var inspector_panel: Control
var inspector_title_label: Label
var inspector_body_label: Label
var inspector_fields_grid: GridContainer
var inspector_apply_button: Button
var editor_status_label: Label
var resource_status_label: Label
var routine_status_label: Label
var inspector_field_inputs: Dictionary = {}
var last_validation_result: Dictionary = {
	"ok": false,
	"errors": ["not_validated"],
	"wrote_file": false,
}


func _ready() -> void:
	build_from_world_map()


func build_from_world_map(path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH) -> Dictionary:
	_bind_layers()
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map(path)
	world_map = result.get("data", {})
	editor_state = world_map.duplicate(true)
	_load_resource_points()
	_load_npc_routines()
	_load_story_props()
	_rebuild_layers()
	_refresh_validation_panel(false, ["not_validated"])
	_refresh_side_status()
	return {
		"ok": result.get("ok", false),
		"errors": result.get("errors", []),
		"place_marker_count": place_marker_layer.get_child_count(),
		"anchor_marker_count": anchor_marker_layer.get_child_count(),
		"resource_marker_count": resource_marker_layer.get_child_count(),
		"npc_marker_count": npc_spawn_layer.get_child_count(),
		"story_prop_marker_count": story_prop_marker_layer.get_child_count(),
		"road_cell_count": road_layer.get_child_count(),
	}


func set_marker_cell_for_test(runtime_type: String, stable_id: String, cell: Vector2i) -> Dictionary:
	var marker := _find_marker(runtime_type, stable_id)
	if marker == null:
		return {"ok": false, "reason": "unknown_marker", "stable_id": stable_id, "runtime_type": runtime_type}
	marker.call("set_cell", cell)
	return {"ok": true, "stable_id": stable_id, "runtime_type": runtime_type, "cell": _cell_to_dict(cell)}


func set_tool_mode(mode: String) -> Dictionary:
	if not _valid_tool_modes().has(mode):
		return {"ok": false, "reason": "unknown_tool_mode", "mode": mode}
	current_tool_mode = mode
	if tool_mode_option != null:
		for index in range(tool_mode_option.item_count):
			if str(tool_mode_option.get_item_metadata(index)) == mode:
				tool_mode_option.select(index)
				break
	_set_editor_status("Tool: %s" % mode)
	return {"ok": true, "tool_mode": current_tool_mode}


func get_tool_summary() -> Dictionary:
	var visibility: Dictionary = {}
	for key in LAYER_KEYS:
		visibility[key] = _layer_for_key(key).visible
	return {
		"tool_mode": current_tool_mode,
		"selected_runtime_type": selected_runtime_type,
		"selected_stable_id": selected_stable_id,
		"current_day_key": current_day_key,
		"layer_visibility": visibility,
		"has_toolbar": toolbar_panel != null,
		"has_inspector": inspector_panel != null,
		"has_editor_status": editor_status_label != null,
	}


func toggle_layer(layer_key: String, visible: bool) -> Dictionary:
	var layer := _layer_for_key(layer_key)
	if layer == null:
		return {"ok": false, "reason": "unknown_layer", "layer": layer_key}
	layer.visible = visible
	if layer_toggles.has(layer_key):
		var toggle := layer_toggles[layer_key] as CheckBox
		if toggle != null:
			toggle.button_pressed = visible
	return {"ok": true, "layer": layer_key, "visible": visible}


func select_marker(runtime_type: String, stable_id: String) -> Dictionary:
	var marker := _find_marker(runtime_type, stable_id)
	if marker == null:
		return {"ok": false, "reason": "unknown_marker", "runtime_type": runtime_type, "stable_id": stable_id}
	_clear_marker_selection()
	selected_runtime_type = runtime_type
	selected_stable_id = stable_id
	marker.call("set_selected", true)
	_refresh_inspector()
	return {"ok": true, "runtime_type": runtime_type, "stable_id": stable_id}


func get_inspector_summary() -> Dictionary:
	return {
		"selected_runtime_type": selected_runtime_type,
		"selected_stable_id": selected_stable_id,
		"title": inspector_title_label.text if inspector_title_label != null else "",
		"body": inspector_body_label.text if inspector_body_label != null else "",
		"editable_fields": _editable_fields_for_selection(),
		"field_values": _selection_field_values(),
		"visible_input_count": inspector_field_inputs.size(),
		"has_apply_button": inspector_apply_button != null,
	}


func update_selected_field(field_name: String, value: Variant) -> Dictionary:
	if selected_runtime_type == "place":
		return _update_place_field(selected_stable_id, field_name, value)
	if selected_runtime_type == "resource":
		return _update_resource_field(selected_stable_id, field_name, value)
	if selected_runtime_type == "npc_routine":
		return _update_npc_field(selected_stable_id, field_name, value)
	if selected_runtime_type == "story_prop":
		return _update_story_prop_field(selected_stable_id, field_name, value)
	if selected_runtime_type == "anchor":
		if field_name in ["cell_x", "cell_y"]:
			return _update_anchor_cell_field(selected_stable_id, field_name, value)
		return edit_anchor_field_candidate(selected_stable_id, field_name, value)
	return {"ok": false, "reason": "nothing_selected"}


func apply_inspector_field_values(values: Dictionary) -> Dictionary:
	if selected_stable_id.is_empty():
		return {"ok": false, "reason": "nothing_selected"}
	var applied: Array[String] = []
	for field_name in _editable_fields_for_selection():
		if not values.has(field_name):
			continue
		var result: Dictionary = update_selected_field(field_name, values[field_name])
		if not result.get("ok", false):
			return result
		applied.append(field_name)
	_refresh_inspector()
	_set_editor_status("Edited %s: %s" % [selected_stable_id, ", ".join(applied)])
	return {"ok": true, "stable_id": selected_stable_id, "runtime_type": selected_runtime_type, "applied_fields": applied}


func commit_marker_drag_for_test(runtime_type: String, stable_id: String, to_cell: Vector2i) -> Dictionary:
	var marker := _find_marker(runtime_type, stable_id)
	if marker == null:
		return {"ok": false, "reason": "unknown_marker", "runtime_type": runtime_type, "stable_id": stable_id}
	var from_cell: Vector2i = marker.get("cell")
	marker.call("set_cell", to_cell)
	return _commit_marker_drag(runtime_type, stable_id, from_cell, to_cell)


func set_current_day_key(day_key: String) -> Dictionary:
	if _find_routine_day_index(day_key) < 0:
		return {"ok": false, "reason": "unknown_day_key", "day_key": day_key}
	current_day_key = day_key
	_rebuild_npc_layer()
	_refresh_inspector()
	return {"ok": true, "day_key": current_day_key, "npc_marker_count": npc_spawn_layer.get_child_count()}


func validate_resources_candidate() -> Dictionary:
	var errors: Array[String] = MapEditorSyncServiceScript.validate_resource_points(resource_points_state, editor_state)
	last_resource_validation_result = {
		"ok": errors.is_empty(),
		"errors": errors,
		"error_count": errors.size(),
		"wrote_file": false,
	}
	_refresh_side_status()
	return last_resource_validation_result.duplicate(true)


func validate_routines_candidate() -> Dictionary:
	var errors: Array[String] = MapEditorSyncServiceScript.validate_npc_routines(npc_routine_state, editor_state, resource_points_state)
	last_routine_validation_result = {
		"ok": errors.is_empty(),
		"errors": errors,
		"error_count": errors.size(),
		"wrote_file": false,
	}
	_refresh_side_status()
	return last_routine_validation_result.duplicate(true)


func validate_story_props_candidate() -> Dictionary:
	var errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(story_props_state, editor_state)
	return {
		"ok": errors.is_empty(),
		"errors": errors,
		"error_count": errors.size(),
		"wrote_file": false,
	}


func save_map_candidate(target_path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH, options: Dictionary = {}) -> Dictionary:
	var exported: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(self)
	if not exported.get("ok", false):
		last_validation_result = {"ok": false, "errors": exported.get("errors", []), "error_count": exported.get("errors", []).size(), "wrote_file": false}
		_refresh_validation_panel(false, exported.get("errors", []))
		return {"ok": false, "reason": "validation_failed", "errors": exported.get("errors", []), "written": false, "target_path": target_path}
	var result: Dictionary = MapEditorSyncServiceScript.write_valid_dictionary(exported.get("data", {}), target_path, options)
	if result.get("ok", false):
		last_validation_result = {"ok": true, "errors": [], "error_count": 0, "wrote_file": true}
		_set_editor_status("Saved map: %s" % target_path)
	else:
		last_validation_result = {"ok": false, "errors": result.get("errors", []), "error_count": result.get("errors", []).size(), "wrote_file": false}
		_set_editor_status("Map save failed: %s" % result.get("reason", "unknown"))
	_refresh_validation_panel(bool(result.get("ok", false)), result.get("errors", []))
	return result


func save_resources_candidate(target_path: String = MapEditorSyncServiceScript.RESOURCE_POINTS_PATH, options: Dictionary = {}) -> Dictionary:
	var validation := validate_resources_candidate()
	if not validation.get("ok", false):
		return {"ok": false, "reason": "validation_failed", "errors": validation.get("errors", []), "written": false, "target_path": target_path}
	var result: Dictionary = MapEditorSyncServiceScript.write_resource_points_if_valid(resource_points_state, editor_state, target_path, options)
	if result.get("ok", false):
		last_resource_validation_result["wrote_file"] = true
		_set_editor_status("Saved resources: %s" % target_path)
	else:
		_set_editor_status("Resource save failed: %s" % result.get("reason", "unknown"))
	_refresh_side_status()
	return result


func save_routines_candidate(target_path: String = MapEditorSyncServiceScript.NPC_ROUTINES_PATH, options: Dictionary = {}) -> Dictionary:
	var validation := validate_routines_candidate()
	if not validation.get("ok", false):
		return {"ok": false, "reason": "validation_failed", "errors": validation.get("errors", []), "written": false, "target_path": target_path}
	var result: Dictionary = MapEditorSyncServiceScript.write_npc_routines_if_valid(npc_routine_state, editor_state, resource_points_state, target_path, options)
	if result.get("ok", false):
		last_routine_validation_result["wrote_file"] = true
		_set_editor_status("Saved routines: %s" % target_path)
	else:
		_set_editor_status("Routine save failed: %s" % result.get("reason", "unknown"))
	_refresh_side_status()
	return result


func add_place_marker_candidate(place_id: String, label: String, district_id: String, place_type: String, cell: Vector2i, footprint: Vector2i = Vector2i.ONE) -> Dictionary:
	if place_id.strip_edges().is_empty():
		return {"ok": false, "reason": "empty_place_id"}
	if _find_place_index(place_id) >= 0:
		return {"ok": false, "reason": "duplicate_place_id", "place_id": place_id}

	var normalized_footprint := Vector2i(max(1, footprint.x), max(1, footprint.y))
	var place := {
		"place_id": place_id,
		"label": label if not label.strip_edges().is_empty() else place_id,
		"place_type": place_type,
		"district_id": district_id,
		"position": _cell_to_dict(cell),
		"size": {"w": normalized_footprint.x, "h": normalized_footprint.y},
		"landmark_asset_id": "authoring_placeholder",
		"occupied_cells": _occupied_cells_for(cell, normalized_footprint),
		"interaction_cell": _cell_to_dict(Vector2i(cell.x, cell.y + normalized_footprint.y)),
		"place_action": "look",
		"card_actions": [],
		"unlock_rule": "default_unlocked",
	}
	var places: Array = editor_state.get("places", [])
	places.append(place)
	editor_state["places"] = places

	var interactions: Array = editor_state.get("interaction_cells", [])
	interactions.append({
		"interaction_id": "interaction_%s_authoring" % place_id,
		"place_id": place_id,
		"label": place.get("label", place_id),
		"cell": place.get("interaction_cell", {}),
		"action": "look",
	})
	editor_state["interaction_cells"] = interactions

	place_marker_layer.add_child(_marker("place", place_id, str(place.get("label", "")), cell, normalized_footprint))
	_refresh_validation_panel(false, ["not_validated"])
	return {"ok": true, "place_id": place_id, "place_count": places.size(), "marker_count": place_marker_layer.get_child_count()}


func delete_place_marker_candidate(place_id: String) -> Dictionary:
	var place_index := _find_place_index(place_id)
	if place_index < 0:
		return {"ok": false, "reason": "unknown_place_id", "place_id": place_id}
	var anchor_ids: Array[String] = _anchor_ids_for_place(place_id)
	if not anchor_ids.is_empty():
		return {"ok": false, "reason": "place_has_anchors", "place_id": place_id, "anchor_ids": anchor_ids}

	var places: Array = editor_state.get("places", [])
	places.remove_at(place_index)
	editor_state["places"] = places
	editor_state["interaction_cells"] = _interactions_without_place(place_id)

	var marker := _find_marker("place", place_id)
	if marker != null:
		place_marker_layer.remove_child(marker)
		marker.queue_free()
	_refresh_validation_panel(false, ["not_validated"])
	return {"ok": true, "place_id": place_id, "place_count": places.size(), "marker_count": place_marker_layer.get_child_count()}


func move_place_marker_candidate(place_id: String, cell: Vector2i) -> Dictionary:
	var place_index := _find_place_index(place_id)
	if place_index < 0:
		return {"ok": false, "reason": "unknown_place_id", "place_id": place_id}

	var candidate := editor_state.duplicate(true)
	var applied: Dictionary = _apply_place_move_to_state(candidate, place_id, cell)
	if not applied.get("ok", false):
		return applied
	var move_errors: Array[String] = _validate_place_move_candidate(candidate, place_id)
	if not move_errors.is_empty():
		return {
			"ok": false,
			"reason": "move_validation_failed",
			"place_id": place_id,
			"errors": move_errors,
		}
	var exported: Dictionary = MapEditorSyncServiceScript.export_to_dictionary(candidate)
	if not exported.get("ok", false):
		return {
			"ok": false,
			"reason": "validation_failed",
			"place_id": place_id,
			"errors": exported.get("errors", []),
		}

	editor_state = candidate
	var marker := _find_marker("place", place_id)
	if marker != null:
		marker.call("set_cell", cell)
	_refresh_validation_panel(false, ["not_validated"])
	return {
		"ok": true,
		"place_id": place_id,
		"cell": _cell_to_dict(cell),
		"interaction_cell": applied.get("interaction_cell", {}),
		"interaction_update_count": int(applied.get("interaction_update_count", 0)),
		"collision_update_count": int(applied.get("collision_update_count", 0)),
		"occupied_cells": applied.get("occupied_cells", []),
	}


func move_resource_marker_candidate(point_id: String, cell: Vector2i) -> Dictionary:
	var index := _find_resource_index(point_id)
	if index < 0:
		return {"ok": false, "reason": "unknown_resource_id", "point_id": point_id}
	var candidate := resource_points_state.duplicate(true)
	var points: Array = candidate.get("resource_points", [])
	var point: Dictionary = points[index]
	var old_cell := _dict_to_cell(point.get("cell", {}))
	point["cell"] = _cell_to_dict(cell)
	points[index] = point
	candidate["resource_points"] = points
	var errors: Array[String] = MapEditorSyncServiceScript.validate_resource_points(candidate, editor_state)
	if not errors.is_empty():
		return {"ok": false, "reason": "validation_failed", "point_id": point_id, "errors": errors, "cell": _cell_to_dict(old_cell)}
	resource_points_state = candidate
	var marker := _find_marker("resource", point_id)
	if marker != null:
		marker.call("set_cell", cell)
	last_resource_validation_result = {"ok": false, "errors": ["not_validated"], "wrote_file": false}
	_refresh_side_status()
	_refresh_inspector()
	return {"ok": true, "point_id": point_id, "cell": _cell_to_dict(cell)}


func move_npc_routine_candidate(routine_id: String, cell: Vector2i, day_key: String = "") -> Dictionary:
	var target_day := day_key if not day_key.is_empty() else current_day_key
	var location := _find_routine_location(routine_id, target_day)
	if int(location.get("day_index", -1)) < 0:
		return {"ok": false, "reason": "unknown_routine_id", "routine_id": routine_id, "day_key": target_day}
	var candidate := npc_routine_state.duplicate(true)
	var days: Array = candidate.get("routine_days", [])
	var day: Dictionary = days[int(location["day_index"])]
	var npcs: Array = day.get("npcs", [])
	var npc: Dictionary = npcs[int(location["npc_index"])]
	var old_cell := _dict_to_cell(npc.get("cell", {}))
	npc["cell"] = _cell_to_dict(cell)
	npcs[int(location["npc_index"])] = npc
	day["npcs"] = npcs
	days[int(location["day_index"])] = day
	candidate["routine_days"] = days
	var errors: Array[String] = MapEditorSyncServiceScript.validate_npc_routines(candidate, editor_state, resource_points_state)
	if not errors.is_empty():
		return {"ok": false, "reason": "validation_failed", "routine_id": routine_id, "errors": errors, "cell": _cell_to_dict(old_cell)}
	npc_routine_state = candidate
	if target_day == current_day_key:
		var marker := _find_marker("npc_routine", routine_id)
		if marker != null:
			marker.call("set_cell", cell)
	last_routine_validation_result = {"ok": false, "errors": ["not_validated"], "wrote_file": false}
	_refresh_side_status()
	_refresh_inspector()
	return {"ok": true, "routine_id": routine_id, "day_key": target_day, "cell": _cell_to_dict(cell)}


func move_story_prop_marker_candidate(story_prop_id: String, cell: Vector2i) -> Dictionary:
	var candidate := story_props_state.duplicate(true)
	var props: Array = candidate.get("story_props", [])
	for index in range(props.size()):
		var prop: Dictionary = props[index]
		if str(prop.get("story_prop_id", "")) != story_prop_id:
			continue
		var old_cell := _dict_to_cell(prop.get("cell", {}))
		prop["cell"] = _cell_to_dict(cell)
		props[index] = prop
		candidate["story_props"] = props
		var errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(candidate, editor_state)
		if not errors.is_empty():
			return {"ok": false, "reason": "validation_failed", "story_prop_id": story_prop_id, "errors": errors, "cell": _cell_to_dict(old_cell)}
		story_props_state = candidate
		var marker := _find_marker("story_prop", story_prop_id)
		if marker != null:
			marker.call("set_cell", cell)
		_refresh_inspector()
		return {"ok": true, "story_prop_id": story_prop_id, "cell": _cell_to_dict(cell)}
	return {"ok": false, "reason": "unknown_story_prop_id", "story_prop_id": story_prop_id}


func move_anchor_marker_candidate(anchor_id: String, cell: Vector2i) -> Dictionary:
	if current_tool_mode != TOOL_MOVE_ANCHOR:
		return {"ok": false, "reason": "anchor_move_mode_required", "anchor_id": anchor_id}
	var anchor_index := _find_anchor_index(anchor_id)
	if anchor_index < 0:
		return {"ok": false, "reason": "unknown_anchor_id", "anchor_id": anchor_id}
	var candidate := editor_state.duplicate(true)
	var anchors: Array = candidate.get("memory_anchors", [])
	var anchor: Dictionary = anchors[anchor_index]
	var original_locked := _locked_anchor_snapshot(anchor)
	anchor["position"] = _cell_to_dict(cell)
	anchors[anchor_index] = anchor
	candidate["memory_anchors"] = anchors
	if _locked_anchor_snapshot(anchor) != original_locked:
		return {"ok": false, "reason": "anchor_locked_field_changed", "anchor_id": anchor_id}
	var errors: Array[String] = MapEditorSyncServiceScript.export_to_dictionary(candidate).get("errors", [])
	errors.append_array(_validate_anchor_migration(candidate))
	if not errors.is_empty():
		return {"ok": false, "reason": "validation_failed", "anchor_id": anchor_id, "errors": errors}
	editor_state = candidate
	var marker := _find_marker("anchor", anchor_id)
	if marker != null:
		marker.call("set_cell", cell)
	_refresh_validation_panel(false, ["not_validated"])
	_refresh_inspector()
	return {"ok": true, "anchor_id": anchor_id, "cell": _cell_to_dict(cell), "anchor_count": anchors.size()}


func paint_cell_candidate(layer_key: String, cell: Vector2i, erase: bool = false) -> Dictionary:
	if not ["road", "collision", "interaction"].has(layer_key):
		return {"ok": false, "reason": "unsupported_paint_layer", "layer": layer_key}
	if not erase:
		var protected_reason := _protected_cell_reason(cell, layer_key)
		if not protected_reason.is_empty():
			return {"ok": false, "reason": "protected_cell", "layer": layer_key, "protected": protected_reason, "cell": _cell_to_dict(cell)}
	if layer_key == "road":
		_paint_road_cell(cell, erase)
	elif layer_key == "collision":
		_paint_collision_cell(cell, erase)
	else:
		var interaction_result := _paint_interaction_cell(cell, erase)
		if not interaction_result.get("ok", false):
			return interaction_result
	_rebuild_map_cell_layers()
	_refresh_validation_panel(false, ["not_validated"])
	return {"ok": true, "layer": layer_key, "erase": erase, "cell": _cell_to_dict(cell)}


func get_authoring_place_summary() -> Dictionary:
	var place_ids: Array[String] = []
	for place in editor_state.get("places", []):
		place_ids.append(str(place.get("place_id", "")))
	return {
		"place_count": place_ids.size(),
		"marker_count": place_marker_layer.get_child_count(),
		"place_ids": place_ids,
	}


func delete_anchor_marker_candidate(anchor_id: String) -> Dictionary:
	var anchor_index := _find_anchor_index(anchor_id)
	if anchor_index < 0:
		return {"ok": false, "reason": "unknown_anchor_id", "anchor_id": anchor_id}
	var anchors: Array = editor_state.get("memory_anchors", [])
	var anchor: Dictionary = anchors[anchor_index]
	if _is_core_az_anchor(anchor):
		return {
			"ok": false,
			"reason": "protected_core_anchor",
			"anchor_id": anchor_id,
			"letter": str(anchor.get("letter", "")),
			"route_order": int(anchor.get("route_order", 0)),
		}

	anchors.remove_at(anchor_index)
	editor_state["memory_anchors"] = anchors
	var marker := _find_marker("anchor", anchor_id)
	if marker != null:
		anchor_marker_layer.remove_child(marker)
		marker.queue_free()
	_refresh_validation_panel(false, ["not_validated"])
	return {"ok": true, "anchor_id": anchor_id, "anchor_count": anchors.size(), "marker_count": anchor_marker_layer.get_child_count()}


func edit_anchor_field_candidate(anchor_id: String, field_name: String, value: Variant) -> Dictionary:
	var anchor_index := _find_anchor_index(anchor_id)
	if anchor_index < 0:
		return {"ok": false, "reason": "unknown_anchor_id", "anchor_id": anchor_id, "field": field_name}
	var anchors: Array = editor_state.get("memory_anchors", [])
	var anchor: Dictionary = anchors[anchor_index]
	if _is_core_az_anchor(anchor) and LOCKED_ANCHOR_FIELDS.has(field_name):
		return {
			"ok": false,
			"reason": "anchor_field_locked",
			"anchor_id": anchor_id,
			"field": field_name,
			"locked_fields": LOCKED_ANCHOR_FIELDS.duplicate(),
		}
	anchor[field_name] = value
	anchors[anchor_index] = anchor
	editor_state["memory_anchors"] = anchors
	_refresh_validation_panel(false, ["not_validated"])
	return {"ok": true, "anchor_id": anchor_id, "field": field_name}


func get_authoring_anchor_summary() -> Dictionary:
	var anchor_ids: Array[String] = []
	var protected_anchor_ids: Array[String] = []
	for anchor in editor_state.get("memory_anchors", []):
		var anchor_id := str(anchor.get("anchor_id", ""))
		anchor_ids.append(anchor_id)
		if _is_core_az_anchor(anchor):
			protected_anchor_ids.append(anchor_id)
	return {
		"anchor_count": anchor_ids.size(),
		"marker_count": anchor_marker_layer.get_child_count(),
		"anchor_ids": anchor_ids,
		"protected_anchor_ids": protected_anchor_ids,
		"protected_anchor_count": protected_anchor_ids.size(),
		"locked_fields": LOCKED_ANCHOR_FIELDS.duplicate(),
	}


func export_world_map_dictionary() -> Dictionary:
	var exported := editor_state.duplicate(true)
	for place in exported.get("places", []):
		var marker := _find_marker("place", str(place.get("place_id", "")))
		if marker != null:
			place["position"] = _cell_to_dict(marker.get("cell"))
	for anchor in exported.get("memory_anchors", []):
		var marker := _find_marker("anchor", str(anchor.get("anchor_id", "")))
		if marker != null:
			anchor["position"] = _cell_to_dict(marker.get("cell"))
	return exported


func validate_export_candidate() -> Dictionary:
	var result: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(self)
	var errors: Array = result.get("errors", [])
	last_validation_result = {
		"ok": result.get("ok", false),
		"errors": errors.duplicate(true),
		"error_count": errors.size(),
		"wrote_file": false,
	}
	_refresh_validation_panel(bool(last_validation_result.get("ok", false)), errors)
	return last_validation_result.duplicate(true)


func get_validation_summary() -> Dictionary:
	return {
		"ok": bool(last_validation_result.get("ok", false)),
		"errors": (last_validation_result.get("errors", []) as Array).duplicate(true),
		"error_count": int(last_validation_result.get("error_count", 0)),
		"wrote_file": bool(last_validation_result.get("wrote_file", false)),
		"status_text": validation_status_label.text if validation_status_label != null else "",
		"error_text": validation_errors_label.text if validation_errors_label != null else "",
		"has_validate_button": validate_export_button != null,
	}


func get_layer_summary() -> Dictionary:
	return {
		"has_ground_preview": ground_preview_layer != null,
		"has_road_layer": road_layer != null,
		"has_collision_layer": collision_layer != null,
		"has_interaction_layer": interaction_layer != null,
		"has_place_marker_layer": place_marker_layer != null,
		"has_anchor_marker_layer": anchor_marker_layer != null,
		"has_resource_marker_layer": resource_marker_layer != null,
		"has_npc_spawn_layer": npc_spawn_layer != null,
		"has_export_validation_panel": export_validation_panel != null,
		"has_validate_export_button": validate_export_button != null,
		"has_validation_status_label": validation_status_label != null,
		"has_validation_errors_label": validation_errors_label != null,
		"has_toolbar": toolbar_panel != null,
		"has_tool_mode_option": tool_mode_option != null,
		"has_inspector_panel": inspector_panel != null,
		"has_editor_status_label": editor_status_label != null,
	}


func get_editor_layout_summary() -> Dictionary:
	var status_panel := get_node_or_null("EditorStatusPanel") as Control
	return {
		"map_origin": {"x": int(road_layer.position.x), "y": int(road_layer.position.y)} if road_layer != null else {},
		"cell_size": MAP_CELL_SIZE,
		"map_extent": _map_extent_dict(),
		"validation_rect": _control_rect_dict(export_validation_panel),
		"toolbar_rect": _control_rect_dict(toolbar_panel),
		"inspector_rect": _control_rect_dict(inspector_panel),
		"status_rect": _control_rect_dict(status_panel),
		"place_label": _marker_label_text("place", "place_home"),
		"anchor_label": _marker_label_text("anchor", "anchor_a_apple"),
		"anchor_visual": _marker_visual_summary("anchor", "anchor_a_apple"),
		"resource_label": _marker_label_text("resource", "resource_branch_bear_corner"),
		"npc_label": _marker_label_text("npc_routine", "routine_mina_plaza_001"),
	}


func _bind_layers() -> void:
	ground_preview_layer = get_node("GroundPreviewLayer") as Control
	road_layer = get_node("RoadLayer") as Control
	collision_layer = get_node("CollisionLayer") as Control
	interaction_layer = get_node("InteractionLayer") as Control
	place_marker_layer = get_node("PlaceMarkerLayer") as Control
	anchor_marker_layer = get_node("AnchorMarkerLayer") as Control
	resource_marker_layer = get_node("ResourceMarkerLayer") as Control
	npc_spawn_layer = get_node("NPCSpawnLayer") as Control
	story_prop_marker_layer = get_node("StoryPropMarkerLayer") as Control
	export_validation_panel = get_node("ExportValidationPanel") as Control
	validate_export_button = get_node("ExportValidationPanel/VBox/ValidateExportButton") as Button
	validation_status_label = get_node("ExportValidationPanel/VBox/ValidationStatusLabel") as Label
	validation_errors_label = get_node("ExportValidationPanel/VBox/ValidationErrorsLabel") as Label
	if not validate_export_button.pressed.is_connected(_on_validate_export_pressed):
		validate_export_button.pressed.connect(_on_validate_export_pressed)
	_ensure_editor_ui()
	_apply_declutter_layout()


func _rebuild_layers() -> void:
	for layer in [road_layer, collision_layer, interaction_layer, place_marker_layer, anchor_marker_layer, resource_marker_layer, npc_spawn_layer, story_prop_marker_layer]:
		for child in layer.get_children():
			layer.remove_child(child)
			child.queue_free()
	_rebuild_map_cell_layers()
	for place in editor_state.get("places", []):
		place_marker_layer.add_child(_marker("place", str(place.get("place_id", "")), str(place.get("label", "")), _dict_to_cell(place.get("position", {})), _size_to_footprint(place.get("size", {}))))
	for anchor in editor_state.get("memory_anchors", []):
		anchor_marker_layer.add_child(_marker("anchor", str(anchor.get("anchor_id", "")), str(anchor.get("letter", "")), _dict_to_cell(anchor.get("position", {})), Vector2i.ONE))
	_rebuild_resource_layer()
	_rebuild_npc_layer()
	_rebuild_story_prop_layer()


func _rebuild_map_cell_layers() -> void:
	for layer in [road_layer, collision_layer, interaction_layer]:
		for child in layer.get_children():
			layer.remove_child(child)
			child.queue_free()
	for road in editor_state.get("roads", []):
		for cell in road.get("cells", []):
			road_layer.add_child(_cell_rect("RoadCell", _dict_to_cell(cell), Color("#d7c894aa")))
	for cell in editor_state.get("collision_cells", []):
		collision_layer.add_child(_cell_rect("CollisionCell", _dict_to_cell(cell), Color("#c46a5c99")))
	for interaction in editor_state.get("interaction_cells", []):
		interaction_layer.add_child(_cell_rect("InteractionCell", _dict_to_cell(interaction.get("cell", {})), Color("#6a9f7b99")))


func _rebuild_resource_layer() -> void:
	for child in resource_marker_layer.get_children():
		resource_marker_layer.remove_child(child)
		child.queue_free()
	for point in resource_points_state.get("resource_points", []):
		if point is Dictionary:
			resource_marker_layer.add_child(_marker("resource", str((point as Dictionary).get("point_id", "")), str((point as Dictionary).get("display_name", "")), _dict_to_cell((point as Dictionary).get("cell", {})), Vector2i.ONE))


func _rebuild_npc_layer() -> void:
	for child in npc_spawn_layer.get_children():
		npc_spawn_layer.remove_child(child)
		child.queue_free()
	var day := _routine_day_by_key(current_day_key)
	for npc in day.get("npcs", []):
		if npc is Dictionary:
			npc_spawn_layer.add_child(_marker("npc_routine", str((npc as Dictionary).get("routine_id", "")), str((npc as Dictionary).get("npc_id", "")), _dict_to_cell((npc as Dictionary).get("cell", {})), Vector2i.ONE))


func _rebuild_story_prop_layer() -> void:
	for child in story_prop_marker_layer.get_children():
		story_prop_marker_layer.remove_child(child)
		child.queue_free()
	for prop in story_props_state.get("story_props", []):
		if prop is Dictionary:
			story_prop_marker_layer.add_child(_marker("story_prop", str((prop as Dictionary).get("story_prop_id", "")), str((prop as Dictionary).get("child_label", "")), _dict_to_cell((prop as Dictionary).get("cell", {})), _size_to_footprint((prop as Dictionary).get("size", {}))))


func _marker(runtime_type: String, stable_id: String, label: String, cell: Vector2i, footprint: Vector2i) -> Control:
	var marker := MapAuthoringMarkerScene.instantiate() as Control
	marker.set("runtime_type", runtime_type)
	marker.set("stable_id", stable_id)
	marker.set("display_label", label)
	marker.set("cell_size", MAP_CELL_SIZE)
	marker.set("footprint", footprint)
	marker.set("cell", cell)
	if runtime_type == "anchor":
		marker.z_index = 90
	elif runtime_type == "npc_routine":
		marker.z_index = 30
	elif runtime_type == "resource":
		marker.z_index = 25
	elif runtime_type == "story_prop":
		marker.z_index = 22
	elif runtime_type == "place":
		marker.z_index = 10
	if marker.has_signal("marker_selected"):
		marker.connect("marker_selected", Callable(self, "_on_marker_selected"))
	if marker.has_signal("marker_drag_finished"):
		marker.connect("marker_drag_finished", Callable(self, "_on_marker_drag_finished"))
	return marker


func _cell_rect(prefix: String, cell: Vector2i, color: Color) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = "%s_%d_%d" % [prefix, cell.x, cell.y]
	rect.position = Vector2(cell.x * MAP_CELL_SIZE + 2, cell.y * MAP_CELL_SIZE + 2)
	rect.size = Vector2(MAP_CELL_SIZE - 4, MAP_CELL_SIZE - 4)
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


func _ensure_editor_ui() -> void:
	if get_node_or_null("EditorToolbar") == null:
		toolbar_panel = PanelContainer.new()
		toolbar_panel.name = "EditorToolbar"
		add_child(toolbar_panel)
		var toolbar_box := GridContainer.new()
		toolbar_box.name = "ToolbarBox"
		toolbar_box.columns = 2
		toolbar_panel.add_child(toolbar_box)
	else:
		toolbar_panel = get_node("EditorToolbar") as Control
		tool_mode_option = find_child("ToolModeOption", true, false) as OptionButton
	_ensure_toolbar_controls()
	if get_node_or_null("InspectorPanel") == null:
		inspector_panel = PanelContainer.new()
		inspector_panel.name = "InspectorPanel"
		add_child(inspector_panel)
		var inspector_box := VBoxContainer.new()
		inspector_box.name = "InspectorBox"
		inspector_panel.add_child(inspector_box)
		inspector_title_label = Label.new()
		inspector_title_label.name = "InspectorTitleLabel"
		inspector_title_label.text = "No selection"
		inspector_box.add_child(inspector_title_label)
		inspector_body_label = Label.new()
		inspector_body_label.name = "InspectorBodyLabel"
		inspector_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		inspector_body_label.text = "Select a marker to inspect editable fields."
		inspector_box.add_child(inspector_body_label)
	else:
		inspector_panel = get_node("InspectorPanel") as Control
		inspector_title_label = find_child("InspectorTitleLabel", true, false) as Label
		inspector_body_label = find_child("InspectorBodyLabel", true, false) as Label
	_ensure_inspector_controls()
	if get_node_or_null("EditorStatusPanel") == null:
		var status_panel := PanelContainer.new()
		status_panel.name = "EditorStatusPanel"
		add_child(status_panel)
		var status_box := VBoxContainer.new()
		status_box.name = "EditorStatusBox"
		status_panel.add_child(status_box)
		editor_status_label = Label.new()
		editor_status_label.name = "EditorStatusLabel"
		editor_status_label.text = "Editor ready"
		status_box.add_child(editor_status_label)
		resource_status_label = Label.new()
		resource_status_label.name = "ResourceStatusLabel"
		status_box.add_child(resource_status_label)
		routine_status_label = Label.new()
		routine_status_label.name = "RoutineStatusLabel"
		status_box.add_child(routine_status_label)
	else:
		editor_status_label = find_child("EditorStatusLabel", true, false) as Label
		resource_status_label = find_child("ResourceStatusLabel", true, false) as Label
		routine_status_label = find_child("RoutineStatusLabel", true, false) as Label
	_refresh_inspector()


func _apply_declutter_layout() -> void:
	for layer in [ground_preview_layer, road_layer, collision_layer, interaction_layer, place_marker_layer, anchor_marker_layer, resource_marker_layer, npc_spawn_layer, story_prop_marker_layer]:
		if layer != null:
			layer.position = MAP_VIEW_ORIGIN
			layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if place_marker_layer != null:
		place_marker_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	if anchor_marker_layer != null:
		anchor_marker_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	if resource_marker_layer != null:
		resource_marker_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	if npc_spawn_layer != null:
		npc_spawn_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	if story_prop_marker_layer != null:
		story_prop_marker_layer.mouse_filter = Control.MOUSE_FILTER_PASS

	if export_validation_panel != null:
		_set_panel_rect(export_validation_panel, Rect2(12, 12, 228, 116))
		_apply_panel_style(export_validation_panel)
		_limit_panel_to_declutter_rect(export_validation_panel)
	if toolbar_panel != null:
		_set_panel_rect(toolbar_panel, Rect2(12, 140, 228, 272))
		_apply_panel_style(toolbar_panel)
		_limit_panel_to_declutter_rect(toolbar_panel)
	if inspector_panel != null:
		_set_panel_rect(inspector_panel, Rect2(12, 388, 228, 190))
		_apply_panel_style(inspector_panel)
		_limit_panel_to_declutter_rect(inspector_panel)
	var status_panel := get_node_or_null("EditorStatusPanel") as Control
	if status_panel != null:
		_set_panel_rect(status_panel, Rect2(12, 590, 228, 118))
		_apply_panel_style(status_panel)
		_limit_panel_to_declutter_rect(status_panel)
	if anchor_marker_layer != null:
		move_child(anchor_marker_layer, get_child_count() - 1)
	_apply_sidebar_text_constraints()


func _set_panel_rect(panel: Control, rect: Rect2) -> void:
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.position = rect.position
	panel.size = rect.size


func _limit_panel_to_declutter_rect(panel: Control) -> void:
	panel.custom_minimum_size = panel.size
	panel.clip_contents = true


func _apply_panel_style(panel: Control) -> void:
	if not panel is PanelContainer:
		return
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = Color("#2f3430dd")
	stylebox.border_color = Color("#76846faa")
	stylebox.border_width_left = 1
	stylebox.border_width_top = 1
	stylebox.border_width_right = 1
	stylebox.border_width_bottom = 1
	stylebox.corner_radius_top_left = 3
	stylebox.corner_radius_top_right = 3
	stylebox.corner_radius_bottom_left = 3
	stylebox.corner_radius_bottom_right = 3
	(panel as PanelContainer).add_theme_stylebox_override("panel", stylebox)


func _apply_sidebar_text_constraints() -> void:
	_configure_sidebar_label(validation_status_label, Vector2(204, 20), 1)
	_configure_sidebar_label(validation_errors_label, Vector2(204, 44), 2)
	_configure_sidebar_label(inspector_title_label, Vector2(204, 20), 1)
	_configure_sidebar_label(inspector_body_label, Vector2(204, 34), 2)
	_configure_sidebar_label(editor_status_label, Vector2(204, 22), 1)
	_configure_sidebar_label(resource_status_label, Vector2(204, 34), 2)
	_configure_sidebar_label(routine_status_label, Vector2(204, 34), 2)


func _configure_sidebar_label(label: Label, minimum_size: Vector2, max_lines: int) -> void:
	if label == null:
		return
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = true
	label.max_lines_visible = max_lines
	label.custom_minimum_size = minimum_size
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN


func _control_rect_dict(control: Control) -> Dictionary:
	if control == null:
		return {}
	return {
		"x": int(control.position.x),
		"y": int(control.position.y),
		"w": int(control.size.x),
		"h": int(control.size.y),
	}


func _map_extent_dict() -> Dictionary:
	var canvas: Dictionary = editor_state.get("canvas_size", {})
	var width := int(canvas.get("w", 60)) * MAP_CELL_SIZE
	var height := int(canvas.get("h", 34)) * MAP_CELL_SIZE
	return {
		"x": int(MAP_VIEW_ORIGIN.x),
		"y": int(MAP_VIEW_ORIGIN.y),
		"w": width,
		"h": height,
		"right": int(MAP_VIEW_ORIGIN.x) + width,
		"bottom": int(MAP_VIEW_ORIGIN.y) + height,
	}


func _ensure_toolbar_controls() -> void:
	if toolbar_panel == null:
		return
	var toolbar_box := toolbar_panel.get_node_or_null("ToolbarBox") as GridContainer
	if toolbar_box == null:
		toolbar_box = GridContainer.new()
		toolbar_box.name = "ToolbarBox"
		toolbar_panel.add_child(toolbar_box)
	toolbar_box.columns = 2
	tool_mode_option = toolbar_box.get_node_or_null("ToolModeOption") as OptionButton
	if tool_mode_option == null:
		tool_mode_option = OptionButton.new()
		tool_mode_option.name = "ToolModeOption"
		toolbar_box.add_child(tool_mode_option)
	tool_mode_option.custom_minimum_size = Vector2(100, 28)
	if tool_mode_option.item_count == 0:
		for mode in _valid_tool_modes():
			tool_mode_option.add_item(_tool_label(mode))
			tool_mode_option.set_item_metadata(tool_mode_option.item_count - 1, mode)
	if not tool_mode_option.item_selected.is_connected(_on_tool_mode_selected):
		tool_mode_option.item_selected.connect(_on_tool_mode_selected)
	for layer_key in LAYER_KEYS:
		var toggle_name := "Layer%sToggle" % layer_key.capitalize()
		var toggle := toolbar_box.get_node_or_null(toggle_name) as CheckBox
		if toggle == null:
			toggle = CheckBox.new()
			toggle.name = toggle_name
			toolbar_box.add_child(toggle)
		toggle.text = _layer_label(layer_key)
		toggle.tooltip_text = "Toggle %s layer" % layer_key
		toggle.custom_minimum_size = Vector2(96, 24)
		toggle.button_pressed = _layer_for_key(layer_key).visible
		var toggle_callable := Callable(self, "_on_layer_toggle_toggled").bind(layer_key)
		if not toggle.toggled.is_connected(toggle_callable):
			toggle.toggled.connect(toggle_callable)
		layer_toggles[layer_key] = toggle
	for button_data in _toolbar_button_data():
		var button := toolbar_box.get_node_or_null(str(button_data["name"])) as Button
		if button == null:
			button = Button.new()
			button.name = str(button_data["name"])
			toolbar_box.add_child(button)
		button.text = str(button_data["text"])
		button.tooltip_text = str(button_data.get("tooltip", button_data["text"]))
		button.custom_minimum_size = Vector2(96, 26)
		var pressed_callable: Callable = button_data["callable"]
		if not button.pressed.is_connected(pressed_callable):
			button.pressed.connect(pressed_callable)


func _ensure_inspector_controls() -> void:
	if inspector_panel == null:
		return
	var inspector_box := inspector_panel.get_node_or_null("InspectorBox") as VBoxContainer
	if inspector_box == null:
		inspector_box = VBoxContainer.new()
		inspector_box.name = "InspectorBox"
		inspector_panel.add_child(inspector_box)
	inspector_fields_grid = inspector_box.get_node_or_null("InspectorFieldsGrid") as GridContainer
	if inspector_fields_grid == null:
		inspector_fields_grid = GridContainer.new()
		inspector_fields_grid.name = "InspectorFieldsGrid"
		inspector_fields_grid.columns = 2
		inspector_box.add_child(inspector_fields_grid)
	inspector_apply_button = inspector_box.get_node_or_null("InspectorApplyButton") as Button
	if inspector_apply_button == null:
		inspector_apply_button = Button.new()
		inspector_apply_button.name = "InspectorApplyButton"
		inspector_apply_button.text = "Apply"
		inspector_apply_button.custom_minimum_size = Vector2(204, 24)
		inspector_box.add_child(inspector_apply_button)
	if not inspector_apply_button.pressed.is_connected(_on_inspector_apply_pressed):
		inspector_apply_button.pressed.connect(_on_inspector_apply_pressed)


func _toolbar_button_data() -> Array[Dictionary]:
	return [
		{"name": "ValidateMapButton", "text": "Map Check", "tooltip": "Validate world_map candidate", "callable": Callable(self, "validate_export_candidate")},
		{"name": "SaveMapButton", "text": "Map Save", "tooltip": "Save world_map after validation", "callable": Callable(self, "save_map_candidate")},
		{"name": "ValidateResourcesButton", "text": "Res Check", "tooltip": "Validate resource_points candidate", "callable": Callable(self, "validate_resources_candidate")},
		{"name": "SaveResourcesButton", "text": "Res Save", "tooltip": "Save resource_points after validation", "callable": Callable(self, "save_resources_candidate")},
		{"name": "ValidateRoutinesButton", "text": "NPC Check", "tooltip": "Validate npc_routines candidate", "callable": Callable(self, "validate_routines_candidate")},
		{"name": "SaveRoutinesButton", "text": "NPC Save", "tooltip": "Save npc_routines after validation", "callable": Callable(self, "save_routines_candidate")},
	]


func _tool_label(mode: String) -> String:
	if mode == TOOL_SELECT:
		return "Select"
	if mode == TOOL_MOVE_PLACE:
		return "Move Place"
	if mode == TOOL_PAINT_ROAD:
		return "Road"
	if mode == TOOL_PAINT_COLLISION:
		return "Block"
	if mode == TOOL_PAINT_INTERACTION:
		return "Look Cell"
	if mode == TOOL_PLACE_RESOURCE:
		return "Resource"
	if mode == TOOL_PLACE_NPC_ROUTINE:
		return "NPC"
	if mode == TOOL_MOVE_ANCHOR:
		return "Move A-Z"
	return mode


func _layer_label(layer_key: String) -> String:
	if layer_key == "collision":
		return "block"
	if layer_key == "interaction":
		return "look"
	if layer_key == "resource":
		return "res"
	if layer_key == "story_prop":
		return "prop"
	return layer_key


func _valid_tool_modes() -> Array[String]:
	return [TOOL_SELECT, TOOL_MOVE_PLACE, TOOL_PAINT_ROAD, TOOL_PAINT_COLLISION, TOOL_PAINT_INTERACTION, TOOL_PLACE_RESOURCE, TOOL_PLACE_NPC_ROUTINE, TOOL_PLACE_STORY_PROP, TOOL_MOVE_ANCHOR]


func _marker_layer_for_type(runtime_type: String) -> Control:
	if runtime_type == "place":
		return place_marker_layer
	if runtime_type == "anchor":
		return anchor_marker_layer
	if runtime_type == "resource":
		return resource_marker_layer
	if runtime_type == "npc_routine":
		return npc_spawn_layer
	if runtime_type == "story_prop":
		return story_prop_marker_layer
	return null


func _layer_for_key(layer_key: String) -> Control:
	if layer_key == "road":
		return road_layer
	if layer_key == "collision":
		return collision_layer
	if layer_key == "interaction":
		return interaction_layer
	if layer_key == "place":
		return place_marker_layer
	if layer_key == "anchor":
		return anchor_marker_layer
	if layer_key == "resource":
		return resource_marker_layer
	if layer_key == "npc":
		return npc_spawn_layer
	if layer_key == "story_prop":
		return story_prop_marker_layer
	return null


func _find_marker(runtime_type: String, stable_id: String) -> Control:
	var layer := _marker_layer_for_type(runtime_type)
	if layer == null:
		return null
	for child in layer.get_children():
		if str(child.get("runtime_type")) == runtime_type and str(child.get("stable_id")) == stable_id:
			return child as Control
	return null


func _marker_label_text(runtime_type: String, stable_id: String) -> String:
	var marker := _find_marker(runtime_type, stable_id)
	if marker == null:
		return ""
	var label := marker.find_child("Label", false, false) as Label
	return label.text if label != null else ""


func _marker_visual_summary(runtime_type: String, stable_id: String) -> Dictionary:
	var marker := _find_marker(runtime_type, stable_id)
	if marker == null:
		return {}
	var label := marker.find_child("Label", false, false) as Label
	return {
		"text": label.text if label != null else "",
		"font_size": label.get_theme_font_size("font_size") if label != null else 0,
		"z_index": marker.z_index,
		"size": {"w": int(marker.size.x), "h": int(marker.size.y)},
	}


func _find_place_index(place_id: String) -> int:
	var places: Array = editor_state.get("places", [])
	for index in range(places.size()):
		var place: Dictionary = places[index]
		if str(place.get("place_id", "")) == place_id:
			return index
	return -1


func _find_anchor_index(anchor_id: String) -> int:
	var anchors: Array = editor_state.get("memory_anchors", [])
	for index in range(anchors.size()):
		var anchor: Dictionary = anchors[index]
		if str(anchor.get("anchor_id", "")) == anchor_id:
			return index
	return -1


func _find_resource_index(point_id: String) -> int:
	var points: Array = resource_points_state.get("resource_points", [])
	for index in range(points.size()):
		var point: Dictionary = points[index]
		if str(point.get("point_id", "")) == point_id:
			return index
	return -1


func _find_routine_day_index(day_key: String) -> int:
	var days: Array = npc_routine_state.get("routine_days", [])
	for index in range(days.size()):
		var day: Dictionary = days[index]
		if str(day.get("day_key", "")) == day_key:
			return index
	return -1


func _find_routine_location(routine_id: String, day_key: String) -> Dictionary:
	var day_index := _find_routine_day_index(day_key)
	if day_index < 0:
		return {"day_index": -1, "npc_index": -1}
	var days: Array = npc_routine_state.get("routine_days", [])
	var day: Dictionary = days[day_index]
	var npcs: Array = day.get("npcs", [])
	for npc_index in range(npcs.size()):
		var npc: Dictionary = npcs[npc_index]
		if str(npc.get("routine_id", "")) == routine_id:
			return {"day_index": day_index, "npc_index": npc_index}
	return {"day_index": -1, "npc_index": -1}


func _routine_day_by_key(day_key: String) -> Dictionary:
	var index := _find_routine_day_index(day_key)
	if index < 0:
		return {}
	return (npc_routine_state.get("routine_days", []) as Array)[index]


func _load_resource_points() -> void:
	var result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH)
	if result.get("ok", false):
		resource_points_state = result.get("data", {}).duplicate(true)
	else:
		resource_points_state = {"schema_version": 1, "resource_points": []}
		last_resource_validation_result = {"ok": false, "errors": result.get("errors", []), "wrote_file": false}


func _load_npc_routines() -> void:
	var result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.NPC_ROUTINES_PATH)
	if result.get("ok", false):
		npc_routine_state = result.get("data", {}).duplicate(true)
		var days: Array = npc_routine_state.get("routine_days", [])
		if not days.is_empty():
			current_day_key = str((days[0] as Dictionary).get("day_key", current_day_key))
	else:
		npc_routine_state = {"schema_version": 1, "routine_days": []}
		last_routine_validation_result = {"ok": false, "errors": result.get("errors", []), "wrote_file": false}


func _load_story_props() -> void:
	var result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.STORY_PROPS_PATH)
	if result.get("ok", false):
		story_props_state = result.get("data", {}).duplicate(true)
	else:
		story_props_state = {"schema_version": 1, "story_props": []}


func _is_core_az_anchor(anchor: Dictionary) -> bool:
	var letter := str(anchor.get("letter", ""))
	var route_order := int(anchor.get("route_order", 0))
	return letter.length() == 1 and "ABCDEFGHIJKLMNOPQRSTUVWXYZ".find(letter) >= 0 and route_order >= 1 and route_order <= 26


func _anchor_ids_for_place(place_id: String) -> Array[String]:
	var anchor_ids: Array[String] = []
	for anchor in editor_state.get("memory_anchors", []):
		if str(anchor.get("place_id", "")) == place_id:
			anchor_ids.append(str(anchor.get("anchor_id", "")))
	return anchor_ids


func _interactions_without_place(place_id: String) -> Array:
	var kept: Array = []
	for interaction in editor_state.get("interaction_cells", []):
		if str(interaction.get("place_id", "")) != place_id:
			kept.append(interaction)
	return kept


func _update_interaction_action_for_place(place_id: String, action: String) -> void:
	var interactions: Array = editor_state.get("interaction_cells", [])
	for index in range(interactions.size()):
		var interaction: Dictionary = interactions[index]
		if str(interaction.get("place_id", "")) == place_id:
			interaction["action"] = action
			interactions[index] = interaction
	editor_state["interaction_cells"] = interactions


func _apply_place_move_to_state(state: Dictionary, place_id: String, cell: Vector2i) -> Dictionary:
	var places: Array = state.get("places", [])
	for index in range(places.size()):
		var place: Dictionary = places[index]
		if str(place.get("place_id", "")) != place_id:
			continue
		var old_position := _dict_to_cell(place.get("position", {}))
		var old_interaction := _dict_to_cell(place.get("interaction_cell", {}))
		var interaction_offset := old_interaction - old_position
		var footprint := _size_to_footprint(place.get("size", {}))
		var new_interaction := cell + interaction_offset
		var old_occupied: Array = place.get("occupied_cells", [])
		var new_occupied := _occupied_cells_for(cell, footprint)
		place["position"] = _cell_to_dict(cell)
		place["interaction_cell"] = _cell_to_dict(new_interaction)
		place["occupied_cells"] = new_occupied
		places[index] = place
		state["places"] = places

		var updated_interactions := 0
		var interactions: Array = state.get("interaction_cells", [])
		for interaction_index in range(interactions.size()):
			var interaction: Dictionary = interactions[interaction_index]
			if str(interaction.get("place_id", "")) == place_id and _same_cell(interaction.get("cell", {}), _cell_to_dict(old_interaction)):
				interaction["cell"] = _cell_to_dict(new_interaction)
				interactions[interaction_index] = interaction
				updated_interactions += 1
		state["interaction_cells"] = interactions

		var updated_collisions := _shift_collision_cells_for_move(state, old_occupied, new_occupied)
		return {
			"ok": true,
			"place_id": place_id,
			"interaction_cell": _cell_to_dict(new_interaction),
			"interaction_update_count": updated_interactions,
			"collision_update_count": updated_collisions,
			"occupied_cells": new_occupied,
		}
	return {"ok": false, "reason": "unknown_place_id", "place_id": place_id}


func _validate_place_move_candidate(state: Dictionary, moved_place_id: String) -> Array[String]:
	var errors: Array[String] = []
	var protected_cells: Dictionary = {}
	var collision_counts: Dictionary = {}
	for place in state.get("places", []):
		if str(place.get("place_id", "")) == moved_place_id:
			continue
		for occupied in place.get("occupied_cells", []):
			protected_cells[_cell_key(occupied)] = "place:%s" % str(place.get("place_id", ""))
	for collision in state.get("collision_cells", []):
		var collision_key := _cell_key(collision)
		collision_counts[collision_key] = int(collision_counts.get(collision_key, 0)) + 1

	var moved_place := _place_by_id_in_state(state, moved_place_id)
	for occupied in moved_place.get("occupied_cells", []):
		var key := _cell_key(occupied)
		if protected_cells.has(key):
			errors.append("place move occupied overlap: %s at %s with %s" % [moved_place_id, key, protected_cells[key]])
		if int(collision_counts.get(key, 0)) > 1:
			errors.append("place move collision overlap: %s at %s" % [moved_place_id, key])
	return errors


func _place_by_id_in_state(state: Dictionary, place_id: String) -> Dictionary:
	for place in state.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			return place
	return {}


func _shift_collision_cells_for_move(state: Dictionary, old_occupied: Array, new_occupied: Array) -> int:
	var old_to_new: Dictionary = {}
	for index in range(min(old_occupied.size(), new_occupied.size())):
		old_to_new[_cell_key(old_occupied[index])] = new_occupied[index]
	var updated := 0
	var collisions: Array = state.get("collision_cells", [])
	for index in range(collisions.size()):
		var key := _cell_key(collisions[index])
		if old_to_new.has(key):
			collisions[index] = old_to_new[key]
			updated += 1
	state["collision_cells"] = collisions
	return updated


func _occupied_cells_for(cell: Vector2i, footprint: Vector2i) -> Array:
	var cells: Array = []
	for y in range(footprint.y):
		for x in range(footprint.x):
			cells.append(_cell_to_dict(Vector2i(cell.x + x, cell.y + y)))
	return cells


func _editable_fields_for_selection() -> Array[String]:
	if selected_runtime_type == "place":
		return ["label", "place_type", "district_id", "place_action", "size_w", "size_h"]
	if selected_runtime_type == "resource":
		return ["display_name", "quantity", "item_id"]
	if selected_runtime_type == "npc_routine":
		return ["label"]
	if selected_runtime_type == "story_prop":
		return ["child_label"]
	if selected_runtime_type == "anchor":
		return ["cell_x", "cell_y"]
	return []


func _update_place_field(place_id: String, field_name: String, value: Variant) -> Dictionary:
	var index := _find_place_index(place_id)
	if index < 0:
		return {"ok": false, "reason": "unknown_place_id", "place_id": place_id}
	var places: Array = editor_state.get("places", [])
	var place: Dictionary = places[index]
	if field_name == "label":
		place["label"] = str(value)
	elif field_name == "place_type":
		place["place_type"] = str(value)
	elif field_name == "district_id":
		place["district_id"] = str(value)
	elif field_name == "place_action":
		place["place_action"] = str(value)
		_update_interaction_action_for_place(place_id, str(value))
	elif field_name in ["size_w", "size_h"]:
		var size := _size_to_footprint(place.get("size", {}))
		if field_name == "size_w":
			size.x = max(1, int(value))
		else:
			size.y = max(1, int(value))
		var position := _dict_to_cell(place.get("position", {}))
		place["size"] = {"w": size.x, "h": size.y}
		place["occupied_cells"] = _occupied_cells_for(position, size)
	else:
		return {"ok": false, "reason": "unsupported_field", "field": field_name}
	places[index] = place
	editor_state["places"] = places
	var exported: Dictionary = MapEditorSyncServiceScript.export_to_dictionary(editor_state)
	if not exported.get("ok", false):
		return {"ok": false, "reason": "validation_failed", "errors": exported.get("errors", [])}
	_refresh_place_marker(place_id)
	_refresh_validation_panel(false, ["not_validated"])
	_refresh_inspector()
	return {"ok": true, "place_id": place_id, "field": field_name}


func _update_resource_field(point_id: String, field_name: String, value: Variant) -> Dictionary:
	var index := _find_resource_index(point_id)
	if index < 0:
		return {"ok": false, "reason": "unknown_resource_id", "point_id": point_id}
	var candidate := resource_points_state.duplicate(true)
	var points: Array = candidate.get("resource_points", [])
	var point: Dictionary = points[index]
	if field_name == "display_name":
		point["display_name"] = str(value)
	elif field_name == "item_id":
		point["item_id"] = str(value)
	elif field_name == "quantity":
		point["quantity"] = max(1, int(value))
	else:
		return {"ok": false, "reason": "unsupported_field", "field": field_name}
	points[index] = point
	candidate["resource_points"] = points
	var errors: Array[String] = MapEditorSyncServiceScript.validate_resource_points(candidate, editor_state)
	if not errors.is_empty():
		return {"ok": false, "reason": "validation_failed", "errors": errors}
	resource_points_state = candidate
	_rebuild_resource_layer()
	select_marker("resource", point_id)
	last_resource_validation_result = {"ok": false, "errors": ["not_validated"], "wrote_file": false}
	_refresh_side_status()
	return {"ok": true, "point_id": point_id, "field": field_name}


func _update_npc_field(routine_id: String, field_name: String, value: Variant) -> Dictionary:
	if field_name != "label":
		return {"ok": false, "reason": "unsupported_field", "field": field_name}
	var location := _find_routine_location(routine_id, current_day_key)
	if int(location.get("day_index", -1)) < 0:
		return {"ok": false, "reason": "unknown_routine_id", "routine_id": routine_id}
	var days: Array = npc_routine_state.get("routine_days", [])
	var day: Dictionary = days[int(location["day_index"])]
	var npcs: Array = day.get("npcs", [])
	var npc: Dictionary = npcs[int(location["npc_index"])]
	npc["label"] = str(value)
	npcs[int(location["npc_index"])] = npc
	day["npcs"] = npcs
	days[int(location["day_index"])] = day
	npc_routine_state["routine_days"] = days
	last_routine_validation_result = {"ok": false, "errors": ["not_validated"], "wrote_file": false}
	_refresh_inspector()
	_refresh_side_status()
	return {"ok": true, "routine_id": routine_id, "field": field_name}


func _update_story_prop_field(story_prop_id: String, field_name: String, value: Variant) -> Dictionary:
	if field_name != "child_label":
		return {"ok": false, "reason": "unsupported_field", "field": field_name}
	var candidate := story_props_state.duplicate(true)
	var props: Array = candidate.get("story_props", [])
	for index in range(props.size()):
		var prop: Dictionary = props[index]
		if str(prop.get("story_prop_id", "")) != story_prop_id:
			continue
		prop["child_label"] = str(value)
		props[index] = prop
		candidate["story_props"] = props
		var errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(candidate, editor_state)
		if not errors.is_empty():
			return {"ok": false, "reason": "validation_failed", "errors": errors}
		story_props_state = candidate
		_rebuild_story_prop_layer()
		select_marker("story_prop", story_prop_id)
		return {"ok": true, "story_prop_id": story_prop_id, "field": field_name}
	return {"ok": false, "reason": "unknown_story_prop_id", "story_prop_id": story_prop_id}


func _update_anchor_cell_field(anchor_id: String, field_name: String, value: Variant) -> Dictionary:
	var anchor := _anchor_by_id(anchor_id)
	if anchor.is_empty():
		return {"ok": false, "reason": "unknown_anchor_id", "anchor_id": anchor_id, "field": field_name}
	var cell := _dict_to_cell(anchor.get("position", {}))
	if field_name == "cell_x":
		cell.x = int(value)
	elif field_name == "cell_y":
		cell.y = int(value)
	else:
		return {"ok": false, "reason": "unsupported_field", "field": field_name}
	return move_anchor_marker_candidate(anchor_id, cell)


func _refresh_place_marker(place_id: String) -> void:
	var marker := _find_marker("place", place_id)
	var place := _place_by_id_in_state(editor_state, place_id)
	if marker != null and not place.is_empty():
		marker.set("display_label", str(place.get("label", "")))
		marker.set("footprint", _size_to_footprint(place.get("size", {})))
		marker.set("cell", _dict_to_cell(place.get("position", {})))


func _refresh_inspector() -> void:
	if inspector_title_label == null or inspector_body_label == null:
		return
	if selected_stable_id.is_empty():
		inspector_title_label.text = "No selection"
		inspector_body_label.text = "Select a marker to inspect editable fields."
		_refresh_inspector_fields()
		return
	inspector_title_label.text = "%s: %s" % [selected_runtime_type, selected_stable_id]
	inspector_body_label.text = _selection_body_text()
	_refresh_inspector_fields()


func _refresh_inspector_fields() -> void:
	if inspector_fields_grid == null:
		return
	inspector_field_inputs.clear()
	for child in inspector_fields_grid.get_children():
		inspector_fields_grid.remove_child(child)
		child.queue_free()
	var fields := _editable_fields_for_selection()
	if selected_stable_id.is_empty() or fields.is_empty():
		if inspector_apply_button != null:
			inspector_apply_button.disabled = true
		return
	for field_name in fields:
		var label := Label.new()
		label.text = field_name
		label.clip_text = true
		label.custom_minimum_size = Vector2(76, 22)
		inspector_fields_grid.add_child(label)
		var input := LineEdit.new()
		input.name = "Field_%s" % field_name
		input.text = str(_field_value_for_selection(field_name))
		input.custom_minimum_size = Vector2(118, 22)
		input.tooltip_text = "Edit %s for %s" % [field_name, selected_stable_id]
		inspector_fields_grid.add_child(input)
		inspector_field_inputs[field_name] = input
	if inspector_apply_button != null:
		inspector_apply_button.disabled = false


func _selection_field_values() -> Dictionary:
	var values: Dictionary = {}
	for field_name in _editable_fields_for_selection():
		values[field_name] = _field_value_for_selection(field_name)
	return values


func _field_value_for_selection(field_name: String) -> Variant:
	if selected_runtime_type == "place":
		var place := _place_by_id_in_state(editor_state, selected_stable_id)
		if field_name == "label" or field_name == "place_type" or field_name == "district_id":
			return place.get(field_name, "")
		if field_name == "place_action":
			return place.get("place_action", "")
		if field_name == "size_w":
			return _size_to_footprint(place.get("size", {})).x
		if field_name == "size_h":
			return _size_to_footprint(place.get("size", {})).y
	if selected_runtime_type == "resource":
		var point := _resource_by_id(selected_stable_id)
		return point.get(field_name, "")
	if selected_runtime_type == "npc_routine":
		var npc := _routine_by_id(selected_stable_id, current_day_key)
		return npc.get(field_name, "")
	if selected_runtime_type == "story_prop":
		var prop := _story_prop_by_id(selected_stable_id)
		return prop.get(field_name, "")
	if selected_runtime_type == "anchor":
		var anchor := _anchor_by_id(selected_stable_id)
		var cell := _dict_to_cell(anchor.get("position", {}))
		if field_name == "cell_x":
			return cell.x
		if field_name == "cell_y":
			return cell.y
	return ""


func _selection_body_text() -> String:
	if selected_runtime_type == "place":
		var place := _place_by_id_in_state(editor_state, selected_stable_id)
		return "label=%s\nplace_type=%s\ndistrict_id=%s\nplace_action=%s\nsize=%s\nfields=%s" % [place.get("label", ""), place.get("place_type", ""), place.get("district_id", ""), place.get("place_action", ""), str(place.get("size", {})), ", ".join(_editable_fields_for_selection())]
	if selected_runtime_type == "resource":
		var point := _resource_by_id(selected_stable_id)
		return "display_name=%s\nitem_id=%s\nquantity=%s\ncell=%s\nfields=%s" % [point.get("display_name", ""), point.get("item_id", ""), str(point.get("quantity", "")), str(point.get("cell", {})), ", ".join(_editable_fields_for_selection())]
	if selected_runtime_type == "npc_routine":
		var npc := _routine_by_id(selected_stable_id, current_day_key)
		return "day_key=%s\nnpc_id=%s\nlabel=%s\ncell=%s\nfields=%s" % [current_day_key, npc.get("npc_id", ""), npc.get("label", ""), str(npc.get("cell", {})), ", ".join(_editable_fields_for_selection())]
	if selected_runtime_type == "story_prop":
		var prop := _story_prop_by_id(selected_stable_id)
		return "place_id=%s\nasset=%s\nlabel=%s\ncell=%s\nfields=%s" % [prop.get("place_id", ""), prop.get("logical_asset_id", ""), prop.get("child_label", ""), str(prop.get("cell", {})), ", ".join(_editable_fields_for_selection())]
	if selected_runtime_type == "anchor":
		var anchor := _anchor_by_id(selected_stable_id)
		return "letter=%s\ncore_word=%s\nroute_order=%s\ncell=%s\nlocked=%s" % [anchor.get("letter", ""), anchor.get("core_word", ""), str(anchor.get("route_order", "")), str(anchor.get("position", {})), ", ".join(LOCKED_ANCHOR_FIELDS)]
	return ""


func _set_editor_status(text: String) -> void:
	if editor_status_label != null:
		editor_status_label.text = text


func _refresh_side_status() -> void:
	if resource_status_label != null:
		resource_status_label.text = "Resources: %s" % ("valid" if bool(last_resource_validation_result.get("ok", false)) else str(last_resource_validation_result.get("errors", ["not_validated"])))
	if routine_status_label != null:
		routine_status_label.text = "Routines: %s" % ("valid" if bool(last_routine_validation_result.get("ok", false)) else str(last_routine_validation_result.get("errors", ["not_validated"])))


func _on_validate_export_pressed() -> void:
	validate_export_candidate()


func _refresh_validation_panel(ok: bool, errors: Array) -> void:
	if validation_status_label == null or validation_errors_label == null:
		return
	if errors.size() == 1 and str(errors[0]) == "not_validated":
		validation_status_label.text = "Export not validated yet"
		validation_errors_label.text = "Press Validate to review the candidate map."
		return
	if ok:
		validation_status_label.text = "Candidate map is valid"
		validation_errors_label.text = "No errors found. JSON was not written."
		return
	validation_status_label.text = "Candidate map has %d issue(s)" % errors.size()
	var lines: Array[String] = []
	for error in errors:
		lines.append("- %s" % str(error))
	validation_errors_label.text = "\n".join(lines)


func _on_tool_mode_selected(index: int) -> void:
	if tool_mode_option == null:
		return
	var mode := str(tool_mode_option.get_item_metadata(index))
	set_tool_mode(mode)


func _on_layer_toggle_toggled(pressed: bool, layer_key: String) -> void:
	toggle_layer(layer_key, pressed)


func _on_inspector_apply_pressed() -> void:
	var values: Dictionary = {}
	for field_name in inspector_field_inputs.keys():
		var input := inspector_field_inputs[field_name] as LineEdit
		if input != null:
			values[str(field_name)] = input.text
	var result := apply_inspector_field_values(values)
	if not result.get("ok", false):
		_set_editor_status("Edit rejected: %s" % result.get("reason", "unknown"))


func _on_marker_selected(runtime_type: String, stable_id: String) -> void:
	select_marker(runtime_type, stable_id)


func _on_marker_drag_finished(runtime_type: String, stable_id: String, from_cell: Vector2i, to_cell: Vector2i) -> void:
	_commit_marker_drag(runtime_type, stable_id, from_cell, to_cell)


func _commit_marker_drag(runtime_type: String, stable_id: String, from_cell: Vector2i, to_cell: Vector2i) -> Dictionary:
	var result: Dictionary = {}
	if runtime_type == "place":
		result = move_place_marker_candidate(stable_id, to_cell)
	elif runtime_type == "resource":
		result = move_resource_marker_candidate(stable_id, to_cell)
	elif runtime_type == "npc_routine":
		result = move_npc_routine_candidate(stable_id, to_cell)
	elif runtime_type == "story_prop":
		result = move_story_prop_marker_candidate(stable_id, to_cell)
	elif runtime_type == "anchor":
		result = move_anchor_marker_candidate(stable_id, to_cell)
	else:
		result = {"ok": false, "reason": "unsupported_marker_drag", "runtime_type": runtime_type}
	if not result.get("ok", false):
		var marker := _find_marker(runtime_type, stable_id)
		if marker != null:
			marker.call("set_cell", from_cell)
		_set_editor_status("Move rejected: %s" % result.get("reason", "unknown"))
	else:
		_set_editor_status("Moved %s %s" % [runtime_type, stable_id])
		select_marker(runtime_type, stable_id)
	return result


func _clear_marker_selection() -> void:
	for layer in [place_marker_layer, anchor_marker_layer, resource_marker_layer, npc_spawn_layer, story_prop_marker_layer]:
		for child in layer.get_children():
			if child.has_method("set_selected"):
				child.call("set_selected", false)


func _resource_by_id(point_id: String) -> Dictionary:
	for point in resource_points_state.get("resource_points", []):
		if point is Dictionary and str((point as Dictionary).get("point_id", "")) == point_id:
			return point
	return {}


func _story_prop_by_id(story_prop_id: String) -> Dictionary:
	for prop in story_props_state.get("story_props", []):
		if prop is Dictionary and str((prop as Dictionary).get("story_prop_id", "")) == story_prop_id:
			return prop
	return {}


func _routine_by_id(routine_id: String, day_key: String) -> Dictionary:
	var day := _routine_day_by_key(day_key)
	for npc in day.get("npcs", []):
		if npc is Dictionary and str((npc as Dictionary).get("routine_id", "")) == routine_id:
			return npc
	return {}


func _anchor_by_id(anchor_id: String) -> Dictionary:
	for anchor in editor_state.get("memory_anchors", []):
		if anchor is Dictionary and str((anchor as Dictionary).get("anchor_id", "")) == anchor_id:
			return anchor
	return {}


func _locked_anchor_snapshot(anchor: Dictionary) -> Dictionary:
	var snapshot: Dictionary = {}
	for field in LOCKED_ANCHOR_FIELDS:
		snapshot[field] = anchor.get(field)
	return snapshot


func _validate_anchor_migration(state: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var anchors: Array = state.get("memory_anchors", [])
	if anchors.size() != 26:
		errors.append("anchor migration must keep 26 anchors")
	var seen_letters: Dictionary = {}
	var seen_orders: Dictionary = {}
	for anchor in anchors:
		if not anchor is Dictionary:
			errors.append("anchor migration has non-dictionary anchor")
			continue
		var letter := str((anchor as Dictionary).get("letter", ""))
		var order := int((anchor as Dictionary).get("route_order", 0))
		if seen_letters.has(letter):
			errors.append("anchor migration duplicate letter: %s" % letter)
		seen_letters[letter] = true
		if seen_orders.has(order):
			errors.append("anchor migration duplicate route_order: %s" % order)
		seen_orders[order] = true
	return errors


func _protected_cell_reason(cell: Vector2i, layer_key: String) -> String:
	var key := _cell_key(_cell_to_dict(cell))
	for anchor in editor_state.get("memory_anchors", []):
		if anchor is Dictionary and _cell_key((anchor as Dictionary).get("position", {})) == key:
			return "anchor:%s" % str((anchor as Dictionary).get("anchor_id", ""))
	for place in editor_state.get("places", []):
		if not place is Dictionary:
			continue
		for occupied in (place as Dictionary).get("occupied_cells", []):
			if _cell_key(occupied) == key:
				return "place:%s" % str((place as Dictionary).get("place_id", ""))
	for point in resource_points_state.get("resource_points", []):
		if point is Dictionary and _cell_key((point as Dictionary).get("cell", {})) == key:
			return "resource:%s" % str((point as Dictionary).get("point_id", ""))
	for day in npc_routine_state.get("routine_days", []):
		if not day is Dictionary:
			continue
		for npc in (day as Dictionary).get("npcs", []):
			if npc is Dictionary and _cell_key((npc as Dictionary).get("cell", {})) == key:
				return "npc:%s" % str((npc as Dictionary).get("routine_id", ""))
	if layer_key != "interaction":
		for interaction in editor_state.get("interaction_cells", []):
			if interaction is Dictionary and _cell_key((interaction as Dictionary).get("cell", {})) == key:
				return "interaction:%s" % str((interaction as Dictionary).get("interaction_id", ""))
	return ""


func _paint_road_cell(cell: Vector2i, erase: bool) -> void:
	var roads: Array = editor_state.get("roads", [])
	if roads.is_empty():
		roads.append({"road_id": "road_authoring_paint", "label": "Authoring Paint Road", "road_type": "authoring", "cells": []})
	var key := _cell_key(_cell_to_dict(cell))
	for index in range(roads.size()):
		var road: Dictionary = roads[index]
		var cells: Array = road.get("cells", [])
		var kept: Array = []
		var found := false
		for existing in cells:
			if _cell_key(existing) == key:
				found = true
				if not erase:
					kept.append(existing)
			else:
				kept.append(existing)
		if index == 0 and not erase and not found:
			kept.append(_cell_to_dict(cell))
		road["cells"] = kept
		roads[index] = road
	editor_state["roads"] = roads


func _paint_collision_cell(cell: Vector2i, erase: bool) -> void:
	var cells: Array = editor_state.get("collision_cells", [])
	editor_state["collision_cells"] = _toggle_cell_array(cells, cell, erase)


func _paint_interaction_cell(cell: Vector2i, erase: bool) -> Dictionary:
	var interactions: Array = editor_state.get("interaction_cells", [])
	var key := _cell_key(_cell_to_dict(cell))
	if erase:
		var kept: Array = []
		for interaction in interactions:
			if _cell_key((interaction as Dictionary).get("cell", {})) != key:
				kept.append(interaction)
		editor_state["interaction_cells"] = kept
		return {"ok": true}
	if selected_runtime_type != "place" or selected_stable_id.is_empty():
		return {"ok": false, "reason": "select_place_before_painting_interaction"}
	var place := _place_by_id_in_state(editor_state, selected_stable_id)
	if place.is_empty():
		return {"ok": false, "reason": "selected_place_missing"}
	for interaction in interactions:
		if _cell_key((interaction as Dictionary).get("cell", {})) == key:
			return {"ok": true}
	interactions.append({
		"interaction_id": "interaction_%s_%d_%d_authoring" % [selected_stable_id, cell.x, cell.y],
		"place_id": selected_stable_id,
		"label": place.get("label", selected_stable_id),
		"cell": _cell_to_dict(cell),
		"action": "look",
	})
	editor_state["interaction_cells"] = interactions
	return {"ok": true}


func _toggle_cell_array(cells: Array, cell: Vector2i, erase: bool) -> Array:
	var key := _cell_key(_cell_to_dict(cell))
	var kept: Array = []
	var found := false
	for existing in cells:
		if _cell_key(existing) == key:
			found = true
			if not erase:
				kept.append(existing)
		else:
			kept.append(existing)
	if not erase and not found:
		kept.append(_cell_to_dict(cell))
	return kept


func _size_to_footprint(size_data: Dictionary) -> Vector2i:
	return Vector2i(max(1, int(size_data.get("w", 1))), max(1, int(size_data.get("h", 1))))


func _dict_to_cell(cell: Dictionary) -> Vector2i:
	return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))


func _cell_to_dict(cell: Vector2i) -> Dictionary:
	return {"x": cell.x, "y": cell.y}


func _same_cell(a: Dictionary, b: Dictionary) -> bool:
	return int(a.get("x", -1)) == int(b.get("x", -2)) and int(a.get("y", -1)) == int(b.get("y", -2))


func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]
