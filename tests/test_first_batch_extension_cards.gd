extends SceneTree

const CORE_CARDS_PATH := "res://data/cards/az_core_cards.json"
const EXTENSION_CARDS_PATH := "res://data/cards/first_batch_extension_cards.json"
const LETTER_SNAKE_PATH := "res://data/minigames/letter_snake_config.json"
const PET_LOOP_PATH := "res://data/quests/pet_food_loop.json"
const REQUIRED_CARD_IDS: Array[String] = [
	"card_pet_hungry",
	"card_pet_food",
	"card_shop_buy",
	"card_shop_egg",
	"card_town_bus",
	"card_weather_windy",
]
const INITIAL_COLLECTION_STATE: Dictionary = {
	"seen": false,
	"heard": false,
	"played": false,
	"collected": false,
	"shiny": false,
	"spark": 0,
}

var failures: Array[String] = []


func _init() -> void:
	var core_ids := _card_ids(_load_json(CORE_CARDS_PATH).get("cards", []))
	var data := _load_json(EXTENSION_CARDS_PATH)
	var cards: Array = data.get("cards", [])
	var extension_ids: Array[String] = []

	_expect(data.get("schema_id", "") == "first_batch_extension_cards_v1", "extension schema_id must be first_batch_extension_cards_v1")
	_expect(cards.size() >= REQUIRED_CARD_IDS.size(), "extension cards must include at least required first-batch records")

	for card in cards:
		_validate_card(card, extension_ids, core_ids)

	for card_id in REQUIRED_CARD_IDS:
		_expect(extension_ids.has(card_id), "required extension card missing: %s" % card_id)

	var referenced := _referenced_cards()
	for card_id in referenced:
		if core_ids.has(card_id):
			continue
		_expect(extension_ids.has(card_id), "non-core referenced card must exist in extension cards: %s" % card_id)

	if failures.is_empty():
		print("HEADLESS TESTS PASSED: first batch extension cards")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _validate_card(card: Dictionary, extension_ids: Array[String], core_ids: Array[String]) -> void:
	var card_id: String = card.get("card_id", "")
	_expect(not card_id.is_empty(), "card_id is required")
	_expect(not extension_ids.has(card_id), "extension card_id must be unique: %s" % card_id)
	_expect(not core_ids.has(card_id), "extension card_id must not duplicate core card: %s" % card_id)
	extension_ids.append(card_id)

	_expect(str(card.get("word", "")).length() > 0, "card word is required: %s" % card_id)
	_expect(card.has("letter") or card.has("learning_tag"), "card must include letter or learning_tag: %s" % card_id)
	_expect(str(card.get("story_memory", "")).length() > 0, "card story_memory is required: %s" % card_id)
	_expect(card.has("source_curriculum_refs") or card.has("source_fill_needed"), "card must include source refs or fill-needed marker: %s" % card_id)
	_expect(card.has("minigame_refs"), "card minigame_refs is required: %s" % card_id)
	_expect(card.has("quest_refs"), "card quest_refs is required: %s" % card_id)

	if card.has("source_curriculum_refs"):
		var refs: Array = card.get("source_curriculum_refs", [])
		_expect(not refs.is_empty(), "source_curriculum_refs must not be empty: %s" % card_id)
		for ref in refs:
			_expect(ref is Dictionary, "source_curriculum_refs entries must be dictionaries: %s" % card_id)
			if ref is Dictionary:
				_expect(str(ref.get("source", "")).length() > 0, "source ref source is required: %s" % card_id)
	if card.has("source_fill_needed"):
		_expect(str(card.get("source_fill_needed", "")).length() > 0, "source_fill_needed must not be empty: %s" % card_id)

	var collection_state: Dictionary = card.get("collection_state", {})
	for key in INITIAL_COLLECTION_STATE.keys():
		_expect(collection_state.has(key), "card collection_state missing %s: %s" % [key, card_id])
		_expect(collection_state.get(key) == INITIAL_COLLECTION_STATE[key], "card collection_state initial %s mismatch: %s" % [key, card_id])


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
