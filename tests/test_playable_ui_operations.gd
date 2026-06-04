extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_playable_ui_operations.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "Playable UI test save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("2026-06-04")
	root.add_child(main)
	main.call("_ready")

	_check_visible_album_path(main)
	_check_visible_interact_paths(main)
	_check_visible_shop_purchase_path(main)
	_check_visible_home_decoration_path(main)

	main.save_service.clear_for_test()
	_finish()


func _check_visible_album_path(main) -> void:
	var backpack_button := main.find_child("BackpackNavButton", true, false) as Button
	_press(backpack_button, "Backpack button should be a visible child-facing entry")
	var backpack_bubble := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack_bubble != null and backpack_bubble.visible, "Backpack bubble should open from the visible backpack button")

	var album_button := main.find_child("OpenMemoryAlbumButton", true, false) as Button
	_press(album_button, "Backpack bubble should expose a visible album button")
	var overlay := main.find_child("MemoryAlbumOverlay", true, false) as Control
	var title := main.find_child("AlbumTitle", true, false) as Label
	_expect(overlay != null and overlay.visible, "Album overlay should open from the visible album button")
	_expect(title != null and str(title.text) == "小镇相册", "Album should use child-facing Chinese title text, got: %s" % (str(title.text) if title != null else "<missing>"))

	var close_button := main.find_child("CloseMemoryAlbumButton", true, false) as Button
	_press(close_button, "Album overlay should expose a visible return button")
	_expect(overlay != null and not overlay.visible, "Album overlay should close from its visible return button")


func _check_visible_interact_paths(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button

	_expect(main.move_player_to_cell(Vector2i(2, 3)).get("ok", false), "Player should move near Apple anchor")
	_press(interact_button, "Visible Interact button should be available near anchors")
	var apple_state: Dictionary = main.save_service.load_learning_record().get("card_states", {}).get("card_a_apple_core", {})
	_expect(bool(apple_state.get("collected", false)), "Visible Interact should collect anchor album state")

	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "Player should move near branch resource")
	_press(interact_button, "Visible Interact button should be available near resources")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 1, "Visible Interact should collect resource into backpack")

	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "Player should move near Mina")
	_press(interact_button, "Visible Interact button should be available near NPCs")
	_expect(str(main.life_status_label.text).contains("米娜"), "Visible Interact should show NPC feedback in the HUD")


func _check_visible_shop_purchase_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "Player should move to the shop hotspot")
	_press(interact_button, "Visible Interact should open the shop shelf at the shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "Shop panel should open from the visible Interact button")

	var bowl_button := main.find_child("ShopBuyPetBowlButton", true, false) as Button
	_press(bowl_button, "Shop shelf should expose visible item buttons even before coins are enough")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("pet_bowl", 0)) == 0, "Shop button should not grant items when coins are not enough")
	_expect(str(main.life_status_label.text).contains("金币还不够"), "Shop should give gentle insufficient-coins feedback")

	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 30
	_expect(main.save_service.save_game_state(game_state), "Test should prepare local town coins")
	main.call("_update_loop_status", "金币准备好")
	_press(interact_button, "Visible Interact should keep the shop shelf reachable after coin setup")
	var chair_button := main.find_child("ShopBuyWoodenChairButton", true, false) as Button
	_press(chair_button, "Shop shelf should buy furniture through a visible item button")
	var after_purchase: Dictionary = main.save_service.load_game_state()
	_expect(int(after_purchase.get("inventory", {}).get("wooden_chair", 0)) == 1, "Visible shop purchase should add furniture to backpack")
	_expect(int(after_purchase.get("coins", -1)) == 22, "Visible shop purchase should deduct configured furniture price")


func _check_visible_home_decoration_path(main) -> void:
	var home_button := main.find_child("HomeNavButton", true, false) as Button
	_press(home_button, "Home button should be a visible child-facing entry")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	var town_stage := main.find_child("TownStage", true, false) as Control
	_expect(home_room != null and home_room.visible, "Visible Home button should open the home room")
	_expect(town_stage != null and not town_stage.visible, "Home room should replace the town playfield while open")

	var place_button := main.find_child("HomePlaceWoodenChairButton", true, false) as Button
	_press(place_button, "Home room should expose a visible place-furniture button for bought furniture")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 1, "Visible home button should place furniture")

	var rotate_button := main.find_child("HomeRotateFirstFurnitureButton", true, false) as Button
	_press(rotate_button, "Home room should expose a visible rotate button")
	var pickup_button := main.find_child("HomePickupFirstFurnitureButton", true, false) as Button
	_press(pickup_button, "Home room should expose a visible pickup button")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).is_empty(), "Visible pickup button should remove placed furniture")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "Visible pickup button should return furniture to backpack")

	var town_button := main.find_child("TownNavButton", true, false) as Button
	_press(town_button, "Town button should be a visible return path")
	_expect(town_stage != null and town_stage.visible, "Visible Town button should return to town playfield")
	_expect(home_room != null and not home_room.visible, "Visible Town button should hide the home room")


func _press(button: Button, message: String) -> void:
	_expect(button != null and _is_control_path_visible(button) and not button.disabled, message)
	if button != null and _is_control_path_visible(button) and not button.disabled:
		button.emit_signal("pressed")


func _is_control_path_visible(node: Node) -> bool:
	var current := node
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _finish() -> void:
	if failures.is_empty():
		print("PLAYABLE UI OPERATIONS TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
