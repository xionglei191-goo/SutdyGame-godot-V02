extends SceneTree

const MainScene := preload("res://scenes/main.tscn")

const DEFAULT_SAVE_PATH := "user://artbase005_capture_save.json"
const DEFAULT_DAY_KEY := "2026-06-05"

var _main
var _output_dir := ""
var _suffix := "1280"


func _init() -> void:
	var args: Dictionary = _parse_args(OS.get_cmdline_user_args())
	_output_dir = str(args.get("output_dir", ""))
	_suffix = str(args.get("suffix", "1280"))
	if _output_dir.is_empty():
		push_error("capture_artbase005_screens.gd requires --output-dir <absolute_or_relative_path>")
		quit(1)
		return

	_output_dir = _normalize_output_dir(_output_dir)
	var mkdir_error: int = DirAccess.make_dir_recursive_absolute(_output_dir)
	if mkdir_error != OK:
		push_error("Unable to create output directory: %s" % _output_dir)
		quit(1)
		return

	await _boot_main()
	await _capture_town()
	await _capture_shop()
	await _capture_home()
	await _capture_anchor("clock", Vector2i(7, 3))
	await _capture_anchor("orange", Vector2i(23, 5))
	await _capture_anchor("sun", Vector2i(17, 2))
	await _capture_npc("mina", Vector2i(14, 10))
	await _capture_npc("shopkeeper", Vector2i(24, 10))
	await _capture_npc("sunny", Vector2i(6, 8))
	quit(0)


func _parse_args(args: Array) -> Dictionary:
	var parsed: Dictionary = {}
	var index: int = 0
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
	_main.configure_for_test(DEFAULT_SAVE_PATH)
	_main.set_day_key_for_test(DEFAULT_DAY_KEY)
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
		"small_table": 1,
		"pet_bowl": 1,
		"sunny_bed": 1,
	}
	game_state["pet"] = {
		"pet_id": "sunny_dog",
		"hunger": 1,
		"food_count": 0,
		"happy": 2,
	}
	game_state["current_place_id"] = "place_town_start"
	_main.save_service.save_game_state(game_state)


func _capture_town() -> void:
	_main.show_town_view()
	_main.move_player_to_cell(Vector2i(15, 10))
	_main._set_life_status("阳光小镇首屏：Home、Shop、主路、米娜和 Sunny 都在视线里。")
	await _settle_frames()
	_save_viewport_image("shot_artbase005_town_%s.png" % _suffix)


func _capture_shop() -> void:
	_main.show_town_view()
	_main.move_player_to_cell(Vector2i(24, 9))
	_main.interact_nearby()
	await _settle_frames()
	_save_viewport_image("shot_artbase005_shop_%s.png" % _suffix)


func _capture_home() -> void:
	_main.show_town_view()
	_main.home_decoration_service.place_furniture("small_table", Vector2i(0, 0))
	_main.home_decoration_service.place_furniture("pet_bowl", Vector2i(1, 3))
	_main.home_decoration_service.place_furniture("sunny_bed", Vector2i(3, 2))
	_main.show_home_view()
	await _settle_frames()
	_save_viewport_image("shot_artbase005_home_%s.png" % _suffix)


func _capture_anchor(anchor_key: String, cell: Vector2i) -> void:
	_main.show_town_view()
	_main.move_player_to_cell(cell)
	_main.interact_nearby()
	await _settle_frames()
	_save_viewport_image("shot_artbase005_anchor_%s_%s.png" % [anchor_key, _suffix])


func _capture_npc(npc_key: String, cell: Vector2i) -> void:
	_main.show_town_view()
	_main.move_player_to_cell(cell)
	_main.interact_nearby()
	await _settle_frames()
	_save_viewport_image("shot_artbase005_npc_%s_%s.png" % [npc_key, _suffix])


func _settle_frames(count: int = 3) -> void:
	for _index in range(count):
		await process_frame


func _save_viewport_image(file_name: String) -> void:
	var viewport_texture := root.get_texture()
	if viewport_texture == null:
		push_error("ARTBASE005_CAPTURE_BLOCKED: headless dummy renderer does not expose a viewport texture. Use MCP or a non-headless display path for screenshot evidence.")
		quit(2)
		return
	var image: Image = viewport_texture.get_image()
	if image == null:
		push_error("ARTBASE005_CAPTURE_BLOCKED: viewport image is unavailable under the current renderer. Use MCP or a non-headless display path for screenshot evidence.")
		quit(2)
		return
	var file_path: String = _output_dir.path_join(file_name)
	var save_error: int = image.save_png(file_path)
	if save_error != OK:
		push_error("Failed to save screenshot: %s" % file_path)
		quit(1)
		return
	print("CAPTURED %s %sx%s" % [file_name, image.get_width(), image.get_height()])
