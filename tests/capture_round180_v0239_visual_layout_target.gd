extends SceneTree

const OUTPUT_DIR := "res://docs/collaboration/round180_v0239_mainline_visual_layout_target"
const TARGET_PNG := OUTPUT_DIR + "/round180_v0239_visual_layout_target_1280x720_v001.png"
const CONTRACT_JSON := OUTPUT_DIR + "/visual_layout_contract_v001.json"
const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	var output_dir_abs: String = ProjectSettings.globalize_path(OUTPUT_DIR)
	var contract_path_abs: String = ProjectSettings.globalize_path(CONTRACT_JSON)
	var target_png_abs: String = ProjectSettings.globalize_path(TARGET_PNG)
	DirAccess.make_dir_recursive_absolute(output_dir_abs)
	if not FileAccess.file_exists(contract_path_abs):
		push_error("Missing Round180 visual layout contract: %s" % CONTRACT_JSON)
		quit(1)
		return
	var contract_file: FileAccess = FileAccess.open(contract_path_abs, FileAccess.READ)
	if contract_file == null:
		push_error("Failed to open Round180 visual layout contract: %s" % CONTRACT_JSON)
		quit(1)
		return
	var contract_result: Variant = JSON.parse_string(contract_file.get_as_text())
	if typeof(contract_result) != TYPE_DICTIONARY:
		push_error("Round180 visual layout contract must be valid JSON: %s" % CONTRACT_JSON)
		quit(1)
		return
	var contract: Dictionary = contract_result
	var target_viewport: Dictionary = contract.get("target_viewport", {})
	if int(target_viewport.get("w", 0)) != VIEW_SIZE.x or int(target_viewport.get("h", 0)) != VIEW_SIZE.y:
		push_error("Round180 visual layout contract viewport mismatch: %s" % CONTRACT_JSON)
		quit(1)
		return
	if str(contract.get("target_frame_output", "")) != TARGET_PNG.replace("res://", ""):
		push_error("Round180 visual layout contract output mismatch: %s" % CONTRACT_JSON)
		quit(1)
		return
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	_draw_target_frame(canvas)
	var image_error: Error = canvas.save_png(target_png_abs)
	if image_error != OK:
		push_error("Failed to save Round180 target frame: %s" % TARGET_PNG)
		quit(1)
		return
	print("Saved Round180 V02.39 target frame: %s" % TARGET_PNG)
	print("Using Round180 V02.39 visual layout contract: %s" % CONTRACT_JSON)
	quit()


func _draw_target_frame(canvas: Image) -> void:
	canvas.fill(Color("#96d485"))
	_draw_sky_band(canvas)
	_draw_depth_bands(canvas)
	_draw_region(canvas, Rect2i(0, 84, 1280, 536), Color("#92d37c"))
	_draw_region(canvas, Rect2i(0, 520, 1280, 200), Color("#78c96f"))
	_draw_water(canvas)
	_draw_paths(canvas)
	_draw_school_hint(canvas)
	_draw_shop_hint(canvas)
	_draw_home_cluster(canvas)
	_draw_fences_and_garden(canvas)
	_draw_trees(canvas)
	_draw_props(canvas)
	_draw_actor_and_companion(canvas)
	_draw_glass_ui(canvas)


func _draw_sky_band(canvas: Image) -> void:
	canvas.fill_rect(Rect2i(0, 0, 1280, 74), Color("#b9e5ef"))
	_draw_ellipse(canvas, Rect2i(52, 18, 156, 34), Color(1, 1, 1, 0.38))
	_draw_ellipse(canvas, Rect2i(930, 16, 180, 36), Color(1, 1, 1, 0.30))


func _draw_depth_bands(canvas: Image) -> void:
	_draw_ellipse(canvas, Rect2i(86, 96, 320, 92), Color("#83c873"))
	_draw_ellipse(canvas, Rect2i(760, 96, 370, 92), Color("#82c36f"))
	_draw_ellipse(canvas, Rect2i(82, 452, 410, 110), Color("#79c46d"))
	_draw_ellipse(canvas, Rect2i(702, 444, 350, 104), Color("#78c76f"))


func _draw_region(canvas: Image, rect: Rect2i, color: Color) -> void:
	canvas.fill_rect(rect, color)
	for y in range(rect.position.y + 18, rect.end.y, 42):
		for x in range(rect.position.x + 20, rect.end.x, 48):
			if int(x / 48 + y / 42) % 3 == 0:
				_draw_ellipse(canvas, Rect2i(x, y, 34, 16), Color(1, 1, 1, 0.05))


func _draw_water(canvas: Image) -> void:
	var water := Color("#5fb8d8")
	canvas.fill_rect(Rect2i(1028, 520, 252, 200), water)
	_draw_ellipse(canvas, Rect2i(948, 506, 210, 72), water)
	_draw_ellipse(canvas, Rect2i(922, 568, 250, 84), water)
	_draw_ellipse(canvas, Rect2i(1040, 502, 188, 42), Color("#e0f1d0"))
	_draw_ellipse(canvas, Rect2i(972, 556, 154, 36), Color("#e0f1d0"))
	_draw_ellipse(canvas, Rect2i(1090, 614, 84, 22), Color(1, 1, 1, 0.20))
	_draw_ellipse(canvas, Rect2i(1034, 582, 62, 24), Color("#75c67c"))


func _draw_paths(canvas: Image) -> void:
	var path := Color("#e7cf98")
	_draw_thick_line(canvas, Vector2i(116, 538), Vector2i(328, 454), 60, path)
	_draw_thick_line(canvas, Vector2i(328, 454), Vector2i(510, 402), 64, path)
	_draw_thick_line(canvas, Vector2i(510, 402), Vector2i(692, 420), 64, path)
	_draw_thick_line(canvas, Vector2i(692, 420), Vector2i(918, 522), 62, path)
	_draw_thick_line(canvas, Vector2i(520, 400), Vector2i(548, 286), 54, path)
	_draw_thick_line(canvas, Vector2i(690, 418), Vector2i(760, 288), 46, path)
	for pos in [Vector2i(300, 492), Vector2i(456, 426), Vector2i(626, 420), Vector2i(788, 470), Vector2i(532, 338)]:
		_draw_ellipse(canvas, Rect2i(pos.x - 8, pos.y - 4, 16, 8), Color("#c9a96e"))


func _draw_school_hint(canvas: Image) -> void:
	_draw_soft_shadow(canvas, Rect2i(522, 150, 230, 48))
	_draw_rect(canvas, Rect2i(532, 120, 208, 106), Color("#f0d69f"), Color("#ba9861"))
	_draw_rect(canvas, Rect2i(512, 104, 248, 36), Color("#5aa1c8"), Color("#3d7fa0"))
	_draw_rect(canvas, Rect2i(606, 174, 58, 52), Color("#9a7248"), Color("#745232"))
	_draw_rect(canvas, Rect2i(552, 152, 36, 28), Color("#bfe8f2"), Color("#6899a7"))
	_draw_rect(canvas, Rect2i(694, 152, 36, 28), Color("#bfe8f2"), Color("#6899a7"))
	_draw_rect(canvas, Rect2i(500, 228, 270, 28), Color("#e7e0c8"), Color("#b7ab87"))
	_draw_ellipse(canvas, Rect2i(438, 248, 390, 116), Color("#84ca72"))


func _draw_shop_hint(canvas: Image) -> void:
	_draw_soft_shadow(canvas, Rect2i(138, 268, 212, 44))
	_draw_rect(canvas, Rect2i(154, 214, 178, 96), Color("#f3ba74"), Color("#b17b45"))
	_draw_rect(canvas, Rect2i(138, 198, 210, 34), Color("#e97e68"), Color("#a65449"))
	_draw_rect(canvas, Rect2i(168, 232, 150, 22), Color("#fff0ba"), Color("#d9b96d"))
	_draw_rect(canvas, Rect2i(224, 262, 42, 48), Color("#8c6849"), Color("#65462f"))
	_draw_ellipse(canvas, Rect2i(76, 322, 318, 84), Color("#84ca72"))


func _draw_home_cluster(canvas: Image) -> void:
	_draw_soft_shadow(canvas, Rect2i(468, 348, 282, 62))
	_draw_rect(canvas, Rect2i(504, 270, 198, 134), Color("#f5d7a1"), Color("#b78854"))
	_draw_rect(canvas, Rect2i(488, 238, 232, 66), Color("#d66b3e"), Color("#9a472d"))
	_draw_rect(canvas, Rect2i(566, 344, 58, 60), Color("#8d603f"), Color("#66462e"))
	_draw_rect(canvas, Rect2i(522, 314, 44, 36), Color("#bee2ed"), Color("#6b98a8"))
	_draw_rect(canvas, Rect2i(642, 314, 44, 36), Color("#bee2ed"), Color("#6b98a8"))
	_draw_rect(canvas, Rect2i(540, 406, 112, 26), Color("#d8b27a"), Color("#a0774f"))
	_draw_rect(canvas, Rect2i(642, 210, 26, 44), Color("#ca8f5b"), Color("#8e6040"))
	_draw_ellipse(canvas, Rect2i(520, 292, 44, 34), Color(1, 1, 1, 0.12))


func _draw_fences_and_garden(canvas: Image) -> void:
	for x in range(420, 786, 36):
		_draw_rect(canvas, Rect2i(x, 436, 24, 44), Color("#f4f0d0"), Color("#b5aa78"))
	_draw_rect(canvas, Rect2i(420, 452, 378, 12), Color("#f4f0d0"), Color("#b5aa78"))
	for rect in [Rect2i(734, 332, 116, 54), Rect2i(810, 386, 112, 50), Rect2i(356, 342, 82, 44)]:
		_draw_rect(canvas, rect, Color("#b78050"), Color("#81573a"))
		for x in range(rect.position.x + 12, rect.end.x - 8, 24):
			_draw_ellipse(canvas, Rect2i(x, rect.position.y + 8, 14, 26), Color("#78c95f"))
	for flower in [Vector2i(440, 394), Vector2i(474, 386), Vector2i(734, 390), Vector2i(872, 442), Vector2i(360, 396)]:
		_draw_flower(canvas, flower)


func _draw_trees(canvas: Image) -> void:
	for tree in [
		{"p": Vector2i(258, 426), "s": 1.10},
		{"p": Vector2i(846, 272), "s": 1.05},
		{"p": Vector2i(946, 366), "s": 1.00},
		{"p": Vector2i(384, 250), "s": 0.94},
	]:
		var tree_position: Vector2i = tree["p"]
		var tree_scale: float = tree["s"]
		_draw_tree(canvas, tree_position, tree_scale)


func _draw_props(canvas: Image) -> void:
	_draw_rect(canvas, Rect2i(648, 410, 30, 46), Color("#d55d48"), Color("#8e3b30"))
	_draw_rect(canvas, Rect2i(642, 398, 42, 14), Color("#f4d38a"), Color("#9a7450"))
	_draw_ellipse(canvas, Rect2i(446, 316, 38, 30), Color("#f2b24c"), Color("#b87334"))
	_draw_rect(canvas, Rect2i(452, 344, 28, 24), Color("#bd8b55"), Color("#805c39"))
	_draw_ellipse(canvas, Rect2i(686, 354, 46, 28), Color("#efdf8c"), Color("#ae9453"))
	_draw_ellipse(canvas, Rect2i(704, 348, 26, 18), Color("#8fc86c"), Color("#5d984f"))


func _draw_actor_and_companion(canvas: Image) -> void:
	_draw_soft_shadow(canvas, Rect2i(574, 486, 52, 16))
	_draw_ellipse(canvas, Rect2i(584, 430, 28, 30), Color("#f0c28d"), Color("#956443"))
	_draw_rect(canvas, Rect2i(578, 458, 38, 48), Color("#5d8fd4"), Color("#3a6095"))
	_draw_rect(canvas, Rect2i(582, 504, 12, 20), Color("#7a4f32"), Color("#4f3425"))
	_draw_rect(canvas, Rect2i(604, 504, 12, 20), Color("#7a4f32"), Color("#4f3425"))
	_draw_soft_shadow(canvas, Rect2i(642, 504, 54, 14))
	_draw_ellipse(canvas, Rect2i(646, 472, 48, 34), Color("#f2a33e"), Color("#a65d2c"))
	_draw_ellipse(canvas, Rect2i(640, 462, 18, 20), Color("#f2a33e"), Color("#a65d2c"))
	_draw_ellipse(canvas, Rect2i(680, 462, 18, 20), Color("#f2a33e"), Color("#a65d2c"))
	_draw_ellipse(canvas, Rect2i(658, 476, 12, 10), Color("#fff3c4"))


func _draw_glass_ui(canvas: Image) -> void:
	for rect in [
		Rect2i(28, 24, 126, 52),
		Rect2i(174, 24, 126, 52),
		Rect2i(320, 24, 126, 52),
		Rect2i(466, 24, 126, 52),
	]:
		_draw_rounded_rect(canvas, rect, 24, Color(1, 1, 1, 0.70), Color(1, 1, 1, 0.34))
	_draw_ellipse(canvas, Rect2i(64, 38, 26, 26), Color("#ffd45e"), Color("#d9a23e"))
	_draw_ellipse(canvas, Rect2i(208, 38, 26, 26), Color("#f48578"), Color("#bd5e56"))
	_draw_ellipse(canvas, Rect2i(354, 38, 26, 26), Color("#f5c552"), Color("#bd8f34"))
	_draw_ellipse(canvas, Rect2i(500, 38, 26, 26), Color("#74c68a"), Color("#4c9660"))
	_draw_rounded_rect(canvas, Rect2i(332, 628, 616, 76), 32, Color(1, 1, 1, 0.54), Color(1, 1, 1, 0.26))
	for i in range(5):
		var x := 384 + i * 112
		_draw_rounded_rect(canvas, Rect2i(x, 642, 58, 48), 18, Color(1, 1, 1, 0.64), Color(1, 1, 1, 0.30))
		_draw_ellipse(canvas, Rect2i(x + 17, 654, 24, 24), Color("#f0b85a"), Color("#b8863f"))


func _draw_tree(canvas: Image, base: Vector2i, scale: float) -> void:
	_draw_soft_shadow(canvas, Rect2i(base.x - 42, base.y + 28, 84, 20))
	_draw_rect(canvas, Rect2i(base.x - roundi(8 * scale), base.y, roundi(16 * scale), roundi(48 * scale)), Color("#9b6a3e"), Color("#69462e"))
	for offset in [Vector2i(-30, -22), Vector2i(0, -34), Vector2i(30, -20), Vector2i(-10, 0), Vector2i(18, 3)]:
		_draw_ellipse(canvas, Rect2i(base.x + roundi(offset.x * scale) - roundi(34 * scale), base.y + roundi(offset.y * scale) - roundi(28 * scale), roundi(68 * scale), roundi(56 * scale)), Color("#62b94d"), Color("#428c3c"))


func _draw_flower(canvas: Image, center: Vector2i) -> void:
	for offset in [Vector2i(-6, 0), Vector2i(6, 0), Vector2i(0, -6), Vector2i(0, 6)]:
		_draw_ellipse(canvas, Rect2i(center.x + offset.x - 5, center.y + offset.y - 5, 10, 10), Color("#f5a6ad"))
	_draw_ellipse(canvas, Rect2i(center.x - 4, center.y - 4, 8, 8), Color("#ffd76a"))


func _draw_soft_shadow(canvas: Image, rect: Rect2i) -> void:
	_draw_ellipse(canvas, rect, Color(0.22, 0.18, 0.14, 0.18))


func _draw_rect(canvas: Image, rect: Rect2i, fill: Color, outline: Color = Color.TRANSPARENT) -> void:
	canvas.fill_rect(rect, fill)
	if outline.a > 0.0:
		canvas.fill_rect(Rect2i(rect.position, Vector2i(rect.size.x, 2)), outline)
		canvas.fill_rect(Rect2i(Vector2i(rect.position.x, rect.end.y - 2), Vector2i(rect.size.x, 2)), outline)
		canvas.fill_rect(Rect2i(rect.position, Vector2i(2, rect.size.y)), outline)
		canvas.fill_rect(Rect2i(Vector2i(rect.end.x - 2, rect.position.y), Vector2i(2, rect.size.y)), outline)


func _draw_rounded_rect(canvas: Image, rect: Rect2i, radius: int, fill: Color, outline: Color = Color.TRANSPARENT) -> void:
	var start_x := maxi(rect.position.x, 0)
	var end_x := mini(rect.end.x, canvas.get_width())
	var start_y := maxi(rect.position.y, 0)
	var end_y := mini(rect.end.y, canvas.get_height())
	for y in range(start_y, end_y):
		for x in range(start_x, end_x):
			var dx: int = maxi(maxi(rect.position.x + radius - x, 0), x - (rect.end.x - radius - 1))
			var dy: int = maxi(maxi(rect.position.y + radius - y, 0), y - (rect.end.y - radius - 1))
			if dx * dx + dy * dy <= radius * radius:
				canvas.set_pixel(x, y, fill)
	if outline.a > 0.0:
		_draw_rounded_rect_outline(canvas, rect, radius, outline)


func _draw_rounded_rect_outline(canvas: Image, rect: Rect2i, radius: int, color: Color) -> void:
	for x in range(rect.position.x + radius, rect.end.x - radius):
		_set_pixel_safe(canvas, x, rect.position.y, color)
		_set_pixel_safe(canvas, x, rect.end.y - 1, color)
	for y in range(rect.position.y + radius, rect.end.y - radius):
		_set_pixel_safe(canvas, rect.position.x, y, color)
		_set_pixel_safe(canvas, rect.end.x - 1, y, color)


func _set_pixel_safe(canvas: Image, x: int, y: int, color: Color) -> void:
	if x < 0 or y < 0 or x >= canvas.get_width() or y >= canvas.get_height():
		return
	canvas.set_pixel(x, y, color)


func _draw_ellipse(canvas: Image, rect: Rect2i, fill: Color, outline: Color = Color.TRANSPARENT) -> void:
	var rx: float = maxf(rect.size.x * 0.5, 1.0)
	var ry: float = maxf(rect.size.y * 0.5, 1.0)
	var cx: float = rect.position.x + rx
	var cy: float = rect.position.y + ry
	var start_x := maxi(rect.position.x, 0)
	var end_x := mini(rect.end.x, canvas.get_width())
	var start_y := maxi(rect.position.y, 0)
	var end_y := mini(rect.end.y, canvas.get_height())
	for y in range(start_y, end_y):
		for x in range(start_x, end_x):
			var value: float = pow((x - cx) / rx, 2.0) + pow((y - cy) / ry, 2.0)
			if value <= 1.0:
				canvas.set_pixel(x, y, fill)
			elif outline.a > 0.0 and value <= 1.10:
				canvas.set_pixel(x, y, outline)


func _draw_thick_line(canvas: Image, from_pos: Vector2i, to_pos: Vector2i, width: int, color: Color) -> void:
	var delta := Vector2(to_pos - from_pos)
	var steps: int = maxi(maxi(abs(to_pos.x - from_pos.x), abs(to_pos.y - from_pos.y)), 1)
	for i in range(steps + 1):
		var t := float(i) / float(steps)
		var center := Vector2(from_pos) + delta * t
		_draw_ellipse(canvas, Rect2i(roundi(center.x - width * 0.5), roundi(center.y - width * 0.5), width, width), color)
