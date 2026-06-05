extends RefCounted
class_name DailyGreetingService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")

const GREETINGS_PATH := "res://data/life/daily_greetings.json"

var save_service
var local_day_service
var today_status_service
var greeting_path: String = GREETINGS_PATH
var greetings_by_npc: Dictionary = {}
var load_errors: Array[String] = []


func _init(service = null, day_service = null, path: String = GREETINGS_PATH, status_service = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	local_day_service = day_service if day_service != null else LocalDayServiceScript.new()
	today_status_service = status_service if status_service != null else TodayStatusServiceScript.new(local_day_service)
	greeting_path = path
	_load_greetings()


func is_loaded() -> bool:
	return load_errors.is_empty()


func get_greeting(npc_id: String) -> Dictionary:
	if not greetings_by_npc.has(npc_id):
		return {"ok": false, "reason": "unknown_npc", "npc_id": npc_id}
	var greeting: Dictionary = greetings_by_npc[npc_id]
	var result := greeting.duplicate(true)
	result["ok"] = true
	return result


func has_greeted_today(npc_id: String) -> bool:
	var day_state: Dictionary = _get_day_state(local_day_service.get_day_key())
	return bool(day_state.get(npc_id, {}).get("greeted", false))


func interact_for_npc(npc_id: String, allow_repeat: bool = true) -> Dictionary:
	var greeting: Dictionary = get_greeting(npc_id)
	if not greeting.get("ok", false):
		return {"handled": false, "ok": false, "reason": "no_daily_greeting", "npc_id": npc_id}

	var day_key: String = local_day_service.get_day_key()
	var day_state: Dictionary = _get_day_state(day_key)
	var npc_state: Dictionary = day_state.get(npc_id, {})
	var first_today := not bool(npc_state.get("greeted", false))
	if not first_today and not allow_repeat:
		return {"handled": false, "ok": false, "reason": "already_greeted", "npc_id": npc_id, "day_key": day_key}

	var weather_status: Dictionary = today_status_service.get_today_status() if today_status_service != null else {}
	var weather_event_id := str(weather_status.get("weather_event_id", ""))
	var weather_event: Dictionary = weather_status.get("weather_event", {})
	var variant: Dictionary = _weather_variant_for_greeting(greeting, weather_event_id)
	var text_key: String = "first_text" if first_today else "repeat_text"
	var text_source: Dictionary = variant if not variant.is_empty() else greeting
	var text: String = str(text_source.get(text_key, greeting.get(text_key, greeting.get("first_text", ""))))
	var variant_id := str(variant.get("variant_id", ""))
	npc_state["greeted"] = true
	npc_state["day_key"] = day_key
	npc_state["first_text_seen"] = bool(npc_state.get("first_text_seen", false)) or first_today
	npc_state["repeat_count"] = int(npc_state.get("repeat_count", 0)) + (0 if first_today else 1)
	npc_state["last_text"] = text
	npc_state["weather_event_id"] = weather_event_id
	npc_state["greeting_variant_id"] = variant_id
	day_state[npc_id] = npc_state.duplicate(true)
	_save_day_state(day_key, day_state)
	_update_relationship(npc_id, text, day_key, first_today)
	return {
		"handled": true,
		"ok": true,
		"npc_id": npc_id,
		"day_key": day_key,
		"first_today": first_today,
		"text": text,
		"weather_event_id": weather_event_id,
		"weather_tag": str(weather_event.get("weather_tag", "")),
		"greeting_variant_id": variant_id,
		"state": npc_state.duplicate(true),
	}


func _weather_variant_for_greeting(greeting: Dictionary, weather_event_id: String) -> Dictionary:
	if weather_event_id.is_empty():
		return {}
	var variants: Dictionary = greeting.get("weather_variants", {})
	var variant: Variant = variants.get(weather_event_id, {})
	return variant.duplicate(true) if variant is Dictionary else {}


func _update_relationship(npc_id: String, text: String, day_key: String, first_today: bool) -> void:
	var learning_record: Dictionary = save_service.load_learning_record()
	var relationships: Dictionary = learning_record.get("npc_relationships", {})
	var state: Dictionary = relationships.get(npc_id, {})
	state["relationship"] = state.get("relationship", "neighbor")
	state["greeting_count"] = int(state.get("greeting_count", 0)) + 1
	if first_today:
		state["daily_greeting_count"] = int(state.get("daily_greeting_count", 0)) + 1
	state["last_daily_greeting_day"] = day_key
	state["last_line"] = text
	relationships[npc_id] = state
	learning_record["npc_relationships"] = relationships
	save_service.save_learning_record(learning_record)


func _get_day_state(day_key: String) -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var all_greetings: Dictionary = game_state.get("daily_greetings", {})
	return all_greetings.get(day_key, {}).duplicate(true)


func _save_day_state(day_key: String, day_state: Dictionary) -> bool:
	var game_state: Dictionary = save_service.load_game_state()
	var all_greetings: Dictionary = game_state.get("daily_greetings", {})
	all_greetings[day_key] = day_state.duplicate(true)
	game_state["daily_greetings"] = all_greetings
	return save_service.save_game_state(game_state)


func _load_greetings() -> void:
	load_errors.clear()
	greetings_by_npc.clear()
	var file := FileAccess.open(greeting_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open daily greeting data: %s" % greeting_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Daily greeting data must be a JSON object: %s" % greeting_path)
		return
	for greeting in parsed.get("greetings", []):
		if not greeting is Dictionary:
			load_errors.append("Daily greeting entry must be an object")
			continue
		var npc_id := str(greeting.get("npc_id", ""))
		if npc_id.is_empty():
			load_errors.append("Daily greeting entry missing npc_id")
			continue
		if str(greeting.get("first_text", "")).is_empty():
			load_errors.append("Daily greeting missing first_text: %s" % npc_id)
		if str(greeting.get("repeat_text", "")).is_empty():
			load_errors.append("Daily greeting missing repeat_text: %s" % npc_id)
		greetings_by_npc[npc_id] = greeting.duplicate(true)
