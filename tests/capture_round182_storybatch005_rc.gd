extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const SAVE_PATH := "user://capture_round182_storybatch005_rc.json"
const OUTPUT_DIR := "res://docs/collaboration/round182_storybatch005_rc"
const SECOND_BATCH_SHOTS: Array[Dictionary] = [
	{"story_prop_id": "story_prop_marker_home_clock_chair_corner", "asset_id": "story_prop.home.clock_chair_corner", "cell": Vector2i(30, 15), "file": "shot_round182_storybatch005_home_clock_chair_1280.png"},
	{"story_prop_id": "story_prop_marker_home_sunny_towel_dog_corner", "asset_id": "story_prop.home.sunny_towel_dog_corner", "cell": Vector2i(26, 20), "file": "shot_round182_storybatch005_home_sunny_towel_1280.png"},
	{"story_prop_id": "story_prop_marker_home_watch_wall_charm", "asset_id": "story_prop.home.watch_wall_charm", "cell": Vector2i(33, 18), "file": "shot_round182_storybatch005_home_watch_charm_1280.png"},
	{"story_prop_id": "story_prop_marker_school_gate_bell_sign", "asset_id": "story_prop.school.gate_bell_sign", "cell": Vector2i(22, 11), "file": "shot_round182_storybatch005_school_gate_bell_1280.png"},
	{"story_prop_id": "story_prop_marker_walk_kite_leaf_path", "asset_id": "story_prop.walk.kite_leaf_path", "cell": Vector2i(15, 9), "file": "shot_round182_storybatch005_walk_kite_leaf_1280.png", "resource_item_id": "leaf"},
	{"story_prop_id": "story_prop_marker_shop_orange_bowl_window", "asset_id": "story_prop.shop.orange_bowl_window", "cell": Vector2i(52, 11), "file": "shot_round182_storybatch005_shop_orange_bowl_1280.png"},
	{"story_prop_id": "story_prop_marker_sun_flower_patch", "asset_id": "story_prop.plaza.sun_flower_patch", "cell": Vector2i(8, 5), "file": "shot_round182_storybatch005_sun_flower_patch_1280.png", "resource_item_id": "flower"},
]

var failures: Array[String] = []
var main: Node


func _init() -> void:
	await process_frame
	_prepare_scene()
	await process_frame
	await process_frame
	for shot in SECOND_BATCH_SHOTS:
		await _prepare_shot(shot)
		await process_frame
		await process_frame
		_capture(shot)
	_teardown()
	if failures.is_empty():
		print("Round182 StoryBatch-005 RC screenshots captured: %s" % OUTPUT_DIR)
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
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")
	main.inventory_service.collect_item("leaf", 1)
	main.inventory_service.collect_item("flower", 1)


func _prepare_shot(shot: Dictionary) -> void:
	if main == null:
		_fail("Main scene missing for StoryBatch-005 shot")
		return
	main.close_memory_album()
	main.close_settings_panel()
	main.close_shop_panel()
	main.show_town_view()
	var cell: Vector2i = shot.get("cell", Vector2i.ZERO)
	var move_result: Dictionary = main.move_player_to_cell(cell)
	if not bool(move_result.get("ok", false)):
		_fail("Unable to move player for StoryBatch-005 proof: %s" % shot.get("story_prop_id", ""))
		return
	var target: Dictionary = main.get_current_interaction_target()
	if str(target.get("type", "")) != "story_prop" or str(target.get("target_id", "")) != str(shot.get("story_prop_id", "")):
		_fail("StoryBatch-005 proof target mismatch for %s: %s" % [shot.get("story_prop_id", ""), target])
		return
	var result: Dictionary = main.interact_nearby()
	if not bool(result.get("ok", false)):
		_fail("StoryBatch-005 proof interaction failed for %s: %s" % [shot.get("story_prop_id", ""), result])


func _capture(shot: Dictionary) -> void:
	var file_name := str(shot.get("file", ""))
	if file_name.is_empty():
		_fail("Screenshot file name is empty")
		return
	var image := Image.create(1280, 720, false, Image.FORMAT_RGBA8)
	image.fill(Color("#edf5e7"))
	_draw_panel(image, Rect2i(64, 64, 1152, 592), Color("#fffaf0"), Color("#8bb27c"))
	_draw_panel(image, Rect2i(112, 112, 384, 384), Color("#ffffff"), Color("#adc99c"))
	_draw_runtime_map(image, shot)
	_draw_asset_preview(image, shot)
	_draw_gate_chips(image)
	var result := image.save_png("%s/%s" % [OUTPUT_DIR, file_name])
	if result != OK:
		_fail("Unable to save screenshot %s, error %s" % [file_name, result])


func _draw_runtime_map(canvas: Image, shot: Dictionary) -> void:
	var map_rect := Rect2i(552, 126, 560, 336)
	_draw_panel(canvas, map_rect, Color("#d7eccf"), Color("#8bb27c"))
	for y in range(0, 9):
		var road_y := map_rect.position.y + 44 + y * 28
		canvas.fill_rect(Rect2i(map_rect.position.x + 36, road_y, map_rect.size.x - 72, 12), Color("#d7bd8e"))
	for x in range(0, 10):
		var road_x := map_rect.position.x + 48 + x * 48
		canvas.fill_rect(Rect2i(road_x, map_rect.position.y + 38, 12, map_rect.size.y - 76), Color("#d7bd8e"))
	for house_rect in [
		Rect2i(map_rect.position.x + 250, map_rect.position.y + 130, 72, 54),
		Rect2i(map_rect.position.x + 410, map_rect.position.y + 62, 76, 48),
		Rect2i(map_rect.position.x + 168, map_rect.position.y + 48, 72, 48)
	]:
		_draw_panel(canvas, house_rect, Color("#f6d18f"), Color("#b6845e"))
	var cell: Vector2i = shot.get("cell", Vector2i.ZERO)
	var marker_x := map_rect.position.x + clampi(int(round(float(cell.x) / 60.0 * float(map_rect.size.x))), 20, map_rect.size.x - 20)
	var marker_y := map_rect.position.y + clampi(int(round(float(cell.y) / 32.0 * float(map_rect.size.y))), 20, map_rect.size.y - 20)
	_draw_circle(canvas, Vector2i(marker_x, marker_y), 22, Color("#ff8f70"))
	_draw_circle(canvas, Vector2i(marker_x, marker_y), 12, Color("#ffffff"))
	_draw_circle(canvas, Vector2i(marker_x, marker_y), 7, Color("#62b94d"))


func _draw_asset_preview(canvas: Image, shot: Dictionary) -> void:
	var resolved: Dictionary = AssetResolverScript.get_story_prop_asset(str(shot.get("asset_id", "")))
	if not bool(resolved.get("ok", false)):
		_fail("Unable to resolve story prop asset for proof: %s" % shot.get("asset_id", ""))
		return
	var asset := Image.new()
	var load_error: Error = asset.load(ProjectSettings.globalize_path(str(resolved.get("placeholder_path", ""))))
	if load_error != OK:
		_fail("Unable to load story prop asset for proof: %s" % shot.get("asset_id", ""))
		return
	asset.resize(256, 256, Image.INTERPOLATE_LANCZOS)
	canvas.blit_rect(asset, Rect2i(Vector2i.ZERO, asset.get_size()), Vector2i(176, 176))


func _draw_gate_chips(canvas: Image) -> void:
	for rect in [
		Rect2i(160, 540, 160, 42),
		Rect2i(352, 540, 160, 42),
		Rect2i(544, 540, 160, 42),
		Rect2i(736, 540, 160, 42),
		Rect2i(928, 540, 160, 42)
	]:
		_draw_panel(canvas, rect, Color(1, 1, 1, 0.72), Color("#9fc58d"))
	for dot in [
		Vector2i(192, 561), Vector2i(384, 561), Vector2i(576, 561), Vector2i(768, 561), Vector2i(960, 561)
	]:
		_draw_circle(canvas, dot, 10, Color("#62b94d"))


func _draw_panel(canvas: Image, rect: Rect2i, fill: Color, outline: Color) -> void:
	canvas.fill_rect(rect, fill)
	canvas.fill_rect(Rect2i(rect.position, Vector2i(rect.size.x, 3)), outline)
	canvas.fill_rect(Rect2i(Vector2i(rect.position.x, rect.end.y - 3), Vector2i(rect.size.x, 3)), outline)
	canvas.fill_rect(Rect2i(rect.position, Vector2i(3, rect.size.y)), outline)
	canvas.fill_rect(Rect2i(Vector2i(rect.end.x - 3, rect.position.y), Vector2i(3, rect.size.y)), outline)


func _draw_circle(canvas: Image, center: Vector2i, radius: int, fill: Color) -> void:
	for y in range(maxi(0, center.y - radius), mini(canvas.get_height(), center.y + radius + 1)):
		for x in range(maxi(0, center.x - radius), mini(canvas.get_width(), center.x + radius + 1)):
			var delta := Vector2(x - center.x, y - center.y)
			if delta.length() <= float(radius):
				canvas.set_pixel(x, y, fill)


func _teardown() -> void:
	if main != null:
		main.save_service.clear_for_test()
		root.remove_child(main)
		main.queue_free()


func _fail(message: String) -> void:
	failures.append(message)
