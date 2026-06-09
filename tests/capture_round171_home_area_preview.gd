extends SceneTree

const OUTPUT_PATH := "res://docs/collaboration/round171_visual_rebuild_asset_generation/round171_home_area_godot_preview_1280x720_v002.png"

const TREE_ATLAS := "res://assets/art/visual_rebuild/round169/trees/tree_round_objects_256x320_sheet_v002.png"
const BUILDING_ATLAS := "res://assets/art/visual_rebuild/round170/buildings/building_prefabs_320x320_atlas_v001.png"
const FENCE_ATLAS := "res://assets/art/visual_rebuild/round170/fences/fence_segments_64x64_sheet_v001.png"
const FLOWER_ATLAS := "res://assets/art/visual_rebuild/round170/flowers/flowers_grass_props_64x64_atlas_v001.png"
const WATER_ATLAS := "res://assets/art/visual_rebuild/round170/water/water_pond_edge_tiles_64x64_sheet_v001.png"
const ACTOR_ATLAS := "res://assets/art/visual_rebuild/round171/actors/round171_actors_scale_reference_atlas_160x192x3.png"
const MEADOW_ATLAS := "res://assets/art/visual_rebuild/round171/ground_regions/ground_meadow_chunks_256x256_atlas_v002.png"
const PATH_ATLAS := "res://assets/art/visual_rebuild/round171/ground_regions/ground_soft_path_bands_512x256_atlas_v002.png"
const EDGE_ATLAS := "res://assets/art/visual_rebuild/round171/ground_regions/ground_grass_path_edges_256x256_atlas_v002.png"

const VIEW_SIZE := Vector2i(1280, 720)


func _init() -> void:
	var canvas := Image.create(VIEW_SIZE.x, VIEW_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("#9fd596"))

	var trees := _load_texture_image(TREE_ATLAS)
	var buildings := _load_texture_image(BUILDING_ATLAS)
	var fences := _load_texture_image(FENCE_ATLAS)
	var flowers := _load_texture_image(FLOWER_ATLAS)
	var water := _load_texture_image(WATER_ATLAS)
	var actors := _load_texture_image(ACTOR_ATLAS)
	var meadow := _load_texture_image(MEADOW_ATLAS)
	var path := _load_texture_image(PATH_ATLAS)
	var edges := _load_texture_image(EDGE_ATLAS)
	if trees == null or buildings == null or fences == null or flowers == null or water == null or actors == null or meadow == null or path == null or edges == null:
		quit(1)
		return

	_draw_ground_regions(canvas, meadow, path, edges)
	_draw_water(canvas, water, Vector2i(850, 444))
	_draw_building(canvas, buildings, 0, Vector2i(470, 415), 0.62)
	_draw_building(canvas, buildings, 1, Vector2i(780, 430), 0.48)
	_draw_fences(canvas, fences)
	_draw_tree(canvas, trees, 0, Vector2i(245, 462), 0.62)
	_draw_tree(canvas, trees, 3, Vector2i(980, 472), 0.56)
	_draw_tree(canvas, trees, 5, Vector2i(1110, 492), 0.50)
	_draw_flowers(canvas, flowers)
	_draw_actor(canvas, actors, 0, Vector2i(585, 498), 0.72)
	_draw_actor(canvas, actors, 1, Vector2i(700, 512), 0.72)
	_draw_actor(canvas, actors, 2, Vector2i(640, 532), 0.72)

	var save_error := canvas.save_png(OUTPUT_PATH)
	if save_error != OK:
		push_error("Failed to save Round171 proof: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved Round171 home-area Godot preview: %s" % OUTPUT_PATH)
	quit()


func _load_texture_image(path: String) -> Image:
	var image := Image.new()
	var error := image.load(ProjectSettings.globalize_path(path))
	if error != OK:
		push_error("Failed to load image: %s" % path)
		return null
	return image


func _draw_ground_regions(canvas: Image, meadow: Image, path: Image, edges: Image) -> void:
	_draw_region(canvas, meadow, Rect2i(0, 0, 256, 256), Vector2i(0, 42), Vector2i(480, 360))
	_draw_region(canvas, meadow, Rect2i(256, 0, 256, 256), Vector2i(420, 36), Vector2i(470, 350))
	_draw_region(canvas, meadow, Rect2i(0, 256, 256, 256), Vector2i(840, 52), Vector2i(470, 350))
	_draw_region(canvas, meadow, Rect2i(256, 256, 256, 256), Vector2i(0, 360), Vector2i(1280, 360))
	_draw_region(canvas, path, Rect2i(0, 0, 512, 256), Vector2i(130, 458), Vector2i(780, 150))
	_draw_region(canvas, path, Rect2i(512, 0, 512, 256), Vector2i(612, 430), Vector2i(520, 145))
	_draw_region(canvas, edges, Rect2i(0, 0, 256, 256), Vector2i(102, 418), Vector2i(310, 170))
	_draw_region(canvas, edges, Rect2i(256, 0, 256, 256), Vector2i(780, 410), Vector2i(330, 178))


func _draw_region(canvas: Image, atlas: Image, source: Rect2i, dest: Vector2i, size: Vector2i) -> void:
	var region := atlas.get_region(source)
	region.resize(size.x, size.y, Image.INTERPOLATE_LANCZOS)
	canvas.blend_rect(region, Rect2i(Vector2i.ZERO, size), dest)


func _draw_water(canvas: Image, water: Image, origin: Vector2i) -> void:
	for row in range(2):
		for column in range(3):
			var source := Rect2i((column % 4) * 64, row * 64, 64, 64)
			var tile := water.get_region(source)
			canvas.blend_rect(tile, Rect2i(Vector2i.ZERO, Vector2i(64, 64)), origin + Vector2i(column * 58, row * 58))


func _draw_fences(canvas: Image, fences: Image) -> void:
	for i in range(9):
		var source := Rect2i((i % 3) * 64, 0, 64, 64)
		var segment := fences.get_region(source)
		canvas.blend_rect(segment, Rect2i(Vector2i.ZERO, Vector2i(64, 64)), Vector2i(225 + i * 46, 418 + int(sin(float(i)) * 3.0)))


func _draw_flowers(canvas: Image, flowers: Image) -> void:
	var placements := [
		[0, Vector2i(350, 520)], [1, Vector2i(560, 534)], [2, Vector2i(735, 544)],
		[4, Vector2i(880, 520)], [5, Vector2i(1022, 548)], [6, Vector2i(170, 555)],
	]
	for placement in placements:
		var index: int = placement[0]
		var pos: Vector2i = placement[1]
		var source := Rect2i((index % 4) * 64, int(index / 4) * 64, 64, 64)
		var prop := flowers.get_region(source)
		canvas.blend_rect(prop, Rect2i(Vector2i.ZERO, Vector2i(64, 64)), pos)


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


func _draw_actor(canvas: Image, atlas: Image, index: int, pivot_world: Vector2i, scale: float) -> void:
	var source := Rect2i(index * 160, 0, 160, 192)
	var sprite := atlas.get_region(source)
	var draw_size := Vector2i(roundi(160.0 * scale), roundi(192.0 * scale))
	sprite.resize(draw_size.x, draw_size.y, Image.INTERPOLATE_LANCZOS)
	var pivot := Vector2i(roundi(80.0 * scale), roundi(176.0 * scale))
	canvas.blend_rect(sprite, Rect2i(Vector2i.ZERO, draw_size), pivot_world - pivot)
