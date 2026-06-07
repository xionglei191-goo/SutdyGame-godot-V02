extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const FORBIDDEN_TEXT: Array[String] = ["Godot skeleton", "Loaded places", "from JSON", "课程", "作业", "测试", "测验", "考试", "背诵", "打卡", "分数", "正确率", "等级", "倒计时", "迟到", "必须", "debug", "grid", "cell", "坐标", "格子", "占格", "家长报告"]

var failures: Array[String] = []
var main: Node


func _init() -> void:
	var save_path := "user://test_v0223_expapproval006_rc_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.23 EXPAPPROVAL-006 save should clear before startup")
	main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	await process_frame
	await process_frame

	_check_town_plaza_world_map()
	_check_home_from_visible_nav()
	_check_shop_from_visible_interact()
	_check_album_from_visible_backpack()
	_check_settings_from_visible_button()
	_check_school_gate_and_yard_from_visible_interact()
	_check_final_child_text()

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_town_plaza_world_map() -> void:
	main.show_town_view()
	_expect(main.move_player_to_cell(Vector2i(31, 19)).get("ok", false), "V02.23 RC should show Town Plaza from town view")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.23 RC should expose TownStage approval snapshot")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(snapshot.get("plaza_life_detail_count", 0)) >= 11, "V02.23 RC should keep plaza plus school life details in stage")
		_expect(int(snapshot.get("anchor_count", 0)) == 26, "V02.23 RC should keep all 26 A-Z anchors")
		_expect(int(snapshot.get("muted_anchor_badge_count", 0)) == int(snapshot.get("anchor_badge_count", -1)), "V02.23 RC should keep anchor badges muted")
		_expect(not bool(snapshot.get("collision_debug_visible", true)), "V02.23 RC should keep collision debug hidden")
	_check_no_forbidden_visible("Town Plaza")


func _check_home_from_visible_nav() -> void:
	_press(main.find_child("HomeNavButton", true, false) as Button, "V02.23 RC should open Home from visible nav")
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_room != null and home_room.visible, "V02.23 RC should show HomeRoom")
	_expect(main.has_method("get_expapproval_home_snapshot"), "V02.23 RC should expose Home approval snapshot")
	var snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(int(snapshot.get("home_life_detail_count", 0)) >= 6, "V02.23 RC should keep Home lived-in details")
	_expect(int(snapshot.get("child_text_banned_count", -1)) == 0, "V02.23 RC Home should avoid child-facing grid/debug words")
	var collected: Dictionary = main.inventory_service.collect_item("wooden_chair", 1)
	_expect(collected.get("ok", false), "V02.23 RC should seed a chair for visible Home placement")
	main.show_home_view()
	_press(main.find_child("HomePlaceWoodenChairButton", true, false) as Button, "V02.23 RC should place Home furniture from visible button")
	snapshot = main.get_expapproval_home_snapshot()
	_expect(int(snapshot.get("placed_furniture_count", 0)) >= 1, "V02.23 RC should keep Home furniture visible")
	_check_no_forbidden_visible("Home")


func _check_shop_from_visible_interact() -> void:
	_press(main.find_child("TownNavButton", true, false) as Button, "V02.23 RC should return to Town before Shop")
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.23 RC should move to visible Shop hotspot")
	_press(main.find_child("InteractButton", true, false) as Button, "V02.23 RC should open Shop from visible Interact")
	var shop_panel := main.find_child("ShopPanel", true, false) as Control
	_expect(shop_panel != null and shop_panel.visible, "V02.23 RC should show ShopPanel")
	_expect(main.has_method("get_expapproval_shop_settings_snapshot"), "V02.23 RC should expose Shop / Settings snapshot")
	var snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(snapshot.get("shop_visible", false)), "V02.23 RC Shop snapshot should be visible")
	_expect(int(snapshot.get("shop_min_touch_height", 0)) >= 46, "V02.23 RC Shop buttons should stay touchable")
	_expect(int(snapshot.get("shop_child_text_banned_count", -1)) == 0, "V02.23 RC Shop text should avoid debug/pressure words")
	_check_no_forbidden_visible("Shop")
	_press(main.find_child("CloseShopButton", true, false) as Button, "V02.23 RC should close Shop")


func _check_album_from_visible_backpack() -> void:
	_press(main.find_child("BackpackNavButton", true, false) as Button, "V02.23 RC should open Backpack")
	_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.23 RC should open Album from Backpack")
	var album_layer := main.find_child("MemoryAlbumOverlay", true, false) as Control
	_expect(album_layer != null and album_layer.visible, "V02.23 RC should show Album overlay")
	var album_text := _collect_visible_text(album_layer)
	_expect(album_text.contains("小镇相册") or album_text.contains("相册"), "V02.23 RC Album should keep album identity visible")
	_check_no_forbidden_visible("Album")
	_press(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.23 RC should close Album")


func _check_settings_from_visible_button() -> void:
	_press(main.find_child("SettingsButton", true, false) as Button, "V02.23 RC should open Settings from top button")
	var settings_panel := main.find_child("SettingsPanel", true, false) as Control
	_expect(settings_panel != null and settings_panel.visible, "V02.23 RC should show SettingsPanel")
	var snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(snapshot.get("settings_visible", false)), "V02.23 RC Settings snapshot should be visible")
	_expect(int(snapshot.get("settings_min_touch_height", 0)) >= 46, "V02.23 RC Settings buttons should stay touchable")
	_expect(int(snapshot.get("settings_child_text_banned_count", -1)) == 0, "V02.23 RC Settings text should avoid debug/pressure words")
	_press(main.find_child("RequestRestButton", true, false) as Button, "V02.23 RC should show rest confirm")
	snapshot = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(snapshot.get("settings_confirm_visible", false)), "V02.23 RC Settings should expose rest confirm")
	_press(main.find_child("CancelRestButton", true, false) as Button, "V02.23 RC should cancel rest confirm")
	_check_no_forbidden_visible("Settings")
	_press(main.find_child("CloseSettingsButton", true, false) as Button, "V02.23 RC should close Settings")


func _check_school_gate_and_yard_from_visible_interact() -> void:
	main.show_town_view()
	_expect(main.request_player_walk_to_cell(Vector2i(21, 12)).get("ok", false), "V02.23 RC should request walk to School Gate")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 RC should finish walk to School Gate")
	_press(main.find_child("InteractButton", true, false) as Button, "V02.23 RC should trigger School Gate from visible Interact")
	var school_snapshot: Dictionary = main.get_expapproval_school_snapshot()
	_expect(int(school_snapshot.get("school_gate_life_detail_count", 0)) >= 2, "V02.23 RC should keep School Gate life details")
	_expect(bool(school_snapshot.get("arrival_school_gate_visible", false)), "V02.23 RC should show School Gate arrival proof")
	_expect(main.request_player_walk_to_cell(Vector2i(19, 15)).get("ok", false), "V02.23 RC should request walk to School Yard")
	_expect(main.finish_player_walk_for_test().get("ok", false), "V02.23 RC should finish walk to School Yard")
	_press(main.find_child("InteractButton", true, false) as Button, "V02.23 RC should trigger School Yard from visible Interact")
	school_snapshot = main.get_expapproval_school_snapshot()
	_expect(int(school_snapshot.get("school_yard_life_detail_count", 0)) >= 4, "V02.23 RC should keep School Yard life details")
	_expect(bool(school_snapshot.get("arrival_school_yard_visible", false)), "V02.23 RC should show School Yard arrival proof")
	_expect(int(school_snapshot.get("school_child_text_banned_count", -1)) == 0, "V02.23 RC School text should avoid debug/pressure words")
	_check_no_forbidden_visible("School line")


func _check_final_child_text() -> void:
	var state: Dictionary = main.save_service.load_game_state()
	_expect(state.get("homeschool_events", {}).has("homeschool_school_gate_hello_001"), "V02.23 RC should persist School Gate event")
	_expect(state.get("homeschool_events", {}).has("homeschool_school_yard_play_001"), "V02.23 RC should persist School Yard event")
	_check_no_forbidden_visible("final RC")


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


func _check_no_forbidden_visible(context: String) -> void:
	var text := _collect_visible_text(main)
	for forbidden in FORBIDDEN_TEXT:
		_expect(not text.contains(forbidden), "V02.23 RC visible text should avoid %s in %s" % [forbidden, context])


func _collect_visible_text(node: Node) -> String:
	if node is Control and not (node as Control).visible:
		return ""
	var parts: Array[String] = []
	if node is Label:
		parts.append(str((node as Label).text))
	elif node is Button:
		parts.append(str((node as Button).text))
	for child in node.get_children():
		parts.append(_collect_visible_text(child))
	return " ".join(parts)


func _finish() -> void:
	if failures.is_empty():
		print("V02.23 EXPAPPROVAL-006 RC SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
