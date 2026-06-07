extends RefCounted
class_name MapEditorSyncService

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const WorldMapContractScript := preload("res://scripts/data/world_map_contract.gd")


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


static func _cleanup_path(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
