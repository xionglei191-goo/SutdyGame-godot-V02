extends PanelContainer
class_name TownHUD

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "TownHUD"
	add_theme_stylebox_override("panel", renderer.call("_rounded_box", Color("#f7fbffd8"), 8, Color("#ffffff99")))

	var margin := get_node("Margin") as MarginContainer
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 4)

	var row := get_node("Margin/Row") as HBoxContainer
	row.add_theme_constant_override("separation", 9)

	var title := row.get_node("Title") as Label
	title.text = "阳光小镇"
	title.custom_minimum_size = Vector2(106, 0)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color("#1f2d2f"))
	title.add_theme_font_size_override("font_size", 20)

	var town_status := row.get_node("Status") as Label
	town_status.text = "开放" if _map_errors_empty() else "照看中"
	town_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	town_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	town_status.custom_minimum_size = Vector2(62, 26)
	town_status.add_theme_color_override("font_color", Color.WHITE)
	town_status.add_theme_font_size_override("font_size", 12)
	town_status.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#3f7f62"), 8))

	var life_status_label := row.get_node("LifeStatus") as Label
	life_status_label.text = "今天适合慢慢散步。"
	life_status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	life_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	life_status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	life_status_label.add_theme_color_override("font_color", Color("#5d6b6d"))
	life_status_label.add_theme_font_size_override("font_size", 13)
	renderer.set("life_status_label", life_status_label)

	var status_label := row.get_node("LoopStatus") as Label
	status_label.custom_minimum_size = Vector2(96, 0)
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	status_label.add_theme_color_override("font_color", Color("#5d6b6d"))
	status_label.add_theme_font_size_override("font_size", 12)
	renderer.set("status_label", status_label)

	var optional_activity_label := row.get_node("OptionalActivityStatus") as Label
	optional_activity_label.text = "相册和 Letter Snake 是可以慢慢玩的收藏活动。"
	optional_activity_label.visible = false
	renderer.set("optional_activity_label", optional_activity_label)

	var coin_icon := row.get_node("CoinIcon") as TextureRect
	coin_icon.texture = renderer.call("_get_texture", "ui_icon_coin") as Texture2D
	coin_icon.custom_minimum_size = Vector2(26, 26)
	coin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	var coin_label := row.get_node("CoinState") as Label
	_configure_state_label(coin_label, 52, Color("#fff0bc"), Color("#d8a84b"))
	renderer.set("coin_label", coin_label)

	var pet_label := row.get_node("PetState") as Label
	_configure_state_label(pet_label, 104, Color("#eaf6ff"), Color("#93bfd0"))
	renderer.set("pet_label", pet_label)

	var settings_button := row.get_node("SettingsButton") as Button
	settings_button.text = ""
	settings_button.custom_minimum_size = Vector2(38, 30)
	settings_button.icon = renderer.call("_get_texture", "ui_icon_settings") as Texture2D
	settings_button.expand_icon = true
	settings_button.focus_mode = Control.FOCUS_NONE
	settings_button.add_theme_font_size_override("font_size", 13)
	settings_button.add_theme_color_override("font_color", Color("#284238"))
	settings_button.add_theme_stylebox_override("normal", renderer.call("_ui_skin_box", "glass_icon_button", renderer.call("_rounded_box", Color("#f7fbffee"), 8, Color("#ffffffaa")), 22))
	settings_button.add_theme_stylebox_override("hover", renderer.call("_ui_skin_box", "glass_icon_button", renderer.call("_rounded_box", Color("#ffffffee"), 8, Color("#ffffffcc")), 22))
	settings_button.add_theme_stylebox_override("pressed", renderer.call("_ui_skin_box", "glass_button_pressed", renderer.call("_rounded_box", Color("#e9f2f7ee"), 8, Color("#cfdce5")), 22))
	var settings_callable := Callable(renderer, "_on_settings_pressed")
	if not settings_button.pressed.is_connected(settings_callable):
		settings_button.pressed.connect(settings_callable)

	var cards_label := row.get_node("CardState") as Label
	cards_label.visible = false
	cards_label.add_theme_color_override("font_color", Color("#1f2d2f"))
	renderer.set("cards_label", cards_label)


func _configure_state_label(label: Label, min_width: int, fill: Color, border: Color) -> void:
	label.custom_minimum_size = Vector2(min_width, 26)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color("#24413a"))
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_stylebox_override("normal", renderer.call("_rounded_box", fill, 8, border))


func _map_errors_empty() -> bool:
	var errors = renderer.get("map_errors")
	return not (errors is Array) or (errors as Array).is_empty()
