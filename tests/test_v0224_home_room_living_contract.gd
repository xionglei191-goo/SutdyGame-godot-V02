extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0224_home_room_living_contract.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.24 HomeRoom save should clear before startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_default_living_corner(main)
	_check_furniture_feedback_and_save_boundary(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_default_living_corner(main) -> void:
	main.show_home_view()
	var snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(str(snapshot.get("home_living_contract_version", "")) == "v02.24_homeplaza_002", "V02.24 HomeRoom should expose the living contract version")
	_expect(bool(snapshot.get("home_visible", false)), "V02.24 HomeRoom should be visible for the living contract")
	_expect(int(snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 HomeRoom should keep at least nine default living details")
	for node_name in [
		"HomeDefaultRug",
		"HomeDefaultTeaTable",
		"HomeDefaultPlant",
		"HomeDefaultWallStory",
		"HomeDefaultSunnyBowl",
		"HomeDefaultSunnyBed",
		"HomeDefaultBookStack",
		"HomeDefaultSunnyToy",
		"HomeDefaultWarmCup",
	]:
		_expect((snapshot.get("home_life_detail_names", []) as Array).has(node_name), "V02.24 HomeRoom default life layer should include %s" % node_name)
	_expect(int(snapshot.get("placed_furniture_count", -1)) == 0, "V02.24 HomeRoom default living details should not enter placed_furniture")
	_expect(str(snapshot.get("sunny_feedback_text", "")).contains("Sunny"), "V02.24 HomeRoom should keep Sunny feedback visible")
	_expect(str(snapshot.get("action_status_text", "")).contains("小角落"), "V02.24 HomeRoom empty state should describe a warm corner")
	_expect(str(snapshot.get("selected_furniture_text", "")).contains("故事书"), "V02.24 HomeRoom empty selected state should mention default story texture")
	_expect(int(snapshot.get("child_text_banned_count", -1)) == 0, "V02.24 HomeRoom child-facing text should hide technical terms")
	_check_home_state_keys(snapshot)


func _check_furniture_feedback_and_save_boundary(main) -> void:
	_seed_inventory(main, {"pet_bowl": 1, "sunny_bed": 1, "small_table": 1})
	main.show_home_view()

	_press(main.find_child("HomePlacePetBowlButton", true, false) as Button, "V02.24 HomeRoom should place Sunny's bowl from a visible button")
	var bowl_snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(int(bowl_snapshot.get("placed_furniture_count", 0)) == 1, "V02.24 HomeRoom should save one real placed furniture item after bowl placement")
	_expect(str(bowl_snapshot.get("sunny_feedback_text", "")).contains("Sunny"), "V02.24 HomeRoom bowl placement should refresh Sunny feedback")
	_expect(str(bowl_snapshot.get("action_status_text", "")).contains("已摆放 1 件"), "V02.24 HomeRoom should show a saved furniture count after bowl placement")
	_expect(int(bowl_snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 HomeRoom default details should stay visible after placement")
	_expect(int(bowl_snapshot.get("child_text_banned_count", -1)) == 0, "V02.24 HomeRoom placed text should remain child-facing")

	_press(main.find_child("HomePlaceSunnyBedButton", true, false) as Button, "V02.24 HomeRoom should place Sunny's bed from a visible button")
	var bed_snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(int(bed_snapshot.get("placed_furniture_count", 0)) == 2, "V02.24 HomeRoom should save two real placed furniture items after bed placement")
	_expect(str(bed_snapshot.get("sunny_feedback_text", "")).contains("小床") or str(bed_snapshot.get("sunny_feedback_text", "")).contains("Sunny"), "V02.24 HomeRoom bed placement should use Sunny's home feedback")
	_expect(int(bed_snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 HomeRoom default living details should not be consumed by placement")
	_check_home_state_keys(bed_snapshot)

	var reloaded_state: Dictionary = main.save_service.load_game_state().get("home_state", {})
	var placed: Array = reloaded_state.get("placed_furniture", [])
	_expect(placed.size() == 2, "V02.24 HomeRoom save state should persist only player-placed furniture")
	for record in placed:
		if record is Dictionary:
			var item_id := str((record as Dictionary).get("item_id", ""))
			_expect(not item_id.begins_with("HomeDefault"), "V02.24 HomeRoom default visual detail should never be saved as furniture: %s" % item_id)


func _seed_inventory(main, inventory_items: Dictionary) -> void:
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["inventory"] = inventory_items.duplicate(true)
	game_state["home_state"] = {"placed_furniture": [], "stowed_furniture": {}}
	_expect(main.save_service.save_game_state(game_state), "V02.24 HomeRoom setup should seed furniture inventory")


func _check_home_state_keys(snapshot: Dictionary) -> void:
	var keys: Array = snapshot.get("home_state_keys", [])
	_expect(keys.has("placed_furniture"), "V02.24 HomeRoom should keep placed_furniture save key")
	for key in keys:
		_expect(["placed_furniture", "stowed_furniture"].has(str(key)), "V02.24 HomeRoom should not add a HomeDecorationService save key: %s" % str(key))


func _press(button: Button, message: String) -> void:
	_expect(button != null and _is_visible_in_tree(button) and not button.disabled, message)
	if button != null and _is_visible_in_tree(button) and not button.disabled:
		button.pressed.emit()


func _is_visible_in_tree(control: Control) -> bool:
	var current: Node = control
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _finish() -> void:
	if failures.is_empty():
		print("V02.24 HOME ROOM LIVING CONTRACT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
