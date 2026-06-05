extends RefCounted
class_name SchoolDayStateService

const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")

const SCHOOL_DAY_STATES_PATH := "res://data/life/school_day_states.json"

var local_day_service
var states_path: String = SCHOOL_DAY_STATES_PATH
var states: Array = []
var states_by_day_key: Dictionary = {}
var load_errors: Array[String] = []


func _init(day_service = null, path: String = SCHOOL_DAY_STATES_PATH) -> void:
	local_day_service = day_service if day_service != null else LocalDayServiceScript.new()
	states_path = path
	_load_states()


func is_loaded() -> bool:
	return load_errors.is_empty()


func get_today_school_state() -> Dictionary:
	var day_key: String = local_day_service.get_day_key()
	var state: Dictionary = _state_for_day_key(day_key)
	if state.is_empty():
		return {"ok": false, "day_key": day_key, "reason": "missing_school_day_state"}
	var result := state.duplicate(true)
	result["ok"] = true
	result["day_key"] = day_key
	return result


func get_entry(stage: String) -> Dictionary:
	var state: Dictionary = get_today_school_state()
	if not state.get("ok", false):
		return {}
	var entries: Dictionary = state.get("entries", {})
	if not entries.has(stage):
		return {}
	var entry: Dictionary = entries.get(stage, {})
	var result := entry.duplicate(true)
	result["day_key"] = str(state.get("day_key", ""))
	result["theme"] = str(state.get("theme", ""))
	return result


func get_all_states() -> Array:
	return states.duplicate(true)


func _state_for_day_key(day_key: String) -> Dictionary:
	if states_by_day_key.has(day_key):
		return states_by_day_key.get(day_key, {}).duplicate(true)
	if day_key.begins_with("local_day_") and not states.is_empty():
		var suffix := day_key.trim_prefix("local_day_")
		if suffix.is_valid_int():
			var index: int = max(0, int(suffix) - 1) % states.size()
			return (states[index] as Dictionary).duplicate(true)
	return {}


func _load_states() -> void:
	states.clear()
	states_by_day_key.clear()
	load_errors.clear()
	var file := FileAccess.open(states_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open school day state data: %s" % states_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("School day state data must be a JSON object: %s" % states_path)
		return
	for state_value in parsed.get("states", []):
		if not state_value is Dictionary:
			load_errors.append("School day state entry must be object")
			continue
		var state: Dictionary = state_value
		var day_key := str(state.get("day_key", ""))
		if day_key.is_empty():
			load_errors.append("School day state missing day_key")
			continue
		states.append(state.duplicate(true))
		states_by_day_key[day_key] = state.duplicate(true)
