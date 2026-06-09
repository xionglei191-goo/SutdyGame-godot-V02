extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round174_visual_rebuild_asset_generation/round174_character_place_weather_godot_preview_1280x720_v001.png"

const NPC_ATLAS := "res://assets/art/visual_rebuild/round174/npc_fullbody/round174_npc_fullbody_160x192_atlas_v001.png"
const PLACE_CONTACT := "res://assets/art/visual_rebuild/round174/place_prefabs/proof/round174_place_prefabs_normalized_contact.png"
const WEATHER_CONTACT := "res://assets/art/visual_rebuild/round174/weather_fx/proofs/round174_weather_fx_contact_sheet.png"

const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#9bd38f"))
	_draw_soft_ground(canvas)

	var places := _load_image(PLACE_CONTACT)
	var npcs := _load_image(NPC_ATLAS)
	var weather := _load_image(WEATHER_CONTACT)
	if places == null or npcs == null or weather == null:
		quit(1)
		return

	_draw_panel(canvas, Vector2i(44, 54), Vector2i(760, 366), places, 0.94, Color(0.86, 0.92, 0.80, 0.92))
	_draw_panel(canvas, Vector2i(836, 54), Vector2i(390, 366), weather, 0.30, Color(0.82, 0.91, 0.95, 0.90))
	_draw_panel(canvas, Vector2i(44, 470), Vector2i(1182, 174), npcs, 0.78, Color(0.90, 0.94, 0.84, 0.92))

	var error := canvas.save_png(OUTPUT_PATH)
	if error != OK:
		push_error("Failed to save Round174 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round174 character/place/weather Godot preview: %s" % OUTPUT_PATH)
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


func _draw_soft_ground(canvas: Image) -> void:
	canvas.fill_rect(Rect2i(0, 450, VIEW_SIZE.x, 270), Color("#86c983"))
	canvas.fill_rect(Rect2i(0, 0, VIEW_SIZE.x, 54), Color("#b8e5f2"))
	for y in range(460, VIEW_SIZE.y, 28):
		for x in range(0, VIEW_SIZE.x, 28):
			if int(x / 28 + y / 28) % 2 == 0:
				canvas.fill_rect(Rect2i(x, y, 28, 28), Color(0.75, 0.88, 0.64, 0.20))


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
