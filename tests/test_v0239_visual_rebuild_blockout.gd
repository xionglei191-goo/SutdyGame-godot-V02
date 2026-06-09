extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var save_path := "user://test_v0239_visual_rebuild_blockout.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.39 blockout save should clear")

	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	root.add_child(main)
	main.call("_ready")

	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_visual_rebuild_blockout_snapshot"), "TownStage should expose V02.39 blockout snapshot")
	if stage != null and stage.has_method("get_visual_rebuild_blockout_snapshot"):
		var snapshot: Dictionary = stage.call("get_visual_rebuild_blockout_snapshot")
		_expect(bool(snapshot.get("layer_exists", false)), "V02.39 blockout layer should exist")
		_expect(int(snapshot.get("blockout_tile_path_count", 0)) >= 30, "V02.39 blockout should use reusable path tiles for a continuous first-screen road")
		_expect(int(snapshot.get("blockout_grass_base_count", 0)) >= 6, "V02.39 blockout should use continuous editable grass base pieces")
		_expect(int(snapshot.get("blockout_open_space_count", 0)) >= 2, "V02.39 blockout should reserve open walkable grass")
		_expect(int(snapshot.get("blockout_house_count", 0)) == 1, "V02.39 blockout should show one small home")
		_expect(int(snapshot.get("blockout_house_detail_count", 0)) >= 6, "V02.39 blockout home should be composed from editable detail pieces")
		_expect(int(snapshot.get("blockout_tree_count", 0)) == 4, "V02.39 blockout should keep sparse tree prefabs")
		_expect(int(snapshot.get("blockout_flower_count", 0)) == 4, "V02.39 blockout should keep sparse flower clusters")
		_expect(int(snapshot.get("blockout_fence_count", 0)) >= 3, "V02.39 blockout should include reusable fence segments")
		_expect(int(snapshot.get("blockout_garden_count", 0)) >= 3, "V02.39 blockout should include editable garden bed prefabs")
		_expect(int(snapshot.get("blockout_water_count", 0)) >= 3, "V02.39 blockout should include a composited water edge")
		_expect(int(snapshot.get("blockout_detail_count", 0)) >= 16, "V02.39 blockout should include reusable ground, bank, and crop detail prefabs")
		_expect(int(snapshot.get("blockout_companion_detail_count", 0)) >= 4, "V02.39 blockout companion should be composed from readable detail pieces")
		_expect(bool(snapshot.get("has_walkable_center", false)), "V02.39 blockout should name the center walkable space")
		_expect(bool(snapshot.get("legacy_visual_layers_hidden", false)), "V02.39 blockout should hide legacy scaffold visual layers")
		_expect(int(snapshot.get("assetized_texture_count", 0)) >= 74, "V02.39 blockout should use unified v0239 runtime textures")
		_expect(int(snapshot.get("resolver_mapped_v0239_count", 0)) >= 30, "V02.39 promoted visual rebuild assets should be bound through runtime resolver mappings")
		var camera_scale: Vector2 = snapshot.get("camera_scale", Vector2.ZERO)
		_expect(camera_scale.x <= 1.6 and camera_scale.y <= 1.6, "V02.39 blockout should use a full first-screen visual camera instead of the old close crop")
		_expect(bool(snapshot.get("player_layer_above_blockout", false)), "V02.39 blockout should keep the player visible above the visual candidate layer")
		var house_scale: Vector2 = snapshot.get("blockout_house_scale_cell", Vector2.ZERO)
		var avatar_scale: Vector2 = snapshot.get("blockout_avatar_scale_cell", Vector2.ZERO)
		_expect(house_scale.x <= 3.4 and house_scale.y <= 2.7, "V02.39 blockout home should stay modest")
		_expect(avatar_scale.x < house_scale.x and avatar_scale.y < house_scale.y, "V02.39 blockout avatar should stay smaller than home")
		_expect(int(snapshot.get("bottom_dock_button_target_count", 0)) == 5, "V02.39 blockout target should use five bottom dock buttons")

	var footer := main.find_child("TownFooter", true, false)
	_expect(footer != null, "TownFooter should exist")
	if footer != null:
		var row := footer.find_child("FooterVisibleActions", true, false) as HBoxContainer
		_expect(row != null, "TownFooter should expose visible action row")
		if row != null:
			_expect(row.get_child_count() == 5, "TownFooter should show five compact dock buttons")
			_expect(row.find_child("AlbumNavButton", false, false) != null, "TownFooter should expose album dock button")
			for button_name in ["InteractButton", "TownNavButton", "HomeNavButton", "BackpackNavButton", "AlbumNavButton"]:
				var button := row.find_child(button_name, false, false) as Button
				_expect(button != null and button.icon != null, "V02.39 dock button should expose an icon: %s" % button_name)

	_expect(main.move_player_to_cell(Vector2i(31, 19)).get("ok", false), "V02.39 blockout start path should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.39 blockout should preserve real look interaction near Home")

	_expect(save_service.clear_for_test(), "V02.39 blockout save should clean")
	root.remove_child(main)
	main.queue_free()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("V02.39 VISUAL REBUILD BLOCKOUT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
