extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var save_path := "user://test_v0238_visual_recovery_runtime.json"
	var service = SaveServiceScript.new(save_path)
	_expect(service.clear_for_test(), "V02.38 visual recovery save should clear")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null and stage.has_method("get_visual_recovery_snapshot"), "V02.38 TownStage should expose visual recovery snapshot")
	if stage != null and stage.has_method("get_visual_recovery_snapshot"):
		var snapshot: Dictionary = stage.call("get_visual_recovery_snapshot")
		_expect(not bool(snapshot.get("uses_full_map_background", true)), "V02.38 should not use world_map_base_1280 as final runtime background")
		_expect(not bool(snapshot.get("has_legacy_ground_sprite", true)), "V02.38 should not create one legacy Ground sprite")
		_expect(int(snapshot.get("terrain_tile_count", 0)) >= 100, "V02.38 should render modular terrain tiles")
		_expect(int(snapshot.get("region_chunk_count", 0)) >= 4, "V02.38 should render first-screen region chunks")
		_expect(int(snapshot.get("building_prefab_count", 0)) >= 3, "V02.38 should render building prefabs")
		_expect(int(snapshot.get("world_prop_count", 0)) == 3, "V02.38 should render each first-screen recovery world prop once")
		_expect((snapshot.get("terrain_logical_ids", []) as Array).has("terrain.grass.soft_tile"), "V02.38 terrain should resolve logical grass tile")
		_expect((snapshot.get("region_logical_ids", []) as Array).has("region.school_line.chunk"), "V02.38 school line should resolve modular region chunk")
		_expect((snapshot.get("building_prefab_logical_ids", []) as Array).has("building.shop.market"), "V02.38 Shop should resolve building prefab")
		_expect(float(snapshot.get("non_prefab_place_max_alpha", 1.0)) <= 0.22, "V02.38 non-prefab place markers should be denoised")
		_expect(float(snapshot.get("anchor_badge_max_alpha", 1.0)) <= 0.5, "V02.38 A-Z letter badges should stay secondary")

	_expect(main.move_player_to_cell(Vector2i(31, 19)).get("ok", false), "V02.38 Home entry cell should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.38 Home real entry should still work through look interaction")
	var home_snapshot: Dictionary = main.get_expapproval_home_snapshot()
	_expect(bool(home_snapshot.get("home_visible", false)), "V02.38 Home entry should show Home view")
	main.show_town_view()

	_expect(main.move_player_to_cell(Vector2i(41, 11)).get("ok", false), "V02.38 Shop entry cell should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.38 Shop real entry should still work through look interaction")
	var shop_snapshot: Dictionary = main.get_expapproval_shop_settings_snapshot()
	_expect(bool(shop_snapshot.get("shop_visible", false)), "V02.38 Shop entry should show Shop panel")
	main.show_town_view()

	_expect(main.move_player_to_cell(Vector2i(21, 12)).get("ok", false), "V02.38 School Gate look cell should remain reachable")
	_expect(main.interact_nearby().get("ok", false), "V02.38 School line look interaction should still work")
	var school_snapshot: Dictionary = main.get_expapproval_school_snapshot()
	_expect(int(school_snapshot.get("school_child_text_banned_count", -1)) == 0, "V02.38 School line text should stay child-facing")

	_expect(service.clear_for_test(), "V02.38 visual recovery save should clean")
	root.remove_child(main)
	main.queue_free()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("V02.38 VISUAL RECOVERY RUNTIME TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
