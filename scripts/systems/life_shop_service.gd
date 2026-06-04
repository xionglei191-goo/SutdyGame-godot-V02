extends RefCounted
class_name LifeShopService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")

var save_service
var inventory_service


func _init(service = null, inventory = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	inventory_service = inventory if inventory != null else InventoryServiceScript.new(save_service)


func buy_life_item(item_id: String) -> Dictionary:
	var item: Dictionary = inventory_service.get_item(item_id)
	if not item.get("ok", false):
		return item
	if str(item.get("item_type", "")) != "furniture":
		return {"ok": false, "reason": "not_for_sale", "item_id": item_id}

	var price := int(item.get("price", 0))
	var game_state: Dictionary = save_service.load_game_state()
	var coins := int(game_state.get("coins", 0))
	if coins < price:
		return {"ok": false, "reason": "not_enough_coins", "item_id": item_id, "price": price, "coins": coins}

	game_state["coins"] = coins - price
	save_service.save_game_state(game_state)
	var collected: Dictionary = inventory_service.collect_item(item_id, 1)
	return {
		"ok": collected.get("ok", false),
		"item_id": item_id,
		"price": price,
		"coins": int(save_service.load_game_state().get("coins", 0)),
		"inventory": collected.get("inventory", {}),
	}


func get_offer(item_id: String = "wooden_chair") -> Dictionary:
	var item: Dictionary = inventory_service.get_item(item_id)
	if not item.get("ok", false):
		return item
	return {
		"ok": true,
		"item_id": item_id,
		"display_name": item.get("localized_display_name", item.get("display_name", item_id)),
		"price": int(item.get("price", 0)),
		"item_type": item.get("item_type", ""),
		"memory_story": item.get("memory_story", {}).duplicate(true),
	}
