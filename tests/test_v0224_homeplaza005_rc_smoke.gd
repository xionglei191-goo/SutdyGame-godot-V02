extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const FORBIDDEN_TEXT: Array[String] = ["课程", "作业", "测试", "测验", "考试", "背诵", "打卡", "分数", "正确率", "等级", "倒计时", "迟到", "必须", "debug", "grid", "cell", "坐标", "格子", "占格", "footprint", "家长报告"]

var failures: Array[String] = []
var main: Node


func _init() -> void:
	var save_path := "user://test_v0224_homeplaza005_rc_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.24 RC save should clear before startup")
	main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")
	await process_frame
	await process_frame

	_check_home_living_contract()
	_check_town_plaza_and_outdoor_decor()
	_check_npc_routine_arrival_safety()
	_check_old_visible_paths()
	_check_no_forbidden_visible("V02.24 HOMEPLAZA-005 RC")

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_home_living_contract() -> void:
	main.show_home_view()
	var snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(str(snapshot.get("home_living_contract_version", "")) == "v02.24_homeplaza_002", "V02.24 RC should keep Home living contract version")
	_expect(int(snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 RC should keep Home default living details")
	_expect(int(snapshot.get("placed_furniture_count", -1)) == 0, "V02.24 RC should keep default Home details out of placed_furniture")
	_expect(int(snapshot.get("child_text_banned_count", -1)) == 0, "V02.24 RC Home text should avoid technical terms")
	_seed_inventory({"pet_bowl": 1, "sunny_bed": 1, "flower_pot": 1})
	main.show_home_view()
	_press(main.find_child("HomePlacePetBowlButton", true, false) as Button, "V02.24 RC should place a bowl from visible Home button")
	snapshot = main.get_expapproval_home_snapshot()
	_expect(int(snapshot.get("placed_furniture_count", 0)) == 1, "V02.24 RC should persist only player-placed Home furniture")
	_expect(int(snapshot.get("home_life_detail_count", 0)) >= 9, "V02.24 RC Home default details should remain after placement")


func _check_town_plaza_and_outdoor_decor() -> void:
	main.show_town_view()
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_expapproval_snapshot"), "V02.24 RC should expose TownStage snapshot")
	if stage != null and stage.has_method("get_expapproval_snapshot"):
		var snapshot: Dictionary = stage.call("get_expapproval_snapshot")
		_expect(int(snapshot.get("plaza_stay_point_count", 0)) >= 4, "V02.24 RC should keep Town Plaza stay points")
		_expect(int(snapshot.get("anchor_count", 0)) == 26, "V02.24 RC should keep all A-Z anchors")
	var placed: Dictionary = main.place_outdoor_item("flower_pot", Vector2i(32, 21))
	_expect(placed.get("ok", false), "V02.24 RC should place outdoor decor in a safe plaza corner")
	_expect(not main.place_outdoor_item("flower_pot", Vector2i(34, 20)).get("ok", true), "V02.24 RC should reject outdoor decor on an anchor")


func _check_npc_routine_arrival_safety() -> void:
	main.show_town_view()
	var snapshot: Dictionary = main.get_npc_routine_snapshot()
	_expect(snapshot.get("ok", false), "V02.24 RC should expose NPC routine snapshot")
	_expect(int(snapshot.get("plaza_arrival_count", 0)) >= 2, "V02.24 RC should keep plaza arrival feel")
	var npcs: Array = snapshot.get("npcs", [])
	var mina := _npc_by_id(npcs, "mina")
	_expect(str(mina.get("arrival_zone", "")) == "town_plaza", "V02.24 RC should keep Mina as a Town Plaza arrival")
	_expect(str(mina.get("arrival_text", "")).contains("Mina"), "V02.24 RC should keep warm Mina arrival text")
	_expect(main.move_player_to_cell(Vector2i(38, 22)).get("ok", false), "V02.24 RC should move to Mina")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.24 RC should keep Mina prompt reachable")


func _check_old_visible_paths() -> void:
	main.show_town_view()
	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "V02.24 RC should move to Shop")
	_press(main.find_child("InteractButton", true, false) as Button, "V02.24 RC should open Shop from visible Interact")
	_expect(main.find_child("ShopPanel", true, false) != null and (main.find_child("ShopPanel", true, false) as Control).visible, "V02.24 RC should show Shop panel")
	_press(main.find_child("CloseShopButton", true, false) as Button, "V02.24 RC should close Shop")
	_press(main.find_child("BackpackNavButton", true, false) as Button, "V02.24 RC should open Backpack")
	_press(main.find_child("OpenMemoryAlbumButton", true, false) as Button, "V02.24 RC should open Album from Backpack")
	_expect(main.find_child("MemoryAlbumOverlay", true, false) != null and (main.find_child("MemoryAlbumOverlay", true, false) as Control).visible, "V02.24 RC should show Album")
	_press(main.find_child("CloseMemoryAlbumButton", true, false) as Button, "V02.24 RC should close Album")
	_press(main.find_child("SettingsButton", true, false) as Button, "V02.24 RC should open Settings")
	_expect(main.find_child("SettingsPanel", true, false) != null and (main.find_child("SettingsPanel", true, false) as Control).visible, "V02.24 RC should show Settings")
	_press(main.find_child("CloseSettingsButton", true, false) as Button, "V02.24 RC should close Settings")


func _seed_inventory(inventory_items: Dictionary) -> void:
	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["inventory"] = inventory_items.duplicate(true)
	game_state["home_state"] = {"placed_furniture": [], "stowed_furniture": {}}
	_expect(main.save_service.save_game_state(game_state), "V02.24 RC should seed inventory")


func _npc_by_id(npcs: Array, npc_id: String) -> Dictionary:
	for value in npcs:
		if value is Dictionary and str((value as Dictionary).get("npc_id", "")) == npc_id:
			return value
	_expect(false, "V02.24 RC should include NPC %s" % npc_id)
	return {}


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
		_expect(not text.contains(forbidden), "%s visible text should avoid %s" % [context, forbidden])


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
		print("V02.24 HOMEPLAZA-005 RC SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
