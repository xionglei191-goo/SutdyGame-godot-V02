extends RefCounted
class_name TodayStatusService

const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")

const TODAY_STATUS_PATH := "res://data/life/today_status.json"

var local_day_service
var status_path: String = TODAY_STATUS_PATH
var statuses: Array = []
var load_errors: Array[String] = []


func _init(day_service = null, path: String = TODAY_STATUS_PATH) -> void:
	local_day_service = day_service if day_service != null else LocalDayServiceScript.new()
	status_path = path
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
	var index: int = _day_index(day_key) % statuses.size()
	var status: Dictionary = statuses[index]
	var result := status.duplicate(true)
	result["ok"] = true
	result["day_key"] = day_key
	result["hud_text"] = "%s / %s / %s" % [
		str(result.get("weather", "晴天")),
		str(result.get("event", "小镇日常")),
		str(result.get("sunny_hint", "Sunny 想玩")),
	]
	return result


func _day_index(day_key: String) -> int:
	var total: int = 0
	for i in range(day_key.length()):
		total += day_key.unicode_at(i)
	return total


func _load_statuses() -> void:
	load_errors.clear()
	statuses.clear()
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
		statuses.append(status.duplicate(true))
