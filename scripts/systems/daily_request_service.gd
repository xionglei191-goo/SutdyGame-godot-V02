extends RefCounted
class_name DailyRequestService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")

const REQUESTS_PATH := "res://data/life/daily_requests.json"

var save_service
var inventory_service
var local_day_service
var request_path: String = REQUESTS_PATH
var requests_by_id: Dictionary = {}
var load_errors: Array[String] = []


func _init(service = null, inventory = null, day_service = null, path: String = REQUESTS_PATH) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	inventory_service = inventory if inventory != null else InventoryServiceScript.new(save_service)
	local_day_service = day_service if day_service != null else LocalDayServiceScript.new()
	request_path = path
	_load_requests()


func is_loaded() -> bool:
	return load_errors.is_empty()


func get_request(request_id: String) -> Dictionary:
	if not requests_by_id.has(request_id):
		return {"ok": false, "reason": "unknown_request", "request_id": request_id}
	var request: Dictionary = requests_by_id[request_id]
	var result := request.duplicate(true)
	result["ok"] = true
	return result


func get_daily_state() -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var all_requests: Dictionary = game_state.get("daily_requests", {})
	return all_requests.get(local_day_service.get_day_key(), {}).duplicate(true)


func interact_for_npc(npc_id: String) -> Dictionary:
	var request: Dictionary = _find_request_for_npc(npc_id)
	if request.is_empty():
		return {"handled": false, "ok": false, "reason": "no_daily_request", "npc_id": npc_id}

	var request_id := str(request.get("request_id", ""))
	var state: Dictionary = _get_request_state(request_id)
	if bool(state.get("completed_today", false)):
		return _format_result(request, state, "already_completed", true, true)
	if str(state.get("status", "")) == "active":
		if _has_required_items(request):
			return _complete_request(request, state)
		return _format_result(request, state, "active", true, false)
	return _start_request(request)


func _start_request(request: Dictionary) -> Dictionary:
	var request_id := str(request.get("request_id", ""))
	var state: Dictionary = {
		"status": "active",
		"npc_id": request.get("npc_id", ""),
		"day_key": local_day_service.get_day_key(),
		"started": true,
		"completed_today": false,
		"completed_count": 0,
	}
	_save_request_state(request_id, state)
	return _format_result(request, state, "start", true, false)


func _complete_request(request: Dictionary, state: Dictionary) -> Dictionary:
	for requirement in request.get("required_items", []):
		var required: Dictionary = requirement
		var consume_result: Dictionary = inventory_service.consume_item(
			str(required.get("item_id", "")),
			int(required.get("quantity", 1))
		)
		if not consume_result.get("ok", false):
			return _format_result(request, state, "active", true, false)

	var rewards: Dictionary = request.get("rewards", {})
	var game_state: Dictionary = save_service.load_game_state()
	game_state["coins"] = int(game_state.get("coins", 0)) + int(rewards.get("coins", 0))
	save_service.save_game_state(game_state)
	for reward_item in rewards.get("items", []):
		if reward_item is Dictionary:
			var item_reward: Dictionary = reward_item
			inventory_service.collect_item(str(item_reward.get("item_id", "")), int(item_reward.get("quantity", 1)))
	game_state = save_service.load_game_state()
	var all_requests: Dictionary = game_state.get("daily_requests", {})
	var day_key := str(state.get("day_key", local_day_service.get_day_key()))
	var daily_requests: Dictionary = all_requests.get(day_key, {})
	state["status"] = "completed"
	state["completed_today"] = true
	state["completed_count"] = int(state.get("completed_count", 0)) + 1
	state["rewarded_coins"] = int(rewards.get("coins", 0))
	daily_requests[str(request.get("request_id", ""))] = state.duplicate(true)
	all_requests[day_key] = daily_requests
	game_state["daily_requests"] = all_requests
	save_service.save_game_state(game_state)
	_update_relationship(str(request.get("npc_id", "")), str(request.get("request_id", "")), int(rewards.get("relationship", 0)))
	return _format_result(request, state, "complete", true, true)


func _update_relationship(npc_id: String, request_id: String, favor: int) -> void:
	var learning_record: Dictionary = save_service.load_learning_record()
	var relationships: Dictionary = learning_record.get("npc_relationships", {})
	var state: Dictionary = relationships.get(npc_id, {})
	state["relationship"] = "neighbor"
	state["favor"] = int(state.get("favor", 0)) + favor
	state["daily_request_count"] = int(state.get("daily_request_count", 0)) + 1
	state["last_daily_request_id"] = request_id
	relationships[npc_id] = state
	learning_record["npc_relationships"] = relationships
	save_service.save_learning_record(learning_record)


func _format_result(request: Dictionary, state: Dictionary, text_key: String, ok: bool, completed: bool) -> Dictionary:
	var text: Dictionary = request.get("text", {})
	var status := "completed" if completed else str(state.get("status", "active"))
	return {
		"handled": true,
		"ok": ok,
		"request_id": request.get("request_id", ""),
		"npc_id": request.get("npc_id", ""),
		"day_key": str(state.get("day_key", local_day_service.get_day_key())),
		"request_status": status,
		"completed_today": completed,
		"required_items": request.get("required_items", []).duplicate(true),
		"rewards": request.get("rewards", {}).duplicate(true),
		"text": str(text.get(text_key, text.get("progress", ""))),
		"state": state.duplicate(true),
	}


func _has_required_items(request: Dictionary) -> bool:
	var inventory: Dictionary = inventory_service.get_inventory()
	for requirement in request.get("required_items", []):
		var required: Dictionary = requirement
		if int(inventory.get(str(required.get("item_id", "")), 0)) < int(required.get("quantity", 1)):
			return false
	return true


func _get_request_state(request_id: String) -> Dictionary:
	return get_daily_state().get(request_id, {}).duplicate(true)


func _save_request_state(request_id: String, state: Dictionary) -> bool:
	var game_state: Dictionary = save_service.load_game_state()
	var all_requests: Dictionary = game_state.get("daily_requests", {})
	var day_key := str(state.get("day_key", local_day_service.get_day_key()))
	var daily_requests: Dictionary = all_requests.get(day_key, {})
	daily_requests[request_id] = state.duplicate(true)
	all_requests[day_key] = daily_requests
	game_state["daily_requests"] = all_requests
	return save_service.save_game_state(game_state)


func _find_request_for_npc(npc_id: String) -> Dictionary:
	for request in requests_by_id.values():
		if str(request.get("npc_id", "")) == npc_id:
			return request.duplicate(true)
	return {}


func _load_requests() -> void:
	load_errors.clear()
	requests_by_id.clear()
	var file := FileAccess.open(request_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open daily request data: %s" % request_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Daily request data must be a JSON object: %s" % request_path)
		return
	for request in parsed.get("requests", []):
		if not request is Dictionary:
			load_errors.append("Daily request entry must be an object")
			continue
		var request_id := str(request.get("request_id", ""))
		if request_id.is_empty():
			load_errors.append("Daily request entry missing request_id")
			continue
		if str(request.get("npc_id", "")).is_empty():
			load_errors.append("Daily request missing npc_id: %s" % request_id)
		if request.get("required_items", []).is_empty():
			load_errors.append("Daily request missing required_items: %s" % request_id)
		requests_by_id[request_id] = request.duplicate(true)
