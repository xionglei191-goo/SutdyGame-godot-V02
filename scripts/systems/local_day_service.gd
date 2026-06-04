extends RefCounted
class_name LocalDayService

var override_day_key := ""


func _init(day_key_override: String = "") -> void:
	override_day_key = day_key_override


func get_day_key() -> String:
	if not override_day_key.is_empty():
		return override_day_key
	return today_key()


func set_day_key_for_test(day_key: String) -> void:
	override_day_key = day_key


static func today_key() -> String:
	var now: Dictionary = Time.get_datetime_dict_from_system()
	return "%04d-%02d-%02d" % [int(now.get("year", 0)), int(now.get("month", 1)), int(now.get("day", 1))]
