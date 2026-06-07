extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

var failures: Array[String] = []


func _init() -> void:
	var original_text := _read_world_map_text()
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	_check_panel_exists(scene)
	_check_valid_candidate(scene, original_text)
	_check_invalid_candidate_error_list(scene, original_text)

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _check_panel_exists(scene: Control) -> void:
	var summary: Dictionary = scene.call("get_layer_summary")
	_expect(bool(summary.get("has_export_validation_panel", false)), "MAPAUTH-001 should expose validation panel")
	_expect(bool(summary.get("has_validate_export_button", false)), "MAPAUTH-001 should expose Validate button")
	_expect(bool(summary.get("has_validation_status_label", false)), "MAPAUTH-001 should expose validation status")
	_expect(bool(summary.get("has_validation_errors_label", false)), "MAPAUTH-001 should expose validation error list")
	var validation: Dictionary = scene.call("get_validation_summary")
	_expect(str(validation.get("status_text", "")).contains("not validated"), "MAPAUTH-001 should start as not validated")


func _check_valid_candidate(scene: Control, original_text: String) -> void:
	_press(scene.find_child("ValidateExportButton", true, false) as Button, "MAPAUTH-001 should validate from visible button")
	var validation: Dictionary = scene.call("get_validation_summary")
	_expect(bool(validation.get("ok", false)), "MAPAUTH-001 valid candidate should pass")
	_expect(int(validation.get("error_count", -1)) == 0, "MAPAUTH-001 valid candidate should show no errors")
	_expect(str(validation.get("status_text", "")).contains("valid"), "MAPAUTH-001 valid status should be visible")
	_expect(not bool(validation.get("wrote_file", true)), "MAPAUTH-001 validation should not write JSON")
	_expect(_read_world_map_text() == original_text, "MAPAUTH-001 valid validation should not change world_map.json")


func _check_invalid_candidate_error_list(scene: Control, original_text: String) -> void:
	var moved: Dictionary = scene.call("set_marker_cell_for_test", "place", "place_home", Vector2i(-5, -5))
	_expect(moved.get("ok", false), "MAPAUTH-001 should move a marker for invalid candidate testing")
	var result: Dictionary = scene.call("validate_export_candidate")
	_expect(not result.get("ok", true), "MAPAUTH-001 invalid candidate should fail validation")
	_expect(int(result.get("error_count", 0)) > 0, "MAPAUTH-001 invalid candidate should expose errors")
	var validation: Dictionary = scene.call("get_validation_summary")
	_expect(str(validation.get("error_text", "")).contains("place position outside district"), "MAPAUTH-001 error list should include contract message")
	_expect(str(validation.get("error_text", "")).contains("place_home"), "MAPAUTH-001 error list should name the invalid place")
	_expect(not bool(validation.get("wrote_file", true)), "MAPAUTH-001 invalid validation should not write JSON")
	_expect(_read_world_map_text() == original_text, "MAPAUTH-001 invalid validation should not change world_map.json")


func _read_world_map_text() -> String:
	var file := FileAccess.open(RuntimeMapBuilderScript.WORLD_MAP_PATH, FileAccess.READ)
	_expect(file != null, "MAPAUTH-001 should read world_map.json")
	if file == null:
		return ""
	return file.get_as_text()


func _press(button: Button, message: String) -> void:
	_expect(button != null and _is_visible_in_tree(button) and not button.disabled, message)
	if button != null and _is_visible_in_tree(button) and not button.disabled:
		button.pressed.emit()


func _is_visible_in_tree(control: Control) -> bool:
	var current: Node = control
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _finish() -> void:
	if failures.is_empty():
		print("V02.25 MAPAUTH-001 VALIDATION PANEL TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
