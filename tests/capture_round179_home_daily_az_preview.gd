extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round179_visual_rebuild_asset_generation/round179_home_daily_az_godot_preview_1280x720_v001.png"

const HOME_DECOR_PROOF := "res://assets/art/visual_rebuild/round179/home_decor_surfaces/proof/round179_home_decor_surfaces_contact_sheet.png"
const DAILY_PROPS_PROOF := "res://assets/art/visual_rebuild/round179/school_shop_daily_props/proof/round179_school_shop_daily_props_contact_sheet.png"
const AZ_A_M_PROOF := "res://assets/art/visual_rebuild/round179/az_story_vignettes_a_m/proof/round179_az_story_vignettes_a_m_contact_sheet.png"
const AZ_N_Z_PROOF := "res://assets/art/visual_rebuild/round179/az_story_vignettes_n_z/proof/round179_az_story_vignettes_n_z_contact_sheet.png"

const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://docs/collaboration/round179_visual_rebuild_asset_generation"))

	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#95cf86"))
	_draw_background(canvas)

	var home_decor := _load_image(HOME_DECOR_PROOF)
	var daily_props := _load_image(DAILY_PROPS_PROOF)
	var az_a_m := _load_image(AZ_A_M_PROOF)
	var az_n_z := _load_image(AZ_N_Z_PROOF)
	if home_decor == null or daily_props == null or az_a_m == null or az_n_z == null:
		quit(1)
		return

	_draw_panel(canvas, Vector2i(42, 54), Vector2i(584, 284), home_decor, 0.27, Color(0.93, 0.91, 0.82, 0.92))
	_draw_panel(canvas, Vector2i(654, 54), Vector2i(584, 284), daily_props, 0.40, Color(0.85, 0.93, 0.88, 0.92))
	_draw_panel(canvas, Vector2i(42, 374), Vector2i(584, 284), az_a_m, 0.27, Color(0.88, 0.92, 0.96, 0.90))
	_draw_panel(canvas, Vector2i(654, 374), Vector2i(584, 284), az_n_z, 0.255, Color(0.91, 0.88, 0.95, 0.90))

	var error := canvas.save_png(OUTPUT_PATH)
	if error != OK:
		push_error("Failed to save Round179 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round179 home/daily/A-Z Godot preview: %s" % OUTPUT_PATH)
	quit()


func _load_image(path: String) -> Image:
	var image := Image.new()
	var error := image.load(ProjectSettings.globalize_path(path))
	if error != OK:
		push_error("Failed to load image: %s" % path)
		return null
	if image.get_format() != Image.FORMAT_RGBA8:
		image.convert(Image.FORMAT_RGBA8)
	return image


func _draw_background(canvas: Image) -> void:
	canvas.fill_rect(Rect2i(0, 0, VIEW_SIZE.x, 52), Color("#b8e2ee"))
	canvas.fill_rect(Rect2i(0, 444, VIEW_SIZE.x, 276), Color("#80c47c"))
	for y in range(52, VIEW_SIZE.y, 24):
		for x in range(0, VIEW_SIZE.x, 24):
			if int(x / 24 + y / 24) % 2 == 0:
				canvas.fill_rect(Rect2i(x, y, 24, 24), Color(1.0, 1.0, 1.0, 0.08))


func _draw_panel(canvas: Image, origin: Vector2i, panel_size: Vector2i, source: Image, scale: float, color: Color) -> void:
	var panel := Image.create(panel_size.x, panel_size.y, false, Image.FORMAT_RGBA8)
	panel.fill(color)
	var step := 18
	for y in range(0, panel_size.y, step):
		for x in range(0, panel_size.x, step):
			if int(x / step + y / step) % 2 == 1:
				panel.fill_rect(Rect2i(x, y, step, step), Color(1.0, 1.0, 1.0, 0.12))

	var sprite := source.duplicate()
	sprite.resize(roundi(source.get_width() * scale), roundi(source.get_height() * scale), Image.INTERPOLATE_LANCZOS)
	var pos := Vector2i((panel_size.x - sprite.get_width()) / 2, (panel_size.y - sprite.get_height()) / 2)
	panel.blend_rect(sprite, Rect2i(Vector2i.ZERO, sprite.get_size()), pos)
	canvas.blend_rect(panel, Rect2i(Vector2i.ZERO, panel_size), origin)
