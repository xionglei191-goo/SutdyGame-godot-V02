extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

var failures: Array[String] = []


func _init() -> void:
	var real_world_before := _read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	_expect(scene.call("select_marker", "place", "place_home").get("ok", false), "MAPEDITOR-010 should select place markers from the scene")
	var inspector: Dictionary = scene.call("get_inspector_summary")
	_expect(bool(inspector.get("has_apply_button", false)), "MAPEDITOR-010 inspector should expose an Apply button")
	_expect(int(inspector.get("visible_input_count", 0)) >= 3, "MAPEDITOR-010 inspector should expose visible input fields")
	_expect((inspector.get("editable_fields", []) as Array).has("label"), "MAPEDITOR-010 inspector should expose editable place label")

	var edit_result: Dictionary = scene.call("apply_inspector_field_values", {
		"label": "Home Direct Edit",
		"place_type": "home",
		"district_id": "district_home_core",
		"size_w": "3",
		"size_h": "2",
	})
	_expect(edit_result.get("ok", false), "MAPEDITOR-010 inspector Apply should edit selected place: %s" % [edit_result])
	inspector = scene.call("get_inspector_summary")
	_expect(str((inspector.get("field_values", {}) as Dictionary).get("label", "")) == "Home Direct Edit", "MAPEDITOR-010 inspector should refresh edited field values")

	var drag_result: Dictionary = scene.call("commit_marker_drag_for_test", "place", "place_home", Vector2i(30, 17))
	_expect(drag_result.get("ok", false), "MAPEDITOR-010 marker drag should commit through authoring move validation: %s" % [drag_result.get("errors", [])])
	var exported: Dictionary = scene.call("export_world_map_dictionary")
	var home := _place_by_id(exported, "place_home")
	_expect(_cell_key(home.get("position", {})) == "30,17", "MAPEDITOR-010 committed drag should update place position")
	_expect(_cell_key(home.get("interaction_cell", {})) == "32,19", "MAPEDITOR-010 committed drag should keep linked interaction offset")

	var bad_anchor_drag: Dictionary = scene.call("commit_marker_drag_for_test", "anchor", "anchor_a_apple", Vector2i(6, 3))
	_expect(not bad_anchor_drag.get("ok", true), "MAPEDITOR-010 direct anchor drag should still require Move A-Z mode")
	_expect(str(bad_anchor_drag.get("reason", "")) == "anchor_move_mode_required", "MAPEDITOR-010 rejected anchor drag should explain mode guard")
	_expect(scene.call("set_tool_mode", "move_anchor").get("ok", false), "MAPEDITOR-010 should allow entering Move A-Z mode")
	var anchor_drag: Dictionary = scene.call("commit_marker_drag_for_test", "anchor", "anchor_a_apple", Vector2i(6, 3))
	_expect(anchor_drag.get("ok", false), "MAPEDITOR-010 Move A-Z mode should commit anchor drag")
	_expect(scene.call("select_marker", "anchor", "anchor_a_apple").get("ok", false), "MAPEDITOR-010 should select anchor markers")
	inspector = scene.call("get_inspector_summary")
	_expect((inspector.get("editable_fields", []) as Array).has("cell_x"), "MAPEDITOR-010 anchor inspector should expose editable cell_x")
	_expect((inspector.get("editable_fields", []) as Array).has("cell_y"), "MAPEDITOR-010 anchor inspector should expose editable cell_y")
	_expect(int(inspector.get("visible_input_count", 0)) >= 2, "MAPEDITOR-010 anchor inspector should show coordinate inputs")
	var anchor_edit: Dictionary = scene.call("apply_inspector_field_values", {"cell_x": "6", "cell_y": "3"})
	_expect(anchor_edit.get("ok", false), "MAPEDITOR-010 anchor inspector Apply should commit coordinate edits in Move A-Z mode: %s" % [anchor_edit])

	var layout: Dictionary = scene.call("get_editor_layout_summary")
	var anchor_visual: Dictionary = layout.get("anchor_visual", {})
	_expect(str(anchor_visual.get("text", "")) == "A", "MAPEDITOR-010 anchor marker should show the letter")
	_expect(int(anchor_visual.get("font_size", 0)) >= 22, "MAPEDITOR-010 anchor marker letter should be readable")
	_expect(int(anchor_visual.get("z_index", 0)) >= 80, "MAPEDITOR-010 anchor marker should render above marker clutter")

	_expect(_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == real_world_before, "MAPEDITOR-010 direct edit/drag should not write runtime world_map.json")
	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _place_by_id(map_data: Dictionary, place_id: String) -> Dictionary:
	for place in map_data.get("places", []):
		if place is Dictionary and str((place as Dictionary).get("place_id", "")) == place_id:
			return place
	return {}


func _cell_key(cell: Dictionary) -> String:
	return "%d,%d" % [int(cell.get("x", -999)), int(cell.get("y", -999))]


func _read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "MAPEDITOR-010 should read runtime world_map.json")
	if file == null:
		return ""
	return file.get_as_text()


func _finish() -> void:
	if failures.is_empty():
		print("V02.27 MAPEDITOR-010 DIRECT EDIT DRAG TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
