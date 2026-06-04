extends RefCounted
class_name HomeDecorationService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")

const FEEDBACK_PATH := "res://data/life/sunny_home_feedback.json"
const HOME_GRID_SIZE := Vector2i(6, 5)

var save_service
var inventory_service
var feedback_path: String = FEEDBACK_PATH
var feedback_data: Dictionary = {}
var load_errors: Array[String] = []


func _init(service = null, inventory = null, path: String = FEEDBACK_PATH) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	inventory_service = inventory if inventory != null else InventoryServiceScript.new(save_service)
	feedback_path = path
	_load_feedback()


func place_furniture(item_id: String, cell: Vector2i, rotation: int = 0) -> Dictionary:
	var item: Dictionary = inventory_service.get_item(item_id)
	if not item.get("ok", false):
		return item
	if str(item.get("item_type", "")) != "furniture":
		return {"ok": false, "reason": "not_furniture", "item_id": item_id}
	var validation: Dictionary = validate_placement(item_id, cell, rotation)
	if not validation.get("ok", false):
		return validation

	var consumed: Dictionary = inventory_service.consume_item(item_id, 1)
	if not consumed.get("ok", false):
		return consumed

	var game_state: Dictionary = save_service.load_game_state()
	var home_state: Dictionary = game_state.get("home_state", {})
	var placed: Array = home_state.get("placed_furniture", [])
	var instance_id: String = "%s_%03d" % [item_id, placed.size() + 1]
	var footprint: Vector2i = _rotated_size(_item_size(item), rotation)
	var record: Dictionary = {
		"instance_id": instance_id,
		"item_id": item_id,
		"cell": {"x": cell.x, "y": cell.y},
		"rotation": _normalize_rotation(rotation),
		"size": {"w": footprint.x, "h": footprint.y},
		"display_name": item.get("display_name", item_id),
		"localized_display_name": item.get("localized_display_name", item.get("display_name", item_id)),
		"category": item.get("category", item.get("furniture_category", "decor")),
		"pet_tags": item.get("pet_tags", item.get("tags", [])).duplicate(true),
		"memory_story": item.get("memory_story", {}).duplicate(true),
	}
	placed.append(record)
	home_state["placed_furniture"] = placed
	game_state["home_state"] = home_state
	var saved: bool = save_service.save_game_state(game_state)
	return {"ok": saved, "furniture": record.duplicate(true), "home_state": home_state.duplicate(true)}


func rotate_furniture(instance_id: String) -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var home_state: Dictionary = game_state.get("home_state", {})
	var placed: Array = home_state.get("placed_furniture", [])
	for index in range(placed.size()):
		var record: Dictionary = placed[index]
		if str(record.get("instance_id", "")) != instance_id:
			continue
		var item_id := str(record.get("item_id", ""))
		var next_rotation := (_normalize_rotation(int(record.get("rotation", 0))) + 90) % 360
		var cell := _dict_to_cell(record.get("cell", {}))
		var validation: Dictionary = validate_placement(item_id, cell, next_rotation, instance_id)
		if not validation.get("ok", false):
			return validation
		var footprint: Vector2i = validation.get("size", Vector2i.ONE)
		record["rotation"] = next_rotation
		record["size"] = {"w": footprint.x, "h": footprint.y}
		placed[index] = record
		home_state["placed_furniture"] = placed
		game_state["home_state"] = home_state
		var saved: bool = save_service.save_game_state(game_state)
		return {"ok": saved, "furniture": record.duplicate(true), "home_state": home_state.duplicate(true)}
	return {"ok": false, "reason": "unknown_furniture", "instance_id": instance_id}


func move_furniture(instance_id: String, cell: Vector2i) -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var home_state: Dictionary = game_state.get("home_state", {})
	var placed: Array = home_state.get("placed_furniture", [])
	for index in range(placed.size()):
		var record: Dictionary = placed[index]
		if str(record.get("instance_id", "")) != instance_id:
			continue
		var item_id := str(record.get("item_id", ""))
		var rotation := int(record.get("rotation", 0))
		var validation: Dictionary = validate_placement(item_id, cell, rotation, instance_id)
		if not validation.get("ok", false):
			return validation
		record["cell"] = {"x": cell.x, "y": cell.y}
		placed[index] = record
		home_state["placed_furniture"] = placed
		game_state["home_state"] = home_state
		var saved: bool = save_service.save_game_state(game_state)
		return {"ok": saved, "furniture": record.duplicate(true), "home_state": home_state.duplicate(true)}
	return {"ok": false, "reason": "unknown_furniture", "instance_id": instance_id}


func pickup_furniture(instance_id: String) -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var home_state: Dictionary = game_state.get("home_state", {})
	var placed: Array = home_state.get("placed_furniture", [])
	for index in range(placed.size()):
		var record: Dictionary = placed[index]
		if str(record.get("instance_id", "")) != instance_id:
			continue
		placed.remove_at(index)
		home_state["placed_furniture"] = placed
		game_state["home_state"] = home_state
		save_service.save_game_state(game_state)
		var collected: Dictionary = inventory_service.collect_item(str(record.get("item_id", "")), 1)
		return {
			"ok": collected.get("ok", false),
			"furniture": record.duplicate(true),
			"home_state": get_home_state(),
			"inventory": collected.get("inventory", {}).duplicate(true),
		}
	return {"ok": false, "reason": "unknown_furniture", "instance_id": instance_id}


func validate_placement(item_id: String, cell: Vector2i, rotation: int = 0, ignore_instance_id: String = "") -> Dictionary:
	var item: Dictionary = inventory_service.get_item(item_id)
	if not item.get("ok", false):
		return item
	var size: Vector2i = _rotated_size(_item_size(item), rotation)
	if cell.x < 0 or cell.y < 0 or cell.x + size.x > HOME_GRID_SIZE.x or cell.y + size.y > HOME_GRID_SIZE.y:
		return {
			"ok": false,
			"reason": "invalid_cell",
			"item_id": item_id,
			"cell": {"x": cell.x, "y": cell.y},
			"size": size,
			"feedback": "这里放不下，换个更宽的小格子吧。",
		}
	for record in get_home_state().get("placed_furniture", []):
		if not record is Dictionary:
			continue
		var furniture: Dictionary = record
		if not ignore_instance_id.is_empty() and str(furniture.get("instance_id", "")) == ignore_instance_id:
			continue
		if _rects_overlap(cell, size, _dict_to_cell(furniture.get("cell", {})), _record_size(furniture)):
			return {
				"ok": false,
				"reason": "occupied",
				"item_id": item_id,
				"cell": {"x": cell.x, "y": cell.y},
				"size": size,
				"feedback": "这里已经有家具啦，挪一挪再试试。",
			}
	return {"ok": true, "item_id": item_id, "cell": {"x": cell.x, "y": cell.y}, "size": size, "rotation": _normalize_rotation(rotation)}


func get_sunny_feedback() -> Dictionary:
	var home_state: Dictionary = get_home_state()
	var placed: Array = home_state.get("placed_furniture", [])
	var item_ids: Array[String] = []
	var pet_tags: Array[String] = []
	for record in placed:
		if not record is Dictionary:
			continue
		var furniture: Dictionary = record
		item_ids.append(str(furniture.get("item_id", "")))
		for tag in furniture.get("pet_tags", []):
			pet_tags.append(str(tag))
	var feedback_key := "default"
	if item_ids.has("sunny_bed"):
		feedback_key = "bed"
	elif item_ids.has("pet_bowl"):
		feedback_key = "pet_bowl"
	elif placed.size() >= 3:
		feedback_key = "cozy_room"
	var lines: Dictionary = feedback_data.get("feedback", {})
	var text := _feedback_text(lines.get(feedback_key, lines.get("default", "Sunny 在小屋里慢慢摇尾巴。")))
	return {
		"ok": true,
		"npc_id": "pet_buddy",
		"pet_id": "sunny_dog",
		"feedback_key": feedback_key,
		"text": text,
		"item_ids": item_ids,
		"pet_tags": pet_tags,
	}


func get_home_state() -> Dictionary:
	return save_service.load_game_state().get("home_state", {"placed_furniture": []}).duplicate(true)


func _item_size(item: Dictionary) -> Vector2i:
	var size: Dictionary = item.get("home_size", {"w": 1, "h": 1})
	return Vector2i(max(1, int(size.get("w", 1))), max(1, int(size.get("h", 1))))


func _record_size(record: Dictionary) -> Vector2i:
	if record.get("size") is Dictionary:
		var size: Dictionary = record.get("size", {})
		return Vector2i(max(1, int(size.get("w", 1))), max(1, int(size.get("h", 1))))
	return _rotated_size(_item_size(inventory_service.get_item(str(record.get("item_id", "")))), int(record.get("rotation", 0)))


func _rotated_size(size: Vector2i, rotation: int) -> Vector2i:
	var normalized := _normalize_rotation(rotation)
	if normalized == 90 or normalized == 270:
		return Vector2i(size.y, size.x)
	return size


func _normalize_rotation(rotation: int) -> int:
	var normalized := rotation % 360
	if normalized < 0:
		normalized += 360
	return int(floor(normalized / 90.0)) * 90


func _dict_to_cell(value: Variant) -> Vector2i:
	if value is Vector2i:
		return value
	if value is Dictionary:
		var cell: Dictionary = value
		return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))
	return Vector2i.ZERO


func _rects_overlap(a_cell: Vector2i, a_size: Vector2i, b_cell: Vector2i, b_size: Vector2i) -> bool:
	return a_cell.x < b_cell.x + b_size.x and a_cell.x + a_size.x > b_cell.x and a_cell.y < b_cell.y + b_size.y and a_cell.y + a_size.y > b_cell.y


func _feedback_text(entry: Variant) -> String:
	if entry is String:
		return entry
	if entry is Dictionary:
		var feedback_entry: Dictionary = entry
		var lines: Array = feedback_entry.get("lines", [])
		if not lines.is_empty():
			return str(lines[0])
	return "Sunny 在小屋里慢慢摇尾巴。"


func _load_feedback() -> void:
	load_errors.clear()
	feedback_data.clear()
	var file := FileAccess.open(feedback_path, FileAccess.READ)
	if file == null:
		feedback_data = {"feedback": {"default": "Sunny 在小屋里慢慢摇尾巴。"}}
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Sunny home feedback must be a JSON object: %s" % feedback_path)
		feedback_data = {"feedback": {"default": "Sunny 在小屋里慢慢摇尾巴。"}}
		return
	feedback_data = parsed
