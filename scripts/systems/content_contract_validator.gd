extends RefCounted
class_name ContentContractValidator

const DAILY_REQUESTS_PATH := "res://data/life/daily_requests.json"
const DAILY_GREETINGS_PATH := "res://data/life/daily_greetings.json"
const ITEMS_PATH := "res://data/items/life_items.json"
const CORE_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const NEW_WORD_STORIES_PATH := "res://data/anchors/new_word_revisit_paths.json"

const PRESSURE_TERMS := ["test", "quiz", "exam", "score", "drill", "lesson", "homework", "考试", "测验", "分数", "作业"]
const STORY_FIELDS := ["letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]


func validate_all() -> Dictionary:
	var errors: Array[String] = []
	var warnings: Array[String] = []
	_validate_daily_requests(errors)
	_validate_daily_greetings(errors)
	_validate_items(errors)
	_validate_anchor_content(errors, warnings)
	return {
		"ok": errors.is_empty(),
		"errors": errors,
		"warnings": warnings,
	}


func validate_candidate_content_pack(candidate: Dictionary) -> Dictionary:
	var errors: Array[String] = []
	var warnings: Array[String] = []
	var core_anchor_ids: Dictionary = _core_anchor_ids()
	for anchor in candidate.get("anchors", []):
		if anchor is Dictionary:
			var anchor_data: Dictionary = anchor
			var anchor_id := str(anchor_data.get("anchor_id", ""))
			if core_anchor_ids.has(anchor_id):
				errors.append("content pack must not override core A-Z anchor: %s" % anchor_id)
	for story in candidate.get("new_word_stories", []):
		if story is Dictionary:
			_validate_story_fields(story, "candidate story", errors)
		else:
			errors.append("candidate new_word_stories entry must be object")
	return {"ok": errors.is_empty(), "errors": errors, "warnings": warnings}


func _validate_daily_requests(errors: Array[String]) -> void:
	var data: Dictionary = _load_json(DAILY_REQUESTS_PATH, errors)
	var seen_ids: Dictionary = {}
	for request_value in data.get("requests", []):
		if not request_value is Dictionary:
			errors.append("daily request entry must be object")
			continue
		var request: Dictionary = request_value
		var request_id := str(request.get("request_id", ""))
		_require_id(request_id, seen_ids, "daily request", errors)
		if str(request.get("npc_id", "")).is_empty():
			errors.append("daily request missing npc_id: %s" % request_id)
		if request.get("required_items", []).is_empty():
			errors.append("daily request missing required_items: %s" % request_id)
		var rewards: Dictionary = request.get("rewards", {})
		if int(rewards.get("coins", 0)) < 0:
			errors.append("daily request has negative coin reward: %s" % request_id)
		for reward_item in rewards.get("items", []):
			if not reward_item is Dictionary or str((reward_item as Dictionary).get("item_id", "")).is_empty():
				errors.append("daily request reward item missing item_id: %s" % request_id)
		_validate_child_safe_dict(request.get("text", {}), "daily request text %s" % request_id, errors)
		_validate_story_fields(request.get("memory_story", {}), "daily request %s" % request_id, errors)


func _validate_daily_greetings(errors: Array[String]) -> void:
	var data: Dictionary = _load_json(DAILY_GREETINGS_PATH, errors)
	var seen_npcs: Dictionary = {}
	for greeting_value in data.get("greetings", []):
		if not greeting_value is Dictionary:
			errors.append("daily greeting entry must be object")
			continue
		var greeting: Dictionary = greeting_value
		var npc_id := str(greeting.get("npc_id", ""))
		_require_id(npc_id, seen_npcs, "daily greeting npc", errors)
		if str(greeting.get("first_text", "")).is_empty():
			errors.append("daily greeting missing first_text: %s" % npc_id)
		if str(greeting.get("repeat_text", "")).is_empty():
			errors.append("daily greeting missing repeat_text: %s" % npc_id)
		_validate_child_safe_dict(greeting, "daily greeting %s" % npc_id, errors)


func _validate_items(errors: Array[String]) -> void:
	var data: Dictionary = _load_json(ITEMS_PATH, errors)
	var seen_ids: Dictionary = {}
	for item_value in data.get("items", []):
		if not item_value is Dictionary:
			errors.append("life item entry must be object")
			continue
		var item: Dictionary = item_value
		var item_id := str(item.get("item_id", ""))
		_require_id(item_id, seen_ids, "life item", errors)
		if str(item.get("item_type", "")).is_empty():
			errors.append("life item missing item_type: %s" % item_id)
		_validate_story_fields(item.get("memory_story", {}), "life item %s" % item_id, errors)
		if str(item.get("item_type", "")) == "furniture":
			if int(item.get("price", -1)) < 0:
				errors.append("furniture has invalid price: %s" % item_id)
			if str(item.get("shop_id", "")).is_empty():
				errors.append("furniture missing shop_id: %s" % item_id)
			if str(item.get("furniture_category", "")).is_empty():
				errors.append("furniture missing furniture_category: %s" % item_id)
			var size: Dictionary = item.get("home_size", {})
			if int(size.get("w", 0)) < 1 or int(size.get("h", 0)) < 1:
				errors.append("furniture missing valid home_size: %s" % item_id)


func _validate_anchor_content(errors: Array[String], warnings: Array[String]) -> void:
	var core_data: Dictionary = _load_json(CORE_ANCHORS_PATH, errors)
	var core_ids: Dictionary = {}
	for anchor_value in core_data.get("anchors", []):
		if anchor_value is Dictionary:
			var anchor: Dictionary = anchor_value
			var anchor_id := str(anchor.get("anchor_id", ""))
			if core_ids.has(anchor_id):
				errors.append("duplicate core anchor id: %s" % anchor_id)
			core_ids[anchor_id] = true
	if core_ids.size() != 26:
		errors.append("core anchor content must preserve 26 A-Z anchors")

	var stories_data: Dictionary = _load_json(NEW_WORD_STORIES_PATH, errors)
	var seen_story_ids: Dictionary = {}
	for story_value in stories_data.get("stories", []):
		if not story_value is Dictionary:
			errors.append("new-word story entry must be object")
			continue
		var story: Dictionary = story_value
		_require_id(str(story.get("story_id", "")), seen_story_ids, "new-word story", errors)
		_validate_story_fields(story, "new-word story %s" % str(story.get("story_id", "")), errors)
		if not core_ids.has(str(story.get("core_anchor_id", ""))):
			errors.append("new-word story binds unknown core anchor: %s" % str(story.get("story_id", "")))
	if stories_data.get("stories", []).is_empty():
		warnings.append("new-word revisit story data is empty")


func _validate_story_fields(value: Variant, label: String, errors: Array[String]) -> void:
	if not value is Dictionary:
		errors.append("%s missing memory story object" % label)
		return
	var story: Dictionary = value
	for field in STORY_FIELDS:
		if str(story.get(field, "")).is_empty():
			errors.append("%s missing %s" % [label, field])


func _validate_child_safe_dict(value: Variant, label: String, errors: Array[String]) -> void:
	if value is Dictionary:
		var dict: Dictionary = value
		for key in dict.keys():
			_validate_child_safe_dict(dict[key], "%s.%s" % [label, str(key)], errors)
	elif value is Array:
		for item in value:
			_validate_child_safe_dict(item, label, errors)
	else:
		var text := str(value).to_lower()
		for term in PRESSURE_TERMS:
			if text.contains(str(term).to_lower()):
				errors.append("%s contains pressure term: %s" % [label, term])


func _require_id(id_value: String, seen_ids: Dictionary, label: String, errors: Array[String]) -> void:
	if id_value.is_empty():
		errors.append("%s missing stable id" % label)
		return
	if seen_ids.has(id_value):
		errors.append("duplicate %s id: %s" % [label, id_value])
	seen_ids[id_value] = true


func _core_anchor_ids() -> Dictionary:
	var errors: Array[String] = []
	var data: Dictionary = _load_json(CORE_ANCHORS_PATH, errors)
	var ids: Dictionary = {}
	for anchor_value in data.get("anchors", []):
		if anchor_value is Dictionary:
			var anchor: Dictionary = anchor_value
			ids[str(anchor.get("anchor_id", ""))] = true
	return ids


func _load_json(path: String, errors: Array[String]) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("unable to open JSON: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		errors.append("JSON root must be object: %s" % path)
		return {}
	return parsed
