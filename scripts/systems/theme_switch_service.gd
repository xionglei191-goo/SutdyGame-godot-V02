extends RefCounted
class_name ThemeSwitchService

const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const ThemeProfileResourceScript := preload("res://scripts/data/theme_profile_resource.gd")

const DEFAULT_THEME_ID := "theme_sunshine_town_placeholder"
const RAINBOW_THEME_ID := "theme_rainbow_garden_placeholder"
const LOCAL_THEME_PATHS := {
	DEFAULT_THEME_ID: "res://data/themes/theme_sunshine_town_placeholder.json",
	RAINBOW_THEME_ID: "res://data/themes/theme_rainbow_garden_placeholder.json",
}
const REQUIRED_CATEGORIES: Array[String] = [
	"tile_atlas",
	"landmark_assets",
	"npc_assets",
	"pet_assets",
	"card_art",
	"ui_skin",
	"card_frame_assets",
]

var current_theme_id: String = DEFAULT_THEME_ID


func get_current_theme_id() -> String:
	return current_theme_id


func switch_theme(theme_id: String, probe_assets: Array[Dictionary] = []) -> Dictionary:
	var loaded: Dictionary = load_theme_profile(theme_id)
	if not loaded.get("ok", false):
		return {"ok": false, "errors": loaded.get("errors", []), "theme_id": theme_id, "resolved_assets": []}

	var resolved_assets: Array[Dictionary] = []
	var probes := probe_assets
	if probes.is_empty():
		probes = [{"category": "tile_atlas", "asset_id": "world"}]

	var errors: Array[String] = []
	for probe in probes:
		var category := str(probe.get("category", ""))
		var asset_id := str(probe.get("asset_id", ""))
		var resolved: Dictionary = resolve_asset(theme_id, category, asset_id)
		resolved_assets.append(resolved)
		if not resolved.get("ok", false):
			errors.append_array(resolved.get("errors", []))

	if not errors.is_empty():
		return {"ok": false, "errors": errors, "theme_id": theme_id, "resolved_assets": resolved_assets}

	current_theme_id = theme_id
	return {"ok": true, "errors": [], "theme_id": current_theme_id, "resolved_assets": resolved_assets}


func resolve_asset(theme_id: String, category: String, logical_asset_id: String) -> Dictionary:
	if theme_id == DEFAULT_THEME_ID:
		return AssetResolverScript.resolve_asset(theme_id, category, logical_asset_id)

	var loaded: Dictionary = load_theme_profile(theme_id)
	if not loaded.get("ok", false):
		return _missing_result(theme_id, category, logical_asset_id, loaded.get("errors", []))

	var profile = loaded.get("profile")
	var category_assets: Dictionary = profile.get_category_assets(category)
	var placeholder_path := str(category_assets.get(logical_asset_id, ""))
	if placeholder_path.is_empty():
		return _missing_result(theme_id, category, logical_asset_id, ["Unknown logical asset id for category %s: %s" % [category, logical_asset_id]])

	return {
		"ok": true,
		"theme_id": theme_id,
		"category": category,
		"asset_id": logical_asset_id,
		"placeholder_path": placeholder_path,
	}


func load_theme_profile(theme_id: String) -> Dictionary:
	if theme_id == DEFAULT_THEME_ID:
		return AssetResolverScript.load_theme_profile(theme_id)
	if not LOCAL_THEME_PATHS.has(theme_id):
		return {"ok": false, "errors": ["Unknown theme_id: %s" % theme_id], "profile": null}

	var theme_path := str(LOCAL_THEME_PATHS[theme_id])
	var file := FileAccess.open(theme_path, FileAccess.READ)
	if file == null:
		return {"ok": false, "errors": ["Unable to open theme profile: %s" % theme_path], "profile": null}

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {"ok": false, "errors": ["Theme profile root must be a dictionary: %s" % theme_path], "profile": null}

	var profile = ThemeProfileResourceScript.new()
	profile.load_from_dictionary(parsed)
	var errors := _validate_profile(profile, theme_id)
	return {"ok": errors.is_empty(), "errors": errors, "profile": profile}


func _validate_profile(profile: Resource, expected_theme_id: String) -> Array[String]:
	var errors: Array[String] = []
	if profile.theme_id != expected_theme_id:
		errors.append("Theme id mismatch. Expected %s, got %s." % [expected_theme_id, profile.theme_id])
	for category in REQUIRED_CATEGORIES:
		if profile.get_category_assets(category).is_empty():
			errors.append("Theme profile category is empty: %s" % category)
	return errors


func _missing_result(theme_id: String, category: String, logical_asset_id: String, errors: Array = []) -> Dictionary:
	return {
		"ok": false,
		"theme_id": theme_id,
		"category": category,
		"asset_id": logical_asset_id,
		"placeholder_path": "placeholder://missing/%s/%s/%s" % [theme_id, category, logical_asset_id],
		"errors": errors,
	}
