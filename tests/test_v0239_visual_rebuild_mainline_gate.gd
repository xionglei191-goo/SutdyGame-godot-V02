extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const CONTRACT_JSON := "res://docs/collaboration/round180_v0239_mainline_visual_layout_target/visual_layout_contract_v001.json"
const KIT_JSON := "res://docs/collaboration/round181_v0239_mainline_closeout/unified_environment_composition_kit_v001.json"
const MATCH_JSON := "res://docs/collaboration/round181_v0239_mainline_closeout/runtime_visual_match_report_v001.json"
const GATE_JSON := "res://docs/collaboration/round181_v0239_mainline_closeout/art_direction_gate_v001.json"
const SIDE_BY_SIDE_PNG := "res://docs/collaboration/round181_v0239_mainline_closeout/round181_v0239_runtime_match_side_by_side_1280x720_v001.png"

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var contract := _load_json(CONTRACT_JSON)
	var kit := _load_json(KIT_JSON)
	var match_report := _load_json(MATCH_JSON)
	var gate := _load_json(GATE_JSON)
	_check_documents(contract, kit, match_report, gate)
	_check_runtime_snapshot()
	_check_side_by_side_png()
	_finish()


func _check_documents(contract: Dictionary, kit: Dictionary, match_report: Dictionary, gate: Dictionary) -> void:
	_expect(str(contract.get("status", "")) == "art_target_locked_whitebox_by_user_instruction", "V02.39 target contract should be whitebox locked")
	_expect(str(kit.get("status", "")) == "whitebox_composition_kit_locked", "V02.39 composition kit should be locked")
	_expect(str(match_report.get("status", "")) == "runtime_visual_match_whitebox_pass", "V02.39 runtime match report should pass")
	_expect(str(gate.get("status", "")) == "gate_pass_for_storybatch_unlock", "V02.39 art direction gate should pass for StoryBatch unlock")
	var logical_assets: Array = kit.get("logical_assets", [])
	_expect(logical_assets.size() >= 11, "V02.39 composition kit should define logical whitebox assets")
	var runtime_claims: Dictionary = match_report.get("runtime_match_claims", {})
	for claim in ["home_centered_first_screen", "player_layer_above_blockout", "legacy_visual_layers_hidden", "walkable_center_exists", "full_map_background_absent", "visible_grid_absent", "five_button_glass_footer", "real_home_interaction_reachable"]:
		_expect(bool(runtime_claims.get(claim, false)), "V02.39 runtime match claim should pass: %s" % claim)
	var storybatch_decision: Dictionary = gate.get("storybatch_decision", {})
	_expect(str(storybatch_decision.get("V02-STORYBATCH-004", "")) == "ready_after_round181_gate", "V02-STORYBATCH-004 should be unlocked to Ready after gate")
	var safety_gate: Dictionary = gate.get("safety_gate", {})
	_expect(int(safety_gate.get("a_z_stable_count", 0)) == 26, "V02.39 gate should preserve 26 stable A-Z anchors")
	_expect(not bool(safety_gate.get("child_runtime_grid_terms_visible", true)), "V02.39 gate should hide child-facing grid terms")


func _check_runtime_snapshot() -> void:
	var save_path := "user://test_v0239_visual_rebuild_mainline_gate.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.39 mainline gate save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	root.add_child(main)
	main.call("_ready")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_visual_rebuild_blockout_snapshot"), "TownStage should expose V02.39 blockout snapshot for gate")
	if stage != null and stage.has_method("get_visual_rebuild_blockout_snapshot"):
		var snapshot: Dictionary = stage.call("get_visual_rebuild_blockout_snapshot")
		_expect(int(snapshot.get("blockout_tile_path_count", 0)) >= 30, "V02.39 gate should keep continuous first-screen road")
		_expect(int(snapshot.get("blockout_grass_base_count", 0)) >= 6, "V02.39 gate should keep terrain regions")
		_expect(int(snapshot.get("blockout_house_count", 0)) == 1, "V02.39 gate should keep one Home")
		_expect(int(snapshot.get("blockout_tree_count", 0)) == 4, "V02.39 gate should keep sparse trees")
		_expect(int(snapshot.get("blockout_water_count", 0)) >= 3, "V02.39 gate should keep water edge hint")
		_expect(int(snapshot.get("blockout_companion_detail_count", 0)) >= 4, "V02.39 gate should keep Sunny detail proxy")
		_expect(bool(snapshot.get("legacy_visual_layers_hidden", false)), "V02.39 gate should hide legacy visual scaffold layers")
		_expect(int(snapshot.get("resolver_mapped_v0239_count", 0)) >= 30, "V02.39 gate should use promoted visual rebuild PNGs through resolver mappings")
		var camera_scale: Vector2 = snapshot.get("camera_scale", Vector2.ZERO)
		_expect(camera_scale.x <= 1.6 and camera_scale.y <= 1.6, "V02.39 gate should keep target camera scale")
		_expect(bool(snapshot.get("player_layer_above_blockout", false)), "V02.39 gate should keep player above blockout")
	var footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(footer_actions != null and footer_actions.get_child_count() == 5, "V02.39 gate should keep five footer actions")
	_expect(main.move_player_to_cell(Vector2i(31, 19)).get("ok", false), "V02.39 gate Home path should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.39 gate Home real interaction should remain reachable")
	_expect(int(main.get_expapproval_school_snapshot().get("anchor_count", 0)) == 26, "V02.39 gate should preserve 26 A-Z anchors")
	_expect(save_service.clear_for_test(), "V02.39 mainline gate save should clean")
	root.remove_child(main)
	main.queue_free()


func _check_side_by_side_png() -> void:
	var target_path_abs: String = ProjectSettings.globalize_path(SIDE_BY_SIDE_PNG)
	_expect(FileAccess.file_exists(target_path_abs), "V02.39 side-by-side proof should exist")
	var image := Image.new()
	var load_error: Error = image.load(target_path_abs)
	_expect(load_error == OK, "V02.39 side-by-side proof should load")
	if load_error == OK:
		_expect(image.get_width() == 1280, "V02.39 side-by-side proof width should be 1280")
		_expect(image.get_height() == 720, "V02.39 side-by-side proof height should be 720")


func _load_json(path: String) -> Dictionary:
	var path_abs: String = ProjectSettings.globalize_path(path)
	if not FileAccess.file_exists(path_abs):
		failures.append("JSON should exist: %s" % path)
		return {}
	var file: FileAccess = FileAccess.open(path_abs, FileAccess.READ)
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
		print("V02.39 VISUAL REBUILD MAINLINE GATE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
