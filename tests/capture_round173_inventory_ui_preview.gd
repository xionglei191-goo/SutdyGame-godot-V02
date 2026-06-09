extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round173_visual_rebuild_asset_generation/round173_inventory_ui_godot_preview_1280x720_v001.png"

const FURNITURE_ATLAS := "res://assets/art/visual_rebuild/round173/furniture/round173_furniture_128x128_atlas_v001.png"
const PORTRAITS_ATLAS := "res://assets/art/visual_rebuild/round173/portraits_status/round173_portraits_status_atlas_192x192.png"
const UI_ATLAS := "res://assets/art/visual_rebuild/round173/ui_icons/round173_ui_icons_atlas_5x2_128.png"
const RESOURCE_ATLAS := "res://assets/art/visual_rebuild/round173/resources_shop_items/resources_shop_items_atlas_128.png"

const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#a8d79b"))

	var furniture := _load_image(FURNITURE_ATLAS)
	var portraits := _load_image(PORTRAITS_ATLAS)
	var ui_icons := _load_image(UI_ATLAS)
	var resources := _load_image(RESOURCE_ATLAS)
	if furniture == null or portraits == null or ui_icons == null or resources == null:
		quit(1)
		return

	_draw_panel(canvas, Vector2i(54, 74), Vector2i(540, 206), furniture, Vector2i(512, 256), 0.74)
	_draw_panel(canvas, Vector2i(686, 74), Vector2i(540, 206), resources, Vector2i(640, 256), 0.70)
	_draw_panel(canvas, Vector2i(54, 356), Vector2i(540, 284), portraits, Vector2i(768, 384), 0.58)
	_draw_panel(canvas, Vector2i(686, 356), Vector2i(540, 284), ui_icons, Vector2i(640, 256), 0.72)

	var error := canvas.save_png(OUTPUT_PATH)
	if error != OK:
		push_error("Failed to save Round173 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round173 inventory/UI Godot preview: %s" % OUTPUT_PATH)
	quit()


func _load_image(path: String) -> Image:
	var image := Image.new()
	var error := image.load(ProjectSettings.globalize_path(path))
	if error != OK:
		push_error("Failed to load image: %s" % path)
		return null
	return image


func _draw_panel(canvas: Image, origin: Vector2i, panel_size: Vector2i, atlas: Image, atlas_size: Vector2i, scale: float) -> void:
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
