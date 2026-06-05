extends SceneTree

const ContentContractValidatorScript := preload("res://scripts/systems/content_contract_validator.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const DailyGreetingServiceScript := preload("res://scripts/systems/daily_greeting_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const SchoolDayStateServiceScript := preload("res://scripts/systems/school_day_state_service.gd")
const TodayStatusServiceScript := preload("res://scripts/systems/today_status_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var validator = ContentContractValidatorScript.new()
	var result: Dictionary = validator.validate_all()
	_expect(result.get("ok", false), "content contracts should pass: %s" % [result.get("errors", [])])
	_check_candidate_pack_rejection(validator)
	_check_data_driven_runtime_loaders()
	_finish()


func _check_candidate_pack_rejection(validator) -> void:
	var blocked: Dictionary = validator.validate_candidate_content_pack({
		"anchors": [{"anchor_id": "anchor_a_apple", "letter": "A"}],
		"new_word_stories": [],
	})
	_expect(not blocked.get("ok", true), "content pack validator should block core A-Z anchor overrides")
	var missing_story: Dictionary = validator.validate_candidate_content_pack({
		"anchors": [],
		"new_word_stories": [{"story_id": "bad_story", "core_anchor_id": "anchor_b_bear"}],
	})
	_expect(not missing_story.get("ok", true), "content pack validator should block incomplete new-word stories")


func _check_data_driven_runtime_loaders() -> void:
	var save_service = SaveServiceScript.new("user://test_v024_content_contracts.json")
	_expect(save_service.clear_for_test(), "content contract save should clear")
	_expect(save_service.reset_for_test(), "content contract save should reset")
	var inventory = InventoryServiceScript.new(save_service)
	var requests = DailyRequestServiceScript.new(save_service, inventory)
	var greetings = DailyGreetingServiceScript.new(save_service)
	var today = TodayStatusServiceScript.new(LocalDayServiceScript.new("local_day_001"))
	var school_day = SchoolDayStateServiceScript.new(LocalDayServiceScript.new("local_day_001"))
	var shop = LifeShopServiceScript.new(save_service, inventory)
	_expect(requests.is_loaded(), "daily request loader should load data contracts")
	_expect(greetings.is_loaded(), "daily greeting loader should load dialogue contracts")
	_expect(today.is_loaded(), "today status loader should load weekly status contracts")
	_expect(school_day.is_loaded(), "school day state loader should load V02.15 state contracts")
	_expect(requests.get_request("daily_shopkeeper_flower_001").get("ok", false), "data-added request should load without main flow edits")
	_expect(greetings.get_greeting("story_bear").get("ok", false), "data-added greeting should load without network")
	_expect(inventory.get_item("sunny_bed").get("ok", false), "data-added furniture should load from item catalog")
	_expect(today.get_all_statuses().size() == 7, "weekly status contract should expose 7 local days")
	_expect(school_day.get_all_states().size() == 7, "school day state contract should expose 7 local days")
	_expect(today.get_all_weather_events().size() == 4, "weather event contract should expose four P0 events")
	var seen_weather_events: Dictionary = {}
	for day_index in range(1, 8):
		var day_key := "local_day_%03d" % day_index
		var status_for_day = TodayStatusServiceScript.new(LocalDayServiceScript.new(day_key))
		var school_for_day = SchoolDayStateServiceScript.new(LocalDayServiceScript.new(day_key))
		var status: Dictionary = status_for_day.get_today_status()
		var school_state: Dictionary = school_for_day.get_today_school_state()
		_expect(status.get("ok", false), "weekly status should resolve: %s" % day_key)
		_expect(school_state.get("ok", false), "school day state should resolve: %s" % day_key)
		_expect(str(status.get("day_key", "")) == day_key, "weekly status should keep requested day key: %s" % day_key)
		_expect(str(school_state.get("day_key", "")) == day_key, "school day state should keep requested day key: %s" % day_key)
		_expect(str(status.get("shop_rotation_id", "")).begins_with("shop_rotation_day_"), "weekly status should bind shop rotation: %s" % day_key)
		_expect(str(status.get("anchor_hint", "")).length() > 0, "weekly status should include anchor hint: %s" % day_key)
		_expect(str(status.get("weather_event_id", "")).begins_with("event_weather_"), "weekly status should bind weather event: %s" % day_key)
		_expect(str(status.get("today_status_text", "")).length() > 0, "weekly status should expose weather HUD text: %s" % day_key)
		_expect(str(status.get("hud_text", "")).contains(str(status.get("today_status_text", ""))), "HUD text should include weather event text: %s" % day_key)
		seen_weather_events[str(status.get("weather_event_id", ""))] = true
		var rotation: Dictionary = shop.get_shop_rotation(str(status.get("shop_rotation_id", "")))
		_expect(rotation.get("ok", false), "weekly shop rotation should resolve from status: %s" % day_key)
		_expect(_rotation_has_tier(rotation, "P0"), "weekly shop rotation should keep P0 offers: %s" % day_key)
		_expect(_rotation_has_item(rotation, "wooden_chair"), "weekly shop rotation should keep wooden chair: %s" % day_key)
		_expect(str(rotation.get("weather_activity_corner", {}).get("weather_event_id", "")) == str(status.get("weather_event_id", "")), "shop activity corner should match weather event: %s" % day_key)
		for stage in ["home_school_walk", "school_gate", "school_yard", "return_home"]:
			var entry: Dictionary = school_for_day.get_entry(stage)
			_expect(str(entry.get("day_key", "")) == day_key, "school day entry should inherit day_key: %s %s" % [day_key, stage])
			_expect(str(entry.get("stage", "")) == stage, "school day entry should keep stage: %s %s" % [day_key, stage])
			_expect(not entry.get("anchor_ids", []).is_empty(), "school day entry should bind anchors: %s %s" % [day_key, stage])
			_expect(not entry.get("environment_words", []).is_empty(), "school day entry should bind environment words: %s %s" % [day_key, stage])
			_expect(str(entry.get("child_facing_text", "")).length() > 0, "school day entry should expose child-facing text: %s %s" % [day_key, stage])
			_expect(str(entry.get("safety_note", "")).length() > 0, "school day entry should expose safety note: %s %s" % [day_key, stage])
	for event_id in [
		"event_weather_sunny_soft_001",
		"event_weather_breezy_kite_001",
		"event_weather_after_rain_001",
		"event_weather_light_rain_001",
	]:
		_expect(seen_weather_events.has(event_id), "today status should reference required P0 weather event: %s" % event_id)
	_expect(save_service.clear_for_test(), "content contract save should clean up")


func _rotation_has_tier(rotation: Dictionary, tier: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("rotation_tier", "")) == tier:
			return true
	return false


func _rotation_has_item(rotation: Dictionary, item_id: String) -> bool:
	for offer in rotation.get("offers", []):
		if offer is Dictionary and str((offer as Dictionary).get("item_id", "")) == item_id:
			return true
	return false


func _finish() -> void:
	if failures.is_empty():
		print("V02.4 CONTENT CONTRACT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
