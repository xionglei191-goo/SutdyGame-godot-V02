extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const OutdoorDecorationServiceScript := preload("res://scripts/systems/outdoor_decoration_service.gd")
const ResourceRefreshServiceScript := preload("res://scripts/systems/resource_refresh_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const NPCRoutineServiceScript := preload("res://scripts/systems/npc_routine_service.gd")

var failures: Array[String] = []


func _init() -> void:
	_check_services()
	_check_main_runtime_slice()
	_finish()


func _check_services() -> void:
	var save_path := "user://test_v0222_hidden_grid_life_services.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.22 hidden grid service save should clear")
	var inventory = InventoryServiceScript.new(save_service)
	_expect(inventory.collect_item("flower_pot", 1).get("ok", false), "V02.22 outdoor service test should seed decor inventory")
	var outdoor = OutdoorDecorationServiceScript.new(save_service, inventory)
	var placed: Dictionary = outdoor.place_item("flower_pot", Vector2i(32, 21))
	_expect(placed.get("ok", false), "V02.22 outdoor decor should place an item on hidden cell")
	var instance_id := str(placed.get("outdoor_item", {}).get("instance_id", ""))
	_expect(not instance_id.is_empty(), "V02.22 outdoor decor should assign stable instance id")
	_expect(outdoor.move_item(instance_id, Vector2i(33, 21)).get("ok", false), "V02.22 outdoor decor should move by hidden cell")
	_expect(outdoor.pickup_item(instance_id).get("ok", false), "V02.22 outdoor decor should return to backpack")
	_expect(outdoor.get_placed_items().is_empty(), "V02.22 outdoor decor pickup should clear placed state")

	var day = LocalDayServiceScript.new("local_day_001")
	var resources = ResourceRefreshServiceScript.new(save_service, inventory, day)
	var summary: Dictionary = resources.get_refresh_summary()
	_expect(summary.get("ok", false), "V02.22 resource 2.0 summary should load")
	_expect(int(summary.get("available_count", 0)) >= 3, "V02.22 resource 2.0 should keep baseline resources available")
	var modes: Dictionary = summary.get("refresh_modes", {})
	_expect(str(modes.get("resource_branch_bear_corner", {}).get("mode", "")) == "daily_soft", "V02.22 resource 2.0 should expose daily soft refresh")

	var routines = NPCRoutineServiceScript.new(day)
	var snapshot: Dictionary = routines.get_routine_snapshot(_base_npcs())
	_expect(snapshot.get("ok", false), "V02.22 NPC routine snapshot should load")
	_expect(int(snapshot.get("blocked_count", -1)) == 0, "V02.22 NPC routine default snapshot should not block arrivals")
	_expect(int(snapshot.get("fallback_count", -1)) == 0, "V02.22 NPC routine default snapshot should not need fallback now that batch data is complete")
	_expect(save_service.clear_for_test(), "V02.22 hidden grid service save should clean up")


func _check_main_runtime_slice() -> void:
	var save_path := "user://test_v0222_hidden_grid_life_main.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.22 hidden grid main save should clear")
	var inventory = InventoryServiceScript.new(save_service)
	_expect(inventory.collect_item("flower_pot", 1).get("ok", false), "V02.22 main runtime should seed outdoor decor")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var place_result: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(32, 21))
	_expect(place_result.get("ok", false), "V02.22 main should place outdoor decor")
	var instance_id := str(place_result.get("outdoor_item", {}).get("instance_id", ""))
	var node := main.find_child("outdoor_%s" % instance_id, true, false)
	_expect(node != null and str(node.get_meta("actor_type", "")) == "outdoor_decor", "V02.22 TownStage should render outdoor decor")
	_expect(main.move_outdoor_item(instance_id, Vector2i(33, 21)).get("ok", false), "V02.22 main should move outdoor decor")
	_expect(main.pickup_outdoor_item(instance_id).get("ok", false), "V02.22 main should pick up outdoor decor")
	_expect(main.outdoor_decoration_service.get_placed_items().is_empty(), "V02.22 main should clear outdoor decor after pickup")

	var routine_snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(routine_snapshot.get("ok", false), "V02.22 main should expose NPC routine snapshot")
	_expect(int(routine_snapshot.get("blocked_count", -1)) == 0, "V02.22 main NPC routine default snapshot should not block arrivals")
	_expect(int(routine_snapshot.get("fallback_count", -1)) == 0, "V02.22 main NPC routine default snapshot should not need fallback now that batch data is complete")
	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.22 hidden grid main should keep Mina reachable")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.22 hidden grid main should keep NPC priority")

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _base_npcs() -> Array[Dictionary]:
	return [
		{"npc_id": "mina", "cell": {"x": 38, "y": 22}},
		{"npc_id": "shopkeeper", "cell": {"x": 43, "y": 12}},
		{"npc_id": "pet_buddy", "cell": {"x": 28, "y": 20}},
		{"npc_id": "bus_helper", "cell": {"x": 36, "y": 20}},
		{"npc_id": "story_bear", "cell": {"x": 16, "y": 18}},
	]


func _finish() -> void:
	if failures.is_empty():
		print("V02.22 HIDDEN GRID LIFE SYSTEMS TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
