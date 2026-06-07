extends PanelContainer
class_name BackpackBubble

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "BackpackBubble"
	visible = false
	add_theme_stylebox_override("panel", renderer.call("_ui_skin_box", "glass_panel_small", renderer.call("_rounded_box", Color("#f7fbfff0"), 16, Color("#ffffffaa")), 28))
	_margin(get_node("Margin") as MarginContainer, 14, 12, 14, 12)
	(get_node("Margin/Stack") as VBoxContainer).add_theme_constant_override("separation", 8)
	_label("Margin/Stack/BackpackTitle", "小背包", 18, Color("#1f2d2f"))
	renderer.set("backpack_summary_label", _label("Margin/Stack/BackpackSummary", "", 14, Color("#365047")))
	var items := _label("Margin/Stack/BackpackItems", "", 14, Color("#5d6b6d"))
	items.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	renderer.set("backpack_items_label", items)
	renderer.set("backpack_collection_label", _label("Margin/Stack/BackpackCollection", "收藏：相册、小游戏", 13, Color("#775f2e")))
	(get_node("Margin/Stack/BackpackCollectionActions") as HBoxContainer).add_theme_constant_override("separation", 8)
	_configure_button("Margin/Stack/BackpackCollectionActions/OpenMemoryAlbumButton", "相册", "_on_memory_album_pressed", 96)
	_configure_button("Margin/Stack/BackpackCollectionActions/OpenLetterSnakeButton", "小游戏", "_on_optional_letter_snake_pressed", 96)


func _margin(node: MarginContainer, left: int, top: int, right: int, bottom: int) -> void:
	node.add_theme_constant_override("margin_left", left)
	node.add_theme_constant_override("margin_top", top)
	node.add_theme_constant_override("margin_right", right)
	node.add_theme_constant_override("margin_bottom", bottom)


func _label(path: String, text: String, font_size: int, color: Color) -> Label:
	var label := get_node(path) as Label
	if not text.is_empty():
		label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _configure_button(path: String, text: String, method_name: String, min_width: int) -> void:
	var button := get_node(path) as Button
	button.text = text
	button.custom_minimum_size = Vector2(min_width, 34)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 14)
	button.add_theme_color_override("font_color", Color("#284238"))
	button.add_theme_stylebox_override("normal", renderer.call("_ui_skin_box", "glass_button_normal", renderer.call("_rounded_box", Color("#f7fbffee"), 12, Color("#ffffffaa")), 24))
	button.add_theme_stylebox_override("hover", renderer.call("_ui_skin_box", "glass_button_normal", renderer.call("_rounded_box", Color("#ffffffee"), 12, Color("#ffffffcc")), 24))
	button.add_theme_stylebox_override("pressed", renderer.call("_ui_skin_box", "glass_button_pressed", renderer.call("_rounded_box", Color("#e8f0f6ee"), 12, Color("#cfdce5")), 24))
	var callable := Callable(renderer, method_name)
	if not button.pressed.is_connected(callable):
		button.pressed.connect(callable)
