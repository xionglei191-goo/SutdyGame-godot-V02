extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const TownMapAuthoringScene := preload("res://scenes/map_editor/town_map_authoring.tscn")

var failures: Array[String] = []


func _init() -> void:
	var real_world_before := _read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH)
	var scene: Control = TownMapAuthoringScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var road_added: Dictionary = scene.call("paint_cell_candidate", "road", Vector2i(2, 2), false)
	_expect(road_added.get("ok", false), "MAPEDITOR-004 should paint road cell")
	_expect(_has_road_cell(scene.call("export_world_map_dictionary"), Vector2i(2, 2)), "MAPEDITOR-004 road candidate should update state")
	var road_erased: Dictionary = scene.call("paint_cell_candidate", "road", Vector2i(2, 2), true)
	_expect(road_erased.get("ok", false), "MAPEDITOR-004 should erase road cell")
	_expect(not _has_road_cell(scene.call("export_world_map_dictionary"), Vector2i(2, 2)), "MAPEDITOR-004 road erase should update state")

	var collision_added: Dictionary = scene.call("paint_cell_candidate", "collision", Vector2i(2, 3), false)
	_expect(collision_added.get("ok", false), "MAPEDITOR-004 should paint collision cell")
	_expect(_has_collision_cell(scene.call("export_world_map_dictionary"), Vector2i(2, 3)), "MAPEDITOR-004 collision candidate should update state")
	var collision_erased: Dictionary = scene.call("paint_cell_candidate", "collision", Vector2i(2, 3), true)
	_expect(collision_erased.get("ok", false), "MAPEDITOR-004 should erase collision cell")
	_expect(not _has_collision_cell(scene.call("export_world_map_dictionary"), Vector2i(2, 3)), "MAPEDITOR-004 collision erase should update state")

	_expect(scene.call("select_marker", "place", "place_home").get("ok", false), "MAPEDITOR-004 should select a place before interaction paint")
	var interaction_added: Dictionary = scene.call("paint_cell_candidate", "interaction", Vector2i(2, 4), false)
	_expect(interaction_added.get("ok", false), "MAPEDITOR-004 should paint interaction cell for selected place")
	_expect(_has_interaction_cell(scene.call("export_world_map_dictionary"), Vector2i(2, 4)), "MAPEDITOR-004 interaction candidate should update state")
	var interaction_erased: Dictionary = scene.call("paint_cell_candidate", "interaction", Vector2i(2, 4), true)
	_expect(interaction_erased.get("ok", false), "MAPEDITOR-004 should erase interaction cell")
	_expect(not _has_interaction_cell(scene.call("export_world_map_dictionary"), Vector2i(2, 4)), "MAPEDITOR-004 interaction erase should update state")

	var protected_anchor: Dictionary = scene.call("paint_cell_candidate", "road", Vector2i(28, 16), false)
	_expect(not protected_anchor.get("ok", true), "MAPEDITOR-004 should reject painting over A-Z anchor")
	_expect(str(protected_anchor.get("reason", "")) == "protected_cell", "MAPEDITOR-004 protected paint should name reason")
	var protected_resource: Dictionary = scene.call("paint_cell_candidate", "collision", Vector2i(19, 18), false)
	_expect(not protected_resource.get("ok", true), "MAPEDITOR-004 should reject painting over resource")
	var protected_npc: Dictionary = scene.call("paint_cell_candidate", "interaction", Vector2i(38, 22), false)
	_expect(not protected_npc.get("ok", true), "MAPEDITOR-004 should reject painting over NPC routine")
	_expect(scene.call("validate_export_candidate").get("ok", false), "MAPEDITOR-004 painted/erased candidate should remain valid")
	_expect(_read_text(RuntimeMapBuilderScript.WORLD_MAP_PATH) == real_world_before, "MAPEDITOR-004 should not write runtime world_map.json")

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _has_road_cell(map_data: Dictionary, cell: Vector2i) -> bool:
	for road in map_data.get("roads", []):
		for candidate in road.get("cells", []):
			if _cell_key(candidate) == _cell_key_dict(cell):
				return true
	return false


func _has_collision_cell(map_data: Dictionary, cell: Vector2i) -> bool:
	for candidate in map_data.get("collision_cells", []):
		if _cell_key(candidate) == _cell_key_dict(cell):
			return true
	return false


func _has_interaction_cell(map_data: Dictionary, cell: Vector2i) -> bool:
	for interaction in map_data.get("interaction_cells", []):
		if _cell_key(interaction.get("cell", {})) == _cell_key_dict(cell):
			return true
	return false


func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]


func _cell_key_dict(cell: Vector2i) -> String:
	return "%s,%s" % [cell.x, cell.y]


func _read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


func _finish() -> void:
	if failures.is_empty():
		print("V02.27 MAPEDITOR-004 CELL PAINTING TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
