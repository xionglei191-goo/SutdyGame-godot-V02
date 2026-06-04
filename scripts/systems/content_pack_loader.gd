extends RefCounted
class_name ContentPackLoader

const CORE_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const WORLD_MAP_PATH := "res://data/maps/world_map.json"
const REQUIRED_WORD_FIELDS: Array[String] = [
	"letter",
	"core_anchor_id",
	"world_place_id",
	"story_memory",
	"visual_hook",
	"review_path",
]

var installed_packs: Dictionary = {}
var installed_words: Dictionary = {}
var install_snapshots: Dictionary = {}


func validate_pack(pack: Dictionary) -> Dictionary:
	var errors: Array[String] = []
	var pack_id := str(pack.get("pack_id", ""))
	if pack_id.is_empty():
		errors.append("Content pack requires pack_id.")

	var core_anchors := _core_anchors_by_id()
	var world_places := _world_place_ids()
	var anchor_payload: Array = _array_from(pack, "anchors", "memory_anchors")
	for anchor in anchor_payload:
		if not anchor is Dictionary:
			errors.append("Content pack anchors must be dictionaries.")
			continue
		var anchor_data: Dictionary = anchor
		var anchor_id := str(anchor_data.get("anchor_id", ""))
		if core_anchors.has(anchor_id):
			errors.append("Content pack cannot override core A-Z anchor: %s" % anchor_id)
		if bool(anchor_data.get("core", false)):
			errors.append("Content pack cannot declare new core A-Z anchors: %s" % anchor_id)

	var word_payload: Array = _array_from(pack, "new_words", "words")
	if word_payload.is_empty():
		errors.append("Content pack requires at least one new word.")

	var seen_word_ids: Array[String] = []
	for word in word_payload:
		if not word is Dictionary:
			errors.append("Content pack words must be dictionaries.")
			continue
		_validate_word(word, core_anchors, world_places, seen_word_ids, errors)

	return {
		"ok": errors.is_empty(),
		"errors": errors,
		"pack_id": pack_id,
		"word_count": word_payload.size(),
	}


func install_pack(pack: Dictionary) -> Dictionary:
	var validation: Dictionary = validate_pack(pack)
	if not validation.get("ok", false):
		return {
			"ok": false,
			"errors": validation.get("errors", []),
			"installed": false,
			"pack_id": validation.get("pack_id", ""),
		}

	var pack_id := str(validation.get("pack_id", ""))
	install_snapshots[pack_id] = {
		"pack": installed_packs.get(pack_id, {}).duplicate(true),
		"words": installed_words.duplicate(true),
		"was_installed": installed_packs.has(pack_id),
	}
	installed_packs[pack_id] = pack.duplicate(true)
	for word in _array_from(pack, "new_words", "words"):
		var word_data: Dictionary = word
		installed_words[str(word_data.get("word_id", word_data.get("word", "")))] = word_data.duplicate(true)

	return {
		"ok": true,
		"errors": [],
		"installed": true,
		"pack_id": pack_id,
		"word_count": int(validation.get("word_count", 0)),
	}


func rollback_pack(pack_id: String) -> Dictionary:
	if not install_snapshots.has(pack_id):
		return {"ok": false, "errors": ["No rollback snapshot for content pack: %s" % pack_id], "pack_id": pack_id}

	var snapshot: Dictionary = install_snapshots[pack_id]
	installed_words = snapshot.get("words", {}).duplicate(true)
	if bool(snapshot.get("was_installed", false)):
		installed_packs[pack_id] = snapshot.get("pack", {}).duplicate(true)
	else:
		installed_packs.erase(pack_id)
	install_snapshots.erase(pack_id)
	return {"ok": true, "errors": [], "rolled_back": true, "pack_id": pack_id}


func get_installed_word(word_id: String) -> Dictionary:
	return installed_words.get(word_id, {}).duplicate(true)


func is_pack_installed(pack_id: String) -> bool:
	return installed_packs.has(pack_id)


func _validate_word(word: Dictionary, core_anchors: Dictionary, world_places: Array[String], seen_word_ids: Array[String], errors: Array[String]) -> void:
	var word_id := str(word.get("word_id", word.get("word", "")))
	if word_id.is_empty():
		errors.append("New word requires word_id or word.")
	elif seen_word_ids.has(word_id):
		errors.append("New word id must be unique in pack: %s" % word_id)
	else:
		seen_word_ids.append(word_id)

	for field_name in REQUIRED_WORD_FIELDS:
		if str(word.get(field_name, "")).is_empty():
			errors.append("New word %s requires %s." % [word_id, field_name])

	var anchor_id := str(word.get("core_anchor_id", ""))
	if not core_anchors.has(anchor_id):
		errors.append("New word %s references unknown core_anchor_id: %s" % [word_id, anchor_id])
	else:
		var anchor: Dictionary = core_anchors[anchor_id]
		var expected_letter := str(anchor.get("letter", ""))
		var actual_letter := str(word.get("letter", "")).to_upper()
		if not actual_letter.is_empty() and actual_letter != expected_letter:
			errors.append("New word %s letter must match core anchor %s." % [word_id, anchor_id])

	var place_id := str(word.get("world_place_id", ""))
	if not place_id.is_empty() and not world_places.has(place_id):
		errors.append("New word %s references unknown world_place_id: %s" % [word_id, place_id])


func _core_anchors_by_id() -> Dictionary:
	var data := _load_json(CORE_ANCHORS_PATH)
	var anchors: Dictionary = {}
	for anchor in data.get("anchors", []):
		if anchor is Dictionary:
			var anchor_data: Dictionary = anchor
			anchors[str(anchor_data.get("anchor_id", ""))] = anchor_data.duplicate(true)
	return anchors


func _world_place_ids() -> Array[String]:
	var data := _load_json(WORLD_MAP_PATH)
	var ids: Array[String] = []
	for place in data.get("places", []):
		if place is Dictionary:
			var place_data: Dictionary = place
			var place_id := str(place_data.get("place_id", ""))
			if not place_id.is_empty():
				ids.append(place_id)
	return ids


func _array_from(data: Dictionary, primary_key: String, fallback_key: String) -> Array:
	var value: Variant = data.get(primary_key, data.get(fallback_key, []))
	if value is Array:
		return value
	return []


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {}
	return parsed
