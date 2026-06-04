extends SceneTree

const WorldOverviewScene := preload("res://scenes/map_editor/world_overview.tscn")
const MapEditorSyncServiceScript := preload("res://scripts/editor/map_editor_sync_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var scene: Control = WorldOverviewScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var road_id := "road_home_to_town"
	var added_cell := Vector2i(6, 8)
	var original_count: int = int(scene.call("get_road_cell_count", road_id))
	var added: Dictionary = scene.call("toggle_road_cell_for_test", road_id, added_cell)
	_expect(added.get("ok", false), "road cell should be addable")
	_expect(bool(scene.call("has_road_cell", road_id, added_cell)), "added road cell should be present")
	_expect(int(scene.call("get_road_cell_count", road_id)) == original_count + 1, "road cell count should increase")
	var removed: Dictionary = scene.call("toggle_road_cell_for_test", road_id, added_cell)
	_expect(removed.get("mode", "") == "removed", "second road toggle should remove")
	_expect(not bool(scene.call("has_road_cell", road_id, added_cell)), "removed road cell should be absent")

	var occupied_cell := Vector2i(2, 2)
	var occupied: Dictionary = scene.call("set_occupied_cell_for_test", occupied_cell, true)
	_expect(occupied.get("ok", false), "occupied cell should be settable")
	_expect(bool(scene.call("has_occupied_cell", occupied_cell)), "occupied cell should be readable")
	var blocked: Dictionary = scene.call("set_interaction_cell_for_test", "interaction_blocked_for_test", "place_home", occupied_cell)
	_expect(not blocked.get("ok", true), "interaction cell should not be allowed over occupied")
	_expect(blocked.get("reason", "") == "interaction_over_occupied", "blocked interaction should report overlap")

	var interaction_cell := Vector2i(8, 7)
	var interaction: Dictionary = scene.call("set_interaction_cell_for_test", "interaction_editor_for_test", "place_home", interaction_cell, "open_home_for_test")
	_expect(interaction.get("ok", false), "interaction cell should be settable on free cell")
	_expect(scene.call("get_interaction_cell", "interaction_editor_for_test") == interaction_cell, "interaction cell should be readable")

	var moved: Dictionary = scene.call("move_place_marker_for_test", "place_home", Vector2i(8, 9))
	_expect(moved.get("ok", false), "place marker move should be command-backed")
	_expect(scene.call("get_place_marker_cell", "place_home") == Vector2i(8, 9), "place marker should move")
	_expect(scene.call("undo_for_test").get("ok", false), "undo should restore place marker move")
	_expect(scene.call("get_place_marker_cell", "place_home") == Vector2i(4, 4), "undo should restore original place marker cell")
	_expect(scene.call("redo_for_test").get("ok", false), "redo should reapply place marker move")
	_expect(scene.call("get_place_marker_cell", "place_home") == Vector2i(8, 9), "redo should restore moved place marker cell")

	scene.call("undo_for_test")
	scene.call("undo_for_test")
	scene.call("undo_for_test")
	var exported: Dictionary = MapEditorSyncServiceScript.export_to_dictionary(scene.call("get_editor_state"))
	_expect(exported.get("ok", false), "editor state should export to contract-valid dictionary: %s" % [exported.get("errors", [])])
	var round_trip: Dictionary = MapEditorSyncServiceScript.round_trip_state(scene.call("get_editor_state"))
	_expect(round_trip.get("ok", false), "editor state should round-trip")
	_expect(int(round_trip.get("anchor_count", 0)) == 26, "round-trip should preserve all A-Z anchors")

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("WORLD OVERVIEW CELL EDITING TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
