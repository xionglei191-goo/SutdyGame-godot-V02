extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v028_daily_life_slice.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.8 slice save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("2026-06-05")
	root.add_child(main)
	main.call("_ready")

	_complete_visible_daily_slice(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	_finish()


func _complete_visible_daily_slice(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button

	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "Slice should move near Mina")
	_press(interact_button, "Visible Interact should greet Mina")
	_expect(str(main.life_status_label.text).contains("米娜"), "Slice should show Mina greeting feedback")
	_press(interact_button, "Visible Interact should start Mina light request")
	_expect(str(main.life_status_label.text).contains("树枝"), "Slice should show Mina branch request")

	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "Slice should move to branch resource")
	_press(interact_button, "Visible Interact should collect branch for Mina")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) == 1, "Slice should collect branch into backpack")

	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "Slice should return to Mina")
	_press(interact_button, "Visible Interact should complete Mina request")
	var after_mina: Dictionary = main.save_service.load_game_state()
	_expect(int(after_mina.get("coins", 0)) == 6, "Slice should earn gentle local coins from Mina")
	_expect(bool(after_mina.get("daily_requests", {}).get("2026-06-05", {}).get("daily_mina_branch_001", {}).get("completed_today", false)), "Slice should persist Mina completion")

	# Keep the slice short while still proving reward use from a visible shop entry.
	var state_with_extra_coins: Dictionary = main.save_service.load_game_state()
	state_with_extra_coins["coins"] = 12
	_expect(main.save_service.save_game_state(state_with_extra_coins), "Slice should prepare enough earned local coins for the shop step")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "Slice should move to shop hotspot")
	_press(interact_button, "Visible Interact should open shop shelf")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "Slice should open shop panel from visible Interact")
	var chair_button := main.find_child("ShopBuyWoodenChairButton", true, false) as Button
	_press(chair_button, "Visible shop button should buy a wooden chair")
	var after_purchase: Dictionary = main.save_service.load_game_state()
	_expect(int(after_purchase.get("inventory", {}).get("wooden_chair", 0)) == 1, "Slice should add bought chair to backpack")
	_expect(int(after_purchase.get("coins", -1)) == 4, "Slice should spend coins on the chair")

	var backpack_button := main.find_child("BackpackNavButton", true, false) as Button
	_press(backpack_button, "Visible backpack button should open after purchase")
	var backpack_items := main.find_child("BackpackItems", true, false) as Label
	_expect(backpack_items != null and str(backpack_items.text).contains("木椅 1"), "Slice should show chair in backpack")
	_press(backpack_button, "Visible backpack button should close before going home")

	var home_button := main.find_child("HomeNavButton", true, false) as Button
	_press(home_button, "Visible Home button should open the home room")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "Slice should show HomeRoom")
	var place_button := main.find_child("HomePlaceWoodenChairButton", true, false) as Button
	_press(place_button, "Visible home button should place bought chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 1, "Slice should persist placed chair")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "Slice should show Sunny home feedback")

	var town_button := main.find_child("TownNavButton", true, false) as Button
	_press(town_button, "Visible Town button should return to town for anchor revisit")
	_expect(main.move_player_to_cell(Vector2i(7, 3)).get("ok", false), "Slice should move to C Clock anchor")
	_press(interact_button, "Visible Interact should revisit C Clock")
	_expect(bool(main.memory_card_service.get_card_state("card_c_clock_core").get("collected", false)), "Slice should collect C Clock album state")
	_expect(str(main.life_status_label.text).contains("Clock"), "Slice should show C Clock story feedback")

	_expect(main.move_player_to_cell(Vector2i(23, 5)).get("ok", false), "Slice should move to O Orange anchor")
	_press(interact_button, "Visible Interact should revisit O Orange")
	_expect(bool(main.memory_card_service.get_card_state("card_o_orange_core").get("collected", false)), "Slice should collect O Orange album state")

	_expect(main.move_player_to_cell(Vector2i(17, 2)).get("ok", false), "Slice should move to S Sun anchor")
	_press(interact_button, "Visible Interact should revisit S Sun")
	_expect(bool(main.memory_card_service.get_card_state("card_s_sun_core").get("collected", false)), "Slice should collect S Sun album state")


func _check_child_safe_visible_text(main) -> void:
	for forbidden in ["考试", "评分", "课程", "背诵", "倒计时", "失败惩罚", "Godot skeleton", "Loaded places"]:
		_expect(_visible_texts_containing(main, forbidden).is_empty(), "Slice visible UI should not contain forbidden text: %s" % forbidden)


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


func _visible_texts_containing(node: Node, forbidden: String) -> Array[String]:
	var matches: Array[String] = []
	if node is Control and not (node as Control).visible:
		return matches
	var text := ""
	if node is Label:
		text = (node as Label).text
	elif node is Button:
		text = (node as Button).text
	if not text.is_empty() and text.contains(forbidden):
		matches.append(text)
	for child in node.get_children():
		matches.append_array(_visible_texts_containing(child, forbidden))
	return matches


func _finish() -> void:
	if failures.is_empty():
		print("V02.8 DAILY LIFE SLICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
