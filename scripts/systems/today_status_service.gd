extends RefCounted
class_name TodayStatusService

const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")

const TODAY_STATUS_PATH := "res://data/life/today_status.json"
const WEATHER_EVENTS_PATH := "res://data/life/weather_events.json"

var local_day_service
var status_path: String = TODAY_STATUS_PATH
var weather_events_path: String = WEATHER_EVENTS_PATH
var statuses: Array = []
var statuses_by_day_key: Dictionary = {}
var weather_events: Array = []
var weather_events_by_id: Dictionary = {}
var load_errors: Array[String] = []


func _init(day_service = null, path: String = TODAY_STATUS_PATH, events_path: String = WEATHER_EVENTS_PATH) -> void:
	local_day_service = day_service if day_service != null else LocalDayServiceScript.new()
	status_path = path
	weather_events_path = events_path
	load_errors.clear()
	_load_weather_events()
	_load_statuses()


func is_loaded() -> bool:
	return load_errors.is_empty()


func get_today_status() -> Dictionary:
	var day_key: String = local_day_service.get_day_key()
	if statuses.is_empty():
		return {
			"ok": false,
			"day_key": day_key,
			"hud_text": "今天适合慢慢散步。",
			"weather": "晴天",
			"event": "小镇日常",
			"sunny_hint": "Sunny 想玩",
		}
	var status: Dictionary = _status_for_day_key(day_key)
	var result := status.duplicate(true)
	var weather_event: Dictionary = get_weather_event(str(result.get("weather_event_id", "")))
	result["ok"] = true
	result["day_key"] = day_key
	if not weather_event.is_empty():
		result["weather_event"] = weather_event
		result["today_status_text"] = str(weather_event.get("today_status_text", ""))
	result["hud_text"] = "%s / %s / %s" % [
		str(result.get("today_status_text", result.get("weather", "晴天"))),
		str(result.get("event", "小镇日常")),
		str(result.get("sunny_hint", "Sunny 想玩")),
	]
	return result


func get_weather_event(event_id: String) -> Dictionary:
	if event_id.is_empty():
		return {}
	return weather_events_by_id.get(event_id, {}).duplicate(true)


func get_all_weather_events() -> Array:
	return weather_events.duplicate(true)


func get_all_statuses() -> Array:
	return statuses.duplicate(true)


func _status_for_day_key(day_key: String) -> Dictionary:
	if statuses_by_day_key.has(day_key):
		return statuses_by_day_key.get(day_key, {}).duplicate(true)
	if day_key.begins_with("local_day_"):
		var suffix := day_key.trim_prefix("local_day_")
		if suffix.is_valid_int() and statuses.size() > 0:
			var index: int = max(0, int(suffix) - 1) % statuses.size()
			return (statuses[index] as Dictionary).duplicate(true)
	var total: int = 0
	for i in range(day_key.length()):
		total += day_key.unicode_at(i)
	var fallback_index: int = total % statuses.size()
	return (statuses[fallback_index] as Dictionary).duplicate(true)


func _load_statuses() -> void:
	statuses.clear()
	statuses_by_day_key.clear()
	var file := FileAccess.open(status_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open today status data: %s" % status_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Today status data must be a JSON object: %s" % status_path)
		return
	for status in parsed.get("statuses", []):
		if not status is Dictionary:
			load_errors.append("Today status entry must be an object")
			continue
		var status_data: Dictionary = status
		var weather_event_id := str(status_data.get("weather_event_id", ""))
		if not weather_event_id.is_empty() and not weather_events_by_id.has(weather_event_id):
			load_errors.append("Today status references unknown weather event: %s" % weather_event_id)
		statuses.append(status_data.duplicate(true))
		var day_key := str(status_data.get("day_key", ""))
		if not day_key.is_empty():
			statuses_by_day_key[day_key] = status_data.duplicate(true)


func _load_weather_events() -> void:
	weather_events.clear()
	weather_events_by_id.clear()
	var file := FileAccess.open(weather_events_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open weather event data: %s" % weather_events_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Weather event data must be a JSON object: %s" % weather_events_path)
		return
	for event in parsed.get("events", []):
		if not event is Dictionary:
			load_errors.append("Weather event entry must be an object")
			continue
		var event_data: Dictionary = event
		var event_id := str(event_data.get("event_id", ""))
		if event_id.is_empty():
			load_errors.append("Weather event missing event_id")
			continue
		weather_events.append(event_data.duplicate(true))
		weather_events_by_id[event_id] = event_data.duplicate(true)
