extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const ResourceRefreshServiceScript := preload("res://scripts/systems/resource_refresh_service.gd")
const ContentContractValidatorScript := preload("res://scripts/systems/content_contract_validator.gd")

const NEW_POINTS: Array[Dictionary] = [
	{"point_id": "resource_shell_coast_edge", "item_id": "shell", "cell": Vector2i(53, 28)},
	{"point_id": "resource_leaf_school_walk", "item_id": "leaf", "cell": Vector2i(22, 15)},
	{"point_id": "resource_pinecone_animal_park", "item_id": "pinecone", "cell": Vector2i(48, 25)},
	{"point_id": "resource_ribbon_shop_street", "item_id": "ribbon", "cell": Vector2i(52, 12)},
]
const FORBIDDEN_TEXT: Array[String] = ["刷", "赶路", "迟到", "错过", "必须", "倒计时", "打卡", "限时", "枯竭", "抢", "任务", "作业", "考试", "测验", "分数"]

var failures: Array[String] = []


func _init() -> void:
	_check_default_resource_batch_data()
	_check_collection_refresh_and_inventory_contract()
	_check_main_runtime_resource_prompts()
	_finish()


func _check_default_resource_batch_data() -> void:
	var save_service = SaveServiceScript.new("user://test_v026_contentbatch002_resource_data.json")
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-002 data save should clear")
	var inventory = InventoryServiceScript.new(save_service)
	_expect(inventory.is_loaded(), "V02.26 CONTENTBATCH-002 item catalog should load: %s" % [inventory.load_errors])
	var resources = ResourceRefreshServiceScript.new(save_service, inventory, LocalDayServiceScript.new("local_day_001"))
	_expect(resources.is_loaded(), "V02.26 CONTENTBATCH-002 resource data should load: %s" % [resources.load_errors])
	_expect(resources.points_by_id.size() >= 7, "V02.26 CONTENTBATCH-002 should keep baseline resources and add a small batch")

	var world_map: Dictionary = _world_map()
	var road_cells: Dictionary = _road_cells(world_map)
	var protected_cells: Dictionary = _protected_cells(world_map)
	for expected in NEW_POINTS:
		var point_id := str(expected.get("point_id", ""))
		var item_id := str(expected.get("item_id", ""))
		var cell: Vector2i = expected.get("cell", Vector2i.ZERO)
		_expect(resources.points_by_id.has(point_id), "V02.26 CONTENTBATCH-002 should include resource point: %s" % point_id)
		var point: Dictionary = resources.get_point(point_id)
		_expect(point.get("ok", false), "V02.26 CONTENTBATCH-002 point should resolve: %s" % point_id)
		_expect(str(point.get("item_id", "")) == item_id, "V02.26 CONTENTBATCH-002 point should bind expected item: %s" % point_id)
		_expect(inventory.get_item(item_id).get("ok", false), "V02.26 CONTENTBATCH-002 item should exist in catalog: %s" % item_id)
		_expect(_cell_matches(point.get("cell", {}), cell), "V02.26 CONTENTBATCH-002 point should stay on planned cell: %s" % point_id)
		_expect(road_cells.has(_cell_key(cell)), "V02.26 CONTENTBATCH-002 point should sit on reachable town path: %s" % point_id)
		_expect(not protected_cells.has(_cell_key(cell)), "V02.26 CONTENTBATCH-002 point should avoid anchor/place/collision cells: %s" % point_id)
		var rule: Dictionary = point.get("refresh_rule", {})
		_expect(str(rule.get("mode", "")) == "daily_soft", "V02.26 CONTENTBATCH-002 point should use daily_soft refresh: %s" % point_id)
		_expect(bool(rule.get("baseline_available", false)), "V02.26 CONTENTBATCH-002 point should stay baseline available: %s" % point_id)
		_expect(str(rule.get("player_pressure", "")) == "none", "V02.26 CONTENTBATCH-002 point should carry no pressure: %s" % point_id)
		_expect(int(point.get("quantity", 0)) == 1, "V02.26 CONTENTBATCH-002 new point should be a small find: %s" % point_id)
		_expect(_child_safe(point), "V02.26 CONTENTBATCH-002 resource text should stay child-safe: %s" % point_id)

	var validation: Dictionary = ContentContractValidatorScript.new().validate_all()
	_expect(validation.get("ok", false), "V02.26 CONTENTBATCH-002 content contracts should pass: %s" % [validation.get("errors", [])])
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-002 data save should clean up")


func _check_collection_refresh_and_inventory_contract() -> void:
	var save_service = SaveServiceScript.new("user://test_v026_contentbatch002_resource_collect.json")
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-002 collect save should clear")
	var day = LocalDayServiceScript.new("local_day_003")
	var inventory = InventoryServiceScript.new(save_service)
	var resources = ResourceRefreshServiceScript.new(save_service, inventory, day)
	_expect(resources.get_available_points().size() >= 7, "V02.26 CONTENTBATCH-002 fresh day should keep all resource choices available")

	for expected in NEW_POINTS:
		var point_id := str(expected.get("point_id", ""))
		var item_id := str(expected.get("item_id", ""))
		var collected: Dictionary = resources.collect_resource(point_id)
		_expect(collected.get("ok", false), "V02.26 CONTENTBATCH-002 should collect new point once: %s" % point_id)
		_expect(str(collected.get("item_id", "")) == item_id, "V02.26 CONTENTBATCH-002 collection should return expected item: %s" % point_id)
		var duplicate: Dictionary = resources.collect_resource(point_id)
		_expect(not duplicate.get("ok", true) and str(duplicate.get("reason", "")) == "already_collected_today", "V02.26 CONTENTBATCH-002 point should not repeat in one day: %s" % point_id)
		_expect(int(save_service.load_game_state().get("inventory", {}).get(item_id, 0)) == 1, "V02.26 CONTENTBATCH-002 inventory should store one gentle find: %s" % item_id)

	day.set_day_key_for_test("local_day_004")
	var next_day: Dictionary = resources.collect_resource("resource_shell_coast_edge")
	_expect(next_day.get("ok", false), "V02.26 CONTENTBATCH-002 resources should refresh on the next day key")
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-002 collect save should clean up")


func _check_main_runtime_resource_prompts() -> void:
	var save_path := "user://test_v026_contentbatch002_resource_main.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-002 main save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_002")
	root.add_child(main)
	main.call("_ready")

	for expected in NEW_POINTS:
		var point_id := str(expected.get("point_id", ""))
		var item_id := str(expected.get("item_id", ""))
		var cell: Vector2i = expected.get("cell", Vector2i.ZERO)
		_expect(main.move_player_to_cell(cell).get("ok", false), "V02.26 CONTENTBATCH-002 player should reach new resource: %s" % point_id)
		var target: Dictionary = main.get_current_interaction_target()
		_expect(str(target.get("type", "")) == "resource" and str(target.get("target_id", "")) == point_id, "V02.26 CONTENTBATCH-002 prompt should target exact resource: %s" % point_id)
		var result: Dictionary = main.interact_nearby()
		_expect(str(result.get("interaction_type", "")) == "resource" and str(result.get("item_id", "")) == item_id, "V02.26 CONTENTBATCH-002 interaction should collect exact resource: %s" % point_id)

	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-002 main save should clean up")
	root.remove_child(main)
	main.queue_free()


func _world_map() -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.26 CONTENTBATCH-002 should load world map")
	return result.get("data", {}).duplicate(true)


func _road_cells(world_map: Dictionary) -> Dictionary:
	var cells: Dictionary = {}
	for road_value in world_map.get("roads", []):
		if road_value is Dictionary:
			for cell_value in (road_value as Dictionary).get("cells", []):
				if cell_value is Dictionary:
					cells[_cell_key(_dict_to_cell(cell_value))] = true
	return cells


func _protected_cells(world_map: Dictionary) -> Dictionary:
	var cells: Dictionary = {}
	for cell_value in world_map.get("collision_cells", []):
		if cell_value is Dictionary:
			cells[_cell_key(_dict_to_cell(cell_value))] = true
	for interaction_value in world_map.get("interaction_cells", []):
		if interaction_value is Dictionary:
			cells[_cell_key(_dict_to_cell((interaction_value as Dictionary).get("cell", {})))] = true
	for anchor_value in world_map.get("memory_anchors", []):
		if anchor_value is Dictionary:
			cells[_cell_key(_dict_to_cell((anchor_value as Dictionary).get("position", {})))] = true
	return cells


func _child_safe(value: Variant) -> bool:
	if value is Dictionary:
		for key in (value as Dictionary).keys():
			if not _child_safe((value as Dictionary)[key]):
				return false
	elif value is Array:
		for item in value:
			if not _child_safe(item):
				return false
	else:
		var text := str(value)
		for forbidden in FORBIDDEN_TEXT:
			if text.contains(forbidden):
				return false
	return true


func _cell_matches(value: Variant, cell: Vector2i) -> bool:
	if not value is Dictionary:
		return false
	var dict: Dictionary = value
	return int(dict.get("x", -1)) == cell.x and int(dict.get("y", -1)) == cell.y


func _dict_to_cell(value: Variant) -> Vector2i:
	if value is Vector2i:
		return value
	if value is Dictionary:
		var dict: Dictionary = value
		return Vector2i(int(dict.get("x", 0)), int(dict.get("y", 0)))
	return Vector2i.ZERO


func _cell_key(cell: Vector2i) -> String:
	return "%s,%s" % [cell.x, cell.y]


func _finish() -> void:
	if failures.is_empty():
		print("V02.26 CONTENTBATCH-002 RESOURCE POINT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
