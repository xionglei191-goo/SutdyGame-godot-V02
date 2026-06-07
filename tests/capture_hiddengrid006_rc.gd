extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")

const SAVE_PATH := "user://capture_hiddengrid006_rc.json"
const OUTPUT_DIR := "res://docs/collaboration/round112_hiddengrid006_rc"
const SHOTS := [
	{"id": "town", "file": "shot_round112_hiddengrid006_town_1280.png"},
	{"id": "outdoor_decor", "file": "shot_round112_hiddengrid006_outdoor_decor_1280.png"},
	{"id": "home", "file": "shot_round112_hiddengrid006_home_1280.png"},
	{"id": "shop", "file": "shot_round112_hiddengrid006_shop_1280.png"},
	{"id": "album", "file": "shot_round112_hiddengrid006_album_1280.png"},
	{"id": "settings", "file": "shot_round112_hiddengrid006_settings_1280.png"},
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
		print("HIDDENGRID-006 RC screenshots captured: %s" % OUTPUT_DIR)
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _prepare_scene() -> void:
	var save_service = SaveServiceScript.new(SAVE_PATH)
	save_service.clear_for_test()
	var inventory = InventoryServiceScript.new(save_service)
	inventory.collect_item("flower_pot", 1)
	inventory.collect_item("wooden_chair", 1)
	main = MainScene.instantiate()
	main.configure_for_test(SAVE_PATH)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(int(state.get("coins", 0)), 18)
	main.save_service.save_game_state(state)
	main.place_home_item("wooden_chair", Vector2i(2, 2))
	main.place_outdoor_item("flower_pot", Vector2i(32, 21))


func _prepare_shot(shot_id: String) -> void:
	if main == null:
		_fail("Main scene missing for shot: %s" % shot_id)
		return
	main.close_memory_album()
	main.close_settings_panel()
	main.close_shop_panel()
	main.show_town_view()
	match shot_id:
		"town":
			main.move_player_to_cell(Vector2i(31, 19))
		"outdoor_decor":
			main.move_player_to_cell(Vector2i(32, 21))
		"home":
			main.show_home_view()
		"shop":
			main.move_player_to_cell(Vector2i(41, 11))
			main.open_shop_panel()
		"album":
			main.open_memory_album()
		"settings":
			main.open_settings_panel()
		_:
			_fail("Unknown shot id: %s" % shot_id)


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
