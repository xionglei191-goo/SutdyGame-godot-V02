extends SceneTree

const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const THEME_ID := "theme_sunshine_town_placeholder"
const GATE_JSON := "res://docs/collaboration/round182_storybatch005_rc/storybatch005_approval_gate_v001.json"
const SECOND_BATCH_ASSETS: Array[Dictionary] = [
	{"asset_id": "story_prop.home.clock_chair_corner", "story_prop_id": "story_prop_marker_home_clock_chair_corner", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_home_clock_chair_1280.png"},
	{"asset_id": "story_prop.home.sunny_towel_dog_corner", "story_prop_id": "story_prop_marker_home_sunny_towel_dog_corner", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_home_sunny_towel_1280.png"},
	{"asset_id": "story_prop.home.watch_wall_charm", "story_prop_id": "story_prop_marker_home_watch_wall_charm", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_home_watch_charm_1280.png"},
	{"asset_id": "story_prop.school.gate_bell_sign", "story_prop_id": "story_prop_marker_school_gate_bell_sign", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_school_gate_bell_1280.png"},
	{"asset_id": "story_prop.walk.kite_leaf_path", "story_prop_id": "story_prop_marker_walk_kite_leaf_path", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_walk_kite_leaf_1280.png"},
	{"asset_id": "story_prop.shop.orange_bowl_window", "story_prop_id": "story_prop_marker_shop_orange_bowl_window", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_shop_orange_bowl_1280.png"},
	{"asset_id": "story_prop.plaza.sun_flower_patch", "story_prop_id": "story_prop_marker_sun_flower_patch", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_sun_flower_patch_1280.png"},
]
const FORBIDDEN_TEXT: Array[String] = ["课程", "测试", "测验", "考试", "背诵", "评分", "打卡", "倒计时", "作业", "分数", "迟到", "坐标", "格子", "debug", "editor"]

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var gate := _load_json(GATE_JSON)
	_check_gate_json(gate)
	_check_asset_acceptance_evidence()
	_check_runtime_snapshot()
	_finish()


func _check_gate_json(gate: Dictionary) -> void:
	_expect(str(gate.get("status", "")) == "storybatch005_stage_closeout_pass", "StoryBatch-005 gate should pass")
	_expect(not bool(gate.get("final_bitmap_art_approval", true)), "StoryBatch-005 should not claim final bitmap art approval")
	var decisions: Array = gate.get("story_prop_decisions", [])
	_expect(decisions.size() == 11, "StoryBatch-005 gate should include all eleven story props")
	var runtime_match_count := 0
	for decision in decisions:
		if not (decision is Dictionary):
			continue
		var item := decision as Dictionary
		_expect(not bool(item.get("final_approved", true)), "StoryBatch-005 item should defer final approval: %s" % item.get("logical_asset_id", ""))
		if str(item.get("batch", "")) == "second":
			_expect(str(item.get("decision", "")) == "runtime_visual_match", "StoryBatch-005 second-batch decision should be runtime visual match: %s" % item.get("logical_asset_id", ""))
			_check_png_size(str(item.get("proof", "")))
			runtime_match_count += 1
	_expect(runtime_match_count == 7, "StoryBatch-005 gate should include seven second-batch runtime match decisions")
	var safety_gate: Dictionary = gate.get("safety_gate", {})
	_expect(int(safety_gate.get("a_z_anchor_count", 0)) == 26, "StoryBatch-005 should preserve 26 A-Z anchors")
	_expect(int(safety_gate.get("story_prop_count", 0)) == 11, "StoryBatch-005 should preserve 11 story props")
	_expect(bool(safety_gate.get("child_text_safe", false)), "StoryBatch-005 child text gate should pass")
	_expect(not bool(safety_gate.get("child_runtime_grid_terms_visible", true)), "StoryBatch-005 should hide child-facing grid terms")


func _check_asset_acceptance_evidence() -> void:
	var records: Array = AssetResolverScript.get_asset_acceptance_records(THEME_ID)
	for entry in SECOND_BATCH_ASSETS:
		var asset_id := str(entry.get("asset_id", ""))
		var resolved: Dictionary = AssetResolverScript.get_story_prop_asset(asset_id, THEME_ID)
		_expect(resolved.get("ok", false), "StoryBatch-005 asset should resolve: %s" % asset_id)
		var asset_path := str(resolved.get("placeholder_path", ""))
		var record := _acceptance_record_for_path(records, asset_id, asset_path)
		_expect(not record.is_empty(), "StoryBatch-005 should keep acceptance record: %s" % asset_id)
		_expect(_record_is_runtime_accepted(record), "StoryBatch-005 asset should be production/pass or runtime-promoted for review: %s" % asset_id)
		_expect(str(record.get("resource_path_for_mapping", "")) == asset_path, "StoryBatch-005 acceptance path should match resolver: %s" % asset_id)
		_expect(not str(record.get("status", "")) == "final_approved", "StoryBatch-005 asset should not claim final approval: %s" % asset_id)


func _check_runtime_snapshot() -> void:
	var save_path := "user://test_v0237_storybatch005_approval_gate.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "StoryBatch-005 save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")
	var snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(snapshot.get("story_prop_count", 0)) == 11, "StoryBatch-005 runtime should render eleven story props")
	_expect(int(main.get_expapproval_school_snapshot().get("anchor_count", 0)) == 26, "StoryBatch-005 runtime should preserve 26 anchors")
	var snapshot_text := str(snapshot)
	for forbidden in FORBIDDEN_TEXT:
		_expect(not snapshot_text.contains(forbidden), "StoryBatch-005 snapshot should stay child-safe: %s" % forbidden)
	save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _check_png_size(path: String) -> void:
	_expect(not path.is_empty(), "StoryBatch-005 proof path should not be empty")
	var absolute_path := ProjectSettings.globalize_path("res://%s" % path)
	_expect(FileAccess.file_exists(absolute_path), "StoryBatch-005 proof PNG should exist: %s" % path)
	var image := Image.new()
	var load_error: Error = image.load(absolute_path)
	_expect(load_error == OK, "StoryBatch-005 proof PNG should load: %s" % path)
	if load_error == OK:
		_expect(image.get_width() == 1280, "StoryBatch-005 proof PNG width should be 1280: %s" % path)
		_expect(image.get_height() == 720, "StoryBatch-005 proof PNG height should be 720: %s" % path)


func _acceptance_record_for(records: Array, asset_id: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str((record as Dictionary).get("logical_asset_id", "")) == asset_id:
			return (record as Dictionary).duplicate(true)
	return {}


func _acceptance_record_for_path(records: Array, asset_id: String, asset_path: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str((record as Dictionary).get("logical_asset_id", "")) == asset_id and str((record as Dictionary).get("resource_path_for_mapping", "")) == asset_path:
			return (record as Dictionary).duplicate(true)
	return _acceptance_record_for(records, asset_id)


func _record_is_runtime_accepted(record: Dictionary) -> bool:
	var status := str(record.get("status", ""))
	var result := str(record.get("acceptance_result", ""))
	if status == "production" and result == "pass":
		return true
	return status == "runtime_promoted_for_review" and result == "runtime_promoted_pending_visual_review"


func _load_json(path: String) -> Dictionary:
	var absolute_path := ProjectSettings.globalize_path(path)
	if not FileAccess.file_exists(absolute_path):
		failures.append("JSON should exist: %s" % path)
		return {}
	var file: FileAccess = FileAccess.open(absolute_path, FileAccess.READ)
	if file == null:
		failures.append("JSON should open: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		failures.append("JSON should parse as Dictionary: %s" % path)
		return {}
	return parsed


func _finish() -> void:
	if failures.is_empty():
		print("V02.37 STORYBATCH-005 APPROVAL GATE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
