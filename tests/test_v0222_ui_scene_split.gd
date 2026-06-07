extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0222_ui_scene_split.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.22 UI split save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_ui_scenes(main)
	_check_visible_footer_paths(main)
	_check_settings_path(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_ui_scenes(main) -> void:
	var hud := main.find_child("TownHUD", true, false) as Control
	var footer := main.find_child("TownFooter", true, false) as Control
	_expect(_script_path(hud).ends_with("town_hud.gd"), "V02.22 TownHUD should be a scene script")
	_expect(_script_path(footer).ends_with("town_footer.gd"), "V02.22 TownFooter should be a scene script")
	_expect(main.status_label != null and main.status_label.name == "LoopStatus", "V02.22 TownHUD should keep Main status_label facade")
	_expect(main.coin_label != null and main.coin_label.name == "CoinState", "V02.22 TownHUD should keep Main coin_label facade")
	_expect(main.pet_label != null and main.pet_label.name == "PetState", "V02.22 TownHUD should keep Main pet_label facade")
	_expect(main.find_child("InteractButton", true, false) != null, "V02.22 TownFooter should expose InteractButton")
	_expect(main.find_child("BackpackNavButton", true, false) != null, "V02.22 TownFooter should expose BackpackNavButton")


func _check_visible_footer_paths(main) -> void:
	var backpack_button := main.find_child("BackpackNavButton", true, false) as Button
	_press_visible_button(backpack_button, "V02.22 UI split should open backpack from footer scene")
	var backpack := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack != null and backpack.visible, "V02.22 UI split should keep backpack bubble visible")
	var album_button := main.find_child("OpenMemoryAlbumButton", true, false) as Button
	_press_visible_button(album_button, "V02.22 UI split should open album from backpack")
	var album := main.find_child("MemoryAlbumOverlay", true, false) as Control
	_expect(album != null and album.visible, "V02.22 UI split should keep album overlay path")
	var close_album_button := main.find_child("CloseMemoryAlbumButton", true, false) as Button
	_press_visible_button(close_album_button, "V02.22 UI split should close album from its overlay button")
	_expect(not album.visible, "V02.22 UI split should close album from its visible return button")


func _check_settings_path(main) -> void:
	var settings_button := main.find_child("SettingsButton", true, false) as Button
	_press_visible_button(settings_button, "V02.22 UI split should open settings from HUD scene")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "V02.22 UI split should keep settings panel visible")
	_press_visible_button(main.find_child("CloseSettingsButton", true, false) as Button, "V02.22 UI split should close settings")
	_expect(not settings_panel.visible, "V02.22 UI split should hide settings panel")


func _press_visible_button(button: Button, message: String) -> void:
	_expect(button != null and _is_visible_in_tree(button) and not button.disabled, message)
	if button != null and _is_visible_in_tree(button) and not button.disabled:
		button.pressed.emit()


func _is_visible_in_tree(control: Control) -> bool:
	if control == null:
		return false
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
	if script == null:
		return ""
	return script.resource_path


func _finish() -> void:
	if failures.is_empty():
		print("V02.22 UI SCENE SPLIT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
