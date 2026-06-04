extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const InventoryServiceScript := preload("res://scripts/systems/inventory_service.gd")
const LifeShopServiceScript := preload("res://scripts/systems/life_shop_service.gd")
const HomeDecorationServiceScript := preload("res://scripts/systems/home_decoration_service.gd")

const REQUIRED_HOME_ITEM_SLOTS := [
	{"slot": "small table", "item_ids": ["small_table"], "category": "table"},
	{"slot": "rug", "item_ids": ["floor_rug", "soft_rug"], "category": "floor_decor"},
	{"slot": "potted plant", "item_ids": ["potted_plant", "flower_pot"], "category": "plant"},
	{"slot": "pet bowl", "item_ids": ["pet_bowl"], "category": "pet_care"},
	{"slot": "pet bed", "item_ids": ["pet_bed", "sunny_bed"], "category": "pet_rest"},
	{"slot": "wall decoration", "item_ids": ["wall_decoration"], "category": "wall_decor", "surface_tag": "wall"},
]

const SHOP_PURCHASE_ITEM_IDS := ["small_table", "pet_bowl"]
const PRESSURE_WORDS := ["test", "quiz", "exam", "score", "drill", "lesson", "homework"]

var failures: Array[String] = []


func _init() -> void:
	_check_expanded_furniture_catalog()
	_check_shop_purchase_for_home_items()
	_check_home_placement_rotation_invalid_stow_and_reload()
	_check_sunny_home_feedback_contract()
	_finish()


func _check_expanded_furniture_catalog() -> void:
	var data: Dictionary = _read_json("res://data/items/life_items.json")
	var items_by_id := _items_by_id(data.get("items", []))

	for spec_value in REQUIRED_HOME_ITEM_SLOTS:
		var spec: Dictionary = spec_value
		var item_id := _first_existing_item_id(items_by_id, spec.get("item_ids", []))
		var slot_name := str(spec.get("slot", "home item"))
		_expect(not item_id.is_empty(), "V02.2 catalog should include a %s item with one of IDs %s" % [slot_name, spec.get("item_ids", [])])
		if item_id.is_empty():
			continue

		var item: Dictionary = items_by_id[item_id]
		_expect(str(item.get("item_id", "")) == item_id, "%s should keep a stable item_id" % item_id)
		_expect(str(item.get("display_name", "")).strip_edges() != "", "%s should have an English ambient display_name" % item_id)
		_expect(str(item.get("localized_display_name", "")).strip_edges() != "", "%s should have localized child-facing display text" % item_id)
		_expect(str(item.get("item_type", "")) == "furniture", "%s should be a placeable furniture item" % item_id)
		_expect(str(item.get("shop_id", "")).strip_edges() != "", "%s should be purchasable from a stable shop_id" % item_id)
		_expect(int(item.get("price", 0)) > 0, "%s should have a positive shop price" % item_id)
		_expect(_has_home_size(item), "%s should define home_size for grid placement" % item_id)
		_expect(str(item.get("furniture_category", "")) == str(spec.get("category", "")), "%s should declare furniture_category %s" % [item_id, spec.get("category", "")])
		if spec.has("surface_tag"):
			_expect(_item_has_tag(item, str(spec.get("surface_tag", ""))), "%s should declare wall placement through tags" % item_id)
		_expect(_has_memory_story_contract(item.get("memory_story", {})), "%s should keep memory-palace story bindings" % item_id)


func _check_shop_purchase_for_home_items() -> void:
	var save_service = SaveServiceScript.new("user://test_v022_shop_purchase.json")
	_expect(save_service.clear_for_test(), "V02.2 shop purchase save should clear")
	_expect(save_service.reset_for_test(), "V02.2 shop purchase save should reset")

	var game_state: Dictionary = save_service.load_game_state()
	game_state["coins"] = 120
	game_state["inventory"] = {}
	game_state["home_state"] = {"placed_furniture": [], "stowed_furniture": {}}
	_expect(save_service.save_game_state(game_state), "V02.2 shop purchase setup should save")

	var inventory = InventoryServiceScript.new(save_service)
	var shop = LifeShopServiceScript.new(save_service, inventory)
	for item_id_value in SHOP_PURCHASE_ITEM_IDS:
		var item_id := str(item_id_value)
		var before: Dictionary = save_service.load_game_state()
		var before_coins := int(before.get("coins", 0))
		var purchase: Dictionary = _call_dict(shop, "buy_life_item", [item_id])
		_expect(purchase.get("ok", false), "LifeShopService.buy_life_item should purchase %s" % item_id)
		_expect(str(purchase.get("item_id", "")) == item_id, "purchase result should report item_id %s" % item_id)
		_expect(int(purchase.get("price", 0)) > 0, "purchase result should report positive price for %s" % item_id)
		var saved: Dictionary = save_service.load_game_state()
		_expect(int(saved.get("coins", before_coins)) == before_coins - int(purchase.get("price", 0)), "purchase should deduct exactly the configured price for %s" % item_id)
		_expect(_saved_has_stowed_item(saved, item_id), "purchase should put %s in backpack or home inventory" % item_id)

	_expect(save_service.clear_for_test(), "V02.2 shop purchase save should clean up")


func _check_home_placement_rotation_invalid_stow_and_reload() -> void:
	var save_service = SaveServiceScript.new("user://test_v022_home_room_workflow.json")
	_expect(save_service.clear_for_test(), "V02.2 home workflow save should clear")
	_expect(save_service.reset_for_test(), "V02.2 home workflow save should reset")
	var inventory = InventoryServiceScript.new(save_service)
	var home = HomeDecorationServiceScript.new(save_service, inventory)

	_seed_home_inventory(save_service, {"wooden_chair": 1}, [])
	var invalid: Dictionary = _call_dict(home, "place_furniture", ["wooden_chair", Vector2i(-1, 0)])
	_expect(not invalid.get("ok", true), "place_furniture should reject cells outside the room grid")
	_expect(str(invalid.get("reason", "")) == "invalid_cell", "invalid placement should return reason invalid_cell")
	_expect(_has_soft_feedback(invalid), "invalid placement should return child-facing soft feedback")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("wooden_chair", -1)) == 1, "invalid placement should not consume furniture")

	_seed_home_inventory(save_service, {"wooden_chair": 2}, [])
	var placed: Dictionary = _call_dict(home, "place_furniture", ["wooden_chair", Vector2i(1, 1)])
	_expect(placed.get("ok", false), "place_furniture should place an owned item")
	var furniture: Dictionary = placed.get("furniture", {})
	var instance_id := str(furniture.get("instance_id", ""))
	_expect(not instance_id.is_empty(), "placed furniture should return a stable instance_id")
	_expect(str(furniture.get("item_id", "")) == "wooden_chair", "placed furniture should report item_id")
	_expect(_cell_matches(furniture.get("cell", {}), Vector2i(1, 1)), "placed furniture should save target cell")
	_expect(int(furniture.get("rotation", -1)) == 0, "new placement should save default rotation 0")
	_expect(_has_home_size(furniture), "placed furniture should include its footprint or home_size")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("wooden_chair", -1)) == 1, "successful placement should consume one inventory item")

	var overlap_before_count := int(save_service.load_game_state().get("inventory", {}).get("wooden_chair", 0))
	var overlap: Dictionary = _call_dict(home, "place_furniture", ["wooden_chair", Vector2i(1, 1)])
	_expect(not overlap.get("ok", true), "place_furniture should reject an occupied cell")
	_expect(["cell_occupied", "occupied"].has(str(overlap.get("reason", ""))), "occupied placement should return an occupied-cell reason")
	_expect(_has_soft_feedback(overlap), "occupied placement should return child-facing soft feedback")
	_expect(int(save_service.load_game_state().get("inventory", {}).get("wooden_chair", -1)) == overlap_before_count, "occupied placement should not consume furniture")

	_expect(home.has_method("rotate_furniture"), "HomeDecorationService should expose rotate_furniture(instance_id)")
	if home.has_method("rotate_furniture") and not instance_id.is_empty():
		var rotated: Dictionary = _call_dict(home, "rotate_furniture", [instance_id])
		_expect(rotated.get("ok", false), "rotate_furniture should rotate a placed item")
		var rotated_furniture: Dictionary = rotated.get("furniture", {})
		_expect(int(rotated_furniture.get("rotation", -1)) == 90, "rotation result should save rotation 90")

	var reloaded_home = HomeDecorationServiceScript.new(save_service, InventoryServiceScript.new(save_service))
	var reloaded_state: Dictionary = reloaded_home.get_home_state()
	var reloaded_furniture := _find_furniture(reloaded_state, instance_id)
	_expect(not reloaded_furniture.is_empty(), "placed furniture should survive HomeDecorationService reload")
	_expect(int(reloaded_furniture.get("rotation", -1)) == 90, "rotated furniture should reload with rotation 90")

	var stow_method := _first_method(reloaded_home, ["stow_furniture", "pickup_furniture"])
	_expect(not stow_method.is_empty(), "HomeDecorationService should expose stow_furniture(instance_id) or pickup_furniture(instance_id)")
	if not stow_method.is_empty() and not instance_id.is_empty():
		var stowed: Dictionary = _call_dict(reloaded_home, stow_method, [instance_id])
		_expect(stowed.get("ok", false), "%s should pick up a placed item" % stow_method)
		_expect(_find_furniture(reloaded_home.get_home_state(), instance_id).is_empty(), "stowed furniture should leave placed_furniture")
		_expect(_saved_has_stowed_item(save_service.load_game_state(), "wooden_chair"), "stowed furniture should return to backpack or home inventory")

	var reloaded_after_stow = HomeDecorationServiceScript.new(save_service, InventoryServiceScript.new(save_service))
	_expect(_find_furniture(reloaded_after_stow.get_home_state(), instance_id).is_empty(), "stowed state should survive reload")
	_expect(save_service.clear_for_test(), "V02.2 home workflow save should clean up")


func _check_sunny_home_feedback_contract() -> void:
	var save_service = SaveServiceScript.new("user://test_v022_sunny_home_feedback.json")
	_expect(save_service.clear_for_test(), "Sunny home feedback save should clear")
	_expect(save_service.reset_for_test(), "Sunny home feedback save should reset")
	var item_data: Dictionary = _read_json("res://data/items/life_items.json")
	var items_by_id := _items_by_id(item_data.get("items", []))
	var pet_bed_item_id := _first_existing_item_id(items_by_id, ["pet_bed", "sunny_bed"])
	if pet_bed_item_id.is_empty():
		pet_bed_item_id = "pet_bed"
	_seed_home_inventory(save_service, {}, [
		{
			"instance_id": "pet_bowl_001",
			"item_id": "pet_bowl",
			"cell": {"x": 2, "y": 2},
			"rotation": 0,
		},
		{
			"instance_id": "pet_bed_001",
			"item_id": pet_bed_item_id,
			"cell": {"x": 3, "y": 2},
			"rotation": 0,
		},
	])

	var home = HomeDecorationServiceScript.new(save_service, InventoryServiceScript.new(save_service))
	var feedback_method := _first_method(home, ["get_sunny_home_feedback", "get_sunny_feedback"])
	_expect(not feedback_method.is_empty(), "HomeDecorationService should expose get_sunny_home_feedback() or get_sunny_feedback()")
	if not feedback_method.is_empty():
		var feedback: Dictionary = _call_dict(home, feedback_method, [])
		_expect(feedback.get("ok", false), "get_sunny_home_feedback should succeed when pet items are placed")
		_expect(str(feedback.get("npc_id", "pet_buddy")) == "pet_buddy", "Sunny feedback should identify the pet buddy NPC when reported")
		_expect(str(feedback.get("pet_id", "sunny_dog")) == "sunny_dog", "Sunny feedback should identify Sunny when reported")
		_expect(_feedbacks_contain_item(feedback, "pet_bowl"), "Sunny feedback should react to pet_bowl")
		_expect(_feedbacks_contain_item(feedback, pet_bed_item_id), "Sunny feedback should react to the pet bed")
		_expect(_feedback_text_is_child_safe(feedback), "Sunny feedback should stay warm and non-scoring")

	_expect(save_service.clear_for_test(), "Sunny home feedback save should clean up")


func _seed_home_inventory(save_service, inventory_items: Dictionary, placed_furniture: Array) -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["inventory"] = inventory_items.duplicate(true)
	game_state["home_state"] = {
		"placed_furniture": placed_furniture.duplicate(true),
		"stowed_furniture": {},
		"room_grid": {"w": 6, "h": 4},
	}
	save_service.save_game_state(game_state)


func _read_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_expect(false, "Unable to open JSON file: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		_expect(false, "JSON file should be an object: %s" % path)
		return {}
	return parsed


func _items_by_id(items: Array) -> Dictionary:
	var result: Dictionary = {}
	for value in items:
		if value is Dictionary:
			var item: Dictionary = value
			var item_id := str(item.get("item_id", ""))
			if not item_id.is_empty():
				_expect(not result.has(item_id), "life item IDs should be unique: %s" % item_id)
				result[item_id] = item
	return result


func _first_existing_item_id(items_by_id: Dictionary, item_ids: Array) -> String:
	for item_id_value in item_ids:
		var item_id := str(item_id_value)
		if items_by_id.has(item_id):
			return item_id
	return ""


func _item_has_tag(item: Dictionary, tag: String) -> bool:
	for value in item.get("tags", []):
		if str(value) == tag:
			return true
	return false


func _first_method(service, method_names: Array) -> String:
	for method_name in method_names:
		if service.has_method(str(method_name)):
			return str(method_name)
	return ""


func _call_dict(service, method_name: String, args: Array) -> Dictionary:
	if not service.has_method(method_name):
		return {"ok": false, "reason": "missing_method", "method": method_name}
	var result: Variant = service.callv(method_name, args)
	if result is Dictionary:
		return result
	return {"ok": false, "reason": "non_dictionary_result", "method": method_name}


func _has_home_size(value: Dictionary) -> bool:
	var size_value: Variant = value.get("home_size", value.get("footprint", value.get("size", {})))
	if not size_value is Dictionary:
		return false
	var home_size: Dictionary = size_value
	return int(home_size.get("w", 0)) >= 1 and int(home_size.get("h", 0)) >= 1


func _has_memory_story_contract(value: Variant) -> bool:
	if not value is Dictionary:
		return false
	var story: Dictionary = value
	for key in ["letter", "core_anchor_id", "world_place_id", "story_memory", "visual_hook", "review_path"]:
		if str(story.get(str(key), "")).strip_edges() == "":
			return false
	return true


func _saved_has_stowed_item(game_state: Dictionary, item_id: String) -> bool:
	var inventory: Dictionary = game_state.get("inventory", {})
	if int(inventory.get(item_id, 0)) >= 1:
		return true
	var home_state: Dictionary = game_state.get("home_state", {})
	var stowed: Dictionary = home_state.get("stowed_furniture", {})
	if int(stowed.get(item_id, 0)) >= 1:
		return true
	var home_inventory: Dictionary = game_state.get("home_inventory", {})
	return int(home_inventory.get(item_id, 0)) >= 1


func _cell_matches(value: Variant, expected: Vector2i) -> bool:
	if value is Vector2i:
		return value == expected
	if value is Dictionary:
		var cell: Dictionary = value
		return int(cell.get("x", 9999)) == expected.x and int(cell.get("y", 9999)) == expected.y
	return false


func _find_furniture(home_state: Dictionary, instance_id: String) -> Dictionary:
	if instance_id.is_empty():
		return {}
	for value in home_state.get("placed_furniture", []):
		if value is Dictionary:
			var furniture: Dictionary = value
			if str(furniture.get("instance_id", "")) == instance_id:
				return furniture
	return {}


func _has_soft_feedback(result: Dictionary) -> bool:
	for key in ["feedback", "message", "child_feedback", "ui_feedback"]:
		var text := str(result.get(str(key), "")).strip_edges()
		if text != "" and _is_child_safe_line(text):
			return true
	return false


func _feedbacks_contain_item(feedback: Dictionary, item_id: String) -> bool:
	for key in ["item_id", "referenced_item_id", "trigger_item_id"]:
		if str(feedback.get(str(key), "")) == item_id:
			return true
	for value in feedback.get("feedbacks", []):
		if value is Dictionary:
			var entry: Dictionary = value
			for key in ["item_id", "referenced_item_id", "trigger_item_id"]:
				if str(entry.get(str(key), "")) == item_id:
					return true
	for value in feedback.get("item_ids", []):
		if str(value) == item_id:
			return true
	return false


func _feedback_text_is_child_safe(feedback: Dictionary) -> bool:
	var texts: Array[String] = []
	for key in ["text", "summary_text", "feedback", "message", "child_feedback"]:
		var text := str(feedback.get(str(key), "")).strip_edges()
		if text != "":
			texts.append(text)
	for value in feedback.get("feedbacks", []):
		if value is Dictionary:
			var entry: Dictionary = value
			for key in ["text", "feedback", "message", "child_feedback"]:
				var entry_text := str(entry.get(str(key), "")).strip_edges()
				if entry_text != "":
					texts.append(entry_text)
	if texts.is_empty():
		return false
	for text in texts:
		if not _is_child_safe_line(text):
			return false
	return true


func _is_child_safe_line(text: String) -> bool:
	var lower := text.to_lower()
	for word in PRESSURE_WORDS:
		if lower.find(str(word)) != -1:
			return false
	return true


func _finish() -> void:
	if failures.is_empty():
		print("V02.2 HOME ROOM CONTRACT TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
