extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const PetServiceScript := preload("res://scripts/systems/pet_service.gd")
const ShopServiceScript := preload("res://scripts/systems/shop_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_pet_shop_services_stub.json")
	_expect(save_service.clear_for_test(), "test save should clear before run")
	_expect(save_service.reset_for_test(), "test save should reset to defaults")

	var pet_service = PetServiceScript.new()
	pet_service.save_service = save_service
	var shop_service = ShopServiceScript.new()
	shop_service.save_service = save_service

	_check_pet_initialization(pet_service, save_service)
	_check_successful_purchase(shop_service, save_service)
	_check_insufficient_coins(shop_service, save_service)
	_check_successful_feed(pet_service, save_service)
	_check_feed_without_food_is_non_punitive(pet_service, save_service)

	_expect(save_service.clear_for_test(), "test save should clean up after run")
	_finish()


func _check_pet_initialization(pet_service, save_service) -> void:
	var result: Dictionary = pet_service.initialize_pet_state()
	_expect(result.get("ok", false), "PetService should initialize and save Sunny")
	var pet: Dictionary = result.get("pet", {})
	_expect(pet.get("display_name", "") == "Sunny", "PetService should initialize display name Sunny")
	_expect(pet.get("species", "") == "dog", "PetService should initialize species dog")
	_expect(int(pet.get("hunger", -1)) == 0, "PetService should preserve existing default hunger before explicit hunger event")
	_expect(int(pet.get("happy", -1)) == 40, "PetService should apply config default happy when missing from save")
	var saved_pet: Dictionary = save_service.load_game_state().get("pet", {})
	_expect(saved_pet.get("display_name", "") == "Sunny", "initialized pet should write back to SaveService")

	var hunger_result: Dictionary = pet_service.set_hunger(70)
	_expect(hunger_result.get("ok", false), "PetService should save explicit hunger")
	_expect(int(save_service.load_game_state().get("pet", {}).get("hunger", -1)) == 70, "explicit hunger should persist")


func _check_successful_purchase(shop_service, save_service) -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["coins"] = 8
	game_state["inventory"] = {"food_pet_snack": 0}
	_expect(save_service.save_game_state(game_state), "purchase setup should save")

	var offer: Dictionary = shop_service.get_pet_food_offer()
	_expect(offer.get("item_id", "") == "food_pet_snack", "shop offer should use configured food item")
	_expect(int(offer.get("price", -1)) == 6, "shop offer should use configured price")

	var result: Dictionary = shop_service.buy_pet_food()
	_expect(result.get("ok", false), "ShopService should buy food when coins are enough")
	_expect(result.get("reason", "") == "purchased", "successful purchase should report purchased")
	var saved: Dictionary = save_service.load_game_state()
	_expect(int(saved.get("coins", -1)) == 2, "successful purchase should subtract configured price")
	_expect(int(saved.get("inventory", {}).get("food_pet_snack", -1)) == 1, "successful purchase should add one snack")


func _check_insufficient_coins(shop_service, save_service) -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["coins"] = 5
	game_state["inventory"] = {"food_pet_snack": 0}
	_expect(save_service.save_game_state(game_state), "insufficient coins setup should save")

	var result: Dictionary = shop_service.buy_pet_food()
	_expect(not result.get("ok", true), "ShopService should not buy food without enough coins")
	_expect(result.get("reason", "") == "not_enough_coins", "insufficient coins should use non-punitive reason")
	var saved: Dictionary = save_service.load_game_state()
	_expect(int(saved.get("coins", -1)) == 5, "insufficient coins should not deduct coins")
	_expect(int(saved.get("coins", -1)) >= 0, "insufficient coins should never make coins negative")
	_expect(int(saved.get("inventory", {}).get("food_pet_snack", -1)) == 0, "insufficient coins should not add food")


func _check_successful_feed(pet_service, save_service) -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["inventory"] = {"food_pet_snack": 1}
	game_state["pet"] = {
		"pet_id": "pet_sunny_dog",
		"display_name": "Sunny",
		"species": "dog",
		"hunger": 70,
		"happy": 35,
		"fed_today": false,
	}
	game_state["flags"] = {}
	_expect(save_service.save_game_state(game_state), "feed setup should save")

	var result: Dictionary = pet_service.feed()
	_expect(result.get("ok", false), "PetService should feed when snack exists")
	_expect(result.get("reason", "") == "fed", "successful feed should report fed")
	var saved: Dictionary = save_service.load_game_state()
	var pet: Dictionary = saved.get("pet", {})
	_expect(int(pet.get("hunger", -1)) == 45, "feeding should reduce hunger by configured delta")
	_expect(int(pet.get("happy", -1)) == 55, "feeding should increase happy by configured delta")
	_expect(bool(pet.get("fed_today", false)), "feeding should set fed_today")
	_expect(int(saved.get("inventory", {}).get("food_pet_snack", -1)) == 0, "feeding should consume one snack")
	_expect(bool(saved.get("flags", {}).get("sunny_first_snack_done", false)), "feeding should save completion flag")


func _check_feed_without_food_is_non_punitive(pet_service, save_service) -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["inventory"] = {"food_pet_snack": 0}
	game_state["pet"] = {
		"pet_id": "pet_sunny_dog",
		"display_name": "Sunny",
		"species": "dog",
		"hunger": 80,
		"happy": 25,
		"fed_today": false,
	}
	_expect(save_service.save_game_state(game_state), "no-food feed setup should save")

	var result: Dictionary = pet_service.feed()
	_expect(not result.get("ok", true), "PetService should not feed without food")
	_expect(result.get("reason", "") == "no_food", "no-food feed should use non-punitive reason")
	var saved: Dictionary = save_service.load_game_state()
	var pet: Dictionary = saved.get("pet", {})
	_expect(int(pet.get("hunger", -1)) == 80, "no-food feed should not increase hunger")
	_expect(int(pet.get("happy", -1)) == 25, "no-food feed should not reduce happy")
	_expect(int(saved.get("inventory", {}).get("food_pet_snack", -1)) == 0, "no-food feed should keep food at zero")


func _finish() -> void:
	if failures.is_empty():
		print("PET AND SHOP SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
