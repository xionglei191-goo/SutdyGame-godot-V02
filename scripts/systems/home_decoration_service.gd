extends RefCounted
class_name HomeDecorationService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")

var save_service
var inventory_service


func _init(service = null, inventory = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	inventory_service = inventory if inventory != null else InventoryServiceScript.new(save_service)


func place_furniture(item_id: String, cell: Vector2i) -> Dictionary:
	var item: Dictionary = inventory_service.get_item(item_id)
	if not item.get("ok", false):
		return item
	if str(item.get("item_type", "")) != "furniture":
		return {"ok": false, "reason": "not_furniture", "item_id": item_id}

	var consumed: Dictionary = inventory_service.consume_item(item_id, 1)
	if not consumed.get("ok", false):
		return consumed

	var game_state: Dictionary = save_service.load_game_state()
	var home_state: Dictionary = game_state.get("home_state", {})
	var placed: Array = home_state.get("placed_furniture", [])
	var instance_id: String = "%s_%03d" % [item_id, placed.size() + 1]
	var record: Dictionary = {
		"instance_id": instance_id,
		"item_id": item_id,
		"cell": {"x": cell.x, "y": cell.y},
		"display_name": item.get("display_name", item_id),
		"memory_story": item.get("memory_story", {}).duplicate(true),
	}
	placed.append(record)
	home_state["placed_furniture"] = placed
	game_state["home_state"] = home_state
	var saved: bool = save_service.save_game_state(game_state)
	return {"ok": saved, "furniture": record.duplicate(true), "home_state": home_state.duplicate(true)}


func get_home_state() -> Dictionary:
	return save_service.load_game_state().get("home_state", {"placed_furniture": []}).duplicate(true)
