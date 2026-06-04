extends Resource
class_name WorldMapResource

@export var map_id: String = ""
@export var version: int = 1
@export var canvas_size: Vector2i = Vector2i.ZERO
@export var cell_size: Vector2i = Vector2i.ONE
@export var theme_id: String = ""
@export var districts: Array[Resource] = []
@export var roads: Array[Resource] = []
@export var places: Array[Resource] = []
@export var memory_anchors: Array[Resource] = []
@export var collision_cells: Array[Vector2i] = []
@export var interaction_cells: Array[Vector2i] = []
