extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const WorldOverviewScene := preload("res://scenes/map_editor/world_overview.tscn")
const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "world map should load before editor proxy test")
	var world_map: Dictionary = map_result.get("data", {})

	var scene: Control = WorldOverviewScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	_expect(bool(scene.call("is_editor_only_proxy_scene")), "world overview should identify as editor-only proxy scene")
	_expect(scene.find_child("EditorOnlyProxyRoot", true, false) != null, "world overview should create EditorOnlyProxyRoot")

	var marker_ids: Array = scene.call("get_place_marker_ids")
	var expected_ids := _place_ids(world_map)
	_expect(marker_ids == expected_ids, "place marker ids should match world map places")
	for place in world_map.get("places", []):
		var place_id := str(place.get("place_id", ""))
		_expect(scene.find_child("proxy_%s" % place_id, true, false) != null, "place proxy marker should exist: %s" % place_id)
		_expect(scene.call("get_place_marker_cell", place_id) == _dict_to_cell(place.get("position", {})), "place proxy cell should match JSON: %s" % place_id)

	var moved: Dictionary = scene.call("move_place_marker_for_test", "place_home", Vector2i(8, 9))
	_expect(moved.get("ok", false), "place marker should move in editor proxy")
	_expect(scene.call("get_place_marker_cell", "place_home") == Vector2i(8, 9), "place marker cell should update after move")

	var reloaded: Dictionary = RuntimeMapBuilderScript.load_world_map().get("data", {})
	_expect(_place_position(reloaded, "place_home") == Vector2i(4, 4), "editor proxy move should not write JSON during V02-MAP-002")

	var main = MainScene.instantiate()
	root.add_child(main)
	main.call("_ready")
	_expect(main.find_child("EditorOnlyProxyRoot", true, false) == null, "runtime main scene should not contain editor-only proxy root")
	_expect(main.find_child("proxy_place_home", true, false) == null, "runtime main scene should not contain place proxy markers")
	_expect(not _runtime_builder_references_editor_proxy(), "RuntimeMapBuilder should not reference editor proxy scenes or nodes")

	root.remove_child(scene)
	scene.queue_free()
	main.queue_free()
	_finish()


func _place_ids(world_map: Dictionary) -> Array:
	var ids: Array[String] = []
	for place in world_map.get("places", []):
		ids.append(str(place.get("place_id", "")))
	ids.sort()
	return ids


func _place_position(world_map: Dictionary, place_id: String) -> Vector2i:
	for place in world_map.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			return _dict_to_cell(place.get("position", {}))
	return Vector2i(-1, -1)


func _dict_to_cell(cell: Dictionary) -> Vector2i:
	return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))


func _runtime_builder_references_editor_proxy() -> bool:
	var file := FileAccess.open("res://scripts/systems/runtime_map_builder.gd", FileAccess.READ)
	if file == null:
		return true
	var source := file.get_as_text()
	return source.contains("WorldOverview") or source.contains("EditorOnly") or source.contains("editor_proxy")


func _finish() -> void:
	if failures.is_empty():
		print("WORLD OVERVIEW EDITOR PROXY TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
