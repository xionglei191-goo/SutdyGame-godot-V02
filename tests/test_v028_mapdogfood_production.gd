extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const FORBIDDEN_TERMS: Array[String] = ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "等级", "倒计时", "迟到", "作业", "老师评价", "家长报告", "坐标", "格子", "调试", "debug", "footprint"]

var failures: Array[String] = []


func _init() -> void:
	_check_data_contract()
	_check_editor_can_see_dogfood_fields()
	_check_child_visible_runtime_paths()
	_finish()


func _check_data_contract() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "V02.28 dogfood world map should load")
	var map_data: Dictionary = map_result.get("data", {})
	var resources_result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH)
	_expect(resources_result.get("ok", false), "V02.28 dogfood resources should load")
	var routines_result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.NPC_ROUTINES_PATH)
	_expect(routines_result.get("ok", false), "V02.28 dogfood routines should load")

	var story_bench := _place_by_id(map_data, "place_plaza_story_bench")
	_expect(not story_bench.is_empty(), "V02.28 dogfood should add Story Bench place")
	_expect(_cell_key(story_bench.get("position", {})) == "12,19", "V02.28 Story Bench position should match dogfood")
	_expect(_cell_key(story_bench.get("interaction_cell", {})) == "12,20", "V02.28 Story Bench interaction should match dogfood")
	_expect(str(story_bench.get("place_type", "")) == "town_start", "V02.28 Story Bench should use allowed district type")
	_expect(str(story_bench.get("place_action", "")) == "open_town_start", "V02.28 Story Bench should use runtime-supported action")

	var ribbon_corner := _place_by_id(map_data, "place_shop_ribbon_corner")
	_expect(not ribbon_corner.is_empty(), "V02.28 dogfood should add Ribbon Corner place")
	_expect(_cell_key(ribbon_corner.get("position", {})) == "49,12", "V02.28 Ribbon Corner position should match dogfood")
	_expect(_cell_key(ribbon_corner.get("interaction_cell", {})) == "49,13", "V02.28 Ribbon Corner interaction should match dogfood")
	_expect(str(ribbon_corner.get("place_type", "")) == "food", "V02.28 Ribbon Corner should use allowed district type")
	_expect(str(ribbon_corner.get("place_action", "")) == "open_town_start", "V02.28 Ribbon Corner should use runtime-supported action")

	_expect(_interaction_action(map_data, "place_plaza_story_bench") == "open_town_start", "V02.28 Story Bench interaction should sync action")
	_expect(_interaction_action(map_data, "place_shop_ribbon_corner") == "open_town_start", "V02.28 Ribbon Corner interaction should sync action")

	var ribbon_resource := _resource_by_id(resources_result.get("data", {}), "resource_ribbon_shop_street")
	_expect(_cell_key(ribbon_resource.get("cell", {})) == "50,14", "V02.28 dogfood should move ribbon resource")

	var shopkeeper_routine := _routine_by_id(routines_result.get("data", {}), "local_day_003", "routine_shopkeeper_shop_003")
	_expect(_cell_key(shopkeeper_routine.get("cell", {})) == "43,14", "V02.28 dogfood should move shopkeeper routine")
	_expect(str(shopkeeper_routine.get("label", "")).contains("Ribbon Corner"), "V02.28 dogfood routine label should mention new place")

	_check_anchor_identity(map_data)
	_expect(MapEditorSyncServiceScript.validate_resource_points(resources_result.get("data", {}), map_data).is_empty(), "V02.28 resources should validate after dogfood")
	_expect(MapEditorSyncServiceScript.validate_npc_routines(routines_result.get("data", {}), map_data, resources_result.get("data", {})).is_empty(), "V02.28 routines should validate after dogfood")


func _check_editor_can_see_dogfood_fields() -> void:
	var scene: Control = preload("res://scenes/map_editor/town_map_authoring.tscn").instantiate()
	root.add_child(scene)
	scene.call("_ready")
	_expect(scene.call("select_marker", "place", "place_shop_ribbon_corner").get("ok", false), "V02.28 editor should select dogfood place")
	var inspector: Dictionary = scene.call("get_inspector_summary")
	_expect((inspector.get("editable_fields", []) as Array).has("place_action"), "V02.28 editor should expose place_action field")
	root.remove_child(scene)
	scene.queue_free()


func _check_child_visible_runtime_paths() -> void:
	var save_path := "user://test_v028_mapdogfood_production.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.28 dogfood save should clear before runtime test")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_003")
	root.add_child(main)
	main.call("_ready")

	_check_place_path(main, Vector2i(12, 20), "interaction_place_plaza_story_bench_authoring", "place_plaza_story_bench")
	_check_place_path(main, Vector2i(49, 13), "interaction_place_shop_ribbon_corner_authoring", "place_shop_ribbon_corner")
	_check_resource_path(main, Vector2i(50, 14), "resource_ribbon_shop_street")
	_check_npc_path(main, Vector2i(43, 14), "shopkeeper")
	_expect(not _has_forbidden_visible_text(main), "V02.28 dogfood visible UI should not expose editor or pressure terms")

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _check_place_path(main, cell: Vector2i, expected_target_id: String, expected_place_id: String) -> void:
	_expect(main.move_player_to_cell(cell).get("ok", false), "V02.28 player should reach dogfood place %s" % expected_place_id)
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "place", "V02.28 target should be place at %s" % expected_place_id)
	_expect(str(target.get("target_id", "")) == expected_target_id, "V02.28 target id should match at %s" % expected_place_id)
	var result: Dictionary = main.interact_nearby()
	_expect(result.get("ok", false), "V02.28 place interaction should succeed at %s: %s" % [expected_place_id, result])
	_expect(str(result.get("interaction_type", "")) == "place_entry", "V02.28 dogfood place should use place entry")
	_expect(str(result.get("place_id", "")) == expected_place_id, "V02.28 dogfood place result should preserve place_id")


func _check_resource_path(main, cell: Vector2i, expected_point_id: String) -> void:
	_expect(main.move_player_to_cell(cell).get("ok", false), "V02.28 player should reach dogfood resource")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "resource", "V02.28 target should be resource at ribbon cell")
	_expect(str(target.get("target_id", "")) == expected_point_id, "V02.28 resource target id should match")
	var result: Dictionary = main.interact_nearby()
	_expect(result.get("ok", false), "V02.28 resource interaction should succeed")
	_expect(str(result.get("interaction_type", "")) == "resource", "V02.28 resource result should keep resource context")
	_expect(str(result.get("item_id", "")) == "ribbon", "V02.28 resource result should collect ribbon")


func _check_npc_path(main, cell: Vector2i, expected_npc_id: String) -> void:
	_expect(main.move_player_to_cell(cell).get("ok", false), "V02.28 player should reach dogfood NPC routine")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc", "V02.28 target should be NPC at routine cell")
	_expect(str(target.get("target_id", "")) == expected_npc_id, "V02.28 NPC target id should match")
	var result: Dictionary = main.interact_nearby()
	_expect(result.get("ok", false), "V02.28 NPC interaction should succeed")
	_expect(str(result.get("interaction_type", "")) == "npc", "V02.28 NPC result should keep NPC context")
	_expect(str(result.get("npc_id", "")) == expected_npc_id, "V02.28 NPC result id should match")


func _check_anchor_identity(map_data: Dictionary) -> void:
	var anchors: Array = map_data.get("memory_anchors", [])
	_expect(anchors.size() == 26, "V02.28 dogfood should keep 26 A-Z anchors")
	var expected_code := 65
	for anchor_value in anchors:
		_expect(anchor_value is Dictionary, "V02.28 anchor entry should be dictionary")
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var letter := char(expected_code)
		_expect(str(anchor.get("letter", "")) == letter, "V02.28 route letter should remain A-Z: %s" % letter)
		_expect(int(anchor.get("route_order", 0)) == expected_code - 64, "V02.28 route_order should remain stable: %s" % letter)
		_expect(not str(anchor.get("anchor_id", "")).is_empty(), "V02.28 anchor_id should remain present: %s" % letter)
		_expect(not str(anchor.get("core_word", "")).is_empty(), "V02.28 core_word should remain present: %s" % letter)
		expected_code += 1


func _place_by_id(map_data: Dictionary, place_id: String) -> Dictionary:
	for place in map_data.get("places", []):
		if place is Dictionary and str((place as Dictionary).get("place_id", "")) == place_id:
			return place
	return {}


func _resource_by_id(data: Dictionary, point_id: String) -> Dictionary:
	for point in data.get("resource_points", []):
		if point is Dictionary and str((point as Dictionary).get("point_id", "")) == point_id:
			return point
	return {}


func _routine_by_id(data: Dictionary, day_key: String, routine_id: String) -> Dictionary:
	for day in data.get("routine_days", []):
		if not day is Dictionary or str((day as Dictionary).get("day_key", "")) != day_key:
			continue
		for npc in (day as Dictionary).get("npcs", []):
			if npc is Dictionary and str((npc as Dictionary).get("routine_id", "")) == routine_id:
				return npc
	return {}


func _interaction_action(map_data: Dictionary, place_id: String) -> String:
	for interaction in map_data.get("interaction_cells", []):
		if interaction is Dictionary and str((interaction as Dictionary).get("place_id", "")) == place_id:
			return str((interaction as Dictionary).get("action", ""))
	return ""


func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]


func _has_forbidden_visible_text(node: Node) -> bool:
	if node is Label:
		for term in FORBIDDEN_TERMS:
			if str((node as Label).text).contains(term):
				return true
	if node is Button:
		for term in FORBIDDEN_TERMS:
			if str((node as Button).text).contains(term):
				return true
	for child in node.get_children():
		if _has_forbidden_visible_text(child):
			return true
	return false


func _finish() -> void:
	if failures.is_empty():
		print("V02.28 MAPDOGFOOD PRODUCTION TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
