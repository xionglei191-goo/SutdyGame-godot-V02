@tool
extends Control
class_name TownMapAuthoring

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const MapAuthoringMarkerScene := preload("res://scenes/map_editor/map_authoring_marker.tscn")
const MAP_CELL_SIZE := 18
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

var ground_preview_layer: Control
var road_layer: Control
var collision_layer: Control
var interaction_layer: Control
var place_marker_layer: Control
var anchor_marker_layer: Control
var resource_marker_layer: Control
var npc_spawn_layer: Control
var export_validation_panel: Control
var validate_export_button: Button
var validation_status_label: Label
var validation_errors_label: Label
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
	_rebuild_layers()
	_refresh_validation_panel(false, ["not_validated"])
	return {
		"ok": result.get("ok", false),
		"errors": result.get("errors", []),
		"place_marker_count": place_marker_layer.get_child_count(),
		"anchor_marker_count": anchor_marker_layer.get_child_count(),
		"road_cell_count": road_layer.get_child_count(),
	}


func set_marker_cell_for_test(runtime_type: String, stable_id: String, cell: Vector2i) -> Dictionary:
	var marker := _find_marker(runtime_type, stable_id)
	if marker == null:
		return {"ok": false, "reason": "unknown_marker", "stable_id": stable_id, "runtime_type": runtime_type}
	marker.call("set_cell", cell)
	return {"ok": true, "stable_id": stable_id, "runtime_type": runtime_type, "cell": _cell_to_dict(cell)}


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
	export_validation_panel = get_node("ExportValidationPanel") as Control
	validate_export_button = get_node("ExportValidationPanel/VBox/ValidateExportButton") as Button
	validation_status_label = get_node("ExportValidationPanel/VBox/ValidationStatusLabel") as Label
	validation_errors_label = get_node("ExportValidationPanel/VBox/ValidationErrorsLabel") as Label
	if not validate_export_button.pressed.is_connected(_on_validate_export_pressed):
		validate_export_button.pressed.connect(_on_validate_export_pressed)


func _rebuild_layers() -> void:
	for layer in [road_layer, collision_layer, interaction_layer, place_marker_layer, anchor_marker_layer, resource_marker_layer, npc_spawn_layer]:
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
	for place in editor_state.get("places", []):
		place_marker_layer.add_child(_marker("place", str(place.get("place_id", "")), str(place.get("label", "")), _dict_to_cell(place.get("position", {})), _size_to_footprint(place.get("size", {}))))
	for anchor in editor_state.get("memory_anchors", []):
		anchor_marker_layer.add_child(_marker("anchor", str(anchor.get("anchor_id", "")), str(anchor.get("letter", "")), _dict_to_cell(anchor.get("position", {})), Vector2i.ONE))


func _marker(runtime_type: String, stable_id: String, label: String, cell: Vector2i, footprint: Vector2i) -> Control:
	var marker := MapAuthoringMarkerScene.instantiate() as Control
	marker.set("runtime_type", runtime_type)
	marker.set("stable_id", stable_id)
	marker.set("display_label", label)
	marker.set("cell_size", MAP_CELL_SIZE)
	marker.set("footprint", footprint)
	marker.set("cell", cell)
	return marker


func _cell_rect(prefix: String, cell: Vector2i, color: Color) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = "%s_%d_%d" % [prefix, cell.x, cell.y]
	rect.position = Vector2(cell.x * MAP_CELL_SIZE + 2, cell.y * MAP_CELL_SIZE + 2)
	rect.size = Vector2(MAP_CELL_SIZE - 4, MAP_CELL_SIZE - 4)
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


func _find_marker(runtime_type: String, stable_id: String) -> Control:
	var layer := place_marker_layer if runtime_type == "place" else anchor_marker_layer
	for child in layer.get_children():
		if str(child.get("runtime_type")) == runtime_type and str(child.get("stable_id")) == stable_id:
			return child as Control
	return null


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
