extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0222_actor_prefab_split.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.22 actor split save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_001")
	root.add_child(main)
	main.call("_ready")

	_check_prefab_scripts(main)
	_check_legacy_facade_still_works(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_prefab_scripts(main) -> void:
	_expect(_script_path(main.find_child("Player", true, false)).ends_with("player_actor.gd"), "V02.22 Player should be a PlayerActor prefab")
	var mina: Node = main.find_child("npc_mina", true, false)
	_expect(_script_path(mina).ends_with("npc_actor.gd"), "V02.22 Mina should be an NPCActor prefab")
	_expect(str(mina.get_meta("actor_type", "")) == "npc" and str(mina.get_meta("npc_id", "")) == "mina", "V02.22 NPC prefab should keep actor metadata")
	var branch: Node = main.find_child("resource_branch", true, false)
	_expect(_script_path(branch).ends_with("resource_object.gd"), "V02.22 branch should be a ResourceObject prefab")
	_expect(str(branch.get_meta("actor_type", "")) == "resource", "V02.22 resource prefab should keep actor metadata")
	var anchor: Node = main.find_child("anchor_a_apple", true, false)
	_expect(_script_path(anchor).ends_with("anchor_object.gd"), "V02.22 A anchor should be an AnchorObject prefab")
	_expect(str(anchor.get_meta("actor_type", "")) == "anchor" and str(anchor.get_meta("letter", "")) == "A", "V02.22 anchor prefab should keep actor metadata")
	var place: Node = main.find_child("place_home", true, false)
	_expect(_script_path(place).ends_with("interactable_object.gd"), "V02.22 Home place should be an InteractableObject prefab")
	_expect(str(place.get_meta("actor_type", "")) == "place", "V02.22 place prefab should keep actor metadata")
	var hotspot: Node = main.find_child("interaction_home_entry", true, false)
	_expect(_script_path(hotspot).ends_with("interactable_object.gd"), "V02.22 Home entry should be an InteractableObject hotspot prefab")
	_expect(str(hotspot.get_meta("actor_type", "")) == "hotspot", "V02.22 hotspot prefab should keep actor metadata")


func _check_legacy_facade_still_works(main) -> void:
	_expect(main.player_marker != null and _script_path(main.player_marker).ends_with("player_actor.gd"), "V02.22 main.player_marker should still point to the Player prefab")
	var walk: Dictionary = main.request_player_walk_to_cell(Vector2i(38, 22))
	_expect(walk.get("ok", false), "V02.22 actor split should keep walk requests working")
	_expect(main.finish_player_walk_for_test(420).get("ok", false), "V02.22 actor split should finish a legacy walk")
	var target: Dictionary = main.get_current_interaction_target()
	_expect(str(target.get("type", "")) == "npc" and str(target.get("target_id", "")) == "mina", "V02.22 actor split should keep interaction priority working")
	var result: Dictionary = main.interact_nearby()
	_expect(str(result.get("interaction_type", "")) == "npc" and str(result.get("npc_id", "")) == "mina", "V02.22 actor split should keep NPC interaction working")


func _script_path(node: Node) -> String:
	if node == null:
		return ""
	var script := node.get_script() as Script
	if script == null:
		return ""
	return script.resource_path


func _finish() -> void:
	if failures.is_empty():
		print("V02.22 ACTOR PREFAB SPLIT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
