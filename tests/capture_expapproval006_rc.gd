extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const SAVE_PATH := "user://capture_expapproval006_rc.json"
const OUTPUT_DIR := "res://docs/collaboration/round119_expapproval006_rc"
const SHOTS := [
	{"id": "town_plaza_first_screen", "file": "shot_round119_expapproval006_town_plaza_first_screen_1280.png"},
	{"id": "town_plaza_prompt", "file": "shot_round119_expapproval006_town_plaza_prompt_1280.png"},
	{"id": "home_default", "file": "shot_round119_expapproval006_home_default_1280.png"},
	{"id": "home_furniture", "file": "shot_round119_expapproval006_home_furniture_1280.png"},
	{"id": "shop_shelf", "file": "shot_round119_expapproval006_shop_shelf_1280.png"},
	{"id": "shop_purchase_feedback", "file": "shot_round119_expapproval006_shop_purchase_feedback_1280.png"},
	{"id": "shop_closed_path", "file": "shot_round119_expapproval006_shop_closed_path_1280.png"},
	{"id": "school_gate_arrival", "file": "shot_round119_expapproval006_school_gate_arrival_1280.png"},
	{"id": "school_gate_feedback", "file": "shot_round119_expapproval006_school_gate_feedback_1280.png"},
	{"id": "school_yard_arrival", "file": "shot_round119_expapproval006_school_yard_arrival_1280.png"},
	{"id": "school_yard_feedback", "file": "shot_round119_expapproval006_school_yard_feedback_1280.png"},
	{"id": "album_open", "file": "shot_round119_expapproval006_album_open_1280.png"},
	{"id": "album_closed_path", "file": "shot_round119_expapproval006_album_closed_path_1280.png"},
	{"id": "settings_default", "file": "shot_round119_expapproval006_settings_default_1280.png"},
	{"id": "settings_rest_confirm", "file": "shot_round119_expapproval006_settings_rest_confirm_1280.png"},
	{"id": "settings_safe_place", "file": "shot_round119_expapproval006_settings_safe_place_1280.png"},
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
		print("EXPAPPROVAL-006 RC screenshots captured: %s" % OUTPUT_DIR)
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
	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(int(state.get("coins", 0)), 30)
	var inventory: Dictionary = state.get("inventory", {})
	inventory["wooden_chair"] = max(int(inventory.get("wooden_chair", 0)), 1)
	state["inventory"] = inventory
	main.save_service.save_game_state(state)


func _prepare_shot(shot_id: String) -> void:
	if main == null:
		_fail("Main scene missing for shot: %s" % shot_id)
		return
	main.close_memory_album()
	main.close_settings_panel()
	main.close_shop_panel()
	main.show_town_view()
	match shot_id:
		"town_plaza_first_screen":
			main.move_player_to_cell(Vector2i(31, 19))
		"town_plaza_prompt":
			main.move_player_to_cell(Vector2i(38, 22))
			main.get_current_interaction_target()
		"home_default":
			main.show_home_view()
		"home_furniture":
			main.place_home_item("wooden_chair", Vector2i(2, 2))
			main.show_home_view()
		"shop_shelf":
			main.move_player_to_cell(Vector2i(24, 9))
			_press(main.find_child("InteractButton", true, false) as Button, "shop RC shot should open from visible Interact")
		"shop_purchase_feedback":
			main.move_player_to_cell(Vector2i(24, 9))
			_press(main.find_child("InteractButton", true, false) as Button, "shop purchase RC shot should open from visible Interact")
			_press(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "shop purchase RC shot should buy from visible button")
		"shop_closed_path":
			main.move_player_to_cell(Vector2i(24, 9))
			_press(main.find_child("InteractButton", true, false) as Button, "shop close RC shot should open from visible Interact")
			_press(main.find_child("CloseShopButton", true, false) as Button, "shop close RC shot should close from visible button")
		"school_gate_arrival":
			main.request_player_walk_to_cell(Vector2i(21, 12))
			main.finish_player_walk_for_test()
		"school_gate_feedback":
			main.request_player_walk_to_cell(Vector2i(21, 12))
			main.finish_player_walk_for_test()
			_press(main.find_child("InteractButton", true, false) as Button, "school gate RC shot should trigger visible look")
		"school_yard_arrival":
			main.request_player_walk_to_cell(Vector2i(19, 15))
			main.finish_player_walk_for_test()
		"school_yard_feedback":
			main.request_player_walk_to_cell(Vector2i(19, 15))
			main.finish_player_walk_for_test()
			_press(main.find_child("InteractButton", true, false) as Button, "school yard RC shot should trigger visible look")
		"album_open":
			_press(main.find_child("BackpackNavButton", true, false) as Button, "album RC shot should open Backpack")
			_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "album RC shot should open Album from Backpack")
		"album_closed_path":
			_press(main.find_child("BackpackNavButton", true, false) as Button, "album close RC shot should open Backpack")
			_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "album close RC shot should open Album from Backpack")
			_press(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "album close RC shot should close Album")
		"settings_default":
			_press(main.find_child("SettingsButton", true, false) as Button, "settings RC shot should open Settings")
		"settings_rest_confirm":
			_press(main.find_child("SettingsButton", true, false) as Button, "settings rest RC shot should open Settings")
			_press(main.find_child("RequestRestButton", true, false) as Button, "settings RC shot should show rest confirm")
		"settings_safe_place":
			main.move_player_to_cell(Vector2i(24, 9))
			_press(main.find_child("SettingsButton", true, false) as Button, "settings safe RC shot should open Settings")
			_press(main.find_child("SafePlaceButton", true, false) as Button, "settings safe RC shot should return to safe place")
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
