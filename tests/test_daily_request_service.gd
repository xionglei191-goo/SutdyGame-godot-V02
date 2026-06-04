extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_daily_request_service.json")
	_expect(save_service.clear_for_test(), "daily request save should clear")
	_expect(save_service.reset_for_test(), "daily request save should reset")

	var inventory = InventoryServiceScript.new(save_service)
	var daily = DailyRequestServiceScript.new(save_service, inventory)
	_expect(daily.is_loaded(), "DailyRequestService should load request data: %s" % [daily.load_errors])

	var request: Dictionary = daily.get_request("daily_mina_branch_001")
	_expect(request.get("ok", false), "Mina branch request should load")
	_expect(request.get("memory_story", {}).get("core_anchor_id", "") == "anchor_b_bear", "request should bind to Bear memory anchor")

	var start: Dictionary = daily.interact_for_npc("mina")
	_expect(start.get("ok", false), "Mina request should start on first interaction")
	_expect(start.get("request_status", "") == "active", "started request should be active")
	_expect(str(start.get("text", "")).contains("Branch"), "start text should mention Branch")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 0, "starting request should not award coins")

	var waiting: Dictionary = daily.interact_for_npc("mina")
	_expect(waiting.get("ok", false), "Mina request should stay gentle without the item")
	_expect(waiting.get("request_status", "") == "active", "missing branch should keep request active")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("branch", 0)) == 0, "missing branch flow should not change inventory")

	_expect(inventory.collect_item("branch", 1).get("ok", false), "branch should be collectable for request")
	var complete: Dictionary = daily.interact_for_npc("mina")
	_expect(complete.get("ok", false), "Mina request should complete with branch")
	_expect(complete.get("request_status", "") == "completed", "request should report completed")
	_expect(bool(complete.get("completed_today", false)), "request should mark completed_today")
	var game_state: Dictionary = save_service.load_game_state()
	_expect(int(game_state.get("inventory", {}).get("branch", -1)) == 0, "completion should consume one branch")
	_expect(int(game_state.get("coins", -1)) == 6, "completion should award town coins")
	_expect(bool(game_state.get("daily_requests", {}).get("daily_mina_branch_001", {}).get("completed_today", false)), "completion state should persist")
	var relationship: Dictionary = save_service.load_learning_record().get("npc_relationships", {}).get("mina", {})
	_expect(int(relationship.get("favor", 0)) == 1, "completion should add Mina favor")
	_expect(int(relationship.get("daily_request_count", 0)) == 1, "completion should count Mina daily request")

	var repeat: Dictionary = daily.interact_for_npc("mina")
	_expect(repeat.get("ok", false), "repeat completed interaction should stay gentle")
	_expect(repeat.get("request_status", "") == "completed", "repeat should still report completed")
	_expect(str(repeat.get("text", "")).contains("already"), "repeat text should avoid another reward")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 6, "repeat should not award more coins")

	var reloaded = DailyRequestServiceScript.new(save_service, InventoryServiceScript.new(save_service))
	var reloaded_repeat: Dictionary = reloaded.interact_for_npc("mina")
	_expect(reloaded_repeat.get("request_status", "") == "completed", "reloaded service should keep completed state")

	_expect(save_service.clear_for_test(), "daily request save should clean up")
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("DAILY REQUEST SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
