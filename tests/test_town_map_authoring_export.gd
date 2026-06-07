extends SceneTree

const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")

var failures: Array[String] = []


func _init() -> void:
	var original_text := _read_world_map_text()
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")
	var summary: Dictionary = scene.call("get_layer_summary")
	for key in ["has_ground_preview", "has_road_layer", "has_collision_layer", "has_interaction_layer", "has_place_marker_layer", "has_anchor_marker_layer", "has_resource_marker_layer", "has_npc_spawn_layer", "has_export_validation_panel"]:
		_expect(bool(summary.get(key, false)), "TownMapAuthoring should expose layer: %s" % key)
	_expect(scene.find_child("place_home", true, false) != null or _has_marker(scene, "place", "place_home"), "TownMapAuthoring should create Home place marker")
	_expect(_has_marker(scene, "anchor", "anchor_a_apple"), "TownMapAuthoring should create A anchor marker")
	var moved: Dictionary = scene.call("move_place_marker_candidate", "place_home", Vector2i(30, 17))
	_expect(moved.get("ok", false), "TownMapAuthoring should move place marker with linked cells")
	_expect(_cell_key(moved.get("interaction_cell", {})) == "32,19", "TownMapAuthoring guarded move should preserve Home interaction offset")
	_expect(int(moved.get("collision_update_count", 0)) >= 6, "TownMapAuthoring guarded move should update linked collision cells")
	var exported: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "TownMapAuthoring export should pass world map contract: %s" % [exported.get("errors", [])])
	_expect(exported.get("data", {}).get("memory_anchors", []).size() == 26, "TownMapAuthoring export should preserve all A-Z anchors")
	var home_place: Dictionary = _place_by_id(exported.get("data", {}), "place_home")
	_expect(_cell_key(home_place.get("position", {})) == "30,17", "TownMapAuthoring export should include moved Home position")
	_expect(_cell_key(home_place.get("interaction_cell", {})) == "32,19", "TownMapAuthoring export should include moved Home interaction")
	_expect(_read_world_map_text() == original_text, "TownMapAuthoring export should not mutate runtime world_map.json")
	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _has_marker(scene: Node, runtime_type: String, stable_id: String) -> bool:
	for child in scene.find_children("*", "PanelContainer", true, false):
		if str(child.get("runtime_type")) == runtime_type and str(child.get("stable_id")) == stable_id:
			return true
	return false


func _place_by_id(map_data: Dictionary, place_id: String) -> Dictionary:
	for place in map_data.get("places", []):
		if str(place.get("place_id", "")) == place_id:
			return place
	return {}


func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]


func _read_world_map_text() -> String:
	var file := FileAccess.open(RuntimeMapBuilderScript.WORLD_MAP_PATH, FileAccess.READ)
	_expect(file != null, "TownMapAuthoring should read runtime world_map.json")
	if file == null:
		return ""
	return file.get_as_text()


func _finish() -> void:
	if failures.is_empty():
		print("TOWN MAP AUTHORING EXPORT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
