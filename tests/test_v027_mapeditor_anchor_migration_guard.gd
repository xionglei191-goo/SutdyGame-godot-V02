extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

const TARGET_PATH := "user://test_v027_mapeditor_anchor_migration_world_map.json"

var failures: Array[String] = []


func _init() -> void:
	_cleanup()
	var real_world_before := _read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var blocked: Dictionary = scene.call("move_anchor_marker_candidate", "anchor_a_apple", Vector2i(6, 3))
	_expect(not blocked.get("ok", true), "MAPEDITOR-007 should require dedicated anchor move mode")
	_expect(str(blocked.get("reason", "")) == "anchor_move_mode_required", "MAPEDITOR-007 blocked anchor move should name mode guard")
	_expect(scene.call("set_tool_mode", "move_anchor").get("ok", false), "MAPEDITOR-007 should enter anchor move mode")
	var moved: Dictionary = scene.call("move_anchor_marker_candidate", "anchor_a_apple", Vector2i(6, 3))
	_expect(moved.get("ok", false), "MAPEDITOR-007 should move anchor position in dedicated mode: %s" % [moved.get("errors", [])])
	_expect(int(moved.get("anchor_count", 0)) == 26, "MAPEDITOR-007 anchor move should preserve 26 anchors")
	var locked_edit: Dictionary = scene.call("edit_anchor_field_candidate", "anchor_a_apple", "letter", "Q")
	_expect(not locked_edit.get("ok", true), "MAPEDITOR-007 should reject locked anchor letter edit")
	_expect(str(locked_edit.get("reason", "")) == "anchor_field_locked", "MAPEDITOR-007 locked field edit should name reason")
	var delete_result: Dictionary = scene.call("delete_anchor_marker_candidate", "anchor_a_apple")
	_expect(not delete_result.get("ok", true), "MAPEDITOR-007 should reject deleting core A-Z anchor")
	var validation: Dictionary = scene.call("validate_export_candidate")
	_expect(validation.get("ok", false), "MAPEDITOR-007 moved anchor candidate should validate: %s" % [validation.get("errors", [])])
	var saved: Dictionary = scene.call("save_map_candidate", TARGET_PATH)
	_expect(saved.get("ok", false), "MAPEDITOR-007 should save anchor migration candidate: %s" % [saved.get("errors", [])])
	var loaded: Dictionary = RuntimeMapBuilderScript.load_world_map(TARGET_PATH)
	_expect(loaded.get("ok", false), "MAPEDITOR-007 saved anchor migration should reload")
	var anchor: Dictionary = _anchor_by_id(loaded.get("data", {}), "anchor_a_apple")
	_expect(_cell_key(anchor.get("position", {})) == "6,3", "MAPEDITOR-007 saved anchor should use moved position")
	_expect(str(anchor.get("letter", "")) == "A", "MAPEDITOR-007 saved anchor should preserve letter")
	_expect(str(anchor.get("core_word", "")) == "Apple", "MAPEDITOR-007 saved anchor should preserve core_word")
	_expect(int(anchor.get("route_order", 0)) == 1, "MAPEDITOR-007 saved anchor should preserve route_order")
	_expect(_letters(loaded.get("data", {})).size() == 26, "MAPEDITOR-007 saved map should keep 26 anchor letters")
	_expect(_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == real_world_before, "MAPEDITOR-007 should not touch runtime world_map.json")

	root.remove_child(scene)
	scene.queue_free()
	_cleanup()
	_finish()


func _anchor_by_id(map_data: Dictionary, anchor_id: String) -> Dictionary:
	for anchor in map_data.get("memory_anchors", []):
		if str(anchor.get("anchor_id", "")) == anchor_id:
			return anchor
	return {}


func _letters(map_data: Dictionary) -> Dictionary:
	var letters: Dictionary = {}
	for anchor in map_data.get("memory_anchors", []):
		letters[str(anchor.get("letter", ""))] = true
	return letters


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
		print("V02.27 MAPEDITOR-007 ANCHOR MIGRATION GUARD TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
