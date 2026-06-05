extends SceneTree

const AZWorldPlanContractScript := preload("res://scripts/data/az_world_plan_contract.gd")

const HOME_LINE_LETTERS: Array[String] = ["A", "C", "D", "W"]
const SCHOOL_LINE_LETTERS: Array[String] = ["E", "G", "K", "N", "R", "Y"]
const EXPECTED_LINE_BY_LETTER: Dictionary = {
	"A": "home_line",
	"C": "home_line",
	"D": "home_line",
	"W": "home_line",
	"E": "school_line",
	"G": "school_line",
	"K": "school_line",
	"N": "school_line",
	"R": "school_line",
	"Y": "school_line",
	"H": "shop_food_line",
	"I": "shop_food_line",
	"J": "shop_food_line",
	"O": "shop_food_line",
	"B": "book_story_line",
	"L": "book_story_line",
	"P": "book_story_line",
	"Q": "book_story_line",
	"V": "book_story_line",
	"F": "nature_line",
	"M": "nature_line",
	"S": "nature_line",
	"U": "nature_line",
	"Z": "nature_far_reserve",
	"T": "transport_line",
	"X": "transport_far_reserve",
}

var failures: Array[String] = []


func _init() -> void:
	var loaded: Dictionary = AZWorldPlanContractScript.load_plan()
	_expect(loaded.get("ok", false), "V02.12 A-Z world plan should pass contract: %s" % [loaded.get("errors", [])])
	var data: Dictionary = loaded.get("data", {})
	_check_home_school_center(data)
	_check_anchor_route_distribution(data)
	_check_routes_and_safety(data)
	_check_reserved_anchor_specs(data)
	_check_future_curriculum_hooks(data)
	_check_screenshot_acceptance(data)
	_check_invalid_plan_rejected(data)
	_finish()


func _check_home_school_center(data: Dictionary) -> void:
	_expect(str(data.get("center_policy", "")) == "home_school_dual_core", "V02.12 map must use Home / School dual core")
	var center_districts: Array = data.get("center_district_ids", [])
	_expect(center_districts.has("district_home_center"), "Home must be a center district")
	_expect(center_districts.has("district_school_center"), "School must be a center district")
	var districts := _records_by_id(data.get("districts", []), "district_id")
	_expect(str(districts.get("district_home_center", {}).get("ring_id", "")) == "center", "Home district must be in center ring")
	_expect(str(districts.get("district_school_center", {}).get("ring_id", "")) == "center", "School district must be in center ring")


func _check_anchor_route_distribution(data: Dictionary) -> void:
	var anchors: Array = data.get("anchors", [])
	_expect(anchors.size() == 26, "V02.12 plan must distribute all 26 letters")
	var by_letter := _records_by_id(anchors, "letter")
	for letter in HOME_LINE_LETTERS:
		var anchor: Dictionary = by_letter.get(letter, {})
		_expect(str(anchor.get("map_ring", "")) == "center", "Home-line anchor should sit in center ring: %s" % letter)
		_expect(str(anchor.get("home_school_relation", "")) == "home_line", "Home-line anchor relation mismatch: %s" % letter)
	for letter in SCHOOL_LINE_LETTERS:
		var anchor: Dictionary = by_letter.get(letter, {})
		_expect(str(anchor.get("map_ring", "")) == "center", "School-line anchor should sit in center ring: %s" % letter)
		_expect(str(anchor.get("home_school_relation", "")) == "school_line", "School-line anchor relation mismatch: %s" % letter)
	for letter in EXPECTED_LINE_BY_LETTER.keys():
		var anchor: Dictionary = by_letter.get(letter, {})
		_expect(str(anchor.get("home_school_relation", "")) == str(EXPECTED_LINE_BY_LETTER.get(letter, "")), "Anchor line distribution mismatch: %s" % letter)
		_expect(str(anchor.get("world_place_id", "")).begins_with("place_"), "Anchor should bind stable world place: %s" % letter)
	_expect(str(by_letter.get("X", {}).get("map_ring", "")) == "far_edge", "X should reserve far-edge cargo route")
	_expect(str(by_letter.get("Z", {}).get("map_ring", "")) == "far_edge", "Z should reserve far-edge zoo route")


func _check_future_curriculum_hooks(data: Dictionary) -> void:
	var by_letter := _records_by_id(data.get("anchors", []), "letter")
	var expected_foundation_tags: Dictionary = {
		"A": "home",
		"C": "clock",
		"D": "dog",
		"G": "gate",
		"K": "play",
		"T": "go",
	}
	for letter in expected_foundation_tags.keys():
		var hooks: Array = by_letter.get(letter, {}).get("future_curriculum_hooks", [])
		var has_tag := false
		for hook in hooks:
			if hook is Dictionary and str((hook as Dictionary).get("foundation_tag", "")) == str(expected_foundation_tags.get(letter, "")):
				has_tag = true
		_expect(has_tag, "Anchor should expose expected 0-foundation hook: %s" % letter)


func _check_routes_and_safety(data: Dictionary) -> void:
	var routes := _records_by_id(data.get("routes", []), "route_id")
	var p0: Dictionary = routes.get("route_p0_home_school_walk", {})
	_expect(bool(p0.get("is_p0_required", false)), "Home-School Walk should be P0 required")
	_expect(bool(p0.get("blocks_p0_if_missing", false)), "Home-School Walk should be the P0 blocking route")
	_expect(str(p0.get("safe_return_node_id", "")) == "place_home", "Home-School Walk should return safely to Home")
	for route_id in ["route_first_ring_daily_town", "route_second_ring_story_nature", "route_far_edge_reserve"]:
		var route: Dictionary = routes.get(route_id, {})
		_expect(not bool(route.get("is_p0_required", false)), "Optional route should not be P0 required: %s" % route_id)
		_expect(not bool(route.get("blocks_p0_if_missing", false)), "Optional route should not block P0: %s" % route_id)
	_expect(str(routes.get("route_far_edge_reserve", {}).get("ring_id", "")) == "far_edge", "Far edge route should stay far_edge")
	_expect(data.get("safety_boundaries", []).size() >= 3, "V02.12 should define safety boundary hints")


func _check_reserved_anchor_specs(data: Dictionary) -> void:
	var specs: Array = data.get("reserved_anchor_specs", [])
	_expect(specs.size() == 17, "V02.12 should include 17 reserved anchor make-ready specs")
	var by_anchor := _records_by_id(specs, "anchor_id")
	for anchor_id in [
		"anchor_e_elephant",
		"anchor_f_fox",
		"anchor_g_gate",
		"anchor_h_hat",
		"anchor_i_ice_cream",
		"anchor_j_jacket",
		"anchor_l_lion",
		"anchor_m_monkey",
		"anchor_n_net",
		"anchor_p_panda",
		"anchor_q_queen",
		"anchor_r_robot",
		"anchor_u_umbrella",
		"anchor_v_violin",
		"anchor_x_x_mark_box",
		"anchor_y_yo_yo",
		"anchor_z_zebra",
	]:
		var spec: Dictionary = by_anchor.get(anchor_id, {})
		_expect(str(spec.get("production_status", "")) == "make_ready", "Reserved anchor should be make_ready: %s" % anchor_id)
		_expect(str(spec.get("visible_entry", "")).length() > 0, "Reserved anchor should have visible entry: %s" % anchor_id)
		_expect(str(spec.get("album_record_id", "")).begins_with("album_anchor_"), "Reserved anchor should have album record id: %s" % anchor_id)
		_expect(spec.get("logical_asset_ids", []).size() >= 2, "Reserved anchor should have main/thumb logical assets: %s" % anchor_id)


func _check_screenshot_acceptance(data: Dictionary) -> void:
	var shots: Array = data.get("screenshot_acceptance", [])
	_expect(shots.size() >= 5, "V02.12 should define screenshot acceptance points")
	var by_shot := _records_by_id(shots, "shot_id")
	for shot_id in [
		"shot_v0212_home_morning",
		"shot_v0212_home_school_walk",
		"shot_v0212_school_gate",
		"shot_v0212_school_yard",
		"shot_v0212_far_edge_reserve",
	]:
		var shot: Dictionary = by_shot.get(shot_id, {})
		_expect(shot.get("viewports", []).has("1280x720"), "Screenshot should cover 1280x720: %s" % shot_id)
		_expect(shot.get("viewports", []).has("960x540"), "Screenshot should cover 960x540: %s" % shot_id)


func _check_invalid_plan_rejected(data: Dictionary) -> void:
	var invalid: Dictionary = data.duplicate(true)
	invalid["center_policy"] = "town_plaza_core"
	var invalid_errors: Array[String] = AZWorldPlanContractScript.validate_plan(invalid)
	_expect(not invalid_errors.is_empty(), "A-Z world contract should reject non Home / School center policy")
	var invalid_far: Dictionary = data.duplicate(true)
	for anchor in invalid_far.get("anchors", []):
		if anchor is Dictionary and str((anchor as Dictionary).get("anchor_id", "")) == "anchor_x_x_mark_box":
			(anchor as Dictionary)["home_school_relation"] = "first_mainline"
	var far_errors: Array[String] = AZWorldPlanContractScript.validate_plan(invalid_far)
	_expect(not far_errors.is_empty(), "A-Z world contract should reject far-edge mainline dependency")
	var invalid_hook: Dictionary = data.duplicate(true)
	invalid_hook["foundation_story_hooks"][0].erase("anchor_id")
	var hook_errors: Array[String] = AZWorldPlanContractScript.validate_plan(invalid_hook)
	_expect(not hook_errors.is_empty(), "A-Z world contract should reject incomplete foundation hook")


func _records_by_id(records: Array, id_key: String) -> Dictionary:
	var mapped: Dictionary = {}
	for record in records:
		if record is Dictionary:
			mapped[str((record as Dictionary).get(id_key, ""))] = record
	return mapped


func _finish() -> void:
	if failures.is_empty():
		print("V02.12 A-Z WORLD PLAN TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
