extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const NPCRoutineServiceScript := preload("res://scripts/systems/npc_routine_service.gd")

var failures: Array[String] = []


func _init() -> void:
	_check_service_arrival_and_fallback()
	_check_main_runtime_arrival_safety()
	_finish()


func _check_service_arrival_and_fallback() -> void:
	var routine_path := "user://test_v0224_npc_routine_arrival_safety.json"
	_write_routine_data(routine_path)
	var day = LocalDayServiceScript.new("local_day_002")
	var service = NPCRoutineServiceScript.new(day, routine_path, _world_map())

	var snapshot: Dictionary = service.get_routine_snapshot(_base_npcs())
	_expect(snapshot.get("ok", false), "V02.24 NPC routine arrival snapshot should succeed")
	_expect(int(snapshot.get("blocked_count", -1)) == 2, "V02.24 NPC routine should report blocked routine fallbacks")
	_expect(int(snapshot.get("fallback_count", -1)) >= 3, "V02.24 NPC routine should keep missing and blocked fallback count")
	_expect(int(snapshot.get("plaza_arrival_count", 0)) >= 2, "V02.24 NPC routine should identify Town Plaza arrivals")

	var npcs: Array = snapshot.get("npcs", [])
	var mina := _npc_by_id(npcs, "mina")
	_expect(not bool(mina.get("routine_fallback", true)), "V02.24 Mina safe plaza routine should not fallback")
	_expect(str(mina.get("arrival_zone", "")) == "town_plaza", "V02.24 Mina routine should be a Town Plaza arrival")
	_expect(str(mina.get("arrival_text", "")).contains("Mina"), "V02.24 Mina arrival feedback should be warm and visible")

	var shopkeeper := _npc_by_id(npcs, "shopkeeper")
	_expect(bool(shopkeeper.get("routine_fallback", false)), "V02.24 blocked shopkeeper routine should fallback")
	_expect(bool(shopkeeper.get("routine_blocked", false)), "V02.24 blocked shopkeeper routine should mark routine_blocked")
	_expect(_cell_matches(shopkeeper.get("cell", {}), Vector2i(43, 12)), "V02.24 blocked shopkeeper should return to base cell")

	var sunny := _npc_by_id(npcs, "pet_buddy")
	_expect(bool(sunny.get("routine_blocked", false)), "V02.24 Sunny routine on an anchor should fallback safely")
	_expect(_cell_matches(sunny.get("cell", {}), Vector2i(28, 20)), "V02.24 Sunny fallback should keep base home-side cell")

	var bus_helper := _npc_by_id(npcs, "bus_helper")
	_expect(bool(bus_helper.get("routine_fallback", false)), "V02.24 missing bus helper routine should use safe fallback")
	_expect(not bool(bus_helper.get("routine_blocked", true)), "V02.24 missing routine fallback should not count as blocked data")

	_expect_reject(service.validate_arrival_cell(Vector2i(34, 20)), "protected_anchor", "anchor", "V02.24 routine should reject anchor arrival cells")
	_expect_reject(service.validate_arrival_cell(Vector2i(31, 19)), "protected_interaction", "interaction", "V02.24 routine should reject interaction arrival cells")


func _check_main_runtime_arrival_safety() -> void:
	var save_path := "user://test_v0224_npc_routine_arrival_safety_main.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.24 NPC routine main save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(snapshot.get("ok", false), "V02.24 main should expose NPC routine snapshot")
	_expect(int(snapshot.get("plaza_arrival_count", 0)) >= 2, "V02.24 main should expose plaza arrival feel")
	var npcs: Array = snapshot.get("npcs", [])
	var mina := _npc_by_id(npcs, "mina")
	_expect(str(mina.get("arrival_zone", "")) == "town_plaza", "V02.24 main Mina should be a Town Plaza arrival")
	_expect(str(mina.get("arrival_text", "")).contains("Mina"), "V02.24 main Mina arrival text should be available")

	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.24 routine should keep Mina reachable")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.24 routine should not block Mina prompt")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "npc" and str(result.get("npc_id", "")) == "mina", "V02.24 routine should keep Mina interaction")

	_expect(main.move_player_to_cell(Vector2i(43, 12)).get("ok", false), "V02.24 routine should keep Shopkeeper reachable")
	target = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "shopkeeper", "V02.24 routine should not block Shopkeeper prompt")

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _write_routine_data(path: String) -> void:
	var data := {
		"schema_version": 1,
		"routine_days": [
			{
				"day_key": "local_day_002",
				"npcs": [
					{"routine_id": "routine_mina_safe_plaza", "npc_id": "mina", "cell": {"x": 38, "y": 22}, "label": "Mina 在广场边等你。"},
					{"routine_id": "routine_shopkeeper_bad_entry", "npc_id": "shopkeeper", "cell": {"x": 31, "y": 19}, "label": "这条数据会被安全 fallback 接住。"},
					{"routine_id": "routine_sunny_bad_anchor", "npc_id": "pet_buddy", "cell": {"x": 34, "y": 20}, "label": "这条数据会被安全 fallback 接住。"}
				]
			}
		]
	}
	var file := FileAccess.open(path, FileAccess.WRITE)
	_expect(file != null, "V02.24 NPC routine test should create routine data")
	if file != null:
		file.store_string(JSON.stringify(data, "\t"))


func _world_map() -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.24 NPC routine should load world map")
	return result.get("data", {}).duplicate(true)


func _base_npcs() -> Array:
	return [
		{"npc_id": "mina", "cell": {"x": 38, "y": 22}},
		{"npc_id": "shopkeeper", "cell": {"x": 43, "y": 12}},
		{"npc_id": "pet_buddy", "cell": {"x": 28, "y": 20}},
		{"npc_id": "bus_helper", "cell": {"x": 36, "y": 20}},
		{"npc_id": "story_bear", "cell": {"x": 16, "y": 18}},
	]


func _npc_by_id(npcs: Array, npc_id: String) -> Dictionary:
	for value in npcs:
		if value is Dictionary and str((value as Dictionary).get("npc_id", "")) == npc_id:
			return value
	_expect(false, "V02.24 NPC routine snapshot should include %s" % npc_id)
	return {}


func _expect_reject(result: Dictionary, reason: String, protected_kind: String, message: String) -> void:
	_expect(not result.get("ok", true), message)
	_expect(str(result.get("reason", "")) == reason, "%s should return reason %s" % [message, reason])
	_expect(str(result.get("protected_kind", "")) == protected_kind, "%s should identify %s" % [message, protected_kind])


func _cell_matches(value: Variant, cell: Vector2i) -> bool:
	return value is Dictionary and int((value as Dictionary).get("x", -1)) == cell.x and int((value as Dictionary).get("y", -1)) == cell.y


func _finish() -> void:
	if failures.is_empty():
		print("V02.24 NPC ROUTINE ARRIVAL SAFETY TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
