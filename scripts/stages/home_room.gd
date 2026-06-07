extends Control
class_name HomeRoom

var renderer: Object


func configure(main_renderer: Object) -> void:
	renderer = main_renderer
	name = "HomeRoom"
	(get_node("HomeRoomBackground") as ColorRect).color = Color("#f5e4bf")
	var stage := get_node("HomeRoomStage") as Node2D
	stage.position = Vector2(250, 95)
	_configure_sprite("HomeRoomStage/HomeFloor", Vector2(210, 155), Vector2(420, 310), "home_floor")
	_configure_sprite("HomeRoomStage/HomeBackWall", Vector2(210, 38), Vector2(420, 76), "home_wall")
	_configure_sprite("HomeRoomStage/HomeSunlightPatch", Vector2(150, 172), Vector2(170, 92), "home_sunlight_patch", Color(1, 1, 1, 0.64))
	_configure_sprite("HomeRoomStage/HomeWindow", Vector2(116, 36), Vector2(86, 44), "home_window")
	_configure_sprite("HomeRoomStage/HomeWallClock", Vector2(216, 38), Vector2(38, 38), "home_wall_clock")
	_configure_sprite("HomeRoomStage/HomeShelf", Vector2(312, 42), Vector2(92, 30), "home_shelf")
	_configure_sprite("HomeRoomStage/HomeWelcomeMat", Vector2(70, 250), Vector2(78, 36), "home_welcome_mat")
	_configure_sprite("HomeRoomStage/HomePetCornerBase", Vector2(372, 252), Vector2(96, 54), "home_pet_corner")
	_configure_default_life_layer()
	renderer.set("home_furniture_layer", get_node("HomeRoomStage/HomeFurnitureLayer"))
	_configure_sprite("HomeRoomStage/HomeSunny/Shadow", Vector2(0, 17), Vector2(30, 9), "shadow")
	_configure_sprite("HomeRoomStage/HomeSunny/Body", Vector2(0, 5), Vector2(30, 30), "npc_pet_buddy_body")
	_configure_sprite("HomeRoomStage/HomeSunny/Head", Vector2(0, -16), Vector2(28, 24), "npc_pet_buddy_head")
	_configure_feedback_panel()
	_configure_action_panel()


func _configure_default_life_layer() -> void:
	renderer.set("home_life_layer", get_node("HomeRoomStage/HomeLifeLayer"))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultRug", Vector2(178, 222), Vector2(132, 78), "home_item_soft_rug", Color(1, 1, 1, 0.82))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultTeaTable", Vector2(178, 204), Vector2(74, 44), "home_item_small_table", Color(1, 1, 1, 0.78))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultPlant", Vector2(78, 58), Vector2(36, 48), "home_item_flower_pot", Color(1, 1, 1, 0.84))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultWallStory", Vector2(270, 72), Vector2(44, 38), "home_item_wall_decoration", Color(1, 1, 1, 0.78))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultSunnyBowl", Vector2(345, 256), Vector2(36, 24), "home_item_pet_bowl", Color(1, 1, 1, 0.82))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultSunnyBed", Vector2(398, 266), Vector2(74, 38), "home_item_sunny_bed", Color(1, 1, 1, 0.62))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultBookStack", Vector2(304, 28), Vector2(38, 18), "home_item_book_stack", Color(1, 1, 1, 0.78))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultSunnyToy", Vector2(372, 214), Vector2(26, 22), "home_item_sunny_toy", Color(1, 1, 1, 0.74))
	_configure_sprite("HomeRoomStage/HomeLifeLayer/HomeDefaultWarmCup", Vector2(192, 191), Vector2(22, 18), "home_item_warm_cup", Color(1, 1, 1, 0.74))


func _configure_feedback_panel() -> void:
	var panel := get_node("SunnyHomeFeedbackPanel") as PanelContainer
	panel.add_theme_stylebox_override("panel", renderer.call("_ui_skin_box", "glass_panel_small", renderer.call("_rounded_box", Color("#f7fbffee"), 14, Color("#ffffffaa")), 28))
	_margin(panel.get_node("Margin") as MarginContainer, 14, 10, 14, 10)
	var label := panel.get_node("Margin/SunnyHomeFeedback") as Label
	label.text = "Sunny 在小屋里慢慢摇尾巴，等你一起整理小角落。"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color("#1f2d2f"))
	label.add_theme_font_size_override("font_size", 15)
	renderer.set("sunny_home_feedback_label", label)


func _configure_action_panel() -> void:
	var panel := get_node("HomeActionPanel") as PanelContainer
	panel.add_theme_stylebox_override("panel", renderer.call("_ui_skin_box", "glass_panel_large", renderer.call("_rounded_box", Color("#f7fbfff0"), 16, Color("#ffffffaa")), 32))
	_margin(panel.get_node("Margin") as MarginContainer, 14, 12, 14, 12)
	var stack := panel.get_node("Margin/HomeActionStack") as VBoxContainer
	stack.add_theme_constant_override("separation", 8)
	_label("HomeActionPanel/Margin/HomeActionStack/HomeActionTitle", "小屋物件", 18, Color("#1f2d2f"))
	var status := _label("HomeActionPanel/Margin/HomeActionStack/HomeActionStatus", "背包里的家具会出现在这里，小屋的小角落已经很暖。", 13, Color("#5d6b6d"))
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	renderer.set("home_action_status_label", status)
	var selected := _label("HomeActionPanel/Margin/HomeActionStack/HomeSelectedFurnitureLabel", "当前小角落：还没摆家具，Sunny 的小毯子和故事书先陪着你。", 13, Color("#1f2d2f"))
	selected.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	selected.add_theme_stylebox_override("normal", renderer.call("_ui_skin_box", "glass_panel_small", renderer.call("_rounded_box", Color("#fff8d9dd"), 10, Color("#ffffff99")), 20))
	renderer.set("home_selected_furniture_label", selected)
	var inventory := panel.get_node("Margin/HomeActionStack/HomeInventoryList") as VBoxContainer
	inventory.add_theme_constant_override("separation", 6)
	renderer.set("home_inventory_list", inventory)
	(panel.get_node("Margin/HomeActionStack/HomePlacedActions") as HBoxContainer).add_theme_constant_override("separation", 8)
	_configure_button("HomeActionPanel/Margin/HomeActionStack/HomePlacedActions/HomeRotateFirstFurnitureButton", "旋转", "_on_home_rotate_pressed", 72)
	_configure_button("HomeActionPanel/Margin/HomeActionStack/HomePlacedActions/HomeMoveFirstFurnitureButton", "挪动", "_on_home_move_pressed", 72)
	_configure_button("HomeActionPanel/Margin/HomeActionStack/HomePlacedActions/HomePickupFirstFurnitureButton", "收起", "_on_home_pickup_pressed", 72)


func _configure_sprite(path: String, sprite_position: Vector2, sprite_size: Vector2, texture_key: String, modulate: Color = Color.WHITE) -> void:
	var sprite := get_node(path) as Sprite2D
	var built := renderer.call("_create_sprite", sprite.name, sprite_position, sprite_size, texture_key) as Sprite2D
	sprite.position = built.position
	sprite.texture = built.texture
	sprite.scale = built.scale
	sprite.modulate = modulate
	built.free()


func _margin(node: MarginContainer, left: int, top: int, right: int, bottom: int) -> void:
	node.add_theme_constant_override("margin_left", left)
	node.add_theme_constant_override("margin_top", top)
	node.add_theme_constant_override("margin_right", right)
	node.add_theme_constant_override("margin_bottom", bottom)


func _label(path: String, text: String, font_size: int, color: Color) -> Label:
	var label := get_node(path) as Label
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
