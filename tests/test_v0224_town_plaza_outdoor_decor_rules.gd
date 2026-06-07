extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const OutdoorDecorationServiceScript := preload("res://scripts/systems/outdoor_decoration_service.gd")

var failures: Array[String] = []


func _init() -> void:
	_check_outdoor_decor_service_rules()
	_check_town_plaza_runtime_stay_points()
	_finish()


func _check_outdoor_decor_service_rules() -> void:
	var save_path := "user://test_v0224_town_plaza_outdoor_decor_rules_service.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.24 outdoor decor rule save should clear")
	var inventory = InventoryServiceScript.new(save_service)
	_expect(inventory.collect_item("flower_pot", 3).get("ok", false), "V02.24 outdoor decor should seed small decor")
	_expect(inventory.collect_item("soft_rug", 1).get("ok", false), "V02.24 outdoor decor should seed larger decor")
	var outdoor = OutdoorDecorationServiceScript.new(save_service, inventory, _world_map(), _resource_points(), _base_npcs())

	var summary: Dictionary = outdoor.get_allowed_place_summary()
	_expect(summary.get("ok", false), "V02.24 outdoor decor should expose allowed-place summary")
	_expect(int(summary.get("allowed_zone_count", 0)) >= 2, "V02.24 outdoor decor should define plaza-side allowed zones")
	_expect(int(summary.get("protected_anchor_count", 0)) == 26, "V02.24 outdoor decor should protect all A-Z anchors")
	_expect(int(summary.get("protected_resource_count", 0)) >= 3, "V02.24 outdoor decor should protect resource points")

	var placed: Dictionary = outdoor.place_item("flower_pot", Vector2i(32, 21))
	_expect(placed.get("ok", false), "V02.24 outdoor decor should allow a curated Town Plaza corner")
	var instance_id := str(placed.get("outdoor_item", {}).get("instance_id", ""))
	_expect(not instance_id.is_empty(), "V02.24 outdoor decor should return a stable outdoor instance id")
	_expect(_cell_matches(placed.get("outdoor_item", {}).get("cell", {}), Vector2i(32, 21)), "V02.24 outdoor decor should save the chosen safe corner")
	_expect(outdoor.move_item(instance_id, Vector2i(33, 21)).get("ok", false), "V02.24 outdoor decor should still move within safe Town Plaza corners")

	_expect_reject(outdoor.validate_placement("flower_pot", Vector2i(5, 5)), "not_allowed_place", "", "V02.24 outdoor decor should reject non-plaza corners")
	_expect_reject(outdoor.validate_placement("flower_pot", Vector2i(31, 19)), "covers_core_target", "interaction", "V02.24 outdoor decor should not cover Home entry")
	_expect_reject(outdoor.validate_placement("flower_pot", Vector2i(34, 20)), "covers_core_target", "anchor", "V02.24 outdoor decor should not cover Taxi anchor")
	_expect_reject(outdoor.validate_placement("flower_pot", Vector2i(35, 22)), "covers_core_target", "resource", "V02.24 outdoor decor should not cover Taxi stone resource")
	_expect_reject(outdoor.validate_placement("flower_pot", Vector2i(38, 22)), "covers_core_target", "npc", "V02.24 outdoor decor should not cover Mina")
	_expect_reject(outdoor.validate_placement("soft_rug", Vector2i(33, 20)), "covers_core_target", "anchor", "V02.24 outdoor decor should reject larger decor whose footprint covers an anchor")
	_expect_reject(outdoor.place_item("flower_pot", Vector2i(33, 21)), "occupied", "", "V02.24 outdoor decor should reject overlapping placed decor")
	_expect(save_service.clear_for_test(), "V02.24 outdoor decor rule save should clean up")


func _check_town_plaza_runtime_stay_points() -> void:
	var save_path := "user://test_v0224_town_plaza_outdoor_decor_rules_runtime.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.24 Town Plaza runtime save should clear")
	var inventory = InventoryServiceScript.new(save_service)
	_expect(inventory.collect_item("flower_pot", 1).get("ok", false), "V02.24 Town Plaza runtime should seed decor")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var stage: Node = main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.24 TownStage should expose plaza snapshot")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(snapshot.get("plaza_stay_point_count", 0)) >= 4, "V02.24 Town Plaza should expose at least four stay points")
		for node_name in ["PlazaBenchHome", "PlazaBenchShop", "PlazaChatStool", "PlazaSnackCrate"]:
			_expect((snapshot.get("plaza_stay_point_names", []) as Array).has(node_name), "V02.24 Town Plaza stay point should include %s" % node_name)
		_expect(int(snapshot.get("anchor_count", 0)) == 26, "V02.24 Town Plaza should keep all A-Z anchors")

	var placed: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(32, 21))
	_expect(placed.get("ok", false), "V02.24 Town Plaza runtime should place decor in a safe plaza corner")
	var instance_id := str(placed.get("outdoor_item", {}).get("instance_id", ""))
	var node := main.find_child("outdoor_%s" % instance_id, true, false)
	_expect(node != null and str(node.get_meta("actor_type", "")) == "outdoor_decor", "V02.24 TownStage should render safe outdoor decor")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var placed_snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(placed_snapshot.get("outdoor_decor_count", 0)) == 1, "V02.24 TownStage snapshot should count rendered outdoor decor")
	_expect_reject(main.place_outdoor_item("flower_pot", Vector2i(34, 20)), "covers_core_target", "anchor", "V02.24 Town Plaza runtime should reject decor on an anchor")

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _world_map() -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.24 outdoor decor should load world map")
	return result.get("data", {}).duplicate(true)


func _resource_points() -> Array:
	var file := FileAccess.open("res://data/life/resource_points.json", FileAccess.READ)
	_expect(file != null, "V02.24 outdoor decor should load resource points")
	if file == null:
		return []
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	_expect(parsed is Dictionary, "V02.24 resource points should be a JSON object")
	if not parsed is Dictionary:
		return []
	return (parsed as Dictionary).get("resource_points", []).duplicate(true)


func _base_npcs() -> Array:
	return [
		{"npc_id": "mina", "cell": {"x": 38, "y": 22}},
		{"npc_id": "shopkeeper", "cell": {"x": 43, "y": 12}},
		{"npc_id": "pet_buddy", "cell": {"x": 28, "y": 20}},
		{"npc_id": "bus_helper", "cell": {"x": 36, "y": 20}},
		{"npc_id": "story_bear", "cell": {"x": 16, "y": 18}},
	]


func _expect_reject(result: Dictionary, reason: String, protected_kind: String, message: String) -> void:
	_expect(not result.get("ok", true), message)
	_expect(str(result.get("reason", "")) == reason, "%s should return reason %s" % [message, reason])
	if not protected_kind.is_empty():
		_expect(str(result.get("protected_kind", "")) == protected_kind, "%s should protect %s" % [message, protected_kind])
	_expect(str(result.get("feedback", "")).strip_edges() != "", "%s should include child-facing feedback" % message)


func _cell_matches(value: Variant, cell: Vector2i) -> bool:
	return value is Dictionary and int((value as Dictionary).get("x", -1)) == cell.x and int((value as Dictionary).get("y", -1)) == cell.y


func _finish() -> void:
	if failures.is_empty():
		print("V02.24 TOWN PLAZA OUTDOOR DECOR RULE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
