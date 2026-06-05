extends RefCounted
class_name ResourceRefreshService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")

const RESOURCE_POINTS_PATH := "res://data/life/resource_points.json"

var save_service
var inventory_service
var local_day_service
var today_status_service
var resource_path: String = RESOURCE_POINTS_PATH
var points_by_id: Dictionary = {}
var load_errors: Array[String] = []


func _init(service = null, inventory = null, day_service = null, path: String = RESOURCE_POINTS_PATH, status_service = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	inventory_service = inventory if inventory != null else InventoryServiceScript.new(save_service)
	local_day_service = day_service if day_service != null else LocalDayServiceScript.new()
	today_status_service = status_service if status_service != null else TodayStatusServiceScript.new(local_day_service)
	resource_path = path
	_load_points()


func is_loaded() -> bool:
	return load_errors.is_empty()


func get_point(point_id: String) -> Dictionary:
	if not points_by_id.has(point_id):
		return {"ok": false, "reason": "unknown_resource_point", "point_id": point_id}
	var point: Dictionary = points_by_id[point_id]
	var result := point.duplicate(true)
	result["ok"] = true
	result["available_today"] = not is_collected_today(point_id)
	_apply_weather_hint(result)
	return result


func is_collected_today(point_id: String) -> bool:
	var day_key: String = local_day_service.get_day_key()
	var day_state: Dictionary = _get_day_state(day_key)
	return bool(day_state.get(point_id, {}).get("collected", false))


func get_available_points() -> Array:
	var available: Array = []
	for point_id in points_by_id.keys():
		if not is_collected_today(str(point_id)):
			available.append(get_point(str(point_id)))
	return available


func get_nearest_resource(cell: Vector2i, radius: int) -> Dictionary:
	var nearest: Dictionary = {}
	var best_distance := radius + 1
	for point in get_available_points():
		var point_cell := _dict_to_cell(point.get("cell", {}))
		var distance: int = abs(point_cell.x - cell.x) + abs(point_cell.y - cell.y)
		if distance <= radius and distance < best_distance:
			nearest = point
			best_distance = distance
	return nearest


func collect_nearest(cell: Vector2i, radius: int) -> Dictionary:
	var point: Dictionary = get_nearest_resource(cell, radius)
	if point.is_empty():
		return {"ok": false, "reason": "no_resource_nearby", "day_key": local_day_service.get_day_key()}
	return collect_resource(str(point.get("point_id", "")))


func collect_resource(point_id: String) -> Dictionary:
	var point: Dictionary = get_point(point_id)
	if not point.get("ok", false):
		return point
	var day_key: String = local_day_service.get_day_key()
	if is_collected_today(point_id):
		return {
			"ok": false,
			"reason": "already_collected_today",
			"point_id": point_id,
			"day_key": day_key,
			"text": str(point.get("collected_text", "这里今天已经整理好啦。")),
		}

	var item_id: String = str(point.get("item_id", ""))
	var quantity: int = int(point.get("quantity", 1))
	var collected: Dictionary = inventory_service.collect_item(item_id, quantity)
	if not collected.get("ok", false):
		return collected
	var day_state: Dictionary = _get_day_state(day_key)
	day_state[point_id] = {
		"collected": true,
		"item_id": item_id,
		"quantity": quantity,
		"day_key": day_key,
	}
	_save_day_state(day_key, day_state)
	return {
		"ok": true,
		"point_id": point_id,
		"item_id": item_id,
		"quantity": quantity,
		"day_key": day_key,
		"display_name": point.get("display_name", item_id),
		"text": str(point.get("collect_text", "收进背包啦。")),
		"weather_event_id": str(point.get("weather_event_id", "")),
		"weather_hint": str(point.get("weather_hint", "")),
		"inventory": collected.get("inventory", {}).duplicate(true),
	}


func _apply_weather_hint(point: Dictionary) -> void:
	var status: Dictionary = today_status_service.get_today_status() if today_status_service != null else {}
	var weather_event_id := str(status.get("weather_event_id", ""))
	point["weather_event_id"] = weather_event_id
	var hints: Dictionary = point.get("weather_hints", {})
	var hint := str(hints.get(weather_event_id, ""))
	if not hint.is_empty():
		point["weather_hint"] = hint


func _get_day_state(day_key: String) -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var all_points: Dictionary = game_state.get("resource_points", {})
	return all_points.get(day_key, {}).duplicate(true)


func _save_day_state(day_key: String, day_state: Dictionary) -> bool:
	var game_state: Dictionary = save_service.load_game_state()
	var all_points: Dictionary = game_state.get("resource_points", {})
	all_points[day_key] = day_state.duplicate(true)
	game_state["resource_points"] = all_points
	return save_service.save_game_state(game_state)


func _dict_to_cell(value: Variant) -> Vector2i:
	if value is Vector2i:
		return value
	if value is Dictionary:
		var dict: Dictionary = value
		return Vector2i(int(dict.get("x", 0)), int(dict.get("y", 0)))
	return Vector2i.ZERO


func _load_points() -> void:
	load_errors.clear()
	points_by_id.clear()
	var file := FileAccess.open(resource_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open resource point data: %s" % resource_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Resource point data must be a JSON object: %s" % resource_path)
		return
	for point in parsed.get("resource_points", []):
		if not point is Dictionary:
			load_errors.append("Resource point entry must be an object")
			continue
		var point_id := str(point.get("point_id", ""))
		if point_id.is_empty():
			load_errors.append("Resource point entry missing point_id")
			continue
		if points_by_id.has(point_id):
			load_errors.append("Duplicate resource point id: %s" % point_id)
		if str(point.get("item_id", "")).is_empty():
			load_errors.append("Resource point missing item_id: %s" % point_id)
		if not point.get("cell") is Dictionary:
			load_errors.append("Resource point missing cell: %s" % point_id)
		points_by_id[point_id] = point.duplicate(true)
