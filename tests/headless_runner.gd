extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const ConversationSummaryServiceScript := preload("res://scripts/systems/conversation_summary_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const HomeDecorationServiceScript := preload("res://scripts/systems/home_decoration_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const DailyGreetingServiceScript := preload("res://scripts/systems/daily_greeting_service.gd")
const ResourceRefreshServiceScript := preload("res://scripts/systems/resource_refresh_service.gd")
const NPCRoutineServiceScript := preload("res://scripts/systems/npc_routine_service.gd")
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")
const AnchorInteractionServiceScript := preload("res://scripts/systems/anchor_interaction_service.gd")
const AccountAdapterScript := preload("res://scripts/systems/account_adapter.gd")
const CloudSaveAdapterScript := preload("res://scripts/systems/cloud_save_adapter.gd")
const ContentPackLoaderScript := preload("res://scripts/systems/content_pack_loader.gd")
const ThemeSwitchServiceScript := preload("res://scripts/systems/theme_switch_service.gd")
const ContentReviewPipelineScript := preload("res://scripts/systems/content_review_pipeline.gd")
const ContentContractValidatorScript := preload("res://scripts/systems/content_contract_validator.gd")
const AZWorldPlanContractScript := preload("res://scripts/data/az_world_plan_contract.gd")
const TextbookWorldContractScript := preload("res://scripts/data/textbook_world_contract.gd")
const V0218MapReadabilityTestScript := preload("res://tests/test_v0218_map_readability.gd")
const V0220PlaygateControlsTestScript := preload("res://tests/test_v0220_playgate_controls.gd")
const V0221LivegateHotspotPriorityTestScript := preload("res://tests/test_v0221_livegate_hotspot_priority.gd")
const V0221LivegateShopSchoolArrivalTestScript := preload("res://tests/test_v0221_livegate_shop_school_arrival.gd")
const V0221LivegateFreeLifeSmokeTestScript := preload("res://tests/test_v0221_livegate_free_life_smoke.gd")
const V0222ActorPrefabSplitTestScript := preload("res://tests/test_v0222_actor_prefab_split.gd")
const V0222UISceneSplitTestScript := preload("res://tests/test_v0222_ui_scene_split.gd")
const V0222HiddenGridLifeSystemsTestScript := preload("res://tests/test_v0222_hidden_grid_life_systems.gd")
const V0222HiddengridFinalSmokeTestScript := preload("res://tests/test_v0222_hiddengrid_final_smoke.gd")
const TownMapAuthoringExportTestScript := preload("res://tests/test_town_map_authoring_export.gd")
const V0225Mapauth001ValidationPanelTestScript := preload("res://tests/test_v0225_mapauth001_validation_panel.gd")
const V0225Mapauth002WriteBackServiceTestScript := preload("res://tests/test_v0225_mapauth002_write_back_service.gd")
const V0225Mapauth003PlaceMarkerLoopTestScript := preload("res://tests/test_v0225_mapauth003_place_marker_loop.gd")
const V0225Mapauth004AnchorProtectionTestScript := preload("res://tests/test_v0225_mapauth004_anchor_protection.gd")
const V0225Mapauth005PlaceMoveLinkageTestScript := preload("res://tests/test_v0225_mapauth005_place_move_linkage.gd")
const V0225Mapauth006RegressionPackTestScript := preload("res://tests/test_v0225_mapauth006_regression_pack.gd")
const TownStageLayeredRuntimeTestScript := preload("res://tests/test_town_stage_layered_runtime.gd")
const V0223UIPanelSceneSplitTestScript := preload("res://tests/test_v0223_ui_panel_scene_split.gd")
const V0223ExpapprovalTownPlazaDensityTestScript := preload("res://tests/test_v0223_expapproval_town_plaza_density.gd")
const V0223ExpapprovalHomeLivingDensityTestScript := preload("res://tests/test_v0223_expapproval_home_living_density.gd")
const V0223ExpapprovalShopSettingsGlassTestScript := preload("res://tests/test_v0223_expapproval_shop_settings_glass.gd")
const V0223ExpapprovalSchoolGateYardLifeNoiseTestScript := preload("res://tests/test_v0223_expapproval_school_gate_yard_life_noise.gd")
const V0223Expapproval006RCSmokeTestScript := preload("res://tests/test_v0223_expapproval006_rc_smoke.gd")
const V0224HomeRoomLivingContractTestScript := preload("res://tests/test_v0224_home_room_living_contract.gd")
const V0224TownPlazaOutdoorDecorRulesTestScript := preload("res://tests/test_v0224_town_plaza_outdoor_decor_rules.gd")
const V0224NPCRoutineArrivalSafetyTestScript := preload("res://tests/test_v0224_npc_routine_arrival_safety.gd")
const V0224Homeplaza005RCSmokeTestScript := preload("res://tests/test_v0224_homeplaza005_rc_smoke.gd")
const V026Contentbatch001NPCRoutineBatchTestScript := preload("res://tests/test_v026_contentbatch001_npc_routine_batch.gd")
const V026Contentbatch002ResourcePointsTestScript := preload("res://tests/test_v026_contentbatch002_resource_points.gd")
const V026Contentbatch003AnchorRevisitsTestScript := preload("res://tests/test_v026_contentbatch003_anchor_revisits.gd")
const V026Contentbatch004LookEventsTestScript := preload("res://tests/test_v026_contentbatch004_look_events.gd")
const V027MapeditorLayersInspectorTestScript := preload("res://tests/test_v027_mapeditor_layers_inspector.gd")
const V027MapeditorPlaceSaveTestScript := preload("res://tests/test_v027_mapeditor_place_save.gd")
const V027MapeditorCellPaintingTestScript := preload("res://tests/test_v027_mapeditor_cell_painting.gd")
const V027MapeditorResourceSaveTestScript := preload("res://tests/test_v027_mapeditor_resource_save.gd")
const V027MapeditorNPCRoutineSaveTestScript := preload("res://tests/test_v027_mapeditor_npc_routine_save.gd")
const V027MapeditorAnchorMigrationGuardTestScript := preload("res://tests/test_v027_mapeditor_anchor_migration_guard.gd")
const V027MapeditorFullRegressionTestScript := preload("res://tests/test_v027_mapeditor_full_regression.gd")
const V027MapeditorUsabilityDeclutterTestScript := preload("res://tests/test_v027_mapeditor_usability_declutter.gd")
const V027MapeditorDirectEditDragTestScript := preload("res://tests/test_v027_mapeditor_direct_edit_drag.gd")
const V028MapdogfoodProductionTestScript := preload("res://tests/test_v028_mapdogfood_production.gd")
const V0234Artprod001AssetIntegrationTestScript := preload("res://tests/test_v0234_artprod001_asset_integration.gd")
const V0235RuntimeAnimControlsTestScript := preload("res://tests/test_v0235_runtime_anim_controls.gd")
const V0236Storyslice001RuntimeTestScript := preload("res://tests/test_v0236_storyslice001_runtime.gd")
const V0237Storybatch002ContentPackTestScript := preload("res://tests/test_v0237_storybatch002_content_pack.gd")
const V0237Storybatch003AssetIntegrationTestScript := preload("res://tests/test_v0237_storybatch003_asset_integration.gd")
const V0237Storybatch004RuntimeSmokeTestScript := preload("res://tests/test_v0237_storybatch004_runtime_smoke.gd")
const V0238VisualRecoveryRuntimeTestScript := preload("res://tests/test_v0238_visual_recovery_runtime.gd")
const VoiceProviderAdapterScript := preload("res://scripts/systems/voice_provider_adapter.gd")
const ANCHOR_ASSET_IDS: Array[String] = [
	"anchor.a.apple_tree", "anchor.b.bear_corner", "anchor.c.clock", "anchor.d.dog_corner", "anchor.e.elephant_slide", "anchor.f.fox_topiary", "anchor.g.school_gate", "anchor.h.hat_sign", "anchor.i.ice_cream_cart", "anchor.j.jacket_window", "anchor.k.kite", "anchor.l.lion_fountain", "anchor.m.monkey_tree", "anchor.n.soft_net", "anchor.o.orange_stall", "anchor.p.panda_corner", "anchor.q.queen_poster", "anchor.r.robot_sign", "anchor.s.sun_landmark", "anchor.t.taxi_marker", "anchor.u.beach_umbrella", "anchor.v.violin_corner", "anchor.w.watch_table", "anchor.x.x_mark_box", "anchor.y.yo_yo_corner", "anchor.z.zebra_edge"
]
const AINPCProviderAdapterScript := preload("res://scripts/systems/ai_npc_provider_adapter.gd")
const FriendVisitServiceScript := preload("res://scripts/systems/friend_visit_service.gd")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const WorldMapContractScript := preload("res://scripts/data/world_map_contract.gd")
const MainScene := preload("res://scenes/main.tscn")
const WorldOverviewScene := preload("res://scenes/map_editor/world_overview.tscn")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

var failures: Array[String] = []


func _init() -> void:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "world_map.json must load and validate: %s" % [result.get("errors", [])])

	var data: Dictionary = result.get("data", {})
	var summary: Dictionary = RuntimeMapBuilderScript.build_summary(data)
	_expect(int(summary.get("place_count", 0)) >= 6, "runtime map must contain Home, Town Start, Supermarket, Home-School Walk, School Gate, and School Yard")
	_expect(summary.get("anchor_count") == 26, "minimum map must contain all 26 A-Z memory palace anchors")
	_expect(_letters(data) == _az_letters(), "memory anchors must follow A-Z route order")

	var invalid: Dictionary = data.duplicate(true)
	var occupied_place_index := _first_place_with_occupied_cells(invalid.get("places", []))
	invalid["places"][occupied_place_index]["interaction_cell"] = invalid["places"][occupied_place_index]["occupied_cells"][0]
	var invalid_errors: Array[String] = WorldMapContractScript.validate_map(invalid)
	_expect(not invalid_errors.is_empty(), "invalid interaction overlap must be rejected")

	var main := MainScene.instantiate()
	root.add_child(main)
	main.call("_ready")
	_expect(main.find_child("RuntimeMap", true, false) != null, "main scene must create RuntimeMap")
	_expect(main.find_children("RoadCell", "", true, false).size() > 0, "main scene must create visible road cells")
	_expect(main.find_child("place_home", true, false) != null, "main scene must create Home marker")
	_expect(main.find_child("place_town_start", true, false) != null, "main scene must create Town Start marker")
	_expect(main.find_child("place_supermarket", true, false) != null, "main scene must create Supermarket marker")
	_expect(main.find_child("place_home_school_walk", true, false) != null, "main scene must create Home-School Walk marker")
	_expect(main.find_child("place_school_gate", true, false) != null, "main scene must create School Gate marker")
	_expect(main.find_child("place_school_yard", true, false) != null, "main scene must create School Yard marker")
	_expect(main.find_child("anchor_a_apple", true, false) != null, "main scene must create anchor markers")
	_expect(main.find_child("anchor_e_elephant", true, false) != null, "main scene must create reserved A-Z anchor markers")
	_expect(main.find_child("interaction_home_entry", true, false) != null, "main scene must create hotspot markers")
	_expect(main.find_children("CollisionCell", "", true, false).size() > 0, "main scene must create collision markers")
	_expect(main.find_child("TownHUD", true, false) != null, "main scene must expose top message HUD")
	_expect(main.find_child("TownFooter", true, false) != null, "main scene must expose bottom action bar")
	_expect(main.find_child("Player", true, false) != null, "main scene must create player marker")
	for npc_id in ["mina", "shopkeeper", "pet_buddy", "bus_helper", "story_bear"]:
		_expect(main.find_child("npc_%s" % npc_id, true, false) != null, "main scene must create NPC marker: %s" % npc_id)
	_check_asset_resolver()
	_check_save_service()
	_check_service_loop_smoke()
	_check_ai_npc_stubs()
	_check_voice_ai_social_stubs()
	_check_life_services()
	_check_daily_requests()
	_check_anchor_interactions()
	_check_map_editor_round_trip()
	_check_child_experience_and_mobile_acceptance(main)
	_check_account_cloud_stubs()
	_check_content_theme_review_stubs()
	_check_content_contracts()
	_check_playable_ui_operations()
	_check_v028_daily_life_slice()
	_check_v029_weekly_return_smoke()
	_check_v0210_p1_return_smoke()
	_check_v0211_weather_slice_smoke()
	_check_v0212_az_world_plan()
	_check_v0213_textbook_world_plan()
	_check_v0214_homeschool_slice()
	_check_v0215_school_daily_slice()
	_check_v0216_playable_rc_gate()
	_check_v0218_map_readability()
	_check_v0220_playgate_controls()
	_check_v0221_livegate_hotspot_priority()
	_check_v0221_livegate_shop_school_arrival()
	_check_v0221_livegate_free_life_smoke()
	_check_v0222_actor_prefab_split()
	_check_v0222_ui_scene_split()
	_check_v0222_hidden_grid_life_systems()
	_check_v0222_hiddengrid_final_smoke()
	_check_town_map_authoring_export()
	_check_v0225_mapauth001_validation_panel()
	_check_v0225_mapauth002_write_back_service()
	_check_v0225_mapauth003_place_marker_loop()
	_check_v0225_mapauth004_anchor_protection()
	_check_v0225_mapauth005_place_move_linkage()
	_check_v0225_mapauth006_regression_pack()
	_check_town_stage_layered_runtime()
	_check_v0223_ui_panel_scene_split()
	_check_v0223_expapproval_town_plaza_density()
	_check_v0223_expapproval_home_living_density()
	_check_v0223_expapproval_shop_settings_glass()
	_check_v0223_expapproval_school_gate_yard_life_noise()
	_check_v0223_expapproval006_rc_smoke()
	_check_v0224_home_room_living_contract()
	_check_v0224_town_plaza_outdoor_decor_rules()
	_check_v0224_npc_routine_arrival_safety()
	_check_v0224_homeplaza005_rc_smoke()
	_check_v026_contentbatch001_npc_routine_batch()
	_check_v026_contentbatch002_resource_points()
	_check_v026_contentbatch003_anchor_revisits()
	_check_v026_contentbatch004_look_events()
	_check_v027_mapeditor_layers_inspector()
	_check_v027_mapeditor_place_save()
	_check_v027_mapeditor_cell_painting()
	_check_v027_mapeditor_resource_save()
	_check_v027_mapeditor_npc_routine_save()
	_check_v027_mapeditor_anchor_migration_guard()
	_check_v027_mapeditor_full_regression()
	_check_v027_mapeditor_usability_declutter()
	_check_v027_mapeditor_direct_edit_drag()
	_check_v028_mapdogfood_production()
	_check_v0234_artprod001_asset_integration()
	_check_v0235_runtime_anim_controls()
	_check_v0236_storyslice001_runtime()
	_check_v0237_storybatch002_content_pack()
	_check_v0237_storybatch003_asset_integration()
	_check_v0237_storybatch004_runtime_smoke()
	_check_v0238_visual_recovery_runtime()
	_check_voice_ai_social_stubs()

	if failures.is_empty():
		print("HEADLESS TESTS PASSED: map contract and runtime loader")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _letters(data: Dictionary) -> Array[String]:
	var letters: Array[String] = []
	for anchor in data.get("memory_anchors", []):
		letters.append(anchor.get("letter", ""))
	return letters


func _az_letters() -> Array[String]:
	var letters: Array[String] = []
	for code in range(65, 91):
		letters.append(char(code))
	return letters


func _check_save_service() -> void:
	var service = SaveServiceScript.new("user://headless_runner_save_stub.json")
	_expect(service.clear_for_test(), "SaveService test save should clear")
	var profile := service.load_profile()
	profile["display_name"] = "Headless"
	_expect(service.save_profile(profile), "SaveService should save profile")
	_expect(service.save_game_state({"coins": 7, "current_place_id": "place_home", "pet": {}, "inventory": {}, "flags": {}}), "SaveService should save game_state")
	var reloaded = SaveServiceScript.new("user://headless_runner_save_stub.json")
	_expect(reloaded.load_profile().get("display_name", "") == "Headless", "SaveService profile should round-trip in main runner")
	_expect(int(reloaded.load_game_state().get("coins", -1)) == 7, "SaveService game_state should round-trip in main runner")
	_expect(reloaded.clear_for_test(), "SaveService test save should clean up")


func _check_asset_resolver() -> void:
	var loaded: Dictionary = AssetResolverScript.load_theme_profile("theme_sunshine_town_placeholder")
	_expect(loaded.get("ok", false), "AssetResolver should load placeholder theme: %s" % [loaded.get("errors", [])])
	var landmark: Dictionary = AssetResolverScript.get_landmark_asset("landmark_home_placeholder")
	_expect(landmark.get("ok", false), "AssetResolver should resolve home landmark")
	_expect(str(landmark.get("placeholder_path", "")).begins_with("placeholder://"), "AssetResolver must return logical placeholder path")
	_check_polish_p0_asset_resolver_records()


func _check_polish_p0_asset_resolver_records() -> void:
	var theme_id := "theme_sunshine_town_placeholder"
	var required_assets := [
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
		{"category": "pet_assets", "asset_id": "pet.sunny.standing"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.coin"},
		{"category": "ui_icon_assets", "asset_id": "ui_icon.bag"},
		{"category": "terrain_edge_assets", "asset_id": "tile_edge.grass_path.soft"},
		{"category": "terrain_tile_assets", "asset_id": "terrain.grass.soft_tile"},
		{"category": "terrain_tile_assets", "asset_id": "terrain.path.soft_tile"},
		{"category": "terrain_tile_assets", "asset_id": "terrain.plaza.warm_tile"},
		{"category": "region_chunk_assets", "asset_id": "region.home.edge_chunk"},
		{"category": "region_chunk_assets", "asset_id": "region.town_plaza.chunk"},
		{"category": "region_chunk_assets", "asset_id": "region.shop_street.chunk"},
		{"category": "region_chunk_assets", "asset_id": "region.school_line.chunk"},
		{"category": "building_prefab_assets", "asset_id": "building.home.cottage"},
		{"category": "building_prefab_assets", "asset_id": "building.shop.market"},
		{"category": "building_prefab_assets", "asset_id": "building.school.gate"},
		{"category": "world_prop_assets", "asset_id": "world_prop.anchor.apple_basket"},
		{"category": "world_prop_assets", "asset_id": "world_prop.anchor.clock_corner"},
		{"category": "world_prop_assets", "asset_id": "world_prop.home.sunny_corner"},
		{"category": "soft_shadow_assets", "asset_id": "soft_shadow.oval.default"},
		{"category": "shadow_assets", "asset_id": "soft_shadow.oval.default"},
		{"category": "actor_sprite_assets", "asset_id": "character.player.standing"},
		{"category": "actor_animation_assets", "asset_id": "anim_sheet.player.p0_motion"},
		{"category": "glass_ui_assets", "asset_id": "glass_hud_bar"},
	]
	var world_base: Dictionary = AssetResolverScript.get_place_asset("place.world_map.base_1280", theme_id)
	_expect(world_base.get("ok", false), "V02.38 reference world map base should still resolve in headless runner")
	_expect(str(world_base.get("placeholder_path", "")).ends_with("world_map_base_1280.png"), "V02.38 world map base should remain reference-only historical asset")
	var records: Array = AssetResolverScript.get_asset_acceptance_records(theme_id)
	var world_base_record: Dictionary = _asset_acceptance_record_for(records, "place.world_map.base_1280")
	_expect(str(world_base_record.get("status", "")) == "reference_only", "V02.38 world map base should be reference-only in asset acceptance")
	_expect(str(world_base_record.get("acceptance_result", "")) == "reference_only", "V02.38 world map base should not carry current production approval")
	for anchor_asset_id in ANCHOR_ASSET_IDS:
		required_assets.append({"category": "anchor_assets", "asset_id": anchor_asset_id})
	for spec in required_assets:
		var category := str(spec.get("category", ""))
		var asset_id := str(spec.get("asset_id", ""))
		var resolved: Dictionary = AssetResolverScript.resolve_asset(theme_id, category, asset_id)
		_expect(resolved.get("ok", false), "P0 polish asset should resolve in headless runner: %s" % asset_id)
		var asset_path := str(resolved.get("placeholder_path", ""))
		_expect(asset_path.begins_with("res://assets/art/"), "P0 polish asset should map to project art: %s" % asset_id)
		_expect(FileAccess.file_exists(asset_path), "P0 polish asset file should exist: %s" % asset_path)
		var record: Dictionary = _asset_acceptance_record_for(records, asset_id)
		_expect(str(record.get("status", "")) == "production", "P0 polish asset should be production: %s" % asset_id)
		_expect(str(record.get("acceptance_result", "")) == "pass", "P0 polish asset should have pass result: %s" % asset_id)


func _asset_acceptance_record_for(records: Array, asset_id: String) -> Dictionary:
	for record in records:
		if record is Dictionary and str(record.get("logical_asset_id", "")) == asset_id:
			return record
	return {}


func _check_service_loop_smoke() -> void:
	var service := SaveServiceScript.new("user://headless_runner_loop_stub.json")
	_expect(service.clear_for_test(), "service loop save should clear")
	var quest := QuestEventServiceScript.new(service)
	var minigame := MinigameServiceScript.new(service)
	_expect(quest.start_chain().get("ok", false), "service loop should start quest chain")
	for event_id in ["event_welcome_home", "event_meet_sunny", "event_snack_time", "event_food_trip"]:
		_expect(quest.advance_event(event_id).get("ok", false), "service loop should advance: %s" % event_id)
	_expect(minigame.complete_minigame({"config_set_id": "food", "score": 80}).get("ok", false), "service loop should complete Letter Snake service result")
	for event_id in ["event_letter_snake_food", "event_food_basket", "event_feed_sunny"]:
		_expect(quest.advance_event(event_id).get("ok", false), "service loop should advance: %s" % event_id)
	var state: Dictionary = service.load_game_state()
	_expect(bool(state.get("flags", {}).get("sunny_first_snack_done", false)), "service loop should set completion flag")
	_expect(service.clear_for_test(), "service loop save should clean up")


func _check_ai_npc_stubs() -> void:
	var service := SaveServiceScript.new("user://headless_runner_ai_stub.json")
	_expect(service.clear_for_test(), "AI stub save should clear")
	_expect(service.reset_for_test(), "AI stub save should reset")
	var memory_store = NPCMemoryStoreScript.new(service)
	_expect(memory_store.load_all().get("ok", false), "NPCMemoryStore should load first batch profiles")
	var client = LLMClientScript.new(memory_store)
	var reply: Dictionary = client.complete_chat("mina", "hello", {"event_id": "event_welcome_home"})
	_expect(reply.get("ok", false), "LLMClient should return local stub reply")
	_expect(not bool(reply.get("network_used", true)), "LLMClient should not use network")
	var summary_service = ConversationSummaryServiceScript.new(service, memory_store)
	var summary: Dictionary = summary_service.record_interaction("pet_buddy", {
		"event_id": "event_feed_sunny",
		"title": "Feed Sunny",
		"summary": "Child fed Sunny after earning local coins.",
		"words": ["feed", "food"],
	})
	_expect(summary.get("ok", false), "ConversationSummaryService should record local summary")
	_expect(service.load_learning_record().get("npc_summary_refs", []).size() == 1, "NPC summary ref should persist")
	_expect(service.clear_for_test(), "AI stub save should clean up")


func _check_life_services() -> void:
	var service := SaveServiceScript.new("user://headless_runner_life_services.json")
	_expect(service.clear_for_test(), "life services save should clear")
	_expect(service.reset_for_test(), "life services save should reset")
	var inventory = InventoryServiceScript.new(service)
	_expect(inventory.is_loaded(), "InventoryService should load life item catalog")
	_expect(inventory.collect_item("branch", 1).get("ok", false), "InventoryService should collect branch")
	var game_state: Dictionary = service.load_game_state()
	game_state["coins"] = 10
	_expect(service.save_game_state(game_state), "life services should save coins setup")
	var shop = LifeShopServiceScript.new(service, inventory)
	_expect(shop.buy_life_item("wooden_chair").get("ok", false), "LifeShopService should buy wooden chair")
	var home = HomeDecorationServiceScript.new(service, inventory)
	var placed: Dictionary = home.place_furniture("wooden_chair", Vector2i(2, 2))
	_expect(placed.get("ok", false), "HomeDecorationService should place wooden chair")
	_expect(home.get_home_state().get("placed_furniture", []).size() == 1, "HomeDecorationService should persist furniture")
	var instance_id := str(placed.get("furniture", {}).get("instance_id", ""))
	_expect(home.rotate_furniture(instance_id).get("ok", false), "HomeDecorationService should rotate furniture")
	_expect(home.pickup_furniture(instance_id).get("ok", false), "HomeDecorationService should pick up furniture")
	game_state = service.load_game_state()
	game_state["coins"] = 12
	_expect(service.save_game_state(game_state), "life services should save pet furniture coins setup")
	_expect(shop.buy_life_item("pet_bowl").get("ok", false), "LifeShopService should buy pet bowl")
	_expect(home.place_furniture("pet_bowl", Vector2i(0, 0)).get("ok", false), "HomeDecorationService should place pet bowl")
	var feedback: Dictionary = home.get_sunny_feedback()
	_expect(feedback.get("ok", false) and str(feedback.get("text", "")).contains("Sunny"), "HomeDecorationService should provide Sunny home feedback")
	_expect(service.clear_for_test(), "life services save should clean up")


func _check_daily_requests() -> void:
	var service := SaveServiceScript.new("user://headless_runner_daily_requests.json")
	_expect(service.clear_for_test(), "daily request save should clear")
	_expect(service.reset_for_test(), "daily request save should reset")
	var day = LocalDayServiceScript.new("2026-06-04")
	var inventory = InventoryServiceScript.new(service)
	var greetings = DailyGreetingServiceScript.new(service, day)
	var resources = ResourceRefreshServiceScript.new(service, inventory, day)
	var today = TodayStatusServiceScript.new(day)
	var daily = DailyRequestServiceScript.new(service, inventory, day)
	var shop = LifeShopServiceScript.new(service, inventory)
	_expect(greetings.is_loaded(), "DailyGreetingService should load greeting data")
	_expect(resources.is_loaded(), "ResourceRefreshService should load resource data")
	_expect(today.is_loaded(), "TodayStatusService should load today status data")
	_expect(daily.is_loaded(), "DailyRequestService should load request data")
	_expect(daily.get_request("daily_shopkeeper_flower_001").get("ok", false), "DailyRequestService should load shopkeeper request")
	_expect(daily.get_request("daily_story_bear_stone_001").get("ok", false), "DailyRequestService should load story bear request")
	_expect(daily.get_request("daily_sunny_flower_001").get("ok", false), "DailyRequestService should load Sunny request")
	var greeting: Dictionary = greetings.interact_for_npc("mina", false)
	_expect(greeting.get("ok", false) and bool(greeting.get("first_today", false)), "daily greeting should persist first NPC greeting")
	_expect(bool(service.load_game_state().get("daily_greetings", {}).get("2026-06-04", {}).get("mina", {}).get("greeted", false)), "daily greeting should save by day key")
	_expect(daily.interact_for_npc("mina").get("request_status", "") == "active", "daily request should start with Mina")
	_expect(resources.collect_resource("resource_branch_bear_corner").get("ok", false), "daily branch resource should be collectable")
	_expect(not resources.collect_resource("resource_branch_bear_corner").get("ok", true), "daily branch resource should not repeat same day")
	var complete: Dictionary = daily.interact_for_npc("mina")
	_expect(complete.get("request_status", "") == "completed", "daily request should complete with branch")
	_expect(int(service.load_game_state().get("coins", -1)) == 6, "daily request should award coins")
	_expect(bool(service.load_game_state().get("daily_requests", {}).get("2026-06-04", {}).get("daily_mina_branch_001", {}).get("completed_today", false)), "daily request completion should persist by day key")
	day.set_day_key_for_test("2026-06-05")
	_expect(resources.collect_resource("resource_branch_bear_corner").get("ok", false), "daily resources should refresh on next day key")
	_expect(str(today.get_today_status().get("hud_text", "")).contains("Sunny"), "today status should expose a soft Sunny hint")
	_expect(str(today.get_today_status().get("weather_event_id", "")).begins_with("event_weather_"), "today status should expose a weather event id")
	_check_weekly_status_and_shop_rotations(shop)
	_expect(service.clear_for_test(), "daily request save should clean up")


func _check_weekly_status_and_shop_rotations(shop) -> void:
	var seen_events: Dictionary = {}
	var seen_weather_events: Dictionary = {}
	var seen_weather_greetings: Dictionary = {}
	var seen_p2 := false
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		var weekly_day = LocalDayServiceScript.new(day_key)
		var weekly_today = TodayStatusServiceScript.new(weekly_day)
		var weekly_greetings = DailyGreetingServiceScript.new(SaveServiceScript.new("user://headless_runner_weather_greetings_%s.json" % day_key), weekly_day)
		var weekly_resources = ResourceRefreshServiceScript.new(SaveServiceScript.new("user://headless_runner_weather_resources_%s.json" % day_key), InventoryServiceScript.new(SaveServiceScript.new("user://headless_runner_weather_resources_%s.json" % day_key)), weekly_day)
		_expect(weekly_today.is_loaded(), "weekly today status should load: %s" % day_key)
		var status: Dictionary = weekly_today.get_today_status()
		_expect(status.get("ok", false), "weekly today status should resolve: %s" % day_key)
		_expect(str(status.get("day_key", "")) == day_key, "weekly today status should keep day key: %s" % day_key)
		_expect(str(status.get("anchor_hint", "")).length() > 0, "weekly today status should include anchor hint: %s" % day_key)
		_expect(str(status.get("hud_text", "")).contains(str(status.get("today_status_text", ""))), "weekly today status should include weather HUD text: %s" % day_key)
		seen_events[str(status.get("event", ""))] = true
		var weather_event_id := str(status.get("weather_event_id", ""))
		seen_weather_events[weather_event_id] = true
		var weather_greeting: Dictionary = weekly_greetings.interact_for_npc(_weather_test_npc(weather_event_id))
		_expect(str(weather_greeting.get("weather_event_id", "")) == weather_event_id, "weekly weather greeting should match event: %s" % day_key)
		_expect(str(weather_greeting.get("greeting_variant_id", "")).begins_with("weather_"), "weekly weather greeting should use data variant: %s" % day_key)
		seen_weather_greetings[weather_event_id] = true
		var available_points: Array = weekly_resources.get_available_points()
		_expect(available_points.size() >= 3, "weather should not hide baseline resource points: %s" % day_key)
		for point in available_points:
			if point is Dictionary:
				_expect(int((point as Dictionary).get("quantity", 0)) >= 1, "weather should not reduce resource quantity: %s" % day_key)
		var rotation: Dictionary = shop.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "weekly shop rotation should resolve: %s" % day_key)
		_expect(str(rotation.get("weather_activity_corner", {}).get("weather_event_id", "")) == weather_event_id, "weekly shop activity corner should match weather event: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "weekly shop rotation should keep P0 offers: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "weekly shop rotation should keep chair offer: %s" % day_key)
		if _rotation_has_tier(rotation, "P2"):
			seen_p2 = true
	_expect(seen_events.size() == 7, "weekly status should provide 7 distinct gentle events")
	_expect(seen_weather_events.size() == 4, "weekly status should cover four P0 weather events")
	_expect(seen_weather_greetings.size() == 4, "weekly greetings should cover four P0 weather variants")
	_expect(seen_p2, "weekly shop rotations should include at least one P2 light variant")


func _rotation_has_item(rotation: Dictionary, item_id: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("item_id", "")) == item_id:
			return true
	return false


func _rotation_has_tier(rotation: Dictionary, tier: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("rotation_tier", "")) == tier:
			return true
	return false


func _weather_test_npc(weather_event_id: String) -> String:
	match weather_event_id:
		"event_weather_sunny_soft_001":
			return "pet_buddy"
		"event_weather_breezy_kite_001":
			return "bus_helper"
		"event_weather_after_rain_001":
			return "mina"
		"event_weather_light_rain_001":
			return "story_bear"
	return "mina"


func _check_anchor_interactions() -> void:
	var service := SaveServiceScript.new("user://headless_runner_anchor_interactions.json")
	_expect(service.clear_for_test(), "anchor interaction save should clear")
	_expect(service.reset_for_test(), "anchor interaction save should reset")
	var card_service = MemoryCardServiceScript.new(service)
	var anchor_service = AnchorInteractionServiceScript.new(service, card_service)
	_expect(anchor_service.is_loaded(), "AnchorInteractionService should load new-word revisit data")
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	var anchor: Dictionary = _anchor_by_id(map_result.get("data", {}).get("memory_anchors", []), "anchor_a_apple")
	var result: Dictionary = anchor_service.interact_with_anchor(anchor)
	_expect(result.get("ok", false), "AnchorInteractionService should interact with a world anchor")
	_expect(bool(card_service.get_card_state("card_a_apple_core").get("collected", false)), "anchor interaction should update album collected state")
	for story in anchor_service.get_all_stories():
		for field in ["letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]:
			_expect(not str(story.get(field, "")).is_empty(), "new-word revisit story should include %s" % field)
	_expect(service.clear_for_test(), "anchor interaction save should clean up")


func _anchor_by_id(anchors: Array, anchor_id: String) -> Dictionary:
	for anchor in anchors:
		if anchor is Dictionary and str(anchor.get("anchor_id", "")) == anchor_id:
			return anchor
	return {}


func _check_map_editor_round_trip() -> void:
	var scene: Control = WorldOverviewScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var grid: Dictionary = scene.call("get_grid_summary")
	_expect(grid.get("canvas_w") == 60 and grid.get("canvas_h") == 34, "Map editor grid should match 60x34 world canvas")
	_expect(grid.get("logical_cell_w") == 32 and grid.get("logical_cell_h") == 32, "Map editor grid should preserve runtime logical cell size")
	var road_add: Dictionary = scene.call("toggle_road_cell_for_test", "road_home_plaza_ring", Vector2i(26, 16))
	_expect(road_add.get("ok", false), "Map editor should add road cell")
	_expect(bool(scene.call("has_road_cell", "road_home_plaza_ring", Vector2i(26, 16))), "Map editor should read added road cell")
	var occupied: Dictionary = scene.call("set_occupied_cell_for_test", Vector2i(2, 2), true)
	_expect(occupied.get("ok", false), "Map editor should set occupied cell")
	var blocked: Dictionary = scene.call("set_interaction_cell_for_test", "interaction_headless_blocked", "place_home", Vector2i(2, 2))
	_expect(not blocked.get("ok", true), "Map editor should reject interaction over occupied cell")
	var moved: Dictionary = scene.call("move_place_marker_for_test", "place_home", Vector2i(8, 9))
	_expect(moved.get("ok", false), "Map editor should command-track place moves")
	_expect(scene.call("undo_for_test").get("ok", false), "Map editor should undo place move")
	_expect(scene.call("redo_for_test").get("ok", false), "Map editor should redo place move")
	scene.call("undo_for_test")
	scene.call("undo_for_test")
	scene.call("undo_for_test")
	var exported: Dictionary = MapEditorSyncServiceScript.export_to_dictionary(scene.call("get_editor_state"))
	_expect(exported.get("ok", false), "Map editor state should export as valid world map: %s" % [exported.get("errors", [])])
	_expect(exported.get("data", {}).get("memory_anchors", []).size() == 26, "Map editor export should preserve all A-Z anchors")
	root.remove_child(scene)
	scene.queue_free()


func _check_child_experience_and_mobile_acceptance(main: Control) -> void:
	var visible_text := _collect_visible_text(main).to_lower()
	for blocked in ["failed", "wrong", "test", "exam", "report", "dashboard", "parent"]:
		_expect(not visible_text.contains(blocked), "child flow should not show blocked text: %s" % blocked)
	for placeholder in ["studygame v02", "godot", "skeleton", "loaded places", "from json"]:
		_expect(not visible_text.contains(placeholder), "child flow should not show engineering placeholder text: %s" % placeholder)
	_expect(visible_text.contains("阳光小镇"), "child flow should present a localized Sunshine Town identity")
	var parent_spec: Dictionary = main.call("get_parent_entry_spec")
	_expect(not bool(parent_spec.get("child_flow_visible", true)), "parent entry should not be visible in child flow")
	_expect(not bool(parent_spec.get("network_required", true)), "parent entry should not require network")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_width") == 1280, "mobile baseline viewport width should be 1280")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_height") == 720, "mobile baseline viewport height should be 720")
	_expect(str(ProjectSettings.get_setting("rendering/renderer/rendering_method")) == "mobile", "Godot renderer should stay mobile-oriented")
	var nav := main.find_child("Navigation", true, false)
	_expect(nav != null and (nav as Control).custom_minimum_size.x >= 220.0, "touch navigation should reserve a usable width")
	_expect(nav != null and not (nav as Control).visible, "legacy left navigation should be hidden behind the playfield HUD")
	_expect(main.find_child("TownStage", true, false) != null, "main scene should expose a full playfield stage")
	var hud := main.find_child("TownHUD", true, false)
	_expect(hud != null, "main scene should keep only lightweight town HUD")
	_expect(hud != null and hud is Control and (hud as Control).anchor_top <= 0.03 and (hud as Control).anchor_right >= 0.95, "town HUD should be a top message bar, not a side status panel")
	var coin_state := main.find_child("CoinState", true, false) as Label
	var pet_state := main.find_child("PetState", true, false) as Label
	_expect(coin_state != null and coin_state.get_theme_stylebox("normal") != null and str(coin_state.text).is_valid_int(), "coin HUD state should be a compact icon-plus-number badge")
	_expect(pet_state != null and pet_state.get_theme_stylebox("normal") != null and str(pet_state.text).contains("心") and not str(pet_state.text).contains("金币"), "pet HUD state should keep Sunny snack and happy separate from coins")
	_expect(main.get_node_or_null("Header") == null, "town title should not return as a root-level second top banner")
	_expect(hud != null and hud.find_child("Title", true, false) != null, "town title should stay folded into the single-line HUD")
	_expect(hud != null and hud is Control and (hud as Control).offset_bottom <= 52.0, "town HUD should stay compact enough to leave the playfield visible")
	var footer := main.find_child("TownFooter", true, false)
	_expect(footer != null and footer is Control and (footer as Control).anchor_top == 1.0, "main actions should sit in a bottom button bar")
	_expect(footer != null and footer is Control and (footer as Control).anchor_left >= 0.2 and (footer as Control).anchor_right <= 0.8, "bottom footer should be compact and centered, not a wide empty strip")
	var visible_footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(visible_footer_actions != null and visible_footer_actions.get_child_count() == 4, "bottom footer should keep only Interact, Town, Home, and Backpack visible")
	var backpack_button := main.find_child("BackpackNavButton", true, false) as Button
	var backpack_bubble := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack_button != null and backpack_bubble != null, "backpack navigation should expose a lightweight content bubble")
	_expect(backpack_bubble != null and not backpack_bubble.visible and backpack_bubble.anchor_left >= 0.5, "backpack bubble should be hidden by default and stay compact on the right")
	if visible_footer_actions != null:
		for child in visible_footer_actions.get_children():
			var footer_button := child as Button
			_expect(footer_button != null and footer_button.custom_minimum_size.x <= 110.0 and footer_button.custom_minimum_size.y <= 50.0, "footer buttons should stay compact and stable")
			_expect(footer_button != null and footer_button.get_theme_stylebox("normal") != null and footer_button.get_theme_stylebox("hover") != null and footer_button.get_theme_stylebox("pressed") != null, "footer buttons should expose normal, hover, and pressed visual states")
	for hidden_button_name in ["StartButton", "HelpNeighborButton", "BuyFoodButton", "FeedSunnyButton", "MemoryAlbumButton", "LetterSnakeButton"]:
		var hidden_button := main.find_child(hidden_button_name, true, false) as Button
		_expect(hidden_button != null and not hidden_button.is_visible_in_tree(), "legacy/test shortcut should be hidden from child footer: %s" % hidden_button_name)
	_expect(main.find_child("LifeRPGPanel", true, false) == null, "life status should not cover the playfield as a large panel")
	_expect(main.find_child("HomePetLoopPanel", true, false) == null, "pocket state should not cover the playfield as a large panel")
	_expect(main.find_child("OptionalActivityPanel", true, false) == null, "optional activities should not cover the playfield as a large panel")
	var runtime_map := main.find_child("RuntimeMap", true, false)
	_expect(runtime_map != null and runtime_map is Node2D, "RuntimeMap must be a Node2D playfield layer")
	_expect(runtime_map != null and _count_nodes_of_type(runtime_map, "Sprite2D") >= 30, "RuntimeMap should be built from Sprite2D-style assets")
	var visual_stage := main.find_child("TownStage", true, false)
	_expect(visual_stage != null and visual_stage.has_method("get_visual_recovery_snapshot"), "RuntimeMap should expose V02.38 modular visual recovery proof")
	if visual_stage != null and visual_stage.has_method("get_visual_recovery_snapshot"):
		var visual_snapshot: Dictionary = visual_stage.call("get_visual_recovery_snapshot")
		_expect(int(visual_snapshot.get("terrain_tile_count", 0)) >= 100, "RuntimeMap ground should be composed from modular sprite terrain tiles")
		_expect(not bool(visual_snapshot.get("uses_full_map_background", true)), "RuntimeMap should not use the historical full-map background as final ground")
	_expect(runtime_map != null and runtime_map.find_child("RoadCell", true, false) is Sprite2D, "RuntimeMap roads should be sprite assets")
	var player := main.find_child("Player", true, false)
	_expect(player != null and player is Node2D and not player is Label, "player marker should be a sprite character, not text")
	_expect(player != null and player.find_child("Body", true, false) is Sprite2D, "player should include sprite body art")
	for npc_id in ["mina", "shopkeeper", "pet_buddy", "bus_helper", "story_bear"]:
		var npc := main.find_child("npc_%s" % npc_id, true, false)
		_expect(npc != null and npc is Node2D and not npc is Label, "NPC should be an animal resident sprite, not a text dot: %s" % npc_id)
		_expect(npc != null and npc.find_child("Head", true, false) is Sprite2D, "NPC should include sprite head art: %s" % npc_id)
	for anchor_id in ["anchor_a_apple", "anchor_c_clock", "anchor_d_dog", "anchor_o_orange"]:
		var anchor := main.find_child(anchor_id, true, false)
		var object_sprite := anchor.find_child("ObjectSprite", true, false) if anchor != null else null
		var object_label := anchor.find_child("ObjectLabel", true, false) if anchor != null else null
		_expect(anchor != null and anchor is Node2D, "anchor should be hidden in a world object: %s" % anchor_id)
		_expect(object_sprite != null and object_sprite is Sprite2D, "anchor should use a sprite object: %s" % anchor_id)
		_expect(not (object_label is Label), "anchor should not be represented by a bare text label: %s" % anchor_id)
	var safe_area := main.find_child("SafeArea", true, false)
	_expect(safe_area != null, "main scene should include a safe area container")


func _count_nodes_of_type(node: Node, type_name: String) -> int:
	var count := 0
	if node.get_class() == type_name:
		count += 1
	for child in node.get_children():
		count += _count_nodes_of_type(child, type_name)
	return count


func _collect_visible_text(node: Node) -> String:
	var parts: Array[String] = []
	if node is Label:
		parts.append((node as Label).text)
	if node is Button:
		parts.append((node as Button).text)
	for child in node.get_children():
		parts.append(_collect_visible_text(child))
	return " ".join(parts)


func _visible_text_for_card(main, card_id: String) -> String:
	var card: Node = main.find_child(card_id, true, false)
	return _collect_visible_text(card) if card != null else ""


func _check_playable_ui_operations() -> void:
	var save_path := "user://headless_runner_playable_ui.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "playable UI save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("2026-06-04")
	root.add_child(main)
	main.call("_ready")

	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "visible backpack button should open backpack")
	var backpack_bubble := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack_bubble != null and backpack_bubble.visible, "visible backpack button should show backpack bubble")
	_press_visible_button(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "visible backpack bubble should open album")
	var album_overlay := main.find_child("MemoryAlbumOverlay", true, false) as Control
	var album_title := main.find_child("AlbumTitle", true, false) as Label
	_expect(album_overlay != null and album_overlay.visible, "visible album button should open album overlay")
	_expect(album_title != null and str(album_title.text) == "小镇相册", "album overlay should expose child-facing title")
	_press_visible_button(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "visible album return button should close album")
	_expect(album_overlay != null and not album_overlay.visible, "album return button should close overlay")

	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "visible top settings button should open settings")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "settings panel should open from visible top entry")
	var visible_footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(visible_footer_actions != null and visible_footer_actions.get_child_count() == 4, "settings should not add quit or settings into the bottom footer")
	var settings_status := main.find_child("SettingsStatus", true, false) as Label
	_expect(settings_status != null and str(settings_status.text).contains("安全位置"), "settings panel should use child-facing safety copy")
	var confirm_exit_button := main.find_child("ConfirmExitButton", true, false) as Button
	_expect(confirm_exit_button != null and not confirm_exit_button.visible, "exit confirm button should stay hidden before rest confirmation")
	_press_visible_button(main.find_child("RequestRestButton", true, false) as Button, "visible rest button should request a confirmation step")
	_expect(confirm_exit_button != null and confirm_exit_button.visible, "exit confirm button should appear after rest request")
	_press_visible_button(main.find_child("CancelRestButton", true, false) as Button, "visible continue button should cancel rest confirmation")
	_expect(confirm_exit_button != null and not confirm_exit_button.visible, "continue button should hide exit confirmation")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "playable UI should move away before safe-place action")
	_press_visible_button(main.find_child("SafePlaceButton", true, false) as Button, "visible safe-place button should return to a safe town cell")
	_expect(main.player_cell == Vector2i(31, 19), "safe-place button should move player back to the home plaza safe cell")
	_expect(settings_panel != null and not settings_panel.visible, "safe-place action should close settings panel")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(2, 3)).get("ok", false), "playable UI should move near an anchor")
	_press_visible_button(interact_button, "visible Interact should work near anchor")
	var apple_state: Dictionary = main.save_service.load_learning_record().get("card_states", {}).get("card_a_apple_core", {})
	_expect(bool(apple_state.get("collected", false)), "visible Interact should update album card state")
	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "playable UI should move near a resource")
	_press_visible_button(interact_button, "visible Interact should work near resource")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 1, "visible Interact should collect resource")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "playable UI should move to shop hotspot")
	_press_visible_button(interact_button, "visible Interact should open shop panel")
	var shop_panel_local := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel_local != null and shop_panel_local.visible, "shop panel should open from visible Interact")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 30
	_expect(main.save_service.save_game_state(game_state), "playable UI should save local coins for purchase path")
	main.call("_update_loop_status", "金币准备好")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "visible shop item button should buy furniture")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "visible shop purchase should add furniture")

	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "visible Home button should open home room")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "visible Home button should show home room")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "visible home item button should place furniture")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 1, "visible home item button should place furniture")
	_press_visible_button(main.find_child("HomeRotateFirstFurnitureButton", true, false) as Button, "visible home rotate button should rotate furniture")
	_press_visible_button(main.find_child("HomePickupFirstFurnitureButton", true, false) as Button, "visible home pickup button should pick up furniture")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).is_empty(), "visible home pickup button should clear placed furniture")
	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "visible Town button should return to town")
	var town_stage_local := main.find_child("TownStage", true, false) as Control
	_expect(town_stage_local != null and town_stage_local.visible, "visible Town button should show town playfield")

	_expect(main.save_service.clear_for_test(), "playable UI save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v028_daily_life_slice() -> void:
	var save_path := "user://headless_runner_v028_daily_slice.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.8 daily slice save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("2026-06-05")
	root.add_child(main)
	main.call("_ready")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.8 slice should move near Mina")
	_press_visible_button(interact_button, "V02.8 slice should greet Mina from visible Interact")
	_press_visible_button(interact_button, "V02.8 slice should start Mina branch request from visible Interact")
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.8 slice should show Mina branch request")

	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.8 slice should move to branch resource")
	_press_visible_button(interact_button, "V02.8 slice should collect branch from visible Interact")
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.8 slice should return to Mina")
	_press_visible_button(interact_button, "V02.8 slice should complete Mina request from visible Interact")
	var after_mina: Dictionary = main.save_service.load_game_state()
	_expect(int(after_mina.get("coins", 0)) == 6, "V02.8 slice should earn local coins from Mina")
	_expect(bool(after_mina.get("daily_requests", {}).get("2026-06-05", {}).get("daily_mina_branch_001", {}).get("completed_today", false)), "V02.8 slice should persist Mina completion")

	after_mina["coins"] = 12
	_expect(main.save_service.save_game_state(after_mina), "V02.8 slice should prepare enough earned local coins for shop")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.8 slice should move to shop hotspot")
	_press_visible_button(interact_button, "V02.8 slice should open shop from visible Interact")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.8 slice should buy chair from visible shop button")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "V02.8 slice should add bought chair to backpack")

	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.8 slice should open backpack from visible button")
	var backpack_items := main.find_child("BackpackItems", true, false) as Label
	_expect(backpack_items != null and str(backpack_items.text).contains("木椅 1"), "V02.8 slice should show bought chair in backpack")
	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.8 slice should close backpack before home")
	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.8 slice should enter home from visible button")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.8 slice should place chair from visible home button")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 1, "V02.8 slice should persist placed chair")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "V02.8 slice should show Sunny home feedback")

	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "V02.8 slice should return to town")
	for anchor_spec in [
		{"cell": Vector2i(31, 15), "card": "card_c_clock_core", "word": "Clock"},
		{"cell": Vector2i(51, 10), "card": "card_o_orange_core", "word": "Orange"},
		{"cell": Vector2i(7, 3), "card": "card_s_sun_core", "word": "Sun"},
	]:
		_expect(main.move_player_to_cell(anchor_spec.get("cell", Vector2i.ZERO)).get("ok", false), "V02.8 slice should move to anchor: %s" % anchor_spec.get("card", ""))
		_press_visible_button(interact_button, "V02.8 slice should revisit anchor from visible Interact: %s" % anchor_spec.get("card", ""))
		_expect(bool(main.memory_card_service.get_card_state(str(anchor_spec.get("card", ""))).get("collected", false)), "V02.8 slice should collect anchor album state: %s" % anchor_spec.get("card", ""))
		_expect(str(main.life_status_label.text).contains(str(anchor_spec.get("word", ""))), "V02.8 slice should show anchor story feedback: %s" % anchor_spec.get("word", ""))

	for forbidden in ["考试", "评分", "课程", "背诵", "倒计时", "失败惩罚", "Godot skeleton", "Loaded places"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.8 slice visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.8 daily slice save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v029_weekly_return_smoke() -> void:
	var save_path := "user://headless_runner_v029_weekly_return_smoke.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.9 weekly smoke save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var seen_events: Dictionary = {}
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")

		var status: Dictionary = main.today_status_service.get_today_status()
		_expect(status.get("ok", false), "V02.9 weekly smoke should resolve today status: %s" % day_key)
		_expect(str(status.get("day_key", "")) == day_key, "V02.9 weekly smoke should keep requested day key: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("event", ""))), "V02.9 weekly smoke HUD should refresh event text: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("today_status_text", ""))), "V02.11 weather smoke HUD should show weather event text: %s" % day_key)
		_expect(str(status.get("anchor_hint", "")).length() > 0, "V02.9 weekly smoke should keep A-Z anchor hint: %s" % day_key)
		seen_events[str(status.get("event", ""))] = true

		var rotation: Dictionary = main.life_shop_service.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "V02.9 weekly smoke should resolve shop rotation: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "V02.9 weekly smoke should keep wooden chair visible as P0: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "V02.9 weekly smoke should keep at least one P0 offer: %s" % day_key)

		_complete_visible_mina_weekly_path(main, day_key)

		if day_key == "local_day_004":
			_expect(str(status.get("primary_npc", "")) == "story_bear", "V02.9 story day should stay represented in status data")
			_expect(str(status.get("anchor_hint", "")).contains("B Bear"), "V02.9 story day should keep B Bear as a soft hint")
		elif day_key == "local_day_005":
			_expect(str(status.get("primary_npc", "")) == "bus_helper", "V02.9 bus day should stay represented in status data")
			_expect(str(status.get("anchor_hint", "")).contains("T Taxi"), "V02.9 bus day should keep T Taxi as a soft hint")

	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(12, int(state.get("coins", 0)))
	_expect(main.save_service.save_game_state(state), "V02.9 weekly smoke should prepare gentle coins for final shop/home check")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.9 weekly smoke should move to shop hotspot after 7 days")
	_press_visible_button(interact_button, "V02.9 weekly smoke should open shop shelf after 7 days")
	_expect((main.find_child("ShopPanel", true, false) as Control).visible, "V02.9 weekly smoke should show visible shop panel after 7 days")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.9 weekly smoke should buy P0 chair after 7 days")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.9 weekly smoke should add P0 chair to backpack")
	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.9 weekly smoke should open home room")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.9 weekly smoke should place bought chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.9 weekly smoke should persist home placement")

	for forbidden in ["Godot skeleton", "Loaded places", "课程", "测验", "考试", "评分", "背诵", "倒计时", "失败惩罚", "陌生人带走", "独自远行", "赶时间"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.9 weekly smoke visible UI should not contain forbidden text: %s" % forbidden)
	_expect(seen_events.size() == 7, "V02.9 weekly smoke should expose 7 distinct gentle day events")

	_expect(main.save_service.clear_for_test(), "V02.9 weekly smoke save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0210_p1_return_entries() -> void:
	var save_path := "user://headless_runner_v0210_p1_return_entries.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.10 P1 return save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	for entry in [
		{"id": "p1_entry_story_bear_bookshop_door", "cell": Vector2i(12, 6), "kind": "bookshop_door", "text": "书店门口", "npc": "story_bear", "anchor": "anchor_b_bear", "card": "card_b_bear_core"},
		{"id": "p1_entry_story_bear_corner", "cell": Vector2i(13, 7), "kind": "bear_corner", "text": "熊形书牌", "npc": "story_bear", "anchor": "anchor_b_bear", "card": "card_b_bear_core"},
		{"id": "p1_entry_bus_helper_stop_sign", "cell": Vector2i(32, 11), "kind": "bus_stop_sign", "text": "小车牌", "npc": "bus_helper", "anchor": "anchor_t_taxi", "card": "card_t_taxi_core"},
		{"id": "p1_entry_bus_helper_taxi_marker", "cell": Vector2i(31, 10), "kind": "taxi_marker", "text": "黄色小标记", "npc": "bus_helper", "anchor": "anchor_t_taxi", "card": "card_t_taxi_core"},
	]:
		_expect(main.find_child(str(entry.get("id", "")), true, false) != null, "V02.10 P1 entry hotspot should be visible: %s" % entry.get("id", ""))
		_expect(main.move_player_to_cell(entry.get("cell", Vector2i.ZERO)).get("ok", false), "V02.10 P1 return should move to visible hotspot: %s" % entry.get("id", ""))
		_press_visible_button(interact_button, "V02.10 P1 return should trigger through visible Interact: %s" % entry.get("id", ""))
		_expect(str(main.life_status_label.text).contains(str(entry.get("text", ""))), "V02.10 P1 return HUD should show gentle feedback: %s" % entry.get("id", ""))
		var state: Dictionary = main.save_service.load_game_state()
		var saved: Dictionary = state.get("p1_return_entries", {}).get(str(entry.get("id", "")), {})
		_expect(bool(saved.get("seen", false)), "V02.10 P1 return should persist seen state: %s" % entry.get("id", ""))
		_expect(str(saved.get("entry_kind", "")) == str(entry.get("kind", "")), "V02.10 P1 return should persist entry kind: %s" % entry.get("id", ""))
		_expect(str(saved.get("npc_id", "")) == str(entry.get("npc", "")), "V02.10 P1 return should bind resident: %s" % entry.get("id", ""))
		_expect(str(saved.get("linked_anchor_id", "")) == str(entry.get("anchor", "")), "V02.10 P1 return should preserve A-Z anchor link: %s" % entry.get("id", ""))
		var card_state: Dictionary = main.memory_card_service.get_card_state(str(entry.get("card", "")))
		_expect(bool(card_state.get("seen", false)), "V02.10 P1 return should mark linked card seen: %s" % entry.get("card", ""))
		_expect(bool(card_state.get("heard", false)), "V02.10 P1 return should mark linked card heard: %s" % entry.get("card", ""))
		_expect(bool(card_state.get("collected", false)), "V02.10 P1 return should mark linked card collected: %s" % entry.get("card", ""))

	_expect(main.open_memory_album().get("ok", false), "V02.10 P1 return album should open after linked card records")
	_expect(_visible_text_for_card(main, "card_b_bear_core").contains("已收藏"), "V02.10 P1 return album should show B Bear collected")
	_expect(_visible_text_for_card(main, "card_t_taxi_core").contains("已收藏"), "V02.10 P1 return album should show T Taxi collected")
	_expect(not _collect_visible_text(main).contains("正确率"), "V02.10 P1 return album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "V02.10 P1 return album should not show level wording")
	main.close_memory_album()

	_expect((main.find_child("ShopPanel", true, false) as Control) != null and not (main.find_child("ShopPanel", true, false) as Control).visible, "V02.10 P1 return should not open shop panel")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) == 0, "V02.10 P1 return should not award coins")
	for forbidden in ["阅读测验", "测验", "考试", "评分", "背诵", "倒计时", "赶时间", "陌生人带走", "独自远行", "上车", "错过班车"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.10 P1 return visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.10 P1 return save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0210_p1_return_smoke() -> void:
	_check_v0210_p1_return_entries()
	_check_v0210_p1_light_returns()


func _check_v0210_p1_light_returns() -> void:
	var save_path := "user://headless_runner_v0210_p1_light_returns.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.10 P1 light return save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "V02.10 P1 light return should move near Story Bear")
	_press_visible_button(interact_button, "V02.10 P1 light return should greet Story Bear")
	_press_visible_button(interact_button, "V02.10 P1 light return should start Story Bear request")
	_expect(str(main.life_status_label.text).contains("Bear Corner"), "V02.10 Story Bear request should mention Bear Corner")
	_expect(main.move_player_to_cell(Vector2i(13, 7)).get("ok", false), "V02.10 P1 light return should move to Bear Corner")
	_press_visible_button(interact_button, "V02.10 P1 light return should see Bear Corner")
	_expect(bool(main.memory_card_service.get_card_state("card_b_bear_core").get("collected", false)), "V02.10 Story Bear P1 path should collect B Bear album card")
	_expect(main.move_player_to_cell(Vector2i(12, 7)).get("ok", false), "V02.10 P1 light return should return to Story Bear")
	_press_visible_button(interact_button, "V02.10 P1 light return should complete Story Bear request")
	var story_state: Dictionary = main.save_service.load_game_state()
	_expect(bool(story_state.get("daily_requests", {}).get("local_day_004", {}).get("daily_story_bear_find_bear_corner_001", {}).get("completed_today", false)), "V02.10 Story Bear P1 request should persist completion")
	_expect(int(story_state.get("coins", 0)) == 5, "V02.10 Story Bear P1 request should award gentle coins once")

	main.set_day_key_for_test("local_day_005")
	main.call("_update_today_status")
	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "V02.10 P1 light return should move near Bus Helper")
	_press_visible_button(interact_button, "V02.10 P1 light return should greet Bus Helper")
	_press_visible_button(interact_button, "V02.10 P1 light return should start Bus Helper request")
	_expect(str(main.life_status_label.text).contains("taxi"), "V02.10 Bus Helper request should mention taxi marker")
	_expect(main.move_player_to_cell(Vector2i(31, 10)).get("ok", false), "V02.10 P1 light return should move to Taxi marker")
	_press_visible_button(interact_button, "V02.10 P1 light return should see Taxi marker")
	_expect(bool(main.memory_card_service.get_card_state("card_t_taxi_core").get("collected", false)), "V02.10 Bus Helper P1 path should collect T Taxi album card")
	_expect(main.move_player_to_cell(Vector2i(32, 12)).get("ok", false), "V02.10 P1 light return should return to Bus Helper")
	_press_visible_button(interact_button, "V02.10 P1 light return should complete Bus Helper request")
	var bus_state: Dictionary = main.save_service.load_game_state()
	_expect(bool(bus_state.get("daily_requests", {}).get("local_day_005", {}).get("daily_bus_helper_taxi_spot_001", {}).get("completed_today", false)), "V02.10 Bus Helper P1 request should persist completion")
	_expect(int(bus_state.get("coins", 0)) == 11, "V02.10 Bus Helper P1 request should add gentle coins once")
	_expect(main.open_memory_album().get("ok", false), "V02.10 P1 light return album should open after request paths")
	_expect(_visible_text_for_card(main, "card_b_bear_core").contains("已收藏"), "V02.10 P1 light return album should show B Bear collected")
	_expect(_visible_text_for_card(main, "card_t_taxi_core").contains("已收藏"), "V02.10 P1 light return album should show T Taxi collected")
	_expect(not _collect_visible_text(main).contains("正确率"), "V02.10 P1 light return album should not show accuracy wording")
	_expect(not _collect_visible_text(main).contains("等级"), "V02.10 P1 light return album should not show level wording")
	main.close_memory_album()

	for forbidden in ["阅读测验", "测验", "考试", "评分", "背诵", "倒计时", "赶时间", "陌生人带走", "独自远行", "上车", "错过班车"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.10 P1 light return visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.10 P1 light return save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0211_weather_slice_smoke() -> void:
	var save_path := "user://headless_runner_v0211_weather_slice_smoke.json"
	var service := SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.11 weather slice save should clear before scene startup")
	var main := MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var weather_paths: Array[Dictionary] = [
		{"day_key": "local_day_001", "event_id": "event_weather_sunny_soft_001", "anchor_id": "anchor_s_sun", "card_id": "card_s_sun_core", "cell": Vector2i(7, 3), "album_tag": "Sunny day."},
		{"day_key": "local_day_002", "event_id": "event_weather_breezy_kite_001", "anchor_id": "anchor_k_kite", "card_id": "card_k_kite_core", "cell": Vector2i(7, 11), "album_tag": "Windy Kite."},
		{"day_key": "local_day_004", "event_id": "event_weather_light_rain_001", "anchor_id": "anchor_b_bear", "card_id": "card_b_bear_core", "cell": Vector2i(13, 7), "album_tag": "Light Rain."},
		{"day_key": "local_day_006", "event_id": "event_weather_after_rain_001", "anchor_id": "anchor_u_umbrella", "card_id": "card_u_umbrella_core", "cell": Vector2i(33, 13), "album_tag": "After Rain."},
	]
	var seen_weather_events: Dictionary = {}
	var interact_button := main.find_child("InteractButton", true, false) as Button
	for path in weather_paths:
		var day_key := str(path.get("day_key", ""))
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")
		var status: Dictionary = main.today_status_service.get_today_status()
		var weather_event_id := str(status.get("weather_event_id", ""))
		_expect(status.get("ok", false), "V02.11 weather slice should resolve today status: %s" % day_key)
		_expect(weather_event_id == str(path.get("event_id", "")), "V02.11 weather slice should use expected event: %s" % day_key)
		_expect(str(main.life_status_label.text).contains(str(status.get("today_status_text", ""))), "V02.11 weather slice HUD should show weather text: %s" % day_key)
		seen_weather_events[weather_event_id] = true

		var rotation: Dictionary = main.life_shop_service.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "V02.11 weather slice should resolve shop rotation: %s" % day_key)
		_expect(str(rotation.get("weather_activity_corner", {}).get("weather_event_id", "")) == weather_event_id, "V02.11 weather slice shop corner should match weather: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "V02.11 weather slice should keep P0 chair: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "V02.11 weather slice should keep P0 offers: %s" % day_key)

		_complete_visible_mina_weekly_path(main, day_key)

		_expect(main.move_player_to_cell(path.get("cell", Vector2i.ZERO)).get("ok", false), "V02.11 weather slice should move to weather clue: %s" % path.get("anchor_id", ""))
		_press_visible_button(interact_button, "V02.11 weather slice should trigger weather clue: %s" % path.get("anchor_id", ""))
		_expect(str(main.life_status_label.text).contains("天气相册"), "V02.11 weather slice clue HUD should mention album: %s" % path.get("anchor_id", ""))
		var record_id := "%s:%s" % [weather_event_id, str(path.get("anchor_id", ""))]
		var record: Dictionary = main.save_service.load_game_state().get("weather_album_clues", {}).get(record_id, {})
		_expect(bool(record.get("seen", false)), "V02.11 weather slice should persist clue record: %s" % record_id)
		_expect(str(record.get("album_tag", "")) == str(path.get("album_tag", "")), "V02.11 weather slice should persist album tag: %s" % record_id)
		var card_state: Dictionary = main.memory_card_service.get_card_state(str(path.get("card_id", "")))
		_expect(bool(card_state.get("seen", false)) and bool(card_state.get("collected", false)), "V02.11 weather slice should collect weather card: %s" % path.get("card_id", ""))

	_expect(seen_weather_events.size() == 4, "V02.11 weather slice should cover four P0 weather events")
	_expect(main.open_memory_album().get("ok", false), "V02.11 weather slice should open album after weather clues")
	for path in weather_paths:
		_expect(_visible_text_for_card(main, str(path.get("card_id", ""))).contains("已收藏"), "V02.11 weather slice album should show collected card: %s" % path.get("card_id", ""))
	main.close_memory_album()

	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(12, int(state.get("coins", 0)))
	_expect(main.save_service.save_game_state(state), "V02.11 weather slice should prepare coins for shop/home")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.11 weather slice should move to shop")
	_press_visible_button(interact_button, "V02.11 weather slice should open shop")
	_expect((main.find_child("ShopPanel", true, false) as Control).visible, "V02.11 weather slice should show shop panel")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.11 weather slice should buy P0 chair")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.11 weather slice should add chair")
	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.11 weather slice should open home")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.11 weather slice should place chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.11 weather slice should persist home placement")
	for forbidden in ["Godot skeleton", "Loaded places", "课程", "测验", "考试", "评分", "背诵", "倒计时", "失败惩罚", "陌生人带走", "独自远行", "赶时间", "打卡", "补签", "连续登录", "错过"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.11 weather slice visible UI should not contain forbidden text: %s" % forbidden)

	_expect(main.save_service.clear_for_test(), "V02.11 weather slice save should clean up")
	root.remove_child(main)
	main.queue_free()


func _complete_visible_mina_weekly_path(main, day_key: String) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.9 weekly smoke should move near Mina: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should greet or advance Mina: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should start Mina request: %s" % day_key)
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.9 weekly smoke should show Mina branch request: %s" % day_key)
	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.9 weekly smoke should move to branch resource: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should collect branch: %s" % day_key)
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.9 weekly smoke should return to Mina: %s" % day_key)
	_press_visible_button(interact_button, "V02.9 weekly smoke should complete Mina request: %s" % day_key)
	var daily_state: Dictionary = main.save_service.load_game_state().get("daily_requests", {}).get(day_key, {}).get("daily_mina_branch_001", {})
	_expect(bool(daily_state.get("completed_today", false)), "V02.9 weekly smoke should persist Mina completion by day: %s" % day_key)


func _press_visible_button(button: Button, message: String) -> void:
	_expect(button != null and _control_path_visible(button) and not button.disabled, message)
	if button != null and _control_path_visible(button) and not button.disabled:
		button.emit_signal("pressed")


func _control_path_visible(node: Node) -> bool:
	var current := node
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _check_account_cloud_stubs() -> void:
	var account_save := SaveServiceScript.new("user://headless_runner_account_cloud.json")
	_expect(account_save.clear_for_test(), "account/cloud save should clear")
	_expect(account_save.reset_for_test(), "account/cloud save should reset")
	var account = AccountAdapterScript.new()
	var current: Dictionary = account.get_current_account(account_save)
	_expect(current.get("account_id", "") == "guest:local_profile", "AccountAdapter should expose local guest id")
	_expect(account_save.load_profile().get("profile_id", "") == "local_profile", "AccountAdapter should preserve SaveService profile id")

	var cloud = CloudSaveAdapterScript.new()
	var device_a := SaveServiceScript.new("user://headless_runner_cloud_a.json")
	var device_b := SaveServiceScript.new("user://headless_runner_cloud_b.json")
	_expect(device_a.clear_for_test(), "cloud device A should clear")
	_expect(device_b.clear_for_test(), "cloud device B should clear")
	_expect(device_a.reset_for_test(), "cloud device A should reset")
	_expect(device_b.reset_for_test(), "cloud device B should reset")
	var state_a: Dictionary = device_a.load_game_state()
	state_a["coins"] = 4
	_expect(device_a.save_game_state(state_a), "cloud device A should save setup")
	_expect(cloud.capture_from_save_service(CloudSaveAdapterScript.DEVICE_A, device_a).get("ok", false), "CloudSaveAdapter should capture device A")
	var sync_a: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_A)
	_expect(sync_a.get("ok", false), "CloudSaveAdapter should sync device A")
	_expect(not bool(sync_a.get("network_used", true)), "CloudSaveAdapter should not use network in runner")
	_expect(not bool(sync_a.get("data_uploaded", true)), "CloudSaveAdapter should not upload data in runner")
	_expect(cloud.sync_device(CloudSaveAdapterScript.DEVICE_B).get("ok", false), "CloudSaveAdapter should sync device B")
	_expect(cloud.restore_to_save_service(CloudSaveAdapterScript.DEVICE_B, device_b).get("ok", false), "CloudSaveAdapter should restore device B")
	_expect(int(device_b.load_game_state().get("coins", -1)) == 4, "CloudSaveAdapter should copy coins to second device")
	_expect(account_save.clear_for_test(), "account/cloud save should clean up")
	_expect(device_a.clear_for_test(), "cloud device A should clean up")
	_expect(device_b.clear_for_test(), "cloud device B should clean up")


func _check_content_theme_review_stubs() -> void:
	var loader = ContentPackLoaderScript.new()
	var pack := {
		"pack_id": "pack_headless_runner_words_001",
		"new_words": [
			{
				"word_id": "word_ant",
				"word": "ant",
				"letter": "A",
				"core_anchor_id": "anchor_a_apple",
				"world_place_id": "place_home",
				"story_memory": "An ant carries a tiny apple crumb beside the Home welcome box.",
				"visual_hook": "tiny ant trail under the red apple sign",
				"review_path": "Home welcome box -> Town Start flower path -> Home welcome box"
			}
		],
	}
	_expect(loader.install_pack(pack).get("ok", false), "ContentPackLoader should install legal local pack")
	_expect(loader.rollback_pack("pack_headless_runner_words_001").get("ok", false), "ContentPackLoader should rollback local pack")
	var illegal := pack.duplicate(true)
	illegal["anchors"] = [{"anchor_id": "anchor_a_apple"}]
	_expect(not loader.validate_pack(illegal).get("ok", true), "ContentPackLoader should reject A-Z core anchor override")

	var theme = ThemeSwitchServiceScript.new()
	var switched: Dictionary = theme.switch_theme("theme_rainbow_garden_placeholder", [{"category": "tile_atlas", "asset_id": "world"}])
	_expect(switched.get("ok", false), "ThemeSwitchService should resolve second placeholder theme")

	var review = ContentReviewPipelineScript.new()
	_expect(review.submit_candidate({"candidate_id": "candidate_headless_pack", "payload": pack}).get("ok", false), "ContentReviewPipeline should store candidate")
	_expect(not review.publish_for_runtime("candidate_headless_pack").get("ok", true), "ContentReviewPipeline should block unapproved content")
	_expect(review.set_manual_status("candidate_headless_pack", "approved").get("ok", false), "ContentReviewPipeline should accept manual approval")
	_expect(review.publish_for_runtime("candidate_headless_pack").get("ok", false), "ContentReviewPipeline should publish approved content")


func _check_content_contracts() -> void:
	var validator = ContentContractValidatorScript.new()
	var result: Dictionary = validator.validate_all()
	_expect(result.get("ok", false), "ContentContractValidator should pass all content data: %s" % [result.get("errors", [])])
	var blocked: Dictionary = validator.validate_candidate_content_pack({
		"anchors": [{"anchor_id": "anchor_a_apple"}],
		"new_word_stories": [],
	})
	_expect(not blocked.get("ok", true), "ContentContractValidator should block core A-Z anchor overrides")


func _check_v0212_az_world_plan() -> void:
	var loaded: Dictionary = AZWorldPlanContractScript.load_plan()
	_expect(loaded.get("ok", false), "V02.12 A-Z world plan should pass contract: %s" % [loaded.get("errors", [])])
	var data: Dictionary = loaded.get("data", {})
	_expect(str(data.get("center_policy", "")) == "home_school_dual_core", "V02.12 world plan should keep Home / School center")
	var anchors: Array = data.get("anchors", [])
	_expect(anchors.size() == 26, "V02.12 world plan should distribute all 26 anchors")
	var by_letter: Dictionary = {}
	for anchor in anchors:
		if anchor is Dictionary:
			by_letter[str((anchor as Dictionary).get("letter", ""))] = anchor
	for letter in ["A", "C", "D", "W"]:
		_expect(str(by_letter.get(letter, {}).get("home_school_relation", "")) == "home_line", "V02.12 home line should include: %s" % letter)
		_expect(str(by_letter.get(letter, {}).get("map_ring", "")) == "center", "V02.12 home line should stay in center: %s" % letter)
	for letter in ["E", "G", "K", "N", "R", "Y"]:
		_expect(str(by_letter.get(letter, {}).get("home_school_relation", "")) == "school_line", "V02.12 school line should include: %s" % letter)
		_expect(str(by_letter.get(letter, {}).get("map_ring", "")) == "center", "V02.12 school line should stay in center: %s" % letter)
	_expect(str(by_letter.get("X", {}).get("map_ring", "")) == "far_edge", "V02.12 X should remain far-edge reserve")
	_expect(str(by_letter.get("Z", {}).get("map_ring", "")) == "far_edge", "V02.12 Z should remain far-edge reserve")


func _check_v0213_textbook_world_plan() -> void:
	var loaded: Dictionary = TextbookWorldContractScript.load_plan()
	_expect(loaded.get("ok", false), "V02.13 textbook world plan should pass contract: %s" % [loaded.get("errors", [])])
	var data: Dictionary = loaded.get("data", {})
	_expect(data.get("textbook_sources", []).size() == 8, "V02.13 should cover 8 textbook sources")
	_expect(data.get("curriculum_items", []).size() == 85, "V02.13 should summarize all 85 unit slots")
	var p0_count := 0
	for mapping in data.get("world_mappings", []):
		if mapping is Dictionary and str((mapping as Dictionary).get("tier", "")) == "P0":
			p0_count += 1
			_expect(not ["anchor_x_x_mark_box", "anchor_z_zebra"].has(str((mapping as Dictionary).get("anchor_id", ""))), "V02.13 P0 mapping should not use far-edge anchors")
	_expect(p0_count >= 12, "V02.13 should include P0 Home / School mappings")


func _check_v0214_homeschool_slice() -> void:
	var save_path := "user://headless_runner_v0214_homeschool_slice.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.14 homeschool runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var path: Array[Dictionary] = [
		{"event_id": "homeschool_home_morning_bag_001", "cell": Vector2i(4, 7), "text": "Good morning", "cards": ["card_a_apple_core", "card_c_clock_core", "card_w_watch_core"]},
		{"event_id": "homeschool_home_sunny_good_morning_001", "cell": Vector2i(6, 8), "text": "Sunny", "cards": ["card_d_dog_core"]},
		{"event_id": "homeschool_walk_gate_sign_001", "cell": Vector2i(8, 11), "text": "school gate", "cards": ["card_g_gate_core"]},
		{"event_id": "homeschool_walk_kite_sky_001", "cell": Vector2i(9, 12), "text": "Kite", "cards": ["card_k_kite_core", "card_s_sun_core"]},
		{"event_id": "homeschool_school_gate_hello_001", "cell": Vector2i(11, 13), "text": "Hello", "cards": ["card_e_elephant_core", "card_g_gate_core"]},
		{"event_id": "homeschool_school_yard_play_001", "cell": Vector2i(11, 15), "text": "Robot", "cards": ["card_n_net_core", "card_r_robot_core", "card_y_yo_yo_core"]},
		{"event_id": "homeschool_return_sunny_story_001", "cell": Vector2i(5, 8), "text": "回到小屋", "cards": ["card_a_apple_core", "card_d_dog_core", "card_o_orange_core"]},
	]
	for step in path:
		var event_id := str(step.get("event_id", ""))
		_expect(main.find_child(event_id, true, false) != null, "V02.14 homeschool hotspot should exist: %s" % event_id)
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.14 homeschool player should reach: %s" % event_id)
		_press_visible_button(interact_button, "V02.14 homeschool visible Interact should trigger: %s" % event_id)
		_expect(str(main.life_status_label.text).contains(str(step.get("text", ""))), "V02.14 homeschool feedback should be visible: %s" % event_id)
		var record: Dictionary = main.save_service.load_game_state().get("homeschool_events", {}).get(event_id, {})
		_expect(bool(record.get("seen", false)), "V02.14 homeschool event should persist: %s" % event_id)
		for card_id in step.get("cards", []):
			var card_state: Dictionary = main.memory_card_service.get_card_state(str(card_id))
			_expect(bool(card_state.get("collected", false)), "V02.14 homeschool card should be collected: %s" % card_id)
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.14 should keep shop path walkable")
	_press_visible_button(interact_button, "V02.14 visible Interact should still open shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.14 should keep shop panel available")
	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "V02.14 should keep home path walkable")
	_press_visible_button(interact_button, "V02.14 visible Interact should still open home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.14 should keep home room available")
	_expect(not _collect_visible_text(main).contains("测试"), "V02.14 visible UI should not expose test wording")
	_expect(not _collect_visible_text(main).contains("分数"), "V02.14 visible UI should not expose score wording")
	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()


func _check_v0215_school_daily_slice() -> void:
	var save_path := "user://headless_runner_v0215_school_daily_slice.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.15 school daily runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var path: Array[Dictionary] = [
		{"event_id": "homeschool_walk_gate_sign_001", "cell": Vector2i(8, 11), "stage": "home_school_walk"},
		{"event_id": "homeschool_school_gate_hello_001", "cell": Vector2i(11, 13), "stage": "school_gate"},
		{"event_id": "homeschool_school_yard_play_001", "cell": Vector2i(11, 15), "stage": "school_yard"},
		{"event_id": "homeschool_return_sunny_story_001", "cell": Vector2i(5, 8), "stage": "return_home"},
	]
	var seen_school_day_events: Dictionary = {}
	var seen_return_events: Dictionary = {}
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		main.set_day_key_for_test(day_key)
		main.call("_update_today_status")
		var school_state: Dictionary = main.school_day_state_service.get_today_school_state()
		_expect(school_state.get("ok", false), "V02.15 school daily should resolve school state: %s" % day_key)
		_expect(str(school_state.get("day_key", "")) == day_key, "V02.15 school daily should keep requested day key: %s" % day_key)
		for step in path:
			var stage := str(step.get("stage", ""))
			var event_id := str(step.get("event_id", ""))
			var entry: Dictionary = main.school_day_state_service.get_entry(stage)
			_expect(str(entry.get("day_key", "")) == day_key, "V02.15 school daily entry should inherit day key: %s %s" % [day_key, stage])
			_expect(str(entry.get("stage", "")) == stage, "V02.15 school daily entry should keep stage: %s %s" % [day_key, stage])
			_expect(main.find_child(event_id, true, false) != null, "V02.15 school daily hotspot should exist: %s" % event_id)
			_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.15 school daily player should reach: %s %s" % [day_key, stage])
			_press_visible_button(interact_button, "V02.15 school daily visible Interact should trigger: %s %s" % [day_key, stage])
			_expect(str(main.life_status_label.text).contains(str(entry.get("child_facing_text", ""))), "V02.15 school daily feedback should show day-specific text: %s %s" % [day_key, stage])
			var record: Dictionary = main.save_service.load_game_state().get("school_day_events", {}).get(str(entry.get("event_id", "")), {})
			_expect(bool(record.get("seen", false)), "V02.15 school daily event should persist: %s" % entry.get("event_id", ""))
			_expect(str(record.get("day_key", "")) == day_key, "V02.15 school daily persisted event should keep day: %s" % entry.get("event_id", ""))
			_expect(str(record.get("stage", "")) == stage, "V02.15 school daily persisted event should keep stage: %s" % entry.get("event_id", ""))
			_expect(not (record.get("anchor_ids", []) as Array).is_empty(), "V02.15 school daily persisted event should keep anchors: %s" % entry.get("event_id", ""))
			_expect(not (record.get("environment_words", []) as Array).is_empty(), "V02.15 school daily persisted event should keep environment words: %s" % entry.get("event_id", ""))
			seen_school_day_events[str(entry.get("event_id", ""))] = true
			if stage == "return_home":
				seen_return_events[str(entry.get("event_id", ""))] = true
				_expect(str(entry.get("display_prefix", "")).contains("Sunny"), "V02.15 return entry should stay tied to Sunny: %s" % day_key)
	_expect(seen_school_day_events.size() == 28, "V02.15 school daily should persist 7 days x 4 school events")
	_expect(seen_return_events.size() == 7, "V02.15 school daily should persist seven Sunny return events")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.15 school daily should keep shop path walkable")
	_press_visible_button(interact_button, "V02.15 school daily visible Interact should still open shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.15 school daily should keep shop panel available")
	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "V02.15 school daily should keep home path walkable")
	_press_visible_button(interact_button, "V02.15 school daily visible Interact should still open Home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.15 school daily should keep Home room available")
	for forbidden in ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "倒计时", "迟到", "作业", "老师评价", "家长报告", "独自远行", "上车", "必须", "打卡"]:
		_expect(not _collect_visible_text(main).contains(forbidden), "V02.15 school daily visible UI should not contain forbidden text: %s" % forbidden)
	_expect(main.save_service.clear_for_test(), "V02.15 school daily runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0216_playable_rc_gate() -> void:
	var save_path := "user://headless_runner_v0216_playable_rc_gate.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.16 playable RC save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_006")
	root.add_child(main)
	main.call("_ready")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 20
	game_state["inventory"] = {"food_pet_snack": 1}
	_expect(main.save_service.save_game_state(game_state), "V02.16 playable RC should seed local state")
	main.call("_update_loop_status", "小镇准备好")
	main.call("_update_today_status")

	var footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(footer_actions != null and footer_actions.get_child_count() == 4, "V02.16 playable RC should keep four footer actions")
	var footer_hint := main.find_child("TownFooterText", true, false) as Label
	_expect(footer_hint != null and str(footer_hint.text).contains("看看"), "V02.16 playable RC should explain visible look action")
	_check_v0216_visible_text(main, "startup")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.16 playable RC should move near Mina")
	_press_visible_button(interact_button, "V02.16 playable RC should greet Mina")
	_press_visible_button(interact_button, "V02.16 playable RC should start Mina request")
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.16 playable RC Mina request should stay life-like")
	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.16 playable RC should move to branch")
	_press_visible_button(interact_button, "V02.16 playable RC should collect branch")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 1, "V02.16 playable RC should collect resource")
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.16 playable RC should return to Mina")
	_press_visible_button(interact_button, "V02.16 playable RC should complete Mina request")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) >= 6, "V02.16 playable RC should keep gentle coins")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.16 playable RC should reach Shop")
	_press_visible_button(interact_button, "V02.16 playable RC should open Shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.16 playable RC should show Shop")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.16 playable RC should buy chair")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.16 playable RC should add chair")
	_press_visible_button(main.find_child("CloseShopButton", true, false) as Button, "V02.16 playable RC should close Shop")
	_expect(shop_panel != null and not shop_panel.visible, "V02.16 playable RC Shop should close")

	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.16 playable RC should open Home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.16 playable RC should show Home")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.16 playable RC should place chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.16 playable RC should persist Home placement")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "V02.16 playable RC should show Sunny feedback")
	_press_visible_button(main.find_child("HomeRotateFirstFurnitureButton", true, false) as Button, "V02.16 playable RC should rotate furniture")
	_press_visible_button(main.find_child("HomeMoveFirstFurnitureButton", true, false) as Button, "V02.16 playable RC should move furniture")
	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "V02.16 playable RC should return to Town")

	for step in [
		{"cell": Vector2i(8, 11), "stage": "home_school_walk"},
		{"cell": Vector2i(11, 13), "stage": "school_gate"},
		{"cell": Vector2i(11, 15), "stage": "school_yard"},
		{"cell": Vector2i(5, 8), "stage": "return_home"},
	]:
		var stage := str(step.get("stage", ""))
		var entry: Dictionary = main.school_day_state_service.get_entry(stage)
		_expect(not entry.is_empty(), "V02.16 playable RC should resolve school entry: %s" % stage)
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.16 playable RC should reach school step: %s" % stage)
		_press_visible_button(interact_button, "V02.16 playable RC should trigger school step: %s" % stage)
		_expect(str(main.life_status_label.text).contains(str(entry.get("child_facing_text", ""))), "V02.16 playable RC should show school text: %s" % stage)
	_expect(main.save_service.load_game_state().get("school_day_events", {}).size() >= 4, "V02.16 playable RC should persist school day events")

	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.16 playable RC should open Backpack")
	_press_visible_button(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.16 playable RC should open Album")
	var album_overlay := main.find_child("MemoryAlbumOverlay", true, false) as Control
	_expect(album_overlay != null and album_overlay.visible, "V02.16 playable RC should show Album")
	_check_v0216_visible_text(main, "album")
	_press_visible_button(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.16 playable RC should close Album")
	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "V02.16 playable RC should open Settings")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "V02.16 playable RC should show Settings")
	_check_v0216_visible_text(main, "settings")
	_press_visible_button(main.find_child("RequestRestButton", true, false) as Button, "V02.16 playable RC should reveal rest confirmation")
	var confirm_exit_button := main.find_child("ConfirmExitButton", true, false) as Button
	_expect(confirm_exit_button != null and confirm_exit_button.visible, "V02.16 playable RC should show exit confirmation only after rest request")
	_press_visible_button(main.find_child("CancelRestButton", true, false) as Button, "V02.16 playable RC should cancel rest confirmation")
	_expect(confirm_exit_button != null and not confirm_exit_button.visible, "V02.16 playable RC should hide exit confirmation")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.16 playable RC should move before safe-place")
	_press_visible_button(main.find_child("SafePlaceButton", true, false) as Button, "V02.16 playable RC should use safe-place")
	_expect(main.player_cell == Vector2i(31, 19), "V02.16 playable RC should return to safe cell")
	_expect(settings_panel != null and not settings_panel.visible, "V02.16 playable RC safe-place should close Settings")
	_check_v0216_visible_text(main, "final")

	_expect(main.save_service.clear_for_test(), "V02.16 playable RC save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0216_visible_text(main, context: String) -> void:
	var text := _collect_visible_child_text(main)
	for forbidden in ["Godot skeleton", "Loaded places", "from JSON", "课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "家长报告", "必须完成", "错过损失", "迟到", "作业", "打卡", "倒计时", "赶时间", "陌生人带走", "独自远行"]:
		_expect(not text.contains(forbidden), "V02.16 playable RC visible UI should not contain forbidden text (%s): %s" % [context, forbidden])


func _check_v0218_map_readability() -> void:
	_expect(V0218MapReadabilityTestScript != null, "V02.18 map readability focused test should compile for headless runner")
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.18 map readability should load world map")
	var world_map: Dictionary = result.get("data", {})
	var save_path := "user://headless_runner_v0218_map_readability.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.18 map readability save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	root.add_child(main)
	main.call("_ready")
	_expect(main.find_child("MapReadabilityLayer", true, false) is Node2D, "V02.18 map readability should expose guide layer")
	var artpass004_zone_names: Array[String] = ["MapReadZoneSun", "MapReadZoneSchoolGate", "MapReadZoneSchoolYard", "MapReadZoneWalk", "MapReadZoneStory", "MapReadZoneHome", "MapReadZoneShop", "MapReadZoneAnimal", "MapReadZoneCoast"]
	for node_name in artpass004_zone_names + ["MapReadSignSun", "MapReadSignSchool", "MapReadSignStory", "MapReadSignHome", "MapReadSignShop", "MapReadSignAnimal", "MapReadSignCoast"]:
		_expect(main.find_child(node_name, true, false) != null, "V02.18 map readability should expose guide node: %s" % node_name)
	for node_name in artpass004_zone_names:
		var zone := main.find_child(node_name, true, false) as Sprite2D
		_expect(zone != null and zone.texture != null and zone.texture.get_width() >= 512, "ARTPASS-004 map zone should use production place asset in headless runner: %s" % node_name)
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_visual_recovery_snapshot"), "V02.38 runner should expose modular visual recovery snapshot")
	if stage != null and stage.has_method("get_visual_recovery_snapshot"):
		var visual_snapshot: Dictionary = stage.call("get_visual_recovery_snapshot")
		_expect(not bool(visual_snapshot.get("uses_full_map_background", true)), "V02.38 runner should not use world_map_base_1280 as final main background")
		_expect(int(visual_snapshot.get("terrain_tile_count", 0)) >= 100, "V02.38 runner ground should be modular terrain tiles")
		_expect(int(visual_snapshot.get("region_chunk_count", 0)) >= 4, "V02.38 runner should expose modular region chunks")
	var groups := {}
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(interact_button != null and _control_path_visible(interact_button), "V02.18 map readability should keep visible Interact button")
	for anchor_value in world_map.get("memory_anchors", []):
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var anchor_id := str(anchor.get("anchor_id", ""))
		var letter := str(anchor.get("letter", ""))
		var card_id := str(anchor.get("card_id", ""))
		var core_word := str(anchor.get("core_word", ""))
		var group := _v0218_screenshot_group_for_letter(letter)
		groups[group] = true
		var node := main.find_child(anchor_id, true, false) as Node2D
		_expect(node != null, "V02.18 map readability should create anchor node: %s" % anchor_id)
		if node == null:
			continue
		_expect(str(node.get_meta("mapread_layer", "")) == _v0218_layer_for_letter(letter), "V02.18 map readability should expose layer meta: %s" % anchor_id)
		_expect(str(node.get_meta("mapread_screenshot_group", "")) == group, "V02.18 map readability should expose screenshot group: %s" % anchor_id)
		var sprite := node.find_child("ObjectSprite", true, false) as Sprite2D
		_expect(sprite != null and sprite.texture != null and sprite.scale.x > 0.0 and sprite.scale.y > 0.0, "V02.18 map readability should keep object sprite readable: %s" % anchor_id)
		var badge := node.find_child("LetterBadge", true, false) as Label
		_expect(badge != null and badge.text == letter and badge.size.x >= 22.0 and badge.size.y >= 22.0 and badge.size.x <= 24.0 and badge.size.y <= 24.0, "V02.20 map readability should keep a quiet readable badge: %s" % anchor_id)
		var look_cell := _v0218_best_look_cell(main, _dict_to_cell(anchor.get("position", {})), anchor_id)
		_expect(main.move_player_to_cell(look_cell).get("ok", false), "V02.18 map readability should reach anchor: %s" % anchor_id)
		_press_visible_button(interact_button, "V02.18 map readability should trigger anchor through visible Interact: %s" % anchor_id)
		_expect(str(main.life_status_label.text).contains(core_word), "V02.18 map readability feedback should name object: %s" % anchor_id)
		_expect(bool(main.memory_card_service.get_card_state(card_id).get("collected", false)), "V02.18 map readability should collect album card: %s" % anchor_id)
	_v0218_check_school_badge_spacing(world_map.get("memory_anchors", []))
	_expect(groups.has("home_anchors") and groups.has("school_line") and groups.has("first_ring") and groups.has("second_ring") and groups.has("far_edge"), "V02.18 map readability should cover all screenshot groups")
	_expect(main.open_memory_album().get("ok", false), "V02.18 map readability should open album after exploration")
	for forbidden in ["课程", "单元", "测试", "测验", "考试", "背诵", "词表", "分数", "正确率", "等级", "打卡", "完成率", "倒计时", "迟到", "必须", "错过", "独自远行", "赶车"]:
		_expect(not _collect_visible_child_text(main).contains(forbidden), "V02.18 map readability visible text should avoid pressure wording: %s" % forbidden)
	main.close_memory_album()
	_expect(main.save_service.clear_for_test(), "V02.18 map readability save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0220_playgate_controls() -> void:
	_expect(V0220PlaygateControlsTestScript != null, "V02.20 playgate controls focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0220_playgate_controls.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.20 playgate controls save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var start_cell: Vector2i = main.player_cell
	var target_cell := start_cell + Vector2i(1, 0)
	var start_position: Vector2 = main.player_marker.position
	var request: Dictionary = main.request_player_walk_to_cell(target_cell)
	_expect(request.get("ok", false) and bool(request.get("walking", false)), "V02.20 playgate should request embodied walking")
	_expect(main.player_cell == start_cell, "V02.20 playgate walking should not teleport logical cell immediately")
	main.call("_advance_player_walk", 1.0 / 60.0)
	_expect(main.player_marker.position != start_position, "V02.20 playgate marker should move over time")
	_expect(main.player_cell == start_cell, "V02.20 playgate should keep logical cell before arrival")
	var finish: Dictionary = main.finish_player_walk_for_test()
	_expect(finish.get("ok", false) and main.player_cell == target_cell, "V02.20 playgate should arrive through frame advancement")

	_expect(main.runtime_map_node != null and main.runtime_map_node.scale.x > 1.0 and main.runtime_map_node.scale.y > 1.0, "V02.20 playgate should use local neighborhood camera scale")
	var before_camera: Vector2 = main.runtime_map_node.position
	_expect(main.request_player_walk_to_cell(main.player_cell + Vector2i(4, 0)).get("ok", false), "V02.20 playgate should start a camera follow walk")
	main.finish_player_walk_for_test()
	_expect(main.runtime_map_node.position != before_camera, "V02.20 playgate camera should follow the player")

	_expect(main.request_player_walk_to_cell(Vector2i(38, 22)).get("ok", false), "V02.20 playgate prompt should walk near Mina")
	main.finish_player_walk_for_test()
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("display_name", "")).contains("米娜"), "V02.20 playgate prompt should resolve visible NPC target")
	var prompt := main.find_child("InteractionPrompt", true, false) as Label
	_expect(prompt != null and prompt.visible and str(prompt.text).contains("米娜"), "V02.20 playgate prompt label should name the current target")

	_expect(main.save_service.clear_for_test(), "V02.20 playgate controls save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0221_livegate_hotspot_priority() -> void:
	_expect(V0221LivegateHotspotPriorityTestScript != null, "V02.21 livegate hotspot priority focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0221_livegate_hotspot_priority.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.21 livegate hotspot priority save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.21 livegate should reach Mina priority cell")
	var mina_target: Dictionary = main.get_current_interaction_target()
	_expect(str(mina_target.get("type", "")) == "npc" and str(mina_target.get("target_id", "")) == "mina", "V02.21 livegate should prompt Mina over nearby anchor")
	var mina_result: Dictionary = main.interact_nearby()
	_expect(str(mina_result.get("interaction_type", "")) == "npc" and str(mina_result.get("npc_id", "")) == "mina", "V02.21 livegate should interact with Mina over nearby anchor")

	_expect(main.move_player_to_cell(Vector2i(34, 20)).get("ok", false), "V02.21 livegate should reach exact Taxi anchor cell")
	var anchor_target: Dictionary = main.get_current_interaction_target()
	_expect(str(anchor_target.get("type", "")) == "anchor" and str(anchor_target.get("target_id", "")) == "anchor_t_taxi", "V02.21 livegate exact Taxi cell should stay an anchor prompt")
	var anchor_result: Dictionary = main.interact_nearby()
	_expect(str(anchor_result.get("interaction_type", "")) == "anchor" and str(anchor_result.get("anchor_id", "")) == "anchor_t_taxi", "V02.21 livegate exact Taxi cell should collect anchor")

	_expect(main.move_player_to_cell(Vector2i(36, 21)).get("ok", false), "V02.21 livegate should reach Bus Helper priority cell")
	var bus_target: Dictionary = main.get_current_interaction_target()
	_expect(str(bus_target.get("type", "")) == "npc" and str(bus_target.get("target_id", "")) == "bus_helper", "V02.21 livegate should prompt Bus Helper over nearby resource")
	var bus_result: Dictionary = main.interact_nearby()
	_expect(str(bus_result.get("interaction_type", "")) == "npc" and str(bus_result.get("npc_id", "")) == "bus_helper", "V02.21 livegate should interact with Bus Helper over nearby resource")

	_expect(main.move_player_to_cell(Vector2i(35, 22)).get("ok", false), "V02.21 livegate should reach exact stone resource cell")
	var resource_target: Dictionary = main.get_current_interaction_target()
	_expect(str(resource_target.get("type", "")) == "resource", "V02.21 livegate exact resource should remain a resource prompt")
	var resource_result: Dictionary = main.interact_nearby()
	_expect(str(resource_result.get("interaction_type", "")) == "resource" and str(resource_result.get("item_id", "")) == "stone", "V02.21 livegate exact resource should collect stone")

	_expect(main.move_player_to_cell(Vector2i(31, 19)).get("ok", false), "V02.21 livegate should reach exact Home entry cell")
	var place_target: Dictionary = main.get_current_interaction_target()
	_expect(str(place_target.get("type", "")) == "place" and str(place_target.get("target_id", "")) == "interaction_home_entry", "V02.21 livegate exact Home entry should stay stable")
	var place_result: Dictionary = main.interact_nearby()
	_expect(str(place_result.get("interaction_type", "")) == "place_entry" and str(place_result.get("place_id", "")) == "place_home", "V02.21 livegate exact Home entry should open Home")

	_expect(main.save_service.clear_for_test(), "V02.21 livegate hotspot priority save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0221_livegate_shop_school_arrival() -> void:
	_expect(V0221LivegateShopSchoolArrivalTestScript != null, "V02.21 livegate Shop/School arrival focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0221_livegate_shop_school_arrival.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.21 Shop/School arrival save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	for node_name in ["ArrivalProofPanel", "ArrivalProofShop", "ArrivalProofSchoolGate", "ArrivalProofSchoolYard"]:
		_expect(main.find_child(node_name, true, false) != null, "V02.21 arrival proof node should exist: %s" % node_name)

	_expect(main.move_player_to_cell(Vector2i(41, 11)).get("ok", false), "V02.21 runner should reach Shop arrival cell")
	_expect(_arrival_proof_visible(main, "ArrivalProofShop"), "V02.21 runner should show Shop arrival proof")
	var shop_result: Dictionary = main.interact_nearby()
	_expect(str(shop_result.get("interaction_type", "")) == "place_entry" and str(shop_result.get("place_id", "")) == "place_supermarket", "V02.21 runner should enter Shop from arrival")

	_expect(main.move_player_to_cell(Vector2i(21, 12)).get("ok", false), "V02.21 runner should reach School Gate arrival cell")
	_expect(_arrival_proof_visible(main, "ArrivalProofSchoolGate"), "V02.21 runner should show School Gate arrival proof")
	var gate_result: Dictionary = main.interact_nearby()
	_expect(str(gate_result.get("interaction_type", "")) == "homeschool_event" and str(gate_result.get("stage", "")) == "school_gate", "V02.21 runner should trigger School Gate arrival event")

	_expect(main.move_player_to_cell(Vector2i(19, 15)).get("ok", false), "V02.21 runner should reach School Yard arrival cell")
	_expect(_arrival_proof_visible(main, "ArrivalProofSchoolYard"), "V02.21 runner should show School Yard arrival proof")
	var yard_result: Dictionary = main.interact_nearby()
	_expect(str(yard_result.get("interaction_type", "")) == "homeschool_event" and str(yard_result.get("stage", "")) == "school_yard", "V02.21 runner should trigger School Yard arrival event")

	_expect(main.save_service.clear_for_test(), "V02.21 Shop/School arrival save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0221_livegate_free_life_smoke() -> void:
	_expect(V0221LivegateFreeLifeSmokeTestScript != null, "V02.21 livegate free life smoke focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0221_livegate_free_life_smoke.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.21 free life smoke save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.request_player_walk_to_cell(Vector2i(38, 22)).get("ok", false), "V02.21 free smoke runner should walk to Mina")
	main.finish_player_walk_for_test(420)
	_press_visible_button(interact_button, "V02.21 free smoke runner should greet Mina")
	_press_visible_button(interact_button, "V02.21 free smoke runner should start Mina request")
	_expect(main.request_player_walk_to_cell(Vector2i(19, 18)).get("ok", false), "V02.21 free smoke runner should walk to branch")
	main.finish_player_walk_for_test(420)
	_press_visible_button(interact_button, "V02.21 free smoke runner should collect branch")
	_expect(main.request_player_walk_to_cell(Vector2i(19, 22)).get("ok", false), "V02.21 free smoke runner should return to the animal road")
	main.finish_player_walk_for_test(420)
	_expect(main.request_player_walk_to_cell(Vector2i(38, 22)).get("ok", false), "V02.21 free smoke runner should return to Mina")
	main.finish_player_walk_for_test(420)
	_press_visible_button(interact_button, "V02.21 free smoke runner should complete Mina request")

	var state: Dictionary = main.save_service.load_game_state()
	state["coins"] = max(int(state.get("coins", 0)), 12)
	_expect(main.save_service.save_game_state(state), "V02.21 free smoke runner should prepare shop coins")
	_expect(main.request_player_walk_to_cell(Vector2i(41, 11)).get("ok", false), "V02.21 free smoke runner should walk to Shop")
	main.finish_player_walk_for_test(420)
	_press_visible_button(interact_button, "V02.21 free smoke runner should open Shop")
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.21 free smoke runner should buy chair")
	_press_visible_button(main.find_child("CloseShopButton", true, false) as Button, "V02.21 free smoke runner should close Shop")
	_press_visible_button(main.find_child("HomeNavButton", true, false) as Button, "V02.21 free smoke runner should open Home")
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.21 free smoke runner should place chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.21 free smoke runner should persist Home furniture")
	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "V02.21 free smoke runner should return Town")
	_expect(main.request_player_walk_to_cell(Vector2i(21, 12)).get("ok", false), "V02.21 free smoke runner should walk to School Gate")
	main.finish_player_walk_for_test(420)
	_press_visible_button(interact_button, "V02.21 free smoke runner should look School Gate")
	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "V02.21 free smoke runner should open Settings")
	_press_visible_button(main.find_child("RequestRestButton", true, false) as Button, "V02.21 free smoke runner should request rest")
	_press_visible_button(main.find_child("CancelRestButton", true, false) as Button, "V02.21 free smoke runner should cancel rest")
	_press_visible_button(main.find_child("SafePlaceButton", true, false) as Button, "V02.21 free smoke runner should return safe place")

	var saved: Dictionary = main.save_service.load_game_state()
	_expect(saved.get("player_cell") is Dictionary, "V02.21 free smoke runner should persist player cell")
	_expect(not saved.get("daily_requests", {}).is_empty(), "V02.21 free smoke runner should persist daily request state")
	_expect(not saved.get("homeschool_events", {}).is_empty(), "V02.21 free smoke runner should persist School look state")
	_expect(main.save_service.clear_for_test(), "V02.21 free smoke save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0222_actor_prefab_split() -> void:
	_expect(V0222ActorPrefabSplitTestScript != null, "V02.22 actor prefab split focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0222_actor_prefab_split.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.22 actor prefab split save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_expect(_script_path(main.find_child("Player", true, false)).ends_with("player_actor.gd"), "V02.22 runner Player should use PlayerActor")
	_expect(_script_path(main.find_child("npc_mina", true, false)).ends_with("npc_actor.gd"), "V02.22 runner Mina should use NPCActor")
	_expect(_script_path(main.find_child("resource_branch", true, false)).ends_with("resource_object.gd"), "V02.22 runner branch should use ResourceObject")
	_expect(_script_path(main.find_child("anchor_a_apple", true, false)).ends_with("anchor_object.gd"), "V02.22 runner A anchor should use AnchorObject")
	_expect(_script_path(main.find_child("place_home", true, false)).ends_with("interactable_object.gd"), "V02.22 runner Home place should use InteractableObject")
	_expect(_script_path(main.find_child("interaction_home_entry", true, false)).ends_with("interactable_object.gd"), "V02.22 runner Home hotspot should use InteractableObject")
	_expect(main.request_player_walk_to_cell(Vector2i(38, 22)).get("ok", false), "V02.22 runner actor split should keep walk facade")
	main.finish_player_walk_for_test(420)
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.22 runner actor split should keep interaction priority")

	_expect(main.save_service.clear_for_test(), "V02.22 actor prefab split save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0222_ui_scene_split() -> void:
	_expect(V0222UISceneSplitTestScript != null, "V02.22 UI scene split focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0222_ui_scene_split.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.22 UI scene split save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_expect(_script_path(main.find_child("TownHUD", true, false)).ends_with("town_hud.gd"), "V02.22 runner TownHUD should use scene script")
	_expect(_script_path(main.find_child("TownFooter", true, false)).ends_with("town_footer.gd"), "V02.22 runner TownFooter should use scene script")
	_expect(main.status_label != null and main.coin_label != null and main.pet_label != null, "V02.22 runner TownHUD should keep Main label facades")
	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.22 runner UI scene split should open backpack")
	_expect((main.find_child("BackpackBubble", true, false) as Control).visible, "V02.22 runner UI scene split should show backpack")
	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "V02.22 runner UI scene split should open settings")
	_expect((main.find_child("SettingsPanel", true, false) as Control).visible, "V02.22 runner UI scene split should show settings")

	_expect(main.save_service.clear_for_test(), "V02.22 UI scene split save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0222_hidden_grid_life_systems() -> void:
	_expect(V0222HiddenGridLifeSystemsTestScript != null, "V02.22 hidden grid life systems focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0222_hidden_grid_life_systems.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.22 hidden grid life systems save should clear")
	var inventory = InventoryServiceScript.new(service)
	_expect(inventory.collect_item("flower_pot", 1).get("ok", false), "V02.22 runner should seed outdoor decor")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	var place_result: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(32, 21))
	_expect(place_result.get("ok", false), "V02.22 runner should place outdoor decor")
	var instance_id := str(place_result.get("outdoor_item", {}).get("instance_id", ""))
	_expect(main.find_child("outdoor_%s" % instance_id, true, false) != null, "V02.22 runner should render outdoor decor marker")
	_expect(main.move_outdoor_item(instance_id, Vector2i(33, 21)).get("ok", false), "V02.22 runner should move outdoor decor")
	_expect(main.pickup_outdoor_item(instance_id).get("ok", false), "V02.22 runner should pick up outdoor decor")
	var resource_summary: Dictionary = main.resource_refresh_service.get_refresh_summary()
	_expect(resource_summary.get("ok", false) and int(resource_summary.get("available_count", 0)) >= 3, "V02.22 runner should expose resource 2.0 summary")
	var routine_snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(routine_snapshot.get("ok", false), "V02.22 runner should expose NPC routine snapshot")
	_expect(int(routine_snapshot.get("blocked_count", -1)) == 0, "V02.26 complete routine data should keep V02.22 default NPC routines unblocked")

	_expect(main.save_service.clear_for_test(), "V02.22 hidden grid life systems save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0222_hiddengrid_final_smoke() -> void:
	_expect(V0222HiddengridFinalSmokeTestScript != null, "V02.22 hiddengrid final smoke focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0222_hiddengrid_final_smoke.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.22 final smoke save should clear")
	var inventory = InventoryServiceScript.new(service)
	_expect(inventory.collect_item("flower_pot", 1).get("ok", false), "V02.22 final smoke runner should seed outdoor decor")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	_expect(_script_path(main.find_child("TownStage", true, false)).ends_with("town_stage.gd"), "V02.22 final smoke runner should use TownStage")
	_expect(main.request_player_walk_to_cell(Vector2i(38, 22)).get("ok", false), "V02.22 final smoke runner should walk to Mina")
	main.finish_player_walk_for_test(420)
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.22 final smoke runner should keep NPC target")
	var outdoor: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(32, 21))
	_expect(outdoor.get("ok", false), "V02.22 final smoke runner should place outdoor decor")
	_expect(main.resource_refresh_service.get_refresh_summary().get("ok", false), "V02.22 final smoke runner should keep resource summary")
	_expect(main.get_npc_routine_snapshot().get("ok", false), "V02.22 final smoke runner should keep NPC routine snapshot")

	_expect(main.save_service.clear_for_test(), "V02.22 final smoke save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_town_map_authoring_export() -> void:
	_expect(TownMapAuthoringExportTestScript != null, "Town map authoring export focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var summary: Dictionary = scene.call("get_layer_summary")
	for key in ["has_ground_preview", "has_road_layer", "has_collision_layer", "has_interaction_layer", "has_place_marker_layer", "has_anchor_marker_layer", "has_resource_marker_layer", "has_npc_spawn_layer", "has_export_validation_panel"]:
		_expect(bool(summary.get(key, false)), "TownMapAuthoring runner should expose layer: %s" % key)
	_expect(_v0223_has_authoring_marker(scene, "place", "place_home"), "TownMapAuthoring runner should create Home place marker")
	_expect(_v0223_has_authoring_marker(scene, "anchor", "anchor_a_apple"), "TownMapAuthoring runner should create A anchor marker")
	var moved: Dictionary = scene.call("set_marker_cell_for_test", "place", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "TownMapAuthoring runner should move a place marker by cell")
	var exported: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "TownMapAuthoring runner export should pass world map contract: %s" % [exported.get("errors", [])])
	_expect(exported.get("data", {}).get("memory_anchors", []).size() == 26, "TownMapAuthoring runner export should preserve 26 A-Z anchors")
	root.remove_child(scene)
	scene.queue_free()


func _check_v0225_mapauth001_validation_panel() -> void:
	_expect(V0225Mapauth001ValidationPanelTestScript != null, "V02.25 MAPAUTH-001 validation panel focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var summary: Dictionary = scene.call("get_layer_summary")
	_expect(bool(summary.get("has_validate_export_button", false)), "V02.25 MAPAUTH-001 runner should expose Validate button")
	var validation: Dictionary = scene.call("validate_export_candidate")
	_expect(validation.get("ok", false), "V02.25 MAPAUTH-001 runner valid candidate should pass")
	_expect(int(validation.get("error_count", -1)) == 0, "V02.25 MAPAUTH-001 runner valid candidate should show no errors")
	_expect(not bool(validation.get("wrote_file", true)), "V02.25 MAPAUTH-001 runner should not write JSON")
	_expect(scene.call("set_marker_cell_for_test", "place", "place_home", Vector2i(-5, -5)).get("ok", false), "V02.25 MAPAUTH-001 runner should move a marker for invalid validation")
	validation = scene.call("validate_export_candidate")
	_expect(not validation.get("ok", true), "V02.25 MAPAUTH-001 runner invalid candidate should fail")
	_expect(int(validation.get("error_count", 0)) > 0, "V02.25 MAPAUTH-001 runner invalid candidate should show errors")
	var validation_summary: Dictionary = scene.call("get_validation_summary")
	_expect(str(validation_summary.get("error_text", "")).contains("place position outside district"), "V02.25 MAPAUTH-001 runner should list contract errors")
	_expect(not bool(validation_summary.get("wrote_file", true)), "V02.25 MAPAUTH-001 runner invalid validation should not write JSON")
	root.remove_child(scene)
	scene.queue_free()


func _check_v0225_mapauth002_write_back_service() -> void:
	_expect(V0225Mapauth002WriteBackServiceTestScript != null, "V02.25 MAPAUTH-002 write-back service focused test should compile for headless runner")
	var source_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(source_result.get("ok", false), "V02.25 MAPAUTH-002 runner should load source world_map")
	var source_map: Dictionary = source_result.get("data", {}).duplicate(true)
	var target_path := "user://headless_runner_mapauth002_world_map.json"
	_runner_cleanup_mapauth002_paths(target_path)
	var seed_result: Dictionary = MapEditorSyncServiceScript.write_valid_dictionary(source_map, target_path)
	_expect(seed_result.get("ok", false), "V02.25 MAPAUTH-002 runner should seed valid temp target")
	var valid_candidate := source_map.duplicate(true)
	valid_candidate["version"] = "headless_mapauth002_valid"
	var write_result: Dictionary = MapEditorSyncServiceScript.write_if_valid(valid_candidate, target_path)
	_expect(write_result.get("ok", false) and bool(write_result.get("written", false)), "V02.25 MAPAUTH-002 runner valid write should succeed")
	_expect(int(write_result.get("anchor_count", 0)) == 26, "V02.25 MAPAUTH-002 runner valid write should preserve 26 anchors")
	_expect(RuntimeMapBuilderScript.load_world_map(target_path).get("ok", false), "V02.25 MAPAUTH-002 runner written file should load")
	var before_invalid := _runner_read_text(target_path)
	var invalid_candidate := source_map.duplicate(true)
	var anchors: Array = invalid_candidate.get("memory_anchors", [])
	if not anchors.is_empty() and anchors[0] is Dictionary:
		(anchors[0] as Dictionary)["route_order"] = 99
	invalid_candidate["memory_anchors"] = anchors
	write_result = MapEditorSyncServiceScript.write_if_valid(invalid_candidate, target_path)
	_expect(not write_result.get("ok", true), "V02.25 MAPAUTH-002 runner invalid write should fail")
	_expect(str(write_result.get("reason", "")) == "validation_failed", "V02.25 MAPAUTH-002 runner invalid write should fail before disk write")
	_expect(_runner_read_text(target_path) == before_invalid, "V02.25 MAPAUTH-002 runner invalid write should preserve target")
	write_result = MapEditorSyncServiceScript.write_if_valid(valid_candidate, target_path, {"simulate_commit_failure": true})
	_expect(not write_result.get("ok", true), "V02.25 MAPAUTH-002 runner simulated failure should fail")
	_expect(_runner_read_text(target_path) == before_invalid, "V02.25 MAPAUTH-002 runner simulated failure should preserve target")
	_runner_cleanup_mapauth002_paths(target_path)


func _check_v0225_mapauth003_place_marker_loop() -> void:
	_expect(V0225Mapauth003PlaceMarkerLoopTestScript != null, "V02.25 MAPAUTH-003 place marker loop focused test should compile for headless runner")
	var original_text := _runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var before_summary: Dictionary = scene.call("get_authoring_place_summary")
	var before_count := int(before_summary.get("place_count", 0))
	var added: Dictionary = scene.call(
		"add_place_marker_candidate",
		"place_authoring_picnic_runner",
		"Picnic Runner",
		"district_sun_scene",
		"landmark",
		Vector2i(3, 1),
		Vector2i.ONE
	)
	_expect(added.get("ok", false), "V02.25 MAPAUTH-003 runner should add a place candidate")
	_expect(int(added.get("place_count", 0)) == before_count + 1, "V02.25 MAPAUTH-003 runner add should increase place count")
	var duplicate: Dictionary = scene.call(
		"add_place_marker_candidate",
		"place_authoring_picnic_runner",
		"Picnic Runner",
		"district_sun_scene",
		"landmark",
		Vector2i(4, 1),
		Vector2i.ONE
	)
	_expect(not duplicate.get("ok", true), "V02.25 MAPAUTH-003 runner should reject duplicate place ids")
	var exported: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "V02.25 MAPAUTH-003 runner added candidate should validate: %s" % [exported.get("errors", [])])
	_expect(exported.get("data", {}).get("memory_anchors", []).size() == 26, "V02.25 MAPAUTH-003 runner should preserve 26 A-Z anchors")
	_expect(scene.call("validate_export_candidate").get("ok", false), "V02.25 MAPAUTH-003 runner valid add should pass visible validation")
	var protected_delete: Dictionary = scene.call("delete_place_marker_candidate", "place_home")
	_expect(not protected_delete.get("ok", true), "V02.25 MAPAUTH-003 runner should reject deleting anchor-owned place")
	_expect(str(protected_delete.get("reason", "")) == "place_has_anchors", "V02.25 MAPAUTH-003 runner protected delete should name reason")
	var deleted: Dictionary = scene.call("delete_place_marker_candidate", "place_authoring_picnic_runner")
	_expect(deleted.get("ok", false), "V02.25 MAPAUTH-003 runner should delete the added place candidate")
	_expect(int(deleted.get("place_count", -1)) == before_count, "V02.25 MAPAUTH-003 runner delete should restore place count")
	exported = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "V02.25 MAPAUTH-003 runner deleted candidate should leave valid export: %s" % [exported.get("errors", [])])
	_expect(_runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == original_text, "V02.25 MAPAUTH-003 runner should not mutate runtime world_map.json")
	root.remove_child(scene)
	scene.queue_free()


func _check_v0225_mapauth004_anchor_protection() -> void:
	_expect(V0225Mapauth004AnchorProtectionTestScript != null, "V02.25 MAPAUTH-004 anchor protection focused test should compile for headless runner")
	var original_text := _runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var summary: Dictionary = scene.call("get_authoring_anchor_summary")
	_expect(int(summary.get("anchor_count", 0)) == 26, "V02.25 MAPAUTH-004 runner should start with 26 anchors")
	_expect(int(summary.get("protected_anchor_count", 0)) == 26, "V02.25 MAPAUTH-004 runner should protect all 26 A-Z anchors")
	var delete_result: Dictionary = scene.call("delete_anchor_marker_candidate", "anchor_a_apple")
	_expect(not delete_result.get("ok", true), "V02.25 MAPAUTH-004 runner should reject deleting A anchor")
	_expect(str(delete_result.get("reason", "")) == "protected_core_anchor", "V02.25 MAPAUTH-004 runner delete rejection should name reason")
	var unknown_delete: Dictionary = scene.call("delete_anchor_marker_candidate", "anchor_missing_runner")
	_expect(not unknown_delete.get("ok", true), "V02.25 MAPAUTH-004 runner should reject unknown anchor delete")
	for field_name in ["anchor_id", "letter", "core_word", "route_order", "place_id", "card_id", "audio_id"]:
		var edit_result: Dictionary = scene.call("edit_anchor_field_candidate", "anchor_a_apple", field_name, "bad_runner_value")
		_expect(not edit_result.get("ok", true), "V02.25 MAPAUTH-004 runner should reject locked field: %s" % field_name)
		_expect(str(edit_result.get("reason", "")) == "anchor_field_locked", "V02.25 MAPAUTH-004 runner locked field should name reason: %s" % field_name)
	var moved: Dictionary = scene.call("set_marker_cell_for_test", "anchor", "anchor_a_apple", Vector2i(29, 16))
	_expect(moved.get("ok", false), "V02.25 MAPAUTH-004 runner should still allow anchor marker position candidate")
	var exported: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "V02.25 MAPAUTH-004 runner export should stay valid: %s" % [exported.get("errors", [])])
	_expect(exported.get("data", {}).get("memory_anchors", []).size() == 26, "V02.25 MAPAUTH-004 runner export should keep 26 anchors")
	_expect(_letters(exported.get("data", {})) == _az_letters(), "V02.25 MAPAUTH-004 runner export should preserve A-Z order")
	_expect(scene.call("validate_export_candidate").get("ok", false), "V02.25 MAPAUTH-004 runner validation should pass")
	_expect(_runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == original_text, "V02.25 MAPAUTH-004 runner should not mutate runtime world_map.json")
	root.remove_child(scene)
	scene.queue_free()


func _check_v0225_mapauth005_place_move_linkage() -> void:
	_expect(V0225Mapauth005PlaceMoveLinkageTestScript != null, "V02.25 MAPAUTH-005 place move linkage focused test should compile for headless runner")
	var original_text := _runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var moved: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "V02.25 MAPAUTH-005 runner should move Home with linkage")
	_expect(_runner_cell_key(moved.get("interaction_cell", {})) == "32,19", "V02.25 MAPAUTH-005 runner should preserve Home interaction offset")
	_expect(int(moved.get("interaction_update_count", 0)) >= 1, "V02.25 MAPAUTH-005 runner should update primary interaction")
	_expect(int(moved.get("collision_update_count", 0)) >= 6, "V02.25 MAPAUTH-005 runner should update linked collision cells")
	var exported: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "V02.25 MAPAUTH-005 runner export should pass after move: %s" % [exported.get("errors", [])])
	var home_place: Dictionary = _runner_place_by_id(exported.get("data", {}), "place_home")
	_expect(_runner_cell_key(home_place.get("position", {})) == "30,17", "V02.25 MAPAUTH-005 runner should export moved Home position")
	_expect(_runner_cell_key(home_place.get("interaction_cell", {})) == "32,19", "V02.25 MAPAUTH-005 runner should export moved Home interaction")
	_expect(_runner_has_occupied_cell(home_place, "30,17"), "V02.25 MAPAUTH-005 runner should shift Home occupied cells")
	var invalid_move: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(-5, -5))
	_expect(not invalid_move.get("ok", true), "V02.25 MAPAUTH-005 runner should reject invalid move")
	exported = MapEditorSyncServiceScript.export_authoring_scene(scene)
	home_place = _runner_place_by_id(exported.get("data", {}), "place_home")
	_expect(_runner_cell_key(home_place.get("position", {})) == "30,17", "V02.25 MAPAUTH-005 runner rejected move should keep previous valid position")
	_expect(scene.call("validate_export_candidate").get("ok", false), "V02.25 MAPAUTH-005 runner validation should pass after move checks")
	_expect(_runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == original_text, "V02.25 MAPAUTH-005 runner should not mutate runtime world_map.json")
	root.remove_child(scene)
	scene.queue_free()


func _check_v0225_mapauth006_regression_pack() -> void:
	_expect(V0225Mapauth006RegressionPackTestScript != null, "V02.25 MAPAUTH-006 regression pack focused test should compile for headless runner")
	var original_text := _runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var target_path := "user://headless_runner_mapauth006_world_map.json"
	_runner_cleanup_mapauth002_paths(target_path)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var moved: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "V02.25 MAPAUTH-006 runner should prepare linked move candidate")
	var write_result: Dictionary = MapEditorSyncServiceScript.write_authoring_scene_if_valid(scene, target_path)
	_expect(write_result.get("ok", false), "V02.25 MAPAUTH-006 runner valid authoring write should pass: %s" % [write_result.get("errors", [])])
	_expect(bool(write_result.get("written", false)), "V02.25 MAPAUTH-006 runner valid write should report written")
	_expect(int(write_result.get("anchor_count", 0)) == 26, "V02.25 MAPAUTH-006 runner valid write should preserve anchors")
	var loaded: Dictionary = RuntimeMapBuilderScript.load_world_map(target_path)
	_expect(loaded.get("ok", false), "V02.25 MAPAUTH-006 runner written temp map should load")
	var home_place: Dictionary = _runner_place_by_id(loaded.get("data", {}), "place_home")
	_expect(_runner_cell_key(home_place.get("position", {})) == "30,17", "V02.25 MAPAUTH-006 runner written map should include moved Home")
	var before_invalid := _runner_read_text(target_path)
	_expect(scene.call("set_marker_cell_for_test", "place", "place_home", Vector2i(-5, -5)).get("ok", false), "V02.25 MAPAUTH-006 runner should prepare invalid raw candidate")
	write_result = MapEditorSyncServiceScript.write_authoring_scene_if_valid(scene, target_path)
	_expect(not write_result.get("ok", true), "V02.25 MAPAUTH-006 runner invalid authoring write should fail")
	_expect(str(write_result.get("reason", "")) == "validation_failed", "V02.25 MAPAUTH-006 runner invalid write should fail at validation")
	_expect(_runner_read_text(target_path) == before_invalid, "V02.25 MAPAUTH-006 runner invalid write should preserve temp target")
	_expect(_runner_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == original_text, "V02.25 MAPAUTH-006 runner should not mutate runtime world_map.json")
	root.remove_child(scene)
	scene.queue_free()
	_runner_cleanup_mapauth002_paths(target_path)


func _runner_read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


func _runner_world_map() -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "Headless runner should load world map for service checks")
	return result.get("data", {}).duplicate(true)


func _runner_place_by_id(map_data: Dictionary, place_id: String) -> Dictionary:
	for place in map_data.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			return place
	return {}


func _runner_has_occupied_cell(place: Dictionary, key: String) -> bool:
	for cell in place.get("occupied_cells", []):
		if _runner_cell_key(cell) == key:
			return true
	return false


func _has_place_at(map_data: Dictionary, place_id: String, key: String) -> bool:
	var place := _runner_place_by_id(map_data, place_id)
	return not place.is_empty() and _runner_cell_key(place.get("position", {})) == key


func _interaction_action_for_place(map_data: Dictionary, place_id: String) -> String:
	for interaction in map_data.get("interaction_cells", []):
		if interaction is Dictionary and str((interaction as Dictionary).get("place_id", "")) == place_id:
			return str((interaction as Dictionary).get("action", ""))
	return ""


func _resource_cell(data: Dictionary, point_id: String) -> String:
	for point in data.get("resource_points", []):
		if point is Dictionary and str((point as Dictionary).get("point_id", "")) == point_id:
			return _runner_cell_key((point as Dictionary).get("cell", {}))
	return ""


func _routine_cell(data: Dictionary, day_key: String, routine_id: String) -> String:
	for day in data.get("routine_days", []):
		if not day is Dictionary or str((day as Dictionary).get("day_key", "")) != day_key:
			continue
		for npc in (day as Dictionary).get("npcs", []):
			if npc is Dictionary and str((npc as Dictionary).get("routine_id", "")) == routine_id:
				return _runner_cell_key((npc as Dictionary).get("cell", {}))
	return ""


func _runner_cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]


func _runner_cleanup_mapauth002_paths(target_path: String) -> void:
	for path in [target_path, target_path + ".tmp", target_path + ".bak"]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _check_town_stage_layered_runtime() -> void:
	_expect(TownStageLayeredRuntimeTestScript != null, "TownStage layered runtime focused test should compile for headless runner")
	var save_path := "user://headless_runner_town_stage_layered_runtime.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "TownStage layered runtime save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null, "TownStage runner should exist")
	for layer_name in ["GroundLayer", "RoadVisualLayer", "PlaceLayer", "PlazaLifeLayer", "HotspotLayer", "CollisionDebugLayer", "AnchorLayer", "ResourceLayer", "NPCActorLayer", "OutdoorDecorLayer", "PlayerLayer"]:
		_expect(stage.find_child(layer_name, true, false) != null, "TownStage runner should expose runtime layer: %s" % layer_name)
	_expect((stage.find_child("CollisionDebugLayer", true, false) as CanvasItem).visible == false, "TownStage runner CollisionDebugLayer should stay hidden")
	_expect((stage.find_child("RoadVisualLayer", true, false) as Node).get_child_count() > 0, "TownStage runner RoadVisualLayer should contain road visuals")
	_expect((stage.find_child("PlaceLayer", true, false) as Node).find_child("place_home", true, false) != null, "TownStage runner PlaceLayer should contain Home")
	_expect(stage.has_method("get_visual_recovery_snapshot"), "TownStage runner should expose V02.38 modular visual recovery snapshot")
	if stage.has_method("get_visual_recovery_snapshot"):
		var visual_snapshot: Dictionary = stage.call("get_visual_recovery_snapshot")
		_expect(int(visual_snapshot.get("terrain_tile_count", 0)) >= 100, "TownStage runner should build first screen from modular terrain tiles")
		_expect(int(visual_snapshot.get("region_chunk_count", 0)) >= 4, "TownStage runner should render Home / Plaza / Shop / School region chunks")
		_expect(int(visual_snapshot.get("building_prefab_count", 0)) >= 3, "TownStage runner should render Home, Shop, and School Gate building prefabs")
		_expect(int(visual_snapshot.get("world_prop_count", 0)) == 3, "TownStage runner should render the three first-screen recovery world props once")
		_expect(not bool(visual_snapshot.get("uses_full_map_background", true)), "TownStage runner should not use place.world_map.base_1280 as final runtime background")
		_expect(not bool(visual_snapshot.get("has_legacy_ground_sprite", true)), "TownStage runner should not create a single legacy Ground sprite")
		_expect(float(visual_snapshot.get("non_prefab_place_max_alpha", 1.0)) <= 0.22, "TownStage runner non-prefab place context markers should stay visually quiet")
		_expect(float(visual_snapshot.get("anchor_badge_max_alpha", 1.0)) <= 0.5, "TownStage runner anchor badges should be muted helper marks")
	_expect((stage.find_child("AnchorLayer", true, false) as Node).find_child("anchor_a_apple", true, false) != null, "TownStage runner AnchorLayer should contain A anchor")
	_expect((stage.find_child("ResourceLayer", true, false) as Node).get_child_count() > 0, "TownStage runner ResourceLayer should contain resources")
	_expect((stage.find_child("NPCActorLayer", true, false) as Node).find_child("npc_mina", true, false) != null, "TownStage runner NPCActorLayer should contain Mina")
	_expect((stage.find_child("PlayerLayer", true, false) as Node).find_child("Player", true, false) != null, "TownStage runner PlayerLayer should contain Player")
	_expect(main.runtime_map_node != null and main.runtime_map_input != null and main.player_marker != null, "TownStage runner should keep Main runtime facades")
	_expect(main.save_service.clear_for_test(), "TownStage layered runtime save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0223_ui_panel_scene_split() -> void:
	_expect(V0223UIPanelSceneSplitTestScript != null, "V02.23 UI panel scene split focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0223_ui_panel_scene_split.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.23 UI panel scene split save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	_expect(_script_path(main.find_child("BackpackBubble", true, false)).ends_with("backpack_bubble.gd"), "V02.23 runner BackpackBubble should use scene script")
	_expect(_script_path(main.find_child("SettingsPanel", true, false)).ends_with("settings_panel.gd"), "V02.23 runner SettingsPanel should use scene script")
	_expect(_script_path(main.find_child("ShopPanel", true, false)).ends_with("shop_panel.gd"), "V02.23 runner ShopPanel should use scene script")
	_expect(_script_path(main.find_child("MemoryAlbumOverlay", true, false)).ends_with("memory_album_overlay.gd"), "V02.23 runner MemoryAlbumOverlay should use scene script")
	_expect(_script_path(main.find_child("HomeRoom", true, false)).ends_with("home_room.gd"), "V02.23 runner HomeRoom should use scene script")
	for node_name in ["BackpackTitle", "BackpackSummary", "BackpackItems", "BackpackCollection", "OpenMemoryAlbumButton", "OpenLetterSnakeButton", "SettingsStatus", "SoundToggleButton", "SafePlaceButton", "RequestRestButton", "CancelRestButton", "ConfirmExitButton", "CloseSettingsButton", "ShopStatus", "ShopItemsList", "CloseShopButton", "MemoryAlbum", "CloseMemoryAlbumButton", "HomeRoomStage", "HomeFurnitureLayer", "HomeSunny", "SunnyHomeFeedback", "HomeActionPanel", "HomeInventoryList", "HomeRotateFirstFurnitureButton"]:
		_expect(main.find_child(node_name, true, false) != null, "V02.23 runner UI panel scene should expose node: %s" % node_name)
	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.23 runner should open Backpack")
	_expect((main.find_child("BackpackBubble", true, false) as Control).visible, "V02.23 runner BackpackBubble should become visible")
	_press_visible_button(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.23 runner should open Album from Backpack")
	_expect((main.find_child("MemoryAlbumOverlay", true, false) as Control).visible, "V02.23 runner MemoryAlbumOverlay should become visible")
	_press_visible_button(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.23 runner should close Album")
	_expect(main.open_shop_panel().get("ok", false), "V02.23 runner Shop facade should still open")
	_expect((main.find_child("ShopPanel", true, false) as Control).visible, "V02.23 runner ShopPanel should become visible")
	_press_visible_button(main.find_child("CloseShopButton", true, false) as Button, "V02.23 runner should close Shop")
	main.show_home_view()
	_expect((main.find_child("HomeRoom", true, false) as Control).visible, "V02.23 runner HomeRoom should become visible")
	_expect(main.save_service.clear_for_test(), "V02.23 UI panel scene split save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0223_expapproval_town_plaza_density() -> void:
	_expect(V0223ExpapprovalTownPlazaDensityTestScript != null, "V02.23 EXPAPPROVAL town plaza density focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0223_expapproval_town_plaza_density.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.23 EXPAPPROVAL density save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.23 EXPAPPROVAL runner should expose TownStage snapshot")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(snapshot.get("plaza_life_detail_count", 0)) >= 5, "V02.23 EXPAPPROVAL runner should keep plaza life details")
		_expect(int(snapshot.get("anchor_count", 0)) == 26, "V02.23 EXPAPPROVAL runner should keep all A-Z anchors")
		_expect(int(snapshot.get("muted_anchor_badge_count", 0)) == int(snapshot.get("anchor_badge_count", -1)), "V02.23 EXPAPPROVAL runner should keep anchor badges muted")
	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.23 EXPAPPROVAL runner should reach Mina")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.23 EXPAPPROVAL runner should keep resident priority")
	_expect(main.save_service.clear_for_test(), "V02.23 EXPAPPROVAL density save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0223_expapproval_home_living_density() -> void:
	_expect(V0223ExpapprovalHomeLivingDensityTestScript != null, "V02.23 EXPAPPROVAL Home living density focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0223_expapproval_home_living_density.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.23 EXPAPPROVAL Home save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	main.show_home_view()
	_expect(main.has_method("get_expapproval_home_snapshot"), "V02.23 EXPAPPROVAL runner should expose Home snapshot")
	if main.has_method("get_expapproval_home_snapshot"):
		var snapshot: Dictionary = main.get_expapproval_home_snapshot()
		_expect(int(snapshot.get("home_life_detail_count", 0)) >= 6, "V02.23 EXPAPPROVAL runner should keep Home lived-in details")
		_expect(int(snapshot.get("child_text_banned_count", -1)) == 0, "V02.23 EXPAPPROVAL runner should keep Home child text free of grid and coordinate terms")
		_expect(int(snapshot.get("placed_furniture_count", -1)) == 0, "V02.23 EXPAPPROVAL default Home details should not be saved furniture")
	var collected: Dictionary = main.inventory_service.collect_item("wooden_chair", 1)
	_expect(collected.get("ok", false), "V02.23 EXPAPPROVAL runner should seed Home furniture")
	main.show_home_view()
	_press_visible_button(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should keep visible Home place button")
	if main.has_method("get_expapproval_home_snapshot"):
		var placed_snapshot: Dictionary = main.get_expapproval_home_snapshot()
		_expect(int(placed_snapshot.get("placed_furniture_count", 0)) == 1, "V02.23 EXPAPPROVAL runner should keep visible furniture placement")
		_expect(int(placed_snapshot.get("child_text_banned_count", -1)) == 0, "V02.23 EXPAPPROVAL placed Home text should remain child-facing")
	_expect(main.save_service.clear_for_test(), "V02.23 EXPAPPROVAL Home save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0224_home_room_living_contract() -> void:
	_expect(V0224HomeRoomLivingContractTestScript != null, "V02.24 HomeRoom living contract focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0224_home_room_living_contract.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.24 HomeRoom runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	main.show_home_view()
	_expect(main.has_method("get_expapproval_home_snapshot"), "V02.24 HomeRoom runner should expose Home snapshot")
	if main.has_method("get_expapproval_home_snapshot"):
		var snapshot: Dictionary = main.get_expapproval_home_snapshot()
		_expect(str(snapshot.get("home_living_contract_version", "")) == "v02.24_homeplaza_002", "V02.24 HomeRoom runner should expose living contract version")
		_expect(int(snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 HomeRoom runner should keep reinforced default living details")
		_expect((snapshot.get("home_life_detail_names", []) as Array).has("HomeDefaultBookStack"), "V02.24 HomeRoom runner should keep default book stack visible")
		_expect((snapshot.get("home_life_detail_names", []) as Array).has("HomeDefaultSunnyToy"), "V02.24 HomeRoom runner should keep Sunny toy visible")
		_expect((snapshot.get("home_life_detail_names", []) as Array).has("HomeDefaultWarmCup"), "V02.24 HomeRoom runner should keep warm cup visible")
		_expect(int(snapshot.get("placed_furniture_count", -1)) == 0, "V02.24 HomeRoom runner default details should not be saved furniture")
		_expect(int(snapshot.get("child_text_banned_count", -1)) == 0, "V02.24 HomeRoom runner child text should stay free of technical terms")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["inventory"] = {"pet_bowl": 1, "sunny_bed": 1}
	game_state["home_state"] = {"placed_furniture": [], "stowed_furniture": {}}
	_expect(main.save_service.save_game_state(game_state), "V02.24 HomeRoom runner should seed Sunny furniture")
	main.show_home_view()
	_press_visible_button(main.find_child("HomePlacePetBowlButton", true, false) as Button, "V02.24 HomeRoom runner should place pet bowl through visible button")
	_press_visible_button(main.find_child("HomePlaceSunnyBedButton", true, false) as Button, "V02.24 HomeRoom runner should place Sunny bed through visible button")
	if main.has_method("get_expapproval_home_snapshot"):
		var placed_snapshot: Dictionary = main.get_expapproval_home_snapshot()
		_expect(int(placed_snapshot.get("placed_furniture_count", 0)) == 2, "V02.24 HomeRoom runner should save real placed furniture only")
		_expect(int(placed_snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 HomeRoom runner default details should remain after placement")
		_expect(str(placed_snapshot.get("sunny_feedback_text", "")).contains("Sunny"), "V02.24 HomeRoom runner should keep Sunny feedback after placement")
		_expect(int(placed_snapshot.get("child_text_banned_count", -1)) == 0, "V02.24 HomeRoom runner placed text should stay child-facing")
	_expect(main.save_service.clear_for_test(), "V02.24 HomeRoom runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0224_town_plaza_outdoor_decor_rules() -> void:
	_expect(V0224TownPlazaOutdoorDecorRulesTestScript != null, "V02.24 Town Plaza outdoor decor rules focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0224_town_plaza_outdoor_decor_rules.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.24 Town Plaza runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var summary: Dictionary = main.outdoor_decoration_service.get_allowed_place_summary()
	_expect(int(summary.get("allowed_zone_count", 0)) >= 2, "V02.24 Town Plaza runner should define allowed decor zones")
	_expect(int(summary.get("protected_anchor_count", 0)) == 26, "V02.24 Town Plaza runner should protect all anchors")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.24 Town Plaza runner should expose TownStage snapshot")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(snapshot.get("plaza_stay_point_count", 0)) >= 4, "V02.24 Town Plaza runner should keep plaza stay points")
		_expect((snapshot.get("plaza_stay_point_names", []) as Array).has("PlazaChatStool"), "V02.24 Town Plaza runner should include chat stay point")
		_expect((snapshot.get("plaza_stay_point_names", []) as Array).has("PlazaSnackCrate"), "V02.24 Town Plaza runner should include snack stay point")
	var inventory = InventoryServiceScript.new(main.save_service)
	_expect(inventory.collect_item("flower_pot", 1).get("ok", false), "V02.24 Town Plaza runner should seed safe outdoor decor")
	var placed: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(32, 21))
	_expect(placed.get("ok", false), "V02.24 Town Plaza runner should place decor in a safe corner")
	var blocked: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(34, 20))
	_expect(not blocked.get("ok", true), "V02.24 Town Plaza runner should reject decor on Taxi anchor")
	_expect(str(blocked.get("reason", "")) == "covers_core_target", "V02.24 Town Plaza runner should report protected target")
	_expect(str(blocked.get("protected_kind", "")) == "anchor", "V02.24 Town Plaza runner should identify protected anchor")
	_expect(main.save_service.clear_for_test(), "V02.24 Town Plaza runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0224_npc_routine_arrival_safety() -> void:
	_expect(V0224NPCRoutineArrivalSafetyTestScript != null, "V02.24 NPC routine arrival safety focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0224_npc_routine_arrival_safety.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.24 NPC routine runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(snapshot.get("ok", false), "V02.24 NPC routine runner should expose snapshot")
	_expect(int(snapshot.get("plaza_arrival_count", 0)) >= 2, "V02.24 NPC routine runner should report plaza arrivals")
	var npcs: Array = snapshot.get("npcs", [])
	var mina := _runner_npc_by_id(npcs, "mina")
	_expect(str(mina.get("arrival_zone", "")) == "town_plaza", "V02.24 NPC routine runner should keep Mina at plaza arrival")
	_expect(str(mina.get("arrival_text", "")).contains("Mina"), "V02.24 NPC routine runner should expose Mina arrival text")
	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.24 NPC routine runner should reach Mina")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.24 NPC routine runner should keep Mina prompt")
	_expect(main.move_player_to_cell(Vector2i(43, 12)).get("ok", false), "V02.24 NPC routine runner should reach Shopkeeper")
	target = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "shopkeeper", "V02.24 NPC routine runner should keep Shopkeeper prompt")
	_expect(main.save_service.clear_for_test(), "V02.24 NPC routine runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _runner_npc_by_id(npcs: Array, npc_id: String) -> Dictionary:
	for value in npcs:
		if value is Dictionary and str((value as Dictionary).get("npc_id", "")) == npc_id:
			return value
	_expect(false, "NPC routine runner snapshot should include %s" % npc_id)
	return {}


func _check_v0224_homeplaza005_rc_smoke() -> void:
	_expect(V0224Homeplaza005RCSmokeTestScript != null, "V02.24 HOMEPLAZA-005 RC smoke focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0224_homeplaza005_rc_smoke.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.24 HOMEPLAZA-005 runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	main.show_home_view()
	var home_snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(int(home_snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 HOMEPLAZA-005 runner should keep Home living details")
	_expect(int(home_snapshot.get("placed_furniture_count", -1)) == 0, "V02.24 HOMEPLAZA-005 runner should keep default Home details out of save state")
	main.show_town_view()
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.24 HOMEPLAZA-005 runner should expose TownStage snapshot")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var plaza_snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(plaza_snapshot.get("plaza_stay_point_count", 0)) >= 4, "V02.24 HOMEPLAZA-005 runner should keep plaza stay points")
		_expect(int(plaza_snapshot.get("anchor_count", 0)) == 26, "V02.24 HOMEPLAZA-005 runner should keep 26 A-Z anchors")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["inventory"] = {"flower_pot": 1}
	_expect(main.save_service.save_game_state(game_state), "V02.24 HOMEPLAZA-005 runner should seed outdoor decor")
	_expect(main.place_outdoor_item("flower_pot", Vector2i(32, 21)).get("ok", false), "V02.24 HOMEPLAZA-005 runner should place safe outdoor decor")
	var routine_snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(int(routine_snapshot.get("plaza_arrival_count", 0)) >= 2, "V02.24 HOMEPLAZA-005 runner should keep NPC plaza arrivals")
	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.24 HOMEPLAZA-005 runner should reach Mina")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.24 HOMEPLAZA-005 runner should keep Mina prompt")
	_expect(main.save_service.clear_for_test(), "V02.24 HOMEPLAZA-005 runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v026_contentbatch001_npc_routine_batch() -> void:
	_expect(V026Contentbatch001NPCRoutineBatchTestScript != null, "V02.26 CONTENTBATCH-001 NPC routine batch focused test should compile for headless runner")
	var routine_service = NPCRoutineServiceScript.new(LocalDayServiceScript.new("local_day_007"), NPCRoutineServiceScript.ROUTINES_PATH, _runner_world_map())
	_expect(routine_service.is_loaded(), "V02.26 CONTENTBATCH-001 runner should load NPC routine data")
	_expect(routine_service.routines_by_day.size() == 7, "V02.26 CONTENTBATCH-001 runner should load seven routine days")
	var save_path := "user://headless_runner_v026_contentbatch001_npc_routine_batch.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.26 CONTENTBATCH-001 runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_007")
	root.add_child(main)
	main.call("_ready")
	var snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(snapshot.get("ok", false), "V02.26 CONTENTBATCH-001 runner snapshot should succeed")
	_expect(int(snapshot.get("blocked_count", -1)) == 0, "V02.26 CONTENTBATCH-001 runner should have no blocked default routines")
	var mina := _runner_npc_by_id(snapshot.get("npcs", []), "mina")
	_expect(_runner_cell_key(mina.get("cell", {})) == "38,21", "V02.26 CONTENTBATCH-001 runner should apply day 7 Mina cell")
	_expect(main.move_player_to_cell(Vector2i(38, 21)).get("ok", false), "V02.26 CONTENTBATCH-001 runner should reach day 7 Mina")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.26 CONTENTBATCH-001 runner should keep Mina prompt")
	_expect(main.save_service.clear_for_test(), "V02.26 CONTENTBATCH-001 runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v026_contentbatch002_resource_points() -> void:
	_expect(V026Contentbatch002ResourcePointsTestScript != null, "V02.26 CONTENTBATCH-002 resource focused test should compile for headless runner")
	var save_path := "user://headless_runner_v026_contentbatch002_resource_points.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.26 CONTENTBATCH-002 runner save should clear")
	var inventory = InventoryServiceScript.new(service)
	var resources = ResourceRefreshServiceScript.new(service, inventory, LocalDayServiceScript.new("local_day_002"))
	_expect(resources.is_loaded(), "V02.26 CONTENTBATCH-002 runner should load resource data")
	_expect(resources.points_by_id.size() >= 7, "V02.26 CONTENTBATCH-002 runner should include baseline plus new resource points")
	for point_id in ["resource_shell_coast_edge", "resource_leaf_school_walk", "resource_pinecone_animal_park", "resource_ribbon_shop_street"]:
		var point: Dictionary = resources.get_point(point_id)
		_expect(point.get("ok", false), "V02.26 CONTENTBATCH-002 runner should resolve point: %s" % point_id)
		_expect(str(point.get("refresh_rule", {}).get("mode", "")) == "daily_soft", "V02.26 CONTENTBATCH-002 runner point should stay daily_soft: %s" % point_id)
		_expect(str(point.get("refresh_rule", {}).get("player_pressure", "")) == "none", "V02.26 CONTENTBATCH-002 runner point should carry no pressure: %s" % point_id)
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_002")
	root.add_child(main)
	main.call("_ready")
	_expect(main.move_player_to_cell(Vector2i(53, 28)).get("ok", false), "V02.26 CONTENTBATCH-002 runner should reach coast shell")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "resource" and str(target.get("target_id", "")) == "resource_shell_coast_edge", "V02.26 CONTENTBATCH-002 runner should prompt coast shell")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "resource" and str(result.get("item_id", "")) == "shell", "V02.26 CONTENTBATCH-002 runner should collect shell")
	_expect(main.save_service.clear_for_test(), "V02.26 CONTENTBATCH-002 runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v026_contentbatch003_anchor_revisits() -> void:
	_expect(V026Contentbatch003AnchorRevisitsTestScript != null, "V02.26 CONTENTBATCH-003 anchor revisit focused test should compile for headless runner")
	var save_path := "user://headless_runner_v026_contentbatch003_anchor_revisits.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.26 CONTENTBATCH-003 runner save should clear")
	var card_service = MemoryCardServiceScript.new(service)
	var anchor_service = AnchorInteractionServiceScript.new(service, card_service)
	_expect(anchor_service.is_loaded(), "V02.26 CONTENTBATCH-003 runner should load revisit data")
	_expect(anchor_service.get_all_stories().size() >= 12, "V02.26 CONTENTBATCH-003 runner should expose expanded revisit batch")
	for anchor_id in ["anchor_a_apple", "anchor_d_dog", "anchor_k_kite", "anchor_h_hat", "anchor_m_monkey", "anchor_u_umbrella"]:
		var story: Dictionary = anchor_service.get_story_for_anchor(anchor_id)
		_expect(not story.is_empty(), "V02.26 CONTENTBATCH-003 runner should resolve story: %s" % anchor_id)
		_expect(str(story.get("core_anchor_id", "")) == anchor_id, "V02.26 CONTENTBATCH-003 runner story should preserve anchor id: %s" % anchor_id)
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_003")
	root.add_child(main)
	main.call("_ready")
	_expect(main.move_player_to_cell(Vector2i(43, 8)).get("ok", false), "V02.26 CONTENTBATCH-003 runner should reach Hat ribbon anchor")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "anchor" and str(target.get("target_id", "")) == "anchor_h_hat", "V02.26 CONTENTBATCH-003 runner should prompt Hat anchor")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "anchor" and str(result.get("story", {}).get("word", "")) == "ribbon", "V02.26 CONTENTBATCH-003 runner should return ribbon story")
	_expect(main.save_service.clear_for_test(), "V02.26 CONTENTBATCH-003 runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v026_contentbatch004_look_events() -> void:
	_expect(V026Contentbatch004LookEventsTestScript != null, "V02.26 CONTENTBATCH-004 look events focused test should compile for headless runner")
	var save_path := "user://headless_runner_v026_contentbatch004_look_events.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.26 CONTENTBATCH-004 runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var path: Array[Dictionary] = [
		{"event_id": "homeschool_shop_front_window_001", "cell": Vector2i(42, 9), "stage": "shop_front", "text": "Hat", "cards": ["card_h_hat_core", "card_i_ice_cream_core", "card_o_orange_core"]},
		{"event_id": "homeschool_school_yard_chalk_flower_001", "cell": Vector2i(18, 14), "stage": "school_yard_extra", "text": "Yo-yo", "cards": ["card_n_net_core", "card_y_yo_yo_core", "card_r_robot_core"]},
	]
	for step in path:
		var event_id := str(step.get("event_id", ""))
		_expect(main.find_child(event_id, true, false) != null, "V02.26 CONTENTBATCH-004 runner hotspot should exist: %s" % event_id)
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.26 CONTENTBATCH-004 runner should reach event: %s" % event_id)
		_press_visible_button(interact_button, "V02.26 CONTENTBATCH-004 runner visible Interact should trigger: %s" % event_id)
		_expect(str(main.life_status_label.text).contains(str(step.get("text", ""))), "V02.26 CONTENTBATCH-004 runner feedback should be visible: %s" % event_id)
		var record: Dictionary = main.save_service.load_game_state().get("homeschool_events", {}).get(event_id, {})
		_expect(bool(record.get("seen", false)) and str(record.get("stage", "")) == str(step.get("stage", "")), "V02.26 CONTENTBATCH-004 runner event should persist: %s" % event_id)
		for card_id in step.get("cards", []):
			var card_state: Dictionary = main.memory_card_service.get_card_state(str(card_id))
			_expect(bool(card_state.get("collected", false)), "V02.26 CONTENTBATCH-004 runner card should be collected: %s" % card_id)
	_expect(main.move_player_to_cell(Vector2i(41, 11)).get("ok", false), "V02.26 CONTENTBATCH-004 runner should keep shop entry reachable")
	_press_visible_button(interact_button, "V02.26 CONTENTBATCH-004 runner visible Interact should still open shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.26 CONTENTBATCH-004 runner should keep shop panel available")
	_expect(main.save_service.clear_for_test(), "V02.26 CONTENTBATCH-004 runner save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v027_mapeditor_layers_inspector() -> void:
	_expect(V027MapeditorLayersInspectorTestScript != null, "V02.27 MAPEDITOR-002 layers inspector focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var summary: Dictionary = scene.call("get_tool_summary")
	_expect(bool(summary.get("has_toolbar", false)), "V02.27 MAPEDITOR-002 runner should expose toolbar")
	_expect(bool(summary.get("has_inspector", false)), "V02.27 MAPEDITOR-002 runner should expose inspector")
	_expect(scene.call("toggle_layer", "resource", false).get("ok", false), "V02.27 MAPEDITOR-002 runner should toggle resource layer")
	_expect(not bool(scene.call("get_tool_summary").get("layer_visibility", {}).get("resource", true)), "V02.27 MAPEDITOR-002 runner should report resource layer hidden")
	_expect(scene.call("select_marker", "resource", "resource_branch_bear_corner").get("ok", false), "V02.27 MAPEDITOR-002 runner should select resource marker")
	_expect(str(scene.call("get_inspector_summary").get("body", "")).contains("item_id"), "V02.27 MAPEDITOR-002 runner inspector should expose resource item_id")
	root.remove_child(scene)
	scene.queue_free()


func _check_v027_mapeditor_place_save() -> void:
	_expect(V027MapeditorPlaceSaveTestScript != null, "V02.27 MAPEDITOR-003 place save focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var moved: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "V02.27 MAPEDITOR-003 runner should move place candidate")
	var saved: Dictionary = scene.call("save_map_candidate", "user://headless_runner_v027_mapeditor_place_world_map.json")
	_expect(saved.get("ok", false), "V02.27 MAPEDITOR-003 runner should save map candidate: %s" % [saved.get("errors", [])])
	_cleanup_paths(["user://headless_runner_v027_mapeditor_place_world_map.json", "user://headless_runner_v027_mapeditor_place_world_map.json.tmp", "user://headless_runner_v027_mapeditor_place_world_map.json.bak"])
	root.remove_child(scene)
	scene.queue_free()


func _check_v027_mapeditor_cell_painting() -> void:
	_expect(V027MapeditorCellPaintingTestScript != null, "V02.27 MAPEDITOR-004 cell painting focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	_expect(scene.call("paint_cell_candidate", "road", Vector2i(2, 2), false).get("ok", false), "V02.27 MAPEDITOR-004 runner should paint road candidate")
	_expect(scene.call("paint_cell_candidate", "road", Vector2i(28, 16), false).get("reason", "") == "protected_cell", "V02.27 MAPEDITOR-004 runner should protect anchor cell")
	_expect(scene.call("validate_export_candidate").get("ok", false), "V02.27 MAPEDITOR-004 runner painted candidate should validate")
	root.remove_child(scene)
	scene.queue_free()


func _check_v027_mapeditor_resource_save() -> void:
	_expect(V027MapeditorResourceSaveTestScript != null, "V02.27 MAPEDITOR-005 resource save focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	_expect(scene.call("move_resource_marker_candidate", "resource_branch_bear_corner", Vector2i(1, 1)).get("ok", false), "V02.27 MAPEDITOR-005 runner should move resource candidate")
	var saved: Dictionary = scene.call("save_resources_candidate", "user://headless_runner_v027_mapeditor_resource_points.json")
	_expect(saved.get("ok", false), "V02.27 MAPEDITOR-005 runner should save resource candidate: %s" % [saved.get("errors", [])])
	_cleanup_paths(["user://headless_runner_v027_mapeditor_resource_points.json", "user://headless_runner_v027_mapeditor_resource_points.json.tmp", "user://headless_runner_v027_mapeditor_resource_points.json.bak"])
	root.remove_child(scene)
	scene.queue_free()


func _check_v027_mapeditor_npc_routine_save() -> void:
	_expect(V027MapeditorNPCRoutineSaveTestScript != null, "V02.27 MAPEDITOR-006 NPC routine save focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	_expect(scene.call("set_current_day_key", "local_day_002").get("ok", false), "V02.27 MAPEDITOR-006 runner should switch day")
	_expect(scene.call("move_npc_routine_candidate", "routine_mina_plaza_002", Vector2i(39, 22)).get("ok", false), "V02.27 MAPEDITOR-006 runner should move NPC routine candidate")
	var saved: Dictionary = scene.call("save_routines_candidate", "user://headless_runner_v027_mapeditor_npc_routines.json")
	_expect(saved.get("ok", false), "V02.27 MAPEDITOR-006 runner should save routine candidate: %s" % [saved.get("errors", [])])
	_cleanup_paths(["user://headless_runner_v027_mapeditor_npc_routines.json", "user://headless_runner_v027_mapeditor_npc_routines.json.tmp", "user://headless_runner_v027_mapeditor_npc_routines.json.bak"])
	root.remove_child(scene)
	scene.queue_free()


func _check_v027_mapeditor_anchor_migration_guard() -> void:
	_expect(V027MapeditorAnchorMigrationGuardTestScript != null, "V02.27 MAPEDITOR-007 anchor migration focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	_expect(scene.call("move_anchor_marker_candidate", "anchor_a_apple", Vector2i(6, 3)).get("reason", "") == "anchor_move_mode_required", "V02.27 MAPEDITOR-007 runner should require anchor move mode")
	_expect(scene.call("set_tool_mode", "move_anchor").get("ok", false), "V02.27 MAPEDITOR-007 runner should enter anchor move mode")
	_expect(scene.call("move_anchor_marker_candidate", "anchor_a_apple", Vector2i(6, 3)).get("ok", false), "V02.27 MAPEDITOR-007 runner should move anchor candidate")
	_expect(not scene.call("edit_anchor_field_candidate", "anchor_a_apple", "letter", "Q").get("ok", true), "V02.27 MAPEDITOR-007 runner should lock anchor letter")
	_expect(scene.call("validate_export_candidate").get("ok", false), "V02.27 MAPEDITOR-007 runner moved anchor candidate should validate")
	root.remove_child(scene)
	scene.queue_free()


func _check_v027_mapeditor_full_regression() -> void:
	_expect(V027MapeditorFullRegressionTestScript != null, "V02.27 MAPEDITOR full regression focused test should compile for headless runner")
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.27 MAPEDITOR full regression runner should still load runtime world_map")
	_expect(int(result.get("data", {}).get("memory_anchors", []).size()) == 26, "V02.27 MAPEDITOR full regression runner should preserve runtime 26 anchors")
	var resources: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH)
	var routines: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.NPC_ROUTINES_PATH)
	_expect(resources.get("ok", false) and (resources.get("data", {}) as Dictionary).get("resource_points", []).size() >= 7, "V02.27 MAPEDITOR full regression runner should load resource points")
	_expect(routines.get("ok", false) and (routines.get("data", {}) as Dictionary).get("routine_days", []).size() == 7, "V02.27 MAPEDITOR full regression runner should load routine days")


func _check_v027_mapeditor_usability_declutter() -> void:
	_expect(V027MapeditorUsabilityDeclutterTestScript != null, "V02.27 MAPEDITOR-008 usability focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var layout: Dictionary = scene.call("get_editor_layout_summary")
	var origin: Dictionary = layout.get("map_origin", {})
	var extent: Dictionary = layout.get("map_extent", {})
	_expect(int(origin.get("x", 0)) == 252 and int(origin.get("y", 0)) == 52, "V02.27 MAPEDITOR-009 runner should use left-rail map origin")
	_expect(int(extent.get("right", 9999)) <= 1268 and int(extent.get("bottom", 9999)) <= 708, "V02.27 MAPEDITOR-009 runner should keep full map inside 1280x720")
	_expect(str(layout.get("anchor_label", "")).length() <= 2, "V02.27 MAPEDITOR-008 runner should compact anchor marker labels")
	var anchor_visual: Dictionary = layout.get("anchor_visual", {})
	_expect(int(anchor_visual.get("font_size", 0)) >= 22, "V02.27 MAPEDITOR-010 runner should keep anchor letters readable")
	_expect(int(anchor_visual.get("z_index", 0)) >= 80, "V02.27 MAPEDITOR-010 runner should draw anchor letters above marker clutter")
	_expect(str(layout.get("resource_label", "")).length() <= 2, "V02.27 MAPEDITOR-008 runner should compact resource marker labels")
	_expect(str(layout.get("npc_label", "")).length() <= 2, "V02.27 MAPEDITOR-008 runner should compact NPC marker labels")
	root.remove_child(scene)
	scene.queue_free()


func _check_v027_mapeditor_direct_edit_drag() -> void:
	_expect(V027MapeditorDirectEditDragTestScript != null, "V02.27 MAPEDITOR-010 direct edit/drag focused test should compile for headless runner")
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	_expect(scene.call("select_marker", "place", "place_home").get("ok", false), "V02.27 MAPEDITOR-010 runner should select a place marker")
	var inspector: Dictionary = scene.call("get_inspector_summary")
	_expect(bool(inspector.get("has_apply_button", false)), "V02.27 MAPEDITOR-010 runner should expose inspector Apply")
	_expect(int(inspector.get("visible_input_count", 0)) >= 3, "V02.27 MAPEDITOR-010 runner should expose real inspector inputs")
	_expect(scene.call("apply_inspector_field_values", {"label": "Runner Direct Edit"}).get("ok", false), "V02.27 MAPEDITOR-010 runner should apply inspector edits")
	var drag_result: Dictionary = scene.call("commit_marker_drag_for_test", "place", "place_home", Vector2i(30, 17))
	_expect(drag_result.get("ok", false), "V02.27 MAPEDITOR-010 runner should commit marker drag through move validation: %s" % [drag_result.get("errors", [])])
	_expect(scene.call("commit_marker_drag_for_test", "anchor", "anchor_a_apple", Vector2i(6, 3)).get("reason", "") == "anchor_move_mode_required", "V02.27 MAPEDITOR-010 runner should keep A-Z move mode guard")
	_expect(scene.call("set_tool_mode", "move_anchor").get("ok", false), "V02.27 MAPEDITOR-010 runner should enter Move A-Z mode")
	_expect(scene.call("commit_marker_drag_for_test", "anchor", "anchor_a_apple", Vector2i(6, 3)).get("ok", false), "V02.27 MAPEDITOR-010 runner should commit A-Z drag in Move A-Z mode")
	_expect(scene.call("select_marker", "anchor", "anchor_a_apple").get("ok", false), "V02.27 MAPEDITOR-010 runner should select an anchor marker")
	inspector = scene.call("get_inspector_summary")
	_expect((inspector.get("editable_fields", []) as Array).has("cell_x"), "V02.27 MAPEDITOR-010 runner should expose anchor cell_x input")
	_expect((inspector.get("editable_fields", []) as Array).has("cell_y"), "V02.27 MAPEDITOR-010 runner should expose anchor cell_y input")
	_expect(scene.call("apply_inspector_field_values", {"cell_x": "6", "cell_y": "3"}).get("ok", false), "V02.27 MAPEDITOR-010 runner should apply anchor coordinate edits in Move A-Z mode")
	root.remove_child(scene)
	scene.queue_free()


func _check_v028_mapdogfood_production() -> void:
	_expect(V028MapdogfoodProductionTestScript != null, "V02.28 MAPDOGFOOD focused test should compile for headless runner")
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "V02.28 MAPDOGFOOD runner world map should load")
	var map_data: Dictionary = map_result.get("data", {})
	_expect(_has_place_at(map_data, "place_plaza_story_bench", "12,19"), "V02.28 MAPDOGFOOD runner should keep Story Bench dogfood place")
	_expect(_has_place_at(map_data, "place_shop_ribbon_corner", "49,12"), "V02.28 MAPDOGFOOD runner should keep Ribbon Corner dogfood place")
	_expect(_interaction_action_for_place(map_data, "place_plaza_story_bench") == "open_town_start", "V02.28 MAPDOGFOOD runner Story Bench should use supported action")
	_expect(_interaction_action_for_place(map_data, "place_shop_ribbon_corner") == "open_town_start", "V02.28 MAPDOGFOOD runner Ribbon Corner should use supported action")
	var resources: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.RESOURCE_POINTS_PATH).get("data", {})
	_expect(_resource_cell(resources, "resource_ribbon_shop_street") == "50,14", "V02.28 MAPDOGFOOD runner should keep ribbon resource dogfood cell")
	var routines: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.NPC_ROUTINES_PATH).get("data", {})
	_expect(_routine_cell(routines, "local_day_003", "routine_shopkeeper_shop_003") == "43,14", "V02.28 MAPDOGFOOD runner should keep shopkeeper routine dogfood cell")

	var save_path := "user://headless_runner_v028_mapdogfood.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.28 MAPDOGFOOD runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_003")
	root.add_child(main)
	main.call("_ready")
	_expect(main.move_player_to_cell(Vector2i(49, 13)).get("ok", false), "V02.28 MAPDOGFOOD runner should reach Ribbon Corner")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "place" and str(target.get("target_id", "")) == "interaction_place_shop_ribbon_corner_authoring", "V02.28 MAPDOGFOOD runner should prompt Ribbon Corner")
	var place_result: Dictionary = main.interact_nearby()
	_expect(str(place_result.get("interaction_type", "")) == "place_entry" and str(place_result.get("place_id", "")) == "place_shop_ribbon_corner", "V02.28 MAPDOGFOOD runner should enter Ribbon Corner")
	_expect(main.move_player_to_cell(Vector2i(50, 14)).get("ok", false), "V02.28 MAPDOGFOOD runner should reach moved ribbon resource")
	var resource_result: Dictionary = main.interact_nearby()
	_expect(str(resource_result.get("interaction_type", "")) == "resource" and str(resource_result.get("item_id", "")) == "ribbon", "V02.28 MAPDOGFOOD runner should collect moved ribbon")
	_expect(main.move_player_to_cell(Vector2i(43, 14)).get("ok", false), "V02.28 MAPDOGFOOD runner should reach moved shopkeeper routine")
	var npc_target: Dictionary = main.get_current_interaction_target()
	_expect(str(npc_target.get("type", "")) == "npc" and str(npc_target.get("target_id", "")) == "shopkeeper", "V02.28 MAPDOGFOOD runner should prompt shopkeeper at moved routine")
	_expect(main.save_service.clear_for_test(), "V02.28 MAPDOGFOOD runner save should clean")
	root.remove_child(main)
	main.queue_free()


func _check_v0234_artprod001_asset_integration() -> void:
	_expect(V0234Artprod001AssetIntegrationTestScript != null, "V02.34 ARTPROD-001 focused test should compile for headless runner")
	var theme_id := "theme_sunshine_town_placeholder"
	var required_assets := [
		{"category": "story_prop_assets", "asset_id": "story_prop.home.apple_welcome_photo"},
		{"category": "story_prop_assets", "asset_id": "story_prop.school.yard_net_robot_yoyo_corner"},
		{"category": "story_prop_assets", "asset_id": "story_prop.shop.hat_ribbon_window"},
		{"category": "story_prop_assets", "asset_id": "story_prop.plaza.bear_book_branch_bookmark"},
		{"category": "character_animation_assets", "asset_id": "anim_sheet.player.p0_motion"},
		{"category": "pet_animation_assets", "asset_id": "anim_sheet.pet.sunny.p0_motion"},
		{"category": "animation_metadata_assets", "asset_id": "anim_meta.player.p0_motion"},
		{"category": "animation_metadata_assets", "asset_id": "anim_meta.pet.sunny.p0_motion"},
		{"category": "ui_feedback_assets", "asset_id": "ui_feedback.prompt_soft_glow"},
		{"category": "ui_feedback_assets", "asset_id": "ui_feedback.collect_sparkle_soft"},
		{"category": "ui_feedback_assets", "asset_id": "ui_feedback.tap_ripple_soft"},
		{"category": "tile_edge_assets", "asset_id": "tile_edge.grass_path.soft"},
	]
	var records: Array = AssetResolverScript.get_asset_acceptance_records(theme_id)
	for spec in required_assets:
		var category := str(spec.get("category", ""))
		var asset_id := str(spec.get("asset_id", ""))
		var resolved: Dictionary = AssetResolverScript.resolve_asset(theme_id, category, asset_id)
		_expect(resolved.get("ok", false), "V02.34 ARTPROD-001 runner asset should resolve: %s" % asset_id)
		var asset_path := str(resolved.get("placeholder_path", ""))
		_expect(FileAccess.file_exists(asset_path), "V02.34 ARTPROD-001 runner asset path should exist: %s" % asset_path)
		if category != "animation_metadata_assets":
			var record: Dictionary = _asset_acceptance_record_for(records, asset_id)
			_expect(str(record.get("status", "")) == "production", "V02.34 ARTPROD-001 runner asset should be production: %s" % asset_id)
			_expect(str(record.get("viewport_evidence", "")) == "pending_1280_runtime_proof", "V02.34 ARTPROD-001 runner should keep runtime proof pending: %s" % asset_id)
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	var story_result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.STORY_PROPS_PATH)
	_expect(story_result.get("ok", false), "V02.34 ARTPROD-001 runner story_props.json should load")
	var story_errors: Array[String] = MapEditorSyncServiceScript.validate_story_props(story_result.get("data", {}), map_result.get("data", {}))
	_expect(story_errors.is_empty(), "V02.34 ARTPROD-001 runner story props should validate: %s" % [story_errors])
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	_expect(int(scene.call("build_from_world_map").get("story_prop_marker_count", 0)) >= 4, "V02.34 ARTPROD-001 runner Map Editor should keep exposing story prop markers")
	_expect(scene.call("select_marker", "story_prop", "story_prop_marker_home_apple_welcome_photo").get("ok", false), "V02.34 ARTPROD-001 runner should select story prop marker")
	var inspector: Dictionary = scene.call("get_inspector_summary")
	_expect((inspector.get("editable_fields", []) as Array).has("child_label"), "V02.34 ARTPROD-001 runner story prop inspector should expose child_label")
	root.remove_child(scene)
	scene.queue_free()


func _check_v0235_runtime_anim_controls() -> void:
	_expect(V0235RuntimeAnimControlsTestScript != null, "V02.35 RUNTIME-ANIM focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0235_runtime_anim_controls.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.35 runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var request: Dictionary = main.request_player_walk_to_cell(main.player_cell + Vector2i(1, 0))
	_expect(request.get("ok", false), "V02.35 runner should start a short walk")
	main.call("_advance_player_walk", 1.0 / 30.0)
	var moving_snapshot: Dictionary = main.get_runtime_motion_snapshot()
	var player: Dictionary = (moving_snapshot.get("stage", {}) as Dictionary).get("player", {})
	_expect(bool(player.get("uses_motion_sheet", false)), "V02.35 runner should use player motion sheet")
	_expect(bool(player.get("walking", false)), "V02.35 runner should report walking state")
	main.finish_player_walk_for_test()
	var prompt_walk: Dictionary = main.request_player_walk_to_cell(Vector2i(38, 22))
	_expect(prompt_walk.get("ok", false), "V02.35 runner should walk to Mina prompt")
	main.finish_player_walk_for_test()
	var prompt_snapshot: Dictionary = main.get_runtime_motion_snapshot()
	_expect(bool(prompt_snapshot.get("prompt_glow_visible", false)), "V02.35 runner should show prompt glow near target")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("show_tap_feedback_at_cell"), "V02.35 runner should expose tap feedback")
	if stage != null and stage.has_method("show_tap_feedback_at_cell"):
		stage.call("show_tap_feedback_at_cell", main.player_cell)
	var feedback_snapshot: Dictionary = main.get_runtime_motion_snapshot().get("stage", {})
	_expect(int(feedback_snapshot.get("tap_feedback_count", 0)) >= 1, "V02.35 runner should record tap feedback")
	_expect(service.clear_for_test(), "V02.35 runner save should clean")
	root.remove_child(main)
	main.queue_free()


func _check_v0236_storyslice001_runtime() -> void:
	_expect(V0236Storyslice001RuntimeTestScript != null, "V02.36 STORYSLICE-001 focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0236_storyslice001_runtime.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.36 runner save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")
	var render_snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(render_snapshot.get("story_prop_count", 0)) >= 4, "V02.36 runner should keep rendering first-batch P0 story props")
	_expect(main.inventory_service.collect_item("branch", 1).get("ok", false), "V02.36 runner should prepare branch resource context")
	for step in [
		{"story_prop_id": "story_prop_marker_home_apple_welcome_photo", "cell": Vector2i(8, 17)},
		{"story_prop_id": "story_prop_marker_plaza_bear_book_branch", "cell": Vector2i(13, 20)},
		{"story_prop_id": "story_prop_marker_school_yard_net_robot_yoyo", "cell": Vector2i(19, 17)},
		{"story_prop_id": "story_prop_marker_shop_hat_ribbon_window", "cell": Vector2i(50, 13)},
	]:
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.36 runner should move to story prop: %s" % step.get("story_prop_id", ""))
		var target: Dictionary = main.get_current_interaction_target()
		_expect(str(target.get("type", "")) == "story_prop", "V02.36 runner prompt should target story prop: %s" % step.get("story_prop_id", ""))
		var result: Dictionary = main.interact_nearby()
		_expect(result.get("ok", false), "V02.36 runner story prop should interact: %s" % step.get("story_prop_id", ""))
	var snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(snapshot.get("story_record_count", 0)) >= 4, "V02.36 runner should persist first-batch story prop records")
	_expect((snapshot.get("seen_anchor_ids", []) as Array).size() >= 6, "V02.36 runner should land at least six A-Z anchor records")
	var plaza_record: Dictionary = (snapshot.get("story_records", {}) as Dictionary).get("story_prop_marker_plaza_bear_book_branch", {})
	_expect(str(plaza_record.get("npc_id", "")) == "story_bear", "V02.36 runner plaza story prop should link Story Bear")
	_expect(str(plaza_record.get("resource_item_id", "")) == "branch", "V02.36 runner plaza story prop should link branch")
	_expect(int(plaza_record.get("resource_count", 0)) >= 1, "V02.36 runner plaza story prop should see branch inventory")
	_expect(service.clear_for_test(), "V02.36 runner save should clean")
	root.remove_child(main)
	main.queue_free()


func _check_v0237_storybatch002_content_pack() -> void:
	_expect(V0237Storybatch002ContentPackTestScript != null, "V02.37 STORYBATCH-002 content pack focused test should compile for headless runner")
	var path := "res://docs/collaboration/Round152_V02.37_STORYBATCH-002第二批story_prop与AZ回访内容包.md"
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "V02.37 runner should open STORYBATCH-002 content pack doc")
	if file == null:
		return
	var doc := file.get_as_text()
	for candidate_id in [
		"story_prop_candidate_home_clock_chair",
		"story_prop_candidate_home_sunny_towel_dog",
		"story_prop_candidate_home_watch_wall_charm",
		"story_prop_candidate_school_gate_bell",
		"story_prop_candidate_walk_kite_leaf",
		"story_prop_candidate_shop_orange_bowl",
		"story_prop_candidate_sun_flower_patch",
	]:
		_expect(doc.contains(candidate_id), "V02.37 runner should keep STORYBATCH-002 candidate: %s" % candidate_id)
	for anchor_id in ["anchor_c_clock", "anchor_d_dog", "anchor_w_watch", "anchor_g_gate", "anchor_k_kite", "anchor_o_orange", "anchor_s_sun"]:
		_expect(doc.contains(anchor_id), "V02.37 runner should keep STORYBATCH-002 anchor binding: %s" % anchor_id)
	_expect(doc.contains("不生成图片") and doc.contains("不改 runtime") and doc.contains("不写正式 JSON"), "V02.37 runner should keep STORYBATCH-002 planning-only boundary")
	_expect(doc.contains("/home/xionglei/GameProject/tools/image_generator.js"), "V02.37 runner should keep bitmap provenance handoff")


func _check_v0237_storybatch003_asset_integration() -> void:
	_expect(V0237Storybatch003AssetIntegrationTestScript != null, "V02.37 STORYBATCH-003 asset integration focused test should compile for headless runner")
	for asset_id in [
		"story_prop.home.clock_chair_corner",
		"story_prop.home.sunny_towel_dog_corner",
		"story_prop.home.watch_wall_charm",
		"story_prop.school.gate_bell_sign",
		"story_prop.walk.kite_leaf_path",
		"story_prop.shop.orange_bowl_window",
		"story_prop.plaza.sun_flower_patch",
	]:
		var resolved: Dictionary = AssetResolverScript.get_story_prop_asset(asset_id)
		_expect(resolved.get("ok", false), "V02.37 runner should resolve second-batch story prop asset: %s" % asset_id)
		_expect(FileAccess.file_exists(str(resolved.get("placeholder_path", ""))), "V02.37 runner should find second-batch story prop file: %s" % asset_id)
	var story_result: Dictionary = MapEditorSyncServiceScript.load_json_dictionary(MapEditorSyncServiceScript.STORY_PROPS_PATH)
	_expect(story_result.get("ok", false), "V02.37 runner should load second-batch story props")
	_expect((story_result.get("data", {}).get("story_props", []) as Array).size() == 11, "V02.37 runner should keep eleven story prop markers after second batch")


func _check_v0237_storybatch004_runtime_smoke() -> void:
	_expect(V0237Storybatch004RuntimeSmokeTestScript != null, "V02.37 STORYBATCH-004 runtime smoke focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0237_storybatch004_runtime_smoke.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.37 runner STORYBATCH-004 save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")
	var snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(snapshot.get("story_prop_count", 0)) == 11, "V02.37 runner should render eleven story props")
	var names: Array = snapshot.get("story_prop_names", [])
	for story_prop_id in [
		"story_prop_marker_home_clock_chair_corner",
		"story_prop_marker_home_sunny_towel_dog_corner",
		"story_prop_marker_home_watch_wall_charm",
		"story_prop_marker_school_gate_bell_sign",
		"story_prop_marker_walk_kite_leaf_path",
		"story_prop_marker_shop_orange_bowl_window",
		"story_prop_marker_sun_flower_patch",
	]:
		_expect(names.has(story_prop_id), "V02.37 runner should render second-batch story prop: %s" % story_prop_id)
	_expect(service.clear_for_test(), "V02.37 runner STORYBATCH-004 save should clean")
	root.remove_child(main)
	main.queue_free()


func _check_v0238_visual_recovery_runtime() -> void:
	_expect(V0238VisualRecoveryRuntimeTestScript != null, "V02.38 VISUALRECOVERY runtime focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0238_visual_recovery_runtime.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.38 runner visual recovery save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_visual_recovery_snapshot"), "V02.38 runner TownStage should expose visual recovery snapshot")
	if stage != null and stage.has_method("get_visual_recovery_snapshot"):
		var snapshot: Dictionary = stage.call("get_visual_recovery_snapshot")
		_expect(not bool(snapshot.get("uses_full_map_background", true)), "V02.38 runner should not use world_map_base_1280 as final runtime background")
		_expect(not bool(snapshot.get("has_legacy_ground_sprite", true)), "V02.38 runner should not create one legacy Ground sprite")
		_expect(int(snapshot.get("terrain_tile_count", 0)) >= 100, "V02.38 runner should render modular terrain tiles")
		_expect(int(snapshot.get("region_chunk_count", 0)) >= 4, "V02.38 runner should render region chunks")
		_expect(int(snapshot.get("building_prefab_count", 0)) >= 3, "V02.38 runner should render building prefabs")
		_expect(int(snapshot.get("world_prop_count", 0)) == 3, "V02.38 runner should render each first-screen recovery world prop once")
		_expect((snapshot.get("region_logical_ids", []) as Array).has("region.school_line.chunk"), "V02.38 runner should resolve School line chunk")
		_expect((snapshot.get("building_prefab_logical_ids", []) as Array).has("building.home.cottage"), "V02.38 runner should resolve Home prefab")
		_expect(float(snapshot.get("non_prefab_place_max_alpha", 1.0)) <= 0.22, "V02.38 runner non-prefab place markers should be denoised")
		_expect(float(snapshot.get("anchor_badge_max_alpha", 1.0)) <= 0.5, "V02.38 runner A-Z badge alpha should be denoised")
	_expect(main.move_player_to_cell(Vector2i(31, 19)).get("ok", false), "V02.38 runner Home entry cell should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.38 runner Home real entry should still work")
	_expect(bool(main.get_expapproval_home_snapshot().get("home_visible", false)), "V02.38 runner Home entry should show Home view")
	main.show_town_view()
	_expect(main.move_player_to_cell(Vector2i(41, 11)).get("ok", false), "V02.38 runner Shop entry cell should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.38 runner Shop real entry should still work")
	_expect(bool(main.get_expapproval_shop_settings_snapshot().get("shop_visible", false)), "V02.38 runner Shop entry should show Shop panel")
	main.show_town_view()
	_expect(main.move_player_to_cell(Vector2i(21, 12)).get("ok", false), "V02.38 runner School Gate look cell should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.38 runner School look interaction should still work")
	_expect(int(main.get_expapproval_school_snapshot().get("school_child_text_banned_count", -1)) == 0, "V02.38 runner School child-facing text should stay safe")
	_expect(service.clear_for_test(), "V02.38 runner visual recovery save should clean")
	root.remove_child(main)
	main.queue_free()


func _check_v0223_expapproval_shop_settings_glass() -> void:
	_expect(V0223ExpapprovalShopSettingsGlassTestScript != null, "V02.23 EXPAPPROVAL Shop / Settings glass focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0223_expapproval_shop_settings_glass.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.23 EXPAPPROVAL Shop / Settings save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	_expect(main.has_method("get_expapproval_shop_settings_snapshot"), "V02.23 EXPAPPROVAL runner should expose Shop / Settings snapshot")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.23 EXPAPPROVAL runner should reach Shop hotspot")
	_press_visible_button(main.find_child("InteractButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should open Shop from visible Interact")
	var shop_snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(shop_snapshot.get("shop_visible", false)), "V02.23 EXPAPPROVAL runner should keep Shop visible")
	_expect(int(shop_snapshot.get("shop_panel_size", {}).get("width", 0)) >= 390, "V02.23 EXPAPPROVAL runner should keep Shop panel wide")
	_expect(int(shop_snapshot.get("shop_min_touch_height", 0)) >= 46, "V02.23 EXPAPPROVAL runner should keep Shop buttons touchable")
	_expect(int(shop_snapshot.get("shop_child_text_banned_count", -1)) == 0, "V02.23 EXPAPPROVAL runner should keep Shop text child-facing")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 30
	_expect(main.save_service.save_game_state(game_state), "V02.23 EXPAPPROVAL runner should seed coins")
	main.open_shop_panel()
	_press_visible_button(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should keep visible Shop buy button")
	var after_purchase: Dictionary = main.save_service.load_game_state()
	_expect(int(after_purchase.get("inventory", {}).get("wooden_chair", 0)) == 1, "V02.23 EXPAPPROVAL runner should keep visible Shop purchase")
	_expect(int(after_purchase.get("coins", -1)) == 22, "V02.23 EXPAPPROVAL runner should keep Shop price deduction")
	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should open Settings from top button")
	var settings_snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(settings_snapshot.get("settings_visible", false)), "V02.23 EXPAPPROVAL runner should keep Settings visible")
	_expect(int(settings_snapshot.get("settings_panel_size", {}).get("width", 0)) >= 390, "V02.23 EXPAPPROVAL runner should keep Settings panel wide")
	_expect(int(settings_snapshot.get("settings_min_touch_height", 0)) >= 46, "V02.23 EXPAPPROVAL runner should keep Settings buttons touchable")
	_expect(int(settings_snapshot.get("settings_child_text_banned_count", -1)) == 0, "V02.23 EXPAPPROVAL runner should keep Settings text child-facing")
	_expect(not bool(settings_snapshot.get("settings_confirm_visible", true)), "V02.23 EXPAPPROVAL runner should hide rest confirm first")
	_press_visible_button(main.find_child("RequestRestButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should keep visible rest request")
	settings_snapshot = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(settings_snapshot.get("settings_confirm_visible", false)), "V02.23 EXPAPPROVAL runner should show confirm after rest request")
	_press_visible_button(main.find_child("SafePlaceButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should keep visible safe-place button")
	_expect(main.player_cell == Vector2i(31, 19), "V02.23 EXPAPPROVAL runner should return to safe place")
	_expect(main.save_service.clear_for_test(), "V02.23 EXPAPPROVAL Shop / Settings save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0223_expapproval_school_gate_yard_life_noise() -> void:
	_expect(V0223ExpapprovalSchoolGateYardLifeNoiseTestScript != null, "V02.23 EXPAPPROVAL School Gate / Yard focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0223_expapproval_school_gate_yard_life_noise.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.23 EXPAPPROVAL School save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	_expect(main.has_method("get_expapproval_school_snapshot"), "V02.23 EXPAPPROVAL runner should expose School snapshot")
	var snapshot: Dictionary = main.get_expapproval_school_snapshot()
	_expect(int(snapshot.get("school_gate_life_detail_count", 0)) >= 2, "V02.23 EXPAPPROVAL runner should keep School Gate life details")
	_expect(int(snapshot.get("school_yard_life_detail_count", 0)) >= 4, "V02.23 EXPAPPROVAL runner should keep School Yard life details")
	_expect(int(snapshot.get("anchor_count", 0)) == 26, "V02.23 EXPAPPROVAL runner should keep all A-Z anchors near School proof")
	_expect(int(snapshot.get("muted_school_line_badge_count", 0)) == int(snapshot.get("school_line_anchor_count", -1)), "V02.23 EXPAPPROVAL runner should keep School-line badges muted")
	_expect(int(snapshot.get("school_child_text_banned_count", -1)) == 0, "V02.23 EXPAPPROVAL runner should keep School text child-facing")
	_expect(main.request_player_walk_to_cell(Vector2i(21, 12)).get("ok", false), "V02.23 EXPAPPROVAL runner should walk to School Gate")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 EXPAPPROVAL runner should finish School Gate walk")
	snapshot = main.get_expapproval_school_snapshot()
	_expect(bool(snapshot.get("arrival_school_gate_visible", false)), "V02.23 EXPAPPROVAL runner should show School Gate arrival proof")
	_press_visible_button(main.find_child("InteractButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should trigger School Gate from visible Interact")
	_expect(main.request_player_walk_to_cell(Vector2i(19, 15)).get("ok", false), "V02.23 EXPAPPROVAL runner should walk to School Yard")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 EXPAPPROVAL runner should finish School Yard walk")
	snapshot = main.get_expapproval_school_snapshot()
	_expect(bool(snapshot.get("arrival_school_yard_visible", false)), "V02.23 EXPAPPROVAL runner should show School Yard arrival proof")
	_press_visible_button(main.find_child("InteractButton", true, false) as Button, "V02.23 EXPAPPROVAL runner should trigger School Yard from visible Interact")
	var state: Dictionary = main.save_service.load_game_state()
	_expect(state.get("homeschool_events", {}).has("homeschool_school_gate_hello_001"), "V02.23 EXPAPPROVAL runner should persist School Gate look")
	_expect(state.get("homeschool_events", {}).has("homeschool_school_yard_play_001"), "V02.23 EXPAPPROVAL runner should persist School Yard look")
	_expect(main.save_service.clear_for_test(), "V02.23 EXPAPPROVAL School save should clean up")
	root.remove_child(main)
	main.queue_free()


func _check_v0223_expapproval006_rc_smoke() -> void:
	_expect(V0223Expapproval006RCSmokeTestScript != null, "V02.23 EXPAPPROVAL-006 RC smoke focused test should compile for headless runner")
	var save_path := "user://headless_runner_v0223_expapproval006_rc_smoke.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.23 EXPAPPROVAL-006 RC smoke save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.23 EXPAPPROVAL-006 runner should expose TownStage snapshot")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var stage_snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(stage_snapshot.get("anchor_count", 0)) == 26, "V02.23 EXPAPPROVAL-006 runner should keep 26 A-Z anchors")
		_expect(int(stage_snapshot.get("muted_anchor_badge_count", 0)) == int(stage_snapshot.get("anchor_badge_count", -1)), "V02.23 EXPAPPROVAL-006 runner should keep anchor badges muted")
	main.show_home_view()
	_expect(main.has_method("get_expapproval_home_snapshot"), "V02.23 EXPAPPROVAL-006 runner should expose Home snapshot")
	var home_snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(int(home_snapshot.get("home_life_detail_count", 0)) >= 6, "V02.23 EXPAPPROVAL-006 runner should keep Home details")
	_press_visible_button(main.find_child("TownNavButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should return to Town")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.23 EXPAPPROVAL-006 runner should reach Shop hotspot")
	_press_visible_button(main.find_child("InteractButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should open Shop")
	var shop_snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(shop_snapshot.get("shop_visible", false)), "V02.23 EXPAPPROVAL-006 runner should show Shop")
	_press_visible_button(main.find_child("CloseShopButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should close Shop")
	_press_visible_button(main.find_child("BackpackNavButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should open Backpack")
	_press_visible_button(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should open Album")
	_expect((main.find_child("MemoryAlbumOverlay", true, false) as Control).visible, "V02.23 EXPAPPROVAL-006 runner should show Album")
	_press_visible_button(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should close Album")
	_press_visible_button(main.find_child("SettingsButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should open Settings")
	var settings_snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(settings_snapshot.get("settings_visible", false)), "V02.23 EXPAPPROVAL-006 runner should show Settings")
	_press_visible_button(main.find_child("CloseSettingsButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should close Settings")
	_expect(main.request_player_walk_to_cell(Vector2i(21, 12)).get("ok", false), "V02.23 EXPAPPROVAL-006 runner should walk to School Gate")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 EXPAPPROVAL-006 runner should finish School Gate walk")
	_press_visible_button(main.find_child("InteractButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should look at School Gate")
	_expect(main.request_player_walk_to_cell(Vector2i(19, 15)).get("ok", false), "V02.23 EXPAPPROVAL-006 runner should walk to School Yard")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 EXPAPPROVAL-006 runner should finish School Yard walk")
	_press_visible_button(main.find_child("InteractButton", true, false) as Button, "V02.23 EXPAPPROVAL-006 runner should look at School Yard")
	var school_snapshot: Dictionary = main.get_expapproval_school_snapshot()
	_expect(int(school_snapshot.get("school_child_text_banned_count", -1)) == 0, "V02.23 EXPAPPROVAL-006 runner should keep School text child-facing")
	_expect(main.save_service.clear_for_test(), "V02.23 EXPAPPROVAL-006 RC smoke save should clean up")
	root.remove_child(main)
	main.queue_free()


func _v0223_has_authoring_marker(scene: Node, runtime_type: String, stable_id: String) -> bool:
	for child in scene.find_children("*", "PanelContainer", true, false):
		if str(child.get("runtime_type")) == runtime_type and str(child.get("stable_id")) == stable_id:
			return true
	return false


func _arrival_proof_visible(main, node_name: String) -> bool:
	var panel := main.find_child("ArrivalProofPanel", true, false) as Control
	var label := main.find_child(node_name, true, false) as Label
	return panel != null and panel.visible and label != null and label.visible


func _v0218_best_look_cell(main, anchor_cell: Vector2i, anchor_id: String) -> Vector2i:
	var candidates: Array[Vector2i] = [
		anchor_cell,
		anchor_cell + Vector2i(1, 0),
		anchor_cell + Vector2i(-1, 0),
		anchor_cell + Vector2i(0, 1),
		anchor_cell + Vector2i(0, -1),
	]
	for candidate in candidates:
		if main.move_player_to_cell(candidate).get("ok", false):
			var nearest_anchor: Dictionary = main.call("_find_nearest_anchor", 1)
			if str(nearest_anchor.get("anchor_id", "")) == anchor_id:
				return candidate
	return anchor_cell


func _v0218_check_school_badge_spacing(anchors: Array) -> void:
	var badge_rects: Array[Dictionary] = []
	for anchor_value in anchors:
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var letter := str(anchor.get("letter", ""))
		if not ["G", "K", "N", "R", "S", "Y"].has(letter):
			continue
		var rect := _v0218_badge_rect_for_anchor(anchor)
		for existing in badge_rects:
			_expect(not _v0218_rects_are_too_close(rect, existing.get("rect", Rect2())), "V02.18 School line badges should not visually stack: %s near %s" % [letter, existing.get("letter", "")])
		badge_rects.append({"letter": letter, "rect": rect})


func _v0218_badge_rect_for_anchor(anchor: Dictionary) -> Rect2:
	var cell := _dict_to_cell(anchor.get("position", {}))
	var route_order := int(anchor.get("route_order", 1))
	var top_left := (Vector2(cell.x, cell.y) + Vector2(0.5, 0.5)) * 16.0 + _v0218_anchor_badge_offset(route_order, str(anchor.get("letter", "")))
	return Rect2(top_left, Vector2(28, 28))


func _v0218_anchor_badge_offset(route_order: int, letter: String = "") -> Vector2:
	var per_letter_offsets: Dictionary = {
		"A": Vector2(-42, -34),
		"B": Vector2(-38, -24),
		"C": Vector2(36, -40),
		"D": Vector2(-42, 8),
		"E": Vector2(-42, -20),
		"F": Vector2(10, -42),
		"G": Vector2(24, -28),
		"H": Vector2(-38, -20),
		"I": Vector2(18, -36),
		"J": Vector2(-34, 4),
		"K": Vector2(-42, -18),
		"L": Vector2(18, -28),
		"M": Vector2(-42, -8),
		"N": Vector2(-42, -12),
		"O": Vector2(20, -10),
		"P": Vector2(18, 8),
		"Q": Vector2(-42, 6),
		"R": Vector2(18, -34),
		"S": Vector2(46, -14),
		"T": Vector2(20, 4),
		"U": Vector2(12, -62),
		"V": Vector2(-42, 6),
		"W": Vector2(20, -8),
		"X": Vector2(18, 2),
		"Y": Vector2(-42, -8),
		"Z": Vector2(16, -38),
	}
	if per_letter_offsets.has(letter):
		return per_letter_offsets.get(letter)
	var offsets: Array[Vector2] = [
		Vector2(8, -31),
		Vector2(-31, -27),
		Vector2(10, 7),
		Vector2(-31, 5),
	]
	return offsets[(max(route_order, 1) - 1) % offsets.size()]


func _v0218_rects_are_too_close(a: Rect2, b: Rect2) -> bool:
	var padded := Rect2(a.position - Vector2(4, 4), a.size + Vector2(8, 8))
	return padded.intersects(b)


func _dict_to_cell(cell: Variant) -> Vector2i:
	if cell is Vector2i:
		return cell
	if cell is Dictionary:
		var dict: Dictionary = cell
		return Vector2i(int(dict.get("x", 0)), int(dict.get("y", 0)))
	return Vector2i.ZERO


func _v0218_screenshot_group_for_letter(letter: String) -> String:
	if ["A", "C", "D", "T", "W"].has(letter):
		return "home_anchors"
	if ["G", "K", "N", "R", "S", "Y"].has(letter):
		return "school_line"
	if ["B", "Q", "V", "H", "I", "J", "O"].has(letter):
		return "first_ring"
	if ["E", "F", "L", "M", "P", "Z"].has(letter):
		return "second_ring"
	if ["U", "X"].has(letter):
		return "far_edge"
	return "reserved"


func _v0218_layer_for_letter(letter: String) -> String:
	if ["A", "C", "D", "T", "W", "G", "K", "N", "R", "Y", "S"].has(letter):
		return "p0_center"
	if ["B", "Q", "V", "H", "I", "J", "O"].has(letter):
		return "first_ring"
	if ["E", "F", "L", "M", "P", "Z"].has(letter):
		return "second_ring"
	if ["U", "X"].has(letter):
		return "far_edge"
	return "reserved"


func _collect_visible_child_text(node: Node) -> String:
	if node is Control and not (node as Control).visible:
		return ""
	var text := ""
	if node is Label:
		text += (node as Label).text + "\n"
	elif node is Button:
		text += (node as Button).text + "\n"
	for child in node.get_children():
		text += _collect_visible_child_text(child)
	return text


func _script_path(node: Node) -> String:
	if node == null:
		return ""
	var script := node.get_script() as Script
	if script == null:
		return ""
	return script.resource_path


func _first_place_with_occupied_cells(places: Array) -> int:
	for index in range(places.size()):
		var place = places[index]
		if place is Dictionary and not (place as Dictionary).get("occupied_cells", []).is_empty():
			return index
	return 0


func _check_voice_ai_social_stubs() -> void:
	var voice = VoiceProviderAdapterScript.new()
	var voice_gate: Dictionary = voice.configure_provider(VoiceProviderAdapterScript.REAL_PROVIDER, false)
	_expect(not voice_gate.get("ok", true), "VoiceProviderAdapter should require privacy approval for real provider")
	var played: Dictionary = voice.play_line("voice_home_good_morning")
	_expect(played.get("ok", false), "VoiceProviderAdapter should play local stub line")
	_expect(not bool(played.get("network_used", true)), "VoiceProviderAdapter should not use network")
	_expect(not voice.request_recording("voice_home_good_morning").get("ok", true), "VoiceProviderAdapter should keep recording disabled")

	var ai = AINPCProviderAdapterScript.new()
	_expect(not ai.configure_provider("real_ai_provider_reserved", false).get("ok", true), "AINPCProviderAdapter should require privacy approval")
	var reply: Dictionary = ai.complete_npc_chat("mina", "hello", {})
	_expect(reply.get("ok", false), "AINPCProviderAdapter should return local NPC reply")
	_expect(not bool(reply.get("network_used", true)), "AINPCProviderAdapter should not use network")

	var visits = FriendVisitServiceScript.new()
	_expect(not visits.start_async_visit("unknown_friend").get("ok", true), "FriendVisitService should block unknown friends")
	_expect(visits.approve_local_friend({"friend_id": "friend_headless", "display_name": "Headless Friend"}, true).get("ok", false), "FriendVisitService should allow parent-approved local friend")
	_expect(visits.send_preset_phrase("friend_headless", "Hi!").get("ok", false), "FriendVisitService should allow preset phrase")
	_expect(not visits.send_preset_phrase("friend_headless", "come to my school").get("ok", true), "FriendVisitService should block free text")


func _cleanup_paths(paths: Array[String]) -> void:
	for path in paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
