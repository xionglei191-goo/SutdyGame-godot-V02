extends SceneTree

const CONFIG_PATH := "res://data/minigames/letter_snake_config.json"
const BLOCKED_CHILD_TERMS := ["failed", "wrong", "test"]

var failures: Array[String] = []


func _init() -> void:
	var config := _load_config()
	_expect(not config.is_empty(), "letter snake config must load")
	if config.is_empty():
		_finish()
		return

	_expect(config.get("schema_version") == 1, "schema version must be 1")
	_expect(config.get("minigame_id") == "letter_snake", "minigame_id must be letter_snake")
	_expect(config.get("return_scene") == "world_overview", "return_scene must return to world overview")
	_check_result_schema(config.get("result_schema", {}))
	_check_sets(config.get("sets", []))
	_check_reward_profile(config.get("reward_profile", {}))
	_check_child_facing_terms(config)
	_finish()


func _load_config() -> Dictionary:
	if not FileAccess.file_exists(CONFIG_PATH):
		_expect(false, "%s must exist" % CONFIG_PATH)
		return {}
	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file == null:
		_expect(false, "%s must be readable" % CONFIG_PATH)
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		_expect(false, "%s must contain a JSON object" % CONFIG_PATH)
		return {}
	return parsed


func _check_result_schema(schema: Dictionary) -> void:
	var required: Array = schema.get("required_fields", [])
	var reward_fields: Array = schema.get("reward_fields", [])
	for field in [
		"minigame_id",
		"config_set_id",
		"score",
		"target_letters_seen",
		"target_words_seen",
		"target_hits",
		"distractor_touches",
		"duration_seconds",
		"reward",
	]:
		_expect(required.has(field), "result schema must include %s" % field)
	for field in ["coins", "card_progress", "collected_chance", "shiny_chance", "spark"]:
		_expect(reward_fields.has(field), "reward schema must include %s" % field)


func _check_sets(sets: Array) -> void:
	var expected := {
		"home": {
			"letters": ["A", "C", "D"],
			"words": ["apple", "clock", "dog"],
		},
		"food": {
			"letters": ["A", "O", "E"],
			"words": ["apple", "orange", "egg"],
		},
		"weather": {
			"letters": ["S", "K", "W"],
			"words": ["sun", "kite", "windy"],
		},
		"transport": {
			"letters": ["B", "T", "W"],
			"words": ["bus", "taxi", "watch"],
		},
	}
	_expect(sets.size() == expected.size(), "config must define exactly four target sets")

	var seen_ids: Array[String] = []
	for item in sets:
		_expect(typeof(item) == TYPE_DICTIONARY, "each target set must be a dictionary")
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var set_id := str(item.get("set_id", ""))
		_expect(expected.has(set_id), "unexpected set_id: %s" % set_id)
		_expect(not seen_ids.has(set_id), "set_id must be unique: %s" % set_id)
		seen_ids.append(set_id)
		if not expected.has(set_id):
			continue
		_expect(_string_array(item.get("target_letters", [])) == expected[set_id]["letters"], "%s target letters must match baseline" % set_id)
		_expect(_string_array(item.get("target_words", [])) == expected[set_id]["words"], "%s target words must match baseline" % set_id)
		_expect(item.get("card_ids", []).size() == item.get("target_words", []).size(), "%s card_ids must match target word count" % set_id)
		_expect(item.get("prompt_templates", []).size() > 0, "%s must define child prompt templates" % set_id)

	for set_id in expected.keys():
		_expect(seen_ids.has(set_id), "missing target set: %s" % set_id)


func _check_reward_profile(profile: Dictionary) -> void:
	var tiers: Array = profile.get("tiers", [])
	_expect(tiers.size() == 3, "reward profile must define three tiers")
	if tiers.size() < 3:
		return

	var low: Dictionary = tiers[0]
	var mid: Dictionary = tiers[1]
	var high: Dictionary = tiers[2]
	_expect(int(low.get("min_score", -1)) == 0, "lowest tier must start at score 0")
	_expect(int(low.get("coins", 0)) > 0, "any score must earn coins")
	_expect(int(mid.get("coins", 0)) > int(low.get("coins", 0)), "mid tier must earn more coins than low tier")
	_expect(int(high.get("coins", 0)) > int(mid.get("coins", 0)), "high tier must earn more coins than mid tier")
	_expect(int(high.get("card_progress", 0)) > int(low.get("card_progress", 0)), "high tier must add more card progress than low tier")
	_expect(float(high.get("collected_chance", 0.0)) > float(mid.get("collected_chance", 0.0)), "high tier must increase collected chance")
	_expect(float(high.get("shiny_chance", 0.0)) > float(low.get("shiny_chance", 0.0)), "high tier must increase shiny chance")


func _check_child_facing_terms(config: Dictionary) -> void:
	var child_texts: Array[String] = [str(config.get("display_name", ""))]
	for tier in config.get("reward_profile", {}).get("tiers", []):
		if typeof(tier) == TYPE_DICTIONARY:
			child_texts.append(str(tier.get("child_feedback", "")))
	for item in config.get("sets", []):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		child_texts.append(str(item.get("child_title", "")))
		for prompt in item.get("prompt_templates", []):
			child_texts.append(str(prompt))

	for text in child_texts:
		var lowered := text.to_lower()
		for term in BLOCKED_CHILD_TERMS:
			_expect(not lowered.contains(term), "child-facing text must not contain blocked term '%s': %s" % [term, text])


func _string_array(value) -> Array[String]:
	var output: Array[String] = []
	for item in value:
		output.append(str(item))
	return output


func _finish() -> void:
	if failures.is_empty():
		print("LETTER SNAKE CONFIG TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
