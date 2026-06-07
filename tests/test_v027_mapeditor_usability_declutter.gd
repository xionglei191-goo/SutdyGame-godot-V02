extends SceneTree

const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

var failures: Array[String] = []


func _init() -> void:
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var layout: Dictionary = scene.call("get_editor_layout_summary")
	var origin: Dictionary = layout.get("map_origin", {})
	_expect(int(origin.get("x", 0)) == 252 and int(origin.get("y", 0)) == 52, "MAPEDITOR-008 should reserve a stable map canvas origin")
	var extent: Dictionary = layout.get("map_extent", {})
	_expect(int(layout.get("cell_size", 0)) == 15, "MAPEDITOR-009 should use a compact editor-only cell size")
	_expect(int(extent.get("right", 9999)) <= 1268 and int(extent.get("bottom", 9999)) <= 708, "MAPEDITOR-009 should keep the full map inside the 1280x720 editor view")

	var toolbar: Dictionary = layout.get("toolbar_rect", {})
	var inspector: Dictionary = layout.get("inspector_rect", {})
	var status: Dictionary = layout.get("status_rect", {})
	var validation: Dictionary = layout.get("validation_rect", {})
	_expect(int(validation.get("x", 0)) == 12 and int(validation.get("h", 9999)) <= 116, "MAPEDITOR-009 validation panel should stay compact in the left work rail")
	_expect(int(toolbar.get("x", 0)) == 12 and int(toolbar.get("w", 0)) == 228, "MAPEDITOR-009 toolbar should stay in the left work rail")
	_expect(int(toolbar.get("h", 0)) <= 272, "MAPEDITOR-009 toolbar should not grow beyond the left work rail")
	_expect(int(inspector.get("x", 0)) == 12 and int(inspector.get("y", 0)) >= 380, "MAPEDITOR-010 inspector should stay in the left work rail with editable fields")
	_expect(int(inspector.get("h", 9999)) <= 190, "MAPEDITOR-010 inspector should fit real edit controls without expanding offscreen")
	_expect(int(status.get("x", 0)) == int(inspector.get("x", -1)), "MAPEDITOR-009 status should align with inspector rail")
	_expect(int(status.get("y", 0)) > int(inspector.get("y", 0)), "MAPEDITOR-008 status should sit below inspector")
	_expect(int(status.get("y", 0)) + int(status.get("h", 9999)) <= 708, "MAPEDITOR-009 status panel should remain inside the editor viewport")

	_expect(str(layout.get("anchor_label", "")).length() <= 2, "MAPEDITOR-008 anchor marker label should be compact")
	var anchor_visual: Dictionary = layout.get("anchor_visual", {})
	_expect(int(anchor_visual.get("font_size", 0)) >= 22, "MAPEDITOR-010 anchor letters should be large enough to read")
	_expect(int(anchor_visual.get("z_index", 0)) >= 80, "MAPEDITOR-010 anchor letters should draw above other markers")
	_expect(str(layout.get("resource_label", "")).length() <= 2, "MAPEDITOR-008 resource marker label should be compact")
	_expect(str(layout.get("npc_label", "")).length() <= 2, "MAPEDITOR-008 NPC marker label should be compact")
	_expect(str(layout.get("place_label", "")).length() <= 8, "MAPEDITOR-008 place marker label should be shortened")

	var tool: Dictionary = scene.call("get_tool_summary")
	for layer_key in ["road", "collision", "interaction", "place", "anchor", "resource", "npc"]:
		_expect(bool(tool.get("layer_visibility", {}).get(layer_key, false)), "MAPEDITOR-008 should keep V02.27 default layer visibility: %s" % layer_key)

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("V02.27 MAPEDITOR-008/009 USABILITY DECLUTTER TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
