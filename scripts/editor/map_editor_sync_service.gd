extends RefCounted
class_name MapEditorSyncService

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const WorldMapContractScript := preload("res://scripts/data/world_map_contract.gd")

const RESOURCE_POINTS_PATH := "res://data/life/resource_points.json"
const NPC_ROUTINES_PATH := "res://data/life/npc_routines.json"
const LIFE_ITEMS_PATH := "res://data/items/life_items.json"
const KNOWN_NPC_IDS: Array[String] = ["mina", "shopkeeper", "pet_buddy", "bus_helper", "story_bear"]


static func import_from_json(path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH) -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map(path)
	if not result.get("ok", false):
		return {"ok": false, "errors": result.get("errors", []), "state": {}}
	return {"ok": true, "errors": [], "state": result.get("data", {}).duplicate(true)}


static func export_to_dictionary(editor_state: Dictionary) -> Dictionary:
	var exported := editor_state.duplicate(true)
	var errors: Array[String] = WorldMapContractScript.validate_map(exported)
	return {
		"ok": errors.is_empty(),
		"errors": errors,
		"data": exported,
	}


static func export_authoring_scene(authoring_scene: Object) -> Dictionary:
	if authoring_scene == null or not authoring_scene.has_method("export_world_map_dictionary"):
		return {"ok": false, "errors": ["authoring_scene_missing_export"], "data": {}}
	var exported = authoring_scene.call("export_world_map_dictionary")
	if not exported is Dictionary:
		return {"ok": false, "errors": ["authoring_export_not_dictionary"], "data": {}}
	return export_to_dictionary(exported)


static func write_if_valid(editor_state: Dictionary, target_path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH, options: Dictionary = {}) -> Dictionary:
	var exported: Dictionary = export_to_dictionary(editor_state)
	if not exported.get("ok", false):
		return {
			"ok": false,
			"reason": "validation_failed",
			"errors": exported.get("errors", []),
			"written": false,
			"target_path": target_path,
		}
	return write_valid_dictionary(exported.get("data", {}), target_path, options)


static func write_authoring_scene_if_valid(authoring_scene: Object, target_path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH, options: Dictionary = {}) -> Dictionary:
	var exported: Dictionary = export_authoring_scene(authoring_scene)
	if not exported.get("ok", false):
		return {
			"ok": false,
			"reason": "validation_failed",
			"errors": exported.get("errors", []),
			"written": false,
			"target_path": target_path,
		}
	return write_valid_dictionary(exported.get("data", {}), target_path, options)


static func write_valid_dictionary(map_data: Dictionary, target_path: String = RuntimeMapBuilderScript.WORLD_MAP_PATH, options: Dictionary = {}) -> Dictionary:
	var errors: Array[String] = WorldMapContractScript.validate_map(map_data)
	if not errors.is_empty():
		return {
			"ok": false,
			"reason": "validation_failed",
			"errors": errors,
			"written": false,
			"target_path": target_path,
		}
	if bool(options.get("simulate_write_failure", false)):
		return {
			"ok": false,
			"reason": "simulated_write_failure",
			"errors": ["simulated_write_failure"],
			"written": false,
			"target_path": target_path,
		}

	var tmp_path := "%s.tmp" % target_path
	var backup_path := "%s.bak" % target_path
	var payload := JSON.stringify(map_data, "\t")
	var had_original := FileAccess.file_exists(target_path)
	var original_text := _read_text(target_path) if had_original else ""

	var tmp_result := _write_text(tmp_path, payload)
	if not tmp_result.get("ok", false):
		return {
			"ok": false,
			"reason": "temp_write_failed",
			"errors": [tmp_result.get("error", "temp_write_failed")],
			"written": false,
			"target_path": target_path,
		}

	if had_original:
		var backup_result := _write_text(backup_path, original_text)
		if not backup_result.get("ok", false):
			_cleanup_path(tmp_path)
			return {
				"ok": false,
				"reason": "backup_write_failed",
				"errors": [backup_result.get("error", "backup_write_failed")],
				"written": false,
				"target_path": target_path,
				"backup_path": backup_path,
			}

	if bool(options.get("simulate_commit_failure", false)):
		_cleanup_path(tmp_path)
		return {
			"ok": false,
			"reason": "simulated_commit_failure",
			"errors": ["simulated_commit_failure"],
			"written": false,
			"target_path": target_path,
			"backup_path": backup_path if had_original else "",
		}

	if had_original:
		var remove_result := DirAccess.remove_absolute(ProjectSettings.globalize_path(target_path))
		if remove_result != OK:
			_cleanup_path(tmp_path)
			return {
				"ok": false,
				"reason": "target_remove_failed",
				"errors": ["target_remove_failed:%s" % remove_result],
				"written": false,
				"target_path": target_path,
				"backup_path": backup_path,
			}

	var rename_result := DirAccess.rename_absolute(ProjectSettings.globalize_path(tmp_path), ProjectSettings.globalize_path(target_path))
	if rename_result != OK:
		if had_original:
			_write_text(target_path, original_text)
		_cleanup_path(tmp_path)
		return {
			"ok": false,
			"reason": "commit_failed",
			"errors": ["commit_failed:%s" % rename_result],
			"written": false,
			"target_path": target_path,
			"backup_path": backup_path if had_original else "",
		}

	var load_result: Dictionary = RuntimeMapBuilderScript.load_world_map(target_path)
	if not load_result.get("ok", false):
		if had_original:
			_write_text(target_path, original_text)
		return {
			"ok": false,
			"reason": "post_write_load_failed",
			"errors": load_result.get("errors", []),
			"written": false,
			"target_path": target_path,
			"backup_path": backup_path if had_original else "",
		}

	return {
		"ok": true,
		"errors": [],
		"written": true,
		"target_path": target_path,
		"backup_path": backup_path if had_original else "",
		"place_count": load_result.get("data", {}).get("places", []).size(),
		"anchor_count": load_result.get("data", {}).get("memory_anchors", []).size(),
	}


static func load_json_dictionary(path: String) -> Dictionary:
	var text := _read_text(path)
	if text.is_empty():
		return {"ok": false, "errors": ["empty_or_missing_json:%s" % path], "data": {}}
	var parsed: Variant = JSON.parse_string(text)
	if not parsed is Dictionary:
		return {"ok": false, "errors": ["json_root_not_dictionary:%s" % path], "data": {}}
	return {"ok": true, "errors": [], "data": (parsed as Dictionary).duplicate(true)}


static func write_resource_points_if_valid(resource_data: Dictionary, map_data: Dictionary, target_path: String = RESOURCE_POINTS_PATH, options: Dictionary = {}) -> Dictionary:
	var errors: Array[String] = validate_resource_points(resource_data, map_data)
	if not errors.is_empty():
		return {"ok": false, "reason": "validation_failed", "errors": errors, "written": false, "target_path": target_path}
	var write_result := _write_json_dictionary_with_backup(resource_data, target_path, options)
	if not write_result.get("ok", false):
		return write_result
	var reload := load_json_dictionary(target_path)
	if not reload.get("ok", false):
		return {"ok": false, "reason": "post_write_load_failed", "errors": reload.get("errors", []), "written": false, "target_path": target_path}
	return {
		"ok": true,
		"errors": [],
		"written": true,
		"target_path": target_path,
		"backup_path": write_result.get("backup_path", ""),
		"resource_count": (reload.get("data", {}) as Dictionary).get("resource_points", []).size(),
	}


static func write_npc_routines_if_valid(routine_data: Dictionary, map_data: Dictionary, resource_data: Dictionary, target_path: String = NPC_ROUTINES_PATH, options: Dictionary = {}) -> Dictionary:
	var errors: Array[String] = validate_npc_routines(routine_data, map_data, resource_data)
	if not errors.is_empty():
		return {"ok": false, "reason": "validation_failed", "errors": errors, "written": false, "target_path": target_path}
	var write_result := _write_json_dictionary_with_backup(routine_data, target_path, options)
	if not write_result.get("ok", false):
		return write_result
	var reload := load_json_dictionary(target_path)
	if not reload.get("ok", false):
		return {"ok": false, "reason": "post_write_load_failed", "errors": reload.get("errors", []), "written": false, "target_path": target_path}
	return {
		"ok": true,
		"errors": [],
		"written": true,
		"target_path": target_path,
		"backup_path": write_result.get("backup_path", ""),
		"day_count": (reload.get("data", {}) as Dictionary).get("routine_days", []).size(),
	}


static func validate_resource_points(resource_data: Dictionary, map_data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if not resource_data.has("resource_points") or not resource_data.get("resource_points", []) is Array:
		return ["resource_points_missing"]
	var item_ids: Dictionary = _load_item_ids()
	var seen_ids: Dictionary = {}
	var protected: Dictionary = _protected_cells_for_resources(map_data)
	var canvas: Dictionary = map_data.get("canvas_size", {})
	for point_value in resource_data.get("resource_points", []):
		if not point_value is Dictionary:
			errors.append("resource point is not dictionary")
			continue
		var point: Dictionary = point_value
		var point_id := str(point.get("point_id", ""))
		var item_id := str(point.get("item_id", ""))
		var key: String = _cell_key(point.get("cell", {}))
		if point_id.is_empty():
			errors.append("resource has empty point_id")
		elif seen_ids.has(point_id):
			errors.append("duplicate resource point_id: %s" % point_id)
		else:
			seen_ids[point_id] = true
		if not item_ids.has(item_id):
			errors.append("resource has unknown item_id: %s" % point_id)
		if int(point.get("quantity", 0)) <= 0:
			errors.append("resource quantity must be positive: %s" % point_id)
		if not _cell_in_canvas(point.get("cell", {}), canvas):
			errors.append("resource cell outside canvas: %s" % point_id)
		if protected.has(key):
			errors.append("resource cell overlaps protected %s: %s" % [protected[key], point_id])
	return errors


static func validate_npc_routines(routine_data: Dictionary, map_data: Dictionary, resource_data: Dictionary = {}) -> Array[String]:
	var errors: Array[String] = []
	if not routine_data.has("routine_days") or not routine_data.get("routine_days", []) is Array:
		return ["routine_days_missing"]
	var protected: Dictionary = _protected_cells_for_npcs(map_data, resource_data)
	var canvas: Dictionary = map_data.get("canvas_size", {})
	var seen_days: Dictionary = {}
	var seen_routine_ids: Dictionary = {}
	for day_value in routine_data.get("routine_days", []):
		if not day_value is Dictionary:
			errors.append("routine day is not dictionary")
			continue
		var day: Dictionary = day_value
		var day_key := str(day.get("day_key", ""))
		if day_key.is_empty():
			errors.append("routine day has empty day_key")
		elif seen_days.has(day_key):
			errors.append("duplicate routine day_key: %s" % day_key)
		else:
			seen_days[day_key] = true
		for npc_value in day.get("npcs", []):
			if not npc_value is Dictionary:
				errors.append("routine npc is not dictionary: %s" % day_key)
				continue
			var npc: Dictionary = npc_value
			var routine_id := str(npc.get("routine_id", ""))
			var npc_id := str(npc.get("npc_id", ""))
			var key: String = _cell_key(npc.get("cell", {}))
			if routine_id.is_empty():
				errors.append("routine has empty routine_id: %s" % day_key)
			elif seen_routine_ids.has(routine_id):
				errors.append("duplicate routine_id: %s" % routine_id)
			else:
				seen_routine_ids[routine_id] = true
			if not KNOWN_NPC_IDS.has(npc_id):
				errors.append("routine has unknown npc_id: %s" % routine_id)
			if not _cell_in_canvas(npc.get("cell", {}), canvas):
				errors.append("routine cell outside canvas: %s" % routine_id)
			if protected.has(key):
				errors.append("routine cell overlaps protected %s: %s" % [protected[key], routine_id])
	return errors


static func round_trip_state(editor_state: Dictionary) -> Dictionary:
	var exported: Dictionary = export_to_dictionary(editor_state)
	if not exported.get("ok", false):
		return exported
	var data: Dictionary = exported.get("data", {})
	return {
		"ok": true,
		"errors": [],
		"data": data.duplicate(true),
		"place_count": data.get("places", []).size(),
		"anchor_count": data.get("memory_anchors", []).size(),
	}


static func _read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


static func _write_text(path: String, text: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return {"ok": false, "error": "unable_to_open:%s" % path}
	file.store_string(text)
	return {"ok": true}


static func _write_json_dictionary_with_backup(data: Dictionary, target_path: String, options: Dictionary = {}) -> Dictionary:
	if bool(options.get("simulate_write_failure", false)):
		return {"ok": false, "reason": "simulated_write_failure", "errors": ["simulated_write_failure"], "written": false, "target_path": target_path}
	var tmp_path := "%s.tmp" % target_path
	var backup_path := "%s.bak" % target_path
	var payload := JSON.stringify(data, "\t")
	var had_original := FileAccess.file_exists(target_path)
	var original_text := _read_text(target_path) if had_original else ""
	var tmp_result := _write_text(tmp_path, payload)
	if not tmp_result.get("ok", false):
		return {"ok": false, "reason": "temp_write_failed", "errors": [tmp_result.get("error", "temp_write_failed")], "written": false, "target_path": target_path}
	if had_original:
		var backup_result := _write_text(backup_path, original_text)
		if not backup_result.get("ok", false):
			_cleanup_path(tmp_path)
			return {"ok": false, "reason": "backup_write_failed", "errors": [backup_result.get("error", "backup_write_failed")], "written": false, "target_path": target_path, "backup_path": backup_path}
	if bool(options.get("simulate_commit_failure", false)):
		_cleanup_path(tmp_path)
		return {"ok": false, "reason": "simulated_commit_failure", "errors": ["simulated_commit_failure"], "written": false, "target_path": target_path, "backup_path": backup_path if had_original else ""}
	if had_original:
		var remove_result := DirAccess.remove_absolute(ProjectSettings.globalize_path(target_path))
		if remove_result != OK:
			_cleanup_path(tmp_path)
			return {"ok": false, "reason": "target_remove_failed", "errors": ["target_remove_failed:%s" % remove_result], "written": false, "target_path": target_path, "backup_path": backup_path}
	var rename_result := DirAccess.rename_absolute(ProjectSettings.globalize_path(tmp_path), ProjectSettings.globalize_path(target_path))
	if rename_result != OK:
		if had_original:
			_write_text(target_path, original_text)
		_cleanup_path(tmp_path)
		return {"ok": false, "reason": "commit_failed", "errors": ["commit_failed:%s" % rename_result], "written": false, "target_path": target_path, "backup_path": backup_path if had_original else ""}
	return {"ok": true, "errors": [], "written": true, "target_path": target_path, "backup_path": backup_path if had_original else ""}


static func _cleanup_path(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


static func _load_item_ids() -> Dictionary:
	var result := load_json_dictionary(LIFE_ITEMS_PATH)
	var ids: Dictionary = {}
	if not result.get("ok", false):
		return ids
	for item_value in (result.get("data", {}) as Dictionary).get("items", []):
		if item_value is Dictionary:
			ids[str((item_value as Dictionary).get("item_id", ""))] = true
	return ids


static func _protected_cells_for_resources(map_data: Dictionary) -> Dictionary:
	var protected: Dictionary = {}
	for anchor in map_data.get("memory_anchors", []):
		if anchor is Dictionary:
			protected[_cell_key((anchor as Dictionary).get("position", {}))] = "anchor:%s" % str((anchor as Dictionary).get("anchor_id", ""))
	for place in map_data.get("places", []):
		if not place is Dictionary:
			continue
		for cell in (place as Dictionary).get("occupied_cells", []):
			protected[_cell_key(cell)] = "place:%s" % str((place as Dictionary).get("place_id", ""))
	for interaction in map_data.get("interaction_cells", []):
		if interaction is Dictionary:
			protected[_cell_key((interaction as Dictionary).get("cell", {}))] = "interaction:%s" % str((interaction as Dictionary).get("interaction_id", ""))
	for cell in map_data.get("collision_cells", []):
		protected[_cell_key(cell)] = "collision"
	return protected


static func _protected_cells_for_npcs(map_data: Dictionary, resource_data: Dictionary) -> Dictionary:
	var protected := _protected_cells_for_resources(map_data)
	for point in resource_data.get("resource_points", []):
		if point is Dictionary:
			protected[_cell_key((point as Dictionary).get("cell", {}))] = "resource:%s" % str((point as Dictionary).get("point_id", ""))
	return protected


static func _cell_in_canvas(cell: Dictionary, canvas: Dictionary) -> bool:
	var x := int(cell.get("x", -1))
	var y := int(cell.get("y", -1))
	return x >= 0 and y >= 0 and x < int(canvas.get("w", 0)) and y < int(canvas.get("h", 0))


static func _cell_key(cell: Dictionary) -> String:
	return "%d,%d" % [int(cell.get("x", -1)), int(cell.get("y", -1))]
