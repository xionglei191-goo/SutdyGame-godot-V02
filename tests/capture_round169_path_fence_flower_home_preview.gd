extends SceneTree

const TREE_ATLAS_PATH := "res://assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_sheet_v002.png"
const PATH_ATLAS_PATH := "res://assets/art/visual_rebuild/round169/path/path_overlay_tiles_128x128_sheet_v002.png"
const FENCE_ATLAS_PATH := "res://assets/art/visual_rebuild/round169/fence/fence_segments_256x128_sheet_v002.png"
const FLOWER_ATLAS_PATH := "res://assets/art/visual_rebuild/round169/flower/flower_patches_192x160_sheet_v002.png"
const HOME_ATLAS_PATH := "res://assets/art/visual_rebuild/round169/home/home_components_320x256_sheet_v002.png"
const OUTPUT_PATH := "res://docs/collaboration/round169_visual_rebuild_same_type_img2img_batches/path_fence_flower_home_pipeline_v002/round169_path_fence_flower_home_godot_preview_1280x720_v002.png"

const VIEW_SIZE := Vector2i(1280, 720)
const TREE_CELL_SIZE := Vector2i(256, 320)
const PATH_CELL_SIZE := Vector2i(128, 128)
const FENCE_CELL_SIZE := Vector2i(256, 128)
const FLOWER_CELL_SIZE := Vector2i(192, 160)
const HOME_CELL_SIZE := Vector2i(320, 256)
const TREE_PIVOT := Vector2i(128, 300)
const FENCE_PIVOT := Vector2i(128, 118)
const FLOWER_PIVOT := Vector2i(96, 148)


func _init() -> void:
	var tree_atlas := _load_atlas(TREE_ATLAS_PATH)
	var path_atlas := _load_atlas(PATH_ATLAS_PATH)
	var fence_atlas := _load_atlas(FENCE_ATLAS_PATH)
	var flower_atlas := _load_atlas(FLOWER_ATLAS_PATH)
	var home_atlas := _load_atlas(HOME_ATLAS_PATH)
	if tree_atlas == null or path_atlas == null or fence_atlas == null or flower_atlas == null or home_atlas == null:
		quit(1)
		return

	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	_draw_background(canvas)
	_draw_path(canvas, path_atlas)
	_draw_fences(canvas, fence_atlas)
	_draw_flowers(canvas, flower_atlas)
	_draw_home(canvas, home_atlas)
	_draw_trees(canvas, tree_atlas)
	_draw_glass_placeholders(canvas)

	if _is_blank(canvas):
		push_error("Round169 path/fence/flower/home preview is blank; refusing to save: %s" % OUTPUT_PATH)
		quit(1)
		return

	_ensure_output_dir()
	var save_error := canvas.save_png(OUTPUT_PATH)
	if save_error != OK:
		push_error("Failed to save Round169 path/fence/flower/home preview: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round169 path/fence/flower/home Godot preview: %s" % OUTPUT_PATH)
	quit()


func _load_atlas(path: String) -> Image:
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("Failed to load texture atlas: %s" % path)
		return null
	var image := texture.get_image()
	if image == null:
		push_error("Failed to read texture image: %s" % path)
		return null
	if image.is_empty():
		push_error("Loaded texture image is empty: %s" % path)
		return null
	return image


func _draw_background(canvas: Image) -> void:
	canvas.fill(Color("#9fd49a"))
	for y in range(0, VIEW_SIZE.y, 36):
		var stripe := Color(0.59, 0.80, 0.52, 0.17) if int(y / 36) % 2 == 0 else Color(0.79, 0.91, 0.66, 0.12)
		_blend_rect(canvas, Rect2i(0, y, VIEW_SIZE.x, 36), stripe)

	_blend_rect(canvas, Rect2i(0, 0, VIEW_SIZE.x, 58), Color(0.74, 0.88, 0.95, 0.18))
	_blend_rect(canvas, Rect2i(0, 620, VIEW_SIZE.x, 100), Color(0.65, 0.83, 0.60, 0.20))
	_draw_soft_ellipse(canvas, Vector2i(638, 470), Vector2i(230, 70), Color(0.29, 0.42, 0.24, 0.15))
	_draw_soft_ellipse(canvas, Vector2i(870, 390), Vector2i(330, 70), Color(0.29, 0.42, 0.24, 0.10))


func _draw_path(canvas: Image, atlas: Image) -> void:
	var path_points := [
		Vector2i(640, 500),
		Vector2i(708, 462),
		Vector2i(780, 424),
		Vector2i(862, 384),
		Vector2i(950, 340),
		Vector2i(1042, 296),
		Vector2i(1136, 252),
	]
	var cell_indices := [5, 6, 6, 10, 10, 2, 2]
	for index in range(path_points.size()):
		_draw_cell(canvas, atlas, PATH_CELL_SIZE, 4, cell_indices[index], path_points[index], Vector2i(64, 64), 0.78)

	for point in path_points:
		_draw_soft_ellipse(canvas, point + Vector2i(0, 34), Vector2i(60, 15), Color(0.34, 0.26, 0.15, 0.08))


func _draw_fences(canvas: Image, atlas: Image) -> void:
	var fence_items := [
		{"cell": 0, "pivot": Vector2i(365, 510), "scale": 0.62},
		{"cell": 1, "pivot": Vector2i(485, 496), "scale": 0.62},
		{"cell": 2, "pivot": Vector2i(785, 505), "scale": 0.62},
		{"cell": 3, "pivot": Vector2i(908, 474), "scale": 0.60},
	]
	for item in fence_items:
		_draw_cell(canvas, atlas, FENCE_CELL_SIZE, 3, item["cell"], item["pivot"], FENCE_PIVOT, item["scale"])


func _draw_flowers(canvas: Image, atlas: Image) -> void:
	var flower_items := [
		{"cell": 0, "pivot": Vector2i(300, 574), "scale": 0.52},
		{"cell": 1, "pivot": Vector2i(428, 557), "scale": 0.48},
		{"cell": 2, "pivot": Vector2i(815, 573), "scale": 0.50},
		{"cell": 3, "pivot": Vector2i(940, 520), "scale": 0.45},
		{"cell": 4, "pivot": Vector2i(552, 532), "scale": 0.40},
		{"cell": 5, "pivot": Vector2i(1090, 316), "scale": 0.42},
	]
	for item in flower_items:
		_draw_cell(canvas, atlas, FLOWER_CELL_SIZE, 3, item["cell"], item["pivot"], FLOWER_PIVOT, item["scale"])


func _draw_home(canvas: Image, atlas: Image) -> void:
	var center_x := 632
	_draw_soft_ellipse(canvas, Vector2i(center_x, 502), Vector2i(180, 38), Color(0.24, 0.33, 0.21, 0.22))
	_draw_cell(canvas, atlas, HOME_CELL_SIZE, 3, 3, Vector2i(center_x, 420), Vector2i(160, 180), 0.72)
	_draw_cell(canvas, atlas, HOME_CELL_SIZE, 3, 0, Vector2i(center_x, 329), Vector2i(160, 190), 0.78)
	_draw_cell(canvas, atlas, HOME_CELL_SIZE, 3, 4, Vector2i(center_x - 88, 424), Vector2i(160, 180), 0.36)
	_draw_cell(canvas, atlas, HOME_CELL_SIZE, 3, 5, Vector2i(center_x + 96, 424), Vector2i(160, 180), 0.36)
	_draw_cell(canvas, atlas, HOME_CELL_SIZE, 3, 6, Vector2i(center_x, 486), Vector2i(160, 222), 0.46)
	_draw_cell(canvas, atlas, HOME_CELL_SIZE, 3, 7, Vector2i(center_x - 4, 505), Vector2i(160, 230), 0.36)


func _draw_trees(canvas: Image, atlas: Image) -> void:
	var tree_items := [
		{"cell": 0, "pivot": Vector2i(168, 487), "scale": 0.57},
		{"cell": 1, "pivot": Vector2i(1118, 446), "scale": 0.55},
		{"cell": 2, "pivot": Vector2i(1010, 565), "scale": 0.58},
		{"cell": 3, "pivot": Vector2i(222, 646), "scale": 0.56},
	]
	for item in tree_items:
		_draw_cell(canvas, atlas, TREE_CELL_SIZE, 3, item["cell"], item["pivot"], TREE_PIVOT, item["scale"])


func _draw_glass_placeholders(canvas: Image) -> void:
	_draw_glass_rect(canvas, Rect2i(36, 24, 266, 46), Color(0.96, 1.0, 1.0, 0.30))
	_draw_glass_rect(canvas, Rect2i(978, 24, 266, 46), Color(0.96, 1.0, 1.0, 0.26))
	_draw_glass_rect(canvas, Rect2i(314, 641, 652, 50), Color(0.96, 1.0, 1.0, 0.24))
	for x in [365, 458, 551, 644, 737, 830]:
		_draw_soft_ellipse(canvas, Vector2i(x, 666), Vector2i(23, 17), Color(1.0, 1.0, 1.0, 0.22))


func _draw_glass_rect(canvas: Image, rect: Rect2i, color: Color) -> void:
	_blend_rect(canvas, rect, color)
	_draw_line(canvas, rect.position, rect.position + Vector2i(rect.size.x, 0), Color(1.0, 1.0, 1.0, 0.50), 2)
	_draw_line(canvas, rect.position + Vector2i(0, rect.size.y), rect.position + rect.size, Color(0.25, 0.38, 0.35, 0.12), 2)
	_draw_line(canvas, rect.position, rect.position + Vector2i(0, rect.size.y), Color(1.0, 1.0, 1.0, 0.30), 2)
	_draw_line(canvas, rect.position + Vector2i(rect.size.x, 0), rect.position + rect.size, Color(0.25, 0.38, 0.35, 0.12), 2)


func _draw_cell(canvas: Image, atlas: Image, cell_size: Vector2i, columns: int, cell_index: int, pivot_position: Vector2i, pivot: Vector2i, scale: float) -> void:
	var column := cell_index % columns
	var row := int(cell_index / columns)
	var source_rect := Rect2i(column * cell_size.x, row * cell_size.y, cell_size.x, cell_size.y)
	var sprite := atlas.get_region(source_rect)
	var draw_size := Vector2i(roundi(cell_size.x * scale), roundi(cell_size.y * scale))
	sprite.resize(draw_size.x, draw_size.y, Image.INTERPOLATE_LANCZOS)

	var scaled_pivot := Vector2i(roundi(pivot.x * scale), roundi(pivot.y * scale))
	var origin := pivot_position - scaled_pivot
	canvas.blend_rect(sprite, Rect2i(Vector2i.ZERO, draw_size), origin)


func _draw_soft_ellipse(canvas: Image, center: Vector2i, radius: Vector2i, color: Color) -> void:
	for y in range(center.y - radius.y, center.y + radius.y + 1):
		for x in range(center.x - radius.x, center.x + radius.x + 1):
			if x < 0 or y < 0 or x >= VIEW_SIZE.x or y >= VIEW_SIZE.y:
				continue
			var dx := float(x - center.x) / float(radius.x)
			var dy := float(y - center.y) / float(radius.y)
			var distance := dx * dx + dy * dy
			if distance <= 1.0:
				var alpha := color.a * (1.0 - distance)
				_blend_pixel_safe(canvas, x, y, Color(color.r, color.g, color.b, alpha))


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


func _blend_rect(canvas: Image, rect: Rect2i, color: Color) -> void:
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		for x in range(rect.position.x, rect.position.x + rect.size.x):
			_blend_pixel_safe(canvas, x, y, color)


func _blend_pixel_safe(canvas: Image, x: int, y: int, color: Color) -> void:
	if x < 0 or y < 0 or x >= VIEW_SIZE.x or y >= VIEW_SIZE.y:
		return
	var base := canvas.get_pixel(x, y)
	var alpha := clampf(color.a, 0.0, 1.0)
	var blended := Color(
		lerpf(base.r, color.r, alpha),
		lerpf(base.g, color.g, alpha),
		lerpf(base.b, color.b, alpha),
		1.0
	)
	canvas.set_pixel(x, y, blended)


func _ensure_output_dir() -> void:
	var output_dir := ProjectSettings.globalize_path(OUTPUT_PATH.get_base_dir())
	var error := DirAccess.make_dir_recursive_absolute(output_dir)
	if error != OK:
		push_error("Failed to ensure output directory for Round169 preview: %s" % OUTPUT_PATH)


func _is_blank(canvas: Image) -> bool:
	var first := canvas.get_pixel(0, 0)
	for y in range(0, VIEW_SIZE.y, 12):
		for x in range(0, VIEW_SIZE.x, 12):
			if canvas.get_pixel(x, y) != first:
				return false
	return true
