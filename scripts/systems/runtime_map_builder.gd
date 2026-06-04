extends RefCounted
class_name RuntimeMapBuilder

const WORLD_MAP_PATH := "res://data/maps/world_map.json"
const WorldMapContractScript := preload("res://scripts/data/world_map_contract.gd")


static func load_world_map(path: String = WORLD_MAP_PATH) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "errors": ["Unable to open world map: %s" % path], "data": {}}

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {"ok": false, "errors": ["World map root must be a dictionary."], "data": {}}

	var data: Dictionary = parsed
	var errors: Array[String] = WorldMapContractScript.validate_map(data)
	return {"ok": errors.is_empty(), "errors": errors, "data": data}


static func build_summary(data: Dictionary) -> Dictionary:
	return {
		"map_id": data.get("map_id", ""),
		"district_count": data.get("districts", []).size(),
		"road_count": data.get("roads", []).size(),
		"place_count": data.get("places", []).size(),
		"anchor_count": data.get("memory_anchors", []).size(),
	}
