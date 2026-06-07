extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const AssetResolverScript := preload("res://scripts/systems/asset_resolver.gd")

const STORY_PROP_STEPS: Array[Dictionary] = [
	{
		"story_prop_id": "story_prop_marker_home_apple_welcome_photo",
		"cell": Vector2i(8, 17),
		"anchors": ["anchor_a_apple"],
		"cards": ["card_a_apple_core"],
		"text": "苹果小照片",
	},
	{
		"story_prop_id": "story_prop_marker_plaza_bear_book_branch",
		"cell": Vector2i(13, 20),
		"anchors": ["anchor_b_bear"],
		"cards": ["card_b_bear_core"],
		"text": "长椅小书",
		"npc_id": "story_bear",
		"resource_item_id": "branch",
	},
	{
		"story_prop_id": "story_prop_marker_school_yard_net_robot_yoyo",
		"cell": Vector2i(19, 17),
		"anchors": ["anchor_n_net", "anchor_r_robot", "anchor_y_yo_yo"],
		"cards": ["card_n_net_core", "card_r_robot_core", "card_y_yo_yo_core"],
		"text": "操场小角落",
	},
	{
		"story_prop_id": "story_prop_marker_shop_hat_ribbon_window",
		"cell": Vector2i(50, 13),
		"anchors": ["anchor_h_hat"],
		"cards": ["card_h_hat_core"],
		"text": "帽子缎带窗",
	},
]
const FORBIDDEN_TEXT: Array[String] = ["课程", "测试", "测验", "考试", "背诵", "评分", "打卡", "倒计时", "必须", "格子", "坐标", "debug", "grid", "cell"]

var failures: Array[String] = []


func _init() -> void:
	_check_story_assets_resolve()
	var save_path := "user://test_v0236_storyslice001_runtime.json"
	var save_service = SaveServiceScript.new(save_path)
	_expect(save_service.clear_for_test(), "V02.36 story slice save should clear before scene startup")
	var main = MainScene.instantiate()
	main.configure_for_test(save_path)
	main.set_day_key_for_test("local_day_004")
	root.add_child(main)
	main.call("_ready")

	_check_story_props_render(main)
	_check_story_prop_runtime_route(main)
	_check_album_state(main)
	_check_child_safe_text(main)

	main.save_service.clear_for_test()
	root.remove_child(main)
	main.queue_free()
	_finish()


func _check_story_assets_resolve() -> void:
	var theme_id := AssetResolverScript.DEFAULT_THEME_ID
	for asset_id in [
		"story_prop.home.apple_welcome_photo",
		"story_prop.plaza.bear_book_branch_bookmark",
		"story_prop.school.yard_net_robot_yoyo_corner",
		"story_prop.shop.hat_ribbon_window",
	]:
		var resolved: Dictionary = AssetResolverScript.get_story_prop_asset(asset_id, theme_id)
		_expect(resolved.get("ok", false), "V02.36 story prop asset should resolve: %s" % asset_id)
		_expect(FileAccess.file_exists(str(resolved.get("placeholder_path", ""))), "V02.36 story prop asset file should exist: %s" % asset_id)


func _check_story_props_render(main) -> void:
	var snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(snapshot.get("story_prop_count", 0)) >= 4, "V02.36 runtime should keep rendering first-batch P0 story props")
	var names: Array = snapshot.get("story_prop_names", [])
	for step in STORY_PROP_STEPS:
		_expect(names.has(str(step.get("story_prop_id", ""))), "V02.36 runtime should expose story prop node: %s" % step.get("story_prop_id", ""))


func _check_story_prop_runtime_route(main) -> void:
	var branch_result: Dictionary = main.inventory_service.collect_item("branch", 1)
	_expect(branch_result.get("ok", false), "V02.36 story slice should prepare branch resource context")
	var seen_anchors: Dictionary = {}
	for step in STORY_PROP_STEPS:
		var cell: Vector2i = step.get("cell", Vector2i.ZERO)
		_expect(main.move_player_to_cell(cell).get("ok", false), "V02.36 player should reach story prop interaction cell: %s" % step.get("story_prop_id", ""))
		var target: Dictionary = main.get_current_interaction_target()
		_expect(str(target.get("type", "")) == "story_prop", "V02.36 prompt should target story prop: %s" % step.get("story_prop_id", ""))
		_expect(str(target.get("target_id", "")) == str(step.get("story_prop_id", "")), "V02.36 prompt should preserve story prop id: %s" % step.get("story_prop_id", ""))
		var result: Dictionary = main.interact_nearby()
		_expect(result.get("ok", false), "V02.36 story prop interaction should succeed: %s" % step.get("story_prop_id", ""))
		_expect(str(result.get("interaction_type", "")) == "story_prop", "V02.36 result should identify story prop interaction")
		_expect(str(result.get("story_prop_id", "")) == str(step.get("story_prop_id", "")), "V02.36 result should preserve story prop id")
		_expect(str(result.get("text", "")).contains(str(step.get("text", ""))), "V02.36 feedback should mention the story prop label: %s" % step.get("story_prop_id", ""))
		if step.has("npc_id"):
			_expect(str(result.get("npc_id", "")) == str(step.get("npc_id", "")), "V02.36 story prop should preserve linked NPC")
			_expect(str(result.get("resource_item_id", "")) == str(step.get("resource_item_id", "")), "V02.36 story prop should preserve linked resource")
			_expect(int(result.get("resource_count", 0)) >= 1, "V02.36 story prop should see prepared branch in inventory")
		for anchor_id in step.get("anchors", []):
			seen_anchors[str(anchor_id)] = true
		for card_id in step.get("cards", []):
			var state: Dictionary = main.memory_card_service.get_card_state(str(card_id))
			_expect(bool(state.get("seen", false)), "V02.36 story prop should mark card seen: %s" % card_id)
			_expect(bool(state.get("heard", false)), "V02.36 story prop should mark card heard: %s" % card_id)
			_expect(bool(state.get("collected", false)), "V02.36 story prop should mark card collected: %s" % card_id)
	var snapshot: Dictionary = main.get_story_slice_snapshot()
	_expect(int(snapshot.get("story_record_count", 0)) == 4, "V02.36 should persist all four story prop records")
	_expect((snapshot.get("seen_anchor_ids", []) as Array).size() >= 6, "V02.36 story slice should land at least six distinct A-Z anchors")
	for anchor_id in seen_anchors.keys():
		_expect((snapshot.get("seen_anchor_ids", []) as Array).has(anchor_id), "V02.36 snapshot should include seen anchor: %s" % anchor_id)


func _check_album_state(main) -> void:
	_expect(main.open_memory_album().get("ok", false), "V02.36 album should open after story slice records")
	for card_id in ["card_a_apple_core", "card_b_bear_core", "card_h_hat_core", "card_n_net_core", "card_r_robot_core", "card_y_yo_yo_core"]:
		var state: Dictionary = main.memory_card_service.get_card_state(card_id)
		_expect(bool(state.get("collected", false)), "V02.36 album state should keep collected card: %s" % card_id)
	main.close_memory_album()


func _check_child_safe_text(main) -> void:
	var visible_text := _collect_visible_text(main)
	var snapshot_text := str(main.get_story_slice_snapshot())
	for forbidden in FORBIDDEN_TEXT:
		_expect(not visible_text.contains(forbidden), "V02.36 visible story slice text should stay child-safe: %s" % forbidden)
		_expect(not snapshot_text.contains(forbidden), "V02.36 story slice state should stay child-safe: %s" % forbidden)


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
		print("V02.36 STORYSLICE-001 RUNTIME TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
