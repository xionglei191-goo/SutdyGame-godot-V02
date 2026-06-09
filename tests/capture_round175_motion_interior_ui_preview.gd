extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round175_visual_rebuild_asset_generation/round175_motion_interior_ui_godot_preview_1280x720_v001.png"

const MOTION_PROOF := "res://assets/art/visual_rebuild/round175/motion_sheets/proof/round175_motion_sheets_contact_sheet.png"
const HOME_PROOF := "res://assets/art/visual_rebuild/round175/home_interior_shells/proof/round175_home_interior_shells_contact_sheet.png"
const UI_PROOF := "res://assets/art/visual_rebuild/round175/interaction_ui_feedback/proof/round175_interaction_ui_feedback_contact_sheet.png"

const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#93cf8a"))
	_draw_background(canvas)

	var motion := _load_image(MOTION_PROOF)
	var home := _load_image(HOME_PROOF)
	var ui := _load_image(UI_PROOF)
	if motion == null or home == null or ui == null:
		quit(1)
		return

	_draw_panel(canvas, Vector2i(42, 54), Vector2i(352, 610), motion, 0.24, Color(0.90, 0.94, 0.84, 0.92))
	_draw_panel(canvas, Vector2i(424, 54), Vector2i(372, 610), home, 0.29, Color(0.86, 0.91, 0.80, 0.92))
	_draw_panel(canvas, Vector2i(826, 54), Vector2i(410, 610), ui, 0.22, Color(0.82, 0.91, 0.95, 0.90))

	var error := canvas.save_png(OUTPUT_PATH)
	if error != OK:
		push_error("Failed to save Round175 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round175 motion/interior/UI Godot preview: %s" % OUTPUT_PATH)
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
	canvas.fill_rect(Rect2i(0, 0, VIEW_SIZE.x, 52), Color("#b7e3ef"))
	canvas.fill_rect(Rect2i(0, 452, VIEW_SIZE.x, 268), Color("#82c780"))
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
