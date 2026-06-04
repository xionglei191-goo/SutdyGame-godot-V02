extends RefCounted
class_name ShopService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const LOOP_CONFIG_PATH := "res://data/quests/pet_food_loop.json"

var save_service
var config_path: String
var loop_config: Dictionary = {}


func _init(service = null, path: String = LOOP_CONFIG_PATH) -> void:
	save_service = service
	if save_service == null:
		save_service = SaveServiceScript.new()
	config_path = path
	loop_config = _load_loop_config(config_path)


func buy_pet_food() -> Dictionary:
	return buy_item(_food_item_id())


func buy_item(item_id: String) -> Dictionary:
	var economy: Dictionary = loop_config.get("economy", {})
	var buy_rule: Dictionary = loop_config.get("reward_rules", {}).get("buy_pet_food", {})
	var food_item_id := _food_item_id()
	if item_id != food_item_id:
		return {"ok": false, "reason": "unknown_item", "item_id": item_id}

	var price := int(economy.get("food_price", buy_rule.get("spend_coins", 0)))
	var quantity := int(economy.get("purchase_quantity", buy_rule.get("add_inventory", {}).get(item_id, 1)))
	var game_state := _load_game_state()
	var coins := int(game_state.get("coins", 0))
	if coins < price:
		return {
			"ok": false,
			"reason": "not_enough_coins",
			"message": "come_back_with_more_coins",
			"item_id": item_id,
			"price": price,
			"coins": coins,
			"game_state": game_state.duplicate(true),
		}

	var inventory: Dictionary = game_state.get("inventory", {}).duplicate(true)
	game_state["coins"] = max(0, coins - price)
	inventory[item_id] = int(inventory.get(item_id, 0)) + quantity
	game_state["inventory"] = inventory

	var saved: bool = save_service.save_game_state(game_state)
	return {
		"ok": saved,
		"reason": "purchased",
		"item_id": item_id,
		"price": price,
		"quantity": quantity,
		"coins": int(game_state.get("coins", 0)),
		"game_state": game_state.duplicate(true),
	}


func get_pet_food_offer() -> Dictionary:
	var economy: Dictionary = loop_config.get("economy", {})
	return {
		"item_id": _food_item_id(),
		"display_name": economy.get("food_display_name", "Sunny Snack"),
		"price": int(economy.get("food_price", 0)),
		"quantity": int(economy.get("purchase_quantity", 1)),
	}


func _load_game_state() -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	if not game_state.get("inventory") is Dictionary:
		game_state["inventory"] = {}
	return game_state


func _food_item_id() -> String:
	return str(loop_config.get("economy", {}).get("food_item_id", "food_pet_snack"))


func _load_loop_config(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Unable to open pet loop config: %s" % path)
		return {}

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Pet loop config must be a JSON object: %s" % path)
		return {}
	return parsed
