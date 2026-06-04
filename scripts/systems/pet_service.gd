extends RefCounted
class_name PetService

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


func initialize_pet_state() -> Dictionary:
	var game_state := _load_game_state()
	var initial_pet: Dictionary = loop_config.get("initial_state", {}).get("pet", {})
	var pet_config: Dictionary = loop_config.get("pet", {})
	var pet_state := _pet_state_from_game_state(game_state)
	pet_state["pet_id"] = pet_config.get("pet_id", "pet_sunny_dog")
	pet_state["display_name"] = pet_config.get("display_name", "Sunny")
	pet_state["species"] = pet_config.get("species", "dog")
	pet_state["hunger"] = _clamp_int(int(pet_state.get("hunger", initial_pet.get("hunger", 30))), "hunger")
	pet_state["happy"] = _clamp_int(int(pet_state.get("happy", initial_pet.get("happy", 40))), "happy")
	pet_state["fed_today"] = bool(pet_state.get("fed_today", initial_pet.get("fed_today", false)))
	game_state["pet"] = pet_state

	var saved: bool = save_service.save_game_state(game_state)
	return {"ok": saved, "pet": pet_state.duplicate(true), "game_state": game_state.duplicate(true)}


func get_pet_state() -> Dictionary:
	return _pet_state_from_game_state(_load_game_state())


func set_hunger(hunger: int) -> Dictionary:
	var game_state := _load_game_state()
	var pet_state := _pet_state_from_game_state(game_state)
	pet_state["hunger"] = _clamp_int(hunger, "hunger")
	game_state["pet"] = pet_state
	var saved: bool = save_service.save_game_state(game_state)
	return {"ok": saved, "pet": pet_state.duplicate(true), "game_state": game_state.duplicate(true)}


func feed(food_item_id: String = "") -> Dictionary:
	var item_id := food_item_id
	if item_id.is_empty():
		item_id = _food_item_id()

	var feed_rule: Dictionary = loop_config.get("reward_rules", {}).get("feed_pet", {})
	var required_count := int(feed_rule.get("requires_inventory", {}).get(item_id, 1))
	var consume_count := int(feed_rule.get("consume_inventory", {}).get(item_id, required_count))
	var game_state := _load_game_state()
	var inventory: Dictionary = game_state.get("inventory", {}).duplicate(true)
	var current_count := int(inventory.get(item_id, 0))
	if current_count < required_count:
		return {
			"ok": false,
			"reason": "no_food",
			"message": "snack_not_ready",
			"pet": _pet_state_from_game_state(game_state),
			"game_state": game_state.duplicate(true),
		}

	var pet_state := _pet_state_from_game_state(game_state)
	var delta: Dictionary = feed_rule.get("pet_delta", {})
	pet_state["hunger"] = _clamp_int(int(pet_state.get("hunger", 0)) + int(delta.get("hunger", 0)), "hunger")
	pet_state["happy"] = _clamp_int(int(pet_state.get("happy", 0)) + int(delta.get("happy", 0)), "happy")
	pet_state["fed_today"] = true
	inventory[item_id] = max(0, current_count - consume_count)

	var flags: Dictionary = game_state.get("flags", {}).duplicate(true)
	for flag_name in feed_rule.get("save_flags", {}).keys():
		flags[flag_name] = bool(feed_rule.get("save_flags", {}).get(flag_name))

	game_state["pet"] = pet_state
	game_state["inventory"] = inventory
	game_state["flags"] = flags
	var saved: bool = save_service.save_game_state(game_state)
	return {
		"ok": saved,
		"reason": "fed",
		"consumed_item_id": item_id,
		"pet": pet_state.duplicate(true),
		"game_state": game_state.duplicate(true),
	}


func _load_game_state() -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	if not game_state.get("inventory") is Dictionary:
		game_state["inventory"] = {}
	if not game_state.get("flags") is Dictionary:
		game_state["flags"] = {}
	return game_state


func _pet_state_from_game_state(game_state: Dictionary) -> Dictionary:
	var initial_pet: Dictionary = loop_config.get("initial_state", {}).get("pet", {})
	var pet_config: Dictionary = loop_config.get("pet", {})
	var existing: Dictionary = {}
	if game_state.get("pet") is Dictionary:
		existing = game_state.get("pet", {}).duplicate(true)

	return {
		"pet_id": existing.get("pet_id", pet_config.get("pet_id", "pet_sunny_dog")),
		"display_name": existing.get("display_name", pet_config.get("display_name", "Sunny")),
		"species": existing.get("species", pet_config.get("species", "dog")),
		"hunger": _clamp_int(int(existing.get("hunger", initial_pet.get("hunger", 30))), "hunger"),
		"happy": _clamp_int(int(existing.get("happy", initial_pet.get("happy", 40))), "happy"),
		"fed_today": bool(existing.get("fed_today", initial_pet.get("fed_today", false))),
	}


func _food_item_id() -> String:
	return str(loop_config.get("economy", {}).get("food_item_id", "food_pet_snack"))


func _clamp_int(value: int, stat_name: String) -> int:
	var limits: Dictionary = loop_config.get("reward_rules", {}).get("feed_pet", {}).get("pet_limits", {})
	var min_value := int(limits.get("%s_min" % stat_name, 0))
	var max_value := int(limits.get("%s_max" % stat_name, 100))
	return clamp(value, min_value, max_value)


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
