extends SceneTree

const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

const THEME_ID := "theme_sunshine_town_placeholder"
const STORY_PROP_IDS: Array[String] = [
	"story_prop.home.apple_welcome_photo",
	"story_prop.school.yard_net_robot_yoyo_corner",
	"story_prop.shop.hat_ribbon_window",
	"story_prop.plaza.bear_book_branch_bookmark",
]
const UI_FEEDBACK_IDS: Array[String] = [
	"ui_feedback.prompt_soft_glow",
	"ui_feedback.collect_sparkle_soft",
	"ui_feedback.tap_ripple_soft",
]

var failures: Array[String] = []


func _init() -> void:
	_check_theme_profile_extended_assets()
	_check_animation_metadata()
	_check_story_prop_contract()
	_check_map_editor_story_prop_markers()
	_finish()


func _check_theme_profile_extended_assets() -> void:
	var loaded: Dictionary = AssetResolverScript.load_theme_profile(THEME_ID)
	_expect(loaded.get("ok", false), "V02.34 theme profile should load with extended asset categories: %s" % [loaded.get("errors", [])])
	for asset_id in STORY_PROP_IDS:
		_expect_project_asset(AssetResolverScript.get_story_prop_asset(asset_id, THEME_ID), asset_id)
	for asset_id in UI_FEEDBACK_IDS:
		_expect_project_asset(AssetResolverScript.get_ui_feedback(asset_id, THEME_ID), asset_id)
	_expect_project_asset(AssetResolverScript.get_tile_edge_asset("tile_edge.grass_path.soft", THEME_ID), "tile edge grass path")
	_expect_project_asset(AssetResolverScript.get_character_animation("anim_sheet.player.p0_motion", THEME_ID), "player motion sheet")
	_expect_project_asset(AssetResolverScript.get_pet_animation("anim_sheet.pet.sunny.p0_motion", THEME_ID), "sunny motion sheet")
	_expect_project_asset(AssetResolverScript.get_animation_metadata("anim_meta.player.p0_motion", THEME_ID), "player motion metadata")
	_expect_project_asset(AssetResolverScript.get_animation_metadata("anim_meta.pet.sunny.p0_motion", THEME_ID), "sunny motion metadata")

	var records: Array = AssetResolverScript.get_asset_acceptance_records(THEME_ID)
	for asset_id in STORY_PROP_IDS + UI_FEEDBACK_IDS + ["tile_edge.grass_path.soft", "anim_sheet.player.p0_motion", "anim_sheet.pet.sunny.p0_motion"]:
		var record := _acceptance_record_for(records, asset_id)
		_expect(not record.is_empty(), "V02.34 production asset should have acceptance record: %s" % asset_id)
		_expect(str(record.get("status", "")) == "production", "V02.34 asset should be production, not approved by file presence: %s" % asset_id)
		_expect(str(record.get("viewport_evidence", "")) == "pending_1280_runtime_proof", "V02.34 asset should keep proof pending until runtime approval: %s" % asset_id)
		_expect(str(record.get("notes_child_safety", "")).length() > 0, "V02.34 asset should have child-safety notes: %s" % asset_id)
		_expect(str(record.get("notes_anchor_integrity", "")).length() > 0, "V02.34 asset should have anchor-integrity notes: %s" % asset_id)


func _check_animation_metadata() -> void:
	_check_metadata("anim_meta.player.p0_motion", "anim_sheet.player.p0_motion", "character_assets", ["down", "left", "up"])
	_check_metadata("anim_meta.pet.sunny.p0_motion", "anim_sheet.pet.sunny.p0_motion", "pet_assets", ["down"])


func _check_metadata(metadata_asset_id: String, sheet_asset_id: String, fallback_category: String, expected_directions: Array[String]) -> void:
	var resolved: Dictionary = AssetResolverScript.get_animation_metadata(metadata_asset_id, THEME_ID)
	var metadata: Dictionary = _load_json(str(resolved.get("placeholder_path", "")))
	_expect(str(metadata.get("metadata_id", "")) == metadata_asset_id, "metadata_id should match resolver id: %s" % metadata_asset_id)
	_expect(str(metadata.get("sheet_asset_id", "")) == sheet_asset_id, "sheet_asset_id should match motion sheet: %s" % metadata_asset_id)
	_expect(FileAccess.file_exists(str(metadata.get("source_png", ""))), "metadata source_png should exist: %s" % metadata_asset_id)
	_expect(int(metadata.get("frame_size", {}).get("w", 0)) > 0 and int(metadata.get("frame_size", {}).get("h", 0)) > 0, "metadata frame_size should be positive: %s" % metadata_asset_id)
	_expect(int(metadata.get("pivot", {}).get("x", -1)) >= 0 and int(metadata.get("pivot", {}).get("y", -1)) >= 0, "metadata pivot should be present: %s" % metadata_asset_id)
	var seen_ids: Dictionary = {}
	var seen_directions: Dictionary = {}
	for animation_value in metadata.get("animations", []):
		_expect(animation_value is Dictionary, "metadata animation should be dictionary: %s" % metadata_asset_id)
		if not animation_value is Dictionary:
			continue
		var animation: Dictionary = animation_value
		var logical_animation_id := str(animation.get("logical_animation_id", ""))
		var direction := str(animation.get("direction", ""))
		_expect(not logical_animation_id.is_empty(), "metadata animation should have logical_animation_id: %s" % metadata_asset_id)
		_expect(not seen_ids.has(logical_animation_id), "metadata logical_animation_id should be unique: %s" % logical_animation_id)
		seen_ids[logical_animation_id] = true
		seen_directions[direction] = true
		_expect(["down", "left", "right", "up"].has(direction), "metadata direction should be P0 legal: %s" % logical_animation_id)
		_expect(int(animation.get("fps", 0)) > 0, "metadata fps should be positive: %s" % logical_animation_id)
		_expect((animation.get("frames", []) as Array).size() > 0, "metadata frames should not be empty: %s" % logical_animation_id)
		var fallback_id := str(animation.get("fallback_asset_id", ""))
		_expect(AssetResolverScript.resolve_asset(THEME_ID, fallback_category, fallback_id).get("ok", false), "metadata fallback should resolve: %s -> %s" % [logical_animation_id, fallback_id])
	for direction in expected_directions:
		_expect(seen_directions.has(direction), "metadata should include expected direction %s for %s" % [direction, metadata_asset_id])


func _check_story_prop_contract() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "V02.34 world map should load before story prop validation")
	var story_result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.STORY_PROPS_PATH)
	_expect(story_result.get("ok", false), "V02.34 story_props.json should load")
	var errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(story_result.get("data", {}), map_result.get("data", {}))
	_expect(errors.is_empty(), "V02.34 story props should validate: %s" % [errors])
	var story_props: Array = story_result.get("data", {}).get("story_props", [])
	_expect(story_props.size() >= 4, "V02.34 story prop data should keep at least the first four P0 story prop markers")
	for first_batch_id in [
		"story_prop_marker_home_apple_welcome_photo",
		"story_prop_marker_school_yard_net_robot_yoyo",
		"story_prop_marker_shop_hat_ribbon_window",
		"story_prop_marker_plaza_bear_book_branch",
	]:
		_expect(_story_prop_exists(story_props, first_batch_id), "V02.34 first batch story prop should remain present: %s" % first_batch_id)

	var invalid: Dictionary = story_result.get("data", {}).duplicate(true)
	invalid["story_props"][0]["child_label"] = "测试格子"
	var invalid_errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(invalid, map_result.get("data", {}))
	_expect(not invalid_errors.is_empty(), "V02.34 story prop validator should reject course/editor/grid wording")


func _check_map_editor_story_prop_markers() -> void:
	var scene: Control = preload("res://scenes/map_editor/town_map_authoring.tscn").instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var build: Dictionary = scene.call("build_from_world_map")
	_expect(int(build.get("story_prop_marker_count", 0)) >= 4, "V02.34 Map Editor should keep building story prop markers")
	var tools: Dictionary = scene.call("get_tool_summary")
	_expect((tools.get("layer_visibility", {}) as Dictionary).has("story_prop"), "V02.34 Map Editor should expose story_prop layer toggle state")
	_expect(scene.call("set_tool_mode", "place_story_prop").get("ok", false), "V02.34 Map Editor should expose story prop tool mode")
	_expect(scene.call("select_marker", "story_prop", "story_prop_marker_home_apple_welcome_photo").get("ok", false), "V02.34 Map Editor should select story prop marker")
	var inspector: Dictionary = scene.call("get_inspector_summary")
	_expect((inspector.get("editable_fields", []) as Array).has("child_label"), "V02.34 story prop inspector should expose child_label")
	_expect(scene.call("apply_inspector_field_values", {"child_label": "看看苹果小照片"}).get("ok", false), "V02.34 story prop inspector should apply safe child label")
	var bad_edit: Dictionary = scene.call("apply_inspector_field_values", {"child_label": "测试格子"})
	_expect(not bad_edit.get("ok", true), "V02.34 story prop inspector should reject unsafe child label")
	var validation: Dictionary = scene.call("validate_story_props_candidate")
	_expect(validation.get("ok", false), "V02.34 Map Editor should validate story prop candidate: %s" % [validation.get("errors", [])])
	var drag: Dictionary = scene.call("commit_marker_drag_for_test", "story_prop", "story_prop_marker_home_apple_welcome_photo", Vector2i(7, 18))
	_expect(drag.get("ok", false), "V02.34 story prop marker should drag through candidate validation: %s" % [drag.get("errors", [])])
	root.remove_child(scene)
	scene.queue_free()


func _expect_project_asset(result: Dictionary, label: String) -> void:
	_expect(result.get("ok", false), "V02.34 asset should resolve: %s -> %s" % [label, result.get("errors", [])])
	var path := str(result.get("placeholder_path", ""))
	_expect(path.begins_with("res://assets/art/"), "V02.34 asset should map through project art tree: %s -> %s" % [label, path])
	_expect(FileAccess.file_exists(path), "V02.34 asset path should exist: %s" % path)


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_expect(false, "JSON file should open: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	_expect(parsed is Dictionary, "JSON root should be dictionary: %s" % path)
	return parsed if parsed is Dictionary else {}


func _acceptance_record_for(records: Array, asset_id: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str((record as Dictionary).get("logical_asset_id", "")) == asset_id:
			return record
	return {}


func _story_prop_exists(story_props: Array, story_prop_id: String) -> bool:
	for story_prop in story_props:
		if story_prop is Dictionary and str((story_prop as Dictionary).get("story_prop_id", "")) == story_prop_id:
			return true
	return false


func _finish() -> void:
	if failures.is_empty():
		print("V02.34 ARTPROD-001 ASSET INTEGRATION TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
