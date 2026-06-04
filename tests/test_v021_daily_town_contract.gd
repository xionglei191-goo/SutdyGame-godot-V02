extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")

const DAY_ONE := "local_day_2026_06_04"
const DAY_TWO := "local_day_2026_06_05"
const LOCAL_DAY_SERVICE_PATH := "res://scripts/systems/local_day_service.gd"
const GREETING_SERVICE_PATH := "res://scripts/systems/daily_greeting_service.gd"
const RESOURCE_SERVICE_PATHS := ["res://scripts/systems/daily_resource_service.gd", "res://scripts/systems/resource_refresh_service.gd"]

const REQUIRED_GREETING_NPCS := ["mina", "shopkeeper", "pet_buddy", "story_bear", "bus_helper"]
const REQUIRED_REQUEST_NPCS := ["mina", "shopkeeper", "pet_buddy", "story_bear"]
const REQUIRED_RESOURCE_ITEMS := ["branch", "flower", "stone"]
const RESOURCE_POINT_IDS := ["resource_branch_bear_corner", "resource_flower_sun_plaza", "resource_stone_taxi_stop"]
const PRESSURE_WORDS := ["test", "quiz", "exam", "score", "drill", "lesson", "homework"]

var failures: Array[String] = []


func _init() -> void:
	_check_current_mina_reload_and_duplicate_prevention()
	_check_daily_request_day_injection_and_cross_day_reset()
	_check_expanded_daily_request_data()
	_check_daily_greeting_service_contract()
	_check_daily_resource_refresh_contract()
	_finish()


func _check_current_mina_reload_and_duplicate_prevention() -> void:
	var save_service = SaveServiceScript.new("user://test_v021_current_mina_duplicate.json")
	_expect(save_service.clear_for_test(), "current Mina save should clear")
	_expect(save_service.reset_for_test(), "current Mina save should reset")

	var inventory = InventoryServiceScript.new(save_service)
	var daily = DailyRequestServiceScript.new(save_service, inventory)
	_expect(daily.is_loaded(), "DailyRequestService should load existing request data")
	_expect(daily.interact_for_npc("mina").get("request_status", "") == "active", "Mina request should start")
	_expect(inventory.collect_item("branch", 1).get("ok", false), "Mina duplicate baseline should collect one branch")
	var complete: Dictionary = daily.interact_for_npc("mina")
	_expect(complete.get("request_status", "") == "completed", "Mina request should complete with one branch")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 6, "Mina completion should award coins once")

	var repeat: Dictionary = daily.interact_for_npc("mina")
	_expect(repeat.get("request_status", "") == "completed", "Mina same-day repeat should stay completed")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 6, "Mina same-day repeat should not duplicate coins")

	var reloaded = DailyRequestServiceScript.new(save_service, InventoryServiceScript.new(save_service))
	var reloaded_repeat: Dictionary = reloaded.interact_for_npc("mina")
	_expect(reloaded_repeat.get("request_status", "") == "completed", "Mina completed state should survive service reload")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 6, "Mina reload repeat should not duplicate coins")
	_expect(save_service.clear_for_test(), "current Mina duplicate save should clean up")


func _check_daily_request_day_injection_and_cross_day_reset() -> void:
	var save_service = SaveServiceScript.new("user://test_v021_daily_request_day_key.json")
	_expect(save_service.clear_for_test(), "daily request day-key save should clear")
	_expect(save_service.reset_for_test(), "daily request day-key save should reset")

	var inventory = InventoryServiceScript.new(save_service)
	var day_service = _new_day_service(DAY_ONE)
	_expect(day_service != null, "LocalDayService should support injectable day_key for DailyRequestService")
	if day_service == null:
		_expect(save_service.clear_for_test(), "daily request day-key save should clean up after missing contract")
		return
	var daily = DailyRequestServiceScript.new(save_service, inventory, day_service)

	_expect(_reported_day_key(day_service) == DAY_ONE, "LocalDayService should report the injected day_key")
	_expect(daily.interact_for_npc("mina").get("request_status", "") == "active", "day-key request should start on injected day")
	var saved_start_state: Dictionary = _saved_request_state(save_service, DAY_ONE, "daily_mina_branch_001")
	_expect(str(saved_start_state.get("day_key", "")) == DAY_ONE, "request start state should save injected day_key")

	_expect(inventory.collect_item("branch", 1).get("ok", false), "day-key request should collect one branch")
	_expect(daily.interact_for_npc("mina").get("request_status", "") == "completed", "day-key request should complete on day one")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 6, "day-key request should award day-one coins once")

	var reloaded_day_service = _new_day_service(DAY_ONE)
	_expect(reloaded_day_service != null, "reloaded DailyRequestService should receive an injected day service")
	var reloaded = DailyRequestServiceScript.new(save_service, InventoryServiceScript.new(save_service), reloaded_day_service)
	_expect(reloaded.interact_for_npc("mina").get("request_status", "") == "completed", "same-day reload should keep completed request closed")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 6, "same-day reload should not duplicate reward")

	_expect(_configure_day_key(reloaded_day_service, DAY_TWO), "LocalDayService should accept a second injected day")
	var next_day: Dictionary = reloaded.interact_for_npc("mina")
	_expect(next_day.get("request_status", "") == "active", "cross-day reset should reopen Mina request")
	_expect(not bool(next_day.get("completed_today", true)), "cross-day reset should clear completed_today")
	var next_day_state: Dictionary = _saved_request_state(save_service, DAY_TWO, "daily_mina_branch_001")
	_expect(str(next_day_state.get("day_key", "")) == DAY_TWO, "cross-day reset should save the new day_key")
	_expect(save_service.clear_for_test(), "daily request day-key save should clean up")


func _check_expanded_daily_request_data() -> void:
	var data: Dictionary = _read_json("res://data/life/daily_requests.json")
	var requests: Array = data.get("requests", [])
	_expect(requests.size() >= 4, "V02.1 daily request data should include Mina plus at least three expanded NPC requests")

	var request_ids: Dictionary = {}
	var npc_ids: Dictionary = {}
	for value in requests:
		if not value is Dictionary:
			_expect(false, "daily request entries should be objects")
			continue
		var request: Dictionary = value
		var request_id := str(request.get("request_id", ""))
		_expect(not request_id.is_empty(), "daily request should have a stable request_id")
		_expect(not request_ids.has(request_id), "daily request IDs should be unique: %s" % request_id)
		request_ids[request_id] = true
		npc_ids[str(request.get("npc_id", ""))] = true
		_expect(_has_memory_story_contract(request), "%s should keep memory-palace story fields" % request_id)
		_expect(_is_child_safe_text_block(request.get("text", {})), "%s should avoid pressure wording" % request_id)

	for npc_id in REQUIRED_REQUEST_NPCS:
		_expect(npc_ids.has(npc_id), "V02.1 daily request data should include an NPC request for %s" % npc_id)

	var item_data: Dictionary = _read_json("res://data/items/life_items.json")
	var item_ids: Dictionary = {}
	for value in item_data.get("items", []):
		if value is Dictionary:
			var item: Dictionary = value
			item_ids[str(item.get("item_id", ""))] = true
	for item_id in REQUIRED_RESOURCE_ITEMS:
		_expect(item_ids.has(item_id), "V02.1 town resource item catalog should include %s" % item_id)


func _check_daily_greeting_service_contract() -> void:
	var script: Script = _load_optional_script(GREETING_SERVICE_PATH, "DailyGreetingService")
	if script == null:
		return

	var save_service = SaveServiceScript.new("user://test_v021_daily_greetings.json")
	_expect(save_service.clear_for_test(), "daily greeting save should clear")
	_expect(save_service.reset_for_test(), "daily greeting save should reset")
	var day_service = _new_day_service(DAY_ONE)
	_expect(day_service != null, "DailyGreetingService should receive injectable LocalDayService")
	if day_service == null:
		_expect(save_service.clear_for_test(), "daily greeting save should clean up after missing day service")
		return
	var service = script.new(save_service, day_service)
	var greet_method := _first_method(service, ["greet_npc", "interact_for_npc", "get_daily_greeting"])
	_expect(not greet_method.is_empty(), "DailyGreetingService should expose greet_npc, interact_for_npc, or get_daily_greeting")
	if greet_method.is_empty():
		_expect(save_service.clear_for_test(), "daily greeting save should clean up after missing method")
		return

	for npc_id in REQUIRED_GREETING_NPCS:
		var first: Dictionary = _call_dict(service, greet_method, [npc_id])
		_expect(first.get("ok", false), "first daily greeting should succeed for %s" % npc_id)
		_expect(str(first.get("npc_id", npc_id)) == npc_id, "daily greeting should identify %s" % npc_id)
		_expect(str(first.get("day_key", DAY_ONE)) == DAY_ONE, "daily greeting should report injected day for %s" % npc_id)
		_expect(not str(first.get("text", "")).is_empty(), "daily greeting should return child-facing text for %s" % npc_id)
		_expect(_is_child_safe_line(str(first.get("text", ""))), "daily greeting should avoid pressure wording for %s" % npc_id)

		var repeat: Dictionary = _call_dict(service, greet_method, [npc_id])
		_expect(_is_same_day_greeting_repeat(repeat), "same-day greeting should be marked as already greeted for %s" % npc_id)

	var reloaded_day_service = _new_day_service(DAY_ONE)
	var reloaded = script.new(save_service, reloaded_day_service)
	var reloaded_repeat: Dictionary = _call_dict(reloaded, greet_method, ["mina"])
	_expect(_is_same_day_greeting_repeat(reloaded_repeat), "reloaded same-day greeting should prevent duplicates")

	_expect(_configure_day_key(reloaded_day_service, DAY_TWO), "LocalDayService should accept next day for greetings")
	var next_day: Dictionary = _call_dict(reloaded, greet_method, ["mina"])
	_expect(bool(next_day.get("first_today", true)) or str(next_day.get("status", "")) == "new_greeting", "next-day greeting should reset Mina")
	_expect(save_service.clear_for_test(), "daily greeting save should clean up")


func _check_daily_resource_refresh_contract() -> void:
	var script: Script = _load_first_optional_script(RESOURCE_SERVICE_PATHS, "DailyResourceService or ResourceRefreshService")
	if script == null:
		return

	var save_service = SaveServiceScript.new("user://test_v021_daily_resources.json")
	_expect(save_service.clear_for_test(), "daily resource save should clear")
	_expect(save_service.reset_for_test(), "daily resource save should reset")
	var inventory = InventoryServiceScript.new(save_service)
	var day_service = _new_day_service(DAY_ONE)
	_expect(day_service != null, "DailyResourceService should receive injectable LocalDayService")
	if day_service == null:
		_expect(save_service.clear_for_test(), "daily resource save should clean up after missing day service")
		return
	var service = script.new(save_service, inventory, day_service)
	var collect_method := _first_method(service, ["collect_resource", "collect_resource_point", "interact_resource"])
	_expect(not collect_method.is_empty(), "DailyResourceService should expose collect_resource, collect_resource_point, or interact_resource")
	if collect_method.is_empty():
		_expect(save_service.clear_for_test(), "daily resource save should clean up after missing method")
		return

	var listed_resources := _list_daily_resources(service)
	_expect(listed_resources.size() >= 3, "DailyResourceService should expose at least branch, flower, and pebble resource points")

	var first: Dictionary = _call_dict(service, collect_method, [RESOURCE_POINT_IDS[0]])
	_expect(first.get("ok", false), "first resource collection should succeed")
	_expect(str(first.get("day_key", DAY_ONE)) == DAY_ONE, "resource collection should report injected day")
	_expect(REQUIRED_RESOURCE_ITEMS.has(str(first.get("item_id", "branch"))), "resource collection should yield a known town resource")
	var inventory_state: Dictionary = save_service.load_game_state().get("inventory", {})
	_expect(int(inventory_state.get(str(first.get("item_id", "branch")), 0)) >= 1, "resource collection should persist inventory")

	var repeat: Dictionary = _call_dict(service, collect_method, [RESOURCE_POINT_IDS[0]])
	_expect(_is_same_day_resource_repeat(repeat), "same-day resource collection should prevent duplicates")

	var reloaded_day_service = _new_day_service(DAY_ONE)
	var reloaded = script.new(save_service, InventoryServiceScript.new(save_service), reloaded_day_service)
	var reloaded_repeat: Dictionary = _call_dict(reloaded, collect_method, [RESOURCE_POINT_IDS[0]])
	_expect(_is_same_day_resource_repeat(reloaded_repeat), "reloaded same-day resource should stay depleted")

	_expect(_configure_day_key(reloaded_day_service, DAY_TWO), "LocalDayService should accept next day for resources")
	if reloaded.has_method("refresh_for_day"):
		reloaded.call("refresh_for_day")
	var next_day: Dictionary = _call_dict(reloaded, collect_method, [RESOURCE_POINT_IDS[0]])
	_expect(next_day.get("ok", false), "next-day resource refresh should make the resource collectable again")
	_expect(save_service.clear_for_test(), "daily resource save should clean up")


func _configure_day_key(service, day_key: String) -> bool:
	if service.has_method("set_day_key"):
		service.call("set_day_key", day_key)
		return true
	if service.has_method("configure_day_key"):
		service.call("configure_day_key", day_key)
		return true
	if service.has_method("set_day_key_for_test"):
		service.call("set_day_key_for_test", day_key)
		return true
	return false


func _reported_day_key(service) -> String:
	if service.has_method("get_day_key"):
		return str(service.call("get_day_key"))
	return ""


func _first_method(service, method_names: Array) -> String:
	for method_name in method_names:
		if service.has_method(str(method_name)):
			return str(method_name)
	return ""


func _call_dict(service, method_name: String, args: Array) -> Dictionary:
	var result: Variant = service.callv(method_name, args)
	if result is Dictionary:
		return result
	return {"ok": false, "reason": "non_dictionary_result", "method": method_name}


func _list_daily_resources(service) -> Array:
	if service.has_method("get_daily_resources"):
		var result: Variant = service.call("get_daily_resources")
		if result is Array:
			return result
	if service.has_method("get_available_points"):
		var result: Variant = service.call("get_available_points")
		if result is Array:
			return result
	return RESOURCE_POINT_IDS.duplicate()


func _load_optional_script(path: String, label: String) -> Script:
	if not FileAccess.file_exists(path):
		_expect(false, "%s should exist at %s" % [label, path])
		return null
	var script: Variant = load(path)
	if script is Script:
		var typed_script: Script = script
		if typed_script.can_instantiate():
			return typed_script
		_expect(false, "%s should compile and instantiate" % label)
		return null
	_expect(false, "%s should load as a script" % label)
	return null


func _load_first_optional_script(paths: Array, label: String) -> Script:
	for path in paths:
		if FileAccess.file_exists(str(path)):
			return _load_optional_script(str(path), label)
	_expect(false, "%s should exist at one of: %s" % [label, ", ".join(paths)])
	return null


func _new_day_service(day_key: String):
	var script: Script = _load_optional_script(LOCAL_DAY_SERVICE_PATH, "LocalDayService")
	if script == null:
		return null
	var day_service = script.new(day_key)
	if _reported_day_key(day_service) != day_key:
		_configure_day_key(day_service, day_key)
	return day_service


func _read_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_expect(false, "should open JSON file: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	_expect(false, "JSON file should parse as an object: %s" % path)
	return {}


func _has_memory_story_contract(request: Dictionary) -> bool:
	var memory_story: Dictionary = request.get("memory_story", {})
	for field in ["letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]:
		if str(memory_story.get(field, "")).is_empty():
			return false
	return true


func _saved_request_state(save_service, day_key: String, request_id: String) -> Dictionary:
	var all_requests: Dictionary = save_service.load_game_state().get("daily_requests", {})
	if all_requests.has(day_key):
		return all_requests.get(day_key, {}).get(request_id, {}).duplicate(true)
	return all_requests.get(request_id, {}).duplicate(true)


func _is_child_safe_text_block(text_block: Dictionary) -> bool:
	for value in text_block.values():
		if not _is_child_safe_line(str(value)):
			return false
	return true


func _is_child_safe_line(line: String) -> bool:
	var lower_line := line.to_lower()
	for pressure_word in PRESSURE_WORDS:
		if lower_line.contains(str(pressure_word)):
			return false
	return true


func _is_same_day_greeting_repeat(result: Dictionary) -> bool:
	if not bool(result.get("first_today", true)):
		return true
	var status := str(result.get("status", ""))
	return ["already_greeted", "repeat_today", "seen_today"].has(status)


func _is_same_day_resource_repeat(result: Dictionary) -> bool:
	if bool(result.get("already_collected", false)):
		return true
	if not bool(result.get("ok", true)):
		return true
	var status := str(result.get("status", ""))
	return ["collected_today", "depleted_today", "seen_today"].has(status)


func _finish() -> void:
	if failures.is_empty():
		print("V02.1 DAILY TOWN CONTRACT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
