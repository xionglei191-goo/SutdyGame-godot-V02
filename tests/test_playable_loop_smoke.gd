extends SceneTree

const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	var main = MainScene.instantiate()
	main.configure_for_test("user://test_playable_loop_smoke.json")
	root.add_child(main)
	main.call("_ready")
	main.save_service.clear_for_test()
	main.call("_ready")

	_expect(main.find_child("HomePetLoopPanel", true, false) != null, "main scene should expose Home/Pet loop panel")
	_expect(main.find_child("StartButton", true, false) != null, "main scene should expose Start button")
	_expect(main.find_child("PlaySnakeButton", true, false) != null, "main scene should expose Play Snake button")
	_expect(main.find_child("BuyFoodButton", true, false) != null, "main scene should expose Buy Food button")
	_expect(main.find_child("FeedSunnyButton", true, false) != null, "main scene should expose Feed Sunny button")

	main._on_start_loop_pressed()
	_expect(int(main.save_service.load_game_state().get("pet", {}).get("hunger", -1)) == 70, "start loop should make Sunny hungry")

	main._on_play_snake_pressed()
	_expect(int(main.save_service.load_game_state().get("coins", -1)) >= 12, "Letter Snake service should add coins")
	_expect(bool(main.save_service.load_learning_record().get("card_states", {}).get("card_shop_egg", {}).get("played", false)), "Letter Snake should update card state")

	main._on_buy_food_pressed()
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("food_pet_snack", -1)) == 1, "Buy Food should add Sunny Snack")

	main._on_feed_sunny_pressed()
	var game_state: Dictionary = main.save_service.load_game_state()
	_expect(bool(game_state.get("flags", {}).get("sunny_first_snack_done", false)), "Feed Sunny should complete the loop")
	_expect(bool(game_state.get("pet", {}).get("fed_today", false)), "Feed Sunny should update pet state")
	_expect(int(game_state.get("inventory", {}).get("food_pet_snack", -1)) == 0, "Feed Sunny should consume food")
	_expect(bool(main.save_service.load_learning_record().get("card_states", {}).get("card_pet_food", {}).get("played", false)), "Feed Sunny should update pet food card")
	_expect(str(main.status_label.text).contains("happy"), "UI status should show final happy feedback")

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
