extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var original_text := _read_world_map_text()
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var before_export: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(before_export.get("ok", false), "MAPAUTH-005 initial export should be valid: %s" % [before_export.get("errors", [])])
	var home_before: Dictionary = _place_by_id(before_export.get("data", {}), "place_home")
	_expect(_cell_key(home_before.get("position", {})) == "29,17", "MAPAUTH-005 should start from expected Home position")
	_expect(_cell_key(home_before.get("interaction_cell", {})) == "31,19", "MAPAUTH-005 should start from expected Home interaction")

	var moved: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "MAPAUTH-005 should move Home with linkage")
	_expect(_cell_key(moved.get("interaction_cell", {})) == "32,19", "MAPAUTH-005 move should preserve Home interaction offset")
	_expect(int(moved.get("interaction_update_count", 0)) >= 1, "MAPAUTH-005 move should update primary interaction cell")
	_expect(int(moved.get("collision_update_count", 0)) >= 6, "MAPAUTH-005 move should update linked collision cells")

	var after_move_export: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(after_move_export.get("ok", false), "MAPAUTH-005 export after valid move should pass: %s" % [after_move_export.get("errors", [])])
	var home_after: Dictionary = _place_by_id(after_move_export.get("data", {}), "place_home")
	_expect(_cell_key(home_after.get("position", {})) == "30,17", "MAPAUTH-005 exported Home position should move")
	_expect(_cell_key(home_after.get("interaction_cell", {})) == "32,19", "MAPAUTH-005 exported Home interaction should move with place")
	_expect(_has_occupied_cell(home_after, "30,17"), "MAPAUTH-005 occupied cells should shift to new Home origin")
	_expect(_has_occupied_cell(home_after, "32,18"), "MAPAUTH-005 occupied cells should preserve Home footprint")
	_expect(_has_interaction_cell(after_move_export.get("data", {}), "place_home", "32,19"), "MAPAUTH-005 top-level primary interaction should move")
	_expect(_has_collision_cell(after_move_export.get("data", {}), "32,18"), "MAPAUTH-005 collision cells should shift with Home footprint")
	_expect(int(after_move_export.get("data", {}).get("memory_anchors", []).size()) == 26, "MAPAUTH-005 valid move should preserve 26 anchors")

	var invalid_move: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(-5, -5))
	_expect(not invalid_move.get("ok", true), "MAPAUTH-005 should reject invalid move outside district")
	_expect(["validation_failed", "move_validation_failed"].has(str(invalid_move.get("reason", ""))), "MAPAUTH-005 invalid move should expose validation reason")
	var after_invalid_export: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(after_invalid_export.get("ok", false), "MAPAUTH-005 export after rejected move should remain valid")
	var home_after_invalid: Dictionary = _place_by_id(after_invalid_export.get("data", {}), "place_home")
	_expect(_cell_key(home_after_invalid.get("position", {})) == "30,17", "MAPAUTH-005 rejected move should leave candidate at last valid position")
	_expect(_cell_key(home_after_invalid.get("interaction_cell", {})) == "32,19", "MAPAUTH-005 rejected move should leave interaction at last valid position")

	var unknown_move: Dictionary = scene.call("move_place_marker_candidate", "place_missing_authoring", Vector2i(30, 17))
	_expect(not unknown_move.get("ok", true), "MAPAUTH-005 should reject moving unknown place")
	_expect(str(unknown_move.get("reason", "")) == "unknown_place_id", "MAPAUTH-005 unknown move should name reason")

	var validation: Dictionary = scene.call("validate_export_candidate")
	_expect(validation.get("ok", false), "MAPAUTH-005 validation should pass after valid move and rejected move")
	_expect(not bool(validation.get("wrote_file", true)), "MAPAUTH-005 validation should not write JSON")
	_expect(_read_world_map_text() == original_text, "MAPAUTH-005 move loop should leave runtime world_map.json unchanged")

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _place_by_id(map_data: Dictionary, place_id: String) -> Dictionary:
	for place in map_data.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			return place
	return {}


func _has_occupied_cell(place: Dictionary, key: String) -> bool:
	for cell in place.get("occupied_cells", []):
		if _cell_key(cell) == key:
			return true
	return false


func _has_interaction_cell(map_data: Dictionary, place_id: String, key: String) -> bool:
	for interaction in map_data.get("interaction_cells", []):
		if str(interaction.get("place_id", "")) == place_id and _cell_key(interaction.get("cell", {})) == key:
			return true
	return false


func _has_collision_cell(map_data: Dictionary, key: String) -> bool:
	for cell in map_data.get("collision_cells", []):
		if _cell_key(cell) == key:
			return true
	return false


func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]


func _read_world_map_text() -> String:
	var file := FileAccess.open(RuntimeMapBuilderScript.WORLD_MAP_PATH, FileAccess.READ)
	_expect(file != null, "MAPAUTH-005 should read world_map.json")
	if file == null:
		return ""
	return file.get_as_text()


func _finish() -> void:
	if failures.is_empty():
		print("V02.25 MAPAUTH-005 PLACE MOVE LINKAGE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
