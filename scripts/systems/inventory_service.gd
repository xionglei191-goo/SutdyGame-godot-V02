extends RefCounted
class_name InventoryService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const ITEM_CATALOG_PATH := "res://data/items/life_items.json"

var save_service
var catalog_path: String = ITEM_CATALOG_PATH
var items_by_id: Dictionary = {}
var load_errors: Array[String] = []


func _init(service = null, path: String = ITEM_CATALOG_PATH) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	catalog_path = path
	_load_catalog()


func is_loaded() -> bool:
	return load_errors.is_empty()


func get_item(item_id: String) -> Dictionary:
	if not items_by_id.has(item_id):
		return {"ok": false, "reason": "unknown_item", "item_id": item_id}
	var item: Dictionary = items_by_id[item_id]
	var result := item.duplicate(true)
	result["ok"] = true
	return result


func get_catalog_data() -> Dictionary:
	var rotations: Array = []
	var file := FileAccess.open(catalog_path, FileAccess.READ)
	if file == null:
		return {"ok": false, "reason": "unable_to_open_catalog", "shop_rotations": []}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {"ok": false, "reason": "invalid_catalog", "shop_rotations": []}
	var data: Dictionary = parsed
	for rotation in data.get("shop_rotations", []):
		if rotation is Dictionary:
			rotations.append((rotation as Dictionary).duplicate(true))
	return {"ok": true, "shop_rotations": rotations}


func get_inventory() -> Dictionary:
	return save_service.load_game_state().get("inventory", {}).duplicate(true)


func collect_item(item_id: String, quantity: int = 1) -> Dictionary:
	var item: Dictionary = get_item(item_id)
	if not item.get("ok", false):
		return item
	var amount: int = max(1, quantity)
	var game_state: Dictionary = save_service.load_game_state()
	var inventory: Dictionary = game_state.get("inventory", {}).duplicate(true)
	inventory[item_id] = int(inventory.get(item_id, 0)) + amount
	game_state["inventory"] = inventory
	var saved: bool = save_service.save_game_state(game_state)
	return {
		"ok": saved,
		"item_id": item_id,
		"quantity": amount,
		"inventory": inventory.duplicate(true),
	}


func consume_item(item_id: String, quantity: int = 1) -> Dictionary:
	var amount: int = max(1, quantity)
	var game_state: Dictionary = save_service.load_game_state()
	var inventory: Dictionary = game_state.get("inventory", {}).duplicate(true)
	var current: int = int(inventory.get(item_id, 0))
	if current < amount:
		return {"ok": false, "reason": "not_enough_items", "item_id": item_id, "quantity": amount, "current": current}
	inventory[item_id] = current - amount
	game_state["inventory"] = inventory
	var saved: bool = save_service.save_game_state(game_state)
	return {"ok": saved, "item_id": item_id, "quantity": amount, "inventory": inventory.duplicate(true)}


func _load_catalog() -> void:
	load_errors.clear()
	items_by_id.clear()
	var file := FileAccess.open(catalog_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open item catalog: %s" % catalog_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Item catalog must be a JSON object: %s" % catalog_path)
		return
	for item in parsed.get("items", []):
		if not item is Dictionary:
			load_errors.append("Item catalog entry must be an object")
			continue
		var item_id := str(item.get("item_id", ""))
		if item_id.is_empty():
			load_errors.append("Item catalog entry missing item_id")
			continue
		if not item.get("memory_story") is Dictionary:
			load_errors.append("Item missing memory_story: %s" % item_id)
		items_by_id[item_id] = item.duplicate(true)
