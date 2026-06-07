extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

const MAP_TARGET := "user://test_v027_mapeditor_full_world_map.json"
const RESOURCE_TARGET := "user://test_v027_mapeditor_full_resource_points.json"
const ROUTINE_TARGET := "user://test_v027_mapeditor_full_npc_routines.json"

var failures: Array[String] = []


func _init() -> void:
	_cleanup()
	var real_world_before := _read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var real_resources_before := _read_text(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH)
	var real_routines_before := _read_text(MapEditorSyncServiceScript.NPC_ROUTINES_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	_expect(scene.call("get_tool_summary").get("has_toolbar", false), "MAPEDITOR full regression should expose toolbar")
	_expect(scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17)).get("ok", false), "MAPEDITOR full regression should move place")
	_expect(scene.call("paint_cell_candidate", "road", Vector2i(2, 2), false).get("ok", false), "MAPEDITOR full regression should paint road")
	_expect(scene.call("move_resource_marker_candidate", "resource_branch_bear_corner", Vector2i(1, 1)).get("ok", false), "MAPEDITOR full regression should move resource")
	_expect(scene.call("set_current_day_key", "local_day_002").get("ok", false), "MAPEDITOR full regression should switch routine day")
	_expect(scene.call("move_npc_routine_candidate", "routine_mina_plaza_002", Vector2i(39, 22)).get("ok", false), "MAPEDITOR full regression should move routine")
	_expect(scene.call("set_tool_mode", "move_anchor").get("ok", false), "MAPEDITOR full regression should enter anchor move mode")
	_expect(scene.call("move_anchor_marker_candidate", "anchor_a_apple", Vector2i(6, 3)).get("ok", false), "MAPEDITOR full regression should move anchor")

	var map_save: Dictionary = scene.call("save_map_candidate", MAP_TARGET)
	_expect(map_save.get("ok", false), "MAPEDITOR full regression should save map: %s" % [map_save.get("errors", [])])
	var resource_save: Dictionary = scene.call("save_resources_candidate", RESOURCE_TARGET)
	_expect(resource_save.get("ok", false), "MAPEDITOR full regression should save resources: %s" % [resource_save.get("errors", [])])
	var routine_save: Dictionary = scene.call("save_routines_candidate", ROUTINE_TARGET)
	_expect(routine_save.get("ok", false), "MAPEDITOR full regression should save routines: %s" % [routine_save.get("errors", [])])

	var loaded_map: Dictionary = RuntimeMapBuilderScript.load_world_map(MAP_TARGET)
	_expect(loaded_map.get("ok", false), "MAPEDITOR full regression saved map should reload")
	_expect(int(loaded_map.get("data", {}).get("memory_anchors", []).size()) == 26, "MAPEDITOR full regression should preserve 26 anchors")
	_expect(MapEditorSyncServiceScript.load_json_dictionary(RESOURCE_TARGET).get("ok", false), "MAPEDITOR full regression saved resources should reload")
	_expect(MapEditorSyncServiceScript.load_json_dictionary(ROUTINE_TARGET).get("ok", false), "MAPEDITOR full regression saved routines should reload")
	_expect(_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == real_world_before, "MAPEDITOR full regression should leave runtime world_map.json untouched")
	_expect(_read_text(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH) == real_resources_before, "MAPEDITOR full regression should leave runtime resource_points.json untouched")
	_expect(_read_text(MapEditorSyncServiceScript.NPC_ROUTINES_PATH) == real_routines_before, "MAPEDITOR full regression should leave runtime npc_routines.json untouched")

	root.remove_child(scene)
	scene.queue_free()
	_cleanup()
	_finish()


func _read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


func _cleanup() -> void:
	for path in [MAP_TARGET, MAP_TARGET + ".tmp", MAP_TARGET + ".bak", RESOURCE_TARGET, RESOURCE_TARGET + ".tmp", RESOURCE_TARGET + ".bak", ROUTINE_TARGET, ROUTINE_TARGET + ".tmp", ROUTINE_TARGET + ".bak"]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _finish() -> void:
	if failures.is_empty():
		print("V02.27 MAPEDITOR FULL REGRESSION TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
