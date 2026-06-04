extends SceneTree

const ContentContractValidatorScript := preload("res://scripts/systems/content_contract_validator.gd")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const DailyGreetingServiceScript := preload("res://scripts/systems/daily_greeting_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

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
	_expect(requests.is_loaded(), "daily request loader should load data contracts")
	_expect(greetings.is_loaded(), "daily greeting loader should load dialogue contracts")
	_expect(requests.get_request("daily_shopkeeper_flower_001").get("ok", false), "data-added request should load without main flow edits")
	_expect(greetings.get_greeting("story_bear").get("ok", false), "data-added greeting should load without network")
	_expect(inventory.get_item("sunny_bed").get("ok", false), "data-added furniture should load from item catalog")
	_expect(save_service.clear_for_test(), "content contract save should clean up")


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
