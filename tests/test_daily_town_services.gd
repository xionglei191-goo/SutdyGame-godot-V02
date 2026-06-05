extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const DailyGreetingServiceScript := preload("res://scripts/systems/daily_greeting_service.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const ResourceRefreshServiceScript := preload("res://scripts/systems/resource_refresh_service.gd")
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_daily_town_services.json")
	_expect(save_service.clear_for_test(), "daily town save should clear")
	_expect(save_service.reset_for_test(), "daily town save should reset")

	var day = LocalDayServiceScript.new("2026-06-04")
	var inventory = InventoryServiceScript.new(save_service)
	var greetings = DailyGreetingServiceScript.new(save_service, day)
	var requests = DailyRequestServiceScript.new(save_service, inventory, day)
	var resources = ResourceRefreshServiceScript.new(save_service, inventory, day)
	var today = TodayStatusServiceScript.new(day)

	_expect(greetings.is_loaded(), "DailyGreetingService should load: %s" % [greetings.load_errors])
	_expect(requests.is_loaded(), "DailyRequestService should load: %s" % [requests.load_errors])
	_expect(resources.is_loaded(), "ResourceRefreshService should load: %s" % [resources.load_errors])
	_expect(today.is_loaded(), "TodayStatusService should load: %s" % [today.load_errors])

	var first_greeting: Dictionary = greetings.interact_for_npc("mina", false)
	_expect(first_greeting.get("ok", false) and bool(first_greeting.get("first_today", false)), "first Mina greeting should be daily first")
	_expect(str(first_greeting.get("text", "")).length() > 0, "daily greeting should be gentle Chinese town text")
	_expect(str(first_greeting.get("weather_event_id", "")).begins_with("event_weather_"), "daily greeting should carry weather event context")
	var second_blocked: Dictionary = greetings.interact_for_npc("mina", false)
	_expect(not bool(second_blocked.get("handled", true)), "first-only greeting should not repeat as first")
	var greeting_state: Dictionary = save_service.load_game_state().get("daily_greetings", {}).get("2026-06-04", {}).get("mina", {})
	_expect(bool(greeting_state.get("greeted", false)), "daily greeting state should persist by day and NPC")

	var branch_collect: Dictionary = resources.collect_resource("resource_branch_bear_corner")
	_expect(branch_collect.get("ok", false), "branch resource should collect once")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("branch", 0)) == 1, "branch should enter inventory")
	var duplicate_branch: Dictionary = resources.collect_resource("resource_branch_bear_corner")
	_expect(not duplicate_branch.get("ok", true) and duplicate_branch.get("reason", "") == "already_collected_today", "same resource should not repeat in one day")
	day.set_day_key_for_test("2026-06-05")
	var next_day_branch: Dictionary = resources.collect_resource("resource_branch_bear_corner")
	_expect(next_day_branch.get("ok", false), "resource should refresh across day key")

	day.set_day_key_for_test("2026-06-04")
	var flower_point: Dictionary = resources.get_point("resource_flower_sun_plaza")
	_expect(int(flower_point.get("quantity", 0)) == 2, "weather hints should not reduce flower quantity")
	_expect(resources.collect_resource("resource_flower_sun_plaza").get("ok", false), "flower resource should collect")
	_expect(resources.collect_resource("resource_stone_taxi_stop").get("ok", false), "stone resource should collect")

	var shop_start: Dictionary = requests.interact_for_npc("shopkeeper")
	_expect(shop_start.get("request_status", "") == "active", "shopkeeper request should start")
	var shop_complete: Dictionary = requests.interact_for_npc("shopkeeper")
	_expect(shop_complete.get("request_status", "") == "completed", "shopkeeper request should complete with flower")
	var bear_start: Dictionary = requests.interact_for_npc("story_bear")
	_expect(bear_start.get("request_status", "") == "active", "story bear request should start")
	var bear_complete: Dictionary = requests.interact_for_npc("story_bear")
	_expect(bear_complete.get("request_status", "") == "completed", "story bear request should complete with stone")
	var sunny_start: Dictionary = requests.interact_for_npc("pet_buddy")
	_expect(sunny_start.get("request_status", "") == "active", "Sunny request should start")
	var sunny_complete: Dictionary = requests.interact_for_npc("pet_buddy")
	_expect(sunny_complete.get("request_status", "") == "completed", "Sunny request should complete with second flower")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("branch", 0)) >= 2, "Sunny material reward should add branch")

	var today_status: Dictionary = today.get_today_status()
	_expect(today_status.get("ok", false), "today status should resolve")
	_expect(str(today_status.get("hud_text", "")).contains("Sunny"), "today HUD text should include Sunny soft hint")
	_expect(str(today_status.get("weather_event_id", "")).begins_with("event_weather_"), "today status should bind a weather event")
	_expect(str(today_status.get("hud_text", "")).contains(str(today_status.get("today_status_text", ""))), "today HUD should show weather event short text")
	_expect(str(today_status.get("shop_rotation_id", "")).begins_with("shop_rotation_day_"), "date-based status should keep stable weekly rotation")
	var seen_events: Dictionary = {}
	var seen_weather_events: Dictionary = {}
	var seen_weather_greetings: Dictionary = {}
	for day_index in range(1, 8):
		var weekly_day = LocalDayServiceScript.new("local_day_%03d" % day_index)
		var weekly_status_service = TodayStatusServiceScript.new(weekly_day)
		var weekly_greetings = DailyGreetingServiceScript.new(save_service, weekly_day)
		var weekly_resources = ResourceRefreshServiceScript.new(save_service, inventory, weekly_day)
		var weekly_status: Dictionary = weekly_status_service.get_today_status()
		_expect(weekly_status.get("ok", false), "weekly local day status should resolve")
		_expect(str(weekly_status.get("day_key", "")) == "local_day_%03d" % day_index, "weekly local day should preserve requested key")
		_expect(str(weekly_status.get("anchor_hint", "")).length() > 0, "weekly status should include A-Z anchor hint")
		_expect(str(weekly_status.get("weather_event_id", "")).begins_with("event_weather_"), "weekly status should include weather event")
		var weather_event_id := str(weekly_status.get("weather_event_id", ""))
		var greeting_npc := _weather_test_npc(weather_event_id)
		var weather_greeting: Dictionary = weekly_greetings.interact_for_npc(greeting_npc)
		_expect(str(weather_greeting.get("weather_event_id", "")) == weather_event_id, "weather greeting should match status event: %s" % weather_event_id)
		_expect(str(weather_greeting.get("greeting_variant_id", "")).begins_with("weather_"), "weather greeting should use a data variant: %s" % weather_event_id)
		seen_weather_greetings[weather_event_id] = true
		var available_points: Array = weekly_resources.get_available_points()
		_expect(available_points.size() >= 3, "weather should not hide baseline resource points: %s" % weather_event_id)
		for point in available_points:
			if point is Dictionary:
				_expect(int((point as Dictionary).get("quantity", 0)) >= 1, "weather should not reduce resource quantity below 1")
		seen_events[str(weekly_status.get("event", ""))] = true
		seen_weather_events[weather_event_id] = true
	_expect(seen_events.size() == 7, "weekly statuses should not repeat the same event to fill 7 days")
	_expect(seen_weather_events.size() == 4, "weekly statuses should cover four P0 weather events")
	_expect(seen_weather_greetings.size() == 4, "weekly greetings should cover four P0 weather variants")

	_expect(save_service.clear_for_test(), "daily town save should clean up")
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("DAILY TOWN SERVICES TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _weather_test_npc(weather_event_id: String) -> String:
	match weather_event_id:
		"event_weather_sunny_soft_001":
			return "pet_buddy"
		"event_weather_breezy_kite_001":
			return "bus_helper"
		"event_weather_after_rain_001":
			return "mina"
		"event_weather_light_rain_001":
			return "story_bear"
	return "mina"
