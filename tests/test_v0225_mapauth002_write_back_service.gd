extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

const TARGET_PATH := "user://test_v0225_mapauth002_world_map.json"

var failures: Array[String] = []


func _init() -> void:
	_cleanup()
	var real_world_before := _read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var source_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(source_result.get("ok", false), "MAPAUTH-002 should load source world_map")
	var source_map: Dictionary = source_result.get("data", {}).duplicate(true)

	_check_valid_write_and_runtime_load(source_map)
	_check_invalid_write_does_not_touch_target(source_map)
	_check_commit_failure_preserves_target(source_map)
	_expect(_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == real_world_before, "MAPAUTH-002 tests should not alter runtime world_map.json")

	_cleanup()
	_finish()


func _check_valid_write_and_runtime_load(source_map: Dictionary) -> void:
	var seed_result: Dictionary = MapEditorSyncServiceScript.write_valid_dictionary(source_map, TARGET_PATH)
	_expect(seed_result.get("ok", false), "MAPAUTH-002 should seed temporary target with valid source map")
	var original_text := _read_text(TARGET_PATH)
	_expect(not original_text.is_empty(), "MAPAUTH-002 seed target should contain JSON")

	var valid_candidate := source_map.duplicate(true)
	valid_candidate["version"] = "mapauth002_valid_write"
	var write_result: Dictionary = MapEditorSyncServiceScript.write_if_valid(valid_candidate, TARGET_PATH)
	_expect(write_result.get("ok", false), "MAPAUTH-002 valid candidate should write")
	_expect(bool(write_result.get("written", false)), "MAPAUTH-002 valid write should report written=true")
	_expect(int(write_result.get("anchor_count", 0)) == 26, "MAPAUTH-002 valid write should preserve 26 A-Z anchors")
	_expect(FileAccess.file_exists(TARGET_PATH + ".bak"), "MAPAUTH-002 valid write should create backup when replacing existing file")
	_expect(_read_text(TARGET_PATH + ".bak") == original_text, "MAPAUTH-002 backup should preserve previous target text")
	var loaded: Dictionary = RuntimeMapBuilderScript.load_world_map(TARGET_PATH)
	_expect(loaded.get("ok", false), "MAPAUTH-002 written target should load through RuntimeMapBuilder")
	_expect(str(loaded.get("data", {}).get("version", "")) == "mapauth002_valid_write", "MAPAUTH-002 written target should contain candidate payload")


func _check_invalid_write_does_not_touch_target(source_map: Dictionary) -> void:
	var before_text := _read_text(TARGET_PATH)
	var invalid_candidate := source_map.duplicate(true)
	var anchors: Array = invalid_candidate.get("memory_anchors", [])
	if not anchors.is_empty() and anchors[0] is Dictionary:
		(anchors[0] as Dictionary)["route_order"] = 99
	invalid_candidate["memory_anchors"] = anchors
	var write_result: Dictionary = MapEditorSyncServiceScript.write_if_valid(invalid_candidate, TARGET_PATH)
	_expect(not write_result.get("ok", true), "MAPAUTH-002 invalid candidate should fail")
	_expect(str(write_result.get("reason", "")) == "validation_failed", "MAPAUTH-002 invalid candidate should fail before writing")
	_expect(not bool(write_result.get("written", true)), "MAPAUTH-002 invalid candidate should report written=false")
	_expect(_read_text(TARGET_PATH) == before_text, "MAPAUTH-002 invalid candidate should not alter target")
	_expect(not FileAccess.file_exists(TARGET_PATH + ".tmp"), "MAPAUTH-002 invalid candidate should not leave temp file")


func _check_commit_failure_preserves_target(source_map: Dictionary) -> void:
	var before_text := _read_text(TARGET_PATH)
	var valid_candidate := source_map.duplicate(true)
	valid_candidate["version"] = "mapauth002_should_not_commit"
	var write_result: Dictionary = MapEditorSyncServiceScript.write_if_valid(valid_candidate, TARGET_PATH, {"simulate_commit_failure": true})
	_expect(not write_result.get("ok", true), "MAPAUTH-002 simulated commit failure should fail")
	_expect(str(write_result.get("reason", "")) == "simulated_commit_failure", "MAPAUTH-002 should expose simulated commit failure reason")
	_expect(not bool(write_result.get("written", true)), "MAPAUTH-002 simulated commit failure should report written=false")
	_expect(_read_text(TARGET_PATH) == before_text, "MAPAUTH-002 simulated commit failure should preserve target")
	_expect(not FileAccess.file_exists(TARGET_PATH + ".tmp"), "MAPAUTH-002 simulated commit failure should clean temp file")
	var loaded: Dictionary = RuntimeMapBuilderScript.load_world_map(TARGET_PATH)
	_expect(loaded.get("ok", false), "MAPAUTH-002 target should still load after simulated failure")
	_expect(int(loaded.get("data", {}).get("memory_anchors", []).size()) == 26, "MAPAUTH-002 target should keep 26 A-Z anchors after simulated failure")


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
		print("V02.25 MAPAUTH-002 WRITE-BACK SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
