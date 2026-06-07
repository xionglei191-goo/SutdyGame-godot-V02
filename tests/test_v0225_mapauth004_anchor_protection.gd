extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

const LOCKED_FIELDS: Array[String] = [
	"anchor_id",
	"letter",
	"core_word",
	"route_order",
	"place_id",
	"card_id",
	"audio_id",
]

var failures: Array[String] = []


func _init() -> void:
	var original_text := _read_world_map_text()
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var summary: Dictionary = scene.call("get_authoring_anchor_summary")
	_expect(int(summary.get("anchor_count", 0)) == 26, "MAPAUTH-004 should start with 26 anchors")
	_expect(int(summary.get("protected_anchor_count", 0)) == 26, "MAPAUTH-004 should protect all 26 A-Z anchors")
	_expect(_has_marker(scene, "anchor", "anchor_a_apple"), "MAPAUTH-004 should start with A anchor marker")

	var exported_before: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported_before.get("ok", false), "MAPAUTH-004 initial export should be valid: %s" % [exported_before.get("errors", [])])
	var apple_before: Dictionary = _anchor_by_id(exported_before.get("data", {}), "anchor_a_apple")

	var delete_result: Dictionary = scene.call("delete_anchor_marker_candidate", "anchor_a_apple")
	_expect(not delete_result.get("ok", true), "MAPAUTH-004 should reject deleting a core A-Z anchor")
	_expect(str(delete_result.get("reason", "")) == "protected_core_anchor", "MAPAUTH-004 protected delete should name the reason")
	_expect(_has_marker(scene, "anchor", "anchor_a_apple"), "MAPAUTH-004 rejected delete should keep marker")

	var unknown_delete: Dictionary = scene.call("delete_anchor_marker_candidate", "anchor_missing_test")
	_expect(not unknown_delete.get("ok", true), "MAPAUTH-004 should reject deleting unknown anchor")
	_expect(str(unknown_delete.get("reason", "")) == "unknown_anchor_id", "MAPAUTH-004 unknown delete should name the reason")

	for field_name in LOCKED_FIELDS:
		var edit_result: Dictionary = scene.call("edit_anchor_field_candidate", "anchor_a_apple", field_name, _bad_value_for(field_name))
		_expect(not edit_result.get("ok", true), "MAPAUTH-004 should reject editing locked anchor field: %s" % field_name)
		_expect(str(edit_result.get("reason", "")) == "anchor_field_locked", "MAPAUTH-004 locked edit should name reason: %s" % field_name)

	var moved: Dictionary = scene.call("set_marker_cell_for_test", "anchor", "anchor_a_apple", Vector2i(29, 16))
	_expect(moved.get("ok", false), "MAPAUTH-004 should still allow marker position candidate movement")
	var exported_after_move: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported_after_move.get("ok", false), "MAPAUTH-004 export after anchor move should stay valid: %s" % [exported_after_move.get("errors", [])])
	var apple_after_move: Dictionary = _anchor_by_id(exported_after_move.get("data", {}), "anchor_a_apple")
	for field_name in LOCKED_FIELDS:
		_expect(apple_after_move.get(field_name) == apple_before.get(field_name), "MAPAUTH-004 marker move should not change locked field: %s" % field_name)
	_expect(_cell_key(apple_after_move.get("position", {})) == "29,16", "MAPAUTH-004 marker move should only update exported position")
	_expect(int(exported_after_move.get("data", {}).get("memory_anchors", []).size()) == 26, "MAPAUTH-004 export should keep 26 anchors after blocked edits and move")
	_expect(_letters(exported_after_move.get("data", {})) == _az_letters(), "MAPAUTH-004 export should preserve A-Z route order")

	var validation: Dictionary = scene.call("validate_export_candidate")
	_expect(validation.get("ok", false), "MAPAUTH-004 validation should pass after blocked edits")
	_expect(not bool(validation.get("wrote_file", true)), "MAPAUTH-004 validation should not write JSON")
	_expect(_read_world_map_text() == original_text, "MAPAUTH-004 blocked edit loop should leave runtime world_map.json unchanged")

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _anchor_by_id(map_data: Dictionary, anchor_id: String) -> Dictionary:
	for anchor in map_data.get("memory_anchors", []):
		if str(anchor.get("anchor_id", "")) == anchor_id:
			return anchor
	return {}


func _letters(map_data: Dictionary) -> Array[String]:
	var letters: Array[String] = []
	for anchor in map_data.get("memory_anchors", []):
		letters.append(str(anchor.get("letter", "")))
	return letters


func _az_letters() -> Array[String]:
	return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]


func _bad_value_for(field_name: String) -> Variant:
	match field_name:
		"route_order":
			return 99
		"place_id":
			return "place_missing_authoring"
		_:
			return "mapauth004_bad_%s" % field_name


func _has_marker(scene: Node, runtime_type: String, stable_id: String) -> bool:
	for child in scene.find_children("*", "PanelContainer", true, false):
		if str(child.get("runtime_type")) == runtime_type and str(child.get("stable_id")) == stable_id:
			return true
	return false


func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]


func _read_world_map_text() -> String:
	var file := FileAccess.open(RuntimeMapBuilderScript.WORLD_MAP_PATH, FileAccess.READ)
	_expect(file != null, "MAPAUTH-004 should read world_map.json")
	if file == null:
		return ""
	return file.get_as_text()


func _finish() -> void:
	if failures.is_empty():
		print("V02.25 MAPAUTH-004 ANCHOR PROTECTION TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
