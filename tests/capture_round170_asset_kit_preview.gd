extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round170_visual_rebuild_asset_generation/round170_asset_kit_godot_preview_1280x720_v001.png"

const TREE_ATLAS := "res://assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_sheet_v002.png"
const BUILDING_ATLAS := "res://assets/art/visual_rebuild/round170/buildings/building_prefabs_320x320_atlas_v001.png"
const TERRAIN_ATLAS := "res://assets/art/visual_rebuild/round170/terrain/terrain_path_tiles_64x64_sheet_v001.png"
const FENCE_ATLAS := "res://assets/art/visual_rebuild/round170/fences/fence_segments_64x64_sheet_v001.png"
const FLOWER_ATLAS := "res://assets/art/visual_rebuild/round170/flowers/flowers_grass_props_64x64_atlas_v001.png"
const WATER_ATLAS := "res://assets/art/visual_rebuild/round170/water/water_pond_edge_tiles_64x64_sheet_v001.png"

const VIEW_SIZE := Vector2i(1280, 720)
const TILE := Vector2i(64, 64)


func _init() -> void:
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#9ed794"))

	var terrain := _load_texture_image(TERRAIN_ATLAS)
	var fences := _load_texture_image(FENCE_ATLAS)
	var flowers := _load_texture_image(FLOWER_ATLAS)
	var water := _load_texture_image(WATER_ATLAS)
	var trees := _load_texture_image(TREE_ATLAS)
	var buildings := _load_texture_image(BUILDING_ATLAS)
	if terrain == null or fences == null or flowers == null or water == null or trees == null or buildings == null:
		quit(1)
		return

	_draw_ground(canvas, terrain)
	_draw_water_patch(canvas, water, Vector2i(880, 430))
	_draw_path(canvas, terrain)
	_draw_fence_row(canvas, fences, Vector2i(230, 430), 8)
	_draw_building(canvas, buildings, 0, Vector2i(445, 395), 0.58)
	_draw_building(canvas, buildings, 1, Vector2i(740, 410), 0.48)
	_draw_tree(canvas, trees, 0, Vector2i(230, 450), 0.62)
	_draw_tree(canvas, trees, 3, Vector2i(990, 460), 0.58)
	_draw_tree(canvas, trees, 5, Vector2i(1120, 480), 0.52)
	_draw_flowers(canvas, flowers)

	var save_error := canvas.save_png(OUTPUT_PATH)
	if save_error != OK:
		push_error("Failed to save Round170 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round170 asset kit Godot preview: %s" % OUTPUT_PATH)
	quit()


func _load_texture_image(path: String) -> Image:
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("Failed to load texture: %s" % path)
		return null
	var image := texture.get_image()
	if image == null:
		push_error("Failed to read image: %s" % path)
	return image


func _draw_ground(canvas: Image, terrain: Image) -> void:
	var grass := terrain.get_region(Rect2i(0, 0, TILE.x, TILE.y))
	for y in range(0, VIEW_SIZE.y, TILE.y):
		for x in range(0, VIEW_SIZE.x, TILE.x):
			canvas.blend_rect(grass, Rect2i(Vector2i.ZERO, TILE), Vector2i(x, y))
	for y in range(0, VIEW_SIZE.y, 96):
		_draw_line(canvas, Vector2i(0, y), Vector2i(VIEW_SIZE.x - 1, y + 20), Color(0.45, 0.69, 0.42, 0.20), 8)


func _draw_path(canvas: Image, terrain: Image) -> void:
	var path_tile := terrain.get_region(Rect2i(64, 0, TILE.x, TILE.y))
	for i in range(15):
		var pos := Vector2i(110 + i * 64, 520 + int(sin(float(i) * 0.45) * 22.0))
		canvas.blend_rect(path_tile, Rect2i(Vector2i.ZERO, TILE), pos)


func _draw_water_patch(canvas: Image, water: Image, origin: Vector2i) -> void:
	var cells := [
		Rect2i(64, 0, 64, 64), Rect2i(0, 0, 64, 64), Rect2i(128, 0, 64, 64),
		Rect2i(192, 0, 64, 64), Rect2i(0, 64, 64, 64), Rect2i(64, 64, 64, 64),
	]
	var positions := [
		origin + Vector2i(0, 0), origin + Vector2i(64, 0), origin + Vector2i(128, 0),
		origin + Vector2i(0, 64), origin + Vector2i(64, 64), origin + Vector2i(128, 64),
	]
	for i in range(cells.size()):
		var tile := water.get_region(cells[i])
		canvas.blend_rect(tile, Rect2i(Vector2i.ZERO, TILE), positions[i])


func _draw_fence_row(canvas: Image, fences: Image, origin: Vector2i, count: int) -> void:
	for i in range(count):
		var source := Rect2i((i % 3) * 64, 0, 64, 64)
		var segment := fences.get_region(source)
		canvas.blend_rect(segment, Rect2i(Vector2i.ZERO, TILE), origin + Vector2i(i * 50, int(sin(float(i)) * 4.0)))


func _draw_flowers(canvas: Image, flowers: Image) -> void:
	var placements := [
		[0, Vector2i(340, 525)], [1, Vector2i(575, 500)], [2, Vector2i(655, 550)],
		[4, Vector2i(815, 505)], [5, Vector2i(1040, 550)], [6, Vector2i(160, 570)],
	]
	for placement in placements:
		var index: int = placement[0]
		var pos: Vector2i = placement[1]
		var source := Rect2i((index % 4) * 64, int(index / 4) * 64, 64, 64)
		var prop := flowers.get_region(source)
		canvas.blend_rect(prop, Rect2i(Vector2i.ZERO, TILE), pos)


func _draw_tree(canvas: Image, atlas: Image, index: int, pivot_world: Vector2i, scale: float) -> void:
	var source := Rect2i((index % 3) * 256, int(index / 3) * 320, 256, 320)
	var sprite := atlas.get_region(source)
	var draw_size := Vector2i(roundi(256.0 * scale), roundi(320.0 * scale))
	sprite.resize(draw_size.x, draw_size.y, Image.INTERPOLATE_LANCZOS)
	var pivot := Vector2i(roundi(128.0 * scale), roundi(300.0 * scale))
	canvas.blend_rect(sprite, Rect2i(Vector2i.ZERO, draw_size), pivot_world - pivot)


func _draw_building(canvas: Image, atlas: Image, index: int, pivot_world: Vector2i, scale: float) -> void:
	var source := Rect2i((index % 2) * 320, int(index / 2) * 320, 320, 320)
	var sprite := atlas.get_region(source)
	var draw_size := Vector2i(roundi(320.0 * scale), roundi(320.0 * scale))
	sprite.resize(draw_size.x, draw_size.y, Image.INTERPOLATE_LANCZOS)
	var pivot := Vector2i(roundi(160.0 * scale), roundi(302.0 * scale))
	canvas.blend_rect(sprite, Rect2i(Vector2i.ZERO, draw_size), pivot_world - pivot)


func _draw_line(canvas: Image, start: Vector2i, end: Vector2i, color: Color, width: int) -> void:
	var delta := end - start
	var steps := maxi(abs(delta.x), abs(delta.y))
	for step in range(steps + 1):
		var t := float(step) / float(steps)
		var point := Vector2i(roundi(lerpf(start.x, end.x, t)), roundi(lerpf(start.y, end.y, t)))
		for oy in range(-int(width / 2), int(width / 2) + 1):
			for ox in range(-int(width / 2), int(width / 2) + 1):
				var x := point.x + ox
				var y := point.y + oy
				if x >= 0 and y >= 0 and x < VIEW_SIZE.x and y < VIEW_SIZE.y:
					canvas.set_pixel(x, y, color)
