extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round178_visual_rebuild_asset_generation/round178_remaining_asset_gap_godot_preview_1280x720_v001.png"

const COMPANION_PROOF := "res://assets/art/visual_rebuild/round178/companion_care_props/proof/round178_companion_care_props_contact_sheet.png"
const MARKER_PROOF := "res://assets/art/visual_rebuild/round178/gentle_quest_markers/proof/round178_gentle_quest_markers_contact_sheet.png"
const EDGE_PROOF := "res://assets/art/visual_rebuild/round178/map_edge_nature_transitions/proof/round178_map_edge_nature_transitions_contact_sheet.png"

const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://docs/collaboration/round178_visual_rebuild_asset_generation"))

	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#9bd48b"))
	_draw_background(canvas)

	var companion := _load_image(COMPANION_PROOF)
	var markers := _load_image(MARKER_PROOF)
	var edges := _load_image(EDGE_PROOF)
	if companion == null or markers == null or edges == null:
		quit(1)
		return

	_draw_panel(canvas, Vector2i(42, 54), Vector2i(584, 284), companion, 0.50, Color(0.92, 0.94, 0.83, 0.92))
	_draw_panel(canvas, Vector2i(654, 54), Vector2i(584, 284), markers, 0.50, Color(0.83, 0.92, 0.95, 0.90))
	_draw_panel(canvas, Vector2i(118, 374), Vector2i(1044, 286), edges, 0.24, Color(0.88, 0.93, 0.82, 0.92))

	var error := canvas.save_png(OUTPUT_PATH)
	if error != OK:
		push_error("Failed to save Round178 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round178 remaining asset gap Godot preview: %s" % OUTPUT_PATH)
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
	canvas.fill_rect(Rect2i(0, 0, VIEW_SIZE.x, 52), Color("#b9e5ee"))
	canvas.fill_rect(Rect2i(0, 444, VIEW_SIZE.x, 276), Color("#83c67e"))
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
