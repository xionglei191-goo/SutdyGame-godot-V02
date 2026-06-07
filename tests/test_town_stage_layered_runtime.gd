extends SceneTree

const MainScene := preload("res://scenes/main.tscn")

var failures: Array[String] = []


func _init() -> void:
	var main = MainScene.instantiate()
	root.add_child(main)
	main.call("_ready")
	var stage := main.find_child("TownStage", true, false)
	_expect(stage != null, "TownStage should exist")
	for layer_name in ["GroundLayer", "RoadVisualLayer", "PlaceLayer", "PlazaLifeLayer", "HotspotLayer", "CollisionDebugLayer", "AnchorLayer", "ResourceLayer", "NPCActorLayer", "OutdoorDecorLayer", "PlayerLayer"]:
		_expect(stage.find_child(layer_name, true, false) != null, "TownStage should expose runtime layer: %s" % layer_name)
	_expect((stage.find_child("CollisionDebugLayer", true, false) as CanvasItem).visible == false, "CollisionDebugLayer should be hidden at runtime")
	_expect((stage.find_child("RoadVisualLayer", true, false) as Node).get_child_count() > 0, "RoadVisualLayer should contain road visuals")
	_expect((stage.find_child("PlaceLayer", true, false) as Node).find_child("place_home", true, false) != null, "PlaceLayer should contain Home")
	_expect((stage.find_child("PlazaLifeLayer", true, false) as Node).get_child_count() >= 5, "PlazaLifeLayer should contain lived-in plaza details")
	_expect((stage.find_child("AnchorLayer", true, false) as Node).find_child("anchor_a_apple", true, false) != null, "AnchorLayer should contain A anchor")
	_expect((stage.find_child("ResourceLayer", true, false) as Node).get_child_count() > 0, "ResourceLayer should contain resources")
	_expect((stage.find_child("NPCActorLayer", true, false) as Node).find_child("npc_mina", true, false) != null, "NPCActorLayer should contain Mina")
	_expect((stage.find_child("PlayerLayer", true, false) as Node).find_child("Player", true, false) != null, "PlayerLayer should contain Player")
	_expect(main.runtime_map_node != null and main.player_marker != null, "Main should keep runtime map and player marker facades")
	root.remove_child(main)
	main.queue_free()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("TOWN STAGE LAYERED RUNTIME TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
