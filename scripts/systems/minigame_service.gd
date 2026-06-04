extends RefCounted
class_name MinigameService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const CONFIG_PATH := "res://data/minigames/letter_snake_config.json"

var save_service
var memory_card_service
var config: Dictionary = {}


func _init(service = null, card_service = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	memory_card_service = card_service if card_service != null else MemoryCardServiceScript.new(save_service)
	config = _load_config()


func start_minigame(set_id: String) -> Dictionary:
	var target_set := _set_by_id(set_id)
	if target_set.is_empty():
		return {"ok": false, "reason": "unknown_set", "set_id": set_id}
	return {
		"ok": true,
		"minigame_id": config.get("minigame_id", "letter_snake"),
		"set": target_set,
		"round_defaults": config.get("round_defaults", {}).duplicate(true),
	}


func complete_minigame(result: Dictionary) -> Dictionary:
	var set_id := str(result.get("config_set_id", ""))
	var target_set := _set_by_id(set_id)
	if target_set.is_empty():
		return {"ok": false, "reason": "unknown_set", "set_id": set_id}

	var reward := _reward_for_score(int(result.get("score", 0)))
	var completed := result.duplicate(true)
	completed["minigame_id"] = config.get("minigame_id", "letter_snake")
	completed["card_ids"] = target_set.get("card_ids", []).duplicate(true)
	completed["reward"] = reward

	var card_result: Dictionary = memory_card_service.apply_minigame_reward(completed)
	var game_state: Dictionary = save_service.load_game_state()
	game_state["coins"] = max(0, int(game_state.get("coins", 0))) + int(reward.get("coins", 0))
	save_service.save_game_state(game_state)

	return {
		"ok": card_result.get("ok", false),
		"result": completed,
		"reward": reward,
		"card_result": card_result,
		"game_state": game_state.duplicate(true),
	}


func _reward_for_score(score: int) -> Dictionary:
	var best: Dictionary = {}
	for tier in config.get("reward_profile", {}).get("tiers", []):
		if int(tier.get("min_score", 0)) <= score:
			best = tier
	return best.duplicate(true)


func _set_by_id(set_id: String) -> Dictionary:
	for item in config.get("sets", []):
		if item is Dictionary and item.get("set_id", "") == set_id:
			return item.duplicate(true)
	return {}


func _load_config() -> Dictionary:
	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file == null:
		push_warning("Unable to open minigame config: %s" % CONFIG_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Minigame config must be a JSON object: %s" % CONFIG_PATH)
		return {}
	return parsed
