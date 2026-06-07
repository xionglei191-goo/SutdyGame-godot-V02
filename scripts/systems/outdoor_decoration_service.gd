extends RefCounted
class_name OutdoorDecorationService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")

const OUTDOOR_GRID_SIZE := Vector2i(60, 34)
const RESOURCE_POINTS_PATH := "res://data/life/resource_points.json"
const OUTDOOR_ALLOWED_ZONES := [
	{"zone_id": "home_plaza_soft_corner", "x": 29, "y": 17, "w": 11, "h": 7},
	{"zone_id": "shop_plaza_wait_corner", "x": 40, "y": 12, "w": 5, "h": 6},
]
const BASE_NPC_CELLS := [
	{"npc_id": "mina", "cell": {"x": 38, "y": 22}},
	{"npc_id": "shopkeeper", "cell": {"x": 43, "y": 12}},
	{"npc_id": "pet_buddy", "cell": {"x": 28, "y": 20}},
	{"npc_id": "bus_helper", "cell": {"x": 36, "y": 20}},
	{"npc_id": "story_bear", "cell": {"x": 16, "y": 18}},
]

var save_service
var inventory_service
var world_map: Dictionary = {}
var resource_points: Array = []
var npc_cells: Array = []


func _init(service = null, inventory = null, map_data: Dictionary = {}, resources: Array = [], npcs: Array = []) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	inventory_service = inventory if inventory != null else InventoryServiceScript.new(save_service)
	world_map = map_data.duplicate(true) if not map_data.is_empty() else _load_world_map()
	resource_points = resources.duplicate(true) if not resources.is_empty() else _load_resource_points()
	npc_cells = npcs.duplicate(true) if not npcs.is_empty() else BASE_NPC_CELLS.duplicate(true)


func get_outdoor_state() -> Dictionary:
	return save_service.load_game_state().get("outdoor_state", {"placed_items": []}).duplicate(true)


func get_placed_items() -> Array:
	return get_outdoor_state().get("placed_items", []).duplicate(true)


func place_item(item_id: String, cell: Vector2i) -> Dictionary:
	var validation: Dictionary = validate_placement(item_id, cell)
	if not validation.get("ok", false):
		return validation
	var consumed: Dictionary = inventory_service.consume_item(item_id, 1)
	if not consumed.get("ok", false):
		return consumed
	var item: Dictionary = inventory_service.get_item(item_id)
	var game_state: Dictionary = save_service.load_game_state()
	var outdoor_state: Dictionary = game_state.get("outdoor_state", {"placed_items": []})
	var placed: Array = outdoor_state.get("placed_items", [])
	var record: Dictionary = {
		"instance_id": "%s_outdoor_%03d" % [item_id, placed.size() + 1],
		"item_id": item_id,
		"cell": {"x": cell.x, "y": cell.y},
		"size": {"w": validation.get("size", Vector2i.ONE).x, "h": validation.get("size", Vector2i.ONE).y},
		"display_name": item.get("display_name", item_id),
		"localized_display_name": item.get("localized_display_name", item.get("display_name", item_id)),
		"memory_story": item.get("memory_story", {}).duplicate(true),
	}
	placed.append(record)
	outdoor_state["placed_items"] = placed
	game_state["outdoor_state"] = outdoor_state
	var saved: bool = save_service.save_game_state(game_state)
	return {"ok": saved, "outdoor_item": record.duplicate(true), "outdoor_state": outdoor_state.duplicate(true)}


func move_item(instance_id: String, cell: Vector2i) -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var outdoor_state: Dictionary = game_state.get("outdoor_state", {"placed_items": []})
	var placed: Array = outdoor_state.get("placed_items", [])
	for index in range(placed.size()):
		var record: Dictionary = placed[index]
		if str(record.get("instance_id", "")) == instance_id:
			var validation: Dictionary = validate_cell(cell, instance_id, _record_size(record))
			if not validation.get("ok", false):
				return validation
			record["cell"] = {"x": cell.x, "y": cell.y}
			placed[index] = record
			outdoor_state["placed_items"] = placed
			game_state["outdoor_state"] = outdoor_state
			var saved: bool = save_service.save_game_state(game_state)
			return {"ok": saved, "outdoor_item": record.duplicate(true), "outdoor_state": outdoor_state.duplicate(true)}
	return {"ok": false, "reason": "unknown_outdoor_item", "instance_id": instance_id}


func pickup_item(instance_id: String) -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var outdoor_state: Dictionary = game_state.get("outdoor_state", {"placed_items": []})
	var placed: Array = outdoor_state.get("placed_items", [])
	for index in range(placed.size()):
		var record: Dictionary = placed[index]
		if str(record.get("instance_id", "")) == instance_id:
			placed.remove_at(index)
			outdoor_state["placed_items"] = placed
			game_state["outdoor_state"] = outdoor_state
			save_service.save_game_state(game_state)
			var collected: Dictionary = inventory_service.collect_item(str(record.get("item_id", "")), 1)
			return {"ok": collected.get("ok", false), "outdoor_item": record.duplicate(true), "outdoor_state": outdoor_state.duplicate(true)}
	return {"ok": false, "reason": "unknown_outdoor_item", "instance_id": instance_id}


func validate_placement(item_id: String, cell: Vector2i) -> Dictionary:
	var item: Dictionary = inventory_service.get_item(item_id)
	if not item.get("ok", false):
		return item
	if str(item.get("item_type", "")) != "furniture":
		return {"ok": false, "reason": "not_outdoor_decor", "item_id": item_id}
	var size := _item_size(item)
	var validation: Dictionary = validate_cell(cell, "", size)
	if not validation.get("ok", false):
		validation["item_id"] = item_id
		validation["size"] = size
		return validation
	validation["item_id"] = item_id
	validation["size"] = size
	return validation


func validate_cell(cell: Vector2i, ignore_instance_id: String = "", size: Vector2i = Vector2i.ONE) -> Dictionary:
	size = Vector2i(max(1, size.x), max(1, size.y))
	if cell.x < 0 or cell.y < 0 or cell.x + size.x > OUTDOOR_GRID_SIZE.x or cell.y + size.y > OUTDOOR_GRID_SIZE.y:
		return {"ok": false, "reason": "invalid_cell", "cell": {"x": cell.x, "y": cell.y}, "feedback": "这里不适合摆小物件，换个路边角落吧。"}
	if not _footprint_inside_allowed_zone(cell, size):
		return {"ok": false, "reason": "not_allowed_place", "cell": {"x": cell.x, "y": cell.y}, "size": size, "feedback": "这个角落要留给散步的小路，换到广场边的小空位吧。"}
	var protected: Dictionary = _protected_overlap(cell, size)
	if not protected.is_empty():
		return {
			"ok": false,
			"reason": "covers_core_target",
			"protected_kind": protected.get("kind", ""),
			"protected_id": protected.get("id", ""),
			"cell": {"x": cell.x, "y": cell.y},
			"size": size,
			"feedback": "这里要留给大家路过和打招呼，换个小空位吧。",
		}
	for value in get_placed_items():
		if not value is Dictionary:
			continue
		var record: Dictionary = value
		if not ignore_instance_id.is_empty() and str(record.get("instance_id", "")) == ignore_instance_id:
			continue
		if _rects_overlap(cell, size, _dict_to_cell(record.get("cell", {})), _record_size(record)):
			return {"ok": false, "reason": "occupied", "cell": {"x": cell.x, "y": cell.y}, "size": size, "feedback": "这里已经有一个小物件啦。"}
	return {"ok": true, "cell": {"x": cell.x, "y": cell.y}, "size": size}


func get_allowed_place_summary() -> Dictionary:
	return {
		"ok": true,
		"allowed_zone_count": OUTDOOR_ALLOWED_ZONES.size(),
		"protected_place_count": world_map.get("places", []).size(),
		"protected_anchor_count": world_map.get("memory_anchors", []).size(),
		"protected_interaction_count": world_map.get("interaction_cells", []).size(),
		"protected_resource_count": resource_points.size(),
		"protected_npc_count": npc_cells.size(),
	}


func _item_size(item: Dictionary) -> Vector2i:
	var size: Dictionary = item.get("outdoor_size", item.get("home_size", {"w": 1, "h": 1}))
	return Vector2i(max(1, int(size.get("w", 1))), max(1, int(size.get("h", 1))))


func _record_size(record: Dictionary) -> Vector2i:
	if record.get("size") is Dictionary:
		var size: Dictionary = record.get("size", {})
		return Vector2i(max(1, int(size.get("w", 1))), max(1, int(size.get("h", 1))))
	return Vector2i.ONE


func _footprint_inside_allowed_zone(cell: Vector2i, size: Vector2i) -> bool:
	for zone_value in OUTDOOR_ALLOWED_ZONES:
		var zone: Dictionary = zone_value
		var zone_cell := Vector2i(int(zone.get("x", 0)), int(zone.get("y", 0)))
		var zone_size := Vector2i(max(1, int(zone.get("w", 1))), max(1, int(zone.get("h", 1))))
		if cell.x >= zone_cell.x and cell.y >= zone_cell.y and cell.x + size.x <= zone_cell.x + zone_size.x and cell.y + size.y <= zone_cell.y + zone_size.y:
			return true
	return false


func _protected_overlap(cell: Vector2i, size: Vector2i) -> Dictionary:
	for anchor_value in world_map.get("memory_anchors", []):
		if anchor_value is Dictionary:
			var anchor: Dictionary = anchor_value
			if _rects_overlap(cell, size, _dict_to_cell(anchor.get("position", {})), Vector2i.ONE):
				return {"kind": "anchor", "id": str(anchor.get("anchor_id", ""))}
	for interaction_value in world_map.get("interaction_cells", []):
		if interaction_value is Dictionary:
			var interaction: Dictionary = interaction_value
			if _rects_overlap(cell, size, _dict_to_cell(interaction.get("cell", {})), Vector2i.ONE):
				return {"kind": "interaction", "id": str(interaction.get("interaction_id", ""))}
	for point_value in resource_points:
		if point_value is Dictionary:
			var point: Dictionary = point_value
			if _rects_overlap(cell, size, _dict_to_cell(point.get("cell", {})), Vector2i.ONE):
				return {"kind": "resource", "id": str(point.get("point_id", ""))}
	for npc_value in npc_cells:
		if npc_value is Dictionary:
			var npc: Dictionary = npc_value
			if _rects_overlap(cell, size, _dict_to_cell(npc.get("cell", {})), Vector2i.ONE):
				return {"kind": "npc", "id": str(npc.get("npc_id", ""))}
	for place_value in world_map.get("places", []):
		if not place_value is Dictionary:
			continue
		var place: Dictionary = place_value
		for protected_cell in _place_protected_cells(place):
			if _rects_overlap(cell, size, protected_cell, Vector2i.ONE):
				return {"kind": "place", "id": str(place.get("place_id", ""))}
	return {}


func _place_protected_cells(place: Dictionary) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for value in place.get("occupied_cells", []):
		result.append(_dict_to_cell(value))
	if result.is_empty():
		var place_cell := _dict_to_cell(place.get("position", {}))
		var size: Dictionary = place.get("size", {"w": 1, "h": 1})
		for y in range(max(1, int(size.get("h", 1)))):
			for x in range(max(1, int(size.get("w", 1)))):
				result.append(place_cell + Vector2i(x, y))
	if place.get("interaction_cell") is Dictionary:
		result.append(_dict_to_cell(place.get("interaction_cell", {})))
	return result


func _rects_overlap(a_cell: Vector2i, a_size: Vector2i, b_cell: Vector2i, b_size: Vector2i) -> bool:
	return a_cell.x < b_cell.x + b_size.x and a_cell.x + a_size.x > b_cell.x and a_cell.y < b_cell.y + b_size.y and a_cell.y + a_size.y > b_cell.y


func _dict_to_cell(value: Variant) -> Vector2i:
	if value is Vector2i:
		return value
	if value is Dictionary:
		var cell: Dictionary = value
		return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))
	return Vector2i.ZERO


func _load_world_map() -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	return result.get("data", {}).duplicate(true)


func _load_resource_points() -> Array:
	var file := FileAccess.open(RESOURCE_POINTS_PATH, FileAccess.READ)
	if file == null:
		return []
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return []
	return (parsed as Dictionary).get("resource_points", []).duplicate(true)
