extends SceneTree

const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

const TARGET_PATH := "user://test_v027_mapeditor_npc_routines.json"

var failures: Array[String] = []


func _init() -> void:
	_cleanup()
	var real_before := _read_text(MapEditorSyncServiceScript.NPC_ROUTINES_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	_expect(scene.call("set_current_day_key", "local_day_002").get("ok", false), "MAPEDITOR-006 should switch routine day")
	_expect(scene.call("select_marker", "npc_routine", "routine_mina_plaza_002").get("ok", false), "MAPEDITOR-006 should select routine marker")
	_expect(scene.call("update_selected_field", "label", "米娜在测试小路旁挥手。").get("ok", false), "MAPEDITOR-006 should edit routine label")
	_expect(scene.call("move_npc_routine_candidate", "routine_mina_plaza_002", Vector2i(39, 22)).get("ok", false), "MAPEDITOR-006 should move NPC routine to safe cell")
	var validation: Dictionary = scene.call("validate_routines_candidate")
	_expect(validation.get("ok", false), "MAPEDITOR-006 routine candidate should validate: %s" % [validation.get("errors", [])])
	var saved: Dictionary = scene.call("save_routines_candidate", TARGET_PATH)
	_expect(saved.get("ok", false), "MAPEDITOR-006 should save routine file: %s" % [saved.get("errors", [])])
	_expect(bool(saved.get("written", false)), "MAPEDITOR-006 routine save should report written")
	var loaded: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(TARGET_PATH)
	_expect(loaded.get("ok", false), "MAPEDITOR-006 saved routines should reload")
	var routine: Dictionary = _routine_by_id(loaded.get("data", {}), "local_day_002", "routine_mina_plaza_002")
	_expect(str(routine.get("label", "")) == "米娜在测试小路旁挥手。", "MAPEDITOR-006 saved routines should include edited label")
	_expect(_cell_key(routine.get("cell", {})) == "39,22", "MAPEDITOR-006 saved routines should include moved cell")

	var bad_day: Dictionary = scene.call("set_current_day_key", "missing_day")
	_expect(not bad_day.get("ok", true), "MAPEDITOR-006 should reject unknown day")
	var invalid_move: Dictionary = scene.call("move_npc_routine_candidate", "routine_mina_plaza_002", Vector2i(28, 16), "local_day_002")
	_expect(not invalid_move.get("ok", true), "MAPEDITOR-006 should reject NPC overlap with anchor")
	_expect(str(invalid_move.get("reason", "")) == "validation_failed", "MAPEDITOR-006 invalid routine move should fail validation")
	_expect(_read_text(MapEditorSyncServiceScript.NPC_ROUTINES_PATH) == real_before, "MAPEDITOR-006 should not touch real npc_routines.json")

	root.remove_child(scene)
	scene.queue_free()
	_cleanup()
	_finish()


func _routine_by_id(data: Dictionary, day_key: String, routine_id: String) -> Dictionary:
	for day in data.get("routine_days", []):
		if str(day.get("day_key", "")) != day_key:
			continue
		for npc in day.get("npcs", []):
			if str(npc.get("routine_id", "")) == routine_id:
				return npc
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
		print("V02.27 MAPEDITOR-006 NPC ROUTINE SAVE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
