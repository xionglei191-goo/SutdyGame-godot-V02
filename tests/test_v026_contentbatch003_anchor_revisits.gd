extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const AnchorInteractionServiceScript := preload("res://scripts/systems/anchor_interaction_service.gd")
const ContentContractValidatorScript := preload("res://scripts/systems/content_contract_validator.gd")

const REVISIT_PATH := "res://data/anchors/new_word_revisit_paths.json"
const REQUIRED_FIELDS: Array[String] = ["story_id", "word", "letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]
const NEW_REVISITS: Array[Dictionary] = [
	{"anchor_id": "anchor_a_apple", "letter": "A", "word": "photo", "card_id": "card_a_apple_core"},
	{"anchor_id": "anchor_d_dog", "letter": "D", "word": "towel", "card_id": "card_d_dog_core"},
	{"anchor_id": "anchor_k_kite", "letter": "K", "word": "leaf", "card_id": "card_k_kite_core"},
	{"anchor_id": "anchor_h_hat", "letter": "H", "word": "ribbon", "card_id": "card_h_hat_core"},
	{"anchor_id": "anchor_m_monkey", "letter": "M", "word": "pinecone", "card_id": "card_m_monkey_core"},
	{"anchor_id": "anchor_u_umbrella", "letter": "U", "word": "shell", "card_id": "card_u_umbrella_core"},
]
const FORBIDDEN_TEXT: Array[String] = ["测验", "考试", "背诵", "评分", "正确率", "等级", "倒计时", "错过", "必须", "打卡", "任务", "作业", "分数"]

var failures: Array[String] = []


func _init() -> void:
	_check_revisit_data_contract()
	_check_anchor_service_lookup()
	_check_main_runtime_revisit_paths()
	_finish()


func _check_revisit_data_contract() -> void:
	var data: Dictionary = _load_json(REVISIT_PATH)
	var stories: Array = data.get("stories", [])
	_expect(stories.size() >= 12, "V02.26 CONTENTBATCH-003 should keep old stories and add a small batch")
	var core_anchors: Dictionary = _core_anchor_index()
	var seen_story_ids: Dictionary = {}
	var seen_anchor_ids: Dictionary = {}
	for story_value in stories:
		_expect(story_value is Dictionary, "V02.26 CONTENTBATCH-003 story entry should be object")
		if not story_value is Dictionary:
			continue
		var story: Dictionary = story_value
		for field in REQUIRED_FIELDS:
			_expect(not str(story.get(field, "")).is_empty(), "V02.26 CONTENTBATCH-003 story should include %s" % field)
		var story_id := str(story.get("story_id", ""))
		var anchor_id := str(story.get("core_anchor_id", ""))
		_expect(not seen_story_ids.has(story_id), "V02.26 CONTENTBATCH-003 story_id should be unique: %s" % story_id)
		_expect(not seen_anchor_ids.has(anchor_id), "V02.26 CONTENTBATCH-003 core_anchor_id should not overwrite another story: %s" % anchor_id)
		_expect(core_anchors.has(anchor_id), "V02.26 CONTENTBATCH-003 story should bind known core anchor: %s" % anchor_id)
		if core_anchors.has(anchor_id):
			_expect(str(core_anchors[anchor_id].get("letter", "")) == str(story.get("letter", "")), "V02.26 CONTENTBATCH-003 story letter should match core anchor: %s" % anchor_id)
		_expect(_child_safe(story), "V02.26 CONTENTBATCH-003 story text should remain child-safe: %s" % story_id)
		seen_story_ids[story_id] = true
		seen_anchor_ids[anchor_id] = true

	for expected in NEW_REVISITS:
		var anchor_id := str(expected.get("anchor_id", ""))
		var story: Dictionary = _story_by_anchor(stories, anchor_id)
		_expect(not story.is_empty(), "V02.26 CONTENTBATCH-003 should include new story for %s" % anchor_id)
		_expect(str(story.get("letter", "")) == str(expected.get("letter", "")), "V02.26 CONTENTBATCH-003 new story should keep expected letter: %s" % anchor_id)
		_expect(str(story.get("word", "")) == str(expected.get("word", "")), "V02.26 CONTENTBATCH-003 new story should keep expected word: %s" % anchor_id)
		_expect(str(story.get("story_memory", "")).to_lower().contains(str(expected.get("word", "")).to_lower()), "V02.26 CONTENTBATCH-003 story memory should include object word: %s" % anchor_id)

	var validation: Dictionary = ContentContractValidatorScript.new().validate_all()
	_expect(validation.get("ok", false), "V02.26 CONTENTBATCH-003 content contracts should pass: %s" % [validation.get("errors", [])])


func _check_anchor_service_lookup() -> void:
	var save_service = SaveServiceScript.new("user://test_v026_contentbatch003_service.json")
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-003 service save should clear")
	var card_service = MemoryCardServiceScript.new(save_service)
	var service = AnchorInteractionServiceScript.new(save_service, card_service)
	_expect(service.is_loaded(), "V02.26 CONTENTBATCH-003 service should load: %s" % [service.load_errors])
	_expect(service.get_all_stories().size() >= 12, "V02.26 CONTENTBATCH-003 service should expose all unique story anchors")
	var anchors: Array = _world_anchors()
	for expected in NEW_REVISITS:
		var anchor_id := str(expected.get("anchor_id", ""))
		var story: Dictionary = service.get_story_for_anchor(anchor_id)
		_expect(not story.is_empty(), "V02.26 CONTENTBATCH-003 service should find story: %s" % anchor_id)
		_expect(str(story.get("word", "")) == str(expected.get("word", "")), "V02.26 CONTENTBATCH-003 service story should keep word: %s" % anchor_id)
		var result: Dictionary = service.interact_with_anchor(_anchor_by_id(anchors, anchor_id))
		_expect(result.get("ok", false), "V02.26 CONTENTBATCH-003 service interaction should succeed: %s" % anchor_id)
		_expect(str(result.get("story", {}).get("word", "")) == str(expected.get("word", "")), "V02.26 CONTENTBATCH-003 service interaction should return story: %s" % anchor_id)
		_expect(bool(card_service.get_card_state(str(expected.get("card_id", ""))).get("collected", false)), "V02.26 CONTENTBATCH-003 service should update card state: %s" % anchor_id)
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-003 service save should clean up")


func _check_main_runtime_revisit_paths() -> void:
	var save_path := "user://test_v026_contentbatch003_main.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-003 main save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_003")
	root.add_child(main)
	main.call("_ready")
	var anchors: Array = _world_anchors()
	for expected in NEW_REVISITS:
		var anchor_id := str(expected.get("anchor_id", ""))
		var anchor: Dictionary = _anchor_by_id(anchors, anchor_id)
		var position: Dictionary = anchor.get("position", {})
		var cell := Vector2i(int(position.get("x", 0)), int(position.get("y", 0)))
		_expect(main.move_player_to_cell(cell).get("ok", false), "V02.26 CONTENTBATCH-003 player should reach anchor: %s" % anchor_id)
		var target: Dictionary = main.get_current_interaction_target()
		_expect(str(target.get("type", "")) == "anchor" and str(target.get("target_id", "")) == anchor_id, "V02.26 CONTENTBATCH-003 prompt should target anchor: %s" % anchor_id)
		var result: Dictionary = main.interact_nearby()
		_expect(str(result.get("interaction_type", "")) == "anchor" and str(result.get("anchor_id", "")) == anchor_id, "V02.26 CONTENTBATCH-003 interaction should preserve anchor: %s" % anchor_id)
		_expect(str(result.get("story", {}).get("word", "")) == str(expected.get("word", "")), "V02.26 CONTENTBATCH-003 runtime story should match word: %s" % anchor_id)
		_expect(str(result.get("text", "")).contains(str(anchor.get("core_word", ""))), "V02.26 CONTENTBATCH-003 runtime feedback should mention core object: %s" % anchor_id)
		_expect(_child_safe(result.get("text", "")), "V02.26 CONTENTBATCH-003 runtime feedback should stay child-safe: %s" % anchor_id)
		var card_state: Dictionary = main.memory_card_service.get_card_state(str(expected.get("card_id", "")))
		_expect(bool(card_state.get("seen", false)) and bool(card_state.get("collected", false)), "V02.26 CONTENTBATCH-003 runtime should update album state: %s" % anchor_id)
	_expect(save_service.clear_for_test(), "V02.26 CONTENTBATCH-003 main save should clean up")
	root.remove_child(main)
	main.queue_free()


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "V02.26 CONTENTBATCH-003 should open JSON: %s" % path)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	_expect(parsed is Dictionary, "V02.26 CONTENTBATCH-003 JSON should be object: %s" % path)
	if parsed is Dictionary:
		return parsed
	return {}


func _core_anchor_index() -> Dictionary:
	var data: Dictionary = _load_json("res://data/anchors/az_core_anchors.json")
	var index: Dictionary = {}
	for anchor_value in data.get("anchors", []):
		if anchor_value is Dictionary:
			index[str((anchor_value as Dictionary).get("anchor_id", ""))] = anchor_value
	return index


func _world_anchors() -> Array:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(result.get("ok", false), "V02.26 CONTENTBATCH-003 should load world map")
	return result.get("data", {}).get("memory_anchors", [])


func _anchor_by_id(anchors: Array, anchor_id: String) -> Dictionary:
	for anchor_value in anchors:
		if anchor_value is Dictionary and str((anchor_value as Dictionary).get("anchor_id", "")) == anchor_id:
			return anchor_value
	_expect(false, "V02.26 CONTENTBATCH-003 should find world anchor: %s" % anchor_id)
	return {}


func _story_by_anchor(stories: Array, anchor_id: String) -> Dictionary:
	for story_value in stories:
		if story_value is Dictionary and str((story_value as Dictionary).get("core_anchor_id", "")) == anchor_id:
			return story_value
	return {}


func _child_safe(value: Variant) -> bool:
	if value is Dictionary:
		for key in (value as Dictionary).keys():
			if not _child_safe((value as Dictionary)[key]):
				return false
	elif value is Array:
		for item in value:
			if not _child_safe(item):
				return false
	else:
		var text := str(value)
		for forbidden in FORBIDDEN_TEXT:
			if text.contains(forbidden):
				return false
	return true


func _finish() -> void:
	if failures.is_empty():
		print("V02.26 CONTENTBATCH-003 ANCHOR REVISIT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
