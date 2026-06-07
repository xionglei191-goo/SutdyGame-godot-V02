extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const FORBIDDEN_TEXT: Array[String] = ["Godot skeleton", "Loaded places", "课程", "作业", "测试", "测验", "考试", "背诵", "打卡", "分数", "正确率", "等级", "倒计时", "家长报告"]

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0221_livegate_free_life_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.21 free life smoke save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_startup_shell(main)
	_run_free_life_path(main)
	_check_persisted_life_state(main)
	_check_child_safe_visible_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_startup_shell(main) -> void:
	for node_name in ["TownHUD", "TownFooter", "InteractButton", "TownNavButton", "HomeNavButton", "BackpackNavButton", "SettingsButton"]:
		_expect(main.find_child(node_name, true, false) != null, "V02.21 free smoke should expose visible startup node: %s" % node_name)
	for hidden_button_name in ["StartButton", "HelpNeighborButton", "BuyFoodButton", "FeedSunnyButton", "MemoryAlbumButton", "LetterSnakeButton"]:
		var button := main.find_child(hidden_button_name, true, false) as Button
		_expect(button == null or not _control_path_visible(button), "V02.21 free smoke should not rely on hidden contract button: %s" % hidden_button_name)


func _run_free_life_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button

	_walk_to(main, Vector2i(38, 22), "walk to Mina")
	var prompt := main.find_child("InteractionPrompt", true, false) as Label
	_expect(prompt != null and str(prompt.text).contains("米娜"), "V02.21 free smoke should prompt Mina after walking")
	_press(interact_button, "V02.21 free smoke should greet Mina through visible Interact")
	_press(interact_button, "V02.21 free smoke should start Mina request through visible Interact")
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.21 free smoke Mina request should mention branch")

	_walk_to(main, Vector2i(19, 18), "walk to branch resource")
	_press(interact_button, "V02.21 free smoke should collect branch through visible Interact")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 1, "V02.21 free smoke should collect branch into backpack")
	_press(interact_button, "V02.21 free smoke should not duplicate same-day resource")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) == 1, "V02.21 free smoke same-day resource should not duplicate")

	_walk_to(main, Vector2i(19, 22), "return to the animal road")
	_walk_to(main, Vector2i(38, 22), "return to Mina")
	_press(interact_button, "V02.21 free smoke should complete Mina request")
	var after_mina: Dictionary = main.save_service.load_game_state()
	_expect(int(after_mina.get("coins", 0)) >= 6, "V02.21 free smoke should earn gentle local coins from visible NPC loop")

	var coin_boost: Dictionary = main.save_service.load_game_state()
	coin_boost["coins"] = max(int(coin_boost.get("coins", 0)), 12)
	_expect(main.save_service.save_game_state(coin_boost), "V02.21 free smoke may top up earned test coins to cover shop branch")

	_walk_to(main, Vector2i(41, 11), "walk to Shop")
	_press(interact_button, "V02.21 free smoke should open Shop through visible Interact")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.21 free smoke should show Shop panel")
	_press(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.21 free smoke should buy chair through visible Shop button")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.21 free smoke should add bought chair to backpack")
	_press(main.find_child("CloseShopButton", true, false) as Button, "V02.21 free smoke should close Shop through visible close button")

	_press(main.find_child("BackpackNavButton", true, false) as Button, "V02.21 free smoke should open backpack")
	_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.21 free smoke should open album from backpack")
	var album_layer := main.find_child("MemoryAlbumOverlay", true, false) as Control
	_expect(album_layer != null and album_layer.visible, "V02.21 free smoke should show memory album overlay")
	_press(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.21 free smoke should close album")

	_press(main.find_child("HomeNavButton", true, false) as Button, "V02.21 free smoke should enter Home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.21 free smoke should show Home room")
	_press(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.21 free smoke should place chair through visible Home button")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.21 free smoke should persist Home furniture")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "V02.21 free smoke should show Sunny feedback")

	_press(main.find_child("TownNavButton", true, false) as Button, "V02.21 free smoke should return to Town")
	_walk_to(main, Vector2i(21, 12), "walk to School Gate")
	_press(interact_button, "V02.21 free smoke should look at School Gate")
	_expect(str(main.life_status_label.text).contains("School Gate") or str(main.life_status_label.text).contains("校门"), "V02.21 free smoke should show School Gate life feedback")

	_press(main.find_child("SettingsButton", true, false) as Button, "V02.21 free smoke should open Settings")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "V02.21 free smoke should show Settings panel")
	_press(main.find_child("RequestRestButton", true, false) as Button, "V02.21 free smoke should open rest confirmation")
	_press(main.find_child("CancelRestButton", true, false) as Button, "V02.21 free smoke should cancel rest confirmation")
	_press(main.find_child("SafePlaceButton", true, false) as Button, "V02.21 free smoke should return to safe town place")
	_expect(main.player_cell == Vector2i(31, 19), "V02.21 free smoke safe place should return to home plaza cell")


func _walk_to(main, target_cell: Vector2i, label: String) -> void:
	var start_cell: Vector2i = main.player_cell
	var before_camera: Vector2 = main.runtime_map_node.position
	var request: Dictionary = main.request_player_walk_to_cell(target_cell)
	_expect(request.get("ok", false), "V02.21 free smoke should request %s" % label)
	if request.get("ok", false):
		_expect(main.player_cell == start_cell, "V02.21 free smoke %s should not teleport before frames advance" % label)
		var finish: Dictionary = main.finish_player_walk_for_test(420)
		_expect(finish.get("ok", false), "V02.21 free smoke should finish %s" % label)
		_expect(main.player_cell == target_cell, "V02.21 free smoke should arrive at %s" % label)
		if start_cell != target_cell:
			_expect(main.runtime_map_node.position != before_camera, "V02.21 free smoke camera should follow during %s" % label)


func _check_persisted_life_state(main) -> void:
	var state: Dictionary = main.save_service.load_game_state()
	_expect(state.get("player_cell") is Dictionary, "V02.21 free smoke should persist player_cell")
	var resource_day: Dictionary = state.get("resource_points", {}).get("local_day_001", {})
	_expect(resource_day.has("resource_branch_bear_corner"), "V02.21 free smoke should persist branch collection state")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.21 free smoke should persist home_state")
	_expect(not state.get("homeschool_events", {}).is_empty(), "V02.21 free smoke should persist School look event")
	_expect(not state.get("daily_requests", {}).is_empty(), "V02.21 free smoke should persist daily request state")


func _check_child_safe_visible_text(main) -> void:
	var visible_text := _collect_visible_text(main)
	for forbidden in FORBIDDEN_TEXT:
		_expect(not visible_text.contains(forbidden), "V02.21 free smoke visible UI should avoid forbidden text: %s" % forbidden)


func _press(button: Button, message: String) -> void:
	_expect(button != null and _control_path_visible(button) and not button.disabled, message)
	if button != null and _control_path_visible(button) and not button.disabled:
		button.emit_signal("pressed")


func _control_path_visible(node: Node) -> bool:
	var current := node
	while current != null:
		if current is Control and not (current as Control).visible:
			return false
		current = current.get_parent()
	return true


func _collect_visible_text(node: Node) -> String:
	if node is Control and not (node as Control).visible:
		return ""
	var parts: Array[String] = []
	if node is Label:
		parts.append((node as Label).text)
	elif node is Button:
		parts.append((node as Button).text)
	for child in node.get_children():
		parts.append(_collect_visible_text(child))
	return " ".join(parts)


func _finish() -> void:
	if failures.is_empty():
		print("V02.21 LIVEGATE FREE LIFE SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
