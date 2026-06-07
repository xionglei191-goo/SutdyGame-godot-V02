extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

const TARGET_PATH := "user://test_v027_mapeditor_place_save_world_map.json"

var failures: Array[String] = []


func _init() -> void:
	_cleanup()
	var real_world_before := _read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	_expect(scene.call("select_marker", "place", "place_home").get("ok", false), "MAPEDITOR-003 should select Home place")
	_expect(scene.call("update_selected_field", "label", "Home Authoring Test").get("ok", false), "MAPEDITOR-003 should edit place label")
	_expect(scene.call("update_selected_field", "place_type", "home").get("ok", false), "MAPEDITOR-003 should edit place_type")
	_expect(scene.call("update_selected_field", "district_id", "district_home_core").get("ok", false), "MAPEDITOR-003 should edit district_id")
	_expect(scene.call("update_selected_field", "size_w", 3).get("ok", false), "MAPEDITOR-003 should edit size_w")
	_expect(scene.call("update_selected_field", "size_h", 2).get("ok", false), "MAPEDITOR-003 should edit size_h")

	var moved: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "MAPEDITOR-003 should move place with linkage: %s" % [moved.get("errors", [])])
	_expect(_cell_key(moved.get("interaction_cell", {})) == "32,19", "MAPEDITOR-003 move should keep interaction offset")
	var save_result: Dictionary = scene.call("save_map_candidate", TARGET_PATH)
	_expect(save_result.get("ok", false), "MAPEDITOR-003 should save valid map candidate: %s" % [save_result.get("errors", [])])
	_expect(bool(save_result.get("written", false)), "MAPEDITOR-003 save should report written")
	var loaded: Dictionary = RuntimeMapBuilderScript.load_world_map(TARGET_PATH)
	_expect(loaded.get("ok", false), "MAPEDITOR-003 saved map should post-load")
	var home: Dictionary = _place_by_id(loaded.get("data", {}), "place_home")
	_expect(str(home.get("label", "")) == "Home Authoring Test", "MAPEDITOR-003 saved map should include edited label")
	_expect(_cell_key(home.get("position", {})) == "30,17", "MAPEDITOR-003 saved map should include moved position")
	_expect(int(home.get("occupied_cells", []).size()) == 6, "MAPEDITOR-003 saved map should include resized footprint")

	var before_invalid := _read_text(TARGET_PATH)
	_expect(scene.call("set_marker_cell_for_test", "place", "place_home", Vector2i(-8, -8)).get("ok", false), "MAPEDITOR-003 should allow raw invalid setup for save guard")
	var invalid_result: Dictionary = scene.call("save_map_candidate", TARGET_PATH)
	_expect(not invalid_result.get("ok", true), "MAPEDITOR-003 invalid candidate should not save")
	_expect(str(invalid_result.get("reason", "")) == "validation_failed", "MAPEDITOR-003 invalid save should fail at validation")
	_expect(_read_text(TARGET_PATH) == before_invalid, "MAPEDITOR-003 invalid save should preserve target")
	_expect(_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == real_world_before, "MAPEDITOR-003 test should not touch runtime world_map.json")

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
		print("V02.27 MAPEDITOR-003 PLACE SAVE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
