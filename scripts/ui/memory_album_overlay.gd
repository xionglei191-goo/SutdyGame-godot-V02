extends Control
class_name MemoryAlbumOverlay

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "MemoryAlbumOverlay"
	visible = false
	z_index = 20
	var album := get_node("MemoryAlbum")
	if album.has_method("set_save_service"):
		album.call("set_save_service", renderer.get("save_service"))
	if album.has_method("_ready"):
		album.call("_ready")
	var close_button := get_node("CloseMemoryAlbumButton") as Button
	close_button.text = "返回"
	close_button.custom_minimum_size = Vector2(86, 34)
	close_button.icon = renderer.call("_get_texture", "ui_icon_close") as Texture2D
	close_button.expand_icon = true
	close_button.focus_mode = Control.FOCUS_NONE
	close_button.add_theme_font_size_override("font_size", 14)
	close_button.add_theme_color_override("font_color", Color("#284238"))
	close_button.add_theme_stylebox_override("normal", renderer.call("_ui_skin_box", "glass_button_normal", renderer.call("_rounded_box", Color("#f7fbffee"), 12, Color("#ffffffaa")), 24))
	close_button.add_theme_stylebox_override("hover", renderer.call("_ui_skin_box", "glass_button_normal", renderer.call("_rounded_box", Color("#ffffffee"), 12, Color("#ffffffcc")), 24))
	close_button.add_theme_stylebox_override("pressed", renderer.call("_ui_skin_box", "glass_button_pressed", renderer.call("_rounded_box", Color("#e8f0f6ee"), 12, Color("#cfdce5")), 24))
	var callable := Callable(renderer, "_on_close_memory_album_pressed")
	if not close_button.pressed.is_connected(callable):
		close_button.pressed.connect(callable)
