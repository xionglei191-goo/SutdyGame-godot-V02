extends RefCounted
class_name AnchorInteractionService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")

const REVISIT_PATHS_PATH := "res://data/anchors/new_word_revisit_paths.json"

var save_service
var memory_card_service
var revisit_path: String = REVISIT_PATHS_PATH
var stories_by_anchor: Dictionary = {}
var load_errors: Array[String] = []


func _init(service = null, card_service = null, path: String = REVISIT_PATHS_PATH) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	memory_card_service = card_service if card_service != null else MemoryCardServiceScript.new(save_service)
	revisit_path = path
	_load_stories()


func is_loaded() -> bool:
	return load_errors.is_empty()


func interact_with_anchor(anchor: Dictionary) -> Dictionary:
	var anchor_id := str(anchor.get("anchor_id", ""))
	var card_id := str(anchor.get("card_id", ""))
	if anchor_id.is_empty():
		return {"ok": false, "reason": "missing_anchor_id"}
	if card_id.is_empty():
		return {"ok": false, "reason": "missing_card_id", "anchor_id": anchor_id}
	memory_card_service.set_card_flags(card_id, {
		"seen": true,
		"heard": true,
		"collected": true,
		"card_progress": 4,
	})
	var story: Dictionary = _story_for_anchor(anchor_id)
	var text := _anchor_text(anchor, story)
	return {
		"ok": true,
		"interaction_type": "anchor",
		"anchor_id": anchor_id,
		"card_id": card_id,
		"letter": str(anchor.get("letter", "")),
		"core_word": str(anchor.get("core_word", "")),
		"text": text,
		"story": story,
		"album_state": memory_card_service.get_card_state(card_id),
	}


func get_story_for_anchor(anchor_id: String) -> Dictionary:
	return _story_for_anchor(anchor_id).duplicate(true)


func get_all_stories() -> Array:
	var stories: Array = []
	for story in stories_by_anchor.values():
		stories.append(story.duplicate(true))
	return stories


func _anchor_text(anchor: Dictionary, story: Dictionary) -> String:
	var core_word := str(anchor.get("core_word", "小物件"))
	if not story.is_empty():
		return "%s 在这里等你发现：%s" % [core_word, str(story.get("story_memory", ""))]
	return "%s 已经放进相册啦，之后路过还可以再看看。" % core_word


func _story_for_anchor(anchor_id: String) -> Dictionary:
	if stories_by_anchor.has(anchor_id):
		return stories_by_anchor[anchor_id].duplicate(true)
	return {}


func _load_stories() -> void:
	load_errors.clear()
	stories_by_anchor.clear()
	var file := FileAccess.open(revisit_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open new word revisit data: %s" % revisit_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("New word revisit data must be a JSON object: %s" % revisit_path)
		return
	for story_value in parsed.get("stories", []):
		if not story_value is Dictionary:
			load_errors.append("New word story entry must be an object")
			continue
		var story: Dictionary = story_value
		var anchor_id := str(story.get("core_anchor_id", ""))
		if anchor_id.is_empty():
			load_errors.append("New word story missing core_anchor_id")
			continue
		for field in ["letter", "world_place_id", "story_memory", "visual_hook", "review_path"]:
			if str(story.get(field, "")).is_empty():
				load_errors.append("New word story missing %s: %s" % [field, str(story.get("story_id", anchor_id))])
		stories_by_anchor[anchor_id] = story.duplicate(true)
