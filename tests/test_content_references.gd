extends SceneTree

const CORE_CARDS_PATH := "res://data/cards/az_core_cards.json"
const EXTENSION_CARDS_PATH := "res://data/cards/first_batch_extension_cards.json"
const LETTER_SNAKE_PATH := "res://data/minigames/letter_snake_config.json"
const PET_LOOP_PATH := "res://data/quests/pet_food_loop.json"

var failures: Array[String] = []


func _init() -> void:
	var core_cards := _card_ids(_load_json(CORE_CARDS_PATH).get("cards", []))
	var extension_cards := _card_ids(_load_json(EXTENSION_CARDS_PATH).get("cards", []))
	var referenced := _referenced_cards()

	for card_id in referenced:
		if core_cards.has(card_id):
			continue
		_expect(extension_cards.has(card_id), "unknown referenced card_id must be core or first-batch extension: %s" % card_id)

	for card_id in extension_cards:
		_expect(referenced.has(card_id), "extension card should be referenced by first-loop content: %s" % card_id)

	if failures.is_empty():
		print("CONTENT REFERENCE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _referenced_cards() -> Array[String]:
	var refs: Array[String] = []
	var minigame := _load_json(LETTER_SNAKE_PATH)
	for set_data in minigame.get("sets", []):
		for card_id in set_data.get("card_ids", []):
			_add_unique(refs, str(card_id))

	var quest := _load_json(PET_LOOP_PATH)
	for card_id in quest.get("initial_state", {}).get("cards", {}).keys():
		_add_unique(refs, str(card_id))
	for rule in quest.get("reward_rules", {}).values():
		if not rule is Dictionary:
			continue
		for card_id in rule.get("target_cards", []):
			_add_unique(refs, str(card_id))
		for card_id in rule.get("card_updates", {}).keys():
			_add_unique(refs, str(card_id))
	for event in quest.get("quest_chain", []):
		for key in event.get("state_out", {}).keys():
			var key_text := str(key)
			if key_text.begins_with("cards."):
				_add_unique(refs, key_text.split(".")[1])

	refs.sort()
	return refs


func _card_ids(cards: Array) -> Array[String]:
	var ids: Array[String] = []
	for card in cards:
		_add_unique(ids, str(card.get("card_id", "")))
	ids.sort()
	return ids


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		failures.append("Cannot open JSON: %s" % path)
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		failures.append("JSON root must be a dictionary: %s" % path)
		return {}
	return parsed


func _add_unique(values: Array[String], value: String) -> void:
	if not value.is_empty() and not values.has(value):
		values.append(value)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
