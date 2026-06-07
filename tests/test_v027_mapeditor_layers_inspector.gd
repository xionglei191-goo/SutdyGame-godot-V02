extends SceneTree

const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

var failures: Array[String] = []


func _init() -> void:
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var layers: Dictionary = scene.call("get_layer_summary")
	for key in ["has_toolbar", "has_tool_mode_option", "has_inspector_panel", "has_editor_status_label", "has_road_layer", "has_collision_layer", "has_interaction_layer", "has_place_marker_layer", "has_anchor_marker_layer", "has_resource_marker_layer", "has_npc_spawn_layer"]:
		_expect(bool(layers.get(key, false)), "MAPEDITOR-002 should expose %s" % key)

	var tool: Dictionary = scene.call("get_tool_summary")
	_expect(str(tool.get("tool_mode", "")) == "select", "MAPEDITOR-002 should default to select tool")
	_expect(bool(tool.get("has_toolbar", false)), "MAPEDITOR-002 tool summary should report toolbar")
	_expect(bool(tool.get("has_inspector", false)), "MAPEDITOR-002 tool summary should report inspector")
	for layer_key in ["road", "collision", "interaction", "place", "anchor", "resource", "npc"]:
		_expect(bool(tool.get("layer_visibility", {}).get(layer_key, false)), "MAPEDITOR-002 layer should start visible: %s" % layer_key)
		var off: Dictionary = scene.call("toggle_layer", layer_key, false)
		_expect(off.get("ok", false), "MAPEDITOR-002 should toggle layer off: %s" % layer_key)
		_expect(not bool(scene.call("get_tool_summary").get("layer_visibility", {}).get(layer_key, true)), "MAPEDITOR-002 summary should show layer off: %s" % layer_key)
		var on: Dictionary = scene.call("toggle_layer", layer_key, true)
		_expect(on.get("ok", false), "MAPEDITOR-002 should toggle layer on: %s" % layer_key)

	var selected_place: Dictionary = scene.call("select_marker", "place", "place_home")
	_expect(selected_place.get("ok", false), "MAPEDITOR-002 should select place marker")
	var inspector: Dictionary = scene.call("get_inspector_summary")
	_expect(str(inspector.get("title", "")).contains("place_home"), "MAPEDITOR-002 inspector should name selected place")
	_expect((inspector.get("editable_fields", []) as Array).has("label"), "MAPEDITOR-002 place inspector should expose label")

	var selected_resource: Dictionary = scene.call("select_marker", "resource", "resource_branch_bear_corner")
	_expect(selected_resource.get("ok", false), "MAPEDITOR-002 should select resource marker")
	inspector = scene.call("get_inspector_summary")
	_expect(str(inspector.get("body", "")).contains("item_id"), "MAPEDITOR-002 resource inspector should show item_id")

	var selected_npc: Dictionary = scene.call("select_marker", "npc_routine", "routine_mina_plaza_001")
	_expect(selected_npc.get("ok", false), "MAPEDITOR-002 should select NPC routine marker")
	inspector = scene.call("get_inspector_summary")
	_expect(str(inspector.get("body", "")).contains("day_key=local_day_001"), "MAPEDITOR-002 NPC inspector should show active day")
	_expect(int(scene.call("set_current_day_key", "local_day_002").get("npc_marker_count", 0)) > 0, "MAPEDITOR-002 day selector should rebuild NPC markers")

	_expect(not scene.call("toggle_layer", "missing", false).get("ok", true), "MAPEDITOR-002 should reject unknown layer")
	_expect(not scene.call("set_tool_mode", "missing").get("ok", true), "MAPEDITOR-002 should reject unknown tool")

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("V02.27 MAPEDITOR-002 LAYERS INSPECTOR TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
