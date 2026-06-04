extends SceneTree

const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")
const WorldOverviewScene := preload("res://scenes/map_editor/world_overview.tscn")

var failures: Array[String] = []


func _init() -> void:
	var map_result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	_expect(map_result.get("ok", false), "world map should load")
	var world_map: Dictionary = map_result.get("data", {})

	var scene: Control = WorldOverviewScene.instantiate()
	root.add_child(scene)
	scene.call("_ready")

	var summary: Dictionary = scene.call("get_grid_summary")
	var canvas: Dictionary = world_map.get("canvas_size", {})
	var cell_size: Dictionary = world_map.get("cell_size", {})
	_expect(summary.get("canvas_w") == int(canvas.get("w", -1)), "grid width should match canvas cells")
	_expect(summary.get("canvas_h") == int(canvas.get("h", -1)), "grid height should match canvas cells")
	_expect(summary.get("logical_cell_w") == int(cell_size.get("w", -1)), "grid logical cell width should match runtime contract")
	_expect(summary.get("logical_cell_h") == int(cell_size.get("h", -1)), "grid logical cell height should match runtime contract")
	_expect(summary.get("cell_count") == int(canvas.get("w", 0)) * int(canvas.get("h", 0)), "grid cell count should match canvas area")
	_expect(scene.find_child("EditorOnlyGridOverlay", true, false) != null, "grid overlay node should exist")
	_expect(scene.find_child("GridV_00", true, false) != null, "vertical grid line should exist")
	_expect(scene.find_child("GridH_00", true, false) != null, "horizontal grid line should exist")

	root.remove_child(scene)
	scene.queue_free()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("WORLD OVERVIEW GRID OVERLAY TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
