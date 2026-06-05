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


func get_shop_rotation(rotation_id: String) -> Dictionary:
	var data: Dictionary = inventory_service.get_catalog_data()
	for rotation_value in data.get("shop_rotations", []):
		if not rotation_value is Dictionary:
			continue
		var rotation: Dictionary = rotation_value
		if str(rotation.get("rotation_id", "")) == rotation_id:
			return _build_rotation_result(rotation)
	return {"ok": false, "reason": "unknown_rotation", "rotation_id": rotation_id, "offers": []}


func get_shop_rotation_for_day(day_key: String) -> Dictionary:
	var data: Dictionary = inventory_service.get_catalog_data()
	for rotation_value in data.get("shop_rotations", []):
		if not rotation_value is Dictionary:
			continue
		var rotation: Dictionary = rotation_value
		if str(rotation.get("day_key", "")) == day_key:
			return _build_rotation_result(rotation)
	return {"ok": false, "reason": "unknown_day_key", "day_key": day_key, "offers": []}


func get_all_shop_rotations() -> Array:
	var results: Array = []
	var data: Dictionary = inventory_service.get_catalog_data()
	for rotation_value in data.get("shop_rotations", []):
		if rotation_value is Dictionary:
			results.append(_build_rotation_result(rotation_value))
	return results


func _build_rotation_result(rotation: Dictionary) -> Dictionary:
	var offers: Array = []
	for offer_value in rotation.get("offers", []):
		if not offer_value is Dictionary:
			continue
		var offer_spec: Dictionary = offer_value
		var item_id := str(offer_spec.get("item_id", ""))
		var item: Dictionary = inventory_service.get_item(item_id)
		if not item.get("ok", false):
			continue
		var offer := get_offer(item_id)
		offer["rotation_tier"] = str(offer_spec.get("rotation_tier", ""))
		offer["slot"] = str(offer_spec.get("slot", ""))
		offers.append(offer)
	return {
		"ok": true,
		"rotation_id": str(rotation.get("rotation_id", "")),
		"day_key": str(rotation.get("day_key", "")),
		"theme": str(rotation.get("theme", "")),
		"weather_activity_corner": rotation.get("weather_activity_corner", {}).duplicate(true),
		"offers": offers,
	}
