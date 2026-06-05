extends RefCounted
class_name AZWorldPlanContract

const PLAN_PATH := "res://data/maps/az_world_plan.json"
const CORE_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const LETTERS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const REQUIRED_ANCHOR_FIELDS: Array[String] = [
	"anchor_id",
	"letter",
	"core_word",
	"route_order",
	"district_id",
	"world_place_id",
	"map_ring",
	"home_school_relation",
	"story_memory",
	"visual_hook",
	"review_path",
	"album_record",
	"future_curriculum_hooks",
]
const RESERVED_LETTERS: Array[String] = ["E", "F", "G", "H", "I", "J", "L", "M", "N", "P", "Q", "R", "U", "V", "X", "Y", "Z"]
const REQUIRED_FOUNDATION_TAGS: Array[String] = [
	"family",
	"home",
	"room",
	"clock",
	"dog",
	"bag",
	"school",
	"gate",
	"play",
	"look",
	"go",
	"good_morning",
]
const PRESSURE_TERMS: Array[String] = [
	"lesson",
	"unit",
	"test",
	"quiz",
	"exam",
	"score",
	"word list",
	"review",
	"homework",
	"课程",
	"单元",
	"考试",
	"测验",
	"分数",
	"背诵",
	"词表",
	"作业",
	"倒计时",
	"赶车",
	"独自远行",
]


static func load_plan(path: String = PLAN_PATH) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "errors": ["Unable to open A-Z world plan: %s" % path], "data": {}}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {"ok": false, "errors": ["A-Z world plan root must be a dictionary."], "data": {}}
	var data: Dictionary = parsed
	var errors := validate_plan(data)
	return {"ok": errors.is_empty(), "errors": errors, "data": data}


static func validate_plan(data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var core_lookup := _load_core_anchor_lookup(errors)
	var district_ids := _collect_ids(data.get("districts", []), "district_id", "district", errors)
	var ring_ids := _collect_ids(data.get("map_rings", []), "ring_id", "map ring", errors)
	_validate_center_policy(data, district_ids, ring_ids, errors)
	_validate_anchor_distribution(data.get("anchors", []), core_lookup, district_ids, ring_ids, errors)
	_validate_routes(data.get("routes", []), ring_ids, errors)
	_validate_safety_boundaries(data.get("safety_boundaries", []), errors)
	_validate_reserved_anchor_specs(data.get("reserved_anchor_specs", []), core_lookup, errors)
	_validate_foundation_story_hooks(data.get("foundation_story_hooks", []), core_lookup, errors)
	_validate_screenshot_acceptance(data.get("screenshot_acceptance", []), errors)
	return errors


static func _validate_center_policy(data: Dictionary, district_ids: Dictionary, ring_ids: Dictionary, errors: Array[String]) -> void:
	if str(data.get("center_policy", "")) != "home_school_dual_core":
		errors.append("A-Z world plan center_policy must be home_school_dual_core.")
	for required_district in ["district_home_center", "district_school_center"]:
		if not district_ids.has(required_district):
			errors.append("A-Z world plan missing center district: %s" % required_district)
	for required_ring in ["center", "first_ring", "second_ring", "far_edge"]:
		if not ring_ids.has(required_ring):
			errors.append("A-Z world plan missing map ring: %s" % required_ring)
	var center_districts: Array = data.get("center_district_ids", [])
	for required_district in ["district_home_center", "district_school_center"]:
		if not center_districts.has(required_district):
			errors.append("A-Z world plan center_district_ids must include: %s" % required_district)


static func _validate_anchor_distribution(anchors: Array, core_lookup: Dictionary, district_ids: Dictionary, ring_ids: Dictionary, errors: Array[String]) -> void:
	if anchors.size() != 26:
		errors.append("A-Z world plan must contain 26 anchor distribution records.")
	var seen_ids: Dictionary = {}
	var seen_letters: Dictionary = {}
	var seen_orders: Dictionary = {}
	var home_school_letters: Dictionary = {}
	var far_edge_count := 0
	for anchor in anchors:
		if not anchor is Dictionary:
			errors.append("A-Z world plan anchor entry must be a dictionary.")
			continue
		var record: Dictionary = anchor
		for field in REQUIRED_ANCHOR_FIELDS:
			if not record.has(field):
				errors.append("A-Z world plan anchor missing %s: %s" % [field, record.get("anchor_id", "")])
			elif field != "future_curriculum_hooks" and str(record.get(field, "")).is_empty():
				errors.append("A-Z world plan anchor field must not be empty %s: %s" % [field, record.get("anchor_id", "")])
		var anchor_id := str(record.get("anchor_id", ""))
		var letter := str(record.get("letter", ""))
		var route_order := int(record.get("route_order", 0))
		var expected_letter := LETTERS.substr(route_order - 1, 1) if route_order >= 1 and route_order <= 26 else ""
		if seen_ids.has(anchor_id):
			errors.append("A-Z world plan duplicate anchor_id: %s" % anchor_id)
		seen_ids[anchor_id] = true
		if seen_letters.has(letter):
			errors.append("A-Z world plan duplicate letter: %s" % letter)
		seen_letters[letter] = true
		if seen_orders.has(route_order):
			errors.append("A-Z world plan duplicate route_order: %s" % route_order)
		seen_orders[route_order] = true
		if letter != expected_letter:
			errors.append("A-Z world plan route_order must match A-Z: %s" % anchor_id)
		if not core_lookup.has(anchor_id):
			errors.append("A-Z world plan anchor_id must exist in core anchors: %s" % anchor_id)
		else:
			var core: Dictionary = core_lookup.get(anchor_id, {})
			if str(core.get("letter", "")) != letter:
				errors.append("A-Z world plan letter must match core anchor: %s" % anchor_id)
			if str(core.get("core_word", "")) != str(record.get("core_word", "")):
				errors.append("A-Z world plan core_word must match core anchor: %s" % anchor_id)
		if not district_ids.has(str(record.get("district_id", ""))):
			errors.append("A-Z world plan anchor district must exist: %s" % anchor_id)
		if not ring_ids.has(str(record.get("map_ring", ""))):
			errors.append("A-Z world plan anchor map_ring must exist: %s" % anchor_id)
		if not str(record.get("world_place_id", "")).begins_with("place_"):
			errors.append("A-Z world plan world_place_id must be stable place id: %s" % anchor_id)
		if str(record.get("home_school_relation", "")) in ["home_line", "school_line"]:
			home_school_letters[letter] = true
		if str(record.get("map_ring", "")) == "far_edge":
			far_edge_count += 1
			if str(record.get("home_school_relation", "")).contains("mainline"):
				errors.append("Far edge anchor must not be first-mainline dependency: %s" % anchor_id)
		_validate_curriculum_hooks(record, errors)
		_validate_child_safe_text(record, errors)
	for required_letter in ["A", "C", "D", "W", "E", "G", "K", "N", "R", "Y"]:
		if not home_school_letters.has(required_letter):
			errors.append("Home / School center route must cover letter: %s" % required_letter)
	if far_edge_count == 0:
		errors.append("A-Z world plan should reserve at least one far_edge anchor.")


static func _validate_curriculum_hooks(record: Dictionary, errors: Array[String]) -> void:
	var hooks: Array = record.get("future_curriculum_hooks", [])
	if hooks.is_empty():
		errors.append("A-Z world plan anchor must keep future curriculum hooks: %s" % record.get("anchor_id", ""))
	for hook in hooks:
		if not hook is Dictionary:
			errors.append("future_curriculum_hooks entry must be a dictionary: %s" % record.get("anchor_id", ""))
			continue
		if str(hook.get("foundation_tag", "")).is_empty():
			errors.append("future curriculum hook missing foundation_tag: %s" % record.get("anchor_id", ""))
		if str(hook.get("storyline_hook", "")).is_empty():
			errors.append("future curriculum hook missing storyline_hook: %s" % record.get("anchor_id", ""))


static func _validate_routes(routes: Array, ring_ids: Dictionary, errors: Array[String]) -> void:
	if routes.size() < 4:
		errors.append("A-Z world plan must include p0, first-ring, second-ring and far-edge routes.")
	var required_routes := {
		"route_p0_home_school_walk": false,
		"route_first_ring_daily_town": false,
		"route_second_ring_story_nature": false,
		"route_far_edge_reserve": false,
	}
	for route in routes:
		if not route is Dictionary:
			errors.append("A-Z world route record must be a dictionary.")
			continue
		var record: Dictionary = route
		var route_id := str(record.get("route_id", ""))
		if required_routes.has(route_id):
			required_routes[route_id] = true
		if route_id.is_empty():
			errors.append("A-Z world route missing route_id.")
		if not ring_ids.has(str(record.get("ring_id", ""))):
			errors.append("A-Z world route ring_id must exist: %s" % route_id)
		if record.get("place_sequence", []).is_empty():
			errors.append("A-Z world route must include place_sequence: %s" % route_id)
		if record.get("anchor_ids", []).is_empty():
			errors.append("A-Z world route must include anchor_ids: %s" % route_id)
		if str(record.get("safe_return_node_id", "")).is_empty():
			errors.append("A-Z world route must include safe_return_node_id: %s" % route_id)
		if route_id == "route_p0_home_school_walk":
			if not bool(record.get("is_p0_required", false)):
				errors.append("Home-School Walk must be marked P0 required.")
			if bool(record.get("blocks_p0_if_missing", false)) != true:
				errors.append("Home-School Walk should be the only route that blocks P0 if missing.")
		elif bool(record.get("blocks_p0_if_missing", false)):
			errors.append("Non-center route must not block P0: %s" % route_id)
		if str(record.get("ring_id", "")) == "far_edge" and bool(record.get("is_p0_required", false)):
			errors.append("Far-edge route must not be P0 required: %s" % route_id)
		_validate_child_safe_text(record, errors)
	for route_id in required_routes.keys():
		if not bool(required_routes[route_id]):
			errors.append("A-Z world plan missing required route: %s" % route_id)


static func _validate_safety_boundaries(boundaries: Array, errors: Array[String]) -> void:
	if boundaries.size() < 3:
		errors.append("A-Z world plan must include safety boundary records.")
	for boundary in boundaries:
		if not boundary is Dictionary:
			errors.append("A-Z world safety boundary must be a dictionary.")
			continue
		var record: Dictionary = boundary
		for field in ["boundary_id", "route_id", "safe_return_node_id", "child_facing_hint"]:
			if str(record.get(field, "")).is_empty():
				errors.append("A-Z world safety boundary missing %s." % field)
		_validate_child_safe_text(record, errors)


static func _validate_reserved_anchor_specs(specs: Array, core_lookup: Dictionary, errors: Array[String]) -> void:
	if specs.size() != RESERVED_LETTERS.size():
		errors.append("A-Z world plan must include 17 reserved anchor production specs.")
	var specs_by_anchor: Dictionary = {}
	for spec in specs:
		if not spec is Dictionary:
			errors.append("Reserved anchor spec must be a dictionary.")
			continue
		var record: Dictionary = spec
		var anchor_id := str(record.get("anchor_id", ""))
		specs_by_anchor[anchor_id] = record
		for field in ["visible_entry", "album_record_id", "safety_note", "production_status"]:
			if str(record.get(field, "")).is_empty():
				errors.append("Reserved anchor spec missing %s: %s" % [field, anchor_id])
		if record.get("logical_asset_ids", []).size() < 2:
			errors.append("Reserved anchor spec must include main and album logical asset ids: %s" % anchor_id)
		if str(record.get("production_status", "")) != "make_ready":
			errors.append("Reserved anchor spec must be make_ready: %s" % anchor_id)
		if not core_lookup.has(anchor_id):
			errors.append("Reserved anchor spec anchor_id must exist: %s" % anchor_id)
		_validate_child_safe_text(record, errors)
	for letter in RESERVED_LETTERS:
		var found := false
		for anchor_id in specs_by_anchor.keys():
			var core: Dictionary = core_lookup.get(anchor_id, {})
			if str(core.get("letter", "")) == letter:
				found = true
		if not found:
			errors.append("Reserved anchor spec missing letter: %s" % letter)


static func _validate_foundation_story_hooks(hooks: Array, core_lookup: Dictionary, errors: Array[String]) -> void:
	if hooks.size() < REQUIRED_FOUNDATION_TAGS.size():
		errors.append("A-Z world plan must include first Home / School foundation hooks.")
	var seen_tags: Dictionary = {}
	for hook in hooks:
		if not hook is Dictionary:
			errors.append("Foundation story hook must be a dictionary.")
			continue
		var record: Dictionary = hook
		for field in ["hook_id", "foundation_tag", "phrase_or_word", "scene_id", "anchor_id", "child_facing_line", "review_path", "safety_note"]:
			if str(record.get(field, "")).is_empty():
				errors.append("Foundation story hook missing %s: %s" % [field, record.get("hook_id", "")])
		seen_tags[str(record.get("foundation_tag", ""))] = true
		if not str(record.get("scene_id", "")).begins_with("place_"):
			errors.append("Foundation story hook scene_id must be stable place id: %s" % record.get("hook_id", ""))
		if not core_lookup.has(str(record.get("anchor_id", ""))):
			errors.append("Foundation story hook anchor must exist: %s" % record.get("hook_id", ""))
		_validate_child_safe_text(record, errors)
	for tag in REQUIRED_FOUNDATION_TAGS:
		if not seen_tags.has(tag):
			errors.append("Foundation story hooks missing required tag: %s" % tag)


static func _validate_screenshot_acceptance(records: Array, errors: Array[String]) -> void:
	if records.size() < 5:
		errors.append("A-Z world plan must include screenshot acceptance points.")
	for record_variant in records:
		if not record_variant is Dictionary:
			errors.append("Screenshot acceptance record must be a dictionary.")
			continue
		var record: Dictionary = record_variant
		for field in ["shot_id", "focus"]:
			if str(record.get(field, "")).is_empty():
				errors.append("Screenshot acceptance missing %s." % field)
		var viewports: Array = record.get("viewports", [])
		if not viewports.has("1280x720") or not viewports.has("960x540"):
			errors.append("Screenshot acceptance should cover 1280x720 and 960x540: %s" % record.get("shot_id", ""))
		_validate_child_safe_text(record, errors)


static func _validate_child_safe_text(record: Dictionary, errors: Array[String]) -> void:
	var combined := " ".join([
		str(record.get("story_memory", "")),
		str(record.get("visual_hook", "")),
		str(record.get("review_path", "")),
		str(record.get("album_record", "")),
		str(record.get("child_safety", "")),
		str(record.get("child_safety", "")),
		str(record.get("child_facing_hint", "")),
		str(record.get("child_facing_line", "")),
		str(record.get("safety_note", "")),
		str(record.get("focus", "")),
	])
	var lower := combined.to_lower()
	for term in PRESSURE_TERMS:
		if lower.contains(term.to_lower()):
			errors.append("A-Z world plan child-facing text contains pressure term '%s': %s" % [term, record.get("anchor_id", "")])


static func _collect_ids(records: Array, id_key: String, label: String, errors: Array[String]) -> Dictionary:
	var ids: Dictionary = {}
	for record in records:
		if not record is Dictionary:
			errors.append("A-Z world plan %s record must be a dictionary." % label)
			continue
		var id := str((record as Dictionary).get(id_key, ""))
		if id.is_empty():
			errors.append("A-Z world plan %s missing %s." % [label, id_key])
		elif ids.has(id):
			errors.append("A-Z world plan duplicate %s: %s" % [id_key, id])
		ids[id] = true
	return ids


static func _load_core_anchor_lookup(errors: Array[String]) -> Dictionary:
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
