extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0221_livegate_hotspot_priority.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.21 hotspot priority save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_blueprint_spacing()
	_check_npc_priority_over_nearby_anchor(main)
	_check_exact_anchor_remains_deliberate(main)
	_check_npc_priority_over_nearby_resource(main)
	_check_exact_resource_remains_deliberate(main)
	_check_place_entry_remains_exact(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_blueprint_spacing() -> void:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.21 world map should load for hotspot audit")
	var data: Dictionary = result.get("data", {})
	var reserved_cells: Dictionary = {}
	for npc in main_npc_cells():
		reserved_cells[_cell_key(npc.get("cell", {}))] = str(npc.get("npc_id", "npc"))
	for interaction in data.get("interaction_cells", []):
		reserved_cells[_cell_key(interaction.get("cell", {}))] = str(interaction.get("interaction_id", "interaction"))
	for anchor_value in data.get("memory_anchors", []):
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var key := _cell_key(anchor.get("position", {}))
		_expect(not reserved_cells.has(key), "V02.21 anchor should not share exact NPC/place hotspot cell: %s" % anchor.get("anchor_id", ""))


func _check_npc_priority_over_nearby_anchor(main) -> void:
	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.21 should reach Mina priority check cell")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc", "V02.21 Mina cell prompt should prefer NPC over nearby anchor")
	_expect(str(target.get("target_id", "")) == "mina", "V02.21 Mina prompt should name Mina")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "npc", "V02.21 Mina action should match NPC prompt")
	_expect(str(result.get("npc_id", "")) == "mina", "V02.21 Mina action should not be swallowed by anchor/resource")


func _check_exact_anchor_remains_deliberate(main) -> void:
	_expect(main.move_player_to_cell(Vector2i(34, 20)).get("ok", false), "V02.21 should reach exact Taxi anchor cell")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "anchor", "V02.21 exact anchor cell should remain an anchor prompt")
	_expect(str(target.get("target_id", "")) == "anchor_t_taxi", "V02.21 exact anchor prompt should name Taxi")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "anchor", "V02.21 exact anchor action should collect anchor")
	_expect(str(result.get("anchor_id", "")) == "anchor_t_taxi", "V02.21 exact anchor action should not be swallowed by resident")


func _check_npc_priority_over_nearby_resource(main) -> void:
	_expect(main.move_player_to_cell(Vector2i(36, 21)).get("ok", false), "V02.21 should reach Bus Helper priority check cell")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc", "V02.21 Bus Helper prompt should prefer NPC over nearby stone")
	_expect(str(target.get("target_id", "")) == "bus_helper", "V02.21 Bus Helper prompt should name the resident")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "npc", "V02.21 Bus Helper action should match NPC prompt")
	_expect(str(result.get("npc_id", "")) == "bus_helper", "V02.21 Bus Helper action should not collect nearby resource")


func _check_exact_resource_remains_deliberate(main) -> void:
	_expect(main.move_player_to_cell(Vector2i(35, 22)).get("ok", false), "V02.21 should reach exact stone resource cell")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "resource", "V02.21 exact resource cell should remain a deliberate pickup")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "resource", "V02.21 exact resource action should collect resource")
	_expect(str(result.get("item_id", "")) == "stone", "V02.21 exact resource action should collect the stone")


func _check_place_entry_remains_exact(main) -> void:
	_expect(main.move_player_to_cell(Vector2i(31, 19)).get("ok", false), "V02.21 should reach exact Home entry cell")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "place", "V02.21 exact place entry should prefer place over nearby resident")
	_expect(str(target.get("target_id", "")) == "interaction_home_entry", "V02.21 Home entry prompt should stay stable")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "place_entry", "V02.21 exact place entry action should enter place")
	_expect(str(result.get("place_id", "")) == "place_home", "V02.21 exact place entry should open Home")


func main_npc_cells() -> Array[Dictionary]:
	return [
		{"npc_id": "mina", "cell": {"x": 38, "y": 22}},
		{"npc_id": "shopkeeper", "cell": {"x": 43, "y": 12}},
		{"npc_id": "pet_buddy", "cell": {"x": 28, "y": 20}},
		{"npc_id": "bus_helper", "cell": {"x": 36, "y": 20}},
		{"npc_id": "story_bear", "cell": {"x": 16, "y": 18}},
	]


func _cell_key(value: Variant) -> String:
	if value is Dictionary:
		var cell: Dictionary = value
		return "%s,%s" % [int(cell.get("x", 0)), int(cell.get("y", 0))]
	if value is Vector2i:
		var vector: Vector2i = value
		return "%s,%s" % [vector.x, vector.y]
	return "0,0"


func _finish() -> void:
	if failures.is_empty():
		print("V02.21 LIVEGATE HOTSPOT PRIORITY TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
