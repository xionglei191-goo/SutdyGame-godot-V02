extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round172_visual_rebuild_asset_generation/round172_props_godot_preview_1280x720_v001.png"

const TOWN_ATLAS := "res://assets/art/visual_rebuild/round172/town_props/round172_town_props_raw_chroma_4x2_v002_128x128_atlas.png"
const HOME_YARD_ATLAS := "res://assets/art/visual_rebuild/round172/home_yard_props/home_yard_props_128x128_atlas.png"
const ANCHOR_A_M_ATLAS := "res://assets/art/visual_rebuild/round172/anchor_props_a_m/round172_anchor_props_a_m_128x128_atlas_v001.png"
const ANCHOR_N_Z_ATLAS := "res://assets/art/visual_rebuild/round172/anchor_props_n_z/round172_anchor_props_n_z_128x128_atlas_v001.png"

const VIEW_SIZE := Vector2i(1280, 720)
const CELL := 128


func _init() -> void:
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#a8d79b"))

	var town := _load_image(TOWN_ATLAS)
	var home_yard := _load_image(HOME_YARD_ATLAS)
	var anchors_a_m := _load_image(ANCHOR_A_M_ATLAS)
	var anchors_n_z := _load_image(ANCHOR_N_Z_ATLAS)
	if town == null or home_yard == null or anchors_a_m == null or anchors_n_z == null:
		quit(1)
		return

	_draw_band(canvas, Rect2i(0, 0, VIEW_SIZE.x, 92), Color("#87c982"))
	_draw_band(canvas, Rect2i(0, 334, VIEW_SIZE.x, 386), Color("#94d18b"))
	_draw_checker_panel(canvas, Vector2i(52, 108), Vector2i(560, 190), town, Vector2i(512, 256), 0.72)
	_draw_checker_panel(canvas, Vector2i(668, 108), Vector2i(560, 190), home_yard, Vector2i(512, 256), 0.72)
	_draw_checker_panel(canvas, Vector2i(52, 372), Vector2i(560, 296), anchors_a_m, Vector2i(512, 512), 0.54)
	_draw_checker_panel(canvas, Vector2i(668, 372), Vector2i(560, 296), anchors_n_z, Vector2i(512, 512), 0.54)

	var error := canvas.save_png(OUTPUT_PATH)
	if error != OK:
		push_error("Failed to save Round172 props proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round172 props Godot preview: %s" % OUTPUT_PATH)
	quit()


func _load_image(path: String) -> Image:
	var image := Image.new()
	var error := image.load(ProjectSettings.globalize_path(path))
	if error != OK:
		push_error("Failed to load image: %s" % path)
		return null
	return image


func _draw_band(canvas: Image, rect: Rect2i, color: Color) -> void:
	canvas.fill_rect(rect, color)


func _draw_checker_panel(canvas: Image, origin: Vector2i, panel_size: Vector2i, atlas: Image, atlas_size: Vector2i, scale: float) -> void:
	var panel := Image.create(panel_size.x, panel_size.y, false, Image.FORMAT_RGBA8)
	panel.fill(Color(0.88, 0.93, 0.84, 1.0))
	var step := 16
	for y in range(0, panel_size.y, step):
		for x in range(0, panel_size.x, step):
			if int(x / step + y / step) % 2 == 1:
				panel.fill_rect(Rect2i(x, y, step, step), Color(0.74, 0.82, 0.70, 1.0))

	var sprite := atlas.duplicate()
	sprite.resize(roundi(atlas_size.x * scale), roundi(atlas_size.y * scale), Image.INTERPOLATE_LANCZOS)
	var pos := Vector2i((panel_size.x - sprite.get_width()) / 2, (panel_size.y - sprite.get_height()) / 2)
	panel.blend_rect(sprite, Rect2i(Vector2i.ZERO, sprite.get_size()), pos)
	canvas.blend_rect(panel, Rect2i(Vector2i.ZERO, panel_size), origin)
