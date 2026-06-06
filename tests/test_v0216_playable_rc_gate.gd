extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const FORBIDDEN_VISIBLE_TERMS := [
	"Godot skeleton",
	"Loaded places",
	"from JSON",
	"课程",
	"单元",
	"测试",
	"测验",
	"考试",
	"背诵",
	"词表",
	"分数",
	"正确率",
	"家长报告",
	"必须完成",
	"错过损失",
	"迟到",
	"作业",
	"打卡",
	"倒计时",
	"赶时间",
	"陌生人带走",
	"独自远行",
]

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0216_playable_rc_gate.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.16 RC save should clear before scene startup")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_006")
	root.add_child(main)
	main.call("_ready")

	_seed_rc_state(main)
	_check_startup_text_and_layout(main)
	_check_mina_resource_shop_home_sunny_path(main)
	_check_home_school_return_path(main)
	_check_album_and_settings_path(main)
	_check_visible_text_is_child_safe(main, "final_rc_gate")

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _seed_rc_state(main) -> void:
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 20
	game_state["inventory"] = {
		"food_pet_snack": 1,
	}
	main.save_service.save_game_state(game_state)
	main.call("_update_loop_status", "小镇准备好")
	main.call("_update_today_status")


func _check_startup_text_and_layout(main) -> void:
	_expect(main.find_child("TownHUD", true, false) != null, "V02.16 RC should show top HUD")
	_expect(main.find_child("TownFooter", true, false) != null, "V02.16 RC should show bottom footer")
	var footer_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(footer_actions != null and footer_actions.get_child_count() == 4, "V02.16 RC footer should keep four child-facing actions")
	var hint := main.find_child("TownFooterText", true, false) as Label
	_expect(hint != null and str(hint.text).contains("看看"), "V02.16 RC startup should explain the visible look action")
	_check_visible_text_is_child_safe(main, "startup")


func _check_mina_resource_shop_home_sunny_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.16 RC should move near Mina")
	_press(interact_button, "V02.16 RC visible Interact should greet Mina")
	_press(interact_button, "V02.16 RC visible Interact should start or advance Mina request")
	_expect(str(main.life_status_label.text).contains("树枝"), "V02.16 RC Mina path should ask for a branch in child-facing copy")
	_check_visible_text_is_child_safe(main, "mina")

	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "V02.16 RC should move to branch resource")
	_press(interact_button, "V02.16 RC visible Interact should collect branch")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 1, "V02.16 RC resource should enter backpack")

	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "V02.16 RC should return to Mina")
	_press(interact_button, "V02.16 RC visible Interact should complete Mina request")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) >= 6, "V02.16 RC Mina path should keep gentle local reward")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.16 RC should move to Shop")
	_press(interact_button, "V02.16 RC visible Interact should open Shop")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.16 RC Shop panel should open")
	_press(main.find_child("ShopBuyWoodenChairButton", true, false) as Button, "V02.16 RC visible Shop item should buy chair")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) >= 1, "V02.16 RC chair should enter backpack")
	_press(main.find_child("CloseShopButton", true, false) as Button, "V02.16 RC Shop should have a visible close button")
	_expect(shop_panel != null and not shop_panel.visible, "V02.16 RC Shop close button should hide panel")

	_press(main.find_child("HomeNavButton", true, false) as Button, "V02.16 RC Home button should open home")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.16 RC Home should be visible")
	_press(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.16 RC Home visible item button should place chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() >= 1, "V02.16 RC Home should persist placed furniture")
	var sunny_feedback := main.find_child("SunnyHomeFeedback", true, false) as Label
	_expect(sunny_feedback != null and str(sunny_feedback.text).contains("Sunny"), "V02.16 RC Home should show Sunny feedback")
	_press(main.find_child("HomeRotateFirstFurnitureButton", true, false) as Button, "V02.16 RC Home should allow visible rotate")
	_press(main.find_child("HomeMoveFirstFurnitureButton", true, false) as Button, "V02.16 RC Home should allow visible move")
	_press(main.find_child("TownNavButton", true, false) as Button, "V02.16 RC Town button should return to town")
	_check_visible_text_is_child_safe(main, "shop_home")


func _check_home_school_return_path(main) -> void:
	var interact_button := main.find_child("InteractButton", true, false) as Button
	var steps: Array[Dictionary] = [
		{"cell": Vector2i(8, 11), "stage": "home_school_walk"},
		{"cell": Vector2i(11, 13), "stage": "school_gate"},
		{"cell": Vector2i(11, 15), "stage": "school_yard"},
		{"cell": Vector2i(5, 8), "stage": "return_home"},
	]
	main.set_day_key_for_test("local_day_006")
	main.call("_update_today_status")
	for step in steps:
		var stage := str(step.get("stage", ""))
		var entry: Dictionary = main.school_day_state_service.get_entry(stage)
		_expect(not entry.is_empty(), "V02.16 RC should resolve school daily entry: %s" % stage)
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.16 RC should move to school step: %s" % stage)
		_press(interact_button, "V02.16 RC visible Interact should trigger school step: %s" % stage)
		_expect(str(main.life_status_label.text).contains(str(entry.get("child_facing_text", ""))), "V02.16 RC should show day-specific school feedback: %s" % stage)
	var game_state: Dictionary = main.save_service.load_game_state()
	_expect(game_state.get("school_day_events", {}).size() >= 4, "V02.16 RC should persist school day events")
	_check_visible_text_is_child_safe(main, "school_return")


func _check_album_and_settings_path(main) -> void:
	_press(main.find_child("BackpackNavButton", true, false) as Button, "V02.16 RC Backpack should open")
	var backpack_bubble := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack_bubble != null and backpack_bubble.visible, "V02.16 RC Backpack bubble should be visible")
	_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.16 RC Album should open from backpack")
	var album_overlay := main.find_child("MemoryAlbumOverlay", true, false) as Control
	_expect(album_overlay != null and album_overlay.visible, "V02.16 RC Album overlay should open")
	var album_title := main.find_child("AlbumTitle", true, false) as Label
	_expect(album_title != null and str(album_title.text) == "小镇相册", "V02.16 RC Album title should stay child-facing")
	_check_visible_text_is_child_safe(main, "album")
	_press(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.16 RC Album should close")
	_expect(album_overlay != null and not album_overlay.visible, "V02.16 RC Album close should hide overlay")

	_press(main.find_child("SettingsButton", true, false) as Button, "V02.16 RC Settings should open")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "V02.16 RC Settings panel should be visible")
	_check_visible_text_is_child_safe(main, "settings")
	_press(main.find_child("RequestRestButton", true, false) as Button, "V02.16 RC Settings rest should reveal confirmation")
	var confirm_button := main.find_child("ConfirmExitButton", true, false) as Button
	_expect(confirm_button != null and confirm_button.visible, "V02.16 RC exit confirmation should only appear after rest request")
	_press(main.find_child("CancelRestButton", true, false) as Button, "V02.16 RC Settings continue should hide confirmation")
	_expect(confirm_button != null and not confirm_button.visible, "V02.16 RC continue should hide exit confirmation")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.16 RC should move away before safe-place check")
	_press(main.find_child("SafePlaceButton", true, false) as Button, "V02.16 RC Settings safe-place should work")
	_expect(main.player_cell == Vector2i(31, 19), "V02.16 RC safe-place should return to home plaza")
	_expect(settings_panel != null and not settings_panel.visible, "V02.16 RC safe-place should close Settings")


func _check_visible_text_is_child_safe(main, context: String) -> void:
	var text := _collect_visible_text(main)
	for forbidden in FORBIDDEN_VISIBLE_TERMS:
		_expect(not text.contains(forbidden), "V02.16 RC visible UI should not contain forbidden text (%s): %s" % [context, forbidden])


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


func _collect_visible_text(node: Node) -> String:
	if node is Control and not (node as Control).visible:
		return ""
	var text := ""
	if node is Label:
		text += (node as Label).text + "\n"
	elif node is Button:
		text += (node as Button).text + "\n"
	for child in node.get_children():
		text += _collect_visible_text(child)
	return text


func _finish() -> void:
	if failures.is_empty():
		print("V02.16 PLAYABLE RC GATE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
