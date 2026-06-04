extends SceneTree

const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const THEME_ID := "theme_sunshine_town_placeholder"

var failures: Array[String] = []


func _init() -> void:
	var loaded: Dictionary = AssetResolverScript.load_theme_profile(THEME_ID)
	_expect(loaded.get("ok", false), "placeholder theme must load: %s" % [loaded.get("errors", [])])

	var profile = loaded.get("profile")
	_expect(profile != null, "placeholder theme must return a ThemeProfileResource")
	if profile != null:
		_expect(profile.theme_id == THEME_ID, "theme id must match the world map placeholder theme")
		_expect(profile.placeholder, "theme must be marked as placeholder")

	_expect_placeholder(AssetResolverScript.get_tile_atlas("world", THEME_ID), "world tile atlas")
	_expect_placeholder(AssetResolverScript.get_tile_atlas("tile_home_grass", THEME_ID), "district tile")
	_expect_placeholder(AssetResolverScript.get_landmark_asset("landmark_home_placeholder", THEME_ID), "home landmark")
	_expect_placeholder(AssetResolverScript.get_npc_sprite("mina", THEME_ID), "npc sprite")
	_expect_placeholder(AssetResolverScript.get_pet_sprite("sunny", THEME_ID), "pet sprite")
	_expect_placeholder(AssetResolverScript.get_card_art("card_a_apple_core", THEME_ID), "card art")
	_expect_placeholder(AssetResolverScript.get_ui_skin("primary_button", THEME_ID), "ui skin")
	_expect_placeholder(AssetResolverScript.get_card_frame("core", THEME_ID), "card frame")

	var missing: Dictionary = AssetResolverScript.get_pet_sprite("unknown_pet", THEME_ID)
	_expect(not missing.get("ok", true), "unknown logical asset id must be reported")
	_expect(str(missing.get("placeholder_path", "")).begins_with("placeholder://missing/"), "unknown asset must still return a logical missing placeholder")

	if failures.is_empty():
		print("HEADLESS TESTS PASSED: asset resolver placeholder theme")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect_placeholder(result: Dictionary, label: String) -> void:
	_expect(result.get("ok", false), "%s must resolve: %s" % [label, result.get("errors", [])])
	_expect(result.get("theme_id", "") == THEME_ID, "%s must keep the requested theme id" % label)
	_expect(str(result.get("asset_id", "")).length() > 0, "%s must include logical asset id" % label)
	_expect(str(result.get("placeholder_path", "")).begins_with("placeholder://%s/" % THEME_ID), "%s must return a logical placeholder path" % label)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
