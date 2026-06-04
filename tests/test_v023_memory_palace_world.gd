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

var failures: Array[String] = []


func _init() -> void:
	_check_anchor_interaction_service()
	_check_main_scene_anchor_interaction()
	_check_new_word_revisit_data()
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


func _anchor_by_id(anchors: Array, anchor_id: String) -> Dictionary:
	for anchor in anchors:
		if anchor is Dictionary and str(anchor.get("anchor_id", "")) == anchor_id:
			return anchor
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
