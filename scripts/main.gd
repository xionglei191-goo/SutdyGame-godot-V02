extends Control

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const HomeDecorationServiceScript := preload("res://scripts/systems/home_decoration_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AZ_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const VIEWPORT_SIZE := Vector2i(1280, 720)
const BACKGROUND_COLOR := Color("#eef4f0")
const SURFACE_COLOR := Color("#ffffff")
const PRIMARY_COLOR := Color("#2f6f73")
const ACCENT_COLOR := Color("#f2b84b")
const ROAD_COLOR := Color("#d7c49a")
const PLACE_COLOR := Color("#ffffff")
const PLAYER_COLOR := Color("#5a8f7b")
const NPC_COLOR := Color("#d98b5f")
const MAP_CELL_SIZE := 18
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
var save_service
var memory_card_service
var minigame_service
var quest_event_service
var inventory_service
var life_shop_service
var home_decoration_service
var daily_request_service
var npc_memory_store
var llm_client
var status_label: Label
var pet_label: Label
var cards_label: Label
var life_status_label: Label
var optional_activity_label: Label
var player_marker: Control
var player_cell := PLAYER_START_CELL


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
	_update_loop_status("Ready")


func configure_for_test(save_path: String) -> void:
	save_path_override = save_path


func get_parent_entry_spec() -> Dictionary:
	return PARENT_ENTRY_SPEC.duplicate(true)


func _init_services() -> void:
	save_service = SaveServiceScript.new(save_path_override) if not save_path_override.is_empty() else SaveServiceScript.new()
	memory_card_service = MemoryCardServiceScript.new(save_service)
	minigame_service = MinigameServiceScript.new(save_service, memory_card_service)
	quest_event_service = QuestEventServiceScript.new(save_service, memory_card_service)
	inventory_service = InventoryServiceScript.new(save_service)
	life_shop_service = LifeShopServiceScript.new(save_service, inventory_service)
	home_decoration_service = HomeDecorationServiceScript.new(save_service, inventory_service)
	daily_request_service = DailyRequestServiceScript.new(save_service, inventory_service)
	npc_memory_store = NPCMemoryStoreScript.new(save_service)
	llm_client = LLMClientScript.new(npc_memory_store)


func _build_shell() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = BACKGROUND_COLOR
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.name = "SafeArea"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 56)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_right", 56)
	margin.add_theme_constant_override("margin_bottom", 36)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 24)
	margin.add_child(layout)

	layout.add_child(_create_header())
	layout.add_child(_create_body())


func _create_header() -> Control:
	var header := HBoxContainer.new()
	header.name = "Header"
	header.custom_minimum_size = Vector2(0, 88)
	header.add_theme_constant_override("separation", 20)

	var title_area := VBoxContainer.new()
	title_area.name = "TitleArea"
	title_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_area.add_theme_constant_override("separation", 4)
	header.add_child(title_area)

	var title := Label.new()
	title.name = "Title"
	title.text = "StudyGame V02"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 34)
	title_area.add_child(title)

	var subtitle := Label.new()
	subtitle.name = "Subtitle"
	subtitle.text = "Godot 4.6 skeleton - landscape 1280x720"
	subtitle.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	subtitle.add_theme_font_size_override("font_size", 18)
	title_area.add_child(subtitle)

	var status := Label.new()
	status.name = "Status"
	status.text = "Map ready" if map_errors.is_empty() else "Map error"
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status.custom_minimum_size = Vector2(160, 48)
	status.add_theme_color_override("font_color", Color.WHITE)
	status.add_theme_font_size_override("font_size", 18)
	status.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR, 8))
	header.add_child(status)

	return header


func _create_body() -> Control:
	var body := HBoxContainer.new()
	body.name = "Body"
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 24)

	var nav := VBoxContainer.new()
	nav.name = "Navigation"
	nav.custom_minimum_size = Vector2(220, 0)
	nav.add_theme_constant_override("separation", 12)
	body.add_child(nav)

	nav.add_child(_create_nav_button("Home", true))
	nav.add_child(_create_nav_button("Map", false))
	nav.add_child(_create_nav_button("Cards", false))

	var content := PanelContainer.new()
	content.name = "Content"
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_stylebox_override("panel", _rounded_box(SURFACE_COLOR, 8))
	body.add_child(content)

	var content_margin := MarginContainer.new()
	content_margin.name = "ContentMargin"
	content_margin.add_theme_constant_override("margin_left", 32)
	content_margin.add_theme_constant_override("margin_top", 28)
	content_margin.add_theme_constant_override("margin_right", 32)
	content_margin.add_theme_constant_override("margin_bottom", 28)
	content.add_child(content_margin)

	var stack := VBoxContainer.new()
	stack.name = "ContentStack"
	stack.add_theme_constant_override("separation", 20)
	content_margin.add_child(stack)

	var heading := Label.new()
	heading.name = "Heading"
	heading.text = "Home"
	heading.add_theme_color_override("font_color", TEXT_COLOR)
	heading.add_theme_font_size_override("font_size", 30)
	stack.add_child(heading)

	var summary := Label.new()
	summary.name = "Summary"
	var map_summary: Dictionary = RuntimeMapBuilderScript.build_summary(world_map)
	summary.text = (
		"Loaded %s places and %s memory anchors from JSON."
		% [map_summary.get("place_count", 0), map_summary.get("anchor_count", 0)]
		if map_errors.is_empty()
		else "Map loading failed: %s" % map_errors
	)
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	summary.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	summary.add_theme_font_size_override("font_size", 20)
	stack.add_child(summary)
	stack.add_child(_create_life_status_panel())
	stack.add_child(_create_loop_panel())
	stack.add_child(_create_optional_activity_panel())

	stack.add_child(_create_map_canvas())

	return body


func _create_life_status_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "LifeRPGPanel"
	panel.add_theme_stylebox_override("panel", _rounded_box(Color("#f1f6ee"), 8, Color("#d7e3d0")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var title := Label.new()
	title.name = "LifeTitle"
	title.text = "Sunshine Town Life"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 22)
	stack.add_child(title)

	life_status_label = Label.new()
	life_status_label.name = "LifeStatus"
	life_status_label.text = "Walk around, meet neighbors, and let A-Z anchors live in the town."
	life_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	life_status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	life_status_label.add_theme_font_size_override("font_size", 16)
	stack.add_child(life_status_label)

	var actions := HBoxContainer.new()
	actions.name = "LifeActions"
	actions.add_theme_constant_override("separation", 12)
	stack.add_child(actions)

	actions.add_child(_create_action_button("Interact", "_on_interact_pressed"))

	return panel


func _create_loop_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "HomePetLoopPanel"
	panel.add_theme_stylebox_override("panel", _rounded_box(Color("#f8faf8"), 8, Color("#d9e2df")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)
	margin.add_child(stack)

	var title := Label.new()
	title.name = "LoopTitle"
	title.text = "Sunny Snack Loop"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 22)
	stack.add_child(title)

	status_label = Label.new()
	status_label.name = "LoopStatus"
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	status_label.add_theme_font_size_override("font_size", 16)
	stack.add_child(status_label)

	pet_label = Label.new()
	pet_label.name = "PetState"
	pet_label.add_theme_color_override("font_color", TEXT_COLOR)
	pet_label.add_theme_font_size_override("font_size", 16)
	stack.add_child(pet_label)

	cards_label = Label.new()
	cards_label.name = "CardState"
	cards_label.add_theme_color_override("font_color", TEXT_COLOR)
	cards_label.add_theme_font_size_override("font_size", 16)
	stack.add_child(cards_label)

	var actions := HBoxContainer.new()
	actions.name = "LoopActions"
	actions.add_theme_constant_override("separation", 12)
	stack.add_child(actions)

	actions.add_child(_create_action_button("Start", "_on_start_loop_pressed"))
	actions.add_child(_create_action_button("Help Neighbor", "_on_help_neighbor_pressed"))
	actions.add_child(_create_action_button("Buy Food", "_on_buy_food_pressed"))
	actions.add_child(_create_action_button("Feed Sunny", "_on_feed_sunny_pressed"))

	return panel


func _create_optional_activity_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "OptionalActivityPanel"
	panel.add_theme_stylebox_override("panel", _rounded_box(Color("#fff8eb"), 8, Color("#ead39c")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var title := Label.new()
	title.name = "OptionalActivityTitle"
	title.text = "Optional Activities"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 20)
	stack.add_child(title)

	optional_activity_label = Label.new()
	optional_activity_label.name = "OptionalActivityStatus"
	optional_activity_label.text = "Album and Letter Snake are side activities; town life works without them."
	optional_activity_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	optional_activity_label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	optional_activity_label.add_theme_font_size_override("font_size", 16)
	stack.add_child(optional_activity_label)

	var actions := HBoxContainer.new()
	actions.name = "OptionalActivityActions"
	actions.add_theme_constant_override("separation", 12)
	stack.add_child(actions)

	actions.add_child(_create_action_button("Memory Album", "_on_memory_album_pressed"))
	actions.add_child(_create_action_button("Letter Snake", "_on_optional_letter_snake_pressed"))

	return panel


func _create_action_button(label: String, method_name: String) -> Button:
	var button := Button.new()
	button.name = label.replace(" ", "") + "Button"
	button.text = label
	button.custom_minimum_size = Vector2(144, 52)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR, 8))
	button.add_theme_stylebox_override("hover", _rounded_box(PRIMARY_COLOR.lightened(0.08), 8))
	button.add_theme_stylebox_override("pressed", _rounded_box(PRIMARY_COLOR.darkened(0.08), 8))
	button.pressed.connect(Callable(self, method_name))
	return button


func _on_start_loop_pressed() -> void:
	quest_event_service.start_chain()
	for event_id in ["event_welcome_home", "event_meet_sunny", "event_snack_time", "event_food_trip"]:
		quest_event_service.advance_event(event_id)
	_update_loop_status("Sunny is ready for a town errand")


func _on_help_neighbor_pressed() -> void:
	help_neighbor_for_coins()


func _on_optional_letter_snake_pressed() -> void:
	minigame_service.complete_minigame({"config_set_id": "food", "score": 80})
	quest_event_service.advance_event("event_letter_snake_food")
	_update_loop_status("Optional Letter Snake reward saved")
	_set_optional_activity_status("Letter Snake was played as an optional town activity.")


func _on_memory_album_pressed() -> void:
	_set_optional_activity_status("Memory Album is available as a collection album, not a required task.")


func _on_buy_food_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_food_basket")
	_update_loop_status("Sunny Snack in basket" if result.get("ok", false) else "More coins can help")


func _on_feed_sunny_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_feed_sunny")
	_update_loop_status("Sunny is happy" if result.get("ok", false) else "Sunny Snack is not ready")


func _on_interact_pressed() -> void:
	interact_nearby()


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
		_update_loop_status("Neighbor help already counted today")
		return {"ok": false, "reason": "already_helped"}

	flags["helped_neighbor_today"] = true
	game_state["flags"] = flags
	game_state["coins"] = int(game_state.get("coins", 0)) + 6
	save_service.save_game_state(game_state)
	_update_loop_status("Helped a neighbor and earned town coins")
	return {"ok": true, "coins": int(game_state.get("coins", 0))}


func collect_branch() -> Dictionary:
	var result: Dictionary = inventory_service.collect_item("branch", 1)
	_set_life_status("Picked up Branch near the Bear anchor." if result.get("ok", false) else "Branch is not ready.")
	return result


func buy_wooden_chair() -> Dictionary:
	var result: Dictionary = life_shop_service.buy_life_item("wooden_chair")
	_set_life_status("Bought Wooden Chair for home." if result.get("ok", false) else "More coins can help with the chair.")
	return result


func place_wooden_chair(cell: Vector2i = Vector2i(2, 2)) -> Dictionary:
	var result: Dictionary = home_decoration_service.place_furniture("wooden_chair", cell)
	_set_life_status("Placed Wooden Chair under the Clock anchor." if result.get("ok", false) else "Chair is not in the bag yet.")
	return result


func interact_nearby() -> Dictionary:
	var exact_interaction: Dictionary = _find_interaction_at_cell(player_cell)
	if not exact_interaction.is_empty():
		return _handle_map_interaction(exact_interaction)

	if _manhattan_distance(player_cell, BRANCH_RESOURCE_CELL) <= 1:
		var branch_result: Dictionary = collect_branch()
		branch_result["interaction_type"] = "resource"
		branch_result["target_id"] = "branch"
		return branch_result

	var npc: Dictionary = _find_nearest_npc(INTERACTION_RADIUS)
	if not npc.is_empty():
		var npc_result: Dictionary = interact_with_npc(str(npc.get("npc_id", "")))
		npc_result["interaction_type"] = "npc"
		return npc_result

	var nearby_interaction: Dictionary = _find_nearest_interaction(1)
	if not nearby_interaction.is_empty():
		return _handle_map_interaction(nearby_interaction)

	_set_life_status("Nothing nearby to use.")
	return {"ok": false, "reason": "no_target", "cell": _cell_to_dict(player_cell)}


func _handle_map_interaction(interaction: Dictionary) -> Dictionary:
	var action := str(interaction.get("action", ""))
	match action:
		"enter_supermarket", "enter_home", "open_town_start":
			return _enter_place(interaction)
		_:
			_set_life_status("This spot is not ready yet.")
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
			return "Home is calm. The room is waiting for cozy things."
		"place_town_start":
			return "Sunshine Town starts here. Paths lead to neighbors and shops."
		"place_supermarket":
			return "The Supermarket doors are open. The shelves are waiting inside."
		_:
			return "%s is quiet and ready to visit." % place_label


func _update_loop_status(message: String) -> void:
	if status_label == null:
		return
	var game_state: Dictionary = save_service.load_game_state()
	var pet: Dictionary = game_state.get("pet", {})
	var learning_record: Dictionary = save_service.load_learning_record()
	var dog_state: Dictionary = learning_record.get("card_states", {}).get("card_d_dog_core", {})
	status_label.text = message
	pet_label.text = "Coins %s  Food %s  Hunger %s  Happy %s" % [
		int(game_state.get("coins", 0)),
		int(game_state.get("inventory", {}).get("food_pet_snack", 0)),
		int(pet.get("hunger", 0)),
		int(pet.get("happy", 0)),
	]
	cards_label.text = "Dog card: %s / %s" % [
		"played" if dog_state.get("played", false) else "seen" if dog_state.get("seen", false) else "new",
		"done" if game_state.get("flags", {}).get("sunny_first_snack_done", false) else "in progress",
	]


func _create_nav_button(label: String, selected: bool) -> Button:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size = Vector2(0, 56)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color", Color.WHITE if selected else TEXT_COLOR)
	button.add_theme_stylebox_override(
		"normal",
		_rounded_box(PRIMARY_COLOR if selected else SURFACE_COLOR, 8)
	)
	button.add_theme_stylebox_override(
		"hover",
		_rounded_box(PRIMARY_COLOR.lightened(0.08) if selected else Color("#f4f7f5"), 8)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_rounded_box(PRIMARY_COLOR.darkened(0.08) if selected else Color("#e7eeeb"), 8)
	)
	return button


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

	var frame := PanelContainer.new()
	frame.name = "RuntimeMapFrame"
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	frame.add_theme_stylebox_override("panel", _rounded_box(Color("#f8faf8"), 8, Color("#d9e2df")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	frame.add_child(margin)

	var map := Control.new()
	map.name = "RuntimeMap"
	map.custom_minimum_size = Vector2(map_width, map_height)
	map.mouse_filter = Control.MOUSE_FILTER_STOP
	map.gui_input.connect(_on_map_gui_input)
	margin.add_child(map)

	var ground := ColorRect.new()
	ground.name = "Ground"
	ground.color = Color("#e8f3df")
	ground.position = Vector2.ZERO
	ground.size = Vector2(map_width, map_height)
	map.add_child(ground)

	for road in world_map.get("roads", []):
		for cell in road.get("cells", []):
			var road_cell := ColorRect.new()
			road_cell.name = "RoadCell"
			road_cell.color = ROAD_COLOR
			road_cell.position = _cell_position(cell)
			road_cell.size = Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE)
			map.add_child(road_cell)

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


func _create_place_marker(place: Dictionary) -> Control:
	var marker := PanelContainer.new()
	marker.name = place.get("place_id", "place")
	var size_data: Dictionary = place.get("size", {"w": 2, "h": 2})
	marker.position = _cell_position(place.get("position", {}))
	marker.size = Vector2(
		int(size_data.get("w", 2)) * MAP_CELL_SIZE,
		int(size_data.get("h", 2)) * MAP_CELL_SIZE
	)
	marker.add_theme_stylebox_override("panel", _rounded_box(PLACE_COLOR, 4, Color("#7fa6a0")))

	var label := Label.new()
	label.name = "Label"
	label.text = place.get("label", "Place")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", TEXT_COLOR)
	label.add_theme_font_size_override("font_size", 12)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	marker.add_child(label)

	return marker


func _create_hotspot_marker(interaction: Dictionary) -> Control:
	var marker := ColorRect.new()
	marker.name = interaction.get("interaction_id", "interaction")
	marker.color = Color("#4da3ff66")
	marker.position = _cell_position(interaction.get("cell", {}))
	marker.size = Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE)
	marker.mouse_filter = Control.MOUSE_FILTER_STOP
	marker.tooltip_text = interaction.get("action", "")
	return marker


func _create_collision_marker(cell: Dictionary) -> Control:
	var marker := ColorRect.new()
	marker.name = "CollisionCell"
	marker.color = Color("#2f3a3a28")
	marker.position = _cell_position(cell)
	marker.size = Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE)
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return marker


func _create_anchor_marker(anchor: Dictionary) -> Control:
	var marker := Label.new()
	marker.name = anchor.get("anchor_id", "anchor")
	marker.text = anchor.get("letter", "")
	marker.position = _cell_position(anchor.get("position", {}))
	marker.size = Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE)
	marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	marker.add_theme_color_override("font_color", TEXT_COLOR)
	marker.add_theme_font_size_override("font_size", 12)
	marker.add_theme_stylebox_override("normal", _rounded_box(ACCENT_COLOR, 4))
	return marker


func _create_reserved_anchor_marker(anchor: Dictionary) -> Control:
	var marker := Label.new()
	marker.name = anchor.get("anchor_id", "anchor")
	marker.text = anchor.get("letter", "")
	var route_order := int(anchor.get("route_order", 1))
	marker.position = Vector2(
		((route_order - 1) % 13) * MAP_CELL_SIZE * 2,
		(20 + int((route_order - 1) / 13)) * MAP_CELL_SIZE
	)
	marker.size = Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE)
	marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	marker.add_theme_color_override("font_color", Color("#6a7476"))
	marker.add_theme_font_size_override("font_size", 12)
	marker.add_theme_stylebox_override("normal", _rounded_box(Color("#e0e6e4"), 4))
	return marker


func _create_npc_marker(npc: Dictionary) -> Control:
	var marker := Label.new()
	var npc_id := str(npc.get("npc_id", "neighbor"))
	marker.name = "npc_%s" % npc_id
	marker.text = _npc_display_name(npc_id).substr(0, 1)
	marker.position = _cell_position(npc.get("cell", {}))
	marker.size = Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE)
	marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	marker.tooltip_text = _npc_line(npc_id)
	marker.add_theme_color_override("font_color", Color.WHITE)
	marker.add_theme_font_size_override("font_size", 12)
	marker.add_theme_stylebox_override("normal", _rounded_box(NPC_COLOR, 4))
	return marker


func _create_player_marker() -> Control:
	var marker := Label.new()
	marker.name = "Player"
	marker.text = "P"
	marker.size = Vector2(MAP_CELL_SIZE, MAP_CELL_SIZE)
	marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	marker.add_theme_color_override("font_color", Color.WHITE)
	marker.add_theme_font_size_override("font_size", 12)
	marker.add_theme_stylebox_override("normal", _rounded_box(PLAYER_COLOR, 4))
	return marker


func move_player_by_cells(delta: Vector2i) -> Dictionary:
	return move_player_to_cell(player_cell + delta)


func move_player_to_cell(target_cell: Vector2i) -> Dictionary:
	if not _is_cell_walkable(target_cell):
		_set_life_status("That spot is not walkable yet.")
		return {"ok": false, "reason": "blocked", "cell": _cell_to_dict(target_cell)}

	player_cell = target_cell
	_save_player_cell()
	_update_player_marker()
	_set_life_status("Walking in Sunshine Town: %s, %s" % [player_cell.x, player_cell.y])
	return {"ok": true, "cell": _cell_to_dict(player_cell)}


func interact_with_npc(npc_id: String) -> Dictionary:
	var npc := _find_npc(npc_id)
	if npc.is_empty():
		return {"ok": false, "reason": "unknown_npc", "npc_id": npc_id}

	var npc_cell := _dict_to_cell(npc.get("cell", {}))
	if _manhattan_distance(player_cell, npc_cell) > 2:
		return {"ok": false, "reason": "too_far", "npc_id": npc_id}

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

	var reply: Dictionary = llm_client.complete_chat(npc_id, "hello", {
		"event_id": "scene_interact",
		"place_id": _current_place_for_cell(player_cell),
	})
	if not reply.get("ok", false):
		return reply

	var display_name := str(reply.get("display_name", _npc_display_name(npc_id)))
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


func _cell_position(cell: Dictionary) -> Vector2:
	return Vector2(
		int(cell.get("x", 0)) * MAP_CELL_SIZE,
		int(cell.get("y", 0)) * MAP_CELL_SIZE
	)


func _dict_to_cell(cell: Dictionary) -> Vector2i:
	return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))


func _cell_to_dict(cell: Vector2i) -> Dictionary:
	return {"x": cell.x, "y": cell.y}


func _update_player_marker() -> void:
	if is_instance_valid(player_marker):
		player_marker.position = Vector2(player_cell.x * MAP_CELL_SIZE, player_cell.y * MAP_CELL_SIZE)


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
	return str(profile.get("display_name", npc_id))


func _npc_line(npc_id: String) -> String:
	var profile := _npc_profile(npc_id)
	return str(profile.get("fallback_reply", "Let's keep exploring Sunshine Town together."))


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
