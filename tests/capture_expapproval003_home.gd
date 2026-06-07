extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const SAVE_PATH := "user://capture_expapproval003_home.json"
const OUTPUT_DIR := "res://docs/collaboration/round116_expapproval003_home"
const SHOTS := [
	{"id": "default_room", "file": "shot_round116_expapproval003_home_default_room_1280.png"},
	{"id": "visible_furniture", "file": "shot_round116_expapproval003_home_visible_furniture_1280.png"},
	{"id": "sunny_feedback", "file": "shot_round116_expapproval003_home_sunny_feedback_1280.png"},
]

var failures: Array[String] = []
var main: Node


func _init() -> void:
	await process_frame
	_prepare_scene()
	await process_frame
	await process_frame
	for shot in SHOTS:
		await _prepare_shot(str(shot.get("id", "")))
		await process_frame
		await process_frame
		_capture(str(shot.get("file", "")))
	_teardown()
	if failures.is_empty():
		print("EXPAPPROVAL-003 Home screenshots captured: %s" % OUTPUT_DIR)
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _prepare_scene() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))
	var save_service = SaveServiceScript.new(SAVE_PATH)
	save_service.clear_for_test()
	main = MainScene.instantiate()
	main.configure_for_test(SAVE_PATH)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	main.show_home_view()


func _prepare_shot(shot_id: String) -> void:
	if main == null:
		_fail("Main scene missing for shot: %s" % shot_id)
		return
	main.close_memory_album()
	main.close_settings_panel()
	main.close_shop_panel()
	main.show_home_view()
	match shot_id:
		"default_room":
			pass
		"visible_furniture":
			main.inventory_service.collect_item("wooden_chair", 1)
			main.show_home_view()
			_press(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "visible furniture shot should place chair")
		"sunny_feedback":
			if int(main.get_expapproval_home_snapshot().get("placed_furniture_count", 0)) == 0:
				main.inventory_service.collect_item("wooden_chair", 1)
				main.show_home_view()
				_press(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "Sunny feedback shot should place chair")
			_press(main.find_child("HomeMoveFirstFurnitureButton", true, false) as Button, "Sunny feedback shot should move chair")
		_:
			_fail("Unknown shot id: %s" % shot_id)


func _press(button: Button, message: String) -> void:
	if button == null or not _is_visible_in_tree(button) or button.disabled:
		_fail(message)
		return
	button.pressed.emit()


func _is_visible_in_tree(control: Control) -> bool:
	var current: Node = control
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _capture(file_name: String) -> void:
	if file_name.is_empty():
		_fail("Screenshot file name is empty")
		return
	var image := root.get_viewport().get_texture().get_image()
	if image == null:
		_fail("Unable to read viewport image for %s" % file_name)
		return
	if image.get_width() != 1280 or image.get_height() != 720:
		_fail("Screenshot should be 1280x720, got %sx%s for %s" % [image.get_width(), image.get_height(), file_name])
	var result := image.save_png("%s/%s" % [OUTPUT_DIR, file_name])
	if result != OK:
		_fail("Unable to save screenshot %s, error %s" % [file_name, result])


func _teardown() -> void:
	if main != null:
		main.save_service.clear_for_test()
		root.remove_child(main)
		main.queue_free()


func _fail(message: String) -> void:
	failures.append(message)
