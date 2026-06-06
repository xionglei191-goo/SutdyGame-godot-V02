extends Resource
class_name ThemeProfileResource

@export var theme_id: String = ""
@export var label: String = ""
@export var version: int = 1
@export var style: String = ""
@export var placeholder: bool = true
@export var tile_atlas: Dictionary = {}
@export var landmark_assets: Dictionary = {}
@export var place_assets: Dictionary = {}
@export var anchor_assets: Dictionary = {}
@export var character_assets: Dictionary = {}
@export var furniture_assets: Dictionary = {}
@export var npc_assets: Dictionary = {}
@export var pet_assets: Dictionary = {}
@export var card_art: Dictionary = {}
@export var ui_icon_assets: Dictionary = {}
@export var ui_skin: Dictionary = {}
@export var card_frame_assets: Dictionary = {}
@export var asset_acceptance: Array = []


func load_from_dictionary(data: Dictionary) -> void:
	theme_id = data.get("theme_id", "")
	label = data.get("label", "")
	version = int(data.get("version", 1))
	style = data.get("style", "")
	placeholder = bool(data.get("placeholder", true))
	tile_atlas = data.get("tile_atlas", {})
	landmark_assets = data.get("landmark_assets", {})
	place_assets = data.get("place_assets", {})
	anchor_assets = data.get("anchor_assets", {})
	character_assets = data.get("character_assets", {})
	furniture_assets = data.get("furniture_assets", {})
	npc_assets = data.get("npc_assets", {})
	pet_assets = data.get("pet_assets", {})
	card_art = data.get("card_art", {})
	ui_icon_assets = data.get("ui_icon_assets", {})
	ui_skin = data.get("ui_skin", {})
	card_frame_assets = data.get("card_frame_assets", {})
	asset_acceptance = data.get("asset_acceptance", [])


func to_dictionary() -> Dictionary:
	return {
		"theme_id": theme_id,
		"label": label,
		"version": version,
		"style": style,
		"placeholder": placeholder,
		"tile_atlas": tile_atlas,
		"landmark_assets": landmark_assets,
		"place_assets": place_assets,
		"anchor_assets": anchor_assets,
		"character_assets": character_assets,
		"furniture_assets": furniture_assets,
		"npc_assets": npc_assets,
		"pet_assets": pet_assets,
		"card_art": card_art,
		"ui_icon_assets": ui_icon_assets,
		"ui_skin": ui_skin,
		"card_frame_assets": card_frame_assets,
		"asset_acceptance": asset_acceptance,
	}


func get_category_assets(category: String) -> Dictionary:
	match category:
		"tile_atlas":
			return tile_atlas
		"landmark_assets", "landmark":
			return landmark_assets
		"place_assets", "place":
			return place_assets
		"anchor_assets", "anchor":
			return anchor_assets
		"character_assets", "character":
			return character_assets
		"furniture_assets", "furniture":
			return furniture_assets
		"npc_assets", "npc":
			return npc_assets
		"pet_assets", "pet":
			return pet_assets
		"card_art", "card":
			return card_art
		"ui_icon_assets", "ui_icon":
			return ui_icon_assets
		"ui_skin", "ui":
			return ui_skin
		"card_frame_assets", "card_frame":
			return card_frame_assets
		_:
			return {}
