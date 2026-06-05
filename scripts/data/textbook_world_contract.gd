extends RefCounted
class_name TextbookWorldContract

const PLAN_PATH := "res://data/curriculum/textbook_world_plan.json"
const CORE_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const AZ_WORLD_PLAN_PATH := "res://data/maps/az_world_plan.json"

const REQUIRED_SOURCE_IDS: Array[String] = [
	"src_grade_3a",
	"src_grade_3b",
	"src_grade_4a",
	"src_grade_4b",
	"src_grade_5a",
	"src_grade_5b",
	"src_grade_6a",
	"src_grade_6b",
]
const REQUIRED_UNIT_COUNTS := {
	"src_grade_3a": 10,
	"src_grade_3b": 10,
	"src_grade_4a": 10,
	"src_grade_4b": 10,
	"src_grade_5a": 12,
	"src_grade_5b": 12,
	"src_grade_6a": 12,
	"src_grade_6b": 9,
}
const VALID_TIERS: Array[String] = ["P0", "P1", "P2"]
const P0_ALLOWED_RINGS: Array[String] = ["center", "first_ring"]
const PRESSURE_TERMS: Array[String] = [
	"lesson",
	"unit",
	"test",
	"quiz",
	"exam",
	"score",
	"word list",
	"homework",
	"rank",
	"countdown",
	"must",
	"课程",
	"单元",
	"测试",
	"测验",
	"考试",
	"背诵",
	"词表",
	"分数",
	"倒计时",
	"错过",
	"必须",
	"排名",
]


static func load_plan(path: String = PLAN_PATH) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "errors": ["Unable to open textbook world plan: %s" % path], "data": {}}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {"ok": false, "errors": ["Textbook world plan root must be a dictionary."], "data": {}}
	var data: Dictionary = parsed
	var errors := validate_plan(data)
	return {"ok": errors.is_empty(), "errors": errors, "data": data}


static func validate_plan(data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var anchor_lookup := _load_anchor_lookup(errors)
	var place_rings := _load_place_ring_lookup(errors)
	var source_ids := _validate_sources(data.get("textbook_sources", []), errors)
	var item_ids := _validate_curriculum_items(data.get("curriculum_items", []), source_ids, errors)
	_validate_world_mappings(data.get("world_mappings", []), item_ids, anchor_lookup, place_rings, errors)
	_validate_mainline_segments(data.get("mainline_segments", []), item_ids, anchor_lookup, place_rings, errors)
	return errors


static func _validate_sources(sources: Array, errors: Array[String]) -> Dictionary:
	var source_ids: Dictionary = {}
	if sources.size() != REQUIRED_SOURCE_IDS.size():
		errors.append("V02.13 textbook sources must cover 8 primary volumes.")
	for source in sources:
		if not source is Dictionary:
			errors.append("textbook source entry must be a dictionary.")
			continue
		var record: Dictionary = source
		var source_id := str(record.get("source_id", ""))
		_require_unique(source_id, source_ids, "textbook source", errors)
		if not REQUIRED_SOURCE_IDS.has(source_id):
			errors.append("unexpected textbook source_id: %s" % source_id)
		if int(record.get("unit_count", 0)) != int(REQUIRED_UNIT_COUNTS.get(source_id, -1)):
			errors.append("textbook source unit_count mismatch: %s" % source_id)
		if str(record.get("local_path", "")).is_empty():
			errors.append("textbook source missing local_path: %s" % source_id)
		if str(record.get("source_status", "")).is_empty():
			errors.append("textbook source missing source_status: %s" % source_id)
		if source_id == "src_grade_3a" and str(record.get("source_url", "")).is_empty():
			errors.append("Grade 3A web summary must keep source_url.")
		_validate_safe_text(record, "textbook source %s" % source_id, errors)
	for source_id in REQUIRED_SOURCE_IDS:
		if not source_ids.has(source_id):
			errors.append("missing textbook source: %s" % source_id)
	return source_ids


static func _validate_curriculum_items(items: Array, source_ids: Dictionary, errors: Array[String]) -> Dictionary:
	var item_ids: Dictionary = {}
	var counts_by_source: Dictionary = {}
	for item in items:
		if not item is Dictionary:
			errors.append("curriculum item entry must be a dictionary.")
			continue
		var record: Dictionary = item
		var item_id := str(record.get("item_id", ""))
		var source_id := str(record.get("source_id", ""))
		_require_unique(item_id, item_ids, "curriculum item", errors)
		if not source_ids.has(source_id):
			errors.append("curriculum item references unknown source: %s" % item_id)
		counts_by_source[source_id] = int(counts_by_source.get(source_id, 0)) + 1
		for field in ["title", "theme", "difficulty"]:
			if str(record.get(field, "")).is_empty():
				errors.append("curriculum item missing %s: %s" % [field, item_id])
		if int(record.get("unit_no", 0)) <= 0:
			errors.append("curriculum item unit_no must be positive: %s" % item_id)
		if record.get("keywords", []).is_empty():
			errors.append("curriculum item missing keywords: %s" % item_id)
		if record.get("sample_phrases", []).is_empty():
			errors.append("curriculum item missing sample_phrases: %s" % item_id)
		if record.get("life_scene_candidates", []).is_empty():
			errors.append("curriculum item missing life_scene_candidates: %s" % item_id)
	for source_id in REQUIRED_SOURCE_IDS:
		if int(counts_by_source.get(source_id, 0)) != int(REQUIRED_UNIT_COUNTS.get(source_id, 0)):
			errors.append("curriculum items must include one summary per unit for: %s" % source_id)
	return item_ids


static func _validate_world_mappings(mappings: Array, item_ids: Dictionary, anchor_lookup: Dictionary, place_rings: Dictionary, errors: Array[String]) -> void:
	var mapping_ids: Dictionary = {}
	var mapped_p0_items: Dictionary = {}
	for mapping in mappings:
		if not mapping is Dictionary:
			errors.append("world mapping entry must be a dictionary.")
			continue
		var record: Dictionary = mapping
		var mapping_id := str(record.get("mapping_id", ""))
		var item_id := str(record.get("item_id", ""))
		var anchor_id := str(record.get("anchor_id", ""))
		var place_id := str(record.get("world_place_id", ""))
		var tier := str(record.get("tier", ""))
		_require_unique(mapping_id, mapping_ids, "world mapping", errors)
		if not item_ids.has(item_id):
			errors.append("world mapping references unknown item: %s" % mapping_id)
		if not anchor_lookup.has(anchor_id):
			errors.append("world mapping references unknown anchor: %s" % mapping_id)
		if not place_rings.has(place_id):
			errors.append("world mapping references unknown world_place_id: %s" % mapping_id)
		if not VALID_TIERS.has(tier):
			errors.append("world mapping has invalid tier: %s" % mapping_id)
		for field in ["npc_id", "story_memory", "visual_hook", "review_path", "child_facing_line"]:
			if str(record.get(field, "")).is_empty():
				errors.append("world mapping missing %s: %s" % [field, mapping_id])
		if tier == "P0":
			mapped_p0_items[item_id] = true
			if not P0_ALLOWED_RINGS.has(str(place_rings.get(place_id, ""))):
				errors.append("P0 world mapping must stay in center or first ring: %s" % mapping_id)
			if ["anchor_x_x_mark_box", "anchor_z_zebra"].has(anchor_id):
				errors.append("P0 world mapping must not use far edge anchor: %s" % mapping_id)
		_validate_safe_text(record, "world mapping %s" % mapping_id, errors)
	if mapped_p0_items.size() < 12:
		errors.append("V02.13 should map at least 12 P0 Home / School foundation items.")


static func _validate_mainline_segments(segments: Array, item_ids: Dictionary, anchor_lookup: Dictionary, place_rings: Dictionary, errors: Array[String]) -> void:
	var segment_ids: Dictionary = {}
	var has_p0 := false
	var has_p1 := false
	var has_p2 := false
	for segment in segments:
		if not segment is Dictionary:
			errors.append("mainline segment entry must be a dictionary.")
			continue
		var record: Dictionary = segment
		var segment_id := str(record.get("segment_id", ""))
		var tier := str(record.get("tier", ""))
		_require_unique(segment_id, segment_ids, "mainline segment", errors)
		if tier == "P0":
			has_p0 = true
		elif tier == "P1":
			has_p1 = true
		elif tier == "P2":
			has_p2 = true
		else:
			errors.append("mainline segment has invalid tier: %s" % segment_id)
		if record.get("item_ids", []).is_empty():
			errors.append("mainline segment missing item_ids: %s" % segment_id)
		for item_id in record.get("item_ids", []):
			if not item_ids.has(str(item_id)):
				errors.append("mainline segment references unknown item: %s" % segment_id)
		for anchor_id in record.get("anchor_ids", []):
			if not anchor_lookup.has(str(anchor_id)):
				errors.append("mainline segment references unknown anchor: %s" % segment_id)
			if tier == "P0" and ["anchor_x_x_mark_box", "anchor_z_zebra"].has(str(anchor_id)):
				errors.append("P0 mainline segment must not use far edge anchor: %s" % segment_id)
		for place_id in record.get("place_sequence", []):
			if not place_rings.has(str(place_id)):
				errors.append("mainline segment references unknown place: %s" % segment_id)
			if tier == "P0" and not P0_ALLOWED_RINGS.has(str(place_rings.get(str(place_id), ""))):
				errors.append("P0 mainline segment must stay in center or first ring: %s" % segment_id)
		if bool(record.get("blocks_current_daily_loop", true)):
			errors.append("V02.13 data-only segment must not block current daily loop: %s" % segment_id)
		_validate_safe_text(record, "mainline segment %s" % segment_id, errors)
	if not has_p0 or not has_p1 or not has_p2:
		errors.append("V02.13 mainline segments must include P0, P1 and P2.")


static func _validate_safe_text(record: Dictionary, label: String, errors: Array[String]) -> void:
	var combined := " ".join([
		str(record.get("child_facing_line", "")),
		str(record.get("child_facing_frame", "")),
		str(record.get("story_memory", "")),
		str(record.get("visual_hook", "")),
		str(record.get("review_path", "")),
	])
	var lower := combined.to_lower()
	for term in PRESSURE_TERMS:
		if lower.contains(term.to_lower()):
			errors.append("textbook world child-facing text contains pressure term '%s': %s" % [term, label])


static func _require_unique(id: String, seen: Dictionary, label: String, errors: Array[String]) -> void:
	if id.is_empty():
		errors.append("%s missing id." % label)
	elif seen.has(id):
		errors.append("duplicate %s id: %s" % [label, id])
	seen[id] = true


static func _load_anchor_lookup(errors: Array[String]) -> Dictionary:
	var file := FileAccess.open(CORE_ANCHORS_PATH, FileAccess.READ)
	if file == null:
		errors.append("Unable to open core anchors: %s" % CORE_ANCHORS_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		errors.append("Core anchors root must be a dictionary.")
		return {}
	var lookup: Dictionary = {}
	for anchor in (parsed as Dictionary).get("anchors", []):
		if anchor is Dictionary:
			lookup[str((anchor as Dictionary).get("anchor_id", ""))] = anchor
	return lookup


static func _load_place_ring_lookup(errors: Array[String]) -> Dictionary:
	var file := FileAccess.open(AZ_WORLD_PLAN_PATH, FileAccess.READ)
	if file == null:
		errors.append("Unable to open A-Z world plan: %s" % AZ_WORLD_PLAN_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		errors.append("A-Z world plan root must be a dictionary.")
		return {}
	var lookup: Dictionary = {}
	for district in (parsed as Dictionary).get("districts", []):
		if not district is Dictionary:
			continue
		var ring_id := str((district as Dictionary).get("ring_id", ""))
		for place_id in (district as Dictionary).get("place_ids", []):
			lookup[str(place_id)] = ring_id
	return lookup
