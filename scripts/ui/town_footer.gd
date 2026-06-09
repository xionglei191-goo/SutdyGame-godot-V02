extends PanelContainer
class_name TownFooter

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "TownFooter"
	add_theme_stylebox_override("panel", renderer.call("_rounded_box", Color("#f7fbffd8"), 8, Color("#ffffff99")))

	var margin := get_node("Margin") as MarginContainer
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)

	var row := get_node("Margin/FooterVisibleActions") as HBoxContainer
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)

	_configure_footer_button(row.get_node("InteractButton") as Button, "看看", true, "_on_interact_pressed", "v0239_icon_look")
	_configure_footer_button(row.get_node("TownNavButton") as Button, "小镇", true, "_on_town_pressed", "v0239_icon_map")
	_configure_footer_button(row.get_node("HomeNavButton") as Button, "小屋", false, "_on_home_pressed", "v0239_icon_home")
	var backpack_button := row.get_node("BackpackNavButton") as Button
	_configure_footer_button(backpack_button, "背包", false, "_on_backpack_pressed", "ui_icon_bag")
	_configure_footer_button(row.get_node("AlbumNavButton") as Button, "相册", false, "_on_memory_album_pressed", "v0239_icon_album")

	var contract_buttons := get_node("FooterContractButtons") as Control
	contract_buttons.visible = false
	_configure_action_button(contract_buttons.get_node("StartButton") as Button, "开始", "_on_start_loop_pressed")
	_configure_action_button(contract_buttons.get_node("HelpNeighborButton") as Button, "帮邻居", "_on_help_neighbor_pressed")
	_configure_action_button(contract_buttons.get_node("BuyFoodButton") as Button, "买点心", "_on_buy_food_pressed")
	_configure_action_button(contract_buttons.get_node("FeedSunnyButton") as Button, "喂 Sunny", "_on_feed_sunny_pressed")
	_configure_action_button(contract_buttons.get_node("MemoryAlbumButton") as Button, "记忆相册", "_on_memory_album_pressed")
	_configure_action_button(contract_buttons.get_node("LetterSnakeButton") as Button, "Letter Snake", "_on_optional_letter_snake_pressed")


func _configure_footer_button(button: Button, label: String, selected: bool, method_name: String, icon_key: String = "") -> void:
	button.text = label
	button.custom_minimum_size = Vector2(62, 42)
	if not icon_key.is_empty():
		button.icon = renderer.call("_get_texture", icon_key) as Texture2D
		button.expand_icon = true
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_color_override("font_color", Color("#27443b") if selected else Color("#46584f"))
	var normal_color := Color("#f7fbffee") if selected else Color("#ffffffdc")
	var hover_color := Color("#ffffffee") if selected else Color("#f7fbffee")
	var pressed_color := Color("#e8f0f6ee") if selected else Color("#e8f0f6dd")
	var border_color := Color("#ffffffcc") if selected else Color("#dfeaf2bb")
	button.add_theme_stylebox_override("normal", renderer.call("_rounded_box", normal_color, 8, border_color))
	button.add_theme_stylebox_override("hover", renderer.call("_rounded_box", hover_color, 8, border_color.lightened(0.08)))
	button.add_theme_stylebox_override("pressed", renderer.call("_rounded_box", pressed_color, 8, border_color.darkened(0.08)))
	button.add_theme_stylebox_override("focus", renderer.call("_rounded_box", Color("#ffffffee"), 8, Color("#b9d8e8")))
	_connect_pressed(button, method_name)


func _configure_action_button(button: Button, label: String, method_name: String) -> void:
	button.text = label
	button.custom_minimum_size = Vector2(112, 38)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 13)
	button.add_theme_color_override("font_color", Color("#284238"))
	button.add_theme_stylebox_override("normal", renderer.call("_ui_skin_box", "glass_button_normal", renderer.call("_rounded_box", Color("#3f7f62"), 8), 24))
	button.add_theme_stylebox_override("hover", renderer.call("_ui_skin_box", "glass_button_normal", renderer.call("_rounded_box", Color("#4c8d70"), 8), 24))
	button.add_theme_stylebox_override("pressed", renderer.call("_ui_skin_box", "glass_button_pressed", renderer.call("_rounded_box", Color("#397259"), 8), 24))
	_connect_pressed(button, method_name)


func _connect_pressed(button: Button, method_name: String) -> void:
	var callable := Callable(renderer, method_name)
	if not button.pressed.is_connected(callable):
		button.pressed.connect(callable)
