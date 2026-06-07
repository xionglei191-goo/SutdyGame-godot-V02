extends RefCounted
class_name AssetResolver

const DEFAULT_THEME_ID := "theme_sunshine_town_placeholder"
const THEME_PATHS := {
	"theme_sunshine_town_placeholder": "res://data/themes/theme_sunshine_town_placeholder.json",
}
const ThemeProfileResourceScript := preload("res://scripts/data/theme_profile_resource.gd")


static func load_theme_profile(theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	var theme_path: String = THEME_PATHS.get(theme_id, "")
	if theme_path.is_empty():
		return {"ok": false, "errors": ["Unknown theme_id: %s" % theme_id], "profile": null}

	var file := FileAccess.open(theme_path, FileAccess.READ)
	if file == null:
		return {"ok": false, "errors": ["Unable to open theme profile: %s" % theme_path], "profile": null}

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {"ok": false, "errors": ["Theme profile root must be a dictionary: %s" % theme_path], "profile": null}

	var profile := ThemeProfileResourceScript.new()
	profile.load_from_dictionary(parsed)
	var errors := _validate_profile(profile, theme_id)
	return {"ok": errors.is_empty(), "errors": errors, "profile": profile}


static func resolve_asset(theme_id: String, category: String, logical_asset_id: String) -> Dictionary:
	var loaded := load_theme_profile(theme_id)
	if not loaded.get("ok", false):
		return _missing_result(theme_id, category, logical_asset_id, loaded.get("errors", []))

	var profile = loaded.get("profile")
	var category_assets: Dictionary = profile.get_category_assets(category)
	var placeholder_path: String = category_assets.get(logical_asset_id, "")
	if placeholder_path.is_empty():
		return _missing_result(theme_id, category, logical_asset_id, ["Unknown logical asset id for category %s: %s" % [category, logical_asset_id]])

	return {
		"ok": true,
		"theme_id": profile.theme_id,
		"category": category,
		"asset_id": logical_asset_id,
		"placeholder_path": placeholder_path,
	}


static func get_tile_atlas(logical_asset_id: String = "world", theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "tile_atlas", logical_asset_id)


static func get_tile_edge_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "tile_edge_assets", logical_asset_id)


static func get_terrain_edge_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "terrain_edge_assets", logical_asset_id)


static func get_terrain_tile_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "terrain_tile_assets", logical_asset_id)


static func get_terrain_decal_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "terrain_decal_assets", logical_asset_id)


static func get_region_chunk_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "region_chunk_assets", logical_asset_id)


static func get_building_prefab_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "building_prefab_assets", logical_asset_id)


static func get_world_prop_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "world_prop_assets", logical_asset_id)


static func get_soft_shadow_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "soft_shadow_assets", logical_asset_id)


static func get_shadow_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "shadow_assets", logical_asset_id)


static func get_landmark_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "landmark_assets", logical_asset_id)


static func get_place_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "place_assets", logical_asset_id)


static func get_story_prop_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "story_prop_assets", logical_asset_id)


static func get_anchor_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "anchor_assets", logical_asset_id)


static func get_character_sprite(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "character_assets", logical_asset_id)


static func get_actor_sprite(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "actor_sprite_assets", logical_asset_id)


static func get_character_animation(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "character_animation_assets", logical_asset_id)


static func get_actor_animation(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "actor_animation_assets", logical_asset_id)


static func get_furniture_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "furniture_assets", logical_asset_id)


static func get_npc_sprite(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "npc_assets", logical_asset_id)


static func get_pet_sprite(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "pet_assets", logical_asset_id)


static func get_pet_animation(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "pet_animation_assets", logical_asset_id)


static func get_animation_metadata(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "animation_metadata_assets", logical_asset_id)


static func get_actor_animation_metadata(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "actor_animation_metadata_assets", logical_asset_id)


static func get_card_art(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "card_art", logical_asset_id)


static func get_ui_icon(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "ui_icon_assets", logical_asset_id)


static func get_ui_feedback(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "ui_feedback_assets", logical_asset_id)


static func get_ui_skin(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "ui_skin", logical_asset_id)


static func get_glass_ui_asset(logical_asset_id: String, theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "glass_ui_assets", logical_asset_id)


static func get_card_frame(logical_asset_id: String = "core", theme_id: String = DEFAULT_THEME_ID) -> Dictionary:
	return resolve_asset(theme_id, "card_frame_assets", logical_asset_id)


static func get_asset_acceptance_records(theme_id: String = DEFAULT_THEME_ID) -> Array:
	var loaded := load_theme_profile(theme_id)
	if not loaded.get("ok", false):
		return []
	var profile = loaded.get("profile")
	return profile.asset_acceptance.duplicate(true)


static func _validate_profile(profile: Resource, expected_theme_id: String) -> Array[String]:
	var errors: Array[String] = []
	if profile.theme_id.is_empty():
		errors.append("Theme profile must include theme_id.")
	elif profile.theme_id != expected_theme_id:
		errors.append("Theme id mismatch. Expected %s, got %s." % [expected_theme_id, profile.theme_id])

	for category in ["tile_atlas", "terrain_tile_assets", "terrain_edge_assets", "region_chunk_assets", "building_prefab_assets", "world_prop_assets", "shadow_assets", "landmark_assets", "place_assets", "anchor_assets", "actor_sprite_assets", "actor_animation_assets", "actor_animation_metadata_assets", "character_assets", "furniture_assets", "npc_assets", "pet_assets", "card_art", "ui_icon_assets", "glass_ui_assets", "ui_skin", "card_frame_assets"]:
		if profile.get_category_assets(category).is_empty():
			errors.append("Theme profile category is empty: %s" % category)

	return errors


static func _missing_result(theme_id: String, category: String, logical_asset_id: String, errors: Array = []) -> Dictionary:
	return {
		"ok": false,
		"theme_id": theme_id,
		"category": category,
		"asset_id": logical_asset_id,
		"placeholder_path": "placeholder://missing/%s/%s/%s" % [theme_id, category, logical_asset_id],
		"errors": errors,
	}
