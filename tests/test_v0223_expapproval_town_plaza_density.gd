extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0223_expapproval_town_plaza_density.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.23 EXPAPPROVAL-002 save should clear before startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_stage_density_snapshot(main)
	_check_anchor_identity_is_unchanged()
	_check_town_plaza_targets_do_not_swallow_each_other(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_stage_density_snapshot(main) -> void:
	var stage: Node = main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.23 TownStage should expose approval snapshot")
	if stage == null or not stage.has_method("get_expapproval_snapshot"):
		return
	var snapshot: Dictionary = stage.call("get_expapproval_snapshot")
	_expect(int(snapshot.get("place_count", 0)) >= 6, "V02.23 Town Plaza should keep visible place density")
	_expect(int(snapshot.get("plaza_life_detail_count", 0)) >= 5, "V02.23 Town Plaza should add lived-in non-interactive details")
	_expect(int(snapshot.get("hotspot_count", 0)) >= 5, "V02.23 Town Plaza should keep real place entry hotspots")
	_expect(int(snapshot.get("resource_count", 0)) >= 3, "V02.23 Town Plaza should keep resource cues visible")
	_expect(int(snapshot.get("npc_count", 0)) >= 5, "V02.23 Town Plaza should keep residents visible")
	_expect(int(snapshot.get("anchor_count", 0)) == 26, "V02.23 denoise should not remove A-Z anchors")
	_expect(int(snapshot.get("muted_anchor_badge_count", 0)) == int(snapshot.get("anchor_badge_count", -1)), "V02.23 anchor badges should be muted helper marks")
	_expect(not bool(snapshot.get("collision_debug_visible", true)), "V02.23 child-facing map should keep debug collision layer hidden")


func _check_anchor_identity_is_unchanged() -> void:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.23 world map should load for anchor identity check")
	var anchors: Array = result.get("data", {}).get("memory_anchors", [])
	_expect(anchors.size() == 26, "V02.23 world map should still contain 26 anchors")
	var route_orders: Dictionary = {}
	var expected_code := 65
	for anchor_value in anchors:
		_expect(anchor_value is Dictionary, "V02.23 anchor entry should be dictionary")
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var letter := char(expected_code)
		_expect(str(anchor.get("letter", "")) == letter, "V02.23 anchor route order should remain A-Z: %s" % letter)
		_expect(str(anchor.get("anchor_id", "")).begins_with("anchor_%s_" % letter.to_lower()), "V02.23 anchor id should keep letter prefix: %s" % letter)
		_expect(int(anchor.get("route_order", 0)) == expected_code - 64, "V02.23 route_order should not change: %s" % letter)
		_expect(not route_orders.has(anchor.get("route_order", 0)), "V02.23 route_order should stay unique: %s" % letter)
		route_orders[anchor.get("route_order", 0)] = true
		_expect(not str(anchor.get("card_id", "")).is_empty(), "V02.23 card binding should remain present: %s" % letter)
		expected_code += 1


func _check_town_plaza_targets_do_not_swallow_each_other(main) -> void:
	_check_target(main, Vector2i(31, 19), "place", "interaction_home_entry", "place_entry", "place_home")
	_check_target(main, Vector2i(38, 22), "npc", "mina", "npc", "mina")
	_check_target(main, Vector2i(34, 20), "anchor", "anchor_t_taxi", "anchor", "anchor_t_taxi")
	_check_target(main, Vector2i(35, 22), "resource", "resource_stone_taxi_stop", "resource", "stone")


func _check_target(main, cell: Vector2i, expected_prompt_type: String, expected_prompt_id: String, expected_result_type: String, expected_result_id: String) -> void:
	_expect(main.move_player_to_cell(cell).get("ok", false), "V02.23 should move player to %s" % [cell])
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == expected_prompt_type, "V02.23 prompt type should match at %s" % [cell])
	_expect(str(target.get("target_id", "")) == expected_prompt_id, "V02.23 prompt target should match at %s" % [cell])
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == expected_result_type, "V02.23 interaction type should match prompt at %s" % [cell])
	match expected_result_type:
		"place_entry":
			_expect(str(result.get("place_id", "")) == expected_result_id, "V02.23 place result should not be swallowed at %s" % [cell])
		"npc":
			_expect(str(result.get("npc_id", "")) == expected_result_id, "V02.23 NPC result should not be swallowed at %s" % [cell])
		"anchor":
			_expect(str(result.get("anchor_id", "")) == expected_result_id, "V02.23 anchor result should not be swallowed at %s" % [cell])
		"resource":
			_expect(str(result.get("item_id", "")) == expected_result_id, "V02.23 resource result should not be swallowed at %s" % [cell])


func _finish() -> void:
	if failures.is_empty():
		print("V02.23 EXPAPPROVAL TOWN PLAZA DENSITY TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
