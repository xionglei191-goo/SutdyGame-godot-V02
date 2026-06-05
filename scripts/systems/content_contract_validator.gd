extends RefCounted
class_name ContentContractValidator

const DAILY_REQUESTS_PATH := "res://data/life/daily_requests.json"
const DAILY_GREETINGS_PATH := "res://data/life/daily_greetings.json"
const TODAY_STATUS_PATH := "res://data/life/today_status.json"
const SCHOOL_DAY_STATES_PATH := "res://data/life/school_day_states.json"
const WEATHER_EVENTS_PATH := "res://data/life/weather_events.json"
const RESOURCE_POINTS_PATH := "res://data/life/resource_points.json"
const ITEMS_PATH := "res://data/items/life_items.json"
const CORE_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const NEW_WORD_STORIES_PATH := "res://data/anchors/new_word_revisit_paths.json"

const PRESSURE_TERMS := ["test", "quiz", "exam", "score", "drill", "lesson", "homework", "countdown", "ranking", "考试", "测验", "分数", "作业", "倒计时", "剩余", "错过", "补签", "连续", "必须", "失败", "奖励翻倍", "排名"]
const STORY_FIELDS := ["letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]
const ROTATION_TIERS := ["P0", "P1", "P2"]
const WEATHER_TAGS := ["sunny", "breezy", "after_rain", "light_rain"]
const SCHOOL_DAY_STAGES := ["home_school_walk", "school_gate", "school_yard", "return_home"]
const REQUIRED_P0_WEATHER_EVENTS := [
	"event_weather_sunny_soft_001",
	"event_weather_breezy_kite_001",
	"event_weather_after_rain_001",
	"event_weather_light_rain_001",
]


func validate_all() -> Dictionary:
	var errors: Array[String] = []
	var warnings: Array[String] = []
	_validate_daily_requests(errors)
	var greeting_variant_ids: Dictionary = _validate_daily_greetings(errors)
	var weather_event_ids: Dictionary = _validate_weather_events(errors, greeting_variant_ids)
	_validate_today_status(errors, weather_event_ids)
	_validate_school_day_states(errors)
	_validate_resource_points(errors, weather_event_ids)
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
		if request.get("required_items", []).is_empty() and request.get("required_p1_entries", []).is_empty():
			errors.append("daily request missing requirements: %s" % request_id)
		var rewards: Dictionary = request.get("rewards", {})
		if int(rewards.get("coins", 0)) < 0:
			errors.append("daily request has negative coin reward: %s" % request_id)
		for reward_item in rewards.get("items", []):
			if not reward_item is Dictionary or str((reward_item as Dictionary).get("item_id", "")).is_empty():
				errors.append("daily request reward item missing item_id: %s" % request_id)
		_validate_child_safe_dict(request.get("text", {}), "daily request text %s" % request_id, errors)
		_validate_story_fields(request.get("memory_story", {}), "daily request %s" % request_id, errors)


func _validate_daily_greetings(errors: Array[String]) -> Dictionary:
	var data: Dictionary = _load_json(DAILY_GREETINGS_PATH, errors)
	var seen_npcs: Dictionary = {}
	var seen_variants: Dictionary = {}
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
		var weather_variants: Dictionary = greeting.get("weather_variants", {})
		for event_id in weather_variants.keys():
			var variant_value: Variant = weather_variants.get(event_id, {})
			if not variant_value is Dictionary:
				errors.append("daily greeting weather variant must be object: %s" % npc_id)
				continue
			var variant: Dictionary = variant_value
			var variant_id := str(variant.get("variant_id", ""))
			_require_id(variant_id, seen_variants, "daily greeting weather variant", errors)
			if str(variant.get("first_text", "")).is_empty():
				errors.append("daily greeting weather variant missing first_text: %s" % variant_id)
			if str(variant.get("repeat_text", "")).is_empty():
				errors.append("daily greeting weather variant missing repeat_text: %s" % variant_id)
		_validate_child_safe_dict(greeting, "daily greeting %s" % npc_id, errors)
	return seen_variants


func _validate_weather_events(errors: Array[String], greeting_variant_ids: Dictionary) -> Dictionary:
	var data: Dictionary = _load_json(WEATHER_EVENTS_PATH, errors)
	var seen_ids: Dictionary = {}
	var seen_required: Dictionary = {}
	for event_value in data.get("events", []):
		if not event_value is Dictionary:
			errors.append("weather event entry must be object")
			continue
		var event: Dictionary = event_value
		var event_id := str(event.get("event_id", ""))
		_require_id(event_id, seen_ids, "weather event", errors)
		if REQUIRED_P0_WEATHER_EVENTS.has(event_id):
			seen_required[event_id] = true
		if str(event.get("priority", "")) != "P0":
			errors.append("weather event must be P0 in V02-WEATHER-001: %s" % event_id)
		if not WEATHER_TAGS.has(str(event.get("weather_tag", ""))):
			errors.append("weather event has invalid weather_tag: %s" % event_id)
		if event.get("day_keys", []).is_empty():
			errors.append("weather event missing day_keys: %s" % event_id)
		if str(event.get("today_status_text", "")).is_empty():
			errors.append("weather event missing today_status_text: %s" % event_id)
		if str(event.get("resource_effect", "")).is_empty():
			errors.append("weather event missing resource_effect: %s" % event_id)
		if str(event.get("shop_rotation_hint", "")).is_empty():
			errors.append("weather event missing shop_rotation_hint: %s" % event_id)
		if event.get("anchor_hints", []).is_empty():
			errors.append("weather event missing anchor_hints: %s" % event_id)
		if event.get("album_clues", []).is_empty():
			errors.append("weather event missing album_clues: %s" % event_id)
		if str(event.get("child_safety_note", "")).is_empty():
			errors.append("weather event missing child_safety_note: %s" % event_id)
		var anchor_hints: Dictionary = {}
		for anchor_hint in event.get("anchor_hints", []):
			anchor_hints[str(anchor_hint)] = true
		for clue_value in event.get("album_clues", []):
			if not clue_value is Dictionary:
				errors.append("weather album clue must be object: %s" % event_id)
				continue
			var clue: Dictionary = clue_value
			var clue_anchor_id := str(clue.get("anchor_id", ""))
			if not anchor_hints.has(clue_anchor_id):
				errors.append("weather album clue anchor must appear in anchor_hints: %s" % event_id)
			if str(clue.get("card_id", "")).is_empty():
				errors.append("weather album clue missing card_id: %s" % event_id)
			if str(clue.get("album_tag", "")).is_empty():
				errors.append("weather album clue missing album_tag: %s" % event_id)
			if str(clue.get("story_memory", "")).is_empty():
				errors.append("weather album clue missing story_memory: %s" % event_id)
			if str(clue.get("environment_word", "")).is_empty():
				errors.append("weather album clue missing environment_word: %s" % event_id)
			_validate_child_safe_dict(clue, "weather album clue %s" % event_id, errors)
		for greeting_ref in event.get("npc_greeting_refs", []):
			if not greeting_variant_ids.has(str(greeting_ref)):
				errors.append("weather event references unknown greeting variant: %s" % str(greeting_ref))
		_validate_child_safe_dict(event, "weather event %s" % event_id, errors)
	for required_id in REQUIRED_P0_WEATHER_EVENTS:
		if not seen_required.has(required_id):
			errors.append("missing required P0 weather event: %s" % required_id)
	return seen_ids


func _validate_today_status(errors: Array[String], weather_event_ids: Dictionary) -> void:
	var data: Dictionary = _load_json(TODAY_STATUS_PATH, errors)
	var seen_day_keys: Dictionary = {}
	var seen_rotations: Dictionary = {}
	var seen_weather_events: Dictionary = {}
	for status_value in data.get("statuses", []):
		if not status_value is Dictionary:
			errors.append("today status entry must be object")
			continue
		var status: Dictionary = status_value
		var day_key := str(status.get("day_key", ""))
		_require_id(day_key, seen_day_keys, "today status day_key", errors)
		if str(status.get("weather", "")).is_empty():
			errors.append("today status missing weather: %s" % day_key)
		var weather_event_id := str(status.get("weather_event_id", ""))
		if weather_event_id.is_empty():
			errors.append("today status missing weather_event_id: %s" % day_key)
		elif not weather_event_ids.has(weather_event_id):
			errors.append("today status references unknown weather event: %s" % weather_event_id)
		else:
			seen_weather_events[weather_event_id] = true
		if str(status.get("event", "")).is_empty():
			errors.append("today status missing event: %s" % day_key)
		if str(status.get("sunny_hint", "")).is_empty():
			errors.append("today status missing sunny_hint: %s" % day_key)
		if str(status.get("primary_npc", "")).is_empty():
			errors.append("today status missing primary_npc: %s" % day_key)
		if str(status.get("anchor_hint", "")).is_empty():
			errors.append("today status missing anchor_hint: %s" % day_key)
		var rotation_id := str(status.get("shop_rotation_id", ""))
		if rotation_id.is_empty():
			errors.append("today status missing shop_rotation_id: %s" % day_key)
		else:
			seen_rotations[rotation_id] = true
		_validate_child_safe_dict(status, "today status %s" % day_key, errors)
	if seen_day_keys.size() < 7:
		errors.append("today status must include at least 7 local day entries")
	for required_id in REQUIRED_P0_WEATHER_EVENTS:
		if not seen_weather_events.has(required_id):
			errors.append("today status must reference required P0 weather event: %s" % required_id)


func _validate_school_day_states(errors: Array[String]) -> void:
	var data: Dictionary = _load_json(SCHOOL_DAY_STATES_PATH, errors)
	var seen_day_keys: Dictionary = {}
	var seen_event_ids: Dictionary = {}
	var core_anchor_ids: Dictionary = _core_anchor_ids()
	for state_value in data.get("states", []):
		if not state_value is Dictionary:
			errors.append("school day state entry must be object")
			continue
		var state: Dictionary = state_value
		var day_key := str(state.get("day_key", ""))
		_require_id(day_key, seen_day_keys, "school day state day_key", errors)
		if str(state.get("theme", "")).is_empty():
			errors.append("school day state missing theme: %s" % day_key)
		var entries: Dictionary = state.get("entries", {})
		for stage in SCHOOL_DAY_STAGES:
			if not entries.has(stage):
				errors.append("school day state missing stage %s for %s" % [stage, day_key])
				continue
			var entry_value: Variant = entries.get(stage, {})
			if not entry_value is Dictionary:
				errors.append("school day state stage must be object: %s %s" % [day_key, stage])
				continue
			var entry: Dictionary = entry_value
			var event_id := str(entry.get("event_id", ""))
			_require_id(event_id, seen_event_ids, "school day event", errors)
			if str(entry.get("stage", "")) != stage:
				errors.append("school day entry stage mismatch: %s %s" % [day_key, event_id])
			if str(entry.get("place_id", "")).is_empty():
				errors.append("school day entry missing place_id: %s" % event_id)
			if str(entry.get("child_facing_text", "")).is_empty():
				errors.append("school day entry missing child_facing_text: %s" % event_id)
			if str(entry.get("safety_note", "")).is_empty():
				errors.append("school day entry missing safety_note: %s" % event_id)
			if entry.get("anchor_ids", []).is_empty():
				errors.append("school day entry missing anchor_ids: %s" % event_id)
			for anchor_id_value in entry.get("anchor_ids", []):
				var anchor_id := str(anchor_id_value)
				if not core_anchor_ids.has(anchor_id):
					errors.append("school day entry references unknown anchor: %s %s" % [event_id, anchor_id])
			if entry.get("environment_words", []).is_empty():
				errors.append("school day entry missing environment_words: %s" % event_id)
			_validate_child_safe_dict(entry, "school day entry %s" % event_id, errors)
	if seen_day_keys.size() < 7:
		errors.append("school day states must include at least 7 local day entries")


func _validate_resource_points(errors: Array[String], weather_event_ids: Dictionary) -> void:
	var data: Dictionary = _load_json(RESOURCE_POINTS_PATH, errors)
	var seen_ids: Dictionary = {}
	for point_value in data.get("resource_points", []):
		if not point_value is Dictionary:
			errors.append("resource point entry must be object")
			continue
		var point: Dictionary = point_value
		var point_id := str(point.get("point_id", ""))
		_require_id(point_id, seen_ids, "resource point", errors)
		if str(point.get("item_id", "")).is_empty():
			errors.append("resource point missing item_id: %s" % point_id)
		if int(point.get("quantity", 0)) < 1:
			errors.append("resource point quantity must stay available: %s" % point_id)
		var weather_hints: Dictionary = point.get("weather_hints", {})
		for event_id in weather_hints.keys():
			if not weather_event_ids.has(str(event_id)):
				errors.append("resource point references unknown weather event: %s" % str(event_id))
		_validate_child_safe_dict(point, "resource point %s" % point_id, errors)


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
	_validate_shop_rotations(data, seen_ids, errors)


func _validate_shop_rotations(data: Dictionary, seen_item_ids: Dictionary, errors: Array[String]) -> void:
	var seen_rotation_ids: Dictionary = {}
	var seen_day_keys: Dictionary = {}
	var weather_event_ids: Dictionary = _weather_event_ids()
	for rotation_value in data.get("shop_rotations", []):
		if not rotation_value is Dictionary:
			errors.append("shop rotation entry must be object")
			continue
		var rotation: Dictionary = rotation_value
		var rotation_id := str(rotation.get("rotation_id", ""))
		_require_id(rotation_id, seen_rotation_ids, "shop rotation", errors)
		var day_key := str(rotation.get("day_key", ""))
		_require_id(day_key, seen_day_keys, "shop rotation day_key", errors)
		if str(rotation.get("theme", "")).is_empty():
			errors.append("shop rotation missing theme: %s" % rotation_id)
		var activity_corner: Dictionary = rotation.get("weather_activity_corner", {})
		if activity_corner.is_empty():
			errors.append("shop rotation missing weather activity corner: %s" % rotation_id)
		else:
			var corner_event_id := str(activity_corner.get("weather_event_id", ""))
			if not weather_event_ids.has(corner_event_id):
				errors.append("shop rotation activity corner references unknown weather event: %s" % corner_event_id)
			if str(activity_corner.get("text", "")).is_empty():
				errors.append("shop rotation activity corner missing text: %s" % rotation_id)
			_validate_child_safe_dict(activity_corner, "shop rotation activity corner %s" % rotation_id, errors)
		var has_p0 := false
		var has_wooden_chair := false
		for offer_value in rotation.get("offers", []):
			if not offer_value is Dictionary:
				errors.append("shop rotation offer must be object: %s" % rotation_id)
				continue
			var offer: Dictionary = offer_value
			var item_id := str(offer.get("item_id", ""))
			if not seen_item_ids.has(item_id):
				errors.append("shop rotation references unknown item: %s" % item_id)
			var tier := str(offer.get("rotation_tier", ""))
			if not ROTATION_TIERS.has(tier):
				errors.append("shop rotation offer has invalid tier: %s" % item_id)
			if tier == "P0":
				has_p0 = true
			if item_id == "wooden_chair":
				has_wooden_chair = true
			if str(offer.get("slot", "")).is_empty():
				errors.append("shop rotation offer missing slot: %s" % item_id)
			_validate_child_safe_dict(offer, "shop rotation offer %s" % item_id, errors)
		if not has_p0:
			errors.append("shop rotation must include at least one P0 offer: %s" % rotation_id)
		if not has_wooden_chair:
			errors.append("shop rotation must keep wooden_chair P0 anchor offer: %s" % rotation_id)
	if seen_day_keys.size() < 7:
		errors.append("shop rotations must include at least 7 local day entries")


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


func _weather_event_ids() -> Dictionary:
	var errors: Array[String] = []
	var data: Dictionary = _load_json(WEATHER_EVENTS_PATH, errors)
	var ids: Dictionary = {}
	for event_value in data.get("events", []):
		if event_value is Dictionary:
			var event: Dictionary = event_value
			ids[str(event.get("event_id", ""))] = true
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
