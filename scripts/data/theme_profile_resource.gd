extends Resource
class_name ThemeProfileResource

@export var theme_id: String = ""
@export var label: String = ""
@export var version: int = 1
@export var style: String = ""
@export var placeholder: bool = true
@export var tile_atlas: Dictionary = {}
@export var tile_edge_assets: Dictionary = {}
@export var terrain_tile_assets: Dictionary = {}
@export var terrain_decal_assets: Dictionary = {}
@export var region_chunk_assets: Dictionary = {}
@export var building_prefab_assets: Dictionary = {}
@export var world_prop_assets: Dictionary = {}
@export var soft_shadow_assets: Dictionary = {}
@export var landmark_assets: Dictionary = {}
@export var place_assets: Dictionary = {}
@export var story_prop_assets: Dictionary = {}
@export var anchor_assets: Dictionary = {}
@export var character_assets: Dictionary = {}
@export var character_animation_assets: Dictionary = {}
@export var furniture_assets: Dictionary = {}
@export var npc_assets: Dictionary = {}
@export var pet_assets: Dictionary = {}
@export var pet_animation_assets: Dictionary = {}
@export var animation_metadata_assets: Dictionary = {}
@export var card_art: Dictionary = {}
@export var ui_icon_assets: Dictionary = {}
@export var ui_feedback_assets: Dictionary = {}
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
	tile_edge_assets = data.get("tile_edge_assets", {})
	terrain_tile_assets = data.get("terrain_tile_assets", {})
	terrain_decal_assets = data.get("terrain_decal_assets", {})
	region_chunk_assets = data.get("region_chunk_assets", {})
	building_prefab_assets = data.get("building_prefab_assets", {})
	world_prop_assets = data.get("world_prop_assets", {})
	soft_shadow_assets = data.get("soft_shadow_assets", {})
	landmark_assets = data.get("landmark_assets", {})
	place_assets = data.get("place_assets", {})
	story_prop_assets = data.get("story_prop_assets", {})
	anchor_assets = data.get("anchor_assets", {})
	character_assets = data.get("character_assets", {})
	character_animation_assets = data.get("character_animation_assets", {})
	furniture_assets = data.get("furniture_assets", {})
	npc_assets = data.get("npc_assets", {})
	pet_assets = data.get("pet_assets", {})
	pet_animation_assets = data.get("pet_animation_assets", {})
	animation_metadata_assets = data.get("animation_metadata_assets", {})
	card_art = data.get("card_art", {})
	ui_icon_assets = data.get("ui_icon_assets", {})
	ui_feedback_assets = data.get("ui_feedback_assets", {})
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
		"tile_edge_assets": tile_edge_assets,
		"terrain_tile_assets": terrain_tile_assets,
		"terrain_decal_assets": terrain_decal_assets,
		"region_chunk_assets": region_chunk_assets,
		"building_prefab_assets": building_prefab_assets,
		"world_prop_assets": world_prop_assets,
		"soft_shadow_assets": soft_shadow_assets,
		"landmark_assets": landmark_assets,
		"place_assets": place_assets,
		"story_prop_assets": story_prop_assets,
		"anchor_assets": anchor_assets,
		"character_assets": character_assets,
		"character_animation_assets": character_animation_assets,
		"furniture_assets": furniture_assets,
		"npc_assets": npc_assets,
		"pet_assets": pet_assets,
		"pet_animation_assets": pet_animation_assets,
		"animation_metadata_assets": animation_metadata_assets,
		"card_art": card_art,
		"ui_icon_assets": ui_icon_assets,
		"ui_feedback_assets": ui_feedback_assets,
		"ui_skin": ui_skin,
		"card_frame_assets": card_frame_assets,
		"asset_acceptance": asset_acceptance,
	}


func get_category_assets(category: String) -> Dictionary:
	match category:
		"tile_atlas":
			return tile_atlas
		"tile_edge_assets", "tile_edge":
			return tile_edge_assets
		"terrain_edge_assets", "terrain_edge":
			return _merged_assets([tile_edge_assets, terrain_decal_assets])
		"terrain_tile_assets", "terrain_tile":
			return terrain_tile_assets
		"terrain_decal_assets", "terrain_decal":
			return terrain_decal_assets
		"region_chunk_assets", "region_chunk":
			return region_chunk_assets
		"building_prefab_assets", "building_prefab":
			return building_prefab_assets
		"world_prop_assets", "world_prop":
			return world_prop_assets
		"soft_shadow_assets", "soft_shadow":
			return soft_shadow_assets
		"shadow_assets", "shadow":
			return soft_shadow_assets
		"landmark_assets", "landmark":
			return landmark_assets
		"place_assets", "place":
			return place_assets
		"story_prop_assets", "story_prop":
			return story_prop_assets
		"anchor_assets", "anchor":
			return anchor_assets
		"character_assets", "character":
			return character_assets
		"actor_sprite_assets", "actor_sprite":
			return _merged_assets([character_assets, npc_assets, pet_assets])
		"character_animation_assets", "character_animation":
			return character_animation_assets
		"actor_animation_assets", "actor_animation":
			return _merged_assets([character_animation_assets, pet_animation_assets])
		"furniture_assets", "furniture":
			return furniture_assets
		"npc_assets", "npc":
			return npc_assets
		"pet_assets", "pet":
			return pet_assets
		"pet_animation_assets", "pet_animation":
			return pet_animation_assets
		"animation_metadata_assets", "animation_metadata":
			return animation_metadata_assets
		"actor_animation_metadata_assets", "actor_animation_metadata":
			return animation_metadata_assets
		"card_art", "card":
			return card_art
		"ui_icon_assets", "ui_icon":
			return ui_icon_assets
		"ui_feedback_assets", "ui_feedback":
			return ui_feedback_assets
		"ui_skin", "ui":
			return ui_skin
		"glass_ui_assets", "glass_ui":
			return ui_skin
		"card_frame_assets", "card_frame":
			return card_frame_assets
		_:
			return {}


func _merged_assets(sources: Array) -> Dictionary:
	var merged: Dictionary = {}
	for source in sources:
		if not source is Dictionary:
			continue
		for key in (source as Dictionary).keys():
			merged[key] = (source as Dictionary).get(key)
	return merged
