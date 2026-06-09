extends PanelContainer
class_name TownHUD

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "TownHUD"
	add_theme_stylebox_override("panel", renderer.call("_rounded_box", Color("#ffffff00"), 8, Color("#ffffff00")))

	var margin := get_node("Margin") as MarginContainer
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_top", 0)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_bottom", 0)

	var row := get_node("Margin/Row") as HBoxContainer
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)

	var title := row.get_node("Title") as Label
	title.text = "阳光小镇"
	title.custom_minimum_size = Vector2(116, 32)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color("#203a34"))
	title.add_theme_font_size_override("font_size", 17)
	title.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#fffdf0e2"), 8, Color("#ffffff9a")))

	var town_status := row.get_node("Status") as Label
	town_status.text = "晴" if _map_errors_empty() else "看护"
	town_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	town_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	town_status.custom_minimum_size = Vector2(38, 32)
	town_status.add_theme_color_override("font_color", Color("#6d7f24"))
	town_status.add_theme_font_size_override("font_size", 14)
	town_status.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#fff0a8d8"), 14, Color("#ffffff8a")))

	var life_status_label := row.get_node("LifeStatus") as Label
	life_status_label.text = "今天适合慢慢散步。"
	life_status_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	life_status_label.custom_minimum_size = Vector2(360, 32)
	life_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	life_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	life_status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	life_status_label.add_theme_color_override("font_color", Color("#415f58"))
	life_status_label.add_theme_font_size_override("font_size", 13)
	life_status_label.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#ffffff76"), 8, Color("#ffffff46")))
	renderer.set("life_status_label", life_status_label)

	var status_label := row.get_node("LoopStatus") as Label
	status_label.custom_minimum_size = Vector2(82, 32)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	status_label.add_theme_color_override("font_color", Color("#416158"))
	status_label.add_theme_font_size_override("font_size", 12)
	status_label.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#ffffff92"), 8, Color("#ffffff5a")))
	renderer.set("status_label", status_label)

	var optional_activity_label := row.get_node("OptionalActivityStatus") as Label
	optional_activity_label.text = "相册和 Letter Snake 是可以慢慢玩的收藏活动。"
	optional_activity_label.visible = false
	renderer.set("optional_activity_label", optional_activity_label)

	var coin_icon := row.get_node("CoinIcon") as TextureRect
	coin_icon.texture = renderer.call("_get_texture", "ui_icon_coin") as Texture2D
	coin_icon.ignore_texture_size = true
	coin_icon.custom_minimum_size = Vector2(24, 32)
	coin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	var coin_label := row.get_node("CoinState") as Label
	_configure_state_label(coin_label, 58, Color("#fff4cdd8"), Color("#ffffff82"))
	renderer.set("coin_label", coin_label)

	var pet_label := row.get_node("PetState") as Label
	_configure_state_label(pet_label, 108, Color("#eef9e8d2"), Color("#ffffff82"))
	renderer.set("pet_label", pet_label)

	var settings_button := row.get_node("SettingsButton") as Button
	settings_button.text = ""
	settings_button.custom_minimum_size = Vector2(34, 32)
	settings_button.icon = renderer.call("_get_texture", "ui_icon_settings") as Texture2D
	settings_button.expand_icon = true
	settings_button.focus_mode = Control.FOCUS_NONE
	settings_button.add_theme_font_size_override("font_size", 13)
	settings_button.add_theme_color_override("font_color", Color("#284238"))
	settings_button.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#ffffff7a"), 8, Color("#ffffff4e")))
	settings_button.add_theme_stylebox_override("hover", renderer.call("_rounded_box", Color("#ffffffe0"), 8, Color("#ffffff9a")))
	settings_button.add_theme_stylebox_override("pressed", renderer.call("_rounded_box", Color("#e7f3efcc"), 8, Color("#bdd5cc")))
	var settings_callable := Callable(renderer, "_on_settings_pressed")
	if not settings_button.pressed.is_connected(settings_callable):
		settings_button.pressed.connect(settings_callable)

	var cards_label := row.get_node("CardState") as Label
	cards_label.visible = false
	cards_label.add_theme_color_override("font_color", Color("#1f2d2f"))
	renderer.set("cards_label", cards_label)

	_ensure_hud_spacers(row, life_status_label, coin_icon)


func _ensure_hud_spacers(row: HBoxContainer, life_status_label: Label, coin_icon: TextureRect) -> void:
	var left_spacer := row.get_node_or_null("HudLeftSpacer") as Control
	if left_spacer == null:
		left_spacer = Control.new()
		left_spacer.name = "HudLeftSpacer"
		left_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(left_spacer)
		row.move_child(left_spacer, life_status_label.get_index())

	var right_spacer := row.get_node_or_null("HudRightSpacer") as Control
	if right_spacer == null:
		right_spacer = Control.new()
		right_spacer.name = "HudRightSpacer"
		right_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		right_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(right_spacer)
		row.move_child(right_spacer, coin_icon.get_index())


func _configure_state_label(label: Label, min_width: int, fill: Color, border: Color) -> void:
	label.custom_minimum_size = Vector2(min_width, 32)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color("#263f38"))
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_stylebox_override("normal", renderer.call("_rounded_box", fill, 8, border))


func _map_errors_empty() -> bool:
	var errors = renderer.get("map_errors")
	return not (errors is Array) or (errors as Array).is_empty()
