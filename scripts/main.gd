extends Control

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const HomeDecorationServiceScript := preload("res://scripts/systems/home_decoration_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const DailyGreetingServiceScript := preload("res://scripts/systems/daily_greeting_service.gd")
const ResourceRefreshServiceScript := preload("res://scripts/systems/resource_refresh_service.gd")
const OutdoorDecorationServiceScript := preload("res://scripts/systems/outdoor_decoration_service.gd")
const NPCRoutineServiceScript := preload("res://scripts/systems/npc_routine_service.gd")
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")
const SchoolDayStateServiceScript := preload("res://scripts/systems/school_day_state_service.gd")
const AnchorInteractionServiceScript := preload("res://scripts/systems/anchor_interaction_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")
const MemoryAlbumScene := preload("res://scenes/memory_album/memory_album.tscn")
const TownStageScene := preload("res://scenes/world/town_stage.tscn")
const TownHUDScene := preload("res://scenes/world/ui/town_hud.tscn")
const TownFooterScene := preload("res://scenes/world/ui/town_footer.tscn")
const BackpackBubbleScene := preload("res://scenes/world/ui/backpack_bubble.tscn")
const SettingsPanelScene := preload("res://scenes/world/ui/settings_panel.tscn")
const ShopPanelScene := preload("res://scenes/world/ui/shop_panel.tscn")
const MemoryAlbumOverlayScene := preload("res://scenes/world/ui/memory_album_overlay.tscn")
const HomeRoomScene := preload("res://scenes/world/home/home_room.tscn")
const AZ_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const HOMESCHOOL_EVENTS_PATH := "res://data/life/homeschool_events.json"
const STORY_PROPS_PATH := "res://data/life/story_props.json"
const VIEWPORT_SIZE := Vector2i(1280, 720)
const BACKGROUND_COLOR := Color("#dff2d6")
const SURFACE_COLOR := Color("#fffdf4")
const PRIMARY_COLOR := Color("#3f7f62")
const ACCENT_COLOR := Color("#f3bf5b")
const ROAD_COLOR := Color("#dfc38a")
const PLACE_COLOR := Color("#fff7df")
const PLAYER_COLOR := Color("#5f8fd3")
const NPC_COLOR := Color("#c96f55")
const WATER_COLOR := Color("#a7d9df")
const FLOWER_COLOR := Color("#e6819b")
const MAP_CELL_SIZE := 16
const MAP_ORIGIN := Vector2.ZERO
const MAP_RENDER_SIZE := Vector2(1280, 720)
const LOCAL_CAMERA_SCALE := Vector2(2.05, 2.05)
const PLAYER_WALK_SPEED := 150.0
const TEXT_COLOR := Color("#1f2d2f")
const MUTED_TEXT_COLOR := Color("#5d6b6d")
const PLAYER_START_CELL := Vector2i(31, 19)
const INTERACTION_RADIUS := 2
const BRANCH_RESOURCE_CELL := Vector2i(13, 6)
const HOME_DECOR_CELL := Vector2i(2, 2)
const PARENT_ENTRY_SPEC := {
	"entry_id": "local_parent_gate",
	"child_flow_visible": false,
	"trigger": "reserved_settings_long_press",
	"hold_seconds": 3,
	"confirmation": "local_adult_confirmation_stub",
	"opens": "parent_dashboard_local_summary",
	"available_in_child_nav": false,
	"network_required": false,
	"account_required": false,
}
const FIRST_NPCS := [
	{
		"npc_id": "mina",
		"cell": {"x": 38, "y": 22},
	},
	{
		"npc_id": "shopkeeper",
		"cell": {"x": 43, "y": 12},
	},
	{
		"npc_id": "pet_buddy",
		"cell": {"x": 28, "y": 20},
	},
	{
		"npc_id": "bus_helper",
		"cell": {"x": 36, "y": 20},
	},
	{
		"npc_id": "story_bear",
		"cell": {"x": 16, "y": 18},
	},
]

var world_map: Dictionary = {}
var az_core_data: Dictionary = {}
var homeschool_events_by_id: Dictionary = {}
var story_props: Array = []
var map_errors: Array = []
var save_path_override := ""
var day_key_override := ""
var save_service
var memory_card_service
var minigame_service
var quest_event_service
var inventory_service
var life_shop_service
var home_decoration_service
var daily_request_service
var local_day_service
var daily_greeting_service
var resource_refresh_service
var outdoor_decoration_service
var npc_routine_service
var today_status_service
var school_day_state_service
var anchor_interaction_service
var npc_memory_store
var llm_client
var status_label: Label
var coin_label: Label
var pet_label: Label
var cards_label: Label
var life_status_label: Label
var optional_activity_label: Label
var backpack_bubble: Control
var backpack_summary_label: Label
var backpack_items_label: Label
var backpack_collection_label: Label
var settings_panel: Control
var settings_status_label: Label
var settings_exit_confirm_visible := false
var settings_sound_enabled := true
var memory_album_layer: Control
var shop_panel: Control
var shop_items_list: VBoxContainer
var shop_status_label: Label
var town_stage: Control
var home_room_layer: Control
var home_life_layer: Node2D
var home_furniture_layer: Node2D
var sunny_home_feedback_label: Label
var home_inventory_list: VBoxContainer
var home_action_status_label: Label
var home_selected_furniture_label: Label
var arrival_proof_panel: Control
var arrival_proof_labels: Dictionary = {}
var runtime_map_frame: Control
var runtime_map_input: Control
var runtime_map_node: Node2D
var interaction_prompt_label: Label
var interaction_prompt_glow: TextureRect
var player_marker: Node2D
var player_cell := PLAYER_START_CELL
var player_world_position := Vector2.ZERO
var player_facing := Vector2i(0, 1)
var player_walk_path: Array[Vector2i] = []
var player_walk_target_cell := PLAYER_START_CELL
var player_is_walking := false
var held_move_direction := Vector2i.ZERO
var held_move_cooldown := 0.0
var runtime_npcs: Array = []
var _texture_cache: Dictionary = {}
var _logical_asset_texture_keys: Dictionary = {
	"ground": {"category": "terrain_tile_assets", "asset_id": "terrain.grass.soft_tile"},
	"terrain_grass_tile": {"category": "terrain_tile_assets", "asset_id": "terrain.grass.soft_tile"},
	"terrain_path_tile": {"category": "terrain_tile_assets", "asset_id": "terrain.path.soft_tile"},
	"terrain_plaza_tile": {"category": "terrain_tile_assets", "asset_id": "terrain.plaza.warm_tile"},
	"terrain_grass_path_edge": {"category": "terrain_decal_assets", "asset_id": "terrain_decal.grass_path.soft_edge"},
	"region_home_edge_chunk": {"category": "region_chunk_assets", "asset_id": "region.home.edge_chunk"},
	"region_town_plaza_chunk": {"category": "region_chunk_assets", "asset_id": "region.town_plaza.chunk"},
	"region_shop_street_chunk": {"category": "region_chunk_assets", "asset_id": "region.shop_street.chunk"},
	"region_school_line_chunk": {"category": "region_chunk_assets", "asset_id": "region.school_line.chunk"},
	"building_prefab_home": {"category": "building_prefab_assets", "asset_id": "building.home.cottage"},
	"building_prefab_shop": {"category": "building_prefab_assets", "asset_id": "building.shop.market"},
	"building_prefab_school_gate": {"category": "building_prefab_assets", "asset_id": "building.school.gate"},
	"world_prop_apple_basket_anchor": {"category": "world_prop_assets", "asset_id": "world_prop.anchor.apple_basket"},
	"world_prop_clock_corner_anchor": {"category": "world_prop_assets", "asset_id": "world_prop.anchor.clock_corner"},
	"world_prop_sunny_corner": {"category": "world_prop_assets", "asset_id": "world_prop.home.sunny_corner"},
	"shadow": {"category": "soft_shadow_assets", "asset_id": "soft_shadow.oval.default"},
	"plaza": {"category": "terrain_tile_assets", "asset_id": "terrain.plaza.warm_tile"},
	"road": {"category": "terrain_tile_assets", "asset_id": "terrain.path.soft_tile"},
	"mapread_sun_scene_zone": {"category": "place_assets", "asset_id": "place.sun_scene.morning"},
	"mapread_home_yard_zone": {"category": "place_assets", "asset_id": "place.home.yard"},
	"mapread_home_school_walk_zone": {"category": "place_assets", "asset_id": "place.home_school_walk.day"},
	"mapread_school_gate_zone": {"category": "place_assets", "asset_id": "place.school_gate.exterior"},
	"mapread_school_yard_zone": {"category": "place_assets", "asset_id": "place.school_yard.day"},
	"mapread_story_culture_zone": {"category": "place_assets", "asset_id": "place.story_culture_bridge.day"},
	"mapread_shop_street_zone": {"category": "place_assets", "asset_id": "place.shop_street.day"},
	"mapread_animal_park_zone": {"category": "place_assets", "asset_id": "place.animal_park.day"},
	"mapread_coast_edge_zone": {"category": "place_assets", "asset_id": "place.coast_edge.day"},
	"place_place_sun_scene_body": {"category": "place_assets", "asset_id": "place.sun_scene.morning"},
	"place_place_home_body": {"category": "building_prefab_assets", "asset_id": "building.home.cottage"},
	"place_place_home_school_walk_body": {"category": "place_assets", "asset_id": "place.home_school_walk.day"},
	"place_place_school_gate_body": {"category": "building_prefab_assets", "asset_id": "building.school.gate"},
	"place_place_school_yard_body": {"category": "place_assets", "asset_id": "place.school_yard.day"},
	"place_place_town_start_body": {"category": "place_assets", "asset_id": "place.story_culture_bridge.day"},
	"place_place_supermarket_body": {"category": "building_prefab_assets", "asset_id": "building.shop.market"},
	"place_place_animal_park_body": {"category": "place_assets", "asset_id": "place.animal_park.day"},
	"place_place_coast_edge_body": {"category": "place_assets", "asset_id": "place.coast_edge.day"},
	"anchor_a_apple_tree": {"category": "anchor_assets", "asset_id": "anchor.a.apple_tree"},
	"anchor_b_bear_corner": {"category": "anchor_assets", "asset_id": "anchor.b.bear_corner"},
	"anchor_c_clock": {"category": "anchor_assets", "asset_id": "anchor.c.clock"},
	"anchor_d_dog_corner": {"category": "anchor_assets", "asset_id": "anchor.d.dog_corner"},
	"anchor_e_elephant_slide": {"category": "anchor_assets", "asset_id": "anchor.e.elephant_slide"},
	"anchor_f_fox_topiary": {"category": "anchor_assets", "asset_id": "anchor.f.fox_topiary"},
	"anchor_g_school_gate": {"category": "anchor_assets", "asset_id": "anchor.g.school_gate"},
	"anchor_h_hat_sign": {"category": "anchor_assets", "asset_id": "anchor.h.hat_sign"},
	"anchor_i_ice_cream_cart": {"category": "anchor_assets", "asset_id": "anchor.i.ice_cream_cart"},
	"anchor_j_jacket_window": {"category": "anchor_assets", "asset_id": "anchor.j.jacket_window"},
	"anchor_k_kite": {"category": "anchor_assets", "asset_id": "anchor.k.kite"},
	"anchor_l_lion_fountain": {"category": "anchor_assets", "asset_id": "anchor.l.lion_fountain"},
	"anchor_m_monkey_tree": {"category": "anchor_assets", "asset_id": "anchor.m.monkey_tree"},
	"anchor_n_soft_net": {"category": "anchor_assets", "asset_id": "anchor.n.soft_net"},
	"anchor_o_orange_stall": {"category": "anchor_assets", "asset_id": "anchor.o.orange_stall"},
	"anchor_p_panda_corner": {"category": "anchor_assets", "asset_id": "anchor.p.panda_corner"},
	"anchor_q_queen_poster": {"category": "anchor_assets", "asset_id": "anchor.q.queen_poster"},
	"anchor_r_robot_sign": {"category": "anchor_assets", "asset_id": "anchor.r.robot_sign"},
	"anchor_s_sun_landmark": {"category": "anchor_assets", "asset_id": "anchor.s.sun_landmark"},
	"anchor_t_taxi_marker": {"category": "anchor_assets", "asset_id": "anchor.t.taxi_marker"},
	"anchor_u_beach_umbrella": {"category": "anchor_assets", "asset_id": "anchor.u.beach_umbrella"},
	"anchor_v_violin_corner": {"category": "anchor_assets", "asset_id": "anchor.v.violin_corner"},
	"anchor_w_watch_table": {"category": "anchor_assets", "asset_id": "anchor.w.watch_table"},
	"anchor_x_x_mark_box": {"category": "anchor_assets", "asset_id": "anchor.x.x_mark_box"},
	"anchor_y_yo_yo_corner": {"category": "anchor_assets", "asset_id": "anchor.y.yo_yo_corner"},
	"anchor_z_zebra_edge": {"category": "anchor_assets", "asset_id": "anchor.z.zebra_edge"},
	"resource_branch": {"category": "place_assets", "asset_id": "place.resource.branch"},
	"player_body": {"category": "character_assets", "asset_id": "character.player.standing"},
	"npc_mina_body": {"category": "character_assets", "asset_id": "character.mina.standing"},
	"npc_shopkeeper_body": {"category": "character_assets", "asset_id": "character.shopkeeper.standing"},
	"npc_bus_helper_body": {"category": "character_assets", "asset_id": "character.bus_helper.standing"},
	"npc_story_bear_body": {"category": "character_assets", "asset_id": "character.story_bear.standing"},
	"npc_pet_buddy_body": {"category": "pet_assets", "asset_id": "pet.sunny.standing"},
	"home_item_small_table": {"category": "furniture_assets", "asset_id": "furniture.small_table.placed"},
	"home_item_pet_bowl": {"category": "furniture_assets", "asset_id": "furniture.pet_bowl.placed"},
	"home_item_sunny_bed": {"category": "furniture_assets", "asset_id": "furniture.sunny_bed.placed"},
	"ui_icon_coin": {"category": "ui_icon_assets", "asset_id": "ui_icon.coin"},
	"ui_icon_bag": {"category": "ui_icon_assets", "asset_id": "ui_icon.bag"},
	"ui_icon_shop": {"category": "ui_icon_assets", "asset_id": "ui_icon.shop"},
	"ui_icon_close": {"category": "ui_icon_assets", "asset_id": "ui_icon.close"},
	"ui_icon_settings": {"category": "ui_icon_assets", "asset_id": "ui_icon.settings"},
	"player_motion_sheet": {"category": "character_animation_assets", "asset_id": "anim_sheet.player.p0_motion"},
	"ui_feedback_prompt_glow": {"category": "ui_feedback_assets", "asset_id": "ui_feedback.prompt_soft_glow"},
	"ui_feedback_tap_ripple": {"category": "ui_feedback_assets", "asset_id": "ui_feedback.tap_ripple_soft"},
	"v0239_grass_patch": {"category": "terrain_tile_assets", "asset_id": "terrain.v0239.grass_patch"},
	"v0239_path_tile": {"category": "terrain_tile_assets", "asset_id": "terrain.v0239.path_tile"},
	"v0239_house_body": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_body"},
	"v0239_house_roof": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_roof"},
	"v0239_house_door": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_door"},
	"v0239_house_chimney": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_chimney"},
	"v0239_house_window": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_window"},
	"v0239_house_round_window": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_round_window"},
	"v0239_house_lantern": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_lantern"},
	"v0239_house_steps": {"category": "building_prefab_assets", "asset_id": "building_part.v0239.house_steps"},
	"v0239_tree_crown": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.tree_crown"},
	"v0239_tree_trunk": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.tree_trunk"},
	"v0239_flower_patch": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.flower_patch"},
	"v0239_fence": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.fence"},
	"v0239_garden_bed": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.garden_bed"},
	"v0239_pond_edge": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.pond_edge"},
	"v0239_grass_tuft": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.grass_tuft"},
	"v0239_path_pebble": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.path_pebble"},
	"v0239_bank_stone": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.bank_stone"},
	"v0239_lily_pad": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.lily_pad"},
	"v0239_crop_leaf": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.crop_leaf"},
	"v0239_flower_box": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.flower_box"},
	"v0239_mailbox": {"category": "world_prop_assets", "asset_id": "world_prop.v0239.mailbox"},
	"v0239_companion": {"category": "pet_assets", "asset_id": "pet.v0239.companion"},
	"v0239_companion_ear": {"category": "pet_assets", "asset_id": "pet.v0239.companion_ear"},
	"v0239_companion_tail": {"category": "pet_assets", "asset_id": "pet.v0239.companion_tail"},
	"v0239_companion_collar": {"category": "pet_assets", "asset_id": "pet.v0239.companion_collar"},
	"v0239_icon_look": {"category": "ui_icon_assets", "asset_id": "ui_icon.v0239.look"},
	"v0239_icon_map": {"category": "ui_icon_assets", "asset_id": "ui_icon.v0239.map"},
	"v0239_icon_home": {"category": "ui_icon_assets", "asset_id": "ui_icon.v0239.home"},
	"v0239_icon_album": {"category": "ui_icon_assets", "asset_id": "ui_icon.v0239.album"},
	"story_prop_story_prop_marker_home_apple_welcome_photo": {"category": "story_prop_assets", "asset_id": "story_prop.home.apple_welcome_photo"},
	"story_prop_story_prop_marker_school_yard_net_robot_yoyo": {"category": "story_prop_assets", "asset_id": "story_prop.school.yard_net_robot_yoyo_corner"},
	"story_prop_story_prop_marker_shop_hat_ribbon_window": {"category": "story_prop_assets", "asset_id": "story_prop.shop.hat_ribbon_window"},
	"story_prop_story_prop_marker_plaza_bear_book_branch": {"category": "story_prop_assets", "asset_id": "story_prop.plaza.bear_book_branch_bookmark"},
	"story_prop_story_prop_marker_home_clock_chair_corner": {"category": "story_prop_assets", "asset_id": "story_prop.home.clock_chair_corner"},
	"story_prop_story_prop_marker_home_sunny_towel_dog_corner": {"category": "story_prop_assets", "asset_id": "story_prop.home.sunny_towel_dog_corner"},
	"story_prop_story_prop_marker_home_watch_wall_charm": {"category": "story_prop_assets", "asset_id": "story_prop.home.watch_wall_charm"},
	"story_prop_story_prop_marker_school_gate_bell_sign": {"category": "story_prop_assets", "asset_id": "story_prop.school.gate_bell_sign"},
	"story_prop_story_prop_marker_walk_kite_leaf_path": {"category": "story_prop_assets", "asset_id": "story_prop.walk.kite_leaf_path"},
	"story_prop_story_prop_marker_shop_orange_bowl_window": {"category": "story_prop_assets", "asset_id": "story_prop.shop.orange_bowl_window"},
	"story_prop_story_prop_marker_sun_flower_patch": {"category": "story_prop_assets", "asset_id": "story_prop.plaza.sun_flower_patch"},
}


func _ready() -> void:
	name = "Main"
	custom_minimum_size = VIEWPORT_SIZE
	set_process(true)
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	world_map = result.get("data", {})
	az_core_data = _load_json(AZ_ANCHORS_PATH)
	homeschool_events_by_id = _load_homeschool_events()
	story_props = _load_story_props()
	map_errors = result.get("errors", [])
	_init_services()
	_build_shell()
	_update_loop_status("准备好啦")
	_update_today_status()


func _process(delta: float) -> void:
	_update_held_movement(delta)
	_advance_player_walk(delta)


func configure_for_test(save_path: String) -> void:
	save_path_override = save_path


func set_day_key_for_test(day_key: String) -> void:
	day_key_override = day_key
	if local_day_service != null:
		local_day_service.set_day_key_for_test(day_key)


func get_parent_entry_spec() -> Dictionary:
	return PARENT_ENTRY_SPEC.duplicate(true)


func _init_services() -> void:
	save_service = SaveServiceScript.new(save_path_override) if not save_path_override.is_empty() else SaveServiceScript.new()
	local_day_service = LocalDayServiceScript.new(day_key_override)
	memory_card_service = MemoryCardServiceScript.new(save_service)
	minigame_service = MinigameServiceScript.new(save_service, memory_card_service)
	quest_event_service = QuestEventServiceScript.new(save_service, memory_card_service)
	inventory_service = InventoryServiceScript.new(save_service)
	life_shop_service = LifeShopServiceScript.new(save_service, inventory_service)
	home_decoration_service = HomeDecorationServiceScript.new(save_service, inventory_service)
	daily_request_service = DailyRequestServiceScript.new(save_service, inventory_service, local_day_service)
	daily_greeting_service = DailyGreetingServiceScript.new(save_service, local_day_service)
	resource_refresh_service = ResourceRefreshServiceScript.new(save_service, inventory_service, local_day_service)
	outdoor_decoration_service = OutdoorDecorationServiceScript.new(save_service, inventory_service, world_map, resource_refresh_service.get_available_points(), FIRST_NPCS)
	today_status_service = TodayStatusServiceScript.new(local_day_service)
	npc_routine_service = NPCRoutineServiceScript.new(local_day_service, NPCRoutineServiceScript.ROUTINES_PATH, world_map)
	runtime_npcs = npc_routine_service.get_npcs_for_day(FIRST_NPCS)
	school_day_state_service = SchoolDayStateServiceScript.new(local_day_service)
	anchor_interaction_service = AnchorInteractionServiceScript.new(save_service, memory_card_service)
	npc_memory_store = NPCMemoryStoreScript.new(save_service)
	llm_client = LLMClientScript.new(npc_memory_store)


func _build_shell() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color("#dff2d6")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.name = "SafeArea"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 0)
	margin.add_theme_constant_override("margin_top", 0)
	margin.add_theme_constant_override("margin_right", 0)
	margin.add_theme_constant_override("margin_bottom", 0)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 0)
	margin.add_child(layout)

	layout.add_child(_create_body())


func _create_body() -> Control:
	var body := Control.new()
	body.name = "Body"
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var nav := VBoxContainer.new()
	nav.name = "Navigation"
	nav.visible = false
	nav.custom_minimum_size = Vector2(220, 0)
	nav.add_theme_constant_override("separation", 10)
	body.add_child(nav)

	var content := Control.new()
	content.name = "Content"
	content.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(content)

	town_stage = _create_map_canvas()
	town_stage.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.add_child(town_stage)

	home_room_layer = _create_home_room_view()
	home_room_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	home_room_layer.visible = false
	content.add_child(home_room_layer)

	var hud := _create_top_message_bar()
	hud.anchor_left = 0.02
	hud.anchor_top = 0.018
	hud.anchor_right = 0.98
	hud.anchor_bottom = 0.018
	hud.offset_bottom = 42
	content.add_child(hud)

	settings_panel = _create_settings_panel()
	settings_panel.anchor_left = 0.62
	settings_panel.anchor_top = 0.08
	settings_panel.anchor_right = 0.97
	settings_panel.anchor_bottom = 0.08
	settings_panel.offset_bottom = 292
	content.add_child(settings_panel)

	var footer := _create_bottom_action_bar()
	footer.anchor_left = 0.34
	footer.anchor_top = 1.0
	footer.anchor_right = 0.66
	footer.anchor_bottom = 1.0
	footer.offset_top = -82
	footer.offset_bottom = -22
	content.add_child(footer)

	backpack_bubble = _create_backpack_bubble()
	backpack_bubble.anchor_left = 0.58
	backpack_bubble.anchor_top = 1.0
	backpack_bubble.anchor_right = 0.94
	backpack_bubble.anchor_bottom = 1.0
	backpack_bubble.offset_top = -330
	backpack_bubble.offset_bottom = -92
	content.add_child(backpack_bubble)

	shop_panel = _create_shop_panel()
	shop_panel.anchor_left = 0.59
	shop_panel.anchor_top = 0.13
	shop_panel.anchor_right = 0.96
	shop_panel.anchor_bottom = 0.13
	shop_panel.offset_bottom = 382
	content.add_child(shop_panel)

	memory_album_layer = _create_memory_album_overlay()
	memory_album_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.add_child(memory_album_layer)

	var hint := Label.new()
	hint.name = "TownFooterText"
	hint.text = "散步靠近亮点时，按“看看”。"
	hint.anchor_left = 0.28
	hint.anchor_top = 1.0
	hint.anchor_right = 0.72
	hint.anchor_bottom = 1.0
	hint.offset_top = -116
	hint.offset_bottom = -96
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", Color("#24413a"))
	hint.add_theme_font_size_override("font_size", 13)
	content.add_child(hint)

	arrival_proof_panel = _create_arrival_proof_panel()
	arrival_proof_panel.anchor_left = 0.04
	arrival_proof_panel.anchor_top = 0.68
	arrival_proof_panel.anchor_right = 0.34
	arrival_proof_panel.anchor_bottom = 0.68
	arrival_proof_panel.offset_bottom = 126
	content.add_child(arrival_proof_panel)

	return body


func _create_top_message_bar() -> Control:
	var scene := TownHUDScene.instantiate() as Control
	scene.call("configure", self)
	return scene

	var panel := PanelContainer.new()
	panel.name = "TownHUD"
	panel.add_theme_stylebox_override("panel", _rounded_box(Color("#f7fbffd8"), 8, Color("#ffffff99")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 9)
	margin.add_child(row)

	var title := Label.new()
	title.name = "Title"
	title.text = "阳光小镇"
	title.custom_minimum_size = Vector2(106, 0)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 20)
	row.add_child(title)

	var town_status := Label.new()
	town_status.name = "Status"
	town_status.text = "开放" if map_errors.is_empty() else "照看中"
	town_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	town_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	town_status.custom_minimum_size = Vector2(62, 26)
	town_status.add_theme_color_override("font_color", Color.WHITE)
	town_status.add_theme_font_size_override("font_size", 12)
	town_status.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR, 8))
	row.add_child(town_status)

	life_status_label = Label.new()
	life_status_label.name = "LifeStatus"
	life_status_label.text = "今天适合慢慢散步。"
	life_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	life_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	life_status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	life_status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	life_status_label.add_theme_font_size_override("font_size", 13)
	row.add_child(life_status_label)

	status_label = Label.new()
	status_label.name = "LoopStatus"
	status_label.custom_minimum_size = Vector2(96, 0)
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	status_label.add_theme_font_size_override("font_size", 12)
	row.add_child(status_label)

	optional_activity_label = Label.new()
	optional_activity_label.name = "OptionalActivityStatus"
	optional_activity_label.text = "相册和 Letter Snake 是可以慢慢玩的收藏活动。"
	optional_activity_label.visible = false
	row.add_child(optional_activity_label)

	row.add_child(_create_asset_icon("CoinIcon", "ui_icon_coin", Vector2(26, 26)))

	coin_label = _create_hud_state_label("CoinState", 52, Color("#fff0bc"), Color("#d8a84b"))
	row.add_child(coin_label)

	pet_label = _create_hud_state_label("PetState", 104, Color("#eaf6ff"), Color("#93bfd0"))
	row.add_child(pet_label)

	row.add_child(_create_hud_settings_button())

	cards_label = Label.new()
	cards_label.name = "CardState"
	cards_label.visible = false
	cards_label.add_theme_color_override("font_color", TEXT_COLOR)
	row.add_child(cards_label)

	return panel


func _create_hud_settings_button() -> Button:
	var button := Button.new()
	button.name = "SettingsButton"
	button.text = ""
	button.custom_minimum_size = Vector2(38, 30)
	button.icon = _get_texture("ui_icon_settings")
	button.expand_icon = true
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_color_override("font_color", Color("#284238"))
	button.add_theme_stylebox_override("normal", _ui_skin_box("glass_icon_button", _rounded_box(Color("#f7fbffee"), 8, Color("#ffffffaa")), 22))
	button.add_theme_stylebox_override("hover", _ui_skin_box("glass_icon_button", _rounded_box(Color("#ffffffee"), 8, Color("#ffffffcc")), 22))
	button.add_theme_stylebox_override("pressed", _ui_skin_box("glass_button_pressed", _rounded_box(Color("#e9f2f7ee"), 8, Color("#cfdce5")), 22))
	button.pressed.connect(Callable(self, "_on_settings_pressed"))
	return button


func _create_bottom_action_bar() -> Control:
	var scene := TownFooterScene.instantiate() as Control
	scene.call("configure", self)
	return scene

	var bar := PanelContainer.new()
	bar.name = "TownFooter"
	bar.add_theme_stylebox_override("panel", _rounded_box(Color("#f7fbffd8"), 8, Color("#ffffff99")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	bar.add_child(margin)

	var row := HBoxContainer.new()
	row.name = "FooterVisibleActions"
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	margin.add_child(row)

	row.add_child(_create_footer_button("看看", true, "_on_interact_pressed", "InteractButton"))
	row.add_child(_create_footer_button("小镇", true, "_on_town_pressed", "TownNavButton"))
	row.add_child(_create_footer_button("小屋", false, "_on_home_pressed", "HomeNavButton"))
	var backpack_button := _create_footer_button("背包", false, "_on_backpack_pressed", "BackpackNavButton")
	backpack_button.icon = _get_texture("ui_icon_bag")
	backpack_button.expand_icon = true
	row.add_child(backpack_button)

	var contract_buttons := Control.new()
	contract_buttons.name = "FooterContractButtons"
	contract_buttons.visible = false
	bar.add_child(contract_buttons)
	contract_buttons.add_child(_create_action_button("开始", "_on_start_loop_pressed", "StartButton"))
	contract_buttons.add_child(_create_action_button("帮邻居", "_on_help_neighbor_pressed", "HelpNeighborButton"))
	contract_buttons.add_child(_create_action_button("买点心", "_on_buy_food_pressed", "BuyFoodButton"))
	contract_buttons.add_child(_create_action_button("喂 Sunny", "_on_feed_sunny_pressed", "FeedSunnyButton"))
	contract_buttons.add_child(_create_action_button("记忆相册", "_on_memory_album_pressed", "MemoryAlbumButton"))
	contract_buttons.add_child(_create_action_button("Letter Snake", "_on_optional_letter_snake_pressed", "LetterSnakeButton"))

	return bar


func _create_hud_state_label(node_name: String, min_width: int, fill: Color, border: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.custom_minimum_size = Vector2(min_width, 30)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.add_theme_color_override("font_color", TEXT_COLOR)
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_stylebox_override("normal", _rounded_box(fill, 8, border))
	return label


func _create_asset_icon(node_name: String, texture_key: String, icon_size: Vector2) -> TextureRect:
	var icon := TextureRect.new()
	icon.name = node_name
	icon.texture = _get_texture(texture_key)
	icon.custom_minimum_size = icon_size
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return icon


func _create_backpack_bubble() -> Control:
	var scene := BackpackBubbleScene.instantiate() as Control
	scene.call("configure", self)
	return scene

	var panel := PanelContainer.new()
	panel.name = "BackpackBubble"
	panel.visible = false
	panel.add_theme_stylebox_override("panel", _ui_skin_box("glass_panel_small", _rounded_box(Color("#f7fbfff0"), 16, Color("#ffffffaa")), 28))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var title := Label.new()
	title.name = "BackpackTitle"
	title.text = "小背包"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 18)
	stack.add_child(title)

	backpack_summary_label = Label.new()
	backpack_summary_label.name = "BackpackSummary"
	backpack_summary_label.add_theme_color_override("font_color", Color("#365047"))
	backpack_summary_label.add_theme_font_size_override("font_size", 14)
	stack.add_child(backpack_summary_label)

	backpack_items_label = Label.new()
	backpack_items_label.name = "BackpackItems"
	backpack_items_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	backpack_items_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	backpack_items_label.add_theme_font_size_override("font_size", 14)
	stack.add_child(backpack_items_label)

	backpack_collection_label = Label.new()
	backpack_collection_label.name = "BackpackCollection"
	backpack_collection_label.text = "收藏：相册、小游戏"
	backpack_collection_label.add_theme_color_override("font_color", Color("#775f2e"))
	backpack_collection_label.add_theme_font_size_override("font_size", 13)
	stack.add_child(backpack_collection_label)

	var collection_actions := HBoxContainer.new()
	collection_actions.name = "BackpackCollectionActions"
	collection_actions.add_theme_constant_override("separation", 8)
	stack.add_child(collection_actions)
	collection_actions.add_child(_create_bubble_button("相册", "_on_memory_album_pressed", "OpenMemoryAlbumButton"))
	collection_actions.add_child(_create_bubble_button("小游戏", "_on_optional_letter_snake_pressed", "OpenLetterSnakeButton"))

	return panel


func _create_settings_panel() -> Control:
	var scene := SettingsPanelScene.instantiate() as Control
	scene.call("configure", self)
	return scene

	var panel := PanelContainer.new()
	panel.name = "SettingsPanel"
	panel.visible = false
	panel.add_theme_stylebox_override("panel", _ui_skin_box("glass_panel_large", _rounded_box(Color("#f7fbfff0"), 16, Color("#ffffffaa")), 32))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.name = "SettingsStack"
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	stack.add_child(header)

	var title := Label.new()
	title.name = "SettingsTitle"
	title.text = "小镇设置"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 18)
	header.add_child(title)

	header.add_child(_create_bubble_button("收起", "_on_close_settings_pressed", "CloseSettingsButton", 70))

	settings_status_label = Label.new()
	settings_status_label.name = "SettingsStatus"
	settings_status_label.text = "可以先休息，也可以回到小镇安全位置。"
	settings_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	settings_status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	settings_status_label.add_theme_font_size_override("font_size", 13)
	stack.add_child(settings_status_label)

	var actions := HBoxContainer.new()
	actions.name = "SettingsActions"
	actions.add_theme_constant_override("separation", 8)
	stack.add_child(actions)
	actions.add_child(_create_bubble_button("声音开", "_on_toggle_sound_pressed", "SoundToggleButton", 86))
	actions.add_child(_create_bubble_button("回到小镇", "_on_safe_place_pressed", "SafePlaceButton", 96))

	var rest_actions := HBoxContainer.new()
	rest_actions.name = "SettingsRestActions"
	rest_actions.add_theme_constant_override("separation", 8)
	stack.add_child(rest_actions)
	rest_actions.add_child(_create_bubble_button("休息一下", "_on_request_rest_pressed", "RequestRestButton", 96))
	rest_actions.add_child(_create_bubble_button("继续逛", "_on_cancel_rest_pressed", "CancelRestButton", 86))
	rest_actions.add_child(_create_bubble_button("退出游戏", "_on_confirm_exit_pressed", "ConfirmExitButton", 96))

	return panel


func _create_shop_panel() -> Control:
	var scene := ShopPanelScene.instantiate() as Control
	scene.call("configure", self)
	return scene

	var panel := PanelContainer.new()
	panel.name = "ShopPanel"
	panel.visible = false
	panel.add_theme_stylebox_override("panel", _ui_skin_box("glass_panel_large", _rounded_box(Color("#f7fbfff0"), 16, Color("#ffffffaa")), 32))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.name = "ShopShelf"
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	stack.add_child(header)

	var title := Label.new()
	title.name = "ShopTitle"
	title.text = "街角商店"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 18)
	header.add_child(_create_asset_icon("ShopIcon", "ui_icon_shop", Vector2(30, 30)))
	header.add_child(title)

	header.add_child(_create_bubble_button("收起", "_on_close_shop_pressed", "CloseShopButton", 70))

	shop_status_label = Label.new()
	shop_status_label.name = "ShopStatus"
	shop_status_label.text = "货架上摆着小屋物件。"
	shop_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	shop_status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	shop_status_label.add_theme_font_size_override("font_size", 13)
	stack.add_child(shop_status_label)

	shop_items_list = VBoxContainer.new()
	shop_items_list.name = "ShopItemsList"
	shop_items_list.add_theme_constant_override("separation", 6)
	stack.add_child(shop_items_list)

	return panel


func _create_arrival_proof_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "ArrivalProofPanel"
	panel.visible = false
	panel.add_theme_stylebox_override("panel", _ui_skin_box("glass_panel_small", _rounded_box(Color("#f7fbffee"), 12, Color("#ffffffaa")), 22))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.name = "ArrivalProofStack"
	stack.add_theme_constant_override("separation", 6)
	margin.add_child(stack)

	for spec in [
		{"place_id": "place_supermarket", "node_name": "ArrivalProofShop", "text": "街角商店到了：店门和货架在旁边。"},
		{"place_id": "place_school_gate", "node_name": "ArrivalProofSchoolGate", "text": "校门到了：小铃轻响，hello。"},
		{"place_id": "place_school_yard", "node_name": "ArrivalProofSchoolYard", "text": "操场到了：风筝和玩具角在旁边。"},
	]:
		var label := Label.new()
		label.name = str(spec.get("node_name", "ArrivalProof"))
		label.text = str(spec.get("text", "到达小镇地点。"))
		label.visible = false
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.add_theme_color_override("font_color", TEXT_COLOR)
		label.add_theme_font_size_override("font_size", 13)
		stack.add_child(label)
		arrival_proof_labels[str(spec.get("place_id", ""))] = label

	return panel


func _create_memory_album_overlay() -> Control:
	var scene := MemoryAlbumOverlayScene.instantiate() as Control
	scene.call("configure", self)
	return scene

	var overlay := Control.new()
	overlay.name = "MemoryAlbumOverlay"
	overlay.visible = false
	overlay.z_index = 20

	var album := MemoryAlbumScene.instantiate()
	album.name = "MemoryAlbum"
	album.set_anchors_preset(Control.PRESET_FULL_RECT)
	if album.has_method("set_save_service"):
		album.call("set_save_service", save_service)
	overlay.add_child(album)
	if album.has_method("_ready"):
		album.call("_ready")

	var close_button := _create_bubble_button("返回", "_on_close_memory_album_pressed", "CloseMemoryAlbumButton", 86)
	close_button.anchor_left = 1.0
	close_button.anchor_top = 0.0
	close_button.anchor_right = 1.0
	close_button.anchor_bottom = 0.0
	close_button.offset_left = -122
	close_button.offset_top = 24
	close_button.offset_right = -28
	close_button.offset_bottom = 66
	overlay.add_child(close_button)

	return overlay


func _create_interaction_prompt_label() -> Label:
	var label := Label.new()
	label.name = "InteractionPrompt"
	label.anchor_left = 0.34
	label.anchor_top = 1.0
	label.anchor_right = 0.66
	label.anchor_bottom = 1.0
	label.offset_top = -154
	label.offset_bottom = -128
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override("font_color", Color("#24413a"))
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_stylebox_override("normal", _ui_skin_box("glass_panel_small", _rounded_box(Color("#f7fbffee"), 12, Color("#ffffffaa")), 22))
	return label


func _create_interaction_prompt_glow() -> TextureRect:
	var glow := TextureRect.new()
	glow.name = "InteractionPromptGlow"
	glow.anchor_left = 0.315
	glow.anchor_top = 1.0
	glow.anchor_right = 0.685
	glow.anchor_bottom = 1.0
	glow.offset_top = -164
	glow.offset_bottom = -118
	glow.texture = _get_texture("ui_feedback_prompt_glow")
	glow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	glow.stretch_mode = TextureRect.STRETCH_SCALE
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glow.modulate = Color(1, 1, 1, 0.68)
	glow.visible = false
	return glow


func _create_home_room_view() -> Control:
	var scene := HomeRoomScene.instantiate() as Control
	scene.call("configure", self)
	return scene

	var room := Control.new()
	room.name = "HomeRoom"

	var background := ColorRect.new()
	background.name = "HomeRoomBackground"
	background.color = Color("#f5e4bf")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	room.add_child(background)

	var room_stage := Node2D.new()
	room_stage.name = "HomeRoomStage"
	room_stage.position = Vector2(250, 95)
	room.add_child(room_stage)

	room_stage.add_child(_create_sprite("HomeFloor", Vector2(210, 155), Vector2(420, 310), "home_floor"))
	room_stage.add_child(_create_sprite("HomeBackWall", Vector2(210, 38), Vector2(420, 76), "home_wall"))
	_add_home_living_room_details(room_stage)

	home_furniture_layer = Node2D.new()
	home_furniture_layer.name = "HomeFurnitureLayer"
	room_stage.add_child(home_furniture_layer)

	var sunny := Node2D.new()
	sunny.name = "HomeSunny"
	sunny.position = Vector2(400, 235)
	sunny.add_child(_create_sprite("Shadow", Vector2(0, 17), Vector2(30, 9), "shadow"))
	sunny.add_child(_create_sprite("Body", Vector2(0, 5), Vector2(30, 30), "npc_pet_buddy_body"))
	sunny.add_child(_create_sprite("Head", Vector2(0, -16), Vector2(28, 24), "npc_pet_buddy_head"))
	room_stage.add_child(sunny)

	var feedback_panel := PanelContainer.new()
	feedback_panel.name = "SunnyHomeFeedbackPanel"
	feedback_panel.anchor_left = 0.08
	feedback_panel.anchor_top = 0.12
	feedback_panel.anchor_right = 0.38
	feedback_panel.anchor_bottom = 0.12
	feedback_panel.offset_bottom = 68
	feedback_panel.add_theme_stylebox_override("panel", _ui_skin_box("glass_panel_small", _rounded_box(Color("#f7fbffee"), 14, Color("#ffffffaa")), 28))
	room.add_child(feedback_panel)

	var feedback_margin := MarginContainer.new()
	feedback_margin.add_theme_constant_override("margin_left", 14)
	feedback_margin.add_theme_constant_override("margin_top", 10)
	feedback_margin.add_theme_constant_override("margin_right", 14)
	feedback_margin.add_theme_constant_override("margin_bottom", 10)
	feedback_panel.add_child(feedback_margin)

	sunny_home_feedback_label = Label.new()
	sunny_home_feedback_label.name = "SunnyHomeFeedback"
	sunny_home_feedback_label.text = "Sunny 在小屋里慢慢摇尾巴。"
	sunny_home_feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sunny_home_feedback_label.add_theme_color_override("font_color", TEXT_COLOR)
	sunny_home_feedback_label.add_theme_font_size_override("font_size", 15)
	feedback_margin.add_child(sunny_home_feedback_label)

	var action_panel := _create_home_action_panel()
	action_panel.anchor_left = 0.68
	action_panel.anchor_top = 0.14
	action_panel.anchor_right = 0.94
	action_panel.anchor_bottom = 0.14
	action_panel.offset_bottom = 250
	room.add_child(action_panel)

	return room


func _add_home_living_room_details(room_stage: Node2D) -> void:
	var sunlight := _create_sprite("HomeSunlightPatch", Vector2(150, 172), Vector2(170, 92), "home_sunlight_patch")
	sunlight.modulate = Color(1, 1, 1, 0.64)
	room_stage.add_child(sunlight)
	room_stage.add_child(_create_sprite("HomeWindow", Vector2(116, 36), Vector2(86, 44), "home_window"))
	room_stage.add_child(_create_sprite("HomeWallClock", Vector2(216, 38), Vector2(38, 38), "home_wall_clock"))
	room_stage.add_child(_create_sprite("HomeShelf", Vector2(312, 42), Vector2(92, 30), "home_shelf"))
	room_stage.add_child(_create_sprite("HomeWelcomeMat", Vector2(70, 250), Vector2(78, 36), "home_welcome_mat"))
	room_stage.add_child(_create_sprite("HomePetCornerBase", Vector2(372, 252), Vector2(96, 54), "home_pet_corner"))
	for x in range(6):
		for y in range(5):
			var tile := _create_sprite("HomeGridCell", Vector2(70 + x * 56, 78 + y * 48), Vector2(42, 34), "home_grid_cell")
			tile.modulate = Color(1, 1, 1, 0.22)
			room_stage.add_child(tile)


func _create_home_action_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "HomeActionPanel"
	panel.add_theme_stylebox_override("panel", _ui_skin_box("glass_panel_large", _rounded_box(Color("#f7fbfff0"), 16, Color("#ffffffaa")), 32))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.name = "HomeActionStack"
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var title := Label.new()
	title.name = "HomeActionTitle"
	title.text = "小屋物件"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 18)
	stack.add_child(title)

	home_action_status_label = Label.new()
	home_action_status_label.name = "HomeActionStatus"
	home_action_status_label.text = "背包里的家具会出现在这里。"
	home_action_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	home_action_status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	home_action_status_label.add_theme_font_size_override("font_size", 13)
	stack.add_child(home_action_status_label)

	home_selected_furniture_label = Label.new()
	home_selected_furniture_label.name = "HomeSelectedFurnitureLabel"
	home_selected_furniture_label.text = "当前小角落：还没摆家具。"
	home_selected_furniture_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	home_selected_furniture_label.add_theme_color_override("font_color", TEXT_COLOR)
	home_selected_furniture_label.add_theme_font_size_override("font_size", 13)
	home_selected_furniture_label.add_theme_stylebox_override("normal", _ui_skin_box("glass_panel_small", _rounded_box(Color("#fff8d9dd"), 10, Color("#ffffff99")), 20))
	stack.add_child(home_selected_furniture_label)

	home_inventory_list = VBoxContainer.new()
	home_inventory_list.name = "HomeInventoryList"
	home_inventory_list.add_theme_constant_override("separation", 6)
	stack.add_child(home_inventory_list)

	var row := HBoxContainer.new()
	row.name = "HomePlacedActions"
	row.add_theme_constant_override("separation", 8)
	stack.add_child(row)
	row.add_child(_create_bubble_button("旋转", "_on_home_rotate_pressed", "HomeRotateFirstFurnitureButton", 72))
	row.add_child(_create_bubble_button("挪动", "_on_home_move_pressed", "HomeMoveFirstFurnitureButton", 72))
	row.add_child(_create_bubble_button("收起", "_on_home_pickup_pressed", "HomePickupFirstFurnitureButton", 72))

	return panel


func _refresh_home_room() -> void:
	if not is_instance_valid(home_furniture_layer):
		return
	for child in home_furniture_layer.get_children():
		home_furniture_layer.remove_child(child)
		child.queue_free()
	for record in home_decoration_service.get_home_state().get("placed_furniture", []):
		if not record is Dictionary:
			continue
		var furniture: Dictionary = record
		var node := Node2D.new()
		node.name = "home_furniture_%s" % str(furniture.get("instance_id", "item"))
		var cell: Vector2i = _dict_to_cell(furniture.get("cell", {}))
		var size_data: Dictionary = furniture.get("size", {"w": 1, "h": 1})
		var width: int = max(1, int(size_data.get("w", 1)))
		var height: int = max(1, int(size_data.get("h", 1)))
		node.position = Vector2(70 + cell.x * 56 + (width - 1) * 28, 78 + cell.y * 48 + (height - 1) * 24)
		node.add_child(_create_sprite("FurnitureShadow", Vector2(0, 16 + height * 4), Vector2(width * 44, 9), "shadow"))
		node.add_child(_create_sprite("FurnitureSprite", Vector2.ZERO, Vector2(width * 48, height * 40), "home_item_%s" % str(furniture.get("item_id", "furniture"))))
		var label := Label.new()
		label.name = "FurnitureNameLabel"
		label.text = _item_display_name(inventory_service.get_item(str(furniture.get("item_id", ""))))
		label.position = Vector2(-38, 24 + height * 10)
		label.size = Vector2(76, 20)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		label.add_theme_color_override("font_color", Color("#3d4b43"))
		label.add_theme_font_size_override("font_size", 11)
		label.add_theme_stylebox_override("normal", _rounded_box(Color("#fffdf4cc"), 6, Color("#ffffffaa")))
		node.add_child(label)
		home_furniture_layer.add_child(node)
	var feedback: Dictionary = home_decoration_service.get_sunny_feedback()
	if is_instance_valid(sunny_home_feedback_label):
		sunny_home_feedback_label.text = str(feedback.get("text", "Sunny 在小屋里慢慢摇尾巴。"))
	_refresh_home_actions()
	_update_backpack_bubble()


func _refresh_home_actions() -> void:
	if not is_instance_valid(home_inventory_list):
		return
	for child in home_inventory_list.get_children():
		home_inventory_list.remove_child(child)
		child.queue_free()

	var inventory: Dictionary = inventory_service.get_inventory()
	var added := 0
	for item_id in _furniture_item_ids():
		var count := int(inventory.get(item_id, 0))
		if count <= 0:
			continue
		var item: Dictionary = inventory_service.get_item(item_id)
		var label := "摆放 %s x%s" % [_item_display_name(item), count]
		var button := _create_bubble_button(label, "", _button_name_from_item("HomePlace", item_id), 160)
		button.pressed.connect(Callable(self, "_on_home_place_item_pressed").bind(item_id))
		home_inventory_list.add_child(button)
		added += 1

	if added == 0:
		var empty := Label.new()
		empty.name = "HomeInventoryEmpty"
		empty.text = "还没有可摆放的家具。"
		empty.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
		empty.add_theme_font_size_override("font_size", 13)
		home_inventory_list.add_child(empty)

	var placed: Array = home_decoration_service.get_home_state().get("placed_furniture", [])
	var has_placed := not placed.is_empty()
	var rotate_button := find_child("HomeRotateFirstFurnitureButton", true, false) as Button
	var move_button := find_child("HomeMoveFirstFurnitureButton", true, false) as Button
	var pickup_button := find_child("HomePickupFirstFurnitureButton", true, false) as Button
	if rotate_button != null:
		rotate_button.disabled = not has_placed
	if move_button != null:
		move_button.disabled = not has_placed
	if pickup_button != null:
		pickup_button.disabled = not has_placed
	if is_instance_valid(home_action_status_label):
		home_action_status_label.text = "已摆放 %s 件。Sunny 会在旁边看你慢慢整理。" % placed.size() if has_placed else "背包里的家具会出现在这里，小屋的小角落已经很暖。"
	if is_instance_valid(home_selected_furniture_label):
		home_selected_furniture_label.text = _home_selected_furniture_text(placed)


func _on_home_place_item_pressed(item_id: String) -> void:
	var result: Dictionary = place_home_item(item_id, _next_home_cell_for_item(item_id))
	var item: Dictionary = inventory_service.get_item(item_id)
	if result.get("ok", false):
		_set_life_status("把%s放进小屋啦。" % _item_display_name(item))
	elif is_instance_valid(home_action_status_label):
		home_action_status_label.text = _home_error_text(str(result.get("reason", "")))


func _on_home_rotate_pressed() -> void:
	var instance_id := _first_placed_instance_id()
	if instance_id.is_empty():
		_set_life_status("还没有可以旋转的家具。")
		return
	rotate_home_item(instance_id)


func _on_home_move_pressed() -> void:
	var instance_id := _first_placed_instance_id()
	if instance_id.is_empty():
		_set_life_status("还没有可以挪动的家具。")
		return
	var placed: Array = home_decoration_service.get_home_state().get("placed_furniture", [])
	var current_cell := Vector2i.ZERO
	for record in placed:
		if record is Dictionary and str(record.get("instance_id", "")) == instance_id:
			current_cell = _dict_to_cell((record as Dictionary).get("cell", {}))
			break
	var next_cell := Vector2i((current_cell.x + 1) % 4, min(current_cell.y + 1, 3))
	move_home_item(instance_id, next_cell)


func _on_home_pickup_pressed() -> void:
	var instance_id := _first_placed_instance_id()
	if instance_id.is_empty():
		_set_life_status("还没有可以收起的家具。")
		return
	pickup_home_item(instance_id)


func _first_placed_instance_id() -> String:
	var placed: Array = home_decoration_service.get_home_state().get("placed_furniture", [])
	if placed.is_empty() or not placed[0] is Dictionary:
		return ""
	return str((placed[0] as Dictionary).get("instance_id", ""))


func _home_selected_furniture_text(placed: Array) -> String:
	if placed.is_empty() or not placed[0] is Dictionary:
		return "当前小角落：还没摆家具，Sunny 的小毯子和故事书先陪着你。"
	var furniture: Dictionary = placed[0]
	var item: Dictionary = inventory_service.get_item(str(furniture.get("item_id", "")))
	var cell := _dict_to_cell(furniture.get("cell", {}))
	return "当前小角落：%s在%s，可以旋转、挪动或收起。" % [_item_display_name(item), _home_corner_label(cell)]


func _home_corner_label(cell: Vector2i) -> String:
	var horizontal := "中间"
	if cell.x <= 1:
		horizontal = "左边"
	elif cell.x >= 4:
		horizontal = "右边"
	var vertical := "中间"
	if cell.y <= 1:
		vertical = "靠墙"
	elif cell.y >= 3:
		vertical = "靠前"
	if horizontal == "中间" and vertical == "中间":
		return "房间中间"
	return "%s%s" % [horizontal if horizontal != "中间" else "", vertical if vertical != "中间" else ""]


func _next_home_cell_for_item(item_id: String) -> Vector2i:
	for y in range(5):
		for x in range(6):
			var cell := Vector2i(x, y)
			var validation: Dictionary = home_decoration_service.validate_placement(item_id, cell)
			if validation.get("ok", false):
				return cell
	return HOME_DECOR_CELL


func _home_error_text(reason: String) -> String:
	match reason:
		"invalid_cell":
			return "这里放不下，换个更宽的小角落吧。"
		"occupied":
			return "这里已经有家具啦，挪一挪再试试。"
		"not_enough_items":
			return "背包里还没有这个家具。"
		_:
			return "小屋还没准备好这个动作。"


func _create_action_button(label: String, method_name: String, node_name: String = "") -> Button:
	var button := Button.new()
	button.name = node_name if not node_name.is_empty() else label.replace(" ", "") + "Button"
	button.text = label
	button.custom_minimum_size = Vector2(112, 38)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_color_override("font_color", Color("#284238"))
	button.add_theme_stylebox_override("normal", _ui_skin_box("glass_button_normal", _rounded_box(PRIMARY_COLOR, 8), 24))
	button.add_theme_stylebox_override("hover", _ui_skin_box("glass_button_normal", _rounded_box(PRIMARY_COLOR.lightened(0.08), 8), 24))
	button.add_theme_stylebox_override("pressed", _ui_skin_box("glass_button_pressed", _rounded_box(PRIMARY_COLOR.darkened(0.08), 8), 24))
	button.pressed.connect(Callable(self, method_name))
	return button


func _create_footer_button(label: String, selected: bool, method_name: String = "", node_name: String = "") -> Button:
	var button := Button.new()
	button.name = node_name if not node_name.is_empty() else label.replace(" ", "") + "FooterButton"
	button.text = label
	button.custom_minimum_size = Vector2(84, 40)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color("#27443b") if selected else Color("#46584f"))
	var normal_color := Color("#f7fbffee") if selected else Color("#ffffffdc")
	var hover_color := Color("#ffffffee") if selected else Color("#f7fbffee")
	var pressed_color := Color("#e8f0f6ee") if selected else Color("#e8f0f6dd")
	var border_color := Color("#ffffffcc") if selected else Color("#dfeaf2bb")
	button.add_theme_stylebox_override("normal", _rounded_box(normal_color, 8, border_color))
	button.add_theme_stylebox_override("hover", _rounded_box(hover_color, 8, border_color.lightened(0.08)))
	button.add_theme_stylebox_override("pressed", _rounded_box(pressed_color, 8, border_color.darkened(0.08)))
	button.add_theme_stylebox_override("focus", _rounded_box(Color("#ffffffee"), 8, Color("#b9d8e8")))
	if not method_name.is_empty():
		button.pressed.connect(Callable(self, method_name))
	return button


func _create_bubble_button(label: String, method_name: String, node_name: String, min_width: int = 96) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = label
	button.custom_minimum_size = Vector2(min_width, 34)
	if node_name.begins_with("Close") or node_name == "CancelRestButton":
		button.icon = _get_texture("ui_icon_close")
		button.expand_icon = true
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 14)
	button.add_theme_color_override("font_color", Color("#284238"))
	button.add_theme_stylebox_override("normal", _ui_skin_box("glass_button_normal", _rounded_box(Color("#f7fbffee"), 12, Color("#ffffffaa")), 24))
	button.add_theme_stylebox_override("hover", _ui_skin_box("glass_button_normal", _rounded_box(Color("#ffffffee"), 12, Color("#ffffffcc")), 24))
	button.add_theme_stylebox_override("pressed", _ui_skin_box("glass_button_pressed", _rounded_box(Color("#e8f0f6ee"), 12, Color("#cfdce5")), 24))
	if not method_name.is_empty():
		button.pressed.connect(Callable(self, method_name))
	return button


func _on_start_loop_pressed() -> void:
	quest_event_service.start_chain()
	for event_id in ["event_welcome_home", "event_meet_sunny", "event_snack_time", "event_food_trip"]:
		quest_event_service.advance_event(event_id)
	_update_loop_status("Sunny 想去小镇跑个小差事")


func _on_help_neighbor_pressed() -> void:
	help_neighbor_for_coins()


func _on_optional_letter_snake_pressed() -> void:
	minigame_service.complete_minigame({"config_set_id": "food", "score": 80})
	quest_event_service.advance_event("event_letter_snake_food")
	_update_loop_status("Letter Snake 的小奖励已经收好")
	_set_optional_activity_status("刚玩了一会儿 Letter Snake，这是可选的小活动。")


func _on_memory_album_pressed() -> void:
	open_memory_album()


func _on_settings_pressed() -> void:
	open_settings_panel()


func _on_close_settings_pressed() -> void:
	close_settings_panel()


func open_settings_panel() -> Dictionary:
	if not is_instance_valid(settings_panel):
		return {"ok": false, "reason": "settings_panel_missing"}
	if is_instance_valid(backpack_bubble):
		backpack_bubble.visible = false
	if is_instance_valid(shop_panel):
		shop_panel.visible = false
	if is_instance_valid(memory_album_layer):
		memory_album_layer.visible = false
	settings_exit_confirm_visible = false
	_refresh_settings_panel()
	settings_panel.visible = true
	_set_life_status("小镇设置打开啦，可以慢慢选。")
	return {"ok": true, "interaction_type": "settings", "state": "open"}


func close_settings_panel() -> Dictionary:
	if not is_instance_valid(settings_panel):
		return {"ok": false, "reason": "settings_panel_missing"}
	settings_panel.visible = false
	settings_exit_confirm_visible = false
	_set_life_status("设置收起来啦，继续逛小镇。")
	return {"ok": true, "interaction_type": "settings", "state": "closed"}


func _refresh_settings_panel() -> void:
	if is_instance_valid(settings_status_label):
		settings_status_label.text = "要先休息一下吗？" if settings_exit_confirm_visible else "可以先休息，也可以回到小镇安全位置。"
	var sound_button := find_child("SoundToggleButton", true, false) as Button
	if sound_button != null:
		sound_button.text = "声音开" if settings_sound_enabled else "声音关"
	var cancel_button := find_child("CancelRestButton", true, false) as Button
	var confirm_button := find_child("ConfirmExitButton", true, false) as Button
	if cancel_button != null:
		cancel_button.visible = settings_exit_confirm_visible
	if confirm_button != null:
		confirm_button.visible = settings_exit_confirm_visible


func _on_toggle_sound_pressed() -> void:
	settings_sound_enabled = not settings_sound_enabled
	_refresh_settings_panel()
	_set_life_status("声音打开啦。" if settings_sound_enabled else "声音先安静下来。")


func _on_safe_place_pressed() -> void:
	move_player_to_cell(PLAYER_START_CELL)
	show_town_view()
	if is_instance_valid(settings_panel):
		settings_panel.visible = false
	settings_exit_confirm_visible = false
	_set_life_status("回到小镇安全位置啦。")


func _on_request_rest_pressed() -> void:
	settings_exit_confirm_visible = true
	_refresh_settings_panel()
	_set_life_status("如果想继续逛，也可以马上回来。")


func _on_cancel_rest_pressed() -> void:
	settings_exit_confirm_visible = false
	_refresh_settings_panel()
	_set_life_status("好呀，继续在小镇慢慢逛。")


func _on_confirm_exit_pressed() -> void:
	if not settings_exit_confirm_visible:
		_on_request_rest_pressed()
		return
	_set_life_status("小镇会在这里等你回来。")
	if is_instance_valid(settings_status_label):
		settings_status_label.text = "小镇会在这里等你回来。"
	get_tree().quit()


func _on_close_memory_album_pressed() -> void:
	close_memory_album()


func open_memory_album() -> Dictionary:
	if not is_instance_valid(memory_album_layer):
		return {"ok": false, "reason": "album_missing"}
	if is_instance_valid(town_stage):
		town_stage.visible = false
	if is_instance_valid(backpack_bubble):
		backpack_bubble.visible = false
	if is_instance_valid(settings_panel):
		settings_panel.visible = false
	if is_instance_valid(memory_album_layer):
		memory_album_layer.visible = false
	if is_instance_valid(shop_panel):
		shop_panel.visible = false
	var album := memory_album_layer.find_child("MemoryAlbum", true, false)
	if album != null and album.has_method("set_save_service"):
		album.call("set_save_service", save_service)
	if album != null and album.has_method("refresh"):
		album.call("refresh")
	memory_album_layer.visible = true
	_set_optional_activity_status("小镇相册打开啦。")
	_set_life_status("翻一翻今天在小镇发现的小物件。")
	return {"ok": true, "interaction_type": "memory_album", "state": "open"}


func close_memory_album() -> Dictionary:
	if not is_instance_valid(memory_album_layer):
		return {"ok": false, "reason": "album_missing"}
	memory_album_layer.visible = false
	if is_instance_valid(town_stage) and (not is_instance_valid(home_room_layer) or not home_room_layer.visible):
		town_stage.visible = true
	_set_life_status("回到阳光小镇，继续慢慢逛。")
	return {"ok": true, "interaction_type": "memory_album", "state": "closed"}


func open_shop_panel() -> Dictionary:
	if not is_instance_valid(shop_panel):
		return {"ok": false, "reason": "shop_panel_missing"}
	if is_instance_valid(backpack_bubble):
		backpack_bubble.visible = false
	if is_instance_valid(memory_album_layer):
		memory_album_layer.visible = false
	if is_instance_valid(settings_panel):
		settings_panel.visible = false
	_refresh_shop_panel()
	shop_panel.visible = true
	_set_life_status("街角商店的货架打开啦，喜欢的小物件可以带回小屋。")
	return {"ok": true, "interaction_type": "shop_panel", "state": "open"}


func close_shop_panel() -> Dictionary:
	if not is_instance_valid(shop_panel):
		return {"ok": false, "reason": "shop_panel_missing"}
	shop_panel.visible = false
	_set_life_status("离开货架，商店还亮着小灯。")
	return {"ok": true, "interaction_type": "shop_panel", "state": "closed"}


func _on_close_shop_pressed() -> void:
	close_shop_panel()


func _refresh_shop_panel() -> void:
	if not is_instance_valid(shop_items_list):
		return
	for child in shop_items_list.get_children():
		shop_items_list.remove_child(child)
		child.queue_free()
	var game_state: Dictionary = save_service.load_game_state()
	if is_instance_valid(shop_status_label):
		shop_status_label.text = "金币 %s，可以慢慢挑。" % int(game_state.get("coins", 0))
	for item_id in _furniture_item_ids():
		var offer: Dictionary = life_shop_service.get_offer(item_id)
		if not offer.get("ok", false):
			continue
		var label := "%s  %s币" % [str(offer.get("display_name", item_id)), int(offer.get("price", 0))]
		var button := _create_bubble_button(label, "", _button_name_from_item("ShopBuy", item_id), 260)
		button.custom_minimum_size.y = 46
		button.add_theme_font_size_override("font_size", 15)
		button.add_theme_stylebox_override("normal", _rounded_box(Color("#fffffffa"), 8, Color("#d5e5e5")))
		button.add_theme_stylebox_override("hover", _rounded_box(Color("#f4fbf8"), 8, Color("#b7d9cd")))
		button.add_theme_stylebox_override("pressed", _rounded_box(Color("#dcebe6"), 8, Color("#a9c8bd")))
		button.pressed.connect(Callable(self, "_on_shop_buy_item_pressed").bind(item_id))
		shop_items_list.add_child(button)


func _on_shop_buy_item_pressed(item_id: String) -> void:
	buy_shop_item(item_id)


func buy_shop_item(item_id: String) -> Dictionary:
	var offer: Dictionary = life_shop_service.get_offer(item_id)
	var result: Dictionary = life_shop_service.buy_life_item(item_id)
	var display_name := str(offer.get("display_name", item_id))
	if result.get("ok", false):
		_set_life_status("买下%s，放进背包啦。" % display_name)
	else:
		var reason := str(result.get("reason", ""))
		if reason == "not_enough_coins":
			_set_life_status("金币还不够，先去帮邻居或完成小委托也可以。")
		else:
			_set_life_status("这个小物件今天还不能带走。")
	_update_loop_status(status_label.text if is_instance_valid(status_label) else "商店更新啦")
	_update_backpack_bubble()
	_refresh_shop_panel()
	return result


func _on_buy_food_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_food_basket")
	_update_loop_status("Sunny 的点心放进背包啦" if result.get("ok", false) else "金币还不够，再帮帮邻居吧")


func _on_feed_sunny_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_feed_sunny")
	_update_loop_status("Sunny 吃饱了，很开心" if result.get("ok", false) else "还没有准备好 Sunny 的点心")


func _on_interact_pressed() -> void:
	interact_nearby()


func _on_town_pressed() -> void:
	show_town_view()


func _on_home_pressed() -> void:
	show_home_view()


func _on_backpack_pressed() -> void:
	if backpack_bubble == null:
		return
	_update_backpack_bubble()
	if is_instance_valid(shop_panel) and not backpack_bubble.visible:
		shop_panel.visible = false
	if is_instance_valid(memory_album_layer) and not backpack_bubble.visible:
		memory_album_layer.visible = false
	if is_instance_valid(settings_panel) and not backpack_bubble.visible:
		settings_panel.visible = false
	backpack_bubble.visible = not backpack_bubble.visible


func _on_pick_branch_pressed() -> void:
	collect_branch()


func _on_buy_chair_pressed() -> void:
	buy_wooden_chair()


func _on_place_chair_pressed() -> void:
	place_wooden_chair(Vector2i(2, 2))


func help_neighbor_for_coins() -> Dictionary:
	var game_state: Dictionary = save_service.load_game_state()
	var flags: Dictionary = game_state.get("flags", {})
	if bool(flags.get("helped_neighbor_today", false)):
		_update_loop_status("今天已经帮过邻居啦")
		return {"ok": false, "reason": "already_helped"}

	flags["helped_neighbor_today"] = true
	game_state["flags"] = flags
	game_state["coins"] = int(game_state.get("coins", 0)) + 6
	save_service.save_game_state(game_state)
	_update_loop_status("帮了邻居，得到小镇金币")
	return {"ok": true, "coins": int(game_state.get("coins", 0))}


func collect_branch() -> Dictionary:
	var result: Dictionary = inventory_service.collect_item("branch", 1)
	_set_life_status("在熊熊玩偶旁边捡到一根树枝。" if result.get("ok", false) else "树枝还没有准备好。")
	return result


func buy_wooden_chair() -> Dictionary:
	var result: Dictionary = life_shop_service.buy_life_item("wooden_chair")
	_set_life_status("给小屋买了一把木椅。" if result.get("ok", false) else "金币还不够，木椅先等等。")
	return result


func place_wooden_chair(cell: Vector2i = Vector2i(2, 2)) -> Dictionary:
	var result: Dictionary = place_home_item("wooden_chair", cell)
	_set_life_status("把木椅放在钟表旁边啦。" if result.get("ok", false) else "背包里还没有木椅。")
	return result


func place_home_item(item_id: String, cell: Vector2i, furniture_rotation: int = 0) -> Dictionary:
	var result: Dictionary = home_decoration_service.place_furniture(item_id, cell, furniture_rotation)
	if result.get("ok", false):
		_refresh_home_room()
	else:
		_set_life_status(_home_error_text(str(result.get("reason", ""))))
	return result


func rotate_home_item(instance_id: String) -> Dictionary:
	var result: Dictionary = home_decoration_service.rotate_furniture(instance_id)
	_set_life_status("家具换了一个方向。" if result.get("ok", false) else _home_error_text(str(result.get("reason", ""))))
	_refresh_home_room()
	return result


func move_home_item(instance_id: String, cell: Vector2i) -> Dictionary:
	var result: Dictionary = home_decoration_service.move_furniture(instance_id, cell)
	_set_life_status("家具挪到新的小角落啦。" if result.get("ok", false) else _home_error_text(str(result.get("reason", ""))))
	_refresh_home_room()
	return result


func pickup_home_item(instance_id: String) -> Dictionary:
	var result: Dictionary = home_decoration_service.pickup_furniture(instance_id)
	_set_life_status("家具收回背包啦。" if result.get("ok", false) else _home_error_text(str(result.get("reason", ""))))
	_refresh_home_room()
	return result


func show_town_view() -> void:
	if is_instance_valid(town_stage):
		town_stage.visible = true
	if is_instance_valid(home_room_layer):
		home_room_layer.visible = false
	if is_instance_valid(shop_panel):
		shop_panel.visible = false
	if is_instance_valid(backpack_bubble):
		backpack_bubble.visible = false
	if is_instance_valid(settings_panel):
		settings_panel.visible = false
	_set_life_status("回到阳光小镇，想去哪边都可以。")


func show_home_view() -> void:
	if is_instance_valid(town_stage):
		town_stage.visible = false
	if is_instance_valid(home_room_layer):
		home_room_layer.visible = true
	if is_instance_valid(shop_panel):
		shop_panel.visible = false
	if is_instance_valid(backpack_bubble):
		backpack_bubble.visible = false
	if is_instance_valid(settings_panel):
		settings_panel.visible = false
	_refresh_home_room()
	var feedback: Dictionary = home_decoration_service.get_sunny_feedback()
	_set_life_status(str(feedback.get("text", "Sunny 在小屋里慢慢摇尾巴。")))


func get_expapproval_home_snapshot() -> Dictionary:
	if not is_instance_valid(home_room_layer):
		return {}
	_refresh_home_room()
	var home_state: Dictionary = home_decoration_service.get_home_state()
	var placed: Array = home_state.get("placed_furniture", [])
	var life_detail_names: Array[String] = []
	if is_instance_valid(home_life_layer):
		for child in home_life_layer.get_children():
			life_detail_names.append(str(child.name))
	var child_texts: Array[String] = []
	_collect_child_facing_texts(home_room_layer, child_texts)
	return {
		"home_visible": bool(home_room_layer.visible),
		"home_living_contract_version": "v02.24_homeplaza_002",
		"home_life_detail_count": life_detail_names.size(),
		"home_life_detail_names": life_detail_names,
		"placed_furniture_count": placed.size(),
		"home_state_keys": home_state.keys(),
		"home_state_has_placed_furniture": home_state.has("placed_furniture"),
		"home_state_has_stowed_furniture": home_state.has("stowed_furniture"),
		"sunny_feedback_text": sunny_home_feedback_label.text if is_instance_valid(sunny_home_feedback_label) else "",
		"action_status_text": home_action_status_label.text if is_instance_valid(home_action_status_label) else "",
		"selected_furniture_text": home_selected_furniture_label.text if is_instance_valid(home_selected_furniture_label) else "",
		"child_text_banned_count": _count_banned_home_child_texts(child_texts),
		"child_texts": child_texts,
	}


func get_expapproval_shop_settings_snapshot() -> Dictionary:
	var shop_texts: Array[String] = []
	var settings_texts: Array[String] = []
	if is_instance_valid(shop_panel):
		_collect_child_facing_texts(shop_panel, shop_texts)
	if is_instance_valid(settings_panel):
		_collect_child_facing_texts(settings_panel, settings_texts)
	return {
		"shop_visible": bool(shop_panel.visible) if is_instance_valid(shop_panel) else false,
		"settings_visible": bool(settings_panel.visible) if is_instance_valid(settings_panel) else false,
		"shop_panel_size": _control_size_dict(shop_panel),
		"settings_panel_size": _control_size_dict(settings_panel),
		"shop_button_count": _visible_button_count(shop_panel),
		"settings_button_count": _visible_button_count(settings_panel),
		"shop_min_touch_height": _minimum_visible_button_height(shop_panel),
		"settings_min_touch_height": _minimum_visible_button_height(settings_panel),
		"settings_confirm_visible": bool((find_child("ConfirmExitButton", true, false) as Button).visible) if find_child("ConfirmExitButton", true, false) is Button else false,
		"shop_child_text_banned_count": _count_banned_ui_child_texts(shop_texts),
		"settings_child_text_banned_count": _count_banned_ui_child_texts(settings_texts),
		"shop_texts": shop_texts,
		"settings_texts": settings_texts,
	}


func get_expapproval_school_snapshot() -> Dictionary:
	var stage_snapshot: Dictionary = {}
	if is_instance_valid(town_stage) and town_stage.has_method("get_expapproval_snapshot"):
		stage_snapshot = town_stage.call("get_expapproval_snapshot")
	var proof_texts: Array[String] = []
	if is_instance_valid(arrival_proof_panel):
		_collect_child_facing_texts(arrival_proof_panel, proof_texts)
	var visible_proof_text := ""
	var gate_label := find_child("ArrivalProofSchoolGate", true, false) as Label
	var yard_label := find_child("ArrivalProofSchoolYard", true, false) as Label
	for text in proof_texts:
		if gate_label != null and text == str(gate_label.text) and _arrival_label_visible("ArrivalProofSchoolGate"):
			visible_proof_text = text
		if yard_label != null and text == str(yard_label.text) and _arrival_label_visible("ArrivalProofSchoolYard"):
			visible_proof_text = text
	var school_texts: Array[String] = []
	if is_instance_valid(arrival_proof_panel):
		_collect_child_facing_texts(arrival_proof_panel, school_texts)
	if is_instance_valid(life_status_label):
		school_texts.append(str(life_status_label.text))
	if is_instance_valid(town_stage):
		_collect_child_facing_texts(town_stage, school_texts)
	return {
		"town_stage_visible": bool(town_stage.visible) if is_instance_valid(town_stage) else false,
		"school_gate_life_detail_count": int(stage_snapshot.get("school_gate_life_detail_count", 0)),
		"school_yard_life_detail_count": int(stage_snapshot.get("school_yard_life_detail_count", 0)),
		"school_life_detail_count": int(stage_snapshot.get("school_life_detail_count", 0)),
		"school_life_detail_names": stage_snapshot.get("school_life_detail_names", []),
		"school_line_anchor_count": int(stage_snapshot.get("school_line_anchor_count", 0)),
		"school_line_letters": stage_snapshot.get("school_line_letters", []),
		"muted_school_line_badge_count": int(stage_snapshot.get("muted_school_line_badge_count", 0)),
		"anchor_count": int(stage_snapshot.get("anchor_count", 0)),
		"collision_debug_visible": bool(stage_snapshot.get("collision_debug_visible", true)),
		"arrival_panel_visible": bool(arrival_proof_panel.visible) if is_instance_valid(arrival_proof_panel) else false,
		"arrival_school_gate_visible": _arrival_label_visible("ArrivalProofSchoolGate"),
		"arrival_school_yard_visible": _arrival_label_visible("ArrivalProofSchoolYard"),
		"visible_arrival_text": visible_proof_text,
		"arrival_texts": proof_texts,
		"life_status_text": life_status_label.text if is_instance_valid(life_status_label) else "",
		"school_child_text_banned_count": _count_banned_school_child_texts(school_texts),
	}


func _arrival_label_visible(node_name: String) -> bool:
	var label := find_child(node_name, true, false) as Label
	return label != null and _is_control_visible_in_tree(label)


func _control_size_dict(control: Control) -> Dictionary:
	if control == null:
		return {"width": 0, "height": 0}
	var rect := control.get_global_rect()
	return {"width": int(round(rect.size.x)), "height": int(round(rect.size.y))}


func _visible_button_count(root_node: Node) -> int:
	if root_node == null:
		return 0
	var count := 0
	for child in root_node.find_children("*", "Button", true, false):
		var button := child as Button
		if button != null and _is_control_visible_in_tree(button):
			count += 1
	return count


func _minimum_visible_button_height(root_node: Node) -> int:
	if root_node == null:
		return 0
	var minimum_height := 9999
	for child in root_node.find_children("*", "Button", true, false):
		var button := child as Button
		if button == null or not _is_control_visible_in_tree(button):
			continue
		var height := int(round(max(button.custom_minimum_size.y, button.get_global_rect().size.y)))
		minimum_height = min(minimum_height, height)
	return 0 if minimum_height == 9999 else minimum_height


func _is_control_visible_in_tree(control: Control) -> bool:
	var current: Node = control
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _collect_child_facing_texts(node: Node, texts: Array[String]) -> void:
	if node is Label:
		texts.append(str((node as Label).text))
	elif node is Button:
		texts.append(str((node as Button).text))
	for child in node.get_children():
		_collect_child_facing_texts(child, texts)


func _count_banned_home_child_texts(texts: Array[String]) -> int:
	var banned_terms := ["格子", "坐标", "占格", "footprint", "debug", "cell"]
	var count := 0
	for text in texts:
		var lowered := text.to_lower()
		for term in banned_terms:
			if lowered.contains(term):
				count += 1
				break
	return count


func _count_banned_ui_child_texts(texts: Array[String]) -> int:
	var banned_terms := ["debug", "cell", "grid", "coord", "坐标", "格子", "占格", "调试", "测试", "评分", "打卡", "倒计时"]
	var count := 0
	for text in texts:
		var lowered := text.to_lower()
		for term in banned_terms:
			if lowered.contains(term):
				count += 1
				break
	return count


func _count_banned_school_child_texts(texts: Array[String]) -> int:
	var banned_terms := ["debug", "cell", "grid", "coord", "坐标", "格子", "占格", "调试", "课程", "作业", "测试", "测验", "考试", "背诵", "分数", "正确率", "等级", "打卡", "倒计时", "迟到", "必须"]
	var count := 0
	for text in texts:
		var lowered := text.to_lower()
		for term in banned_terms:
			if lowered.contains(term):
				count += 1
				break
	return count


func interact_nearby() -> Dictionary:
	_update_interaction_prompt()
	var exact_interaction: Dictionary = _find_interaction_at_cell(player_cell)
	if not exact_interaction.is_empty():
		return _handle_map_interaction(exact_interaction)

	var exact_story_prop: Dictionary = _find_story_prop_at_cell(player_cell)
	if not exact_story_prop.is_empty():
		return _look_story_prop(exact_story_prop)

	var resource_result: Dictionary = resource_refresh_service.collect_nearest(player_cell, 0)
	if resource_result.get("ok", false):
		_set_life_status(str(resource_result.get("text", "收进背包啦。")))
		resource_result["interaction_type"] = "resource"
		resource_result["target_id"] = resource_result.get("item_id", "")
		_update_loop_status("背包里多了%s" % str(resource_result.get("display_name", "小材料")))
		return resource_result

	var exact_anchor: Dictionary = _find_nearest_anchor(0)
	if not exact_anchor.is_empty():
		var exact_anchor_result: Dictionary = anchor_interaction_service.interact_with_anchor(exact_anchor)
		var exact_weather_clue: Dictionary = _record_weather_anchor_clue(exact_anchor, exact_anchor_result)
		if not exact_weather_clue.is_empty():
			exact_anchor_result["weather_clue"] = exact_weather_clue
		_set_life_status(str(exact_anchor_result.get("text", "放进相册啦。")))
		exact_anchor_result["interaction_type"] = "anchor"
		return exact_anchor_result

	var npc: Dictionary = _find_nearest_npc(INTERACTION_RADIUS)
	if not npc.is_empty():
		var npc_result: Dictionary = interact_with_npc(str(npc.get("npc_id", "")))
		npc_result["interaction_type"] = "npc"
		return npc_result

	var anchor: Dictionary = _find_nearest_anchor(1)
	if not anchor.is_empty():
		var anchor_result: Dictionary = anchor_interaction_service.interact_with_anchor(anchor)
		var weather_clue: Dictionary = _record_weather_anchor_clue(anchor, anchor_result)
		if not weather_clue.is_empty():
			anchor_result["weather_clue"] = weather_clue
		_set_life_status(str(anchor_result.get("text", "放进相册啦。")))
		anchor_result["interaction_type"] = "anchor"
		return anchor_result

	var story_prop: Dictionary = _find_nearest_story_prop(1)
	if not story_prop.is_empty():
		return _look_story_prop(story_prop)

	resource_result = resource_refresh_service.collect_nearest(player_cell, 1)
	if resource_result.get("ok", false):
		_set_life_status(str(resource_result.get("text", "收进背包啦。")))
		resource_result["interaction_type"] = "resource"
		resource_result["target_id"] = resource_result.get("item_id", "")
		_update_loop_status("背包里多了%s" % str(resource_result.get("display_name", "小材料")))
		return resource_result

	var nearby_interaction: Dictionary = _find_nearest_interaction(1)
	if not nearby_interaction.is_empty():
		return _handle_map_interaction(nearby_interaction)

	_set_life_status("附近暂时没有可以看的东西。")
	return {"ok": false, "reason": "no_target", "cell": _cell_to_dict(player_cell)}


func _handle_map_interaction(interaction: Dictionary) -> Dictionary:
	var action := str(interaction.get("action", ""))
	match action:
		"enter_supermarket", "enter_home", "open_town_start":
			return _enter_place(interaction)
		"look_p1_return_entry":
			return _look_p1_return_entry(interaction)
		"look_homeschool_event":
			return _look_homeschool_event(interaction)
		"look_story_prop":
			var story_prop := _story_prop_by_id(str(interaction.get("story_prop_id", interaction.get("interaction_id", ""))))
			if story_prop.is_empty():
				story_prop = interaction.duplicate(true)
			return _look_story_prop(story_prop)
		_:
			_set_life_status("这个地方还没有准备好。")
			return {
				"ok": false,
				"reason": "unsupported_action",
				"action": action,
				"interaction_id": interaction.get("interaction_id", ""),
			}


func _look_story_prop(story_prop: Dictionary) -> Dictionary:
	var story_prop_id := str(story_prop.get("story_prop_id", ""))
	if story_prop_id.is_empty():
		_set_life_status("这个小物件还在整理，先看看旁边吧。")
		return {"ok": false, "reason": "missing_story_prop_id"}
	var core_anchor_ids: Array[String] = []
	for anchor_id_value in story_prop.get("core_anchor_ids", []):
		var anchor_id := str(anchor_id_value)
		if not anchor_id.is_empty() and not core_anchor_ids.has(anchor_id):
			core_anchor_ids.append(anchor_id)
	var anchor_records: Array[Dictionary] = []
	var story_memories: Array[String] = []
	for anchor_id in core_anchor_ids:
		var record: Dictionary = _record_story_slice_anchor_album(anchor_id)
		if record.get("ok", false):
			anchor_records.append(record)
			var story_memory := str(record.get("story", {}).get("story_memory", ""))
			if not story_memory.is_empty():
				story_memories.append(story_memory)
	var npc_id := str(story_prop.get("npc_id", ""))
	var resource_item_id := str(story_prop.get("resource_item_id", ""))
	var resource_count := 0
	if not resource_item_id.is_empty() and inventory_service != null:
		resource_count = int(inventory_service.get_inventory().get(resource_item_id, 0))
	var record := {
		"seen": true,
		"story_prop_id": story_prop_id,
		"storyline_id": str(story_prop.get("storyline_id", "")),
		"place_id": str(story_prop.get("place_id", _current_place_for_cell(player_cell))),
		"core_anchor_ids": core_anchor_ids.duplicate(true),
		"card_ids": _card_ids_from_anchor_records(anchor_records),
		"environment_words": story_prop.get("environment_words", []).duplicate(true),
		"npc_id": npc_id,
		"resource_item_id": resource_item_id,
		"resource_count": resource_count,
		"last_position": _cell_to_dict(player_cell),
	}
	var game_state: Dictionary = save_service.load_game_state()
	var records: Dictionary = game_state.get("story_slice_records", {})
	records[story_prop_id] = record
	game_state["story_slice_records"] = records
	save_service.save_game_state(game_state)
	var label := str(story_prop.get("child_label", "看看小物件")).trim_prefix("看看").strip_edges()
	if label.is_empty():
		label = "小物件"
	var feedback := str(story_prop.get("child_feedback", "这个小物件把今天的小故事放进相册。"))
	var context := _story_prop_context_text(npc_id, resource_item_id, resource_count)
	var display_text := "%s：%s" % [label, feedback]
	if not context.is_empty():
		display_text = "%s %s" % [display_text, context]
	_set_life_status(display_text)
	return {
		"ok": true,
		"interaction_type": "story_prop",
		"story_prop_id": story_prop_id,
		"storyline_id": str(story_prop.get("storyline_id", "")),
		"place_id": str(record.get("place_id", "")),
		"core_anchor_ids": core_anchor_ids,
		"anchor_records": anchor_records,
		"story_memories": story_memories,
		"environment_words": story_prop.get("environment_words", []).duplicate(true),
		"npc_id": npc_id,
		"resource_item_id": resource_item_id,
		"resource_count": resource_count,
		"text": display_text,
		"record": record,
	}


func _record_story_slice_anchor_album(anchor_id: String) -> Dictionary:
	var anchor := _anchor_by_id(anchor_id)
	var card_id := str(anchor.get("card_id", ""))
	if card_id.is_empty():
		return {"ok": false, "reason": "missing_card_id", "anchor_id": anchor_id}
	memory_card_service.set_card_flags(card_id, {
		"seen": true,
		"heard": true,
		"collected": true,
		"card_progress": 4,
	})
	return {
		"ok": true,
		"anchor_id": anchor_id,
		"card_id": card_id,
		"letter": str(anchor.get("letter", "")),
		"core_word": str(anchor.get("core_word", "")),
		"story": anchor_interaction_service.get_story_for_anchor(anchor_id),
		"album_state": memory_card_service.get_card_state(card_id),
	}


func _card_ids_from_anchor_records(anchor_records: Array[Dictionary]) -> Array[String]:
	var card_ids: Array[String] = []
	for record in anchor_records:
		var card_id := str(record.get("card_id", ""))
		if not card_id.is_empty() and not card_ids.has(card_id):
			card_ids.append(card_id)
	return card_ids


func _story_prop_context_text(npc_id: String, resource_item_id: String, resource_count: int) -> String:
	if npc_id == "story_bear" and resource_item_id == "branch" and resource_count > 0:
		return "背包里的树枝也记得这条小书签路。"
	if npc_id == "story_bear":
		return "故事熊就在附近，路过时可以慢慢打招呼。"
	return ""


func _look_homeschool_event(interaction: Dictionary) -> Dictionary:
	var event_id := str(interaction.get("event_id", interaction.get("interaction_id", "")))
	var event: Dictionary = homeschool_events_by_id.get(event_id, {})
	if event.is_empty():
		_set_life_status("这段小路还在准备，先慢慢看看周围吧。")
		return {"ok": false, "reason": "unknown_homeschool_event", "event_id": event_id}
	var stage := str(event.get("stage", ""))
	var school_day_entry: Dictionary = school_day_state_service.get_entry(stage) if school_day_state_service != null else {}
	var anchor_records: Array[Dictionary] = []
	for anchor_id_value in event.get("anchor_ids", []):
		var record: Dictionary = _record_homeschool_anchor_album(str(anchor_id_value))
		if record.get("ok", false):
			anchor_records.append(record)
	for anchor_id_value in school_day_entry.get("anchor_ids", []):
		var record: Dictionary = _record_homeschool_anchor_album(str(anchor_id_value))
		if record.get("ok", false):
			anchor_records.append(record)
	var game_state: Dictionary = save_service.load_game_state()
	var records: Dictionary = game_state.get("homeschool_events", {})
	records[event_id] = {
		"seen": true,
		"event_id": event_id,
		"stage": stage,
		"place_id": str(event.get("place_id", interaction.get("place_id", _current_place_for_cell(player_cell)))),
		"anchor_ids": event.get("anchor_ids", []).duplicate(true),
		"environment_words": event.get("environment_words", []).duplicate(true),
		"last_cell": _cell_to_dict(player_cell),
	}
	game_state["homeschool_events"] = records
	var school_day_record: Dictionary = {}
	if not school_day_entry.is_empty():
		var school_day_records: Dictionary = game_state.get("school_day_events", {})
		var school_day_event_id := str(school_day_entry.get("event_id", ""))
		school_day_record = {
			"seen": true,
			"event_id": school_day_event_id,
			"day_key": str(school_day_entry.get("day_key", "")),
			"theme": str(school_day_entry.get("theme", "")),
			"stage": str(school_day_entry.get("stage", stage)),
			"place_id": str(school_day_entry.get("place_id", event.get("place_id", ""))),
			"anchor_ids": school_day_entry.get("anchor_ids", []).duplicate(true),
			"environment_words": school_day_entry.get("environment_words", []).duplicate(true),
			"last_cell": _cell_to_dict(player_cell),
		}
		school_day_records[school_day_event_id] = school_day_record
		game_state["school_day_events"] = school_day_records
	save_service.save_game_state(game_state)
	var prefix := str(event.get("display_prefix", event.get("entry_label", "Home / School")))
	var text := str(event.get("text", "这里有一段温和的小路故事。"))
	var next_hint := str(event.get("next_hint", ""))
	var display_text := text if next_hint.is_empty() else "%s %s" % [text, next_hint]
	var school_day_text := str(school_day_entry.get("child_facing_text", ""))
	if not school_day_text.is_empty():
		display_text = "%s 今天的小发现：%s" % [display_text, school_day_text]
	_update_arrival_proof(str(event.get("place_id", interaction.get("place_id", ""))))
	_set_life_status("%s：%s" % [prefix, display_text])
	return {
		"ok": true,
		"interaction_type": "homeschool_event",
		"interaction_id": str(interaction.get("interaction_id", event_id)),
		"event_id": event_id,
		"stage": stage,
		"place_id": str(event.get("place_id", interaction.get("place_id", ""))),
		"text": display_text,
		"anchor_records": anchor_records,
		"environment_words": event.get("environment_words", []).duplicate(true),
		"school_day_entry": school_day_entry,
		"school_day_record": school_day_record,
	}


func _record_homeschool_anchor_album(anchor_id: String) -> Dictionary:
	var anchor := _anchor_by_id(anchor_id)
	var card_id := str(anchor.get("card_id", ""))
	if card_id.is_empty():
		return {"ok": false, "reason": "missing_card_id", "anchor_id": anchor_id}
	memory_card_service.set_card_flags(card_id, {
		"seen": true,
		"heard": true,
		"collected": true,
		"card_progress": 4,
	})
	return {
		"ok": true,
		"anchor_id": anchor_id,
		"card_id": card_id,
		"album_state": memory_card_service.get_card_state(card_id),
	}


func _look_p1_return_entry(interaction: Dictionary) -> Dictionary:
	var interaction_id := str(interaction.get("interaction_id", ""))
	var text := str(interaction.get("text", "这里很安静，可以慢慢看看。"))
	var entry_label := str(interaction.get("entry_label", "小镇角落"))
	var npc_id := str(interaction.get("npc_id", ""))
	var linked_anchor_id := str(interaction.get("linked_anchor_id", ""))
	var game_state: Dictionary = save_service.load_game_state()
	var p1_entries: Dictionary = game_state.get("p1_return_entries", {})
	p1_entries[interaction_id] = {
		"seen": true,
		"entry_label": entry_label,
		"entry_kind": str(interaction.get("entry_kind", "")),
		"npc_id": npc_id,
		"linked_anchor_id": linked_anchor_id,
		"place_id": str(interaction.get("place_id", _current_place_for_cell(player_cell))),
	}
	game_state["p1_return_entries"] = p1_entries
	save_service.save_game_state(game_state)
	var album_record: Dictionary = _record_p1_anchor_album(linked_anchor_id)
	var weather_clue: Dictionary = _record_weather_anchor_clue(_anchor_by_id(linked_anchor_id), {"card_id": str(album_record.get("card_id", ""))})
	var display_text := text
	if not weather_clue.is_empty():
		display_text = "%s 天气相册记下：%s" % [text, str(weather_clue.get("story_memory", ""))]
	var display_prefix := _localized_npc_name(npc_id, entry_label) if not npc_id.is_empty() else entry_label
	_set_life_status("%s：%s" % [display_prefix, display_text])
	return {
		"ok": true,
		"interaction_type": "p1_return_entry",
		"interaction_id": interaction_id,
		"entry_label": entry_label,
		"entry_kind": str(interaction.get("entry_kind", "")),
		"npc_id": npc_id,
		"linked_anchor_id": linked_anchor_id,
		"place_id": str(interaction.get("place_id", _current_place_for_cell(player_cell))),
		"text": display_text,
		"card_id": str(album_record.get("card_id", "")),
		"album_state": album_record.get("album_state", {}),
		"weather_clue": weather_clue,
	}


func _record_p1_anchor_album(anchor_id: String) -> Dictionary:
	var anchor := _anchor_by_id(anchor_id)
	var card_id := str(anchor.get("card_id", ""))
	if card_id.is_empty():
		return {"ok": false, "reason": "missing_card_id", "anchor_id": anchor_id}
	memory_card_service.set_card_flags(card_id, {
		"seen": true,
		"heard": true,
		"collected": true,
		"card_progress": 4,
	})
	return {
		"ok": true,
		"anchor_id": anchor_id,
		"card_id": card_id,
		"album_state": memory_card_service.get_card_state(card_id),
	}


func _record_weather_anchor_clue(anchor: Dictionary, anchor_result: Dictionary) -> Dictionary:
	if today_status_service == null or save_service == null:
		return {}
	var anchor_id := str(anchor.get("anchor_id", ""))
	var card_id := str(anchor.get("card_id", anchor_result.get("card_id", "")))
	if anchor_id.is_empty() or card_id.is_empty():
		return {}
	var status: Dictionary = today_status_service.get_today_status()
	var weather_event: Dictionary = status.get("weather_event", {})
	var clue: Dictionary = _weather_clue_for_anchor(weather_event, anchor_id)
	if clue.is_empty():
		return {}
	var game_state: Dictionary = save_service.load_game_state()
	var records: Dictionary = game_state.get("weather_album_clues", {})
	var event_id := str(weather_event.get("event_id", status.get("weather_event_id", "")))
	var record_id := "%s:%s" % [event_id, anchor_id]
	var record: Dictionary = {
		"seen": true,
		"event_id": event_id,
		"weather_tag": str(weather_event.get("weather_tag", "")),
		"anchor_id": anchor_id,
		"card_id": card_id,
		"album_tag": str(clue.get("album_tag", weather_event.get("album_tag", ""))),
		"story_memory": str(clue.get("story_memory", "")),
		"environment_word": str(clue.get("environment_word", "")),
		"day_key": str(status.get("day_key", "")),
	}
	records[record_id] = record
	game_state["weather_album_clues"] = records
	save_service.save_game_state(game_state)
	var clue_text := str(clue.get("story_memory", ""))
	if not clue_text.is_empty():
		anchor_result["text"] = "%s 天气相册记下：%s" % [str(anchor.get("core_word", "小物件")), clue_text]
	return record


func _weather_clue_for_anchor(weather_event: Dictionary, anchor_id: String) -> Dictionary:
	for clue_value in weather_event.get("album_clues", []):
		if clue_value is Dictionary:
			var clue: Dictionary = clue_value
			if str(clue.get("anchor_id", "")) == anchor_id:
				return clue.duplicate(true)
	for hint_value in weather_event.get("anchor_hints", []):
		if str(hint_value) == anchor_id:
			return {
				"anchor_id": anchor_id,
				"album_tag": str(weather_event.get("album_tag", "")),
				"story_memory": str(weather_event.get("today_status_text", "")),
				"environment_word": str(weather_event.get("weather_tag", "")),
			}
	return {}


func _anchor_by_id(anchor_id: String) -> Dictionary:
	if anchor_id.is_empty():
		return {}
	for anchor_value in world_map.get("memory_anchors", []):
		if anchor_value is Dictionary:
			var anchor: Dictionary = anchor_value
			if str(anchor.get("anchor_id", "")) == anchor_id:
				return anchor.duplicate(true)
	for anchor_value in az_core_data.get("anchors", []):
		if anchor_value is Dictionary:
			var anchor: Dictionary = anchor_value
			if str(anchor.get("anchor_id", "")) == anchor_id:
				return anchor.duplicate(true)
	return {}


func _enter_place(interaction: Dictionary) -> Dictionary:
	var place_id := str(interaction.get("place_id", _current_place_for_cell(player_cell)))
	var place: Dictionary = _find_place(place_id)
	var place_label := str(place.get("label", place_id))
	var message := _place_entry_message(place_id, place_label)
	var game_state: Dictionary = save_service.load_game_state()
	game_state["current_place_id"] = place_id
	save_service.save_game_state(game_state)
	_set_life_status(message)
	_update_arrival_proof(place_id)
	if place_id == "place_home":
		show_home_view()
	elif place_id == "place_supermarket":
		open_shop_panel()
	elif place_id == "place_town_start":
		show_town_view()
	return {
		"ok": true,
		"interaction_type": "place_entry",
		"interaction_id": interaction.get("interaction_id", ""),
		"place_id": place_id,
		"place_label": place_label,
		"action": interaction.get("action", ""),
		"panel": "shop" if place_id == "place_supermarket" else "home" if place_id == "place_home" else "",
		"text": message,
	}


func _place_entry_message(place_id: String, place_label: String) -> String:
	match place_id:
		"place_home":
			return "小屋很安静，房间等着你慢慢装扮。"
		"place_town_start":
			return "这里是阳光小镇广场，小路通向邻居和商店。"
		"place_supermarket":
			return "商店开门啦，货架上有生活小物。"
		_:
			return "%s 很安静，可以进去看看。" % place_label


func _update_arrival_proof(place_id: String) -> void:
	if not is_instance_valid(arrival_proof_panel):
		return
	var has_visible := false
	for key in arrival_proof_labels.keys():
		var label := arrival_proof_labels.get(key) as Label
		if label == null:
			continue
		var is_current := str(key) == place_id
		label.visible = is_current
		has_visible = has_visible or is_current
	arrival_proof_panel.visible = has_visible and (not is_instance_valid(home_room_layer) or not home_room_layer.visible)


func _update_loop_status(message: String) -> void:
	if status_label == null:
		return
	var game_state: Dictionary = save_service.load_game_state()
	var pet: Dictionary = game_state.get("pet", {})
	var learning_record: Dictionary = save_service.load_learning_record()
	var dog_state: Dictionary = learning_record.get("card_states", {}).get("card_d_dog_core", {})
	status_label.text = message
	coin_label.text = "%s" % int(game_state.get("coins", 0))
	pet_label.text = "点%s 心%s" % [
		int(game_state.get("inventory", {}).get("food_pet_snack", 0)),
		int(pet.get("happy", 0)),
	]
	cards_label.text = "小狗收藏：%s / %s" % [
		"玩过" if dog_state.get("played", false) else "见过" if dog_state.get("seen", false) else "新的",
		"完成" if game_state.get("flags", {}).get("sunny_first_snack_done", false) else "进行中",
	]
	_update_backpack_bubble()


func _update_backpack_bubble() -> void:
	if backpack_summary_label == null or backpack_items_label == null:
		return
	var game_state: Dictionary = save_service.load_game_state()
	var inventory: Dictionary = game_state.get("inventory", {})
	backpack_summary_label.text = "金币 %s  Sunny 开心 %s" % [
		int(game_state.get("coins", 0)),
		int(game_state.get("pet", {}).get("happy", 0)),
	]
	backpack_items_label.text = "点心 %s   树枝 %s   小花 %s   小石子 %s   木椅 %s   家具 %s" % [
		int(inventory.get("food_pet_snack", 0)),
		int(inventory.get("branch", 0)),
		int(inventory.get("flower", 0)),
		int(inventory.get("stone", 0)),
		int(inventory.get("wooden_chair", 0)),
		_count_home_inventory_items(inventory),
	]


func _count_home_inventory_items(inventory: Dictionary) -> int:
	var count := 0
	for item_id in _furniture_item_ids():
		if item_id == "wooden_chair":
			continue
		count += int(inventory.get(item_id, 0))
	return count


func _furniture_item_ids() -> Array[String]:
	return ["wooden_chair", "small_table", "soft_rug", "flower_pot", "pet_bowl", "sunny_bed", "wall_decoration"]


func _item_display_name(item: Dictionary) -> String:
	return str(item.get("localized_display_name", item.get("display_name", item.get("item_id", "小物件"))))


func _button_name_from_item(prefix: String, item_id: String) -> String:
	var suffix := ""
	for part in item_id.split("_"):
		suffix += str(part).capitalize().replace(" ", "")
	return "%s%sButton" % [prefix, suffix]


func _create_nav_button(label: String, selected: bool, node_name: String = "") -> Button:
	return _create_footer_button(label, selected, "", node_name if not node_name.is_empty() else label.replace(" ", "") + "NavButton")


func _create_placeholder(title_text: String, body_text: String) -> Control:
	var panel := PanelContainer.new()
	panel.name = title_text.replace(" ", "") + "Placeholder"
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _rounded_box(Color("#f8faf8"), 8, Color("#d9e2df")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 10)
	margin.add_child(stack)

	var marker := ColorRect.new()
	marker.name = "Marker"
	marker.color = ACCENT_COLOR
	marker.custom_minimum_size = Vector2(0, 10)
	stack.add_child(marker)

	var title := Label.new()
	title.name = "Title"
	title.text = title_text
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 24)
	stack.add_child(title)

	var body := Label.new()
	body.name = "Body"
	body.text = body_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	body.add_theme_font_size_override("font_size", 18)
	stack.add_child(body)

	return panel


func _create_map_canvas() -> Control:
	player_cell = _load_player_cell()
	player_walk_target_cell = player_cell
	player_world_position = _cell_center(_cell_to_dict(player_cell))

	var stage := TownStageScene.instantiate() as Control
	stage.name = "TownStage"
	var stage_result: Dictionary = stage.call("setup", {
		"renderer": self,
		"world_map": world_map,
		"az_core_data": az_core_data,
		"resource_points": resource_refresh_service.get_available_points(),
		"story_props": story_props,
		"first_npcs": _active_npcs(),
		"outdoor_items": outdoor_decoration_service.get_placed_items(),
		"map_cell_size": MAP_CELL_SIZE,
		"map_render_size": MAP_RENDER_SIZE,
		"local_camera_scale": LOCAL_CAMERA_SCALE,
	})
	stage.connect("map_cell_requested", Callable(self, "_on_town_stage_cell_requested"))
	runtime_map_frame = stage_result.get("frame", null)
	runtime_map_input = stage_result.get("input", null)
	runtime_map_node = stage_result.get("map", null)
	player_marker = stage_result.get("player_marker", null)
	_update_player_marker()
	_update_camera_for_player()
	_update_interaction_prompt()

	interaction_prompt_glow = _create_interaction_prompt_glow()
	runtime_map_frame.add_child(interaction_prompt_glow)
	interaction_prompt_label = _create_interaction_prompt_label()
	runtime_map_frame.add_child(interaction_prompt_label)
	_update_interaction_prompt()

	return stage


func _create_place_marker(place: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = place.get("place_id", "place")
	var size_data: Dictionary = place.get("size", {"w": 2, "h": 2})
	var place_id := str(place.get("place_id", "place"))
	var building_size := Vector2(
		int(size_data.get("w", 2)) * MAP_CELL_SIZE,
		int(size_data.get("h", 2)) * MAP_CELL_SIZE
	)
	marker.position = _cell_position(place.get("position", {})) + building_size * 0.5

	var body_texture_key := "place_%s_body" % place_id
	marker.add_child(_create_sprite("Shadow", Vector2(3, building_size.y * 0.45), Vector2(building_size.x * 0.95, 15), "shadow"))
	if _can_resolve_texture_key(body_texture_key):
		var production_body := _create_sprite("Building", Vector2.ZERO, building_size, body_texture_key)
		production_body.modulate = Color(1, 1, 1, 0.0)
		marker.add_child(production_body)
		return marker

	marker.add_child(_create_sprite("Building", Vector2(0, 8), Vector2(building_size.x, building_size.y - 8), body_texture_key))
	marker.add_child(_create_sprite("Roof", Vector2(0, -building_size.y * 0.32), Vector2(building_size.x * 0.92, 22), "place_%s_roof" % place_id))
	marker.add_child(_create_sprite("Door", Vector2(0, building_size.y * 0.25), Vector2(14, 18), "door_%s" % place_id))
	marker.add_child(_create_sprite("WindowLeft", Vector2(-building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_left" % place_id))
	marker.add_child(_create_sprite("WindowRight", Vector2(building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_right" % place_id))
	if place_id == "place_supermarket":
		marker.add_child(_create_sprite("ShopSignAnchor", Vector2(0, -building_size.y * 0.08), Vector2(48, 14), "anchor_shop_sign"))
	elif place_id == "place_town_start":
		marker.add_child(_create_sprite("PlazaFlag", Vector2(building_size.x * 0.28, -building_size.y * 0.22), Vector2(14, 26), "plaza_flag"))

	return marker


func _create_resource_marker(point: Dictionary) -> Node2D:
	var marker := Node2D.new()
	var item_id := str(point.get("item_id", "resource"))
	marker.name = "resource_%s" % item_id
	marker.position = _cell_center(point.get("cell", {}))
	marker.add_child(_create_sprite("ResourceSprite", Vector2.ZERO, Vector2(MAP_CELL_SIZE * 1.2, MAP_CELL_SIZE * 1.2), "resource_%s" % item_id))
	return marker


func _create_hotspot_marker(interaction: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = interaction.get("interaction_id", "interaction")
	marker.position = _cell_center(interaction.get("cell", {}))
	marker.modulate = Color(1, 1, 1, 0.18)
	marker.add_child(_create_sprite("Glow", Vector2.ZERO, Vector2(MAP_CELL_SIZE * 0.9, MAP_CELL_SIZE * 0.55), "hotspot_glow"))
	return marker


func _create_collision_marker(cell: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = "CollisionCell"
	marker.position = _cell_center(cell)
	return marker


func _create_anchor_marker(anchor: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = anchor.get("anchor_id", "anchor")
	var letter := str(anchor.get("letter", ""))
	marker.position = _cell_center(anchor.get("position", {}))
	marker.set_meta("mapread_layer", _mapread_layer_for_anchor(letter))
	marker.set_meta("mapread_screenshot_group", _mapread_screenshot_group_for_anchor(letter))
	marker.set_meta("mapread_core_word", str(anchor.get("core_word", "")))
	marker.add_child(_create_anchor_object_sprite(letter))
	marker.add_child(_create_anchor_letter_badge(anchor))

	var object := Node2D.new()
	object.name = "ObjectLabel"
	marker.add_child(object)
	return marker


func _create_reserved_anchor_marker(anchor: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = anchor.get("anchor_id", "anchor")
	var route_order := int(anchor.get("route_order", 1))
	marker.position = Vector2(
		(((route_order - 1) % 13) * MAP_CELL_SIZE * 2) + MAP_CELL_SIZE,
		((20 + int(float(route_order - 1) / 13.0)) * MAP_CELL_SIZE) + MAP_CELL_SIZE
	)
	marker.add_child(_create_sprite("FutureObject", Vector2.ZERO, Vector2(MAP_CELL_SIZE * 1.15, MAP_CELL_SIZE * 0.9), "reserved_anchor_%s" % str(anchor.get("letter", ""))))
	marker.add_child(_create_anchor_letter_badge(anchor))

	var label := Node2D.new()
	label.name = "ObjectLabel"
	marker.add_child(label)
	return marker


func _create_npc_marker(npc: Dictionary) -> Node2D:
	var marker := Node2D.new()
	var npc_id := str(npc.get("npc_id", "neighbor"))
	marker.name = "npc_%s" % npc_id
	marker.position = _cell_center(npc.get("cell", {}))
	marker.add_child(_create_sprite("Shadow", Vector2(0, 14), Vector2(24, 7), "shadow"))
	marker.add_child(_create_sprite("Body", Vector2(0, 2), Vector2(22, 26), "npc_%s_body" % npc_id))
	marker.add_child(_create_sprite("Head", Vector2(0, -13), Vector2(24, 22), "npc_%s_head" % npc_id))
	marker.add_child(_create_sprite("EarLeft", Vector2(-9, -24), Vector2(8, 10), "npc_%s_ear_left" % npc_id))
	marker.add_child(_create_sprite("EarRight", Vector2(9, -24), Vector2(8, 10), "npc_%s_ear_right" % npc_id))
	marker.add_child(_create_sprite("FaceDotLeft", Vector2(-4, -15), Vector2(3, 3), "face_dot"))
	marker.add_child(_create_sprite("FaceDotRight", Vector2(4, -15), Vector2(3, 3), "face_dot"))
	return marker


func _create_player_marker() -> Node2D:
	var marker := Node2D.new()
	marker.name = "Player"
	marker.add_child(_create_sprite("Shadow", Vector2(0, 14), Vector2(22, 7), "shadow"))
	if _can_resolve_texture_key("player_body"):
		marker.add_child(_create_sprite("Body", Vector2(0, -4), Vector2(34, 43), "player_body"))
	else:
		marker.add_child(_create_sprite("Body", Vector2(0, 4), Vector2(20, 24), "player_body"))
		marker.add_child(_create_sprite("Head", Vector2(0, -12), Vector2(22, 20), "player_head"))
		marker.add_child(_create_sprite("FaceDotLeft", Vector2(-4, -13), Vector2(3, 3), "face_dot"))
		marker.add_child(_create_sprite("FaceDotRight", Vector2(4, -13), Vector2(3, 3), "face_dot"))
	return marker


func move_player_by_cells(delta: Vector2i) -> Dictionary:
	return request_player_walk_to_cell(player_cell + delta)


func request_player_walk_to_cell(target_cell: Vector2i) -> Dictionary:
	target_cell = _remap_legacy_runtime_cell(target_cell)
	var path := _build_walk_path(player_cell, target_cell)
	if path.is_empty():
		_set_life_status("那里暂时走不过去。")
		_update_interaction_prompt()
		_update_player_marker()
		return {"ok": false, "reason": "blocked", "cell": _cell_to_dict(target_cell)}

	player_walk_path = path
	player_walk_target_cell = target_cell
	player_is_walking = true
	_update_player_facing_for_next_step()
	held_move_cooldown = 0.0
	_set_life_status("沿着小路慢慢走过去。")
	_update_interaction_prompt()
	_update_player_marker()
	return {
		"ok": true,
		"walking": true,
		"target_cell": _cell_to_dict(target_cell),
		"path_length": path.size(),
	}


func finish_player_walk_for_test(max_steps: int = 240) -> Dictionary:
	var steps := 0
	while player_is_walking and steps < max_steps:
		_advance_player_walk(1.0 / 30.0)
		steps += 1
	return {
		"ok": not player_is_walking,
		"steps": steps,
		"cell": _cell_to_dict(player_cell),
		"target_cell": _cell_to_dict(player_walk_target_cell),
	}


func move_player_to_cell(target_cell: Vector2i) -> Dictionary:
	target_cell = _remap_legacy_runtime_cell(target_cell)
	if not _is_cell_walkable(target_cell):
		_set_life_status("那里暂时走不过去。")
		return {"ok": false, "reason": "blocked", "cell": _cell_to_dict(target_cell)}

	player_cell = target_cell
	player_walk_target_cell = target_cell
	player_world_position = _cell_center(_cell_to_dict(player_cell))
	player_walk_path.clear()
	player_is_walking = false
	held_move_cooldown = 0.0
	_save_player_cell()
	_update_player_marker()
	_set_life_status(_walk_status_for_cell(player_cell))
	_update_interaction_prompt()
	return {"ok": true, "cell": _cell_to_dict(player_cell)}


func place_outdoor_item(item_id: String, cell: Vector2i) -> Dictionary:
	var result: Dictionary = outdoor_decoration_service.place_item(item_id, cell)
	if result.get("ok", false):
		_refresh_outdoor_decor_layer()
		_set_life_status("小镇角落多了一个小物件。")
	return result


func move_outdoor_item(instance_id: String, cell: Vector2i) -> Dictionary:
	var result: Dictionary = outdoor_decoration_service.move_item(instance_id, cell)
	if result.get("ok", false):
		_refresh_outdoor_decor_layer()
		_set_life_status("把小物件挪到新的角落啦。")
	return result


func pickup_outdoor_item(instance_id: String) -> Dictionary:
	var result: Dictionary = outdoor_decoration_service.pickup_item(instance_id)
	if result.get("ok", false):
		_refresh_outdoor_decor_layer()
		_update_loop_status("小物件回到背包啦")
	return result


func get_npc_routine_snapshot() -> Dictionary:
	if npc_routine_service == null:
		return {"ok": false, "reason": "routine_service_missing"}
	return npc_routine_service.get_routine_snapshot(FIRST_NPCS)


func get_story_slice_snapshot() -> Dictionary:
	var stage_snapshot: Dictionary = {}
	if is_instance_valid(town_stage) and town_stage.has_method("get_expapproval_snapshot"):
		stage_snapshot = town_stage.call("get_expapproval_snapshot")
	var game_state: Dictionary = save_service.load_game_state() if save_service != null else {}
	var story_records: Dictionary = game_state.get("story_slice_records", {})
	var seen_anchor_ids: Array[String] = []
	for record_value in story_records.values():
		if not record_value is Dictionary:
			continue
		for anchor_id_value in (record_value as Dictionary).get("core_anchor_ids", []):
			var anchor_id := str(anchor_id_value)
			if not anchor_id.is_empty() and not seen_anchor_ids.has(anchor_id):
				seen_anchor_ids.append(anchor_id)
	return {
		"story_prop_count": int(stage_snapshot.get("story_prop_count", 0)),
		"story_prop_names": stage_snapshot.get("story_prop_names", []),
		"story_record_count": story_records.size(),
		"story_records": story_records.duplicate(true),
		"seen_anchor_ids": seen_anchor_ids,
		"life_status_text": life_status_label.text if is_instance_valid(life_status_label) else "",
	}


func interact_with_npc(npc_id: String) -> Dictionary:
	var npc := _find_npc(npc_id)
	if npc.is_empty():
		return {"ok": false, "reason": "unknown_npc", "npc_id": npc_id}

	var npc_cell := _dict_to_cell(npc.get("cell", {}))
	if _manhattan_distance(player_cell, npc_cell) > 2:
		return {"ok": false, "reason": "too_far", "npc_id": npc_id}

	var greeting_result: Dictionary = daily_greeting_service.interact_for_npc(npc_id, false)
	if bool(greeting_result.get("handled", false)):
		var greeting_text := str(greeting_result.get("text", ""))
		var greeting_display_name := _npc_display_name(npc_id)
		npc_memory_store.record_event(npc_id, {
			"event_id": "daily_greeting_%s" % str(greeting_result.get("day_key", "")),
			"title": "%s daily greeting" % greeting_display_name,
			"summary": greeting_text,
			"created_at": "",
		})
		_set_life_status("%s: %s" % [greeting_display_name, greeting_text])
		greeting_result["display_name"] = greeting_display_name
		greeting_result["is_stub"] = true
		greeting_result["network_used"] = false
		return greeting_result

	var daily_result: Dictionary = _interact_for_visible_daily_request(npc_id)
	if bool(daily_result.get("handled", false)):
		var daily_text := str(daily_result.get("text", ""))
		var daily_display_name := _npc_display_name(npc_id)
		npc_memory_store.record_event(npc_id, {
			"event_id": str(daily_result.get("request_id", "daily_request")),
			"title": "%s daily request" % daily_display_name,
			"summary": daily_text,
			"created_at": "",
		})
		_set_life_status("%s: %s" % [daily_display_name, daily_text])
		daily_result["display_name"] = daily_display_name
		daily_result["is_stub"] = true
		daily_result["network_used"] = false
		return daily_result

	var repeat_greeting: Dictionary = daily_greeting_service.interact_for_npc(npc_id, true)
	if bool(repeat_greeting.get("handled", false)):
		var repeat_text := str(repeat_greeting.get("text", ""))
		var repeat_display_name := _npc_display_name(npc_id)
		npc_memory_store.record_event(npc_id, {
			"event_id": "daily_greeting_repeat_%s" % str(repeat_greeting.get("day_key", "")),
			"title": "%s daily greeting" % repeat_display_name,
			"summary": repeat_text,
			"created_at": "",
		})
		_set_life_status("%s: %s" % [repeat_display_name, repeat_text])
		repeat_greeting["display_name"] = repeat_display_name
		repeat_greeting["is_stub"] = true
		repeat_greeting["network_used"] = false
		return repeat_greeting

	var reply: Dictionary = llm_client.complete_chat(npc_id, "hello", {
		"event_id": "scene_interact",
		"place_id": _current_place_for_cell(player_cell),
	})
	if not reply.get("ok", false):
		return reply

	var display_name := _localized_npc_name(npc_id, str(reply.get("display_name", _npc_display_name(npc_id))))
	var line := str(reply.get("text", _npc_line(npc_id)))
	var learning_record: Dictionary = save_service.load_learning_record()
	var relationships: Dictionary = learning_record.get("npc_relationships", {})
	var state: Dictionary = relationships.get(npc_id, {})
	state["greeting_count"] = int(state.get("greeting_count", 0)) + 1
	state["last_line"] = line
	state["relationship"] = "neighbor"
	relationships[npc_id] = state
	learning_record["npc_relationships"] = relationships
	save_service.save_learning_record(learning_record)
	npc_memory_store.record_event(npc_id, {
		"event_id": "scene_interact",
		"title": "%s greeting" % display_name,
		"summary": line,
		"created_at": "",
	})
	_set_life_status("%s: %s" % [display_name, line])
	return {
		"ok": true,
		"npc_id": npc_id,
		"display_name": display_name,
		"text": line,
		"is_stub": bool(reply.get("is_stub", false)),
		"network_used": bool(reply.get("network_used", true)),
		"state": state.duplicate(true),
	}


func _interact_for_visible_daily_request(npc_id: String) -> Dictionary:
	var request_id := _visible_daily_request_id_for_npc(npc_id)
	if not request_id.is_empty() and daily_request_service.has_method("interact_for_request"):
		return daily_request_service.interact_for_request(request_id)
	return daily_request_service.interact_for_npc(npc_id)


func _visible_daily_request_id_for_npc(npc_id: String) -> String:
	match npc_id:
		"story_bear":
			return "daily_story_bear_find_bear_corner_001"
		"bus_helper":
			return "daily_bus_helper_taxi_spot_001"
		_:
			return ""


func _map_anchor_letters() -> Array[String]:
	var letters: Array[String] = []
	for anchor in world_map.get("memory_anchors", []):
		letters.append(anchor.get("letter", ""))
	return letters


func _create_sprite(sprite_name: String, sprite_position: Vector2, sprite_size: Vector2, texture_key: String) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = sprite_name
	sprite.position = sprite_position
	sprite.set_meta("texture_key", texture_key)
	var spec: Dictionary = _logical_asset_texture_keys.get(texture_key, {})
	if not spec.is_empty():
		sprite.set_meta("asset_category", str(spec.get("category", "")))
		sprite.set_meta("logical_asset_id", str(spec.get("asset_id", "")))
	sprite.texture = _get_texture(texture_key)
	var texture_size := Vector2(sprite.texture.get_width(), sprite.texture.get_height())
	sprite.scale = Vector2(
		sprite_size.x / max(texture_size.x, 1.0),
		sprite_size.y / max(texture_size.y, 1.0)
	)
	return sprite


func _map_render_scale(map_width: int, map_height: int) -> Vector2:
	return LOCAL_CAMERA_SCALE


func _get_texture(texture_key: String) -> Texture2D:
	if _texture_cache.has(texture_key):
		return _texture_cache[texture_key]
	var resolved_texture := _get_resolved_asset_texture(texture_key)
	if resolved_texture != null:
		_texture_cache[texture_key] = resolved_texture
		return resolved_texture
	if texture_key.begins_with("v0239_"):
		var v0239_texture := _create_v0239_texture(texture_key)
		_texture_cache[texture_key] = v0239_texture
		return v0239_texture
	var colors := _texture_colors(texture_key)
	var image := Image.create(8, 8, false, Image.FORMAT_RGBA8)
	image.fill(colors.get("fill", Color.WHITE))
	var edge_color: Color = colors.get("edge", colors.get("fill", Color.WHITE))
	for x in range(8):
		image.set_pixel(x, 0, edge_color)
		image.set_pixel(x, 7, edge_color)
	for y in range(8):
		image.set_pixel(0, y, edge_color)
		image.set_pixel(7, y, edge_color)
	var accent: Color = colors.get("accent", colors.get("fill", Color.WHITE))
	for x in range(2, 6):
		image.set_pixel(x, 2, accent)
	for y in range(3, 6):
		image.set_pixel(5, y, accent)
	var texture := ImageTexture.create_from_image(image)
	_texture_cache[texture_key] = texture
	return texture


func _create_v0239_texture(texture_key: String) -> Texture2D:
	var colors := _v0239_texture_colors(texture_key)
	var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	var fill: Color = colors.get("fill", Color.WHITE)
	var edge: Color = colors.get("edge", fill.darkened(0.12))
	var accent: Color = colors.get("accent", fill.lightened(0.12))
	var transparent := Color(0, 0, 0, 0)
	image.fill(transparent)
	match texture_key:
		"v0239_tree_crown":
			_paint_ellipse_texture(image, Vector2(32, 29), Vector2(27, 23), fill, edge, accent)
			_paint_ellipse_texture(image, Vector2(21, 34), Vector2(16, 14), fill.darkened(0.03), edge, accent)
			_paint_ellipse_texture(image, Vector2(43, 34), Vector2(15, 13), fill.lightened(0.03), edge, accent)
		"v0239_flower_patch":
			_paint_ellipse_texture(image, Vector2(32, 36), Vector2(25, 11), Color("#7dbb6e"), Color("#579053"), Color("#a4d98f"))
			for point in [Vector2(20, 28), Vector2(28, 24), Vector2(37, 26), Vector2(45, 30), Vector2(31, 35)]:
				_paint_ellipse_texture(image, point, Vector2(5, 4), fill, edge, accent)
		"v0239_pond_edge":
			_paint_ellipse_texture(image, Vector2(35, 35), Vector2(29, 19), fill, edge, accent)
			_paint_ellipse_texture(image, Vector2(18, 26), Vector2(14, 8), Color("#dff3d3"), Color("#b9d9b1"), Color("#edf9df"))
		"v0239_path_tile":
			_paint_ellipse_texture(image, Vector2(32, 32), Vector2(30, 21), fill, edge, accent)
			_paint_dots(image, Color("#d6b66f88"), 9)
		"v0239_grass_tuft":
			_paint_grass_tuft_texture(image, fill, edge, accent)
		"v0239_path_pebble":
			_paint_ellipse_texture(image, Vector2(30, 34), Vector2(18, 10), fill, edge, accent)
			_paint_ellipse_texture(image, Vector2(44, 30), Vector2(9, 6), fill.lightened(0.04), edge, accent)
		"v0239_bank_stone":
			_paint_ellipse_texture(image, Vector2(31, 34), Vector2(25, 15), fill, edge, accent)
			_paint_ellipse_texture(image, Vector2(44, 29), Vector2(11, 8), fill.lightened(0.05), edge, accent)
		"v0239_lily_pad":
			_paint_ellipse_texture(image, Vector2(32, 34), Vector2(24, 12), fill, edge, accent)
			for x in range(32, 50):
				var y := int(34 - (x - 32) * 0.42)
				if Rect2i(Vector2i.ZERO, image.get_size()).has_point(Vector2i(x, y)):
					image.set_pixel(x, y, edge.darkened(0.08))
		"v0239_crop_leaf":
			_paint_crop_leaf_texture(image, fill, edge, accent)
		"v0239_house_window":
			_paint_window_texture(image, fill, edge, accent, false)
		"v0239_house_round_window":
			_paint_window_texture(image, fill, edge, accent, true)
		"v0239_house_lantern":
			_paint_lantern_texture(image, fill, edge, accent)
		"v0239_flower_box":
			_paint_flower_box_texture(image, fill, edge, accent)
		"v0239_house_steps":
			_paint_steps_texture(image, fill, edge, accent)
		"v0239_mailbox":
			_paint_mailbox_texture(image, fill, edge, accent)
		"v0239_companion_ear":
			_paint_ellipse_texture(image, Vector2(32, 32), Vector2(18, 22), fill, edge, accent)
		"v0239_companion_tail":
			_paint_ellipse_texture(image, Vector2(29, 34), Vector2(22, 12), fill, edge, accent)
		"v0239_companion_collar":
			_paint_rounded_rect_texture(image, Rect2i(8, 25, 48, 16), 5, fill, edge, accent)
		"v0239_icon_look":
			_paint_icon_disc_texture(image, fill, edge, accent, "look")
		"v0239_icon_map":
			_paint_icon_disc_texture(image, fill, edge, accent, "map")
		"v0239_icon_home":
			_paint_icon_disc_texture(image, fill, edge, accent, "home")
		"v0239_icon_album":
			_paint_icon_disc_texture(image, fill, edge, accent, "album")
		_:
			_paint_rounded_rect_texture(image, Rect2i(4, 4, 56, 56), 12, fill, edge, accent)
			if texture_key == "v0239_grass_patch":
				_paint_dots(image, Color("#c8e8b688"), 11)
				_paint_grass_blades(image, Color("#b9d99a99"), 13)
			elif texture_key == "v0239_house_roof":
				_paint_roof_lines(image, edge.darkened(0.1))
			elif texture_key == "v0239_house_body":
				_paint_house_siding(image, Color("#efd7a688"))
			elif texture_key == "v0239_fence":
				_paint_fence_texture(image, fill, edge)
			elif texture_key == "v0239_garden_bed":
				_paint_dots(image, Color("#79b96a"), 7)
	var texture := ImageTexture.create_from_image(image)
	return texture


func _v0239_texture_colors(texture_key: String) -> Dictionary:
	match texture_key:
		"v0239_grass_patch":
			return {"fill": Color("#dff2cf"), "edge": Color("#c5e2b6"), "accent": Color("#eef9df")}
		"v0239_path_tile":
			return {"fill": Color("#dfc079"), "edge": Color("#c6a663"), "accent": Color("#efd59a")}
		"v0239_house_body":
			return {"fill": Color("#f6dfad"), "edge": Color("#c99a63"), "accent": Color("#fff1cb")}
		"v0239_house_roof":
			return {"fill": Color("#e99059"), "edge": Color("#b86443"), "accent": Color("#f4b07b")}
		"v0239_house_door":
			return {"fill": Color("#8f6042"), "edge": Color("#5e3e2d"), "accent": Color("#d3a572")}
		"v0239_tree_crown":
			return {"fill": Color("#74b86a"), "edge": Color("#4f8c4f"), "accent": Color("#9fd58a")}
		"v0239_tree_trunk":
			return {"fill": Color("#9a6848"), "edge": Color("#6d4a36"), "accent": Color("#bd8359")}
		"v0239_flower_patch":
			return {"fill": Color("#ee88a6"), "edge": Color("#bf5d7e"), "accent": Color("#ffe0a2")}
		"v0239_fence":
			return {"fill": Color("#f1d495"), "edge": Color("#b98555"), "accent": Color("#fff1c2")}
		"v0239_signpost":
			return {"fill": Color("#eed28a"), "edge": Color("#9a6a45"), "accent": Color("#fff6cf")}
		"v0239_garden_bed":
			return {"fill": Color("#b87952"), "edge": Color("#7d513a"), "accent": Color("#e6b77c")}
		"v0239_pond_edge":
			return {"fill": Color("#9fdce2"), "edge": Color("#66aeb8"), "accent": Color("#dcf6f4")}
		"v0239_companion":
			return {"fill": Color("#f2c671"), "edge": Color("#b98539"), "accent": Color("#fff0b5")}
		"v0239_grass_tuft":
			return {"fill": Color("#83bf66"), "edge": Color("#4f8e48"), "accent": Color("#b7dc7a")}
		"v0239_path_pebble":
			return {"fill": Color("#d0aa68"), "edge": Color("#a8824e"), "accent": Color("#efd28f")}
		"v0239_bank_stone":
			return {"fill": Color("#bfb69b"), "edge": Color("#8f876f"), "accent": Color("#ddd6bd")}
		"v0239_lily_pad":
			return {"fill": Color("#64a95b"), "edge": Color("#3e7e43"), "accent": Color("#a4d35e")}
		"v0239_crop_leaf":
			return {"fill": Color("#71b85f"), "edge": Color("#4f8847"), "accent": Color("#f3a143")}
		"v0239_house_chimney":
			return {"fill": Color("#b7a28e"), "edge": Color("#766758"), "accent": Color("#ddd1bc")}
		"v0239_house_window":
			return {"fill": Color("#6fb5d6"), "edge": Color("#8a5f39"), "accent": Color("#f9df89")}
		"v0239_house_round_window":
			return {"fill": Color("#72b7d8"), "edge": Color("#8a5f39"), "accent": Color("#f9df89")}
		"v0239_house_lantern":
			return {"fill": Color("#ffd36b"), "edge": Color("#9a623b"), "accent": Color("#fff0b5")}
		"v0239_flower_box":
			return {"fill": Color("#c07b43"), "edge": Color("#7d513a"), "accent": Color("#f3d35f")}
		"v0239_house_steps":
			return {"fill": Color("#c9b99d"), "edge": Color("#8f806a"), "accent": Color("#ebe0c9")}
		"v0239_mailbox":
			return {"fill": Color("#d95745"), "edge": Color("#8e3e34"), "accent": Color("#fff0cf")}
		"v0239_companion_ear":
			return {"fill": Color("#f0a65f"), "edge": Color("#b98539"), "accent": Color("#fff0b5")}
		"v0239_companion_tail":
			return {"fill": Color("#f0a65f"), "edge": Color("#b98539"), "accent": Color("#fff0b5")}
		"v0239_companion_collar":
			return {"fill": Color("#7fc36d"), "edge": Color("#4f8847"), "accent": Color("#dff2cf")}
		"v0239_icon_look":
			return {"fill": Color("#f2c671"), "edge": Color("#b98539"), "accent": Color("#fff0b5")}
		"v0239_icon_map":
			return {"fill": Color("#8ac6a8"), "edge": Color("#4d8c70"), "accent": Color("#ffe08a")}
		"v0239_icon_home":
			return {"fill": Color("#e99059"), "edge": Color("#8a5f39"), "accent": Color("#fff1cb")}
		"v0239_icon_album":
			return {"fill": Color("#ef8da0"), "edge": Color("#b95368"), "accent": Color("#fff1cb")}
		_:
			return {"fill": Color("#ffffff"), "edge": Color("#d8d8d8"), "accent": Color("#f4f4f4")}


func _paint_rounded_rect_texture(image: Image, rect: Rect2i, radius: int, fill: Color, edge: Color, accent: Color) -> void:
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		for x in range(rect.position.x, rect.position.x + rect.size.x):
			var dx: int = max(rect.position.x + radius - x, 0, x - (rect.position.x + rect.size.x - radius - 1))
			var dy: int = max(rect.position.y + radius - y, 0, y - (rect.position.y + rect.size.y - radius - 1))
			if dx * dx + dy * dy > radius * radius:
				continue
			var is_edge := x <= rect.position.x + 2 or y <= rect.position.y + 2 or x >= rect.position.x + rect.size.x - 3 or y >= rect.position.y + rect.size.y - 3
			image.set_pixel(x, y, edge if is_edge else fill)
	for x in range(rect.position.x + 12, rect.position.x + rect.size.x - 12):
		image.set_pixel(x, rect.position.y + 12, accent)


func _paint_ellipse_texture(image: Image, center: Vector2, radius: Vector2, fill: Color, edge: Color, accent: Color) -> void:
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var normalized := Vector2((float(x) - center.x) / max(radius.x, 1.0), (float(y) - center.y) / max(radius.y, 1.0))
			var distance := normalized.length_squared()
			if distance > 1.0:
				continue
			image.set_pixel(x, y, edge if distance > 0.78 else fill)
	for x in range(int(center.x - radius.x * 0.45), int(center.x + radius.x * 0.45)):
		var y := int(center.y - radius.y * 0.32)
		if Rect2i(Vector2i.ZERO, image.get_size()).has_point(Vector2i(x, y)):
			image.set_pixel(x, y, accent)


func _paint_dots(image: Image, dot_color: Color, step: int) -> void:
	for y in range(10, image.get_height() - 8, step):
		for x in range(8 + (y % 3), image.get_width() - 8, step + 3):
			if image.get_pixel(x, y).a > 0.0:
				image.set_pixel(x, y, dot_color)


func _paint_grass_blades(image: Image, blade_color: Color, step: int) -> void:
	for y in range(12, image.get_height() - 9, step):
		for x in range(10 + (y % 5), image.get_width() - 10, step + 2):
			for offset in range(3):
				var point := Vector2i(x + offset, y - offset)
				if Rect2i(Vector2i.ZERO, image.get_size()).has_point(point) and image.get_pixel(point.x, point.y).a > 0.0:
					image.set_pixel(point.x, point.y, blade_color)


func _paint_grass_tuft_texture(image: Image, fill: Color, edge: Color, accent: Color) -> void:
	for blade in [
		[Vector2i(16, 50), Vector2i(25, 18)],
		[Vector2i(26, 51), Vector2i(31, 13)],
		[Vector2i(36, 51), Vector2i(37, 17)],
		[Vector2i(47, 50), Vector2i(40, 22)],
	]:
		_paint_line_texture(image, blade[0], blade[1], edge, 2)
		_paint_line_texture(image, blade[0] + Vector2i(1, 0), blade[1] + Vector2i(1, 0), fill, 1)
	_paint_ellipse_texture(image, Vector2(32, 51), Vector2(22, 6), fill.darkened(0.08), edge, accent)


func _paint_crop_leaf_texture(image: Image, fill: Color, edge: Color, accent: Color) -> void:
	_paint_ellipse_texture(image, Vector2(24, 34), Vector2(14, 22), fill, edge, accent)
	_paint_ellipse_texture(image, Vector2(40, 32), Vector2(13, 20), fill.lightened(0.05), edge, accent)
	_paint_ellipse_texture(image, Vector2(32, 42), Vector2(8, 8), accent, edge.darkened(0.08), accent.lightened(0.1))
	_paint_line_texture(image, Vector2i(32, 52), Vector2i(32, 22), edge.darkened(0.05), 1)


func _paint_line_texture(image: Image, from: Vector2i, to: Vector2i, color: Color, width: int) -> void:
	var delta := to - from
	var steps: int = maxi(maxi(abs(delta.x), abs(delta.y)), 1)
	for i in range(steps + 1):
		var t := float(i) / float(steps)
		var point := Vector2i(roundi(lerpf(from.x, to.x, t)), roundi(lerpf(from.y, to.y, t)))
		for oy in range(-width, width + 1):
			for ox in range(-width, width + 1):
				var pixel := point + Vector2i(ox, oy)
				if Rect2i(Vector2i.ZERO, image.get_size()).has_point(pixel):
					image.set_pixel(pixel.x, pixel.y, color)


func _paint_window_texture(image: Image, fill: Color, edge: Color, accent: Color, round_window: bool) -> void:
	if round_window:
		_paint_ellipse_texture(image, Vector2(32, 32), Vector2(23, 21), fill, edge, accent)
	else:
		_paint_rounded_rect_texture(image, Rect2i(11, 10, 42, 42), 6, fill, edge, accent)
	for x in range(18, 47):
		if Rect2i(Vector2i.ZERO, image.get_size()).has_point(Vector2i(x, 32)) and image.get_pixel(x, 32).a > 0.0:
			image.set_pixel(x, 32, edge)
	for y in range(17, 48):
		if Rect2i(Vector2i.ZERO, image.get_size()).has_point(Vector2i(32, y)) and image.get_pixel(32, y).a > 0.0:
			image.set_pixel(32, y, edge)


func _paint_lantern_texture(image: Image, fill: Color, edge: Color, accent: Color) -> void:
	_paint_line_texture(image, Vector2i(32, 8), Vector2i(32, 18), edge, 1)
	_paint_ellipse_texture(image, Vector2(32, 35), Vector2(15, 20), fill, edge, accent)
	_paint_ellipse_texture(image, Vector2(26, 30), Vector2(5, 8), accent, edge, accent.lightened(0.05))


func _paint_flower_box_texture(image: Image, fill: Color, edge: Color, accent: Color) -> void:
	_paint_rounded_rect_texture(image, Rect2i(8, 31, 48, 18), 5, fill, edge, fill.lightened(0.08))
	for point in [Vector2(17, 27), Vector2(27, 24), Vector2(37, 26), Vector2(46, 27)]:
		_paint_ellipse_texture(image, point, Vector2(5, 5), Color("#ee88a6"), Color("#bf5d7e"), accent)


func _paint_steps_texture(image: Image, fill: Color, edge: Color, accent: Color) -> void:
	_paint_rounded_rect_texture(image, Rect2i(8, 15, 48, 14), 4, fill.lightened(0.08), edge, accent)
	_paint_rounded_rect_texture(image, Rect2i(5, 29, 54, 16), 5, fill, edge, accent)
	_paint_rounded_rect_texture(image, Rect2i(2, 44, 60, 12), 5, fill.darkened(0.04), edge, accent)


func _paint_mailbox_texture(image: Image, fill: Color, edge: Color, accent: Color) -> void:
	_paint_rounded_rect_texture(image, Rect2i(13, 12, 38, 27), 8, fill, edge, accent)
	for x in range(21, 43):
		image.set_pixel(x, 25, accent)
	_paint_rounded_rect_texture(image, Rect2i(28, 39, 8, 20), 2, Color("#7d513a"), Color("#5b3b2a"), Color("#a86a42"))


func _paint_icon_disc_texture(image: Image, fill: Color, edge: Color, accent: Color, icon_kind: String) -> void:
	_paint_rounded_rect_texture(image, Rect2i(6, 6, 52, 52), 12, Color("#fffaf0"), Color("#e6d7bd"), Color("#ffffff"))
	match icon_kind:
		"look":
			_paint_ellipse_texture(image, Vector2(32, 31), Vector2(19, 13), fill, edge, accent)
			_paint_ellipse_texture(image, Vector2(32, 31), Vector2(7, 7), edge.darkened(0.05), edge, accent)
		"map":
			_paint_rounded_rect_texture(image, Rect2i(16, 16, 32, 32), 4, fill, edge, accent)
			_paint_ellipse_texture(image, Vector2(36, 28), Vector2(7, 9), accent, edge, accent.lightened(0.08))
		"home":
			_paint_rounded_rect_texture(image, Rect2i(18, 29, 28, 18), 4, accent, edge, accent.lightened(0.06))
			_paint_line_texture(image, Vector2i(16, 30), Vector2i(32, 17), edge, 2)
			_paint_line_texture(image, Vector2i(32, 17), Vector2i(48, 30), edge, 2)
		"album":
			_paint_rounded_rect_texture(image, Rect2i(18, 14, 28, 36), 5, fill, edge, accent)
			_paint_ellipse_texture(image, Vector2(32, 32), Vector2(10, 10), accent, edge, accent.lightened(0.06))


func _paint_roof_lines(image: Image, line_color: Color) -> void:
	for y in range(16, 54, 10):
		for x in range(10, 54):
			if image.get_pixel(x, y).a > 0.0:
				image.set_pixel(x, y, line_color)


func _paint_house_siding(image: Image, line_color: Color) -> void:
	for y in range(18, 50, 12):
		for x in range(12, 52):
			if image.get_pixel(x, y).a > 0.0:
				image.set_pixel(x, y, line_color)


func _paint_fence_texture(image: Image, fill: Color, edge: Color) -> void:
	image.fill(Color(0, 0, 0, 0))
	for post_x in [8, 24, 40, 56]:
		for y in range(10, 54):
			for x in range(post_x - 3, post_x + 4):
				image.set_pixel(clampi(x, 0, 63), y, edge if abs(x - post_x) == 3 else fill)
	for y in [22, 39]:
		for x in range(6, 59):
			image.set_pixel(x, y, edge)
			image.set_pixel(x, y + 1, fill)


func _can_resolve_texture_key(texture_key: String) -> bool:
	var spec: Dictionary = _logical_asset_texture_keys.get(texture_key, {})
	if spec.is_empty():
		return false
	var resolved: Dictionary = AssetResolverScript.resolve_asset(
		AssetResolverScript.DEFAULT_THEME_ID,
		str(spec.get("category", "")),
		str(spec.get("asset_id", ""))
	)
	return resolved.get("ok", false) and FileAccess.file_exists(str(resolved.get("placeholder_path", "")))


func _place_prefab_texture_key_for_place(place_id: String) -> String:
	match place_id:
		"place_home":
			return "building_prefab_home"
		"place_supermarket":
			return "building_prefab_shop"
		"place_school_gate":
			return "building_prefab_school_gate"
		_:
			return ""


func _get_resolved_asset_texture(texture_key: String) -> Texture2D:
	var spec: Dictionary = _logical_asset_texture_keys.get(texture_key, {})
	if spec.is_empty():
		return null
	var resolved: Dictionary = AssetResolverScript.resolve_asset(
		AssetResolverScript.DEFAULT_THEME_ID,
		str(spec.get("category", "")),
		str(spec.get("asset_id", ""))
	)
	if not resolved.get("ok", false):
		return null
	var asset_path := str(resolved.get("placeholder_path", ""))
	if not FileAccess.file_exists(asset_path):
		return null
	if asset_path.get_extension().to_lower() == "png" and not FileAccess.file_exists("%s.import" % asset_path):
		return _load_image_texture(asset_path)
	var loaded_texture := ResourceLoader.load(asset_path) as Texture2D
	if loaded_texture != null:
		return loaded_texture
	return _load_image_texture(asset_path)


func _load_image_texture(asset_path: String) -> Texture2D:
	var image := Image.new()
	var load_error := image.load(asset_path)
	if load_error != OK:
		return null
	return ImageTexture.create_from_image(image)


func _texture_colors(texture_key: String) -> Dictionary:
	if texture_key == "ground":
		return {"fill": Color("#dff0d1"), "edge": Color("#d5e8c7"), "accent": Color("#e8f6da")}
	if texture_key == "soft_horizon":
		return {"fill": Color("#f7ffe433"), "edge": Color("#f7ffe400"), "accent": Color("#ffffff22")}
	if texture_key == "mapread_home_school_zone":
		return {"fill": Color("#e8f6d655"), "edge": Color("#9fcf9b55"), "accent": Color("#fffdf055")}
	if texture_key == "mapread_town_ring_zone":
		return {"fill": Color("#f8e5ad44"), "edge": Color("#d6af5c55"), "accent": Color("#fff2bc55")}
	if texture_key == "mapread_far_edge_zone":
		return {"fill": Color("#dce8ef44"), "edge": Color("#86a8b755"), "accent": Color("#f6fbff55")}
	if texture_key == "road":
		return {"fill": ROAD_COLOR, "edge": Color("#caa66b"), "accent": Color("#ead39a")}
	if texture_key == "pond":
		return {"fill": WATER_COLOR, "edge": Color("#76b6bf"), "accent": Color("#d7f4f2")}
	if texture_key == "plaza":
		return {"fill": Color("#f2dda2"), "edge": Color("#d1b56f"), "accent": Color("#ffe9ad")}
	if texture_key == "flower":
		return {"fill": FLOWER_COLOR, "edge": Color("#bd5775"), "accent": Color("#ffe7a0")}
	if texture_key == "tree_trunk":
		return {"fill": Color("#9b6b46"), "edge": Color("#735039"), "accent": Color("#ba8459")}
	if texture_key == "tree_crown":
		return {"fill": Color("#77b96c"), "edge": Color("#558d52"), "accent": Color("#9fd784")}
	if texture_key == "shadow":
		return {"fill": Color("#30453544"), "edge": Color("#30453522"), "accent": Color("#30453522")}
	if texture_key.begins_with("place_"):
		if texture_key.ends_with("_roof"):
			var roof_place := texture_key.trim_prefix("place_").trim_suffix("_roof")
			return {"fill": _place_roof_color(roof_place), "edge": Color("#8f6a45"), "accent": _place_roof_color(roof_place).lightened(0.18)}
		var body_place := texture_key.trim_prefix("place_").trim_suffix("_body")
		return {"fill": _place_color(body_place), "edge": Color("#7fa6a0"), "accent": _place_color(body_place).lightened(0.16)}
	if texture_key.begins_with("door_"):
		return {"fill": Color("#8f6244"), "edge": Color("#67452f"), "accent": Color("#d8b174")}
	if texture_key.begins_with("window_"):
		return {"fill": Color("#dff7ff"), "edge": Color("#78aac1"), "accent": Color("#ffffff")}
	if texture_key == "plaza_stool":
		return {"fill": Color("#b98258"), "edge": Color("#73503a"), "accent": Color("#e5bd82")}
	if texture_key == "plaza_snack_crate":
		return {"fill": Color("#d6a45d"), "edge": Color("#8f6844"), "accent": Color("#fff2a8")}
	if texture_key == "anchor_shop_sign":
		return {"fill": Color("#f5c85c"), "edge": Color("#a76f3c"), "accent": Color("#fff2a8")}
	if texture_key == "plaza_flag":
		return {"fill": Color("#f0a34f"), "edge": Color("#8f6a45"), "accent": Color("#fff2a8")}
	if texture_key == "plaza_bench":
		return {"fill": Color("#b98258"), "edge": Color("#73503a"), "accent": Color("#e5bd82")}
	if texture_key == "plaza_flower_basket":
		return {"fill": Color("#d88f57"), "edge": Color("#8f5c3f"), "accent": Color("#f5d86f")}
	if texture_key == "plaza_notice_board":
		return {"fill": Color("#f3d48a"), "edge": Color("#8c6844"), "accent": Color("#fff8d5")}
	if texture_key == "plaza_tiny_lamp":
		return {"fill": Color("#f6e4a2"), "edge": Color("#76634c"), "accent": Color("#fff9cf")}
	if texture_key == "hotspot_glow":
		return {"fill": Color("#fff0a877"), "edge": Color("#fff0a822"), "accent": Color("#ffffffaa")}
	if texture_key == "home_floor":
		return {"fill": Color("#f0d49c"), "edge": Color("#c9a46b"), "accent": Color("#ffe6ad")}
	if texture_key == "home_wall":
		return {"fill": Color("#ffe8bd"), "edge": Color("#d7b06f"), "accent": Color("#fff4d9")}
	if texture_key == "home_grid_cell":
		return {"fill": Color("#f8e8c244"), "edge": Color("#d1ae7344"), "accent": Color("#fff8df55")}
	if texture_key == "home_sunlight_patch":
		return {"fill": Color("#fff0a866"), "edge": Color("#fff6cf22"), "accent": Color("#fffce0aa")}
	if texture_key == "home_window":
		return {"fill": Color("#dff7ff"), "edge": Color("#8db8c8"), "accent": Color("#ffffff")}
	if texture_key == "home_wall_clock":
		return {"fill": Color("#f6e2a6"), "edge": Color("#8f7350"), "accent": Color("#5d6b6d")}
	if texture_key == "home_shelf":
		return {"fill": Color("#b77d52"), "edge": Color("#765139"), "accent": Color("#f1d19b")}
	if texture_key == "home_welcome_mat":
		return {"fill": Color("#9ec7a4"), "edge": Color("#5d8d67"), "accent": Color("#f5e9b4")}
	if texture_key == "home_pet_corner":
		return {"fill": Color("#f4d58d"), "edge": Color("#c09a51"), "accent": Color("#fff4d0")}
	if texture_key.begins_with("home_item_"):
		return _home_item_texture_colors(texture_key.trim_prefix("home_item_"))
	if texture_key.begins_with("npc_"):
		var npc_id := texture_key.trim_prefix("npc_").trim_suffix("_body").trim_suffix("_head").trim_suffix("_ear_left").trim_suffix("_ear_right")
		return {"fill": _npc_color(npc_id), "edge": _npc_color(npc_id).darkened(0.25), "accent": _npc_color(npc_id).lightened(0.2)}
	if texture_key == "face_dot":
		return {"fill": Color("#273034"), "edge": Color("#273034"), "accent": Color("#273034")}
	if texture_key == "player_body":
		return {"fill": PLAYER_COLOR, "edge": Color("#3f6091"), "accent": Color("#90b6e4")}
	if texture_key == "player_head":
		return {"fill": Color("#f0c9a2"), "edge": Color("#a97757"), "accent": Color("#ffdcb8")}
	if texture_key.begins_with("anchor_"):
		return _anchor_texture_colors(texture_key)
	if texture_key.begins_with("reserved_anchor_"):
		return {"fill": Color("#e9eee3aa"), "edge": Color("#c1cbca99"), "accent": Color("#f7faf4aa")}
	return {"fill": Color("#ffffff"), "edge": Color("#d8d8d8"), "accent": Color("#f4f4f4")}


func _home_item_texture_colors(item_id: String) -> Dictionary:
	match item_id:
		"wooden_chair", "small_table":
			return {"fill": Color("#b77d52"), "edge": Color("#765139"), "accent": Color("#e1b37c")}
		"soft_rug":
			return {"fill": Color("#f1b7c8"), "edge": Color("#bc7892"), "accent": Color("#ffe4ed")}
		"flower_pot":
			return {"fill": Color("#d88f57"), "edge": Color("#8f5c3f"), "accent": Color("#78b76a")}
		"pet_bowl":
			return {"fill": Color("#9ccde3"), "edge": Color("#5b93ad"), "accent": Color("#fff4d0")}
		"sunny_bed":
			return {"fill": Color("#f2c76a"), "edge": Color("#b98539"), "accent": Color("#fff0b5")}
		"wall_decoration":
			return {"fill": Color("#d9c484"), "edge": Color("#7c6f4b"), "accent": Color("#fff5c7")}
		"book_stack":
			return {"fill": Color("#8fb9c9"), "edge": Color("#557a8e"), "accent": Color("#fff5c7")}
		"sunny_toy":
			return {"fill": Color("#f2a86f"), "edge": Color("#b56a43"), "accent": Color("#fff0b5")}
		"warm_cup":
			return {"fill": Color("#f7f0d8"), "edge": Color("#b68e62"), "accent": Color("#d9b78a")}
		_:
			return {"fill": Color("#d8c7a3"), "edge": Color("#8f7b5d"), "accent": Color("#fff5d8")}


func _anchor_texture_colors(texture_key: String) -> Dictionary:
	if texture_key == "anchor_apple_tree":
		return {"fill": Color("#78b76a"), "edge": Color("#4f8f50"), "accent": Color("#e85c4a")}
	if texture_key == "anchor_bear_plush":
		return {"fill": Color("#b8795c"), "edge": Color("#7a4d3c"), "accent": Color("#f1c8aa")}
	if texture_key == "anchor_clock":
		return {"fill": Color("#f2dfa5"), "edge": Color("#9c7d4e"), "accent": Color("#5c6670")}
	if texture_key == "anchor_doghouse":
		return {"fill": Color("#d7835d"), "edge": Color("#8d4d3e"), "accent": Color("#f5d293")}
	if texture_key == "anchor_kite":
		return {"fill": Color("#9fc9e6"), "edge": Color("#558ab2"), "accent": Color("#f2d36c")}
	if texture_key == "anchor_orange_stand":
		return {"fill": Color("#f1a34c"), "edge": Color("#ab6a32"), "accent": Color("#ffdc7a")}
	if texture_key == "anchor_sun":
		return {"fill": Color("#f2d36c"), "edge": Color("#c08f38"), "accent": Color("#fff2a8")}
	if texture_key == "anchor_taxi_stop":
		return {"fill": Color("#f0c94c"), "edge": Color("#3a3a37"), "accent": Color("#ffffff")}
	if texture_key == "anchor_watch_sign":
		return {"fill": Color("#d9c484"), "edge": Color("#7c6f4b"), "accent": Color("#f6f0cd")}
	return {"fill": _anchor_object_color(texture_key.trim_prefix("anchor_")), "edge": Color("#9f7e48"), "accent": Color("#ffffffaa")}


func _create_anchor_object_sprite(letter: String) -> Sprite2D:
	var texture_key := _anchor_texture_key_for_letter(letter)
	var sprite := _create_sprite("ObjectSprite", Vector2.ZERO, Vector2(MAP_CELL_SIZE * 1.22, MAP_CELL_SIZE * 1.08), texture_key)
	sprite.modulate = Color(1, 1, 1, 1.0)
	return sprite


func _anchor_texture_key_for_letter(letter: String) -> String:
	var texture_keys: Dictionary = {
		"A": "anchor_a_apple_tree",
		"B": "anchor_b_bear_corner",
		"C": "anchor_c_clock",
		"D": "anchor_d_dog_corner",
		"E": "anchor_e_elephant_slide",
		"F": "anchor_f_fox_topiary",
		"G": "anchor_g_school_gate",
		"H": "anchor_h_hat_sign",
		"I": "anchor_i_ice_cream_cart",
		"J": "anchor_j_jacket_window",
		"K": "anchor_k_kite",
		"L": "anchor_l_lion_fountain",
		"M": "anchor_m_monkey_tree",
		"N": "anchor_n_soft_net",
		"O": "anchor_o_orange_stall",
		"P": "anchor_p_panda_corner",
		"Q": "anchor_q_queen_poster",
		"R": "anchor_r_robot_sign",
		"S": "anchor_s_sun_landmark",
		"T": "anchor_t_taxi_marker",
		"U": "anchor_u_beach_umbrella",
		"V": "anchor_v_violin_corner",
		"W": "anchor_w_watch_table",
		"X": "anchor_x_x_mark_box",
		"Y": "anchor_y_yo_yo_corner",
		"Z": "anchor_z_zebra_edge",
	}
	return str(texture_keys.get(letter, "reserved_anchor_%s" % letter))


func _create_anchor_letter_badge(anchor: Dictionary) -> Label:
	var letter := str(anchor.get("letter", ""))
	var route_order := int(anchor.get("route_order", 1))
	var badge := Label.new()
	badge.name = "LetterBadge"
	badge.text = letter
	badge.custom_minimum_size = Vector2(22, 22)
	badge.size = Vector2(20, 20)
	badge.position = _anchor_badge_offset(route_order, letter)
	badge.modulate = Color(1, 1, 1, 0.48)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.z_index = 4
	badge.add_theme_color_override("font_color", Color("#44584fcc"))
	badge.add_theme_font_size_override("font_size", 12)
	badge.add_theme_stylebox_override("normal", _rounded_box(Color("#fff8cf55"), 7, Color("#9f7a2e33")))
	return badge


func _anchor_badge_offset(route_order: int, letter: String = "") -> Vector2:
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


func _add_town_scenery(map: Node2D, map_width: int, map_height: int) -> void:
	map.add_child(_create_map_readability_layer())

	for cell in [Vector2i(7, 6), Vector2i(15, 18), Vector2i(22, 24), Vector2i(39, 18), Vector2i(47, 27), Vector2i(55, 26)]:
		var flower := Node2D.new()
		flower.name = "FlowerPatch"
		flower.modulate = Color(1, 1, 1, 0.08)
		flower.position = Vector2(cell.x + 0.5, cell.y + 0.5) * MAP_CELL_SIZE
		flower.add_child(_create_sprite("Petals", Vector2.ZERO, Vector2(15, 13), "flower"))
		map.add_child(flower)

	for cell in [Vector2i(12, 4), Vector2i(9, 15), Vector2i(24, 11), Vector2i(38, 25), Vector2i(50, 20), Vector2i(58, 27)]:
		var tree := Node2D.new()
		tree.name = "RoundTree"
		tree.modulate = Color(1, 1, 1, 0.08)
		tree.position = Vector2(cell.x + 0.72, cell.y + 0.72) * MAP_CELL_SIZE
		tree.add_child(_create_sprite("Trunk", Vector2(0, 13), Vector2(8, 18), "tree_trunk"))
		tree.add_child(_create_sprite("Crown", Vector2(0, -2), Vector2(MAP_CELL_SIZE * 1.5, MAP_CELL_SIZE * 1.42), "tree_crown"))
		map.add_child(tree)


func _create_map_readability_layer() -> Node2D:
	var layer := Node2D.new()
	layer.name = "MapReadabilityLayer"
	layer.z_index = -2
	layer.modulate = Color(1, 1, 1, 0.34)
	layer.add_child(_create_mapread_zone("MapReadZoneSun", Vector2(8.0, 3.0) * MAP_CELL_SIZE, Vector2(10.0, 4.0) * MAP_CELL_SIZE, "mapread_sun_scene_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneSchoolGate", Vector2(20.5, 11.0) * MAP_CELL_SIZE, Vector2(7.0, 5.0) * MAP_CELL_SIZE, "mapread_school_gate_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneSchoolYard", Vector2(17.0, 11.8) * MAP_CELL_SIZE, Vector2(12.0, 10.0) * MAP_CELL_SIZE, "mapread_school_yard_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneWalk", Vector2(24.0, 14.7) * MAP_CELL_SIZE, Vector2(6.0, 5.0) * MAP_CELL_SIZE, "mapread_home_school_walk_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneStory", Vector2(15.5, 22.0) * MAP_CELL_SIZE, Vector2(13.0, 10.0) * MAP_CELL_SIZE, "mapread_story_culture_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneHome", Vector2(31.0, 18.0) * MAP_CELL_SIZE, Vector2(12.0, 12.0) * MAP_CELL_SIZE, "mapread_home_yard_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneShop", Vector2(48.0, 10.5) * MAP_CELL_SIZE, Vector2(16.0, 11.0) * MAP_CELL_SIZE, "mapread_shop_street_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneAnimal", Vector2(47.5, 25.0) * MAP_CELL_SIZE, Vector2(17.0, 12.0) * MAP_CELL_SIZE, "mapread_animal_park_zone"))
	layer.add_child(_create_mapread_zone("MapReadZoneCoast", Vector2(55.5, 30.0) * MAP_CELL_SIZE, Vector2(7.0, 4.0) * MAP_CELL_SIZE, "mapread_coast_edge_zone"))
	layer.add_child(_create_mapread_sign("MapReadSignSun", Vector2(5.0, 2.1) * MAP_CELL_SIZE, "太阳"))
	layer.add_child(_create_mapread_sign("MapReadSignSchool", Vector2(17.5, 6.2) * MAP_CELL_SIZE, "学校"))
	layer.add_child(_create_mapread_sign("MapReadSignStory", Vector2(11.0, 18.5) * MAP_CELL_SIZE, "故事桥"))
	layer.add_child(_create_mapread_sign("MapReadSignHome", Vector2(28.0, 13.2) * MAP_CELL_SIZE, "回家"))
	layer.add_child(_create_mapread_sign("MapReadSignShop", Vector2(43.0, 6.2) * MAP_CELL_SIZE, "商店街"))
	layer.add_child(_create_mapread_sign("MapReadSignAnimal", Vector2(41.0, 20.0) * MAP_CELL_SIZE, "动物公园"))
	layer.add_child(_create_mapread_sign("MapReadSignCoast", Vector2(53.0, 29.2) * MAP_CELL_SIZE, "海边"))
	return layer


func _create_mapread_zone(zone_name: String, zone_position: Vector2, zone_size: Vector2, texture_key: String) -> Sprite2D:
	var zone := _create_sprite(zone_name, zone_position, zone_size, texture_key)
	zone.z_index = -2
	zone.modulate = Color(1, 1, 1, 0.0)
	return zone


func _create_mapread_sign(sign_name: String, sign_position: Vector2, text: String) -> Label:
	var sign_label := Label.new()
	sign_label.name = sign_name
	sign_label.text = text
	sign_label.position = sign_position
	sign_label.custom_minimum_size = Vector2(78, 24)
	sign_label.size = Vector2(78, 24)
	sign_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sign_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sign_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sign_label.z_index = 9
	sign_label.add_theme_color_override("font_color", Color("#284238"))
	sign_label.add_theme_font_size_override("font_size", 13)
	sign_label.add_theme_stylebox_override("normal", _rounded_box(Color("#fffdf0dd"), 8, Color("#8ab18d")))
	return sign_label


func _mapread_layer_for_anchor(letter: String) -> String:
	if ["A", "C", "D", "T", "W", "G", "K", "N", "R", "Y", "S"].has(letter):
		return "p0_center"
	if ["B", "Q", "V", "H", "I", "J", "O"].has(letter):
		return "first_ring"
	if ["E", "F", "L", "M", "P", "Z"].has(letter):
		return "second_ring"
	if ["U", "X"].has(letter):
		return "far_edge"
	return "reserved"


func _mapread_screenshot_group_for_anchor(letter: String) -> String:
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


func _place_color(place_id: String) -> Color:
	match place_id:
		"place_home":
			return Color("#ffd98e")
		"place_town_start":
			return Color("#f7e6a6")
		"place_supermarket":
			return Color("#b9dcf0")
		_:
			return PLACE_COLOR


func _place_roof_color(place_id: String) -> Color:
	match place_id:
		"place_home":
			return Color("#d7835d")
		"place_town_start":
			return Color("#9eb76d")
		"place_supermarket":
			return Color("#5f9fc4")
		_:
			return Color("#b99268")


func _place_icon(place_id: String) -> String:
	match place_id:
		"place_home":
			return "温暖小屋"
		"place_town_start":
			return "小镇广场"
		"place_supermarket":
			return "街角商店"
		_:
			return "小地点"


func _npc_icon(npc_id: String) -> String:
	match npc_id:
		"mina":
			return "Mina"
		"shopkeeper":
			return "店长"
		"pet_buddy":
			return "Sunny"
		"bus_helper":
			return "巴士"
		"story_bear":
			return "熊熊"
		_:
			return "你好"


func _npc_color(npc_id: String) -> Color:
	match npc_id:
		"mina":
			return Color("#d98578")
		"shopkeeper":
			return Color("#a36d4f")
		"pet_buddy":
			return Color("#e0a14d")
		"bus_helper":
			return Color("#5a94b6")
		"story_bear":
			return Color("#b8795c")
		_:
			return NPC_COLOR


func _anchor_object_label(letter: String, core_word: String) -> String:
	match letter:
		"A":
			return "Apple"
		"B":
			return "Bear"
		"C":
			return "Clock"
		"D":
			return "Dog"
		"K":
			return "Kite"
		"O":
			return "Orange"
		"S":
			return "Sun"
		"T":
			return "Taxi"
		"W":
			return "Watch"
		_:
			if core_word.is_empty():
				return "Keepsake"
			return core_word


func _anchor_object_color(letter: String) -> Color:
	match letter:
		"A", "O":
			return Color("#f1b85c")
		"B", "D":
			return Color("#c98b68")
		"C", "W":
			return Color("#d9c484")
		"K":
			return Color("#9fc9e6")
		"S":
			return Color("#f2d36c")
		"T":
			return Color("#e8b05b")
		_:
			return Color("#e9eee3")


func _cell_position(cell: Dictionary) -> Vector2:
	return Vector2(
		int(cell.get("x", 0)) * MAP_CELL_SIZE,
		int(cell.get("y", 0)) * MAP_CELL_SIZE
	)


func _cell_center(cell: Dictionary) -> Vector2:
	return _cell_position(cell) + Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE) * 0.5


func _dict_to_cell(cell: Variant) -> Vector2i:
	if cell is Vector2i:
		return cell
	if cell is Dictionary:
		var cell_dict: Dictionary = cell
		return Vector2i(int(cell_dict.get("x", 0)), int(cell_dict.get("y", 0)))
	return Vector2i.ZERO


func _cell_to_dict(cell: Vector2i) -> Dictionary:
	return {"x": cell.x, "y": cell.y}


func _remap_legacy_runtime_cell(cell: Vector2i) -> Vector2i:
	var redirects: Dictionary = {
		"2,3": Vector2i(28, 16),
		"4,7": Vector2i(28, 17),
		"5,7": Vector2i(31, 19),
		"5,8": Vector2i(31, 20),
		"6,8": Vector2i(28, 20),
		"7,11": Vector2i(16, 8),
		"8,11": Vector2i(24, 15),
		"9,12": Vector2i(16, 9),
		"11,13": Vector2i(21, 12),
		"11,15": Vector2i(19, 15),
		"12,6": Vector2i(17, 18),
		"12,7": Vector2i(16, 18),
		"13,6": Vector2i(19, 18),
		"13,7": Vector2i(18, 19),
		"14,10": Vector2i(38, 22),
		"15,10": Vector2i(38, 22),
		"16,4": Vector2i(9, 5),
		"17,2": Vector2i(7, 3),
		"23,5": Vector2i(51, 10),
		"24,9": Vector2i(41, 11),
		"24,10": Vector2i(41, 11),
		"31,10": Vector2i(34, 21),
		"31,11": Vector2i(35, 20),
		"32,9": Vector2i(34, 20),
		"32,11": Vector2i(35, 20),
		"32,12": Vector2i(36, 20),
		"33,13": Vector2i(54, 30),
	}
	return redirects.get("%s,%s" % [cell.x, cell.y], cell)


func _update_player_marker() -> void:
	if is_instance_valid(town_stage) and town_stage.has_method("update_player_marker"):
		town_stage.call("update_player_marker", player_world_position)
		if town_stage.has_method("set_player_motion_state"):
			town_stage.call("set_player_motion_state", player_facing, player_is_walking)
	elif is_instance_valid(player_marker):
		player_marker.position = player_world_position
	_update_camera_for_player()


func _load_player_cell() -> Vector2i:
	var game_state: Dictionary = save_service.load_game_state()
	if game_state.get("player_cell") is Dictionary:
		return _remap_legacy_runtime_cell(_dict_to_cell(game_state.get("player_cell", {})))
	return PLAYER_START_CELL


func _save_player_cell() -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["player_cell"] = _cell_to_dict(player_cell)
	game_state["current_place_id"] = _current_place_for_cell(player_cell)
	save_service.save_game_state(game_state)


func _current_place_for_cell(cell: Vector2i) -> String:
	for place in world_map.get("places", []):
		var place_position := _dict_to_cell(place.get("position", {}))
		var size_data: Dictionary = place.get("size", {"w": 1, "h": 1})
		var place_size := Vector2i(int(size_data.get("w", 1)), int(size_data.get("h", 1)))
		if cell.x >= place_position.x and cell.x < place_position.x + place_size.x and cell.y >= place_position.y and cell.y < place_position.y + place_size.y:
			return str(place.get("place_id", ""))
	return "town_walk"


func _walk_status_for_cell(cell: Vector2i) -> String:
	var place_id := _current_place_for_cell(cell)
	var exact_interaction := _find_interaction_at_cell(cell)
	if not exact_interaction.is_empty():
		place_id = str(exact_interaction.get("place_id", place_id))
	_update_arrival_proof(place_id)
	match place_id:
		"place_home":
			return "走到小屋旁边啦。"
		"place_town_start":
			return "来到阳光小镇广场。"
		"place_supermarket":
			return "来到街角商店旁边。"
		"place_school_gate":
			return "来到 School Gate，校门旁很安静。"
		"place_school_yard":
			return "来到 School Yard，操场角落可以慢慢看看。"
		_:
			return "正在阳光小镇散步。"


func _is_cell_walkable(cell: Vector2i) -> bool:
	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 40, "h": 24})
	if cell.x < 0 or cell.y < 0 or cell.x >= int(canvas_size.get("w", 40)) or cell.y >= int(canvas_size.get("h", 24)):
		return false
	for blocked in world_map.get("collision_cells", []):
		if _dict_to_cell(blocked) == cell:
			return false
	return true


func _build_walk_path(from_cell: Vector2i, target_cell: Vector2i) -> Array[Vector2i]:
	if from_cell == target_cell or not _is_cell_walkable(target_cell):
		return []
	var path: Array[Vector2i] = []
	var cursor := from_cell
	while cursor.x != target_cell.x:
		cursor.x += _axis_step(target_cell.x - cursor.x)
		if not _is_cell_walkable(cursor):
			return []
		path.append(cursor)
	while cursor.y != target_cell.y:
		cursor.y += _axis_step(target_cell.y - cursor.y)
		if not _is_cell_walkable(cursor):
			return []
		path.append(cursor)
	return path


func _axis_step(delta: int) -> int:
	if delta > 0:
		return 1
	if delta < 0:
		return -1
	return 0


func _advance_player_walk(delta: float) -> void:
	if not player_is_walking or player_walk_path.is_empty():
		_update_player_marker()
		return
	var next_cell := player_walk_path[0]
	var target_position := _cell_center(_cell_to_dict(next_cell))
	var step_distance := PLAYER_WALK_SPEED * delta
	player_world_position = player_world_position.move_toward(target_position, step_distance)
	if player_world_position.distance_to(target_position) <= 0.5:
		player_world_position = target_position
		player_cell = next_cell
		player_walk_path.pop_front()
		if player_walk_path.is_empty():
			player_is_walking = false
			_save_player_cell()
			_set_life_status(_walk_status_for_cell(player_cell))
			_update_interaction_prompt()
			held_move_cooldown = 0.08
		else:
			_update_player_facing_for_next_step()
	_update_player_marker()


func _update_player_facing_for_next_step() -> void:
	if player_walk_path.is_empty():
		return
	var delta := player_walk_path[0] - player_cell
	player_facing = Vector2i(clampi(delta.x, -1, 1), clampi(delta.y, -1, 1))


func _update_camera_for_player() -> void:
	if is_instance_valid(town_stage) and town_stage.has_method("update_camera_for_player"):
		town_stage.call("update_camera_for_player", player_world_position)
		return
	if not is_instance_valid(runtime_map_node) or not is_instance_valid(runtime_map_frame):
		return
	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 40, "h": 24})
	var map_width := int(canvas_size.get("w", 40)) * MAP_CELL_SIZE
	var map_height := int(canvas_size.get("h", 24)) * MAP_CELL_SIZE
	var frame_size := runtime_map_frame.size
	if frame_size.x <= 1.0 or frame_size.y <= 1.0:
		frame_size = MAP_RENDER_SIZE
	var scaled_map_size := Vector2(map_width, map_height) * runtime_map_node.scale
	var desired := frame_size * 0.5 - player_world_position * runtime_map_node.scale
	desired.x = clampf(desired.x, min(0.0, frame_size.x - scaled_map_size.x), 0.0)
	desired.y = clampf(desired.y, min(0.0, frame_size.y - scaled_map_size.y), 0.0)
	runtime_map_node.position = desired


func _screen_to_map_position(screen_position: Vector2) -> Vector2:
	if is_instance_valid(town_stage) and town_stage.has_method("screen_to_map_position"):
		return town_stage.call("screen_to_map_position", screen_position)
	if not is_instance_valid(runtime_map_node):
		return screen_position
	return (screen_position - runtime_map_node.position) / runtime_map_node.scale


func _on_town_stage_cell_requested(cell: Vector2i) -> void:
	var result: Dictionary = request_player_walk_to_cell(cell)
	if result.get("ok", false) and is_instance_valid(town_stage) and town_stage.has_method("show_tap_feedback_at_cell"):
		town_stage.call("show_tap_feedback_at_cell", cell)


func _on_map_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			var map_position := _screen_to_map_position(mouse_event.position)
			request_player_walk_to_cell(Vector2i(int(map_position.x / MAP_CELL_SIZE), int(map_position.y / MAP_CELL_SIZE)))


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event: InputEventKey = event
	var direction := _direction_for_keycode(key_event.keycode)
	if direction == Vector2i.ZERO:
		return
	if key_event.pressed:
		held_move_direction = direction
		if not key_event.echo and not player_is_walking:
			move_player_by_cells(direction)
	else:
		if held_move_direction == direction:
			held_move_direction = Vector2i.ZERO


func _update_held_movement(delta: float) -> void:
	if held_move_direction == Vector2i.ZERO:
		return
	held_move_cooldown = maxf(held_move_cooldown - delta, 0.0)
	if player_is_walking or held_move_cooldown > 0.0:
		return
	var result: Dictionary = move_player_by_cells(held_move_direction)
	if not result.get("ok", false):
		held_move_cooldown = 0.18


func simulate_held_move_for_test(direction: Vector2i, frames: int = 90) -> Dictionary:
	held_move_direction = direction
	var start_cell := player_cell
	for index in range(frames):
		_process(1.0 / 30.0)
	var end_cell := player_cell
	held_move_direction = Vector2i.ZERO
	return {
		"ok": end_cell != start_cell,
		"start_cell": _cell_to_dict(start_cell),
		"end_cell": _cell_to_dict(end_cell),
		"direction": _cell_to_dict(direction),
	}


func get_runtime_motion_snapshot() -> Dictionary:
	var stage_snapshot: Dictionary = {}
	if is_instance_valid(town_stage) and town_stage.has_method("get_runtime_motion_snapshot"):
		stage_snapshot = town_stage.call("get_runtime_motion_snapshot")
	return {
		"player_cell": _cell_to_dict(player_cell),
		"player_facing": _cell_to_dict(player_facing),
		"player_is_walking": player_is_walking,
		"held_move_direction": _cell_to_dict(held_move_direction),
		"stage": stage_snapshot,
		"prompt_glow_visible": is_instance_valid(interaction_prompt_glow) and interaction_prompt_glow.visible,
		"prompt_visible": is_instance_valid(interaction_prompt_label) and interaction_prompt_label.visible,
	}


func _direction_for_keycode(keycode: Key) -> Vector2i:
	match keycode:
		KEY_UP, KEY_W:
			return Vector2i(0, -1)
		KEY_DOWN, KEY_S:
			return Vector2i(0, 1)
		KEY_LEFT, KEY_A:
			return Vector2i(-1, 0)
		KEY_RIGHT, KEY_D:
			return Vector2i(1, 0)
		_:
			return Vector2i.ZERO


func _find_npc(npc_id: String) -> Dictionary:
	for npc in _active_npcs():
		if npc.get("npc_id", "") == npc_id:
			return npc
	return {}


func _find_place(place_id: String) -> Dictionary:
	for place in world_map.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			return place
	return {}


func _npc_profile(npc_id: String) -> Dictionary:
	if npc_memory_store == null:
		return {}
	return npc_memory_store.get_profile(npc_id)


func _npc_display_name(npc_id: String) -> String:
	var profile := _npc_profile(npc_id)
	return _localized_npc_name(npc_id, str(profile.get("display_name", npc_id)))


func _npc_line(npc_id: String) -> String:
	var profile := _npc_profile(npc_id)
	return str(profile.get("fallback_reply", "Let's keep exploring Sunshine Town together."))


func _localized_npc_name(npc_id: String, fallback: String) -> String:
	match npc_id:
		"mina":
			return "米娜"
		"shopkeeper":
			return "店长"
		"pet_buddy":
			return "Sunny"
		"bus_helper":
			return "巴士哥哥"
		"story_bear":
			return "故事熊"
		_:
			return fallback


func _find_nearest_npc(radius: int) -> Dictionary:
	var nearest: Dictionary = {}
	var nearest_distance := radius + 1
	for npc in _active_npcs():
		var distance := _manhattan_distance(player_cell, _dict_to_cell(npc.get("cell", {})))
		if distance <= radius and distance < nearest_distance:
			nearest = npc
			nearest_distance = distance
	return nearest


func _active_npcs() -> Array:
	if runtime_npcs.is_empty():
		return FIRST_NPCS.duplicate(true)
	return runtime_npcs


func _refresh_outdoor_decor_layer() -> void:
	if is_instance_valid(town_stage) and town_stage.has_method("render_outdoor_items"):
		town_stage.call("render_outdoor_items", outdoor_decoration_service.get_placed_items())


func _find_interaction_at_cell(cell: Vector2i) -> Dictionary:
	for interaction in world_map.get("interaction_cells", []):
		if _dict_to_cell(interaction.get("cell", {})) == cell:
			return interaction
	return {}


func _find_nearest_interaction(radius: int) -> Dictionary:
	var nearest: Dictionary = {}
	var nearest_distance := radius + 1
	for interaction in world_map.get("interaction_cells", []):
		var distance := _manhattan_distance(player_cell, _dict_to_cell(interaction.get("cell", {})))
		if distance <= radius and distance < nearest_distance:
			nearest = interaction
			nearest_distance = distance
	return nearest


func _find_story_prop_at_cell(cell: Vector2i) -> Dictionary:
	for story_prop_value in story_props:
		if not story_prop_value is Dictionary:
			continue
		var story_prop: Dictionary = story_prop_value
		if not bool(story_prop.get("visible_in_child_runtime", false)):
			continue
		if _dict_to_cell(story_prop.get("interaction_cell", story_prop.get("cell", {}))) == cell:
			return story_prop.duplicate(true)
	return {}


func _find_nearest_story_prop(radius: int) -> Dictionary:
	var nearest: Dictionary = {}
	var nearest_distance := radius + 1
	for story_prop_value in story_props:
		if not story_prop_value is Dictionary:
			continue
		var story_prop: Dictionary = story_prop_value
		if not bool(story_prop.get("visible_in_child_runtime", false)):
			continue
		var distance := _manhattan_distance(player_cell, _dict_to_cell(story_prop.get("interaction_cell", story_prop.get("cell", {}))))
		if distance <= radius and distance < nearest_distance:
			nearest = story_prop
			nearest_distance = distance
	return nearest.duplicate(true)


func _story_prop_by_id(story_prop_id: String) -> Dictionary:
	for story_prop_value in story_props:
		if story_prop_value is Dictionary and str((story_prop_value as Dictionary).get("story_prop_id", "")) == story_prop_id:
			return (story_prop_value as Dictionary).duplicate(true)
	return {}


func _find_nearest_anchor(radius: int) -> Dictionary:
	var nearest: Dictionary = {}
	var nearest_distance := radius + 1
	for anchor in world_map.get("memory_anchors", []):
		if not anchor is Dictionary:
			continue
		var anchor_data: Dictionary = anchor
		var distance := _manhattan_distance(player_cell, _dict_to_cell(anchor_data.get("position", {})))
		if distance <= radius and distance < nearest_distance:
			nearest = anchor_data
			nearest_distance = distance
	return nearest


func get_current_interaction_target() -> Dictionary:
	var exact_interaction: Dictionary = _find_interaction_at_cell(player_cell)
	if not exact_interaction.is_empty():
		return _interaction_target_from_map_interaction(exact_interaction)

	var exact_story_prop: Dictionary = _find_story_prop_at_cell(player_cell)
	if not exact_story_prop.is_empty():
		return _interaction_target_from_story_prop(exact_story_prop)

	var resource_point: Dictionary = _find_nearest_resource_point(0)
	if not resource_point.is_empty():
		return {
			"ok": true,
			"type": "resource",
			"target_id": str(resource_point.get("point_id", resource_point.get("item_id", ""))),
			"display_name": _resource_display_name(str(resource_point.get("item_id", "resource"))),
			"prompt": "看看 %s" % _resource_display_name(str(resource_point.get("item_id", "resource"))),
		}

	var exact_anchor: Dictionary = _find_nearest_anchor(0)
	if not exact_anchor.is_empty():
		var exact_core_word := str(exact_anchor.get("core_word", exact_anchor.get("letter", "")))
		return {
			"ok": true,
			"type": "anchor",
			"target_id": str(exact_anchor.get("anchor_id", "")),
			"display_name": exact_core_word,
			"prompt": "看看 %s" % exact_core_word,
		}

	var npc: Dictionary = _find_nearest_npc(INTERACTION_RADIUS)
	if not npc.is_empty():
		var npc_name := _npc_display_name(str(npc.get("npc_id", "")))
		return {
			"ok": true,
			"type": "npc",
			"target_id": str(npc.get("npc_id", "")),
			"display_name": npc_name,
			"prompt": "和 %s 打招呼" % npc_name,
		}

	var anchor: Dictionary = _find_nearest_anchor(1)
	if not anchor.is_empty():
		var core_word := str(anchor.get("core_word", anchor.get("letter", "")))
		return {
			"ok": true,
			"type": "anchor",
			"target_id": str(anchor.get("anchor_id", "")),
			"display_name": core_word,
			"prompt": "看看 %s" % core_word,
		}

	var story_prop: Dictionary = _find_nearest_story_prop(1)
	if not story_prop.is_empty():
		return _interaction_target_from_story_prop(story_prop)

	resource_point = _find_nearest_resource_point(1)
	if not resource_point.is_empty():
		return {
			"ok": true,
			"type": "resource",
			"target_id": str(resource_point.get("point_id", resource_point.get("item_id", ""))),
			"display_name": _resource_display_name(str(resource_point.get("item_id", "resource"))),
			"prompt": "捡起 %s" % _resource_display_name(str(resource_point.get("item_id", "resource"))),
		}

	var nearby_interaction: Dictionary = _find_nearest_interaction(1)
	if not nearby_interaction.is_empty():
		return _interaction_target_from_map_interaction(nearby_interaction)

	return {"ok": false, "type": "none", "prompt": "走近居民、物件或小路，再按看看。"}


func _interaction_target_from_map_interaction(interaction: Dictionary) -> Dictionary:
	var place_id := str(interaction.get("place_id", ""))
	var display_name := str(interaction.get("label", ""))
	if display_name.is_empty() and not place_id.is_empty():
		display_name = _place_icon(place_id)
	if display_name.is_empty():
		display_name = "这里"
	return {
		"ok": true,
		"type": "place",
		"target_id": str(interaction.get("interaction_id", place_id)),
		"display_name": display_name,
		"prompt": "看看 %s" % display_name,
	}


func _interaction_target_from_story_prop(story_prop: Dictionary) -> Dictionary:
	var display_name := str(story_prop.get("child_label", "看看小物件")).trim_prefix("看看").strip_edges()
	if display_name.is_empty():
		display_name = "小物件"
	return {
		"ok": true,
		"type": "story_prop",
		"target_id": str(story_prop.get("story_prop_id", "")),
		"display_name": display_name,
		"prompt": "看看 %s" % display_name,
	}


func _find_nearest_resource_point(radius: int) -> Dictionary:
	var nearest: Dictionary = {}
	var nearest_distance := radius + 1
	for point in resource_refresh_service.get_available_points():
		var distance := _manhattan_distance(player_cell, _dict_to_cell(point.get("cell", {})))
		if distance <= radius and distance < nearest_distance:
			nearest = point
			nearest_distance = distance
	return nearest


func _resource_display_name(item_id: String) -> String:
	match item_id:
		"branch":
			return "树枝"
		"flower":
			return "小花"
		"stone":
			return "小石子"
		_:
			return "小材料"


func _update_interaction_prompt() -> void:
	if not is_instance_valid(interaction_prompt_label):
		return
	var target := get_current_interaction_target()
	interaction_prompt_label.text = str(target.get("prompt", "走近一点，再按看看。"))
	interaction_prompt_label.visible = not player_is_walking
	if is_instance_valid(interaction_prompt_glow):
		interaction_prompt_glow.visible = interaction_prompt_label.visible and bool(target.get("ok", false))


func _manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)


func _set_life_status(message: String) -> void:
	if is_instance_valid(life_status_label):
		life_status_label.text = message


func _update_today_status() -> void:
	if today_status_service == null:
		return
	var status: Dictionary = today_status_service.get_today_status()
	_set_life_status("今天：%s" % str(status.get("hud_text", "适合慢慢散步。")))


func _set_optional_activity_status(message: String) -> void:
	if is_instance_valid(optional_activity_label):
		optional_activity_label.text = message


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}


func _load_homeschool_events() -> Dictionary:
	var data: Dictionary = _load_json(HOMESCHOOL_EVENTS_PATH)
	var events_by_id: Dictionary = {}
	for event_value in data.get("events", []):
		if event_value is Dictionary:
			var event: Dictionary = event_value
			var event_id := str(event.get("event_id", ""))
			if not event_id.is_empty():
				events_by_id[event_id] = event.duplicate(true)
	return events_by_id


func _load_story_props() -> Array:
	var data: Dictionary = _load_json(STORY_PROPS_PATH)
	var props: Array = []
	for story_prop_value in data.get("story_props", []):
		if story_prop_value is Dictionary:
			props.append((story_prop_value as Dictionary).duplicate(true))
	return props


func _rounded_box(fill: Color, radius: int, border: Color = Color.TRANSPARENT) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.corner_radius_top_left = radius
	box.corner_radius_top_right = radius
	box.corner_radius_bottom_left = radius
	box.corner_radius_bottom_right = radius
	if border.a > 0.0:
		box.border_color = border
		box.border_width_left = 1
		box.border_width_top = 1
		box.border_width_right = 1
		box.border_width_bottom = 1
	return box


func _ui_skin_box(logical_asset_id: String, fallback: StyleBox, texture_margin: int = 24) -> StyleBox:
	var resolved: Dictionary = AssetResolverScript.get_ui_skin(logical_asset_id, AssetResolverScript.DEFAULT_THEME_ID)
	if not resolved.get("ok", false):
		return fallback
	var asset_path := str(resolved.get("placeholder_path", ""))
	if not FileAccess.file_exists(asset_path):
		return fallback
	var texture := ResourceLoader.load(asset_path) as Texture2D
	if texture == null:
		texture = _load_image_texture(asset_path)
	if texture == null:
		return fallback
	var box := StyleBoxTexture.new()
	box.texture = texture
	box.texture_margin_left = texture_margin
	box.texture_margin_top = texture_margin
	box.texture_margin_right = texture_margin
	box.texture_margin_bottom = texture_margin
	return box
