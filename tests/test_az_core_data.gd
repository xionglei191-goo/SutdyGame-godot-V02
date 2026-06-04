extends SceneTree

const ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const CARDS_PATH := "res://data/cards/az_core_cards.json"
const LETTERS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const FIRST_BATCH_LETTERS: Array[String] = ["A", "B", "C", "D", "K", "O", "S", "T", "W"]
const CORE_WORD_BY_LETTER: Dictionary = {
	"A": "Apple",
	"B": "Bear",
	"C": "Clock",
	"D": "Dog",
	"E": "Elephant",
	"F": "Fox",
	"G": "Gate",
	"H": "Hat",
	"I": "Ice cream",
	"J": "Jacket",
	"K": "Kite",
	"L": "Lion",
	"M": "Monkey",
	"N": "Net",
	"O": "Orange",
	"P": "Panda",
	"Q": "Queen",
	"R": "Robot",
	"S": "Sun",
	"T": "Taxi",
	"U": "Umbrella",
	"V": "Violin",
	"W": "Watch",
	"X": "X-mark Box",
	"Y": "Yo-yo",
	"Z": "Zebra",
}
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
	var anchors_data: Dictionary = _load_json(ANCHORS_PATH)
	var cards_data: Dictionary = _load_json(CARDS_PATH)
	var anchors: Array = anchors_data.get("anchors", [])
	var cards: Array = cards_data.get("cards", [])

	_expect(anchors.size() == 26, "A-Z core anchors must contain 26 records")
	_expect(cards.size() == 26, "A-Z core cards must contain 26 records")
	_expect(anchors_data.get("first_batch_letters", []) == FIRST_BATCH_LETTERS, "first batch letters must match baseline")

	var cards_by_id: Dictionary = {}
	var anchors_by_id: Dictionary = {}
	for card in cards:
		_validate_card(card, cards_by_id)
	for anchor in anchors:
		_validate_anchor(anchor, anchors_by_id, cards_by_id)
	for card in cards:
		_expect(anchors_by_id.has(card.get("anchor_id", "")), "card must bind an existing anchor_id: %s" % card.get("card_id", ""))

	if failures.is_empty():
		print("HEADLESS TESTS PASSED: A-Z core anchor and card data")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


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


func _validate_anchor(anchor: Dictionary, anchors_by_id: Dictionary, cards_by_id: Dictionary) -> void:
	var anchor_id: String = anchor.get("anchor_id", "")
	var letter: String = anchor.get("letter", "")
	var route_order: int = int(anchor.get("route_order", 0))
	var expected_letter := LETTERS.substr(route_order - 1, 1) if route_order >= 1 and route_order <= 26 else ""
	var card_id: String = anchor.get("card_id", "")

	_expect(not anchor_id.is_empty(), "anchor_id is required")
	_expect(not anchors_by_id.has(anchor_id), "anchor_id must be unique: %s" % anchor_id)
	anchors_by_id[anchor_id] = anchor
	_expect(CORE_WORD_BY_LETTER.has(letter), "anchor letter must be A-Z: %s" % anchor_id)
	_expect(route_order >= 1 and route_order <= 26, "route_order must be 1-26: %s" % anchor_id)
	_expect(letter == expected_letter, "route_order must match A-Z order: %s" % anchor_id)
	_expect(anchor.get("core_word", "") == CORE_WORD_BY_LETTER.get(letter, ""), "core_word must match fixed encoding: %s" % anchor_id)
	_expect(not card_id.is_empty(), "anchor must include card_id: %s" % anchor_id)
	_expect(cards_by_id.has(card_id), "anchor card_id must exist in core cards: %s" % anchor_id)

	if FIRST_BATCH_LETTERS.has(letter):
		_expect(anchor.get("enabled", false), "first batch anchor must be enabled: %s" % letter)
		_expect(anchor.get("phase", "") == "first_batch", "first batch anchor must use phase=first_batch: %s" % letter)
	else:
		_expect(not anchor.get("enabled", true), "reserved anchor must not be enabled yet: %s" % letter)
		_expect(anchor.get("phase", "") == "reserved", "reserved anchor must use phase=reserved: %s" % letter)


func _validate_card(card: Dictionary, cards_by_id: Dictionary) -> void:
	var card_id: String = card.get("card_id", "")
	var letter: String = card.get("letter", "")

	_expect(not card_id.is_empty(), "card_id is required")
	_expect(not cards_by_id.has(card_id), "card_id must be unique: %s" % card_id)
	cards_by_id[card_id] = card
	_expect(str(card.get("word", "")).length() > 0, "card word is required: %s" % card_id)
	_expect(CORE_WORD_BY_LETTER.has(letter), "card letter must be A-Z: %s" % card_id)
	_expect(str(card.get("anchor_id", "")).length() > 0, "card anchor_id is required: %s" % card_id)
	_expect(str(card.get("story_memory", "")).length() > 0, "card story_memory is required: %s" % card_id)
	_expect(str(card.get("source", "")).length() > 0, "card source is required: %s" % card_id)

	var collection_state: Dictionary = card.get("collection_state", {})
	for key in INITIAL_COLLECTION_STATE.keys():
		_expect(collection_state.has(key), "card collection_state missing %s: %s" % [key, card_id])
		_expect(collection_state.get(key) == INITIAL_COLLECTION_STATE[key], "card collection_state initial %s mismatch: %s" % [key, card_id])


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
