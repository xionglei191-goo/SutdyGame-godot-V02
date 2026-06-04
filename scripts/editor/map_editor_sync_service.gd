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
