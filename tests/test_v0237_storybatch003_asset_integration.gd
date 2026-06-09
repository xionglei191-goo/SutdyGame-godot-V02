extends SceneTree

const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

const THEME_ID := "theme_sunshine_town_placeholder"
const SECOND_BATCH_ASSETS: Array[Dictionary] = [
	{"asset_id": "story_prop.home.clock_chair_corner", "story_prop_id": "story_prop_marker_home_clock_chair_corner", "anchor_id": "anchor_c_clock", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_home_clock_chair_1280.png"},
	{"asset_id": "story_prop.home.sunny_towel_dog_corner", "story_prop_id": "story_prop_marker_home_sunny_towel_dog_corner", "anchor_id": "anchor_d_dog", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_home_sunny_towel_1280.png"},
	{"asset_id": "story_prop.home.watch_wall_charm", "story_prop_id": "story_prop_marker_home_watch_wall_charm", "anchor_id": "anchor_w_watch", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_home_watch_charm_1280.png"},
	{"asset_id": "story_prop.school.gate_bell_sign", "story_prop_id": "story_prop_marker_school_gate_bell_sign", "anchor_id": "anchor_g_gate", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_school_gate_bell_1280.png"},
	{"asset_id": "story_prop.walk.kite_leaf_path", "story_prop_id": "story_prop_marker_walk_kite_leaf_path", "anchor_id": "anchor_k_kite", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_walk_kite_leaf_1280.png"},
	{"asset_id": "story_prop.shop.orange_bowl_window", "story_prop_id": "story_prop_marker_shop_orange_bowl_window", "anchor_id": "anchor_o_orange", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_shop_orange_bowl_1280.png"},
	{"asset_id": "story_prop.plaza.sun_flower_patch", "story_prop_id": "story_prop_marker_sun_flower_patch", "anchor_id": "anchor_s_sun", "proof": "docs/collaboration/round182_storybatch005_rc/shot_round182_storybatch005_sun_flower_patch_1280.png"},
]
const FORBIDDEN_TEXT: Array[String] = ["课程", "测试", "测验", "考试", "背诵", "评分", "打卡", "倒计时", "作业", "分数", "迟到", "坐标", "格子", "debug", "editor"]

var failures: Array[String] = []


func _init() -> void:
	_check_second_batch_assets_resolve()
	_check_story_prop_data_contract()
	_check_map_editor_second_batch_markers()
	_finish()


func _check_second_batch_assets_resolve() -> void:
	var records: Array = AssetResolverScript.get_asset_acceptance_records(THEME_ID)
	for entry in SECOND_BATCH_ASSETS:
		var asset_id := str(entry.get("asset_id", ""))
		var resolved: Dictionary = AssetResolverScript.get_story_prop_asset(asset_id, THEME_ID)
		_expect(resolved.get("ok", false), "V02.37 STORYBATCH-003 asset should resolve: %s -> %s" % [asset_id, resolved.get("errors", [])])
		var path := str(resolved.get("placeholder_path", ""))
		_expect(path.begins_with("res://assets/art/"), "V02.37 STORYBATCH-003 asset should live under project art assets: %s" % asset_id)
		_expect(FileAccess.file_exists(path), "V02.37 STORYBATCH-003 asset file should exist: %s" % path)
		var record := _acceptance_record_for_path(records, asset_id, path)
		_expect(not record.is_empty(), "V02.37 STORYBATCH-003 asset should have acceptance record: %s" % asset_id)
		_expect(_record_is_runtime_accepted(record), "V02.37 STORYBATCH-003 asset should be production/pass or runtime-promoted for review: %s" % asset_id)
		_expect(str(record.get("resource_path_for_mapping", "")) == path, "V02.37 STORYBATCH-003 asset acceptance path should match resolver: %s" % asset_id)
		_expect(str(record.get("notes_child_safety", "")).length() > 0, "V02.37 STORYBATCH-003 asset should have child-safety notes: %s" % asset_id)
		_expect(str(record.get("notes_anchor_integrity", "")).length() > 0, "V02.37 STORYBATCH-003 asset should have anchor-integrity notes: %s" % asset_id)


func _check_story_prop_data_contract() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "V02.37 STORYBATCH-003 world map should load")
	var story_result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.STORY_PROPS_PATH)
	_expect(story_result.get("ok", false), "V02.37 STORYBATCH-003 story_props.json should load")
	var story_data: Dictionary = story_result.get("data", {})
	var errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(story_data, map_result.get("data", {}))
	_expect(errors.is_empty(), "V02.37 STORYBATCH-003 story props should validate: %s" % [errors])
	var story_props: Array = story_data.get("story_props", [])
	_expect(story_props.size() == 11, "V02.37 STORYBATCH-003 should contain first batch plus seven new story props")
	var seen_anchors: Dictionary = {}
	for entry in SECOND_BATCH_ASSETS:
		var prop := _story_prop_by_id(story_props, str(entry.get("story_prop_id", "")))
		_expect(not prop.is_empty(), "V02.37 STORYBATCH-003 story prop should exist: %s" % entry.get("story_prop_id", ""))
		_expect((prop.get("core_anchor_ids", []) as Array).has(str(entry.get("anchor_id", ""))), "V02.37 STORYBATCH-003 story prop should bind expected anchor: %s" % entry.get("story_prop_id", ""))
		_expect(str(prop.get("logical_asset_id", "")) == str(entry.get("asset_id", "")), "V02.37 STORYBATCH-003 story prop should bind expected asset: %s" % entry.get("story_prop_id", ""))
		_expect(bool(prop.get("visible_in_child_runtime", false)), "V02.37 STORYBATCH-003 story prop should be visible in child runtime: %s" % entry.get("story_prop_id", ""))
		_expect(_child_safe(str(prop.get("child_label", ""))), "V02.37 STORYBATCH-003 child label should be safe: %s" % entry.get("story_prop_id", ""))
		_expect(_child_safe(str(prop.get("child_feedback", ""))), "V02.37 STORYBATCH-003 child feedback should be safe: %s" % entry.get("story_prop_id", ""))
		var anchor_id := str(entry.get("anchor_id", ""))
		_expect(not seen_anchors.has(anchor_id), "V02.37 STORYBATCH-003 second batch should not reuse anchor: %s" % anchor_id)
		seen_anchors[anchor_id] = true
	var invalid: Dictionary = story_data.duplicate(true)
	invalid["story_props"][4]["child_label"] = "测试格子"
	var invalid_errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(invalid, map_result.get("data", {}))
	_expect(not invalid_errors.is_empty(), "V02.37 STORYBATCH-003 validator should still reject unsafe story prop labels")


func _check_map_editor_second_batch_markers() -> void:
	var scene: Control = preload("res://scenes/map_editor/town_map_authoring.tscn").instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var build: Dictionary = scene.call("build_from_world_map")
	_expect(int(build.get("story_prop_marker_count", 0)) == 11, "V02.37 STORYBATCH-003 Map Editor should build all story prop markers")
	for entry in SECOND_BATCH_ASSETS:
		_expect(scene.call("select_marker", "story_prop", str(entry.get("story_prop_id", ""))).get("ok", false), "V02.37 STORYBATCH-003 Map Editor should select second-batch marker: %s" % entry.get("story_prop_id", ""))
	var validation: Dictionary = scene.call("validate_story_props_candidate")
	_expect(validation.get("ok", false), "V02.37 STORYBATCH-003 Map Editor should validate second-batch story prop state: %s" % [validation.get("errors", [])])
	root.remove_child(scene)
	scene.queue_free()


func _story_prop_by_id(story_props: Array, story_prop_id: String) -> Dictionary:
	for prop in story_props:
		if prop is Dictionary and str((prop as Dictionary).get("story_prop_id", "")) == story_prop_id:
			return (prop as Dictionary).duplicate(true)
	return {}


func _acceptance_record_for(records: Array, asset_id: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str((record as Dictionary).get("logical_asset_id", "")) == asset_id:
			return record
	return {}


func _acceptance_record_for_path(records: Array, asset_id: String, asset_path: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str((record as Dictionary).get("logical_asset_id", "")) == asset_id and str((record as Dictionary).get("resource_path_for_mapping", "")) == asset_path:
			return record
	return _acceptance_record_for(records, asset_id)


func _record_is_runtime_accepted(record: Dictionary) -> bool:
	var status := str(record.get("status", ""))
	var result := str(record.get("acceptance_result", ""))
	if status == "production" and result == "pass":
		return true
	return status == "runtime_promoted_for_review" and result == "runtime_promoted_pending_visual_review"


func _child_safe(text: String) -> bool:
	for forbidden in FORBIDDEN_TEXT:
		if text.contains(forbidden):
			return false
	return true


func _finish() -> void:
	if failures.is_empty():
		print("V02.37 STORYBATCH-003 ASSET INTEGRATION TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
