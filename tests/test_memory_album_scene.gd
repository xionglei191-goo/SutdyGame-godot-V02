extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")
const MemoryAlbumScene := preload("res://scenes/memory_album/memory_album.tscn")
const FORBIDDEN_CHILD_PARENT_UI_TERMS := ["Parent", "Dashboard", "Report", "家长", "报告", "后台"]

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_memory_album_scene.json")
	_expect(save_service.clear_for_test(), "test save should clear before run")
	_expect(save_service.reset_for_test(), "test save should reset")

	var card_service = MemoryCardServiceScript.new(save_service)
	_expect(card_service.set_card_flags("card_a_apple_core", {
		"seen": true,
		"played": true,
		"collected": true,
		"spark": 2,
		"card_progress": 4,
	}), "card_a state should save")
	_expect(card_service.set_card_flags("card_pet_food", {
		"seen": true,
		"played": true,
		"card_progress": 2,
	}), "card_pet_food state should save")

	var scene: Control = MemoryAlbumScene.instantiate()
	root.add_child(scene)
	scene.call("set_save_service", save_service)
	scene.call("_ready")
	scene.call("refresh")

	_expect(scene.find_child("CardGrid", true, false) != null, "album should create card grid")
	_expect(scene.find_child("card_a_apple_core", true, false) != null, "album should show A core card")
	_expect(scene.find_child("card_w_watch_core", true, false) != null, "album should show first batch W core card")
	_expect(scene.find_child("card_pet_food", true, false) != null, "album should show extension card pet food")
	_expect(scene.call("get_album_cards").size() >= 15, "album should include 9 core cards plus extension cards")
	_expect(_has_text(scene, "collected"), "album should show collected state")
	_expect(_has_text(scene, "played"), "album should show played state")
	_expect(_has_text(scene, "Food keepsake") or _has_text(scene, "food keepsake"), "album should display extension keepsake styling")
	_expect(not bool(scene.call("has_blocked_child_terms")), "album should not expose blocked child-facing terms")

	var visible_text := str(scene.call("get_visible_text")).to_lower()
	for blocked in ["lesson", "test", "word list", "review", "failed"]:
		_expect(not visible_text.contains(blocked), "album visible text should not contain blocked term: %s" % blocked)
	for forbidden in FORBIDDEN_CHILD_PARENT_UI_TERMS:
		_expect(not str(scene.call("get_visible_text")).contains(str(forbidden)), "album visible text should not expose parent term: %s" % forbidden)

	root.remove_child(scene)
	scene.queue_free()
	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _has_text(node: Node, expected: String) -> bool:
	if node is Label and (node as Label).text.contains(expected):
		return true
	if node is Button and (node as Button).text.contains(expected):
		return true
	for child in node.get_children():
		if _has_text(child, expected):
			return true
	return false


func _finish() -> void:
	if failures.is_empty():
		print("MEMORY ALBUM SCENE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
