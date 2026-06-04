extends SceneTree

const CONFIG_PATH := "res://data/quests/pet_food_loop.json"
const EXPECTED_TITLES := [
	"Welcome Home",
	"Meet Sunny",
	"Snack Time",
	"Food Trip",
	"Letter Snake",
	"Food Basket",
	"Feed Sunny",
]
const BLOCKED_TERMS := ["lesson", "test", "failed", "word list", "review"]

var failures: Array[String] = []


func _init() -> void:
	var config := _load_config()
	if config.is_empty():
		_finish()
		return

	_check_chain_order(config)
	_check_state_contract(config)
	_check_rewards_are_non_punitive(config)
	_check_purchase_and_feed_rules(config)
	_check_child_language(config)
	_finish()


func _load_config() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_PATH):
		_expect(false, "pet food loop config must exist")
		return {}

	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file == null:
		_expect(false, "pet food loop config must be readable")
		return {}

	var parsed = JSON.parse_string(file.get_as_text())
	_expect(typeof(parsed) == TYPE_DICTIONARY, "pet food loop config must be valid JSON object")
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed


func _check_chain_order(config: Dictionary) -> void:
	var chain: Array = config.get("quest_chain", [])
	_expect(chain.size() == EXPECTED_TITLES.size(), "quest chain must contain the first loop events")

	var seen_ids: Dictionary = {}
	for index in range(chain.size()):
		var event: Dictionary = chain[index]
		_expect(not seen_ids.has(event.get("event_id", "")), "event ids must be unique")
		seen_ids[event.get("event_id", "")] = true
		_expect(int(event.get("order", -1)) == index + 1, "event order must be sequential")
		_expect(event.get("child_title", "") == EXPECTED_TITLES[index], "event title order mismatch at index %d" % index)
		if index < chain.size() - 1:
			_expect(event.get("next_event_id", "") == chain[index + 1].get("event_id", ""), "next_event_id must point to the next event")
		else:
			_expect(event.get("next_event_id", "") == "", "last event must close the chain")


func _check_state_contract(config: Dictionary) -> void:
	var contract: Dictionary = config.get("state_contract", {})
	var inputs: Array = contract.get("inputs", [])
	var outputs: Array = contract.get("outputs", [])
	for required in ["coins", "inventory.food_pet_snack", "pet.hunger", "pet.happy", "cards", "flags"]:
		_expect(inputs.has(required), "state inputs must include %s" % required)
		_expect(outputs.has(required), "state outputs must include %s" % required)
	_expect(outputs.has("save_snapshot"), "state outputs must include save_snapshot")


func _check_rewards_are_non_punitive(config: Dictionary) -> void:
	var economy: Dictionary = config.get("economy", {})
	_expect(int(economy.get("coin_floor_per_letter_snake_run", 0)) > 0, "coin floor must be positive")
	_expect(economy.get("low_result_policy", "") == "always_small_reward", "low result policy must grant a small reward")

	var letter_snake: Dictionary = config.get("reward_rules", {}).get("letter_snake_food", {})
	var floor: Dictionary = letter_snake.get("non_punitive_floor", {})
	_expect(int(floor.get("coins", 0)) > 0, "non-punitive floor coins must be positive")
	_expect(int(floor.get("card_spark", 0)) > 0, "non-punitive floor card spark must be positive")

	var previous_coins := -1
	for reward in letter_snake.get("coin_rewards", []):
		var coins := int(reward.get("coins", -1))
		_expect(coins > 0, "each result band must award coins")
		_expect(int(reward.get("card_spark", -1)) > 0, "each result band must award card spark")
		_expect(coins >= previous_coins, "coin rewards must not decrease across stronger result bands")
		previous_coins = coins


func _check_purchase_and_feed_rules(config: Dictionary) -> void:
	var economy: Dictionary = config.get("economy", {})
	var buy_rule: Dictionary = config.get("reward_rules", {}).get("buy_pet_food", {})
	var feed_rule: Dictionary = config.get("reward_rules", {}).get("feed_pet", {})

	_expect(int(economy.get("food_price", -1)) == int(buy_rule.get("spend_coins", -2)), "food price and spend_coins must match")
	_expect(int(buy_rule.get("requires_min_coins", 0)) >= int(economy.get("food_price", 0)), "purchase must require enough coins")
	_expect(int(buy_rule.get("add_inventory", {}).get("food_pet_snack", 0)) == 1, "purchase must add one snack")
	_expect(int(feed_rule.get("consume_inventory", {}).get("food_pet_snack", 0)) == 1, "feed must consume one snack")

	var pet_delta: Dictionary = feed_rule.get("pet_delta", {})
	_expect(int(pet_delta.get("hunger", 0)) < 0, "feeding must reduce hunger")
	_expect(int(pet_delta.get("happy", 0)) > 0, "feeding must increase happy")
	_expect(feed_rule.get("save_flags", {}).get("sunny_first_snack_done", false), "feeding must set completion save flag")


func _check_child_language(config: Dictionary) -> void:
	var child_texts: Array[String] = [
		str(config.get("title", "")),
		str(config.get("economy", {}).get("food_display_name", "")),
	]
	for event in config.get("quest_chain", []):
		child_texts.append(str(event.get("child_title", "")))

	for text in child_texts:
		var lowered := text.to_lower()
		for term in BLOCKED_TERMS:
			_expect(lowered.find(term) == -1, "child-facing text must not contain blocked term '%s': %s" % [term, text])


func _finish() -> void:
	if failures.is_empty():
		print("PET FOOD LOOP CONFIG TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
