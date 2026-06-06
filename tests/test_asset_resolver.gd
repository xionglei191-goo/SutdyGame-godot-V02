extends SceneTree

const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const THEME_ID := "theme_sunshine_town_placeholder"
const ANCHOR_ASSET_IDS: Array[String] = [
	"anchor.a.apple_tree", "anchor.b.bear_corner", "anchor.c.clock", "anchor.d.dog_corner", "anchor.e.elephant_slide", "anchor.f.fox_topiary", "anchor.g.school_gate", "anchor.h.hat_sign", "anchor.i.ice_cream_cart", "anchor.j.jacket_window", "anchor.k.kite", "anchor.l.lion_fountain", "anchor.m.monkey_tree", "anchor.n.soft_net", "anchor.o.orange_stall", "anchor.p.panda_corner", "anchor.q.queen_poster", "anchor.r.robot_sign", "anchor.s.sun_landmark", "anchor.t.taxi_marker", "anchor.u.beach_umbrella", "anchor.v.violin_corner", "anchor.w.watch_table", "anchor.x.x_mark_box", "anchor.y.yo_yo_corner", "anchor.z.zebra_edge"
]

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
	_expect_project_asset(AssetResolverScript.get_ui_skin("primary_button", THEME_ID), "ui skin")
	_expect_placeholder(AssetResolverScript.get_card_frame("core", THEME_ID), "card frame")
	_check_polish_assets()

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


func _check_polish_assets() -> void:
	var required_assets := [
		{"category": "place_assets", "asset_id": "place.world_map.base_1280"},
		{"category": "place_assets", "asset_id": "place.home.yard"},
		{"category": "place_assets", "asset_id": "place.home_school_walk.day"},
		{"category": "place_assets", "asset_id": "place.school_gate.exterior"},
		{"category": "place_assets", "asset_id": "place.school_yard.day"},
		{"category": "place_assets", "asset_id": "place.shop_street.day"},
		{"category": "place_assets", "asset_id": "place.animal_park.day"},
		{"category": "place_assets", "asset_id": "place.coast_edge.day"},
		{"category": "place_assets", "asset_id": "place.sun_scene.morning"},
		{"category": "place_assets", "asset_id": "place.story_culture_bridge.day"},
		{"category": "place_assets", "asset_id": "place.town_plaza.day"},
		{"category": "place_assets", "asset_id": "place.home.exterior"},
		{"category": "place_assets", "asset_id": "place.shop.exterior"},
		{"category": "place_assets", "asset_id": "place.road.main"},
		{"category": "place_assets", "asset_id": "place.resource.branch"},
		{"category": "character_assets", "asset_id": "character.player.standing"},
		{"category": "character_assets", "asset_id": "character.mina.standing"},
		{"category": "character_assets", "asset_id": "character.shopkeeper.standing"},
		{"category": "character_assets", "asset_id": "character.story_bear.standing"},
		{"category": "character_assets", "asset_id": "character.bus_helper.standing"},
		{"category": "furniture_assets", "asset_id": "furniture.small_table.placed"},
		{"category": "furniture_assets", "asset_id": "furniture.pet_bowl.placed"},
		{"category": "furniture_assets", "asset_id": "furniture.sunny_bed.placed"},
		{"category": "pet_assets", "asset_id": "pet.sunny.standing"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.coin"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.bag"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.shop"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.close"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.settings"},
		{"category": "ui_skin", "asset_id": "glass_hud_bar"},
		{"category": "ui_skin", "asset_id": "glass_footer_bar"},
		{"category": "ui_skin", "asset_id": "glass_panel_large"},
		{"category": "ui_skin", "asset_id": "glass_panel_small"},
		{"category": "ui_skin", "asset_id": "glass_button_normal"},
		{"category": "ui_skin", "asset_id": "glass_button_pressed"},
		{"category": "ui_skin", "asset_id": "glass_icon_button"},
	]
	var records: Array = AssetResolverScript.get_asset_acceptance_records(THEME_ID)
	for anchor_asset_id in ANCHOR_ASSET_IDS:
		required_assets.append({"category": "anchor_assets", "asset_id": anchor_asset_id})
	for spec in required_assets:
		var category := str(spec.get("category", ""))
		var asset_id := str(spec.get("asset_id", ""))
		var resolved: Dictionary = AssetResolverScript.resolve_asset(THEME_ID, category, asset_id)
		_expect(resolved.get("ok", false), "Polish asset should resolve: %s" % asset_id)
		var asset_path := str(resolved.get("placeholder_path", ""))
		_expect(asset_path.begins_with("res://assets/art/"), "Polish asset should map through project art assets: %s -> %s" % [asset_id, asset_path])
		_expect(FileAccess.file_exists(asset_path), "Polish mapped resource should exist: %s" % asset_path)
		var record: Dictionary = _acceptance_record_for(records, asset_id)
		_expect(not record.is_empty(), "Polish asset should have acceptance record: %s" % asset_id)
		_expect(str(record.get("status", "")) == "production", "Polish asset should be production status: %s" % asset_id)
		_expect(str(record.get("acceptance_result", "")) == "pass", "Polish asset should have pass acceptance result: %s" % asset_id)
		_expect(str(record.get("resource_path_for_mapping", "")) == asset_path, "Acceptance path should match resolver mapping: %s" % asset_id)
		_expect(str(record.get("notes_child_safety", "")).length() > 0, "Polish asset should record child safety notes: %s" % asset_id)
		_expect(str(record.get("notes_anchor_integrity", "")).length() > 0, "Polish asset should record anchor integrity notes: %s" % asset_id)


func _acceptance_record_for(records: Array, asset_id: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str(record.get("logical_asset_id", "")) == asset_id:
			return record
	return {}


func _expect_project_asset(result: Dictionary, label: String) -> void:
	_expect(result.get("ok", false), "%s must resolve: %s" % [label, result.get("errors", [])])
	_expect(result.get("theme_id", "") == THEME_ID, "%s must keep the requested theme id" % label)
	_expect(str(result.get("asset_id", "")).length() > 0, "%s must include logical asset id" % label)
	_expect(str(result.get("placeholder_path", "")).begins_with("res://assets/art/"), "%s must return a project art path" % label)
	_expect(FileAccess.file_exists(str(result.get("placeholder_path", ""))), "%s project art path must exist" % label)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
