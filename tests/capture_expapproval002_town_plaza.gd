extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const SAVE_PATH := "user://capture_expapproval002_town_plaza.json"
const OUTPUT_DIR := "res://docs/collaboration/round115_expapproval002_town_plaza"
const SHOTS := [
	{"id": "first_screen", "file": "shot_round115_expapproval002_town_plaza_first_screen_1280.png"},
	{"id": "mina_resource_anchor", "file": "shot_round115_expapproval002_town_plaza_mina_resource_anchor_1280.png"},
	{"id": "footer_prompt", "file": "shot_round115_expapproval002_town_plaza_footer_prompt_1280.png"},
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
		print("EXPAPPROVAL-002 Town Plaza screenshots captured: %s" % OUTPUT_DIR)
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _prepare_scene() -> void:
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
		"first_screen":
			main.move_player_to_cell(Vector2i(31, 19))
		"mina_resource_anchor":
			main.move_player_to_cell(Vector2i(38, 22))
			main.get_current_interaction_target()
		"footer_prompt":
			main.move_player_to_cell(Vector2i(34, 20))
			main.get_current_interaction_target()
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
