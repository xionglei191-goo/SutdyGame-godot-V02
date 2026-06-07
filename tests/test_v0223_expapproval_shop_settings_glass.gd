extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []
var main: Node


func _init() -> void:
	var save_path := "user://test_v0223_expapproval_shop_settings_glass.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.23 EXPAPPROVAL-004 save should clear before startup")
	main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	await process_frame
	await process_frame

	await _check_shop_glass_and_purchase_path()
	await _check_settings_glass_and_safe_rest_path()

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_shop_glass_and_purchase_path() -> void:
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "Shop proof should move to visible shop hotspot")
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_press(interact_button, "Shop proof should open from visible Interact button")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "Shop proof should show visible Shop panel")
	await process_frame
	var snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(int(snapshot.get("shop_panel_size", {}).get("width", 0)) >= 390, "Shop glass panel should be wide enough at 1280")
	_expect(int(snapshot.get("shop_panel_size", {}).get("height", 0)) >= 330, "Shop glass panel should be tall enough at 1280")
	_expect(int(snapshot.get("shop_min_touch_height", 0)) >= 46, "Shop visible buttons should use 46px touch targets")
	_expect(int(snapshot.get("shop_button_count", 0)) >= 4, "Shop proof should expose close plus item buttons")
	_expect(int(snapshot.get("shop_child_text_banned_count", -1)) == 0, "Shop proof should avoid grid/debug/test wording")

	var bowl_button := main.find_child("ShopBuyPetBowlButton", true, false) as Button
	_press(bowl_button, "Shop proof should expose visible item button before coins are enough")
	_expect(str(main.life_status_label.text).contains("金币还不够"), "Shop proof should give gentle insufficient-coins feedback")
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 30
	_expect(main.save_service.save_game_state(game_state), "Shop proof should prepare local coins")
	main.open_shop_panel()
	await process_frame
	var chair_button := main.find_child("ShopBuyWoodenChairButton", true, false) as Button
	_press(chair_button, "Shop proof should buy furniture through visible item button")
	var after_purchase: Dictionary = main.save_service.load_game_state()
	_expect(int(after_purchase.get("inventory", {}).get("wooden_chair", 0)) == 1, "Shop proof purchase should add wooden chair")
	_expect(int(after_purchase.get("coins", -1)) == 22, "Shop proof purchase should deduct configured price")
	var close_button := main.find_child("CloseShopButton", true, false) as Button
	_press(close_button, "Shop proof should close from visible close button")
	_expect(shop_panel != null and not shop_panel.visible, "Shop proof close button should hide panel")


func _check_settings_glass_and_safe_rest_path() -> void:
	var settings_button := main.find_child("SettingsButton", true, false) as Button
	_press(settings_button, "Settings proof should open from visible top button")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "Settings proof should show visible Settings panel")
	await process_frame
	var snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(int(snapshot.get("settings_panel_size", {}).get("width", 0)) >= 390, "Settings glass panel should be wide enough at 1280")
	_expect(int(snapshot.get("settings_panel_size", {}).get("height", 0)) >= 280, "Settings glass panel should be tall enough at 1280")
	_expect(int(snapshot.get("settings_min_touch_height", 0)) >= 46, "Settings visible buttons should use 46px touch targets")
	_expect(int(snapshot.get("settings_button_count", 0)) >= 4, "Settings proof should expose visible controls")
	_expect(int(snapshot.get("settings_child_text_banned_count", -1)) == 0, "Settings proof should avoid grid/debug/test wording")
	_expect(not bool(snapshot.get("settings_confirm_visible", true)), "Settings proof should hide exit confirm before rest request")

	var rest_button := main.find_child("RequestRestButton", true, false) as Button
	_press(rest_button, "Settings proof should expose visible rest request button")
	await process_frame
	snapshot = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(snapshot.get("settings_confirm_visible", false)), "Settings proof should show confirm only after rest request")
	var cancel_button := main.find_child("CancelRestButton", true, false) as Button
	_press(cancel_button, "Settings proof should expose visible continue button")
	await process_frame
	snapshot = main.get_expapproval_shop_settings_snapshot()
	_expect(not bool(snapshot.get("settings_confirm_visible", true)), "Settings proof continue button should hide confirm")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "Settings proof should move away before safe-place")
	_press(settings_button, "Settings proof should reopen after movement")
	var safe_button := main.find_child("SafePlaceButton", true, false) as Button
	_press(safe_button, "Settings proof should expose visible safe-place button")
	_expect(main.player_cell == Vector2i(31, 19), "Settings proof safe-place should return to home plaza")
	_expect(settings_panel != null and not settings_panel.visible, "Settings proof safe-place should close panel")


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


func _finish() -> void:
	if failures.is_empty():
		print("V02.23 EXPAPPROVAL SHOP SETTINGS GLASS TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
