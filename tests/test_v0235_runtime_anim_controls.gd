extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0235_runtime_anim_controls.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.35 runtime anim save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_asset_hooks()
	_check_player_motion_state(main)
	_check_camera_smoothing(main)
	_check_held_keyboard_movement(main)
	_check_prompt_and_tap_feedback(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_asset_hooks() -> void:
	var theme_id := AssetResolverScript.DEFAULT_THEME_ID
	for spec in [
		{"category": "character_animation_assets", "asset_id": "anim_sheet.player.p0_motion"},
		{"category": "ui_feedback_assets", "asset_id": "ui_feedback.prompt_soft_glow"},
		{"category": "ui_feedback_assets", "asset_id": "ui_feedback.tap_ripple_soft"},
	]:
		var resolved: Dictionary = AssetResolverScript.resolve_asset(theme_id, str(spec.get("category", "")), str(spec.get("asset_id", "")))
		_expect(resolved.get("ok", false), "V02.35 asset should resolve: %s" % str(spec.get("asset_id", "")))
		_expect(FileAccess.file_exists(str(resolved.get("placeholder_path", ""))), "V02.35 asset file should exist: %s" % str(spec.get("asset_id", "")))


func _check_player_motion_state(main) -> void:
	var start_cell: Vector2i = main.player_cell
	var request: Dictionary = main.request_player_walk_to_cell(start_cell + Vector2i(1, 0))
	_expect(request.get("ok", false), "V02.35 walk request should start runtime motion")
	main.call("_advance_player_walk", 1.0 / 30.0)
	var moving_snapshot: Dictionary = main.get_runtime_motion_snapshot()
	var stage: Dictionary = moving_snapshot.get("stage", {})
	var player: Dictionary = stage.get("player", {})
	_expect(bool(player.get("uses_motion_sheet", false)), "V02.35 PlayerActor should use production motion sheet")
	_expect(bool(player.get("walking", false)), "V02.35 PlayerActor should report walking while moving")
	_expect(str(player.get("animation_key", "")) == "walk_left", "V02.35 PlayerActor should use side walk row for horizontal movement")
	var facing: Dictionary = player.get("facing", {})
	_expect(int(facing.get("x", 0)) == 1, "V02.35 PlayerActor should face right for an east step")
	main.finish_player_walk_for_test()
	var idle_snapshot: Dictionary = main.get_runtime_motion_snapshot()
	var idle_player: Dictionary = (idle_snapshot.get("stage", {}) as Dictionary).get("player", {})
	_expect(not bool(idle_player.get("walking", true)), "V02.35 PlayerActor should return to idle after arrival")
	_expect(str(idle_player.get("animation_key", "")) == "idle_side", "V02.35 PlayerActor should keep last horizontal facing while idle")


func _check_camera_smoothing(main) -> void:
	var before: Dictionary = main.get_runtime_motion_snapshot().get("stage", {})
	var before_camera: Vector2 = before.get("camera_position", Vector2.ZERO)
	var request: Dictionary = main.request_player_walk_to_cell(main.player_cell + Vector2i(3, 0))
	_expect(request.get("ok", false), "V02.35 camera smoothing should accept a short walk")
	main.call("_advance_player_walk", 1.0 / 30.0)
	var during: Dictionary = main.get_runtime_motion_snapshot().get("stage", {})
	var camera_position: Vector2 = during.get("camera_position", Vector2.ZERO)
	var desired_position: Vector2 = during.get("desired_camera_position", Vector2.ZERO)
	_expect(camera_position != before_camera, "V02.35 camera should move during walking")
	_expect(camera_position != desired_position, "V02.35 camera should smooth toward target instead of snapping")
	_expect(float(during.get("camera_smoothing", 1.0)) < 1.0, "V02.35 camera smoothing factor should stay below snap speed")
	main.finish_player_walk_for_test()


func _check_held_keyboard_movement(main) -> void:
	var held: Dictionary = main.simulate_held_move_for_test(Vector2i(0, 1), 130)
	_expect(held.get("ok", false), "V02.35 held movement should continue walking across frames")
	var start_cell := _dict_to_cell(held.get("start_cell", {}))
	var end_cell := _dict_to_cell(held.get("end_cell", {}))
	_expect(end_cell.y > start_cell.y, "V02.35 held down movement should advance south")


func _check_prompt_and_tap_feedback(main) -> void:
	var walk: Dictionary = main.request_player_walk_to_cell(Vector2i(38, 22))
	_expect(walk.get("ok", false), "V02.35 prompt test should walk to Mina")
	main.finish_player_walk_for_test()
	var prompt_snapshot: Dictionary = main.get_runtime_motion_snapshot()
	_expect(bool(prompt_snapshot.get("prompt_visible", false)), "V02.35 prompt should be visible near an interaction target")
	_expect(bool(prompt_snapshot.get("prompt_glow_visible", false)), "V02.35 prompt should show production glow feedback")
	var stage: Node = main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("show_tap_feedback_at_cell"), "V02.35 TownStage should expose tap feedback")
	stage.call("show_tap_feedback_at_cell", main.player_cell + Vector2i(1, 0))
	var feedback_snapshot: Dictionary = main.get_runtime_motion_snapshot().get("stage", {})
	_expect(int(feedback_snapshot.get("tap_feedback_count", 0)) >= 1, "V02.35 tap feedback should count a ripple")
	_expect(int(feedback_snapshot.get("feedback_layer_count", 0)) >= 1, "V02.35 tap feedback should render on FeedbackLayer")


func _dict_to_cell(cell: Variant) -> Vector2i:
	if cell is Dictionary:
		var dict: Dictionary = cell
		return Vector2i(int(dict.get("x", 0)), int(dict.get("y", 0)))
	return Vector2i.ZERO


func _finish() -> void:
	if failures.is_empty():
		print("V02.35 RUNTIME ANIM CONTROLS TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
