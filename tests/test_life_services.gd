extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const HomeDecorationServiceScript := preload("res://scripts/systems/home_decoration_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_life_services.json")
	_expect(save_service.clear_for_test(), "test save should clear")
	_expect(save_service.reset_for_test(), "test save should reset")

	var inventory = InventoryServiceScript.new(save_service)
	_expect(inventory.is_loaded(), "life item catalog should load: %s" % [inventory.load_errors])

	var branch: Dictionary = inventory.collect_item("branch", 2)
	_expect(branch.get("ok", false), "branch collection should succeed")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("branch", 0)) == 2, "branch quantity should save")
	_expect(inventory.get_item("branch").get("memory_story", {}).get("core_anchor_id", "") == "anchor_b_bear", "branch story should bind to memory palace anchor")

	var game_state: Dictionary = save_service.load_game_state()
	game_state["coins"] = 10
	_expect(save_service.save_game_state(game_state), "coins setup should save")

	var shop = LifeShopServiceScript.new(save_service, inventory)
	var offer: Dictionary = shop.get_offer("wooden_chair")
	_expect(offer.get("ok", false), "wooden chair offer should load")
	_expect(int(offer.get("price", 0)) == 8, "wooden chair price should be configured")
	_expect(offer.get("memory_story", {}).get("core_anchor_id", "") == "anchor_c_clock", "chair offer should expose memory story anchor")
	var rotation: Dictionary = shop.get_shop_rotation_for_day("local_day_003")
	_expect(rotation.get("ok", false), "weekly shop rotation should load by day key")
	_expect(str(rotation.get("rotation_id", "")) == "shop_rotation_day_003", "weekly shop rotation should keep stable rotation id")
	_expect(str(rotation.get("weather_activity_corner", {}).get("weather_event_id", "")).begins_with("event_weather_"), "shop rotation should expose weather activity corner")
	_expect(str(rotation.get("weather_activity_corner", {}).get("text", "")).length() > 0, "shop weather activity corner should be child-facing text")
	_expect(_rotation_has_item(rotation, "wooden_chair"), "weekly shop rotation should include P0 chair")
	_expect(_rotation_has_item(rotation, "pet_bowl"), "weekly shop rotation should include P0 pet bowl")
	_expect(_rotation_has_tier(rotation, "P1"), "weekly shop rotation should include a P1 daily item")
	var low_coin_purchase: Dictionary = shop.buy_life_item("sunny_bed")
	_expect(not low_coin_purchase.get("ok", true), "not enough coins should not buy expensive item")
	_expect(str(low_coin_purchase.get("reason", "")) == "not_enough_coins", "not enough coins should return gentle economy reason")

	var purchase: Dictionary = shop.buy_life_item("wooden_chair")
	_expect(purchase.get("ok", false), "wooden chair purchase should succeed")
	_expect(int(save_service.load_game_state().get("coins", -1)) == 2, "chair purchase should deduct coins")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "chair should enter inventory")

	var home = HomeDecorationServiceScript.new(save_service, inventory)
	var placed: Dictionary = home.place_furniture("wooden_chair", Vector2i(2, 2))
	_expect(placed.get("ok", false), "chair placement should succeed")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("wooden_chair", -1)) == 0, "placed chair should leave inventory")
	var home_state: Dictionary = home.get_home_state()
	_expect(home_state.get("placed_furniture", []).size() == 1, "home should save placed furniture")
	_expect(home_state.get("placed_furniture", [])[0].get("memory_story", {}).get("review_path", "") != "", "placed furniture should keep review path")

	var reloaded_home = HomeDecorationServiceScript.new(save_service, InventoryServiceScript.new(save_service))
	_expect(reloaded_home.get_home_state().get("placed_furniture", []).size() == 1, "home state should reload")
	var instance_id := str(home_state.get("placed_furniture", [])[0].get("instance_id", ""))
	var rotated: Dictionary = reloaded_home.rotate_furniture(instance_id)
	_expect(rotated.get("ok", false), "home furniture should rotate")
	_expect(int(rotated.get("furniture", {}).get("rotation", -1)) == 90, "home furniture rotation should persist")
	var invalid: Dictionary = reloaded_home.place_furniture("wooden_chair", Vector2i(-1, 0))
	_expect(not invalid.get("ok", true) and str(invalid.get("feedback", "")).contains("放不下"), "invalid home placement should give soft feedback")
	var picked_up: Dictionary = reloaded_home.pickup_furniture(instance_id)
	_expect(picked_up.get("ok", false), "home furniture should be picked up")
	_expect(reloaded_home.get_home_state().get("placed_furniture", []).is_empty(), "picked up furniture should leave room")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "picked up furniture should return to inventory")

	var more_state: Dictionary = save_service.load_game_state()
	more_state["coins"] = 30
	_expect(save_service.save_game_state(more_state), "coins setup for pet furniture should save")
	_expect(shop.buy_life_item("pet_bowl").get("ok", false), "pet bowl should be buyable")
	_expect(reloaded_home.place_furniture("pet_bowl", Vector2i(0, 0)).get("ok", false), "pet bowl should place")
	var sunny_feedback: Dictionary = reloaded_home.get_sunny_feedback()
	_expect(sunny_feedback.get("ok", false), "Sunny home feedback should resolve")
	_expect(str(sunny_feedback.get("text", "")).contains("Sunny"), "Sunny feedback should be child-facing text")

	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("LIFE SERVICES TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _rotation_has_item(rotation: Dictionary, item_id: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("item_id", "")) == item_id:
			return true
	return false


func _rotation_has_tier(rotation: Dictionary, tier: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("rotation_tier", "")) == tier:
			return true
	return false
