extends RefCounted
class_name MemoryCardService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const CORE_CARDS_PATH := "res://data/cards/az_core_cards.json"
const EXTENSION_CARDS_PATH := "res://data/cards/first_batch_extension_cards.json"
const DEFAULT_COLLECT_PROGRESS := 4
const DEFAULT_STATE: Dictionary = {
	"seen": false,
	"heard": false,
	"played": false,
	"collected": false,
	"shiny": false,
	"spark": 0,
	"card_progress": 0,
}

var save_service
var cards_by_id: Dictionary = {}
var load_warnings: Array[String] = []
var load_errors: Array[String] = []


func _init(service = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	load_cards()


func load_cards() -> Dictionary:
	cards_by_id.clear()
	load_warnings.clear()
	load_errors.clear()

	_load_card_file(CORE_CARDS_PATH, true)
	_load_card_file(EXTENSION_CARDS_PATH, false)

	return {
		"ok": load_errors.is_empty(),
		"errors": load_errors.duplicate(),
		"warnings": load_warnings.duplicate(),
		"cards": cards_by_id.duplicate(true),
	}


func has_card(card_id: String) -> bool:
	return cards_by_id.has(card_id)


func get_card(card_id: String) -> Dictionary:
	return cards_by_id.get(card_id, {}).duplicate(true)


func get_all_cards() -> Array[Dictionary]:
	var cards: Array[Dictionary] = []
	for card in cards_by_id.values():
		cards.append(card.duplicate(true))
	cards.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return str(a.get("card_id", "")) < str(b.get("card_id", ""))
	)
	return cards


func get_card_state(card_id: String) -> Dictionary:
	var learning_record: Dictionary = save_service.load_learning_record()
	var card_states: Dictionary = learning_record.get("card_states", {})
	return _normalized_state(card_states.get(card_id, {}))


func save_card_state(card_id: String, state: Dictionary) -> bool:
	if card_id.is_empty():
		push_warning("Cannot save card state without card_id.")
		return false

	var learning_record: Dictionary = save_service.load_learning_record()
	var card_states: Dictionary = learning_record.get("card_states", {})
	card_states[card_id] = _normalized_state(state)
	learning_record["card_states"] = card_states
	return save_service.save_learning_record(learning_record)


func set_card_flags(card_id: String, flags: Dictionary) -> bool:
	var state: Dictionary = get_card_state(card_id)
	for key in ["seen", "heard", "played", "collected", "shiny"]:
		if flags.has(key):
			state[key] = bool(flags[key])
	if flags.has("spark"):
		state["spark"] = max(0, int(flags["spark"]))
	if flags.has("card_progress"):
		state["card_progress"] = max(0, int(flags["card_progress"]))
	return save_card_state(card_id, state)


func mark_seen(card_id: String) -> bool:
	return set_card_flags(card_id, {"seen": true})


func mark_heard(card_id: String) -> bool:
	return set_card_flags(card_id, {"seen": true, "heard": true})


func mark_played(card_id: String) -> bool:
	return set_card_flags(card_id, {"seen": true, "played": true})


func mark_collected(card_id: String) -> bool:
	return set_card_flags(card_id, {"seen": true, "collected": true})


func apply_minigame_reward(result: Dictionary) -> Dictionary:
	var reward: Dictionary = result.get("reward", {})
	var card_ids: Array[String] = _target_card_ids(result)
	var changed_states: Dictionary = {}
	var skipped_cards: Array[String] = []

	for card_id in card_ids:
		if not has_card(card_id):
			skipped_cards.append(card_id)
			continue
		var state: Dictionary = get_card_state(card_id)
		_apply_reward_to_state(state, reward)
		if save_card_state(card_id, state):
			changed_states[card_id] = state.duplicate(true)

	var learning_record: Dictionary = save_service.load_learning_record()
	var results: Array = learning_record.get("minigame_results", [])
	results.append(result.duplicate(true))
	learning_record["minigame_results"] = results
	save_service.save_learning_record(learning_record)

	return {
		"ok": skipped_cards.is_empty(),
		"changed_states": changed_states,
		"skipped_cards": skipped_cards,
	}


func _load_card_file(path: String, required: bool) -> void:
	if not FileAccess.file_exists(path):
		var message := "Card file is missing: %s" % path
		if required:
			load_errors.append(message)
		else:
			load_warnings.append("Optional extension cards skipped: %s" % path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		var open_message := "Unable to open card file: %s" % path
		if required:
			load_errors.append(open_message)
		else:
			load_warnings.append(open_message)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		var parse_message := "Card file root must be a dictionary: %s" % path
		if required:
			load_errors.append(parse_message)
		else:
			load_warnings.append(parse_message)
		return

	var data: Dictionary = parsed
	for card in data.get("cards", []):
		if not card is Dictionary:
			continue
		var card_data: Dictionary = card
		var card_id := str(card_data.get("card_id", ""))
		if card_id.is_empty():
			load_warnings.append("Card without card_id skipped in %s" % path)
			continue
		if cards_by_id.has(card_id):
			load_warnings.append("Duplicate card_id skipped: %s" % card_id)
			continue
		cards_by_id[card_id] = card_data.duplicate(true)


func _target_card_ids(result: Dictionary) -> Array[String]:
	var card_ids: Array[String] = []
	for key in ["card_ids", "target_card_ids"]:
		for card_id in result.get(key, []):
			_add_unique(card_ids, str(card_id))
	var reward: Dictionary = result.get("reward", {})
	for card_id in reward.get("card_ids", []):
		_add_unique(card_ids, str(card_id))
	return card_ids


func _apply_reward_to_state(state: Dictionary, reward: Dictionary) -> void:
	var progress_gain: int = max(0, int(reward.get("card_progress", 0)))
	state["seen"] = true
	state["played"] = true
	state["card_progress"] = max(0, int(state.get("card_progress", 0))) + progress_gain

	if _reward_adds_spark(reward):
		state["spark"] = max(0, int(state.get("spark", 0))) + 1

	if bool(state.get("collected", false)) or float(reward.get("collected_chance", 0.0)) >= 1.0 or int(state.get("card_progress", 0)) >= DEFAULT_COLLECT_PROGRESS:
		state["collected"] = true

	if bool(state.get("shiny", false)) or bool(reward.get("shiny", false)) or float(reward.get("shiny_chance", 0.0)) >= 1.0:
		state["shiny"] = true


func _reward_adds_spark(reward: Dictionary) -> bool:
	var value: Variant = reward.get("spark", false)
	if value is bool:
		return bool(value)
	return int(value) > 0


func _normalized_state(value: Dictionary) -> Dictionary:
	var state := DEFAULT_STATE.duplicate(true)
	for key in value.keys():
		state[key] = value[key]
	for key in ["seen", "heard", "played", "collected", "shiny"]:
		state[key] = bool(state.get(key, false))
	state["spark"] = max(0, int(state.get("spark", 0)))
	state["card_progress"] = max(0, int(state.get("card_progress", 0)))
	return state


func _add_unique(values: Array[String], value: String) -> void:
	if not value.is_empty() and not values.has(value):
		values.append(value)
