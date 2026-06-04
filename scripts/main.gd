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
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AZ_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
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
const MAP_CELL_SIZE := 22
const TEXT_COLOR := Color("#1f2d2f")
const MUTED_TEXT_COLOR := Color("#5d6b6d")
const PLAYER_START_CELL := Vector2i(5, 8)
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
		"cell": {"x": 15, "y": 10},
	},
	{
		"npc_id": "shopkeeper",
		"cell": {"x": 24, "y": 10},
	},
	{
		"npc_id": "pet_buddy",
		"cell": {"x": 6, "y": 8},
	},
	{
		"npc_id": "bus_helper",
		"cell": {"x": 32, "y": 12},
	},
	{
		"npc_id": "story_bear",
		"cell": {"x": 12, "y": 7},
	},
]

var world_map: Dictionary = {}
var az_core_data: Dictionary = {}
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
var today_status_service
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
var player_marker: Node2D
var player_cell := PLAYER_START_CELL
var _texture_cache: Dictionary = {}


func _ready() -> void:
	name = "Main"
	custom_minimum_size = VIEWPORT_SIZE
	for child in get_children():
		remove_child(child)
		child.queue_free()
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	world_map = result.get("data", {})
	az_core_data = _load_json(AZ_ANCHORS_PATH)
	map_errors = result.get("errors", [])
	_init_services()
	_build_shell()
	_update_loop_status("准备好啦")
	_update_today_status()


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
	today_status_service = TodayStatusServiceScript.new(local_day_service)
	npc_memory_store = NPCMemoryStoreScript.new(save_service)
	llm_client = LLMClientScript.new(npc_memory_store)


func _build_shell() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color("#cdebc0")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.name = "SafeArea"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 14)
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

	nav.add_child(_create_nav_button("小镇", true))
	nav.add_child(_create_nav_button("小屋", false))
	nav.add_child(_create_nav_button("相册", false))
	nav.add_child(_create_nav_button("背包", false))

	var content := Control.new()
	content.name = "Content"
	content.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(content)

	var stage := Control.new()
	stage.name = "TownStage"
	stage.set_anchors_preset(Control.PRESET_FULL_RECT)
	content.add_child(stage)

	var map_frame := _create_map_canvas()
	map_frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	stage.add_child(map_frame)

	var hud := _create_top_message_bar()
	hud.anchor_left = 0.015
	hud.anchor_top = 0.015
	hud.anchor_right = 0.985
	hud.anchor_bottom = 0.015
	hud.offset_bottom = 48
	content.add_child(hud)

	var footer := _create_bottom_action_bar()
	footer.anchor_left = 0.24
	footer.anchor_top = 1.0
	footer.anchor_right = 0.76
	footer.anchor_bottom = 1.0
	footer.offset_top = -72
	footer.offset_bottom = -10
	content.add_child(footer)

	backpack_bubble = _create_backpack_bubble()
	backpack_bubble.anchor_left = 0.58
	backpack_bubble.anchor_top = 1.0
	backpack_bubble.anchor_right = 0.94
	backpack_bubble.anchor_bottom = 1.0
	backpack_bubble.offset_top = -286
	backpack_bubble.offset_bottom = -92
	content.add_child(backpack_bubble)

	var hint := Label.new()
	hint.name = "TownFooterText"
	hint.text = "点一点草地去散步。靠近居民、小屋、商店或树枝时，可以按“看看”。"
	hint.anchor_left = 0.24
	hint.anchor_top = 1.0
	hint.anchor_right = 0.76
	hint.anchor_bottom = 1.0
	hint.offset_top = -104
	hint.offset_bottom = -82
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", Color("#24413a"))
	hint.add_theme_font_size_override("font_size", 14)
	content.add_child(hint)

	return body


func _create_top_message_bar() -> Control:
	var panel := PanelContainer.new()
	panel.name = "TownHUD"
	panel.add_theme_stylebox_override("panel", _rounded_box(Color("#fff8dff0"), 8, Color("#d7bc71")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 5)
	panel.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	margin.add_child(row)

	var title := Label.new()
	title.name = "Title"
	title.text = "阳光小镇"
	title.custom_minimum_size = Vector2(118, 0)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 22)
	row.add_child(title)

	var town_status := Label.new()
	town_status.name = "Status"
	town_status.text = "开放" if map_errors.is_empty() else "照看中"
	town_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	town_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	town_status.custom_minimum_size = Vector2(70, 30)
	town_status.add_theme_color_override("font_color", Color.WHITE)
	town_status.add_theme_font_size_override("font_size", 13)
	town_status.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR, 8))
	row.add_child(town_status)

	life_status_label = Label.new()
	life_status_label.name = "LifeStatus"
	life_status_label.text = "今天：从小屋出发，去小镇走一走吧。"
	life_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	life_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	life_status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	life_status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	life_status_label.add_theme_font_size_override("font_size", 14)
	row.add_child(life_status_label)

	status_label = Label.new()
	status_label.name = "LoopStatus"
	status_label.custom_minimum_size = Vector2(150, 0)
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

	coin_label = _create_hud_state_label("CoinState", 72, Color("#fff0bc"), Color("#d8a84b"))
	row.add_child(coin_label)

	pet_label = _create_hud_state_label("PetState", 174, Color("#eaf6ff"), Color("#93bfd0"))
	row.add_child(pet_label)

	cards_label = Label.new()
	cards_label.name = "CardState"
	cards_label.visible = false
	cards_label.add_theme_color_override("font_color", TEXT_COLOR)
	row.add_child(cards_label)

	return panel


func _create_bottom_action_bar() -> Control:
	var bar := PanelContainer.new()
	bar.name = "TownFooter"
	bar.add_theme_stylebox_override("panel", _rounded_box(Color("#fff6dde8"), 18, Color("#e9c878")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 7)
	bar.add_child(margin)

	var row := HBoxContainer.new()
	row.name = "FooterVisibleActions"
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	margin.add_child(row)

	row.add_child(_create_footer_button("看看", true, "_on_interact_pressed", "InteractButton"))
	row.add_child(_create_nav_button("小镇", true, "TownNavButton"))
	row.add_child(_create_nav_button("小屋", false, "HomeNavButton"))
	row.add_child(_create_footer_button("背包", false, "_on_backpack_pressed", "BackpackNavButton"))

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


func _create_backpack_bubble() -> Control:
	var panel := PanelContainer.new()
	panel.name = "BackpackBubble"
	panel.visible = false
	panel.add_theme_stylebox_override("panel", _rounded_box(Color("#fffaf0f2"), 16, Color("#e9c878")))

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
	backpack_collection_label.text = "收藏：记忆相册、Letter Snake"
	backpack_collection_label.add_theme_color_override("font_color", Color("#775f2e"))
	backpack_collection_label.add_theme_font_size_override("font_size", 13)
	stack.add_child(backpack_collection_label)

	return panel


func _create_action_button(label: String, method_name: String, node_name: String = "") -> Button:
	var button := Button.new()
	button.name = node_name if not node_name.is_empty() else label.replace(" ", "") + "Button"
	button.text = label
	button.custom_minimum_size = Vector2(112, 38)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR, 8))
	button.add_theme_stylebox_override("hover", _rounded_box(PRIMARY_COLOR.lightened(0.08), 8))
	button.add_theme_stylebox_override("pressed", _rounded_box(PRIMARY_COLOR.darkened(0.08), 8))
	button.pressed.connect(Callable(self, method_name))
	return button


func _create_footer_button(label: String, selected: bool, method_name: String = "", node_name: String = "") -> Button:
	var button := Button.new()
	button.name = node_name if not node_name.is_empty() else label.replace(" ", "") + "FooterButton"
	button.text = label
	button.custom_minimum_size = Vector2(104, 48)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", Color("#27443b") if selected else Color("#46584f"))
	var normal_color := Color("#ffe28f") if selected else Color("#fffdf4")
	var hover_color := Color("#ffeca9") if selected else Color("#fff7dc")
	var pressed_color := Color("#f7c86f") if selected else Color("#f1ead2")
	var border_color := Color("#d39b43") if selected else Color("#ded0a7")
	button.add_theme_stylebox_override("normal", _rounded_box(normal_color, 16, border_color))
	button.add_theme_stylebox_override("hover", _rounded_box(hover_color, 16, border_color.lightened(0.08)))
	button.add_theme_stylebox_override("pressed", _rounded_box(pressed_color, 16, border_color.darkened(0.08)))
	button.add_theme_stylebox_override("focus", _rounded_box(Color("#fff3b8"), 16, Color("#f0b35a")))
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
	_set_optional_activity_status("记忆相册是收藏册，想看的时候再看。")


func _on_buy_food_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_food_basket")
	_update_loop_status("Sunny 的点心放进背包啦" if result.get("ok", false) else "金币还不够，再帮帮邻居吧")


func _on_feed_sunny_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_feed_sunny")
	_update_loop_status("Sunny 吃饱了，很开心" if result.get("ok", false) else "还没有准备好 Sunny 的点心")


func _on_interact_pressed() -> void:
	interact_nearby()


func _on_backpack_pressed() -> void:
	if backpack_bubble == null:
		return
	_update_backpack_bubble()
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
	var result: Dictionary = home_decoration_service.place_furniture("wooden_chair", cell)
	_set_life_status("把木椅放在钟表旁边啦。" if result.get("ok", false) else "背包里还没有木椅。")
	return result


func interact_nearby() -> Dictionary:
	var exact_interaction: Dictionary = _find_interaction_at_cell(player_cell)
	if not exact_interaction.is_empty():
		return _handle_map_interaction(exact_interaction)

	var resource_result: Dictionary = resource_refresh_service.collect_nearest(player_cell, 1)
	if resource_result.get("ok", false):
		_set_life_status(str(resource_result.get("text", "收进背包啦。")))
		resource_result["interaction_type"] = "resource"
		resource_result["target_id"] = resource_result.get("item_id", "")
		_update_loop_status("背包里多了%s" % str(resource_result.get("display_name", "小材料")))
		return resource_result

	var npc: Dictionary = _find_nearest_npc(INTERACTION_RADIUS)
	if not npc.is_empty():
		var npc_result: Dictionary = interact_with_npc(str(npc.get("npc_id", "")))
		npc_result["interaction_type"] = "npc"
		return npc_result

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
		_:
			_set_life_status("这个地方还没有准备好。")
			return {
				"ok": false,
				"reason": "unsupported_action",
				"action": action,
				"interaction_id": interaction.get("interaction_id", ""),
			}


func _enter_place(interaction: Dictionary) -> Dictionary:
	var place_id := str(interaction.get("place_id", _current_place_for_cell(player_cell)))
	var place: Dictionary = _find_place(place_id)
	var place_label := str(place.get("label", place_id))
	var message := _place_entry_message(place_id, place_label)
	var game_state: Dictionary = save_service.load_game_state()
	game_state["current_place_id"] = place_id
	save_service.save_game_state(game_state)
	_set_life_status(message)
	return {
		"ok": true,
		"interaction_type": "place_entry",
		"interaction_id": interaction.get("interaction_id", ""),
		"place_id": place_id,
		"place_label": place_label,
		"action": interaction.get("action", ""),
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


func _update_loop_status(message: String) -> void:
	if status_label == null:
		return
	var game_state: Dictionary = save_service.load_game_state()
	var pet: Dictionary = game_state.get("pet", {})
	var learning_record: Dictionary = save_service.load_learning_record()
	var dog_state: Dictionary = learning_record.get("card_states", {}).get("card_d_dog_core", {})
	status_label.text = message
	coin_label.text = "币 %s" % int(game_state.get("coins", 0))
	pet_label.text = "点 %s  饿 %s  心 %s" % [
		int(game_state.get("inventory", {}).get("food_pet_snack", 0)),
		int(pet.get("hunger", 0)),
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
	backpack_summary_label.text = "金币 %s  开心 %s" % [
		int(game_state.get("coins", 0)),
		int(game_state.get("pet", {}).get("happy", 0)),
	]
	backpack_items_label.text = "点心 %s   树枝 %s   木椅 %s" % [
		int(inventory.get("food_pet_snack", 0)),
		int(inventory.get("branch", 0)),
		int(inventory.get("wooden_chair", 0)),
	]


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
	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 40, "h": 24})
	var map_width := int(canvas_size.get("w", 40)) * MAP_CELL_SIZE
	var map_height := int(canvas_size.get("h", 24)) * MAP_CELL_SIZE

	var frame := Control.new()
	frame.name = "RuntimeMapFrame"
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var input := Control.new()
	input.name = "RuntimeMapInput"
	input.set_anchors_preset(Control.PRESET_FULL_RECT)
	input.custom_minimum_size = Vector2(map_width, map_height)
	input.mouse_filter = Control.MOUSE_FILTER_STOP
	input.gui_input.connect(_on_map_gui_input)
	frame.add_child(input)

	var map := Node2D.new()
	map.name = "RuntimeMap"
	map.position = Vector2.ZERO
	var ground := _create_sprite("Ground", Vector2(map_width, map_height) * 0.5, Vector2(map_width, map_height), "ground")
	map.add_child(ground)
	frame.add_child(map)

	_add_town_scenery(map, map_width, map_height)

	for road in world_map.get("roads", []):
		for cell in road.get("cells", []):
			map.add_child(_create_sprite("RoadCell", _cell_center(cell), Vector2(MAP_CELL_SIZE + 6, MAP_CELL_SIZE + 4), "road"))

	for place in world_map.get("places", []):
		map.add_child(_create_place_marker(place))

	for interaction in world_map.get("interaction_cells", []):
		map.add_child(_create_hotspot_marker(interaction))

	for cell in world_map.get("collision_cells", []):
		map.add_child(_create_collision_marker(cell))

	for anchor in world_map.get("memory_anchors", []):
		map.add_child(_create_anchor_marker(anchor))

	for anchor in az_core_data.get("anchors", []):
		if _map_anchor_letters().has(anchor.get("letter", "")):
			continue
		map.add_child(_create_reserved_anchor_marker(anchor))

	for npc in FIRST_NPCS:
		map.add_child(_create_npc_marker(npc))

	player_cell = _load_player_cell()
	player_marker = _create_player_marker()
	map.add_child(player_marker)
	_update_player_marker()

	return frame


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

	marker.add_child(_create_sprite("Shadow", Vector2(3, building_size.y * 0.45), Vector2(building_size.x * 0.95, 15), "shadow"))
	marker.add_child(_create_sprite("Building", Vector2(0, 8), Vector2(building_size.x, building_size.y - 8), "place_%s_body" % place_id))
	marker.add_child(_create_sprite("Roof", Vector2(0, -building_size.y * 0.32), Vector2(building_size.x * 0.92, 22), "place_%s_roof" % place_id))
	marker.add_child(_create_sprite("Door", Vector2(0, building_size.y * 0.25), Vector2(14, 18), "door_%s" % place_id))
	marker.add_child(_create_sprite("WindowLeft", Vector2(-building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_left" % place_id))
	marker.add_child(_create_sprite("WindowRight", Vector2(building_size.x * 0.25, 4), Vector2(12, 12), "window_%s_right" % place_id))
	if place_id == "place_supermarket":
		marker.add_child(_create_sprite("ShopSignAnchor", Vector2(0, -building_size.y * 0.08), Vector2(48, 14), "anchor_shop_sign"))
	elif place_id == "place_town_start":
		marker.add_child(_create_sprite("PlazaFlag", Vector2(building_size.x * 0.28, -building_size.y * 0.22), Vector2(14, 26), "plaza_flag"))

	return marker


func _create_hotspot_marker(interaction: Dictionary) -> Node2D:
	var marker := Node2D.new()
	marker.name = interaction.get("interaction_id", "interaction")
	marker.position = _cell_center(interaction.get("cell", {}))
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
	marker.add_child(_create_anchor_object_sprite(letter))

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
		((20 + int((route_order - 1) / 13)) * MAP_CELL_SIZE) + MAP_CELL_SIZE
	)
	marker.add_child(_create_sprite("FutureObject", Vector2.ZERO, Vector2(MAP_CELL_SIZE * 1.15, MAP_CELL_SIZE * 0.9), "reserved_anchor_%s" % str(anchor.get("letter", ""))))

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
	marker.add_child(_create_sprite("Body", Vector2(0, 4), Vector2(20, 24), "player_body"))
	marker.add_child(_create_sprite("Head", Vector2(0, -12), Vector2(22, 20), "player_head"))
	marker.add_child(_create_sprite("FaceDotLeft", Vector2(-4, -13), Vector2(3, 3), "face_dot"))
	marker.add_child(_create_sprite("FaceDotRight", Vector2(4, -13), Vector2(3, 3), "face_dot"))
	return marker


func move_player_by_cells(delta: Vector2i) -> Dictionary:
	return move_player_to_cell(player_cell + delta)


func move_player_to_cell(target_cell: Vector2i) -> Dictionary:
	if not _is_cell_walkable(target_cell):
		_set_life_status("那里暂时走不过去。")
		return {"ok": false, "reason": "blocked", "cell": _cell_to_dict(target_cell)}

	player_cell = target_cell
	_save_player_cell()
	_update_player_marker()
	_set_life_status("正在阳光小镇散步：%s，%s" % [player_cell.x, player_cell.y])
	return {"ok": true, "cell": _cell_to_dict(player_cell)}


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

	var daily_result: Dictionary = daily_request_service.interact_for_npc(npc_id)
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


func _map_anchor_letters() -> Array[String]:
	var letters: Array[String] = []
	for anchor in world_map.get("memory_anchors", []):
		letters.append(anchor.get("letter", ""))
	return letters


func _create_sprite(sprite_name: String, sprite_position: Vector2, sprite_size: Vector2, texture_key: String) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = sprite_name
	sprite.position = sprite_position
	sprite.texture = _get_texture(texture_key)
	var texture_size := Vector2(sprite.texture.get_width(), sprite.texture.get_height())
	sprite.scale = Vector2(
		sprite_size.x / max(texture_size.x, 1.0),
		sprite_size.y / max(texture_size.y, 1.0)
	)
	return sprite


func _get_texture(texture_key: String) -> ImageTexture:
	if _texture_cache.has(texture_key):
		return _texture_cache[texture_key]
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


func _texture_colors(texture_key: String) -> Dictionary:
	if texture_key == "ground":
		return {"fill": Color("#dff0d1"), "edge": Color("#d5e8c7"), "accent": Color("#e8f6da")}
	if texture_key == "soft_horizon":
		return {"fill": Color("#f7ffe433"), "edge": Color("#f7ffe400"), "accent": Color("#ffffff22")}
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
	if texture_key == "anchor_shop_sign":
		return {"fill": Color("#f5c85c"), "edge": Color("#a76f3c"), "accent": Color("#fff2a8")}
	if texture_key == "plaza_flag":
		return {"fill": Color("#f0a34f"), "edge": Color("#8f6a45"), "accent": Color("#fff2a8")}
	if texture_key == "hotspot_glow":
		return {"fill": Color("#fff0a877"), "edge": Color("#fff0a822"), "accent": Color("#ffffffaa")}
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
	var texture_key := "anchor_%s" % letter.to_lower()
	match letter:
		"A":
			texture_key = "anchor_apple_tree"
		"B":
			texture_key = "anchor_bear_plush"
		"C":
			texture_key = "anchor_clock"
		"D":
			texture_key = "anchor_doghouse"
		"K":
			texture_key = "anchor_kite"
		"O":
			texture_key = "anchor_orange_stand"
		"S":
			texture_key = "anchor_sun"
		"T":
			texture_key = "anchor_taxi_stop"
		"W":
			texture_key = "anchor_watch_sign"
		_:
			texture_key = "reserved_anchor_%s" % letter
	return _create_sprite("ObjectSprite", Vector2.ZERO, Vector2(MAP_CELL_SIZE * 1.55, MAP_CELL_SIZE * 1.35), texture_key)


func _add_town_scenery(map: Node2D, map_width: int, map_height: int) -> void:
	map.add_child(_create_sprite("SoftHorizon", Vector2(map_width, map_height) * 0.5, Vector2(map_width, map_height), "soft_horizon"))
	map.add_child(_create_sprite("TownPond", Vector2(30.5, 5.0) * MAP_CELL_SIZE, Vector2(5 * MAP_CELL_SIZE, 4 * MAP_CELL_SIZE), "pond"))
	map.add_child(_create_sprite("TownPlaza", Vector2(16.0, 8.5) * MAP_CELL_SIZE, Vector2(8 * MAP_CELL_SIZE, 5 * MAP_CELL_SIZE), "plaza"))

	for cell in [Vector2i(2, 12), Vector2i(4, 14), Vector2i(8, 18), Vector2i(18, 4), Vector2i(30, 16), Vector2i(35, 9)]:
		var flower := Node2D.new()
		flower.name = "FlowerPatch"
		flower.position = Vector2(cell.x + 0.5, cell.y + 0.5) * MAP_CELL_SIZE
		flower.add_child(_create_sprite("Petals", Vector2.ZERO, Vector2(15, 13), "flower"))
		map.add_child(flower)

	for cell in [Vector2i(1, 2), Vector2i(9, 3), Vector2i(11, 13), Vector2i(20, 14), Vector2i(27, 18), Vector2i(36, 4)]:
		var tree := Node2D.new()
		tree.name = "RoundTree"
		tree.position = Vector2(cell.x + 0.72, cell.y + 0.72) * MAP_CELL_SIZE
		tree.add_child(_create_sprite("Trunk", Vector2(0, 13), Vector2(8, 18), "tree_trunk"))
		tree.add_child(_create_sprite("Crown", Vector2(0, -2), Vector2(MAP_CELL_SIZE * 1.5, MAP_CELL_SIZE * 1.42), "tree_crown"))
		map.add_child(tree)


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


func _dict_to_cell(cell: Dictionary) -> Vector2i:
	return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))


func _cell_to_dict(cell: Vector2i) -> Dictionary:
	return {"x": cell.x, "y": cell.y}


func _update_player_marker() -> void:
	if is_instance_valid(player_marker):
		player_marker.position = Vector2(player_cell.x + 0.5, player_cell.y + 0.5) * MAP_CELL_SIZE


func _load_player_cell() -> Vector2i:
	var game_state: Dictionary = save_service.load_game_state()
	if game_state.get("player_cell") is Dictionary:
		return _dict_to_cell(game_state.get("player_cell", {}))
	return PLAYER_START_CELL


func _save_player_cell() -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["player_cell"] = _cell_to_dict(player_cell)
	game_state["current_place_id"] = _current_place_for_cell(player_cell)
	save_service.save_game_state(game_state)


func _current_place_for_cell(cell: Vector2i) -> String:
	for place in world_map.get("places", []):
		var position := _dict_to_cell(place.get("position", {}))
		var size_data: Dictionary = place.get("size", {"w": 1, "h": 1})
		var size := Vector2i(int(size_data.get("w", 1)), int(size_data.get("h", 1)))
		if cell.x >= position.x and cell.x < position.x + size.x and cell.y >= position.y and cell.y < position.y + size.y:
			return str(place.get("place_id", ""))
	return "town_walk"


func _is_cell_walkable(cell: Vector2i) -> bool:
	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 40, "h": 24})
	if cell.x < 0 or cell.y < 0 or cell.x >= int(canvas_size.get("w", 40)) or cell.y >= int(canvas_size.get("h", 24)):
		return false
	for blocked in world_map.get("collision_cells", []):
		if _dict_to_cell(blocked) == cell:
			return false
	return true


func _on_map_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			move_player_to_cell(Vector2i(int(mouse_event.position.x / MAP_CELL_SIZE), int(mouse_event.position.y / MAP_CELL_SIZE)))


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_UP, KEY_W:
				move_player_by_cells(Vector2i(0, -1))
			KEY_DOWN, KEY_S:
				move_player_by_cells(Vector2i(0, 1))
			KEY_LEFT, KEY_A:
				move_player_by_cells(Vector2i(-1, 0))
			KEY_RIGHT, KEY_D:
				move_player_by_cells(Vector2i(1, 0))


func _find_npc(npc_id: String) -> Dictionary:
	for npc in FIRST_NPCS:
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
	for npc in FIRST_NPCS:
		var distance := _manhattan_distance(player_cell, _dict_to_cell(npc.get("cell", {})))
		if distance <= radius and distance < nearest_distance:
			nearest = npc
			nearest_distance = distance
	return nearest


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
