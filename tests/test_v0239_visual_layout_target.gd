extends SceneTree

const CONTRACT_JSON := "res://docs/collaboration/round180_v0239_mainline_visual_layout_target/visual_layout_contract_v001.json"
const TARGET_PNG := "res://docs/collaboration/round180_v0239_mainline_visual_layout_target/round180_v0239_visual_layout_target_1280x720_v001.png"
const CANONICAL_REFERENCE := "res://docs/collaboration/artpass003_visual_direction/artpass003_main_gameplay_direction_1280.png"

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var contract: Dictionary = _load_contract()
	_expect(not contract.is_empty(), "Round180 visual layout contract should load")
	if not contract.is_empty():
		_expect(str(contract.get("task_id", "")) == "V02-VISUALREBUILD-002", "Round180 contract should bind to V02-VISUALREBUILD-002")
		_expect(str(contract.get("round", "")) == "Round180", "Round180 contract should record round")
		_expect(str(contract.get("status", "")) == "art_target_locked_whitebox_by_user_instruction", "Round180 contract should be locked as whitebox target")
		_expect(str(contract.get("runtime_boundary", "")).contains("locked_whitebox_target"), "Round180 contract should stay locked to whitebox runtime scope")
		_expect(str(contract.get("target_frame_output", "")) == TARGET_PNG.replace("res://", ""), "Round180 contract should point at the generated 1280 target")
		_expect(str(contract.get("canonical_reference", "")) == CANONICAL_REFERENCE.replace("res://", ""), "Round180 contract should preserve canonical gameplay reference")
		var target_viewport: Dictionary = contract.get("target_viewport", {})
		_expect(int(target_viewport.get("w", 0)) == 1280, "Round180 contract viewport width should be 1280")
		_expect(int(target_viewport.get("h", 0)) == 720, "Round180 contract viewport height should be 720")
		_check_layers(contract.get("layers", []))
		_check_visual_nodes(contract.get("visual_nodes", []))
		_check_constraints(contract.get("constraints", {}))
	_check_png()
	_finish()


func _load_contract() -> Dictionary:
	var contract_path_abs: String = ProjectSettings.globalize_path(CONTRACT_JSON)
	if not FileAccess.file_exists(contract_path_abs):
		failures.append("Round180 visual layout contract file should exist")
		return {}
	var contract_file: FileAccess = FileAccess.open(contract_path_abs, FileAccess.READ)
	if contract_file == null:
		failures.append("Round180 visual layout contract file should open")
		return {}
	var parsed: Variant = JSON.parse_string(contract_file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		failures.append("Round180 visual layout contract should parse as Dictionary")
		return {}
	return parsed


func _check_layers(layers: Variant) -> void:
	_expect(typeof(layers) == TYPE_ARRAY, "Round180 contract layers should be an array")
	if typeof(layers) != TYPE_ARRAY:
		return
	var layer_ids: Array[String] = []
	for layer in layers:
		if typeof(layer) == TYPE_DICTIONARY:
			layer_ids.append(str(layer.get("layer_id", "")))
	for layer_id in ["terrain_regions", "path_water", "background_places", "home_midground", "props_anchors", "actors", "glass_ui"]:
		_expect(layer_ids.has(layer_id), "Round180 contract should include layer: %s" % layer_id)


func _check_visual_nodes(nodes: Variant) -> void:
	_expect(typeof(nodes) == TYPE_ARRAY, "Round180 contract visual_nodes should be an array")
	if typeof(nodes) != TYPE_ARRAY:
		return
	var bind_ids: Array[String] = []
	for node in nodes:
		if typeof(node) == TYPE_DICTIONARY:
			var bind: Dictionary = node.get("bind", {})
			bind_ids.append(str(bind.get("id", "")))
	for bind_id in ["place_home", "place_school_gate", "place_supermarket", "anchor_a_apple", "anchor_c_clock", "player", "sunny", "town_footer"]:
		_expect(bind_ids.has(bind_id), "Round180 contract should bind visual node: %s" % bind_id)


func _check_constraints(constraints: Variant) -> void:
	_expect(typeof(constraints) == TYPE_DICTIONARY, "Round180 contract constraints should be a dictionary")
	if typeof(constraints) != TYPE_DICTIONARY:
		return
	var constraint_data: Dictionary = constraints
	_expect(str(constraint_data.get("story_batch_status", "")) == "pending_until_round181_gate", "StoryBatch should wait for Round181 gate")
	_expect(str(constraint_data.get("full_map_background", "")) == "forbidden_as_final_runtime", "Full-map background should remain forbidden")
	_expect(str(constraint_data.get("visible_grid", "")) == "forbidden_in_child_runtime", "Visible grid should remain forbidden")
	_expect(str(constraint_data.get("a_z_first_screen", "")) == "prop_first_subset_only", "A-Z first screen should be prop-first subset only")
	_expect(str(constraint_data.get("approval", "")).contains("grants_art_target_locked"), "Round180 contract should grant whitebox art_target_locked")


func _check_png() -> void:
	var target_path_abs: String = ProjectSettings.globalize_path(TARGET_PNG)
	_expect(FileAccess.file_exists(target_path_abs), "Round180 1280 target PNG should exist")
	var image := Image.new()
	var load_error: Error = image.load(target_path_abs)
	_expect(load_error == OK, "Round180 1280 target PNG should load")
	if load_error == OK:
		_expect(image.get_width() == 1280, "Round180 target PNG width should be 1280")
		_expect(image.get_height() == 720, "Round180 target PNG height should be 720")


func _finish() -> void:
	if failures.is_empty():
		print("V02.39 VISUAL LAYOUT TARGET TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
