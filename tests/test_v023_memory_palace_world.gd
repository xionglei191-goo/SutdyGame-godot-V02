extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const AnchorInteractionServiceScript := preload("res://scripts/systems/anchor_interaction_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const MainScene := preload("res://scenes/main.tscn")

const FIRST_BATCH_ANCHORS: Dictionary = {
	"anchor_a_apple": "Apple Tree",
	"anchor_b_bear": "Bear Corner",
	"anchor_c_clock": "Clock Tower",
	"anchor_d_dog": "Dog House",
	"anchor_k_kite": "Kite Hill",
	"anchor_o_orange": "Orange Stand",
	"anchor_s_sun": "Sun Plaza",
	"anchor_t_taxi": "Taxi Stop",
	"anchor_w_watch": "Watch Sign",
}
const REQUIRED_STORY_FIELDS := ["letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]
const DAILYLIFE_REVISIT_ANCHORS: Array[Dictionary] = [
	{"anchor_id": "anchor_c_clock", "card_id": "card_c_clock_core", "core_word": "Clock", "story_hint": "chair"},
	{"anchor_id": "anchor_o_orange", "card_id": "card_o_orange_core", "core_word": "Orange", "story_hint": "bowl"},
	{"anchor_id": "anchor_s_sun", "card_id": "card_s_sun_core", "core_word": "Sun", "story_hint": "flower"},
]
const WEATHER_ALBUM_REVISITS: Array[Dictionary] = [
	{"day_key": "local_day_001", "event_id": "event_weather_sunny_soft_001", "anchor_id": "anchor_s_sun", "card_id": "card_s_sun_core", "core_word": "Sun", "tag": "Sunny day.", "environment_word": "sunny"},
	{"day_key": "local_day_002", "event_id": "event_weather_breezy_kite_001", "anchor_id": "anchor_k_kite", "card_id": "card_k_kite_core", "core_word": "Kite", "tag": "Windy Kite.", "environment_word": "windy"},
	{"day_key": "local_day_004", "event_id": "event_weather_light_rain_001", "anchor_id": "anchor_b_bear", "card_id": "card_b_bear_core", "core_word": "Bear", "tag": "Light Rain.", "environment_word": "rainy", "look_cell": Vector2i(13, 7)},
	{"day_key": "local_day_006", "event_id": "event_weather_after_rain_001", "anchor_id": "anchor_u_umbrella", "card_id": "card_u_umbrella_core", "core_word": "Umbrella", "tag": "After Rain.", "environment_word": "after rain"},
]

var failures: Array[String] = []


func _init() -> void:
	_check_anchor_interaction_service()
	_check_main_scene_anchor_interaction()
	_check_new_word_revisit_data()
	_check_weather_album_anchor_revisits()
	_finish()


func _check_anchor_interaction_service() -> void:
	var save_service = SaveServiceScript.new("user://test_v023_anchor_service.json")
	_expect(save_service.clear_for_test(), "anchor service save should clear")
	_expect(save_service.reset_for_test(), "anchor service save should reset")
	var card_service = MemoryCardServiceScript.new(save_service)
	var service = AnchorInteractionServiceScript.new(save_service, card_service)
	_expect(service.is_loaded(), "AnchorInteractionService should load stories: %s" % [service.load_errors])
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	var anchor: Dictionary = _anchor_by_id(map_result.get("data", {}).get("memory_anchors", []), "anchor_b_bear")
	var result: Dictionary = service.interact_with_anchor(anchor)
	_expect(result.get("ok", false), "anchor interaction should succeed")
	_expect(result.get("interaction_type", "") == "anchor", "anchor interaction should report anchor context")
	_expect(str(result.get("card_id", "")) == "card_b_bear_core", "anchor interaction should bind card")
	_expect(str(result.get("text", "")).contains("Bear"), "anchor interaction should include world object story text")
	var state: Dictionary = card_service.get_card_state("card_b_bear_core")
	_expect(bool(state.get("seen", false)) and bool(state.get("heard", false)) and bool(state.get("collected", false)), "anchor interaction should update album collection state")
	_expect(save_service.clear_for_test(), "anchor service save should clean up")


func _check_main_scene_anchor_interaction() -> void:
	var main = MainScene.instantiate()
	main.configure_for_test("user://test_v023_main_anchor.json")
	root.add_child(main)
	main.call("_ready")
	main.save_service.clear_for_test()
	main.call("_ready")
	for anchor_id in FIRST_BATCH_ANCHORS.keys():
		var anchor_node := main.find_child(anchor_id, true, false)
		_expect(anchor_node != null and anchor_node is Node2D, "%s should exist as a world object node" % anchor_id)
		_expect(anchor_node != null and anchor_node.find_child("ObjectSprite", true, false) is Sprite2D, "%s should use sprite object art" % anchor_id)
		_expect(not (anchor_node != null and anchor_node.find_child("ObjectLabel", true, false) is Label), "%s should not be represented by a bare label" % anchor_id)
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	var apple_anchor: Dictionary = _anchor_by_id(map_result.get("data", {}).get("memory_anchors", []), "anchor_a_apple")
	var position: Dictionary = apple_anchor.get("position", {})
	_expect(main.move_player_to_cell(Vector2i(int(position.get("x", 0)), int(position.get("y", 0)))).get("ok", false), "player should move to Apple anchor")
	var result: Dictionary = main.interact_nearby()
	_expect(result.get("ok", false), "main Interact should trigger anchor interaction")
	_expect(result.get("interaction_type", "") == "anchor", "main Interact should report anchor context")
	var card_state: Dictionary = main.memory_card_service.get_card_state("card_a_apple_core")
	_expect(bool(card_state.get("collected", false)), "main anchor interaction should update album state")
	_expect(str(main.life_status_label.text).contains("Apple"), "main HUD should show anchor discovery text")
	for revisit in DAILYLIFE_REVISIT_ANCHORS:
		_check_daily_life_anchor_revisit(main, map_result.get("data", {}).get("memory_anchors", []), revisit)
	root.remove_child(main)
	main.queue_free()


func _check_new_word_revisit_data() -> void:
	var data: Dictionary = _load_json("res://data/anchors/new_word_revisit_paths.json")
	var stories: Array = data.get("stories", [])
	_expect(stories.size() >= 5, "V02.3 should include first new-word revisit stories")
	var seen_ids: Dictionary = {}
	for story_value in stories:
		_expect(story_value is Dictionary, "new-word story should be object")
		if not story_value is Dictionary:
			continue
		var story: Dictionary = story_value
		var story_id := str(story.get("story_id", ""))
		_expect(not story_id.is_empty(), "new-word story should have stable story_id")
		_expect(not seen_ids.has(story_id), "new-word story IDs should be unique: %s" % story_id)
		seen_ids[story_id] = true
		for field in REQUIRED_STORY_FIELDS:
			_expect(not str(story.get(field, "")).is_empty(), "new-word story missing %s: %s" % [field, story_id])
		_expect(str(story.get("core_anchor_id", "")).begins_with("anchor_"), "new-word story should bind core anchor")
		_expect(str(story.get("world_place_id", "")).begins_with("place_"), "new-word story should bind world place")
	for revisit in DAILYLIFE_REVISIT_ANCHORS:
		var story: Dictionary = _story_by_anchor(stories, str(revisit.get("anchor_id", "")))
		_expect(not story.is_empty(), "V02.8 daily life revisit story should exist for %s" % revisit.get("anchor_id", ""))
		_expect(str(story.get("story_memory", "")).to_lower().contains(str(revisit.get("story_hint", "")).to_lower()), "V02.8 revisit story should stay tied to daily life object: %s" % revisit.get("anchor_id", ""))


func _check_daily_life_anchor_revisit(main, anchors: Array, revisit: Dictionary) -> void:
	var anchor_id := str(revisit.get("anchor_id", ""))
	var card_id := str(revisit.get("card_id", ""))
	var core_word := str(revisit.get("core_word", ""))
	var anchor: Dictionary = _anchor_by_id(anchors, anchor_id)
	var position: Dictionary = anchor.get("position", {})
	_expect(main.move_player_to_cell(Vector2i(int(position.get("x", 0)), int(position.get("y", 0)))).get("ok", false), "player should move to %s revisit anchor" % anchor_id)
	var result: Dictionary = main.interact_nearby()
	_expect(result.get("ok", false), "%s should trigger through the visible Interact path" % anchor_id)
	_expect(result.get("interaction_type", "") == "anchor", "%s should report anchor interaction context" % anchor_id)
	_expect(result.get("anchor_id", "") == anchor_id, "%s should preserve anchor id" % anchor_id)
	_expect(result.get("card_id", "") == card_id, "%s should bind the expected card" % anchor_id)
	_expect(str(result.get("text", "")).contains(core_word), "%s feedback should include the place object story, got: %s" % [anchor_id, result.get("text", "")])
	var story: Dictionary = result.get("story", {})
	for field in REQUIRED_STORY_FIELDS:
		_expect(not str(story.get(field, "")).is_empty(), "%s visible revisit story should include %s" % [anchor_id, field])
	var text := str(result.get("text", ""))
	for forbidden in ["测验", "考试", "背诵", "评分", "倒计时", "失败"]:
		_expect(not text.contains(forbidden), "%s should not use test-like wording: %s" % [anchor_id, forbidden])
	var card_state: Dictionary = main.memory_card_service.get_card_state(card_id)
	_expect(bool(card_state.get("seen", false)) and bool(card_state.get("collected", false)), "%s should update album state through visible Interact" % anchor_id)
	_expect(str(main.life_status_label.text).contains(core_word), "%s HUD should show daily-life anchor feedback" % anchor_id)


func _check_weather_album_anchor_revisits() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	var anchors: Array = map_result.get("data", {}).get("memory_anchors", [])
	for revisit in WEATHER_ALBUM_REVISITS:
		var save_path := "user://test_v023_weather_album_%s.json" % str(revisit.get("event_id", "event"))
		var save_service = SaveServiceScript.new(save_path)
		_expect(save_service.clear_for_test(), "weather album save should clear: %s" % save_path)
		var main = MainScene.instantiate()
		main.configure_for_test(save_path)
		main.set_day_key_for_test(str(revisit.get("day_key", "")))
		root.add_child(main)
		main.call("_ready")
		_check_weather_album_anchor_revisit(main, anchors, revisit)
		_expect(main.open_memory_album().get("ok", false), "weather album should open after clue record: %s" % revisit.get("event_id", ""))
		_expect(_visible_text_for_card(main, str(revisit.get("card_id", ""))).contains("已收藏"), "weather album should show collected card: %s" % revisit.get("card_id", ""))
		_expect(not _collect_visible_text(main).contains("正确率"), "weather album should not show accuracy wording")
		_expect(not _collect_visible_text(main).contains("等级"), "weather album should not show level wording")
		main.close_memory_album()
		_expect(main.save_service.clear_for_test(), "weather album save should clean up: %s" % save_path)
		root.remove_child(main)
		main.queue_free()


func _check_weather_album_anchor_revisit(main, anchors: Array, revisit: Dictionary) -> void:
	var anchor_id := str(revisit.get("anchor_id", ""))
	var card_id := str(revisit.get("card_id", ""))
	var event_id := str(revisit.get("event_id", ""))
	var anchor: Dictionary = _anchor_by_id(anchors, anchor_id)
	var position: Dictionary = anchor.get("position", {})
	var look_cell: Vector2i = revisit.get("look_cell", Vector2i(int(position.get("x", 0)), int(position.get("y", 0))))
	_expect(main.move_player_to_cell(look_cell).get("ok", false), "player should move to weather clue visible look point: %s" % anchor_id)
	var result: Dictionary = main.interact_nearby()
	_expect(result.get("ok", false), "weather clue should trigger through visible Interact: %s" % anchor_id)
	_expect(["anchor", "p1_return_entry"].has(str(result.get("interaction_type", ""))), "weather clue should keep a visible look context: %s" % anchor_id)
	_expect(str(result.get("card_id", "")) == card_id, "weather clue should bind expected card: %s" % anchor_id)
	var clue: Dictionary = result.get("weather_clue", {})
	_expect(not clue.is_empty(), "weather clue result should include weather_clue: %s" % anchor_id)
	_expect(str(clue.get("event_id", "")) == event_id, "weather clue should persist event id: %s" % event_id)
	_expect(str(clue.get("anchor_id", "")) == anchor_id, "weather clue should persist anchor id: %s" % anchor_id)
	_expect(str(clue.get("album_tag", "")) == str(revisit.get("tag", "")), "weather clue should persist album tag: %s" % event_id)
	_expect(str(clue.get("environment_word", "")) == str(revisit.get("environment_word", "")), "weather clue should persist environment word: %s" % event_id)
	_expect(str(result.get("text", "")).contains(str(revisit.get("core_word", ""))), "weather clue feedback should include core word: %s" % anchor_id)
	_expect(str(main.life_status_label.text).contains("天气相册"), "weather clue HUD should mention album record: %s" % anchor_id)
	var state: Dictionary = main.save_service.load_game_state()
	var record_id := "%s:%s" % [event_id, anchor_id]
	var saved: Dictionary = state.get("weather_album_clues", {}).get(record_id, {})
	_expect(bool(saved.get("seen", false)), "weather clue should persist seen record: %s" % record_id)
	_expect(str(saved.get("story_memory", "")).length() > 0, "weather clue should persist story memory: %s" % record_id)
	var card_state: Dictionary = main.memory_card_service.get_card_state(card_id)
	_expect(bool(card_state.get("seen", false)) and bool(card_state.get("collected", false)), "weather clue should update album card state: %s" % card_id)
	for forbidden in ["打卡", "顺序", "测验", "考试", "背诵", "评分", "等级", "正确率", "倒计时", "错过"]:
		_expect(not str(result.get("text", "")).contains(forbidden), "weather clue should not use pressure wording: %s" % forbidden)


func _visible_text_for_card(main, card_id: String) -> String:
	var card_node: Node = main.find_child(card_id, true, false)
	if card_node == null:
		return ""
	return _collect_visible_text(card_node)


func _collect_visible_text(node: Node) -> String:
	var parts: Array[String] = []
	if node is Label:
		parts.append((node as Label).text)
	elif node is Button:
		parts.append((node as Button).text)
	for child in node.get_children():
		parts.append(_collect_visible_text(child))
	return " ".join(parts)


func _anchor_by_id(anchors: Array, anchor_id: String) -> Dictionary:
	for anchor in anchors:
		if anchor is Dictionary and str(anchor.get("anchor_id", "")) == anchor_id:
			return anchor
	return {}


func _story_by_anchor(stories: Array, anchor_id: String) -> Dictionary:
	for story in stories:
		if story is Dictionary and str(story.get("core_anchor_id", "")) == anchor_id:
			return story
	return {}


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_expect(false, "cannot open JSON: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		_expect(false, "JSON should be object: %s" % path)
		return {}
	return parsed


func _finish() -> void:
	if failures.is_empty():
		print("V02.3 MEMORY PALACE WORLD TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
