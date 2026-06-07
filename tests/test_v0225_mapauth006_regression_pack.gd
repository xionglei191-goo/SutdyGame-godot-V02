extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

const TARGET_PATH := "user://test_v0225_mapauth006_world_map.json"

var failures: Array[String] = []


func _init() -> void:
	_cleanup()
	var original_text := _read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var moved: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "MAPAUTH-006 should prepare a valid linked move candidate")
	_expect(int(moved.get("collision_update_count", 0)) >= 6, "MAPAUTH-006 linked move should update collision cells")
	var write_result: Dictionary = MapEditorSyncServiceScript.write_authoring_scene_if_valid(scene, TARGET_PATH)
	_expect(write_result.get("ok", false), "MAPAUTH-006 valid authoring scene should write temp target: %s" % [write_result.get("errors", [])])
	_expect(bool(write_result.get("written", false)), "MAPAUTH-006 valid authoring write should report written")
	_expect(int(write_result.get("anchor_count", 0)) == 26, "MAPAUTH-006 valid write should preserve 26 A-Z anchors")
	var loaded: Dictionary = RuntimeMapBuilderScript.load_world_map(TARGET_PATH)
	_expect(loaded.get("ok", false), "MAPAUTH-006 written temp map should load through RuntimeMapBuilder")
	var home_place: Dictionary = _place_by_id(loaded.get("data", {}), "place_home")
	_expect(_cell_key(home_place.get("position", {})) == "30,17", "MAPAUTH-006 written temp map should include linked Home move")
	_expect(_cell_key(home_place.get("interaction_cell", {})) == "32,19", "MAPAUTH-006 written temp map should include linked Home interaction")

	var before_invalid := _read_text(TARGET_PATH)
	var raw_invalid: Dictionary = scene.call("set_marker_cell_for_test", "place", "place_home", Vector2i(-5, -5))
	_expect(raw_invalid.get("ok", false), "MAPAUTH-006 should still allow raw invalid candidate setup for regression")
	var invalid_result: Dictionary = MapEditorSyncServiceScript.write_authoring_scene_if_valid(scene, TARGET_PATH)
	_expect(not invalid_result.get("ok", true), "MAPAUTH-006 invalid authoring scene should not write")
	_expect(str(invalid_result.get("reason", "")) == "validation_failed", "MAPAUTH-006 invalid write should fail at validation")
	_expect(not bool(invalid_result.get("written", true)), "MAPAUTH-006 invalid write should report written=false")
	_expect(_read_text(TARGET_PATH) == before_invalid, "MAPAUTH-006 invalid write should preserve temp target")
	_expect(not FileAccess.file_exists(TARGET_PATH + ".tmp"), "MAPAUTH-006 invalid write should not leave temp file")
	_expect(_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == original_text, "MAPAUTH-006 regression pack should leave runtime world_map.json unchanged")

	root.remove_child(scene)
	scene.queue_free()
	_cleanup()
	_finish()


func _place_by_id(map_data: Dictionary, place_id: String) -> Dictionary:
	for place in map_data.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			return place
	return {}


func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]


func _read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


func _cleanup() -> void:
	for path in [TARGET_PATH, TARGET_PATH + ".tmp", TARGET_PATH + ".bak"]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _finish() -> void:
	if failures.is_empty():
		print("V02.25 MAPAUTH-006 REGRESSION PACK TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
