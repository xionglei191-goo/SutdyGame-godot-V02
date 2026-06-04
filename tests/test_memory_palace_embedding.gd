extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")

const ITEM_CATALOG_PATH := "res://data/items/life_items.json"
const LETTERS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const FIRST_BATCH_LETTERS: Array[String] = ["A", "B", "C", "D", "K", "O", "S", "T", "W"]
const REQUIRED_STORY_FIELDS: Array[String] = [
	"letter",
	"core_anchor_id",
	"world_place_id",
	"story_memory",
	"visual_hook",
	"review_path",
]

var failures: Array[String] = []


func _init() -> void:
	_check_world_anchor_embedding()
	_check_new_word_story_bindings()
	_finish()


func _check_world_anchor_embedding() -> void:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "world map should validate before memory palace audit: %s" % [result.get("errors", [])])
	var data: Dictionary = result.get("data", {})
	var anchors: Array = data.get("memory_anchors", [])
	_expect(anchors.size() == 26, "world map must contain 26 memory palace anchors")

	var seen_letters: Dictionary = {}
	var seen_orders: Dictionary = {}
	for anchor in anchors:
		var letter := str(anchor.get("letter", ""))
		var route_order := int(anchor.get("route_order", 0))
		var expected_letter := LETTERS.substr(route_order - 1, 1) if route_order >= 1 and route_order <= 26 else ""
		_expect(letter == expected_letter, "anchor route order should match A-Z: %s" % anchor.get("anchor_id", ""))
		_expect(not seen_letters.has(letter), "anchor letter should be unique: %s" % letter)
		_expect(not seen_orders.has(route_order), "anchor route order should be unique: %s" % route_order)
		_expect(str(anchor.get("place_id", "")).begins_with("place_"), "anchor should bind a world place: %s" % anchor.get("anchor_id", ""))
		_expect(anchor.get("position", {}) is Dictionary, "anchor should keep map position: %s" % anchor.get("anchor_id", ""))
		_expect(not str(anchor.get("card_id", "")).is_empty(), "anchor should bind core card: %s" % anchor.get("anchor_id", ""))
		seen_letters[letter] = true
		seen_orders[route_order] = true

	for first_letter in FIRST_BATCH_LETTERS:
		var first_anchor: Dictionary = _anchor_by_letter(anchors, first_letter)
		_expect(first_anchor.get("unlock_rule", "") == "default_unlocked", "first batch anchor should be unlocked: %s" % first_letter)


func _check_new_word_story_bindings() -> void:
	var catalog: Dictionary = _load_json(ITEM_CATALOG_PATH)
	for item in catalog.get("items", []):
		if not item is Dictionary:
			failures.append("item catalog entry must be a dictionary")
			continue
		var item_id := str(item.get("item_id", ""))
		var story: Dictionary = item.get("memory_story", {})
		for field in REQUIRED_STORY_FIELDS:
			_expect(story.has(field), "item memory_story missing %s: %s" % [field, item_id])
			_expect(not str(story.get(field, "")).is_empty(), "item memory_story field should not be empty %s: %s" % [field, item_id])
		_expect(str(story.get("core_anchor_id", "")).begins_with("anchor_"), "item should bind core anchor id: %s" % item_id)
		_expect(str(story.get("world_place_id", "")).begins_with("place_"), "item should bind world place id: %s" % item_id)


func _anchor_by_letter(anchors: Array, letter: String) -> Dictionary:
	for anchor in anchors:
		if anchor is Dictionary and anchor.get("letter", "") == letter:
			return anchor
	return {}


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		failures.append("Cannot open JSON: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		failures.append("JSON root must be dictionary: %s" % path)
		return {}
	return parsed


func _finish() -> void:
	if failures.is_empty():
		print("MEMORY PALACE EMBEDDING TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
