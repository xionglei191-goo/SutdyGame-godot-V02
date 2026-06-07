extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const SECOND_BATCH_STEPS: Array[Dictionary] = [
	{"story_prop_id": "story_prop_marker_home_clock_chair_corner", "cell": Vector2i(30, 15), "anchor_id": "anchor_c_clock", "card_id": "card_c_clock_core", "text": "时钟小椅子"},
	{"story_prop_id": "story_prop_marker_home_sunny_towel_dog_corner", "cell": Vector2i(26, 20), "anchor_id": "anchor_d_dog", "card_id": "card_d_dog_core", "text": "Sunny 的小毛巾"},
	{"story_prop_id": "story_prop_marker_home_watch_wall_charm", "cell": Vector2i(33, 18), "anchor_id": "anchor_w_watch", "card_id": "card_w_watch_core", "text": "手表小挂饰"},
	{"story_prop_id": "story_prop_marker_school_gate_bell_sign", "cell": Vector2i(22, 11), "anchor_id": "anchor_g_gate", "card_id": "card_g_gate_core", "text": "校门小铃"},
	{"story_prop_id": "story_prop_marker_walk_kite_leaf_path", "cell": Vector2i(15, 9), "anchor_id": "anchor_k_kite", "card_id": "card_k_kite_core", "text": "风筝小叶子", "resource_item_id": "leaf"},
	{"story_prop_id": "story_prop_marker_shop_orange_bowl_window", "cell": Vector2i(52, 11), "anchor_id": "anchor_o_orange", "card_id": "card_o_orange_core", "text": "橙子小碗", "npc_id": "shopkeeper"},
	{"story_prop_id": "story_prop_marker_sun_flower_patch", "cell": Vector2i(8, 5), "anchor_id": "anchor_s_sun", "card_id": "card_s_sun_core", "text": "阳光小花", "resource_item_id": "flower"},
]
const FORBIDDEN_TEXT: Array[String] = ["课程", "测试", "测验", "考试", "背诵", "评分", "打卡", "倒计时", "作业", "分数", "迟到", "坐标", "格子", "debug", "editor"]

var failures: Array[String] = []


func _init() -> void:
	var save_path := "user://test_v0237_storybatch004_runtime_smoke.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.37 STORYBATCH-004 save should clear before runtime smoke")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	_check_second_batch_render(main)
	_check_second_batch_runtime_route(main)
	_check_child_safe_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_second_batch_render(main) -> void:
	var snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(snapshot.get("story_prop_count", 0)) == 11, "V02.37 STORYBATCH-004 runtime should render all eleven story props")
	var names: Array = snapshot.get("story_prop_names", [])
	for step in SECOND_BATCH_STEPS:
		_expect(names.has(str(step.get("story_prop_id", ""))), "V02.37 STORYBATCH-004 runtime should expose second-batch prop: %s" % step.get("story_prop_id", ""))


func _check_second_batch_runtime_route(main) -> void:
	_expect(main.inventory_service.collect_item("leaf", 1).get("ok", false), "V02.37 STORYBATCH-004 should seed leaf context")
	_expect(main.inventory_service.collect_item("flower", 1).get("ok", false), "V02.37 STORYBATCH-004 should seed flower context")
	for step in SECOND_BATCH_STEPS:
		_expect(main.move_player_to_cell(step.get("cell", Vector2i.ZERO)).get("ok", false), "V02.37 STORYBATCH-004 player should reach story prop: %s" % step.get("story_prop_id", ""))
		var target: Dictionary = main.get_current_interaction_target()
		_expect(str(target.get("type", "")) == "story_prop", "V02.37 STORYBATCH-004 prompt should target story prop: %s" % step.get("story_prop_id", ""))
		_expect(str(target.get("target_id", "")) == str(step.get("story_prop_id", "")), "V02.37 STORYBATCH-004 prompt should preserve prop id: %s" % step.get("story_prop_id", ""))
		var result: Dictionary = main.interact_nearby()
		_expect(result.get("ok", false), "V02.37 STORYBATCH-004 story prop interaction should succeed: %s" % step.get("story_prop_id", ""))
		_expect(str(result.get("interaction_type", "")) == "story_prop", "V02.37 STORYBATCH-004 result should identify story prop")
		_expect(str(result.get("story_prop_id", "")) == str(step.get("story_prop_id", "")), "V02.37 STORYBATCH-004 result should preserve prop id")
		_expect(str(result.get("text", "")).contains(str(step.get("text", ""))), "V02.37 STORYBATCH-004 feedback should mention child label: %s" % step.get("story_prop_id", ""))
		_expect((result.get("core_anchor_ids", []) as Array).has(str(step.get("anchor_id", ""))), "V02.37 STORYBATCH-004 result should include anchor: %s" % step.get("anchor_id", ""))
		if step.has("npc_id"):
			_expect(str(result.get("npc_id", "")) == str(step.get("npc_id", "")), "V02.37 STORYBATCH-004 result should preserve NPC context: %s" % step.get("story_prop_id", ""))
		if step.has("resource_item_id"):
			_expect(str(result.get("resource_item_id", "")) == str(step.get("resource_item_id", "")), "V02.37 STORYBATCH-004 result should preserve resource context: %s" % step.get("story_prop_id", ""))
			_expect(int(result.get("resource_count", 0)) >= 1, "V02.37 STORYBATCH-004 result should see seeded resource context: %s" % step.get("story_prop_id", ""))
		var state: Dictionary = main.memory_card_service.get_card_state(str(step.get("card_id", "")))
		_expect(bool(state.get("seen", false)), "V02.37 STORYBATCH-004 card should be seen: %s" % step.get("card_id", ""))
		_expect(bool(state.get("heard", false)), "V02.37 STORYBATCH-004 card should be heard: %s" % step.get("card_id", ""))
		_expect(bool(state.get("collected", false)), "V02.37 STORYBATCH-004 card should be collected: %s" % step.get("card_id", ""))
	var snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(snapshot.get("story_record_count", 0)) >= 7, "V02.37 STORYBATCH-004 should persist second-batch story prop records")
	for step in SECOND_BATCH_STEPS:
		_expect((snapshot.get("seen_anchor_ids", []) as Array).has(str(step.get("anchor_id", ""))), "V02.37 STORYBATCH-004 snapshot should include anchor: %s" % step.get("anchor_id", ""))


func _check_child_safe_text(main) -> void:
	var snapshot_text := str(main.get_story_slice_snapshot())
	var visible_text := _collect_visible_text(main)
	for forbidden in FORBIDDEN_TEXT:
		_expect(not snapshot_text.contains(forbidden), "V02.37 STORYBATCH-004 snapshot should stay child-safe: %s" % forbidden)
		_expect(not visible_text.contains(forbidden), "V02.37 STORYBATCH-004 visible text should stay child-safe: %s" % forbidden)


func _collect_visible_text(node: Node) -> String:
	var texts: Array[String] = []
	_collect_visible_texts(node, texts)
	return "\n".join(texts)


func _collect_visible_texts(node: Node, texts: Array[String]) -> void:
	if node is CanvasItem and not (node as CanvasItem).visible:
		return
	if node is Label:
		texts.append(str((node as Label).text))
	elif node is Button:
		texts.append(str((node as Button).text))
	for child in node.get_children():
		_collect_visible_texts(child, texts)


func _finish() -> void:
	if failures.is_empty():
		print("V02.37 STORYBATCH-004 RUNTIME SMOKE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
