extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round176_visual_rebuild_asset_generation/round176_place_album_seasonal_godot_preview_1280x720_v001.png"

const PLACE_PROOF := "res://assets/art/visual_rebuild/round176/place_interior_shells/proof/round176_place_interior_shells_contact_sheet.png"
const ALBUM_PROOF := "res://assets/art/visual_rebuild/round176/album_card_ui/proof/round176_album_card_ui_contact_sheet.png"
const SEASONAL_PROOF := "res://assets/art/visual_rebuild/round176/seasonal_event_decor/proof/round176_seasonal_event_decor_contact_sheet.png"

const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#93cf8a"))
	_draw_background(canvas)

	var place := _load_image(PLACE_PROOF)
	var album := _load_image(ALBUM_PROOF)
	var seasonal := _load_image(SEASONAL_PROOF)
	if place == null or album == null or seasonal == null:
		quit(1)
		return

	_draw_panel(canvas, Vector2i(44, 54), Vector2i(386, 612), place, 0.58, Color(0.88, 0.92, 0.82, 0.92))
	_draw_panel(canvas, Vector2i(462, 54), Vector2i(774, 252), album, 0.58, Color(0.82, 0.91, 0.95, 0.90))
	_draw_panel(canvas, Vector2i(462, 342), Vector2i(774, 324), seasonal, 0.46, Color(0.90, 0.94, 0.84, 0.92))

	var error := canvas.save_png(OUTPUT_PATH)
	if error != OK:
		push_error("Failed to save Round176 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round176 place/album/seasonal Godot preview: %s" % OUTPUT_PATH)
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
	canvas.fill_rect(Rect2i(0, 454, VIEW_SIZE.x, 266), Color("#82c780"))
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
