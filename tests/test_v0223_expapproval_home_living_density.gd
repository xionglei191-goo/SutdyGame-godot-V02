extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0223_expapproval_home_living_density.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.23 EXPAPPROVAL-003 save should clear before startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_home_density_snapshot(main)
	_check_visible_home_furniture_path_still_works(main)
	_check_home_save_schema_is_not_extended(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_home_density_snapshot(main) -> void:
	main.show_home_view()
	_expect(main.has_method("get_expapproval_home_snapshot"), "V02.23 Home should expose approval snapshot")
	if not main.has_method("get_expapproval_home_snapshot"):
		return
	var snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(bool(snapshot.get("home_visible", false)), "V02.23 Home proof should inspect the visible Home view")
	_expect(int(snapshot.get("home_life_detail_count", 0)) >= 6, "V02.23 Home should add default lived-in room details")
	for node_name in ["HomeDefaultRug", "HomeDefaultTeaTable", "HomeDefaultPlant", "HomeDefaultWallStory", "HomeDefaultSunnyBowl", "HomeDefaultSunnyBed"]:
		_expect((snapshot.get("home_life_detail_names", []) as Array).has(node_name), "V02.23 Home life layer should include %s" % node_name)
	_expect(int(snapshot.get("placed_furniture_count", -1)) == 0, "V02.23 default Home density should not be saved furniture")
	_expect(str(snapshot.get("sunny_feedback_text", "")).contains("Sunny"), "V02.23 Home should keep Sunny feedback visible")
	_expect(int(snapshot.get("child_text_banned_count", -1)) == 0, "V02.23 Home child-facing text should hide grid and coordinate terms")


func _check_visible_home_furniture_path_still_works(main) -> void:
	var collected: Dictionary = main.inventory_service.collect_item("wooden_chair", 1)
	_expect(collected.get("ok", false), "V02.23 Home proof should seed one furniture item")
	main.show_home_view()
	var place_button := main.find_child("HomePlaceWoodenChairButton", true, false) as Button
	_press(place_button, "V02.23 Home should still place furniture through visible button")
	var placed_snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(int(placed_snapshot.get("placed_furniture_count", 0)) == 1, "V02.23 Home visible placement should still save one furniture item")
	_expect(str(placed_snapshot.get("selected_furniture_text", "")).contains("小木椅"), "V02.23 Home should name selected furniture")
	_expect(not str(placed_snapshot.get("selected_furniture_text", "")).contains("("), "V02.23 Home selected furniture text should not show coordinate tuple")
	_expect(int(placed_snapshot.get("child_text_banned_count", -1)) == 0, "V02.23 Home placed state should still hide grid and coordinate terms")
	var move_button := main.find_child("HomeMoveFirstFurnitureButton", true, false) as Button
	_press(move_button, "V02.23 Home should keep visible move button")
	var moved_snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(str(moved_snapshot.get("selected_furniture_text", "")).contains("小角落"), "V02.23 Home moved state should stay child-facing")
	_expect(int(moved_snapshot.get("child_text_banned_count", -1)) == 0, "V02.23 Home moved state should still hide grid and coordinate terms")


func _check_home_save_schema_is_not_extended(main) -> void:
	var snapshot: Dictionary = main.get_expapproval_home_snapshot()
	var keys: Array = snapshot.get("home_state_keys", [])
	_expect(keys.has("placed_furniture"), "V02.23 Home should keep placed_furniture save key")
	for key in keys:
		_expect(["placed_furniture", "stowed_furniture"].has(str(key)), "V02.23 Home proof should not add new HomeDecorationService save key: %s" % str(key))


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
		print("V02.23 EXPAPPROVAL HOME LIVING DENSITY TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
