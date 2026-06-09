extends SceneTree

const ATLAS_PATH := "res://assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_sheet_v002.png"
const OUTPUT_PATH := "res://docs/collaboration/round169_visual_rebuild_same_type_img2img_batches/tree_pipeline_test_v001/round169_tree_godot_preview_1280x720_v002.png"

const VIEW_SIZE := Vector2i(1280, 720)
const CELL_SIZE := Vector2i(256, 320)
const GRID_COLUMNS := 3
const GRID_ROWS := 2
const PIVOT := Vector2i(128, 300)
const DISPLAY_SCALE := 0.60


func _init() -> void:
	var atlas_texture := load(ATLAS_PATH) as Texture2D
	if atlas_texture == null:
		push_error("Failed to load atlas: %s" % ATLAS_PATH)
		quit(1)
		return
	var atlas := atlas_texture.get_image()
	if atlas == null:
		push_error("Failed to read atlas image: %s" % ATLAS_PATH)
		quit(1)
		return

	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	_draw_background(canvas)
	_draw_tree_rows(canvas, atlas)

	var save_error := canvas.save_png(OUTPUT_PATH)
	if save_error != OK:
		push_error("Failed to save preview: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round169 tree Godot preview: %s" % OUTPUT_PATH)
	quit()


func _draw_background(canvas: Image) -> void:
	canvas.fill(Color("#9dd394"))
	for y in range(0, VIEW_SIZE.y, 40):
		var color := Color("#90c788") if int(y / 40) % 2 == 0 else Color("#a8d99d")
		canvas.fill_rect(Rect2i(0, y, VIEW_SIZE.x, 40), color)

	for offset in range(-72, 128, 28):
		_draw_line(canvas, Vector2i(0, 548 + offset), Vector2i(VIEW_SIZE.x - 1, 608 + offset), Color(0.73, 0.63, 0.42, 0.42), 8)


func _draw_tree_rows(canvas: Image, atlas: Image) -> void:
	var baseline_y := 520
	_draw_line(canvas, Vector2i(64, baseline_y), Vector2i(1216, baseline_y), Color(0.86, 0.22, 0.18, 0.72), 2)

	var positions := [
		Vector2i(180, baseline_y),
		Vector2i(360, baseline_y),
		Vector2i(540, baseline_y),
		Vector2i(720, baseline_y),
		Vector2i(900, baseline_y),
		Vector2i(1080, baseline_y),
	]

	for index in range(6):
		var column := index % GRID_COLUMNS
		var row := int(index / GRID_COLUMNS)
		var source_rect := Rect2i(column * CELL_SIZE.x, row * CELL_SIZE.y, CELL_SIZE.x, CELL_SIZE.y)
		var sprite := atlas.get_region(source_rect)
		var draw_size := Vector2i(roundi(CELL_SIZE.x * DISPLAY_SCALE), roundi(CELL_SIZE.y * DISPLAY_SCALE))
		sprite.resize(draw_size.x, draw_size.y, Image.INTERPOLATE_LANCZOS)

		var pivot := Vector2i(roundi(PIVOT.x * DISPLAY_SCALE), roundi(PIVOT.y * DISPLAY_SCALE))
		var origin: Vector2i = positions[index] - pivot
		canvas.blend_rect(sprite, Rect2i(Vector2i.ZERO, draw_size), origin)
		_draw_pivot(canvas, positions[index])


func _draw_pivot(canvas: Image, center: Vector2i) -> void:
	_draw_line(canvas, center - Vector2i(7, 0), center + Vector2i(7, 0), Color("#181818"), 2)
	_draw_line(canvas, center - Vector2i(0, 7), center + Vector2i(0, 7), Color("#181818"), 2)
	for y in range(center.y - 4, center.y + 5):
		for x in range(center.x - 4, center.x + 5):
			if center.distance_to(Vector2i(x, y)) <= 4.0:
				_set_pixel_safe(canvas, x, y, Color("#ffe640"))


func _draw_line(canvas: Image, start: Vector2i, end: Vector2i, color: Color, width: int) -> void:
	var delta := end - start
	var steps := maxi(abs(delta.x), abs(delta.y))
	if steps == 0:
		_set_pixel_safe(canvas, start.x, start.y, color)
		return

	for step in range(steps + 1):
		var t := float(step) / float(steps)
		var point := Vector2i(roundi(lerpf(start.x, end.x, t)), roundi(lerpf(start.y, end.y, t)))
		for oy in range(-int(width / 2), int(width / 2) + 1):
			for ox in range(-int(width / 2), int(width / 2) + 1):
				_set_pixel_safe(canvas, point.x + ox, point.y + oy, color)


func _set_pixel_safe(canvas: Image, x: int, y: int, color: Color) -> void:
	if x < 0 or y < 0 or x >= VIEW_SIZE.x or y >= VIEW_SIZE.y:
		return
	canvas.set_pixel(x, y, color)
