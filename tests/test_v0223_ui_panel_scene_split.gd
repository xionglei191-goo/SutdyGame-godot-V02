extends SceneTree

const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	var main = MainScene.instantiate()
	root.add_child(main)
	main.call("_ready")
	_expect(_script_path(main.find_child("BackpackBubble", true, false)).ends_with("backpack_bubble.gd"), "BackpackBubble should use scene script")
	_expect(_script_path(main.find_child("SettingsPanel", true, false)).ends_with("settings_panel.gd"), "SettingsPanel should use scene script")
	_expect(_script_path(main.find_child("ShopPanel", true, false)).ends_with("shop_panel.gd"), "ShopPanel should use scene script")
	_expect(_script_path(main.find_child("MemoryAlbumOverlay", true, false)).ends_with("memory_album_overlay.gd"), "MemoryAlbumOverlay should use scene script")
	_expect(_script_path(main.find_child("HomeRoom", true, false)).ends_with("home_room.gd"), "HomeRoom should use scene script")
	for node_name in ["BackpackTitle", "BackpackSummary", "BackpackItems", "OpenMemoryAlbumButton", "SettingsStatus", "CloseSettingsButton", "ShopStatus", "ShopItemsList", "CloseShopButton", "MemoryAlbum", "CloseMemoryAlbumButton", "HomeRoomStage", "HomeFurnitureLayer", "HomeSunny", "SunnyHomeFeedback", "HomeInventoryList", "HomeRotateFirstFurnitureButton"]:
		_expect(main.find_child(node_name, true, false) != null, "UI panel scene should expose node: %s" % node_name)
	_press(main.find_child("BackpackNavButton", true, false) as Button, "Backpack should open")
	_expect((main.find_child("BackpackBubble", true, false) as Control).visible, "BackpackBubble should be visible")
	_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "Album should open from Backpack")
	_expect((main.find_child("MemoryAlbumOverlay", true, false) as Control).visible, "MemoryAlbumOverlay should be visible")
	_press(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "Album should close")
	_press(main.find_child("SettingsButton", true, false) as Button, "Settings should open")
	_expect((main.find_child("SettingsPanel", true, false) as Control).visible, "SettingsPanel should be visible")
	_press(main.find_child("CloseSettingsButton", true, false) as Button, "Settings should close")
	_expect(main.open_shop_panel().get("ok", false), "Shop should open by facade")
	_expect((main.find_child("ShopPanel", true, false) as Control).visible, "ShopPanel should be visible")
	_press(main.find_child("CloseShopButton", true, false) as Button, "Shop should close")
	main.show_home_view()
	_expect((main.find_child("HomeRoom", true, false) as Control).visible, "HomeRoom should be visible")
	root.remove_child(main)
	main.queue_free()
	_finish()


func _press(button: Button, message: String) -> void:
	_expect(button != null and _is_visible_in_tree(button) and not button.disabled, message)
	if button != null and _is_visible_in_tree(button) and not button.disabled:
		button.pressed.emit()


func _is_visible_in_tree(control: Control) -> bool:
	var current: Node = control
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _script_path(node: Node) -> String:
	if node == null:
		return ""
	var script := node.get_script() as Script
	return "" if script == null else script.resource_path


func _finish() -> void:
	if failures.is_empty():
		print("V02.23 UI PANEL SCENE SPLIT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
