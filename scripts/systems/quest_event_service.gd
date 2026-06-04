extends RefCounted
class_name QuestEventService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const PetServiceScript := preload("res://scripts/systems/pet_service.gd")
const ShopServiceScript := preload("res://scripts/systems/shop_service.gd")
const LOOP_CONFIG_PATH := "res://data/quests/pet_food_loop.json"

var save_service
var memory_card_service
var pet_service
var shop_service
var config: Dictionary = {}
var events_by_id: Dictionary = {}


func _init(service = null, card_service = null, pet = null, shop = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	memory_card_service = card_service if card_service != null else MemoryCardServiceScript.new(save_service)
	pet_service = pet if pet != null else PetServiceScript.new(save_service)
	shop_service = shop if shop != null else ShopServiceScript.new(save_service)
	config = _load_config()
	for event in config.get("quest_chain", []):
		events_by_id[event.get("event_id", "")] = event


func start_chain() -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var initial: Dictionary = config.get("initial_state", {})
	game_state["current_event_id"] = "event_welcome_home"
	game_state["current_place_id"] = initial.get("current_place_id", "place_home")
	game_state["coins"] = int(initial.get("coins", 0))
	game_state["inventory"] = initial.get("inventory", {}).duplicate(true)
	game_state["pet"] = initial.get("pet", {}).duplicate(true)
	game_state["flags"] = {}
	save_service.save_game_state(game_state)

	for card_id in initial.get("cards", {}).keys():
		if initial.get("cards", {}).get(card_id) == "seen":
			memory_card_service.mark_seen(card_id)

	return {"ok": true, "event": get_current_event(), "game_state": game_state.duplicate(true)}


func get_current_event() -> Dictionary:
	var current_id := str(save_service.load_game_state().get("current_event_id", "event_welcome_home"))
	return events_by_id.get(current_id, {}).duplicate(true)


func advance_event(event_id: String) -> Dictionary:
	if not events_by_id.has(event_id):
		return {"ok": false, "reason": "unknown_event", "event_id": event_id}
	if event_id == "event_food_basket":
		var purchase: Dictionary = shop_service.buy_pet_food()
		if not purchase.get("ok", false):
			return {"ok": false, "reason": purchase.get("reason", ""), "needs": "letter_snake_food", "purchase": purchase}
	if event_id == "event_feed_sunny":
		var feed: Dictionary = pet_service.feed()
		if not feed.get("ok", false):
			return {"ok": false, "reason": feed.get("reason", ""), "needs": "food_pet_snack", "feed": feed}

	var event: Dictionary = events_by_id[event_id]
	var game_state: Dictionary = save_service.load_game_state()
	_apply_state_out(game_state, event.get("state_out", {}))
	game_state["current_event_id"] = event.get("next_event_id", "")
	save_service.save_game_state(game_state)
	return {"ok": true, "event_id": event_id, "next_event_id": event.get("next_event_id", ""), "game_state": game_state.duplicate(true)}


func _apply_state_out(game_state: Dictionary, state_out: Dictionary) -> void:
	for key in state_out.keys():
		var value = state_out[key]
		if key == "current_place_id":
			game_state["current_place_id"] = value
		elif key.begins_with("flags."):
			var flags: Dictionary = game_state.get("flags", {}).duplicate(true)
			flags[key.split(".")[1]] = value
			game_state["flags"] = flags
		elif key.begins_with("pet."):
			var pet: Dictionary = game_state.get("pet", {}).duplicate(true)
			var pet_key: String = key.split(".")[1]
			if pet_key.ends_with("_delta"):
				var base_key: String = pet_key.replace("_delta", "")
				pet[base_key] = int(pet.get(base_key, 0)) + int(value)
			else:
				pet[pet_key] = value
			game_state["pet"] = pet
		elif key.begins_with("inventory."):
			var inventory: Dictionary = game_state.get("inventory", {}).duplicate(true)
			inventory[key.split(".")[1]] = value
			game_state["inventory"] = inventory
		elif key.begins_with("cards."):
			var card_id: String = key.split(".")[1]
			_apply_card_state(card_id, str(value))
		elif key == "coins_add":
			game_state["coins"] = max(0, int(game_state.get("coins", 0)) + int(value))
		elif key == "save_snapshot":
			var flags: Dictionary = game_state.get("flags", {}).duplicate(true)
			flags["save_snapshot"] = value
			game_state["flags"] = flags


func _apply_card_state(card_id: String, state_name: String) -> void:
	match state_name:
		"seen":
			memory_card_service.mark_seen(card_id)
		"played":
			memory_card_service.mark_played(card_id)
		"collected":
			memory_card_service.mark_collected(card_id)


func _load_config() -> Dictionary:
	var file := FileAccess.open(LOOP_CONFIG_PATH, FileAccess.READ)
	if file == null:
		push_warning("Unable to open quest config: %s" % LOOP_CONFIG_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Quest config must be a JSON object: %s" % LOOP_CONFIG_PATH)
		return {}
	return parsed
