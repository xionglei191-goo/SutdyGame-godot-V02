extends SceneTree

const MainScene := preload("res://scenes/main.tscn")

var _main
var _output_dir := ""
var _suffix := "1280"


func _init() -> void:
	var args: Dictionary = _parse_args(OS.get_cmdline_user_args())
	_output_dir = str(args.get("output_dir", ""))
	_suffix = str(args.get("suffix", "1280"))
	if _output_dir.is_empty():
		push_error("capture_schooldaily005_screens.gd requires --output-dir <absolute_or_relative_path>")
		quit(1)
		return

	_output_dir = _normalize_output_dir(_output_dir)
	var mkdir_error: int = DirAccess.make_dir_recursive_absolute(_output_dir)
	if mkdir_error != OK:
		push_error("Unable to create output directory: %s" % _output_dir)
		quit(1)
		return

	await _boot_main()
	await _capture_day_001_gate()
	await _capture_day_003_yard()
	await _capture_day_007_return_home()
	await _capture_shop_home_safe_path()
	quit(0)


func _parse_args(args: Array) -> Dictionary:
	var parsed: Dictionary = {}
	var index := 0
	while index < args.size():
		var key := str(args[index])
		if key == "--output-dir" and index + 1 < args.size():
			parsed["output_dir"] = str(args[index + 1])
			index += 2
			continue
		if key == "--suffix" and index + 1 < args.size():
			parsed["suffix"] = str(args[index + 1])
			index += 2
			continue
		index += 1
	return parsed


func _normalize_output_dir(path: String) -> String:
	if path.begins_with("res://") or path.begins_with("user://"):
		return ProjectSettings.globalize_path(path)
	if path.is_absolute_path():
		return path
	return ProjectSettings.globalize_path("res://%s" % path)


func _boot_main() -> void:
	_main = MainScene.instantiate()
	_main.configure_for_test("user://schooldaily005_capture_save_%s.json" % _suffix)
	_main.set_day_key_for_test("local_day_001")
	root.add_child(_main)
	await process_frame
	if _main.save_service != null:
		_main.save_service.clear_for_test()
	_main.call("_ready")
	await _settle_frames()
	_seed_base_state()
	await _settle_frames()


func _seed_base_state() -> void:
	var game_state: Dictionary = _main.save_service.load_game_state()
	game_state["coins"] = 24
	game_state["inventory"] = {
		"branch": 1,
		"food_pet_snack": 2,
	}
	game_state["current_place_id"] = "place_town_start"
	_main.save_service.save_game_state(game_state)


func _capture_day_001_gate() -> void:
	_main.show_town_view()
	_main.set_day_key_for_test("local_day_001")
	_main.call("_update_today_status")
	_main.move_player_to_cell(Vector2i(11, 13))
	_main.interact_nearby()
	await _settle_frames()
	_save_viewport_image("shot_schooldaily005_day001_gate_%s.png" % _suffix)


func _capture_day_003_yard() -> void:
	_main.show_town_view()
	_main.set_day_key_for_test("local_day_003")
	_main.call("_update_today_status")
	_main.move_player_to_cell(Vector2i(11, 15))
	_main.interact_nearby()
	await _settle_frames()
	_save_viewport_image("shot_schooldaily005_day003_yard_%s.png" % _suffix)


func _capture_day_007_return_home() -> void:
	_main.show_town_view()
	_main.set_day_key_for_test("local_day_007")
	_main.call("_update_today_status")
	_main.move_player_to_cell(Vector2i(5, 8))
	_main.interact_nearby()
	await _settle_frames()
	_save_viewport_image("shot_schooldaily005_day007_return_%s.png" % _suffix)


func _capture_shop_home_safe_path() -> void:
	_main.show_town_view()
	_main.set_day_key_for_test("local_day_007")
	_main.call("_update_today_status")
	_main.move_player_to_cell(Vector2i(24, 9))
	_main.interact_nearby()
	await _settle_frames()
	_save_viewport_image("shot_schooldaily005_shop_%s.png" % _suffix)
	_main.show_home_view()
	await _settle_frames()
	_save_viewport_image("shot_schooldaily005_home_%s.png" % _suffix)


func _settle_frames(count: int = 3) -> void:
	for _index in range(count):
		await process_frame


func _save_viewport_image(file_name: String) -> void:
	var viewport_texture := root.get_texture()
	if viewport_texture == null:
		push_error("SCHOOLDAILY005_CAPTURE_BLOCKED: headless dummy renderer does not expose a viewport texture. Use MCP or a non-headless display path for screenshot evidence.")
		quit(2)
		return
	var image: Image = viewport_texture.get_image()
	if image == null:
		push_error("SCHOOLDAILY005_CAPTURE_BLOCKED: viewport image is unavailable under the current renderer. Use MCP or a non-headless display path for screenshot evidence.")
		quit(2)
		return
	var file_path := _output_dir.path_join(file_name)
	var save_error := image.save_png(file_path)
	if save_error != OK:
		push_error("Failed to save screenshot: %s" % file_path)
		quit(1)
		return
	print("CAPTURED %s %sx%s" % [file_name, image.get_width(), image.get_height()])
