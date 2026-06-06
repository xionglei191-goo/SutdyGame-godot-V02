extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0220_playgate_controls.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.20 controls save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_embodied_walk(main)
	_check_local_camera(main)
	_check_context_prompt(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	_finish()


func _check_embodied_walk(main) -> void:
	var start_cell: Vector2i = main.player_cell
	var target_cell := start_cell + Vector2i(1, 0)
	var start_position: Vector2 = main.player_marker.position
	var request: Dictionary = main.request_player_walk_to_cell(target_cell)
	_expect(request.get("ok", false), "V02.20 walk request should accept a neighboring target")
	_expect(bool(request.get("walking", false)), "V02.20 walk request should enter walking state")
	_expect(main.player_cell == start_cell, "V02.20 walk request should not teleport the saved cell immediately")
	main.call("_advance_player_walk", 1.0 / 60.0)
	_expect(main.player_marker.position != start_position, "V02.20 walking should move the marker over time")
	_expect(main.player_cell == start_cell, "V02.20 walking should keep logical cell until arrival")
	var finish: Dictionary = main.finish_player_walk_for_test()
	_expect(finish.get("ok", false), "V02.20 walking should finish within the focused test frame budget")
	_expect(main.player_cell == target_cell, "V02.20 walking should arrive at target cell")
	var saved_cell: Dictionary = main.save_service.load_game_state().get("player_cell", {})
	_expect(int(saved_cell.get("x", -1)) == target_cell.x and int(saved_cell.get("y", -1)) == target_cell.y, "V02.20 walking should save the cell after arrival")
	var blocked: Dictionary = main.request_player_walk_to_cell(Vector2i(-1, -1))
	_expect(not blocked.get("ok", true), "V02.20 walking should reject blocked/out-of-bounds targets")


func _check_local_camera(main) -> void:
	_expect(main.runtime_map_node != null, "V02.20 camera should keep a RuntimeMap node reference")
	_expect(main.runtime_map_node.scale.x > 1.0 and main.runtime_map_node.scale.y > 1.0, "V02.20 camera should render a local neighborhood instead of compressing the whole map")
	var before_position: Vector2 = main.runtime_map_node.position
	var request: Dictionary = main.request_player_walk_to_cell(main.player_cell + Vector2i(4, 0))
	_expect(request.get("ok", false), "V02.20 camera test should request a short walk")
	main.finish_player_walk_for_test()
	_expect(main.runtime_map_node.position != before_position, "V02.20 camera should follow the player after walking")


func _check_context_prompt(main) -> void:
	var walk: Dictionary = main.request_player_walk_to_cell(Vector2i(38, 22))
	_expect(walk.get("ok", false), "V02.20 prompt test should walk near Mina")
	main.finish_player_walk_for_test()
	var target: Dictionary = main.get_current_interaction_target()
	_expect(target.get("ok", false), "V02.20 prompt should resolve a nearby target")
	_expect(str(target.get("type", "")) == "npc", "V02.20 prompt near Mina should resolve NPC target")
	_expect(str(target.get("display_name", "")).contains("米娜"), "V02.20 prompt should expose child-facing target name")
	var prompt := main.find_child("InteractionPrompt", true, false) as Label
	_expect(prompt != null and prompt.visible and str(prompt.text).contains("米娜"), "V02.20 prompt label should show the current target")


func _finish() -> void:
	if failures.is_empty():
		print("V02.20 PLAYGATE CONTROLS TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
