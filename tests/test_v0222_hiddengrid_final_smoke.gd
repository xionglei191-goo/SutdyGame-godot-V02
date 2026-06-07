extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0222_hiddengrid_final_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.22 final smoke save should clear")
	var inventory = InventoryServiceScript.new(save_service)
	_expect(inventory.collect_item("flower_pot", 1).get("ok", false), "V02.22 final smoke should seed outdoor decor")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_scene_splits(main)
	_check_life_path(main)
	_check_hidden_grid_systems(main)
	_check_ui_paths(main)

	var saved: Dictionary = main.save_service.load_game_state()
	_expect(saved.get("player_cell") is Dictionary, "V02.22 final smoke should persist player cell")
	_expect(saved.get("outdoor_state") is Dictionary, "V02.22 final smoke should persist outdoor state bucket")
	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_scene_splits(main) -> void:
	_expect(_script_path(main.find_child("TownStage", true, false)).ends_with("town_stage.gd"), "V02.22 final smoke should use TownStage scene")
	_expect(_script_path(main.find_child("Player", true, false)).ends_with("player_actor.gd"), "V02.22 final smoke should use PlayerActor")
	_expect(_script_path(main.find_child("npc_mina", true, false)).ends_with("npc_actor.gd"), "V02.22 final smoke should use NPCActor")
	_expect(_script_path(main.find_child("TownHUD", true, false)).ends_with("town_hud.gd"), "V02.22 final smoke should use TownHUD scene")
	_expect(_script_path(main.find_child("TownFooter", true, false)).ends_with("town_footer.gd"), "V02.22 final smoke should use TownFooter scene")


func _check_life_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.request_player_walk_to_cell(Vector2i(38, 22)).get("ok", false), "V02.22 final smoke should walk to Mina")
	main.finish_player_walk_for_test(420)
	_press(interact_button, "V02.22 final smoke should greet Mina")
	_press(interact_button, "V02.22 final smoke should start Mina request")
	_expect(main.request_player_walk_to_cell(Vector2i(19, 18)).get("ok", false), "V02.22 final smoke should walk to branch")
	main.finish_player_walk_for_test(420)
	_press(interact_button, "V02.22 final smoke should collect branch")
	_expect(main.request_player_walk_to_cell(Vector2i(19, 22)).get("ok", false), "V02.22 final smoke should return to the animal road")
	main.finish_player_walk_for_test(420)
	_expect(main.request_player_walk_to_cell(Vector2i(38, 22)).get("ok", false), "V02.22 final smoke should return to Mina")
	main.finish_player_walk_for_test(420)
	_press(interact_button, "V02.22 final smoke should complete Mina request")


func _check_hidden_grid_systems(main) -> void:
	var outdoor: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(32, 21))
	_expect(outdoor.get("ok", false), "V02.22 final smoke should place outdoor decor")
	var instance_id := str(outdoor.get("outdoor_item", {}).get("instance_id", ""))
	_expect(main.find_child("outdoor_%s" % instance_id, true, false) != null, "V02.22 final smoke should render outdoor decor")
	_expect(main.move_outdoor_item(instance_id, Vector2i(33, 21)).get("ok", false), "V02.22 final smoke should move outdoor decor")
	var resources: Dictionary = main.resource_refresh_service.get_refresh_summary()
	_expect(resources.get("ok", false) and int(resources.get("available_count", 0)) >= 2, "V02.22 final smoke should keep resource summary available")
	var routines: Dictionary = main.get_npc_routine_snapshot()
	_expect(routines.get("ok", false) and int(routines.get("fallback_count", -1)) >= 1, "V02.22 final smoke should keep NPC routine fallback")


func _check_ui_paths(main) -> void:
	_press(main.find_child("BackpackNavButton", true, false) as Button, "V02.22 final smoke should open backpack")
	_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.22 final smoke should open album")
	var album := main.find_child("MemoryAlbumOverlay", true, false) as Control
	_expect(album != null and album.visible, "V02.22 final smoke should show album")
	_press(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.22 final smoke should close album")
	_press(main.find_child("SettingsButton", true, false) as Button, "V02.22 final smoke should open settings")
	var settings := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings != null and settings.visible, "V02.22 final smoke should show settings")
	_press(main.find_child("CloseSettingsButton", true, false) as Button, "V02.22 final smoke should close settings")


func _press(button: Button, message: String) -> void:
	_expect(button != null and _is_visible_in_tree(button) and not button.disabled, message)
	if button != null and _is_visible_in_tree(button) and not button.disabled:
		button.pressed.emit()


func _is_visible_in_tree(control: Control) -> bool:
	if control == null:
		return false
	var current: Node = control
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _script_path(node: Node) -> String:
	if node == null:
		return ""
	var script := node.get_script() as Script
	if script == null:
		return ""
	return script.resource_path


func _finish() -> void:
	if failures.is_empty():
		print("V02.22 HIDDENGRID FINAL SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
