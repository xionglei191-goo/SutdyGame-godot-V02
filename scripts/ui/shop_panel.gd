extends PanelContainer
class_name ShopPanel

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "ShopPanel"
	visible = false
	custom_minimum_size = Vector2(392, 336)
	add_theme_stylebox_override("panel", renderer.call("_rounded_box", Color("#fbfffffa"), 12, Color("#ffffffee")))
	_margin(get_node("Margin") as MarginContainer, 18, 16, 18, 16)
	(get_node("Margin/ShopShelf") as VBoxContainer).add_theme_constant_override("separation", 10)
	(get_node("Margin/ShopShelf/Header") as HBoxContainer).add_theme_constant_override("separation", 10)
	var icon := get_node("Margin/ShopShelf/Header/ShopIcon") as TextureRect
	icon.texture = renderer.call("_get_texture", "ui_icon_shop") as Texture2D
	icon.custom_minimum_size = Vector2(34, 34)
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var title := get_node("Margin/ShopShelf/Header/ShopTitle") as Label
	title.text = "街角商店"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_color_override("font_color", Color("#15282a"))
	title.add_theme_font_size_override("font_size", 20)
	_configure_button("Margin/ShopShelf/Header/CloseShopButton", "收起", "_on_close_shop_pressed", 86)
	var status := get_node("Margin/ShopShelf/ShopStatus") as Label
	status.text = "货架上摆着小屋物件。"
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status.add_theme_color_override("font_color", Color("#314549"))
	status.add_theme_font_size_override("font_size", 15)
	status.custom_minimum_size = Vector2(0, 40)
	renderer.set("shop_status_label", status)
	var list := get_node("Margin/ShopShelf/ShopItemsList") as VBoxContainer
	list.add_theme_constant_override("separation", 8)
	renderer.set("shop_items_list", list)


func _margin(node: MarginContainer, left: int, top: int, right: int, bottom: int) -> void:
	node.add_theme_constant_override("margin_left", left)
	node.add_theme_constant_override("margin_top", top)
	node.add_theme_constant_override("margin_right", right)
	node.add_theme_constant_override("margin_bottom", bottom)


func _configure_button(path: String, text: String, method_name: String, min_width: int) -> void:
	var button := get_node(path) as Button
	button.text = text
	button.custom_minimum_size = Vector2(min_width, 46)
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
