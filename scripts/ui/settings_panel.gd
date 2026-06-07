extends PanelContainer
class_name SettingsPanel

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "SettingsPanel"
	visible = false
	custom_minimum_size = Vector2(392, 286)
	add_theme_stylebox_override("panel", renderer.call("_rounded_box", Color("#fbfffffa"), 12, Color("#ffffffee")))
	_margin(get_node("Margin") as MarginContainer, 18, 16, 18, 16)
	(get_node("Margin/SettingsStack") as VBoxContainer).add_theme_constant_override("separation", 10)
	(get_node("Margin/SettingsStack/Header") as HBoxContainer).add_theme_constant_override("separation", 10)
	var title := get_node("Margin/SettingsStack/Header/SettingsTitle") as Label
	title.text = "小镇设置"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", Color("#15282a"))
	title.add_theme_font_size_override("font_size", 20)
	_configure_button("Margin/SettingsStack/Header/CloseSettingsButton", "收起", "_on_close_settings_pressed", 86)
	var status := get_node("Margin/SettingsStack/SettingsStatus") as Label
	status.text = "可以先休息，也可以回到小镇安全位置。"
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status.add_theme_color_override("font_color", Color("#314549"))
	status.add_theme_font_size_override("font_size", 15)
	status.custom_minimum_size = Vector2(0, 42)
	renderer.set("settings_status_label", status)
	(get_node("Margin/SettingsStack/SettingsActions") as HBoxContainer).add_theme_constant_override("separation", 10)
	(get_node("Margin/SettingsStack/SettingsRestActions") as HBoxContainer).add_theme_constant_override("separation", 10)
	_configure_button("Margin/SettingsStack/SettingsActions/SoundToggleButton", "声音开", "_on_toggle_sound_pressed", 104)
	_configure_button("Margin/SettingsStack/SettingsActions/SafePlaceButton", "回到小镇", "_on_safe_place_pressed", 116)
	_configure_button("Margin/SettingsStack/SettingsRestActions/RequestRestButton", "休息一下", "_on_request_rest_pressed", 116)
	_configure_button("Margin/SettingsStack/SettingsRestActions/CancelRestButton", "继续逛", "_on_cancel_rest_pressed", 104)
	_configure_button("Margin/SettingsStack/SettingsRestActions/ConfirmExitButton", "退出游戏", "_on_confirm_exit_pressed", 116)


func _margin(node: MarginContainer, left: int, top: int, right: int, bottom: int) -> void:
	node.add_theme_constant_override("margin_left", left)
	node.add_theme_constant_override("margin_top", top)
	node.add_theme_constant_override("margin_right", right)
	node.add_theme_constant_override("margin_bottom", bottom)


func _configure_button(path: String, text: String, method_name: String, min_width: int) -> void:
	var button := get_node(path) as Button
	button.text = text
	button.custom_minimum_size = Vector2(min_width, 46)
	if path.contains("Close") or path.contains("Cancel"):
		button.icon = renderer.call("_get_texture", "ui_icon_close") as Texture2D
		button.expand_icon = true
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color("#1f3a32"))
	button.add_theme_stylebox_override("normal", renderer.call("_rounded_box", Color("#fffffffa"), 8, Color("#d5e5e5")))
	button.add_theme_stylebox_override("hover", renderer.call("_rounded_box", Color("#f4fbf8"), 8, Color("#b7d9cd")))
	button.add_theme_stylebox_override("pressed", renderer.call("_rounded_box", Color("#dcebe6"), 8, Color("#a9c8bd")))
	var callable := Callable(renderer, method_name)
	if not button.pressed.is_connected(callable):
		button.pressed.connect(callable)
