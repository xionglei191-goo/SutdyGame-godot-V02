extends SceneTree

const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

const TARGET_PATH := "user://test_v027_mapeditor_resource_points.json"

var failures: Array[String] = []


func _init() -> void:
	_cleanup()
	var real_before := _read_text(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	_expect(scene.call("select_marker", "resource", "resource_branch_bear_corner").get("ok", false), "MAPEDITOR-005 should select resource marker")
	_expect(scene.call("update_selected_field", "display_name", "测试树枝").get("ok", false), "MAPEDITOR-005 should edit display_name")
	_expect(scene.call("update_selected_field", "quantity", 2).get("ok", false), "MAPEDITOR-005 should edit quantity")
	_expect(scene.call("update_selected_field", "item_id", "branch").get("ok", false), "MAPEDITOR-005 should edit item_id when catalog item exists")
	_expect(scene.call("move_resource_marker_candidate", "resource_branch_bear_corner", Vector2i(1, 1)).get("ok", false), "MAPEDITOR-005 should move resource to valid cell")
	var validation: Dictionary = scene.call("validate_resources_candidate")
	_expect(validation.get("ok", false), "MAPEDITOR-005 resource candidate should validate: %s" % [validation.get("errors", [])])
	var saved: Dictionary = scene.call("save_resources_candidate", TARGET_PATH)
	_expect(saved.get("ok", false), "MAPEDITOR-005 should save resource file: %s" % [saved.get("errors", [])])
	_expect(bool(saved.get("written", false)), "MAPEDITOR-005 resource save should report written")
	var loaded: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(TARGET_PATH)
	_expect(loaded.get("ok", false), "MAPEDITOR-005 saved resources should reload")
	var point: Dictionary = _point_by_id(loaded.get("data", {}), "resource_branch_bear_corner")
	_expect(str(point.get("display_name", "")) == "测试树枝", "MAPEDITOR-005 saved resources should include edited display_name")
	_expect(int(point.get("quantity", 0)) == 2, "MAPEDITOR-005 saved resources should include edited quantity")
	_expect(_cell_key(point.get("cell", {})) == "1,1", "MAPEDITOR-005 saved resources should include moved cell")

	_expect(not scene.call("update_selected_field", "item_id", "missing_item").get("ok", true), "MAPEDITOR-005 should reject unknown item_id")
	var invalid_move: Dictionary = scene.call("move_resource_marker_candidate", "resource_branch_bear_corner", Vector2i(28, 16))
	_expect(not invalid_move.get("ok", true), "MAPEDITOR-005 should reject resource overlap with anchor")
	_expect(str(invalid_move.get("reason", "")) == "validation_failed", "MAPEDITOR-005 invalid resource move should fail validation")
	_expect(_read_text(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH) == real_before, "MAPEDITOR-005 should not touch real resource_points.json")

	root.remove_child(scene)
	scene.queue_free()
	_cleanup()
	_finish()


func _point_by_id(data: Dictionary, point_id: String) -> Dictionary:
	for point in data.get("resource_points", []):
		if str(point.get("point_id", "")) == point_id:
			return point
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
		print("V02.27 MAPEDITOR-005 RESOURCE SAVE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
