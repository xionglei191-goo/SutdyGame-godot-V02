extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const NPCRoutineServiceScript := preload("res://scripts/systems/npc_routine_service.gd")

const EXPECTED_DAYS: Array[String] = [
	"local_day_001",
	"local_day_002",
	"local_day_003",
	"local_day_004",
	"local_day_005",
	"local_day_006",
	"local_day_007",
]
const EXPECTED_NPCS: Array[String] = ["mina", "shopkeeper", "pet_buddy", "bus_helper", "story_bear"]
const FORBIDDEN_TEXT: Array[String] = ["赶路", "迟到", "错过", "值班", "必须", "倒计时", "打卡", "任务", "作业", "考试", "测验", "分数"]

var failures: Array[String] = []


func _init() -> void:
	_check_default_batch_data()
	_check_fallback_still_handles_bad_batch_data()
	_check_main_runtime_day_snapshot()
	_finish()


func _check_default_batch_data() -> void:
	var service = NPCRoutineServiceScript.new(LocalDayServiceScript.new("local_day_001"), NPCRoutineServiceScript.ROUTINES_PATH, _world_map())
	_expect(service.is_loaded(), "V02.26 CONTENTBATCH-001 NPC routine data should load")
	_expect(service.routines_by_day.size() == 7, "V02.26 CONTENTBATCH-001 should define 7 routine days")
	for day_key in EXPECTED_DAYS:
		_expect(service.routines_by_day.has(day_key), "V02.26 CONTENTBATCH-001 should include day: %s" % day_key)
		var day_routines: Dictionary = service.routines_by_day.get(day_key, {})
		_expect(day_routines.size() == EXPECTED_NPCS.size(), "V02.26 CONTENTBATCH-001 day should include all core residents: %s" % day_key)
		for npc_id in EXPECTED_NPCS:
			_expect(day_routines.has(npc_id), "V02.26 CONTENTBATCH-001 day should include resident %s on %s" % [npc_id, day_key])
			var routine: Dictionary = day_routines.get(npc_id, {})
			_expect(str(routine.get("routine_id", "")).begins_with("routine_%s_" % _routine_prefix(npc_id)), "V02.26 CONTENTBATCH-001 routine id should be stable for %s on %s" % [npc_id, day_key])
			_expect(_label_is_child_safe(str(routine.get("label", ""))), "V02.26 CONTENTBATCH-001 label should be child-safe for %s on %s" % [npc_id, day_key])

	for day_key in EXPECTED_DAYS:
		service.local_day_service = LocalDayServiceScript.new(day_key)
		var snapshot: Dictionary = service.get_routine_snapshot(_base_npcs())
		_expect(snapshot.get("ok", false), "V02.26 CONTENTBATCH-001 snapshot should succeed: %s" % day_key)
		_expect(int(snapshot.get("blocked_count", -1)) == 0, "V02.26 CONTENTBATCH-001 default data should not block arrivals: %s %s" % [day_key, _blocked_summary(snapshot)])
		_expect(int(snapshot.get("fallback_count", -1)) == 0, "V02.26 CONTENTBATCH-001 default data should not need fallback: %s %s" % [day_key, _blocked_summary(snapshot)])
		_expect(int(snapshot.get("plaza_arrival_count", 0)) >= 2, "V02.26 CONTENTBATCH-001 should keep a gentle plaza presence: %s" % day_key)
		for npc in snapshot.get("npcs", []):
			if npc is Dictionary:
				var npc_data: Dictionary = npc
				_expect(_label_is_child_safe(str(npc_data.get("routine_label", ""))), "V02.26 CONTENTBATCH-001 runtime label should stay child-safe: %s" % day_key)

	for npc_id in EXPECTED_NPCS:
		_expect(_unique_cell_count_for_npc(service, npc_id) >= 2, "V02.26 CONTENTBATCH-001 should give light variation to %s" % npc_id)


func _check_fallback_still_handles_bad_batch_data() -> void:
	var routine_path := "user://test_v026_contentbatch001_bad_routines.json"
	var data := {
		"schema_version": 1,
		"routine_days": [
			{
				"day_key": "local_day_003",
				"npcs": [
					{"routine_id": "routine_mina_bad_anchor", "npc_id": "mina", "cell": {"x": 34, "y": 20}, "label": "这条坏数据会被温和接住。"},
					{"routine_id": "routine_shopkeeper_safe", "npc_id": "shopkeeper", "cell": {"x": 43, "y": 12}, "label": "店长在门口看看贴纸。"}
				]
			}
		]
	}
	var file := FileAccess.open(routine_path, FileAccess.WRITE)
	_expect(file != null, "V02.26 CONTENTBATCH-001 should create fallback test data")
	if file != null:
		file.store_string(JSON.stringify(data, "\t"))
		file = null
	var service = NPCRoutineServiceScript.new(LocalDayServiceScript.new("local_day_003"), routine_path, _world_map())
	_expect(service.is_loaded(), "V02.26 CONTENTBATCH-001 fallback test data should load")
	var snapshot: Dictionary = service.get_routine_snapshot(_base_npcs())
	_expect(int(snapshot.get("blocked_count", -1)) == 1, "V02.26 CONTENTBATCH-001 fallback should count blocked bad routine")
	_expect(int(snapshot.get("fallback_count", -1)) >= 4, "V02.26 CONTENTBATCH-001 fallback should cover blocked and missing residents")
	var mina := _npc_by_id(snapshot.get("npcs", []), "mina")
	_expect(bool(mina.get("routine_blocked", false)), "V02.26 CONTENTBATCH-001 fallback should mark bad Mina routine blocked")
	_expect(_cell_matches(mina.get("cell", {}), Vector2i(38, 22)), "V02.26 CONTENTBATCH-001 fallback should keep Mina at safe base cell")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(routine_path))


func _check_main_runtime_day_snapshot() -> void:
	var save_path := "user://test_v026_contentbatch001_main.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-001 main save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_007")
	root.add_child(main)
	main.call("_ready")

	var snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(snapshot.get("ok", false), "V02.26 CONTENTBATCH-001 main snapshot should succeed")
	_expect(str(snapshot.get("day_key", "")) == "local_day_007", "V02.26 CONTENTBATCH-001 main should use selected day")
	_expect(int(snapshot.get("blocked_count", -1)) == 0, "V02.26 CONTENTBATCH-001 main should have no blocked default routines")
	var mina := _npc_by_id(snapshot.get("npcs", []), "mina")
	_expect(_cell_matches(mina.get("cell", {}), Vector2i(38, 21)), "V02.26 CONTENTBATCH-001 main should apply day 7 Mina cell")
	_expect(main.move_player_to_cell(Vector2i(38, 21)).get("ok", false), "V02.26 CONTENTBATCH-001 main should keep Mina reachable")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.26 CONTENTBATCH-001 main should keep Mina prompt")

	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-001 main save should clean up")
	root.remove_child(main)
	main.queue_free()


func _world_map() -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.26 CONTENTBATCH-001 should load world map")
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
	_expect(false, "V02.26 CONTENTBATCH-001 snapshot should include %s" % npc_id)
	return {}


func _unique_cell_count_for_npc(service, npc_id: String) -> int:
	var cells: Dictionary = {}
	for day_key in EXPECTED_DAYS:
		var day_routines: Dictionary = service.routines_by_day.get(day_key, {})
		var routine: Dictionary = day_routines.get(npc_id, {})
		cells[_cell_key(routine.get("cell", {}))] = true
	return cells.size()


func _routine_prefix(npc_id: String) -> String:
	match npc_id:
		"pet_buddy":
			return "sunny"
		_:
			return npc_id


func _label_is_child_safe(label: String) -> bool:
	if label.strip_edges().is_empty():
		return false
	for forbidden in FORBIDDEN_TEXT:
		if label.contains(forbidden):
			return false
	return true


func _cell_matches(value: Variant, cell: Vector2i) -> bool:
	return value is Dictionary and int((value as Dictionary).get("x", -1)) == cell.x and int((value as Dictionary).get("y", -1)) == cell.y


func _cell_key(value: Variant) -> String:
	if value is Dictionary:
		return "%s,%s" % [int((value as Dictionary).get("x", -1)), int((value as Dictionary).get("y", -1))]
	return "-1,-1"


func _blocked_summary(snapshot: Dictionary) -> String:
	var parts: Array[String] = []
	for value in snapshot.get("npcs", []):
		if value is Dictionary:
			var npc: Dictionary = value
			if bool(npc.get("routine_blocked", false)):
				parts.append("%s:%s:%s" % [str(npc.get("npc_id", "")), str(npc.get("blocked_reason", "")), _cell_key(npc.get("cell", {}))])
	return ",".join(parts)


func _finish() -> void:
	if failures.is_empty():
		print("V02.26 CONTENTBATCH-001 NPC ROUTINE BATCH TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
