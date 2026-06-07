extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const SAVE_PATH := "user://capture_expapproval004_shop_settings.json"
const OUTPUT_DIR := "res://docs/collaboration/round117_expapproval004_shop_settings"
const SHOTS := [
	{"id": "shop_shelf", "file": "shot_round117_expapproval004_shop_shelf_1280.png"},
	{"id": "shop_purchase_feedback", "file": "shot_round117_expapproval004_shop_purchase_feedback_1280.png"},
	{"id": "settings_rest_confirm", "file": "shot_round117_expapproval004_settings_rest_confirm_1280.png"},
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
		print("EXPAPPROVAL-004 Shop / Settings screenshots captured: %s" % OUTPUT_DIR)
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


func _prepare_shot(shot_id: String) -> void:
	if main == null:
		_fail("Main scene missing for shot: %s" % shot_id)
		return
	main.close_memory_album()
	main.close_settings_panel()
	main.close_shop_panel()
	main.show_town_view()
	match shot_id:
		"shop_shelf":
			main.move_player_to_cell(Vector2i(24, 9))
			_press(main.find_child("InteractButton", true, false) as Button, "shop shelf shot should open Shop")
		"shop_purchase_feedback":
			var game_state: Dictionary = main.save_service.load_game_state()
			game_state["coins"] = 30
			main.save_service.save_game_state(game_state)
			main.open_shop_panel()
			_press(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "shop purchase shot should buy chair")
		"settings_rest_confirm":
			main.open_settings_panel()
			_press(main.find_child("RequestRestButton", true, false) as Button, "settings shot should show rest confirm")
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
