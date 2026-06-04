extends Control

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const QuestEventServiceScript := preload("res://scripts/systems/quest_event_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const AZ_ANCHORS_PATH := "res://data/anchors/az_core_anchors.json"
const VIEWPORT_SIZE := Vector2i(1280, 720)
const BACKGROUND_COLOR := Color("#eef4f0")
const SURFACE_COLOR := Color("#ffffff")
const PRIMARY_COLOR := Color("#2f6f73")
const ACCENT_COLOR := Color("#f2b84b")
const ROAD_COLOR := Color("#d7c49a")
const PLACE_COLOR := Color("#ffffff")
const MAP_CELL_SIZE := 18
const TEXT_COLOR := Color("#1f2d2f")
const MUTED_TEXT_COLOR := Color("#5d6b6d")

var world_map: Dictionary = {}
var az_core_data: Dictionary = {}
var map_errors: Array = []
var save_path_override := ""
var save_service
var memory_card_service
var minigame_service
var quest_event_service
var status_label: Label
var pet_label: Label
var cards_label: Label


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


func _init_services() -> void:
	save_service = SaveServiceScript.new(save_path_override) if not save_path_override.is_empty() else SaveServiceScript.new()
	memory_card_service = MemoryCardServiceScript.new(save_service)
	minigame_service = MinigameServiceScript.new(save_service, memory_card_service)
	quest_event_service = QuestEventServiceScript.new(save_service, memory_card_service)


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
	nav.add_child(_create_nav_button("Parent", false))

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
	stack.add_child(_create_loop_panel())

	stack.add_child(_create_map_canvas())

	return body


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
	actions.add_child(_create_action_button("Play Snake", "_on_play_snake_pressed"))
	actions.add_child(_create_action_button("Buy Food", "_on_buy_food_pressed"))
	actions.add_child(_create_action_button("Feed Sunny", "_on_feed_sunny_pressed"))

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
	_update_loop_status("Sunny is ready for Letter Snake")


func _on_play_snake_pressed() -> void:
	minigame_service.complete_minigame({"config_set_id": "food", "score": 80})
	quest_event_service.advance_event("event_letter_snake_food")
	_update_loop_status("Coins and card spark saved")


func _on_buy_food_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_food_basket")
	_update_loop_status("Sunny Snack in basket" if result.get("ok", false) else "More coins can help")


func _on_feed_sunny_pressed() -> void:
	var result: Dictionary = quest_event_service.advance_event("event_feed_sunny")
	_update_loop_status("Sunny is happy" if result.get("ok", false) else "Sunny Snack is not ready")


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
