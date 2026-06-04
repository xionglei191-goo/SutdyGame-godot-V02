extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const FORBIDDEN_CHILD_PARENT_UI_TERMS := ["Parent", "Dashboard", "Report", "家长", "报告", "后台"]

var failures: Array[String] = []


func _init() -> void:
	var main = MainScene.instantiate()
	main.configure_for_test("user://test_playable_loop_smoke.json")
	root.add_child(main)
	main.call("_ready")
	main.save_service.clear_for_test()
	main.call("_ready")

	_expect(main.find_child("HomePetLoopPanel", true, false) != null, "main scene should expose Home/Pet loop panel")
	_expect(main.find_child("OptionalActivityPanel", true, false) != null, "main scene should expose optional activity panel")
	_expect(main.find_child("StartButton", true, false) != null, "main scene should expose Start button")
	_expect(main.find_child("HelpNeighborButton", true, false) != null, "main scene should expose non-learning coin source")
	_expect(main.find_child("LetterSnakeButton", true, false) != null, "main scene should keep Letter Snake as optional activity")
	_expect(main.find_child("MemoryAlbumButton", true, false) != null, "main scene should keep Memory Album as optional activity")
	_expect(main.find_child("BuyFoodButton", true, false) != null, "main scene should expose Buy Food button")
	_expect(main.find_child("FeedSunnyButton", true, false) != null, "main scene should expose Feed Sunny button")
	_expect(main.find_child("ParentButton", true, false) == null, "child loop should not expose Parent navigation button")
	_expect(main.get_parent_entry_spec().get("child_flow_visible", true) == false, "parent entry spec should stay outside child flow")
	_expect(main.get_parent_entry_spec().get("available_in_child_nav", true) == false, "parent entry spec should not be in child nav")
	_expect(_visible_texts_containing(main, FORBIDDEN_CHILD_PARENT_UI_TERMS).is_empty(), "child loop should not expose parent report/dashboard UI text")

	main._on_start_loop_pressed()
	_expect(int(main.save_service.load_game_state().get("pet", {}).get("hunger", -1)) == 70, "start loop should make Sunny hungry")
	_expect(str(main.status_label.text).contains("town errand"), "start loop should not point the child to Letter Snake")

	main._on_help_neighbor_pressed()
	_expect(int(main.save_service.load_game_state().get("coins", -1)) >= 6, "life errand should add enough coins without a minigame")
	_expect(not bool(main.save_service.load_learning_record().get("card_states", {}).get("card_shop_egg", {}).get("played", false)), "life loop should not require Letter Snake card progress")

	main._on_buy_food_pressed()
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("food_pet_snack", -1)) == 1, "Buy Food should add Sunny Snack")

	main._on_feed_sunny_pressed()
	var game_state: Dictionary = main.save_service.load_game_state()
	_expect(bool(game_state.get("flags", {}).get("sunny_first_snack_done", false)), "Feed Sunny should complete the loop")
	_expect(bool(game_state.get("pet", {}).get("fed_today", false)), "Feed Sunny should update pet state")
	_expect(int(game_state.get("inventory", {}).get("food_pet_snack", -1)) == 0, "Feed Sunny should consume food")
	_expect(bool(main.save_service.load_learning_record().get("card_states", {}).get("card_pet_food", {}).get("played", false)), "Feed Sunny should update pet food card")
	_expect(str(main.status_label.text).contains("happy"), "UI status should show final happy feedback")

	main._on_optional_letter_snake_pressed()
	_expect(bool(main.save_service.load_learning_record().get("card_states", {}).get("card_shop_egg", {}).get("played", false)), "optional Letter Snake should still update card state when chosen")
	_expect(str(main.optional_activity_label.text).contains("optional"), "optional status should describe Letter Snake as optional")

	main.save_service.clear_for_test()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("PLAYABLE LOOP SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _visible_texts_containing(node: Node, forbidden_terms: Array) -> Array[String]:
	var matches: Array[String] = []
	if node is Control and not node.visible:
		return matches
	var text := ""
	if node is Label:
		text = (node as Label).text
	elif node is Button:
		text = (node as Button).text
	for term in forbidden_terms:
		if not text.is_empty() and text.find(str(term)) != -1:
			matches.append(text)
	for child in node.get_children():
		matches.append_array(_visible_texts_containing(child, forbidden_terms))
	return matches
