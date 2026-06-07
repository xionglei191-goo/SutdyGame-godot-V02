extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var original_text := _read_world_map_text()
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var before_summary: Dictionary = scene.call("get_authoring_place_summary")
	var before_count := int(before_summary.get("place_count", 0))
	var added: Dictionary = scene.call(
		"add_place_marker_candidate",
		"place_authoring_picnic_test",
		"Picnic Test",
		"district_sun_scene",
		"landmark",
		Vector2i(3, 1),
		Vector2i.ONE
	)
	_expect(added.get("ok", false), "MAPAUTH-003 should add a place marker candidate")
	_expect(int(added.get("place_count", 0)) == before_count + 1, "MAPAUTH-003 added candidate should increase place count")
	_expect(_has_marker(scene, "place", "place_authoring_picnic_test"), "MAPAUTH-003 added candidate should create a visible place marker")

	var duplicate: Dictionary = scene.call(
		"add_place_marker_candidate",
		"place_authoring_picnic_test",
		"Picnic Test",
		"district_sun_scene",
		"landmark",
		Vector2i(4, 1),
		Vector2i.ONE
	)
	_expect(not duplicate.get("ok", true), "MAPAUTH-003 should reject duplicate place ids")
	_expect(str(duplicate.get("reason", "")) == "duplicate_place_id", "MAPAUTH-003 duplicate rejection should name the reason")

	var exported: Dictionary = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "MAPAUTH-003 added candidate should pass map contract: %s" % [exported.get("errors", [])])
	_expect(int(exported.get("data", {}).get("memory_anchors", []).size()) == 26, "MAPAUTH-003 added candidate should preserve 26 A-Z anchors")
	_expect(_has_interaction_for_place(exported.get("data", {}), "place_authoring_picnic_test"), "MAPAUTH-003 added candidate should include an interaction cell")

	var validation: Dictionary = scene.call("validate_export_candidate")
	_expect(validation.get("ok", false), "MAPAUTH-003 valid add candidate should validate")
	_expect(not bool(validation.get("wrote_file", true)), "MAPAUTH-003 validation should not write JSON")
	_expect(_read_world_map_text() == original_text, "MAPAUTH-003 add validation should leave runtime world_map.json unchanged")

	var protected_delete: Dictionary = scene.call("delete_place_marker_candidate", "place_home")
	_expect(not protected_delete.get("ok", true), "MAPAUTH-003 should reject deleting a place that owns A-Z anchors")
	_expect(str(protected_delete.get("reason", "")) == "place_has_anchors", "MAPAUTH-003 protected delete should name anchor ownership")

	var unknown_delete: Dictionary = scene.call("delete_place_marker_candidate", "place_missing_authoring")
	_expect(not unknown_delete.get("ok", true), "MAPAUTH-003 should reject deleting an unknown place")
	_expect(str(unknown_delete.get("reason", "")) == "unknown_place_id", "MAPAUTH-003 unknown delete should name the reason")

	var deleted: Dictionary = scene.call("delete_place_marker_candidate", "place_authoring_picnic_test")
	_expect(deleted.get("ok", false), "MAPAUTH-003 should delete the added place marker candidate")
	_expect(int(deleted.get("place_count", -1)) == before_count, "MAPAUTH-003 delete should restore place count")
	_expect(not _has_marker(scene, "place", "place_authoring_picnic_test"), "MAPAUTH-003 delete should remove the marker node")

	exported = MapEditorSyncServiceScript.export_authoring_scene(scene)
	_expect(exported.get("ok", false), "MAPAUTH-003 deleted candidate should leave valid map contract: %s" % [exported.get("errors", [])])
	_expect(not _has_interaction_for_place(exported.get("data", {}), "place_authoring_picnic_test"), "MAPAUTH-003 delete should remove the added interaction cell")
	_expect(_read_world_map_text() == original_text, "MAPAUTH-003 delete loop should leave runtime world_map.json unchanged")

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _has_marker(scene: Node, runtime_type: String, stable_id: String) -> bool:
	for child in scene.find_children("*", "PanelContainer", true, false):
		if str(child.get("runtime_type")) == runtime_type and str(child.get("stable_id")) == stable_id:
			return true
	return false


func _has_interaction_for_place(map_data: Dictionary, place_id: String) -> bool:
	for interaction in map_data.get("interaction_cells", []):
		if str(interaction.get("place_id", "")) == place_id:
			return true
	return false


func _read_world_map_text() -> String:
	var file := FileAccess.open(RuntimeMapBuilderScript.WORLD_MAP_PATH, FileAccess.READ)
	_expect(file != null, "MAPAUTH-003 should read world_map.json")
	if file == null:
		return ""
	return file.get_as_text()


func _finish() -> void:
	if failures.is_empty():
		print("V02.25 MAPAUTH-003 PLACE MARKER LOOP TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
