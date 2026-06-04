extends Resource
class_name PlaceResource

@export var place_id: String = ""
@export var label: String = ""
@export var place_type: String = ""
@export var district_id: String = ""
@export var position: Vector2i = Vector2i.ZERO
@export var size: Vector2i = Vector2i.ONE
@export var landmark_asset_id: String = ""
@export var occupied_cells: Array[Vector2i] = []
@export var interaction_cell: Vector2i = Vector2i.ZERO
@export var place_action: String = ""
@export var card_actions: Array[String] = []
@export var unlock_rule: String = "default_unlocked"
