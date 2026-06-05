extends SceneTree

const MainScene := preload("res://scenes/main.tscn")
const DailyRequestServiceScript := preload("res://scripts/systems/daily_request_service.gd")
const FORBIDDEN_CHILD_PARENT_UI_TERMS := ["Parent", "Dashboard", "Report", "家长", "报告", "后台"]

var failures: Array[String] = []


func _init() -> void:
	var main = MainScene.instantiate()
	main.configure_for_test("user://test_life_rpg_scene.json")
	main.set_day_key_for_test("2026-06-04")
	root.add_child(main)
	main.call("_ready")
	main.save_service.clear_for_test()
	main.call("_ready")

	_expect(main.find_child("TownHUD", true, false) != null, "main scene should expose top message HUD")
	_expect(main.find_child("TownFooter", true, false) != null, "main scene should expose bottom action bar")
	var footer := main.find_child("TownFooter", true, false) as Control
	_expect(footer != null and footer.anchor_left >= 0.2 and footer.anchor_right <= 0.8, "bottom action bar should be compact and centered")
	var visible_actions := main.find_child("FooterVisibleActions", true, false) as HBoxContainer
	_expect(visible_actions != null and visible_actions.get_child_count() == 4, "bottom bar should expose only Interact and three navigation buttons")
	var backpack_button := main.find_child("BackpackNavButton", true, false) as Button
	var backpack_bubble := main.find_child("BackpackBubble", true, false) as Control
	_expect(backpack_button != null and backpack_bubble != null and not backpack_bubble.visible, "Backpack button should start with a hidden content bubble")
	var home_button := main.find_child("HomeNavButton", true, false) as Button
	var town_stage := main.find_child("TownStage", true, false) as Control
	var home_room := main.find_child("HomeRoom", true, false) as Control
	_expect(home_button != null and home_room != null and town_stage != null, "main scene should expose HomeRoom and Home navigation")
	_expect(home_room != null and not home_room.visible, "HomeRoom should start hidden behind town playfield")
	_expect(main.find_child("Header", true, false) == null, "main scene should not keep a second top title banner")
	var title_label := main.find_child("Title", true, false) as Label
	_expect(title_label != null and str(title_label.text) == "阳光小镇", "single-line HUD should keep the town title")
	var coin_state := main.find_child("CoinState", true, false) as Label
	var pet_state := main.find_child("PetState", true, false) as Label
	_expect(coin_state != null and str(coin_state.text).contains("币"), "coin status should be separated into its own icon badge")
	_expect(pet_state != null and not str(pet_state.text).contains("金币"), "pet status should not merge coins with Sunny's needs")
	_expect(_texture_width(main.find_child("CoinIcon", true, false)) == 64, "coin HUD icon should use the resolved P0 art asset")
	_expect(backpack_button != null and backpack_button.icon != null and backpack_button.icon.get_width() == 64, "backpack button should use the resolved P0 art asset")
	_expect(main.find_child("LifeRPGPanel", true, false) == null, "main scene should not cover the map with a left life panel")
	_expect(main.find_child("OptionalActivityPanel", true, false) == null, "main scene should not cover the map with optional activity panel")
	_expect(main.find_child("RuntimeMap", true, false) != null, "main scene should expose runtime map")
	_expect(main.find_child("Player", true, false) != null, "main scene should expose player marker")
	_expect(main.find_child("npc_mina", true, false) != null, "main scene should expose Mina marker")
	_expect(_texture_width(main.find_child("Player", true, false).find_child("Body", true, false)) == 128, "player marker should use the resolved P0 art asset")
	_expect(_texture_width(main.find_child("npc_mina", true, false).find_child("Body", true, false)) == 128, "Mina marker should use the resolved P0 art asset")
	_expect(main.find_child("npc_shopkeeper", true, false) != null, "main scene should expose Shopkeeper marker")
	_expect(main.find_child("npc_pet_buddy", true, false) != null, "main scene should expose Pet Buddy marker")
	_expect(main.find_child("npc_bus_helper", true, false) != null, "main scene should expose Bus Helper marker")
	_expect(main.find_child("npc_story_bear", true, false) != null, "main scene should expose Story Bear marker")
	_expect(main.find_child("anchor_a_apple", true, false) != null, "A anchor should remain visible in explorable map")
	_expect(main.find_child("InteractButton", true, false) != null, "main scene should expose unified Interact button")
	var help_neighbor_button := main.find_child("HelpNeighborButton", true, false) as Button
	_expect(help_neighbor_button != null and not help_neighbor_button.is_visible_in_tree(), "life shortcut buttons should stay hidden from the child footer")
	_expect(main.find_child("PickBranchButton", true, false) == null, "main scene should not expose Pick Branch debug button")
	_expect(main.find_child("BuyChairButton", true, false) == null, "main scene should not expose Buy Chair debug button")
	_expect(main.find_child("PlaceChairButton", true, false) == null, "main scene should not expose Place Chair debug button")
	_expect(main.find_child("HelpNeighborButton", true, false) != null, "main scene should expose life-first coin action")
	_expect(str(main.optional_activity_label.text).contains("收藏活动"), "learning systems should be presented as optional collection activities")
	_expect(main.find_child("ParentButton", true, false) == null, "child main flow should not expose Parent navigation button")
	_expect(main.get_parent_entry_spec().get("child_flow_visible", true) == false, "parent entry spec should stay outside child flow")
	_expect(main.get_parent_entry_spec().get("available_in_child_nav", true) == false, "parent entry spec should not be in child nav")
	_expect(_visible_texts_containing(main, FORBIDDEN_CHILD_PARENT_UI_TERMS).is_empty(), "child main flow should not expose parent report/dashboard UI text")

	var start_cell: Vector2i = main.player_cell
	var moved: Dictionary = main.move_player_by_cells(Vector2i(1, 0))
	_expect(moved.get("ok", false), "player should move to walkable neighboring cell")
	_expect(main.player_cell == start_cell + Vector2i(1, 0), "player cell should update after movement")
	var saved_cell: Dictionary = main.save_service.load_game_state().get("player_cell", {})
	_expect(int(saved_cell.get("x", -1)) == main.player_cell.x and int(saved_cell.get("y", -1)) == main.player_cell.y, "player cell should persist")

	var blocked: Dictionary = main.move_player_to_cell(Vector2i(4, 4))
	_expect(not blocked.get("ok", true), "player should not move onto occupied/collision cell")
	_expect(blocked.get("reason", "") == "blocked", "blocked movement should explain reason")

	_expect(main.move_player_to_cell(Vector2i(0, 23)).get("ok", false), "player should move to empty edge cell")
	var no_target: Dictionary = main.interact_nearby()
	_expect(not no_target.get("ok", true), "empty edge cell should not interact")
	_expect(no_target.get("reason", "") == "no_target", "empty edge cell should report no target")

	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "player should move near Mina for daily request")
	var mina_greeting: Dictionary = main.interact_nearby()
	_expect(mina_greeting.get("ok", false), "Mina should greet on first daily interaction")
	_expect(mina_greeting.get("interaction_type", "") == "npc", "Mina daily greeting should still be an NPC interaction")
	_expect(bool(mina_greeting.get("first_today", false)), "Mina greeting should mark first_today")
	_expect(str(mina_greeting.get("text", "")).contains("散步"), "Mina first greeting should be gentle Chinese town text")
	var mina_start: Dictionary = main.interact_nearby()
	_expect(mina_start.get("ok", false), "Mina should start a daily light request")
	_expect(mina_start.get("interaction_type", "") == "npc", "Mina daily request should still be an NPC interaction")
	_expect(mina_start.get("request_id", "") == "daily_mina_branch_001", "Mina should offer the branch request")
	_expect(mina_start.get("request_status", "") == "active", "Mina branch request should become active")
	_expect(not bool(mina_start.get("network_used", true)), "Mina daily request should not use network")
	_expect(str(main.life_status_label.text).contains("米娜"), "life status should show localized Mina request")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) == 0, "starting Mina request should not award coins")

	var npc_checks := [
		{"npc_id": "shopkeeper", "display_name": "店长", "cell": Vector2i(24, 10), "text_contains": "小店"},
		{"npc_id": "pet_buddy", "display_name": "Sunny", "cell": Vector2i(6, 8), "text_contains": "Sunny"},
		{"npc_id": "bus_helper", "display_name": "巴士哥哥", "cell": Vector2i(32, 12), "text_contains": "站牌"},
		{"npc_id": "story_bear", "display_name": "故事熊", "cell": Vector2i(12, 7), "text_contains": "故事"},
	]
	for check in npc_checks:
		_check_npc_interaction(main, check)

	_expect(main.move_player_to_cell(Vector2i(15, 9)).get("ok", false), "player should move to Town Start interaction cell")
	var town_entry: Dictionary = main.interact_nearby()
	_expect(town_entry.get("ok", false), "Town Start entry should respond through unified Interact")
	_expect(town_entry.get("interaction_type", "") == "place_entry", "Town Start entry should be a neutral place entry")
	_expect(town_entry.get("place_id", "") == "place_town_start", "Town Start entry should report place id")
	_expect(town_entry.get("action", "") == "open_town_start", "Town Start entry should preserve map action")
	var town_state: Dictionary = main.save_service.load_game_state()
	_expect(int(town_state.get("coins", 0)) == 0, "Town Start entry should not award coins")
	_expect(not bool(town_state.get("flags", {}).get("helped_neighbor_today", false)), "Town Start entry should not mark neighbor help")

	var help_result: Dictionary = main.help_neighbor_for_coins()
	_expect(help_result.get("ok", false), "explicit Help Neighbor action should still award coins")
	_expect(int(main.save_service.load_game_state().get("coins", 0)) == 6, "explicit Help Neighbor should update coins")

	_expect(main.move_player_to_cell(Vector2i(13, 6)).get("ok", false), "player should move to branch resource area")
	var branch_result: Dictionary = main.interact_nearby()
	_expect(branch_result.get("ok", false), "unified Interact should collect branch near Bear anchor")
	_expect(branch_result.get("interaction_type", "") == "resource", "branch interaction should be reported as resource context")
	main._on_backpack_pressed()
	var backpack_items := main.find_child("BackpackItems", true, false) as Label
	_expect(backpack_bubble.visible and backpack_items != null and str(backpack_items.text).contains("树枝 1"), "Backpack bubble should show collected branch")
	main._on_backpack_pressed()

	_expect(main.move_player_to_cell(Vector2i(14, 10)).get("ok", false), "player should return to Mina with branch")
	var mina_complete: Dictionary = main.interact_nearby()
	_expect(mina_complete.get("ok", false), "Mina should complete the branch request")
	_expect(mina_complete.get("interaction_type", "") == "npc", "Mina completion should still be an NPC interaction")
	_expect(mina_complete.get("request_status", "") == "completed", "Mina branch request should complete")
	_expect(bool(mina_complete.get("completed_today", false)), "Mina request should be completed today")
	var after_mina_complete: Dictionary = main.save_service.load_game_state()
	_expect(int(after_mina_complete.get("inventory", {}).get("branch", -1)) == 0, "Mina request should consume branch")
	_expect(int(after_mina_complete.get("coins", -1)) == 12, "Mina request should add coins after Help Neighbor")
	var mina_relationship: Dictionary = main.save_service.load_learning_record().get("npc_relationships", {}).get("mina", {})
	_expect(int(mina_relationship.get("favor", 0)) == 1, "Mina request should add relationship favor")
	_expect(int(mina_relationship.get("daily_request_count", 0)) == 1, "Mina request should save daily request count")
	_expect(main.npc_memory_store.get_recent_events("mina").size() >= 2, "Mina daily request should persist NPC memory events")

	_expect(main.move_player_to_cell(Vector2i(18, 7)).get("ok", false), "player should move to flower resource area for P0 daily requests")
	var flower_result: Dictionary = main.interact_nearby()
	_expect(flower_result.get("ok", false), "visible Interact should collect flowers for Shopkeeper and Sunny requests")
	_expect(flower_result.get("interaction_type", "") == "resource", "flower collection should use the visible resource context")
	_expect(str(flower_result.get("item_id", "")) == "flower", "flower resource should report flower item")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("flower", 0)) == 2, "flower resource should add two flowers for the P0 daily requests")

	_expect(main.move_player_to_cell(Vector2i(24, 10)).get("ok", false), "player should return to Shopkeeper for P0 request")
	var shopkeeper_start: Dictionary = main.interact_nearby()
	_expect(shopkeeper_start.get("ok", false), "Shopkeeper should start a P0 daily request through visible Interact")
	_expect(shopkeeper_start.get("interaction_type", "") == "npc", "Shopkeeper request should still be an NPC interaction")
	_expect(shopkeeper_start.get("request_id", "") == "daily_shopkeeper_flower_001", "Shopkeeper should offer the flower counter request")
	_expect(shopkeeper_start.get("request_status", "") == "active", "Shopkeeper request should become active before completion")
	_expect(str(shopkeeper_start.get("text", "")).contains("小花"), "Shopkeeper start text should stay life-like and child-facing")
	var shopkeeper_complete: Dictionary = main.interact_nearby()
	_expect(shopkeeper_complete.get("ok", false), "Shopkeeper request should complete through visible Interact")
	_expect(shopkeeper_complete.get("request_status", "") == "completed", "Shopkeeper flower request should complete")
	_expect(bool(shopkeeper_complete.get("completed_today", false)), "Shopkeeper request should mark completed_today")
	var after_shopkeeper_complete: Dictionary = main.save_service.load_game_state()
	_expect(int(after_shopkeeper_complete.get("inventory", {}).get("flower", -1)) == 1, "Shopkeeper request should consume one flower")
	_expect(int(after_shopkeeper_complete.get("coins", -1)) == 17, "Shopkeeper request should add its coin reward after Mina")
	var shopkeeper_relationship: Dictionary = main.save_service.load_learning_record().get("npc_relationships", {}).get("shopkeeper", {})
	_expect(int(shopkeeper_relationship.get("favor", 0)) == 1, "Shopkeeper request should add relationship favor")
	_expect(int(shopkeeper_relationship.get("daily_request_count", 0)) == 1, "Shopkeeper request should save daily request count")
	var shopkeeper_repeat: Dictionary = main.interact_nearby()
	_expect(shopkeeper_repeat.get("request_status", "") == "completed", "Shopkeeper repeat interaction should stay completed today")
	_expect(int(main.save_service.load_game_state().get("coins", -1)) == 17, "Shopkeeper repeat interaction should not duplicate rewards")

	_expect(main.move_player_to_cell(Vector2i(6, 8)).get("ok", false), "player should return to Sunny for P0 request")
	var sunny_start: Dictionary = main.interact_nearby()
	_expect(sunny_start.get("ok", false), "Sunny should start a P0 daily request through visible Interact")
	_expect(sunny_start.get("interaction_type", "") == "npc", "Sunny request should still be an NPC interaction")
	_expect(sunny_start.get("request_id", "") == "daily_sunny_flower_001", "Sunny should offer the flower sniff request")
	_expect(sunny_start.get("request_status", "") == "active", "Sunny request should become active before completion")
	_expect(str(sunny_start.get("text", "")).contains("Sunny"), "Sunny start text should stay warm and child-facing")
	var sunny_complete: Dictionary = main.interact_nearby()
	_expect(sunny_complete.get("ok", false), "Sunny request should complete through visible Interact")
	_expect(sunny_complete.get("request_status", "") == "completed", "Sunny flower request should complete")
	_expect(bool(sunny_complete.get("completed_today", false)), "Sunny request should mark completed_today")
	var after_sunny_complete: Dictionary = main.save_service.load_game_state()
	_expect(int(after_sunny_complete.get("inventory", {}).get("flower", -1)) == 0, "Sunny request should consume the second flower")
	_expect(int(after_sunny_complete.get("inventory", {}).get("branch", -1)) == 1, "Sunny request should grant a branch reward")
	_expect(int(after_sunny_complete.get("coins", -1)) == 17, "Sunny request should not add pressure-making coins")
	var sunny_relationship: Dictionary = main.save_service.load_learning_record().get("npc_relationships", {}).get("pet_buddy", {})
	_expect(int(sunny_relationship.get("favor", 0)) == 1, "Sunny request should add relationship favor")
	_expect(int(sunny_relationship.get("daily_request_count", 0)) == 1, "Sunny request should save daily request count")
	var sunny_repeat: Dictionary = main.interact_nearby()
	_expect(sunny_repeat.get("request_status", "") == "completed", "Sunny repeat interaction should stay completed today")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("branch", -1)) == 1, "Sunny repeat interaction should not duplicate item rewards")
	var reloaded_daily = DailyRequestServiceScript.new(main.save_service, main.inventory_service, main.local_day_service)
	var reloaded_daily_state: Dictionary = reloaded_daily.get_daily_state()
	for request_id in ["daily_mina_branch_001", "daily_shopkeeper_flower_001", "daily_sunny_flower_001"]:
		_expect(bool(reloaded_daily_state.get(request_id, {}).get("completed_today", false)), "%s should reload as completed today" % request_id)

	var game_state: Dictionary = main.save_service.load_game_state()
	game_state["coins"] = 10
	game_state["inventory"] = {}
	_expect(main.save_service.save_game_state(game_state), "scene coin setup should save")

	_expect(main.move_player_to_cell(Vector2i(24, 9)).get("ok", false), "player should move to supermarket interaction cell")
	var shop_entry: Dictionary = main.interact_nearby()
	_expect(shop_entry.get("ok", false), "Supermarket entry should respond through unified Interact")
	_expect(shop_entry.get("interaction_type", "") == "place_entry", "Supermarket entry should be a neutral place entry")
	_expect(shop_entry.get("place_id", "") == "place_supermarket", "Supermarket entry should report place id")
	_expect(shop_entry.get("action", "") == "enter_supermarket", "Supermarket entry should preserve map action")
	var after_shop_entry: Dictionary = main.save_service.load_game_state()
	_expect(int(after_shop_entry.get("coins", -1)) == 10, "Supermarket entry should not spend coins")
	_expect(int(after_shop_entry.get("inventory", {}).get("wooden_chair", 0)) == 0, "Supermarket entry should not add furniture")

	var shop_result: Dictionary = main.buy_wooden_chair()
	_expect(shop_result.get("ok", false), "explicit shop action should buy wooden chair")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "explicit shop action should add furniture")

	_expect(main.move_player_to_cell(Vector2i(5, 7)).get("ok", false), "player should move to home interaction cell")
	var home_entry: Dictionary = main.interact_nearby()
	_expect(home_entry.get("ok", false), "Home entry should respond through unified Interact")
	_expect(home_entry.get("interaction_type", "") == "place_entry", "Home entry should be a neutral place entry")
	_expect(home_entry.get("place_id", "") == "place_home", "Home entry should report place id")
	_expect(home_entry.get("action", "") == "enter_home", "Home entry should preserve map action")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 0, "Home entry should not place furniture")
	_expect(int(main.save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0)) == 1, "Home entry should not consume furniture")

	var home_result: Dictionary = main.place_wooden_chair(Vector2i(2, 2))
	_expect(home_result.get("ok", false), "explicit home action should place wooden chair")
	_expect(main.home_decoration_service.get_home_state().get("placed_furniture", []).size() == 1, "main scene should persist placed furniture")
	main.show_home_view()
	_expect(home_room.visible and not town_stage.visible, "Home navigation should show the independent room view")
	_expect(main.find_child("HomeSunny", true, false) != null, "HomeRoom should show Sunny")
	_expect(main.find_child("HomeFurnitureLayer", true, false).get_child_count() >= 1, "HomeRoom should render placed furniture")
	var placed_instance_id := str(main.home_decoration_service.get_home_state().get("placed_furniture", [])[0].get("instance_id", ""))
	var rotate_result: Dictionary = main.rotate_home_item(placed_instance_id)
	_expect(rotate_result.get("ok", false), "main scene should rotate home furniture")
	var pickup_result: Dictionary = main.pickup_home_item(placed_instance_id)
	_expect(pickup_result.get("ok", false), "main scene should pick up home furniture")
	main.show_town_view()
	_expect(town_stage.visible and not home_room.visible, "Town navigation should return to the town playfield")

	main.save_service.clear_for_test()
	_finish()


func _finish() -> void:
	if failures.is_empty():
		print("LIFE RPG SCENE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _texture_width(node: Node) -> int:
	if node == null:
		return 0
	var texture: Texture2D = null
	if node is Sprite2D:
		texture = (node as Sprite2D).texture
	elif node is TextureRect:
		texture = (node as TextureRect).texture
	if texture == null:
		return 0
	return texture.get_width()


func _check_npc_interaction(main, check: Dictionary) -> void:
	var npc_id := str(check.get("npc_id", ""))
	var display_name := str(check.get("display_name", npc_id))
	var expected_text := str(check.get("text_contains", ""))
	_expect(main.move_player_to_cell(check.get("cell", Vector2i.ZERO)).get("ok", false), "player should move near %s" % display_name)
	var result: Dictionary = main.interact_nearby()
	_expect(result.get("ok", false), "player should interact with %s through unified Interact" % display_name)
	_expect(result.get("interaction_type", "") == "npc", "%s interaction should be reported as NPC context" % display_name)
	_expect(bool(result.get("is_stub", false)), "%s interaction should use local stub" % display_name)
	_expect(not bool(result.get("network_used", true)), "%s interaction should not use network" % display_name)
	_expect(str(result.get("text", "")).contains(expected_text), "%s should use daily Chinese greeting text" % display_name)

	var learning_record: Dictionary = main.save_service.load_learning_record()
	var relationships: Dictionary = learning_record.get("npc_relationships", {})
	_expect(int(relationships.get(npc_id, {}).get("greeting_count", 0)) >= 1, "%s greeting count should persist" % display_name)
	_expect(str(relationships.get(npc_id, {}).get("last_line", "")).contains(expected_text), "%s line should persist" % display_name)
	_expect(str(main.life_status_label.text).find(display_name) != -1, "life status should show %s interaction" % display_name)
	_expect(main.npc_memory_store.get_recent_events(npc_id).size() >= 1, "%s recent event should persist in NPC memory" % display_name)


func _visible_texts_containing(node: Node, forbidden_terms: Array) -> Array[String]:
	var matches: Array[String] = []
	if node is Control and not node.visible:
		return matches
	var text := ""
	if node is Label:
		text = (node as Label).text
	elif node is Button:
		text = (node as Button).text
	for term in forbidden_terms:
		if not text.is_empty() and text.find(str(term)) != -1:
			matches.append(text)
	for child in node.get_children():
		matches.append_array(_visible_texts_containing(child, forbidden_terms))
	return matches
