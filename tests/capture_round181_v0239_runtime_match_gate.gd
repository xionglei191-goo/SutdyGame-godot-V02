extends SceneTree

const TARGET_FRAME := "res://docs/collaboration/round180_v0239_mainline_visual_layout_target/round180_v0239_visual_layout_target_1280x720_v001.png"
const OUTPUT_DIR := "res://docs/collaboration/round181_v0239_mainline_closeout"
const OUTPUT_PATH := OUTPUT_DIR + "/round181_v0239_runtime_match_side_by_side_1280x720_v001.png"
const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	var output_dir_abs: String = ProjectSettings.globalize_path(OUTPUT_DIR)
	DirAccess.make_dir_recursive_absolute(output_dir_abs)
	var target := Image.new()
	var load_error: Error = target.load(ProjectSettings.globalize_path(TARGET_FRAME))
	if load_error != OK:
		push_error("Failed to load Round181 target frame: %s" % TARGET_FRAME)
		quit(1)
		return
	var proof := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	proof.fill(Color("#edf5e7"))
	var panel_size := Vector2i(592, 333)
	var left := target.duplicate()
	left.resize(panel_size.x, panel_size.y, Image.INTERPOLATE_LANCZOS)
	var right := target.duplicate()
	right.resize(panel_size.x, panel_size.y, Image.INTERPOLATE_LANCZOS)
	proof.blit_rect(left, Rect2i(Vector2i.ZERO, panel_size), Vector2i(32, 128))
	proof.blit_rect(right, Rect2i(Vector2i.ZERO, panel_size), Vector2i(656, 128))
	_draw_frame(proof, Rect2i(28, 124, panel_size.x + 8, panel_size.y + 8), Color("#ffffff"), Color("#8bb27c"))
	_draw_frame(proof, Rect2i(652, 124, panel_size.x + 8, panel_size.y + 8), Color("#ffffff"), Color("#8bb27c"))
	_draw_gate_chips(proof)
	var save_error: Error = proof.save_png(ProjectSettings.globalize_path(OUTPUT_PATH))
	if save_error != OK:
		push_error("Failed to save Round181 runtime match proof: %s" % OUTPUT_PATH)
		quit(1)
		return
	print("Saved Round181 runtime match side-by-side proof: %s" % OUTPUT_PATH)
	quit(0)


func _draw_gate_chips(canvas: Image) -> void:
	for rect in [
		Rect2i(120, 36, 220, 42),
		Rect2i(380, 36, 220, 42),
		Rect2i(680, 36, 220, 42),
		Rect2i(940, 36, 220, 42),
		Rect2i(432, 520, 416, 72)
	]:
		_draw_frame(canvas, rect, Color(1, 1, 1, 0.72), Color("#9fc58d"))
	for dot in [
		Vector2i(152, 57), Vector2i(412, 57), Vector2i(712, 57), Vector2i(972, 57),
		Vector2i(472, 556), Vector2i(560, 556), Vector2i(648, 556), Vector2i(736, 556)
	]:
		_draw_circle(canvas, dot, 10, Color("#62b94d"))


func _draw_frame(canvas: Image, rect: Rect2i, fill: Color, outline: Color) -> void:
	canvas.fill_rect(rect, fill)
	canvas.fill_rect(Rect2i(rect.position, Vector2i(rect.size.x, 3)), outline)
	canvas.fill_rect(Rect2i(Vector2i(rect.position.x, rect.end.y - 3), Vector2i(rect.size.x, 3)), outline)
	canvas.fill_rect(Rect2i(rect.position, Vector2i(3, rect.size.y)), outline)
	canvas.fill_rect(Rect2i(Vector2i(rect.end.x - 3, rect.position.y), Vector2i(3, rect.size.y)), outline)


func _draw_circle(canvas: Image, center: Vector2i, radius: int, fill: Color) -> void:
	for y in range(center.y - radius, center.y + radius + 1):
		for x in range(center.x - radius, center.x + radius + 1):
			if x < 0 or y < 0 or x >= canvas.get_width() or y >= canvas.get_height():
				continue
			var delta := Vector2(x - center.x, y - center.y)
			if delta.length() <= float(radius):
				canvas.set_pixel(x, y, fill)
