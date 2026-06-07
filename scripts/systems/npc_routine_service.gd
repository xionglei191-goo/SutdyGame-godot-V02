extends RefCounted
class_name NPCRoutineService

const LocalDayServiceScript := preload("res://scripts/systems/local_day_service.gd")
const RuntimeMapBuilderScript := preload("res://scripts/systems/runtime_map_builder.gd")

const ROUTINES_PATH := "res://data/life/npc_routines.json"

var local_day_service
var routine_path: String = ROUTINES_PATH
var world_map: Dictionary = {}
var routines_by_day: Dictionary = {}
var load_errors: Array[String] = []


func _init(day_service = null, path: String = ROUTINES_PATH, map_data: Dictionary = {}) -> void:
	local_day_service = day_service if day_service != null else LocalDayServiceScript.new()
	routine_path = path
	world_map = map_data.duplicate(true) if not map_data.is_empty() else _load_world_map()
	_load_routines()


func is_loaded() -> bool:
	return load_errors.is_empty()


func get_npcs_for_day(base_npcs: Array) -> Array:
	var day_key: String = local_day_service.get_day_key()
	var day_routines: Dictionary = routines_by_day.get(day_key, {})
	var result: Array = []
	for value in base_npcs:
		if not value is Dictionary:
			continue
		var npc: Dictionary = (value as Dictionary).duplicate(true)
		var npc_id := str(npc.get("npc_id", ""))
		var routine: Dictionary = day_routines.get(npc_id, {})
		if routine.get("cell") is Dictionary:
			var routine_cell := _dict_to_cell(routine.get("cell", {}))
			var safety: Dictionary = validate_arrival_cell(routine_cell)
			if safety.get("ok", false):
				npc["cell"] = routine.get("cell", {}).duplicate(true)
				npc["routine_id"] = str(routine.get("routine_id", ""))
				npc["routine_label"] = str(routine.get("label", ""))
				npc["routine_fallback"] = false
				npc["routine_blocked"] = false
			else:
				npc["cell"] = _cell_to_dict(_dict_to_cell(npc.get("cell", {})))
				npc["routine_id"] = "safe_fallback_%s_%s" % [day_key, npc_id]
				npc["routine_label"] = "今天还是在熟悉的小镇角落等你。"
				npc["routine_fallback"] = true
				npc["routine_blocked"] = true
				npc["blocked_reason"] = str(safety.get("reason", "unsafe_arrival"))
				npc["blocked_kind"] = str(safety.get("protected_kind", ""))
		else:
			npc["routine_id"] = "fallback_%s_%s" % [day_key, npc_id]
			npc["routine_label"] = "在熟悉的小镇角落慢慢待着。"
			npc["routine_fallback"] = true
			npc["routine_blocked"] = false
		var arrival: Dictionary = get_arrival_feedback_for_npc(npc)
		npc["arrival_zone"] = str(arrival.get("arrival_zone", "town"))
		npc["arrival_text"] = str(arrival.get("text", "小镇今天也慢慢醒来了。"))
		result.append(npc)
	return result


func get_routine_snapshot(base_npcs: Array) -> Dictionary:
	var npcs := get_npcs_for_day(base_npcs)
	var fallback_count := 0
	var blocked_count := 0
	var plaza_arrival_count := 0
	for npc in npcs:
		if not npc is Dictionary:
			continue
		var npc_data: Dictionary = npc
		if bool(npc_data.get("routine_fallback", false)):
			fallback_count += 1
		if bool(npc_data.get("routine_blocked", false)):
			blocked_count += 1
		if str(npc_data.get("arrival_zone", "")) == "town_plaza":
			plaza_arrival_count += 1
	return {
		"ok": true,
		"day_key": local_day_service.get_day_key(),
		"npcs": npcs,
		"fallback_count": fallback_count,
		"blocked_count": blocked_count,
		"plaza_arrival_count": plaza_arrival_count,
	}


func validate_arrival_cell(cell: Vector2i) -> Dictionary:
	var canvas_size: Dictionary = world_map.get("canvas_size", {"w": 60, "h": 34})
	if cell.x < 0 or cell.y < 0 or cell.x >= int(canvas_size.get("w", 60)) or cell.y >= int(canvas_size.get("h", 34)):
		return {"ok": false, "reason": "outside_map", "cell": _cell_to_dict(cell)}
	for blocked_value in world_map.get("collision_cells", []):
		if _dict_to_cell(blocked_value) == cell:
			return {"ok": false, "reason": "blocked_cell", "protected_kind": "collision", "cell": _cell_to_dict(cell)}
	for interaction_value in world_map.get("interaction_cells", []):
		if interaction_value is Dictionary:
			var interaction: Dictionary = interaction_value
			if _dict_to_cell(interaction.get("cell", {})) == cell:
				return {"ok": false, "reason": "protected_interaction", "protected_kind": "interaction", "protected_id": str(interaction.get("interaction_id", "")), "cell": _cell_to_dict(cell)}
	for anchor_value in world_map.get("memory_anchors", []):
		if anchor_value is Dictionary:
			var anchor: Dictionary = anchor_value
			if _dict_to_cell(anchor.get("position", {})) == cell:
				return {"ok": false, "reason": "protected_anchor", "protected_kind": "anchor", "protected_id": str(anchor.get("anchor_id", "")), "cell": _cell_to_dict(cell)}
	for place_value in world_map.get("places", []):
		if place_value is Dictionary:
			var place: Dictionary = place_value
			for protected_cell in _place_protected_cells(place):
				if protected_cell == cell:
					return {"ok": false, "reason": "protected_place", "protected_kind": "place", "protected_id": str(place.get("place_id", "")), "cell": _cell_to_dict(cell)}
	return {"ok": true, "cell": _cell_to_dict(cell), "arrival_zone": _arrival_zone_for_cell(cell)}


func get_arrival_feedback_for_npc(npc: Dictionary) -> Dictionary:
	var npc_id := str(npc.get("npc_id", ""))
	var zone := _arrival_zone_for_cell(_dict_to_cell(npc.get("cell", {})))
	var text := "小镇今天也慢慢醒来了。"
	if zone == "town_plaza":
		match npc_id:
			"mina":
				text = "Mina 在广场旁等你，像要一起慢慢散步。"
			"pet_buddy":
				text = "Sunny 在小屋边摇摇尾巴，听见广场有轻轻的脚步声。"
			_:
				text = "广场旁多了熟悉的身影，可以慢慢过去打招呼。"
	elif zone == "shop_front":
		text = "商店门口有人整理小物件，路过时可以打个招呼。"
	elif zone == "school_line":
		text = "学校方向有人慢慢等着，不催不赶。"
	return {"ok": true, "npc_id": npc_id, "arrival_zone": zone, "text": text}


func _load_routines() -> void:
	load_errors.clear()
	routines_by_day.clear()
	var file := FileAccess.open(routine_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open NPC routine data: %s" % routine_path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("NPC routine data must be a JSON object: %s" % routine_path)
		return
	for day_value in (parsed as Dictionary).get("routine_days", []):
		if not day_value is Dictionary:
			continue
		var day: Dictionary = day_value
		var day_key := str(day.get("day_key", ""))
		if day_key.is_empty():
			continue
		var by_npc: Dictionary = {}
		for entry_value in day.get("npcs", []):
			if not entry_value is Dictionary:
				continue
			var entry: Dictionary = entry_value
			var npc_id := str(entry.get("npc_id", ""))
			if npc_id.is_empty():
				continue
			by_npc[npc_id] = entry.duplicate(true)
		routines_by_day[day_key] = by_npc


func _arrival_zone_for_cell(cell: Vector2i) -> String:
	if cell.x >= 29 and cell.x <= 39 and cell.y >= 17 and cell.y <= 23:
		return "town_plaza"
	if cell.x >= 40 and cell.x <= 47 and cell.y >= 9 and cell.y <= 16:
		return "shop_front"
	if cell.x >= 14 and cell.x <= 24 and cell.y >= 8 and cell.y <= 17:
		return "school_line"
	return "town"


func _place_protected_cells(place: Dictionary) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for value in place.get("occupied_cells", []):
		result.append(_dict_to_cell(value))
	if result.is_empty():
		var place_cell := _dict_to_cell(place.get("position", {}))
		var size: Dictionary = place.get("size", {"w": 1, "h": 1})
		for y in range(max(1, int(size.get("h", 1)))):
			for x in range(max(1, int(size.get("w", 1)))):
				result.append(place_cell + Vector2i(x, y))
	if place.get("interaction_cell") is Dictionary:
		result.append(_dict_to_cell(place.get("interaction_cell", {})))
	return result


func _dict_to_cell(value: Variant) -> Vector2i:
	if value is Vector2i:
		return value
	if value is Dictionary:
		var cell: Dictionary = value
		return Vector2i(int(cell.get("x", 0)), int(cell.get("y", 0)))
	return Vector2i.ZERO


func _cell_to_dict(cell: Vector2i) -> Dictionary:
	return {"x": cell.x, "y": cell.y}


func _load_world_map() -> Dictionary:
	var result: Dictionary = RuntimeMapBuilderScript.load_world_map()
	return result.get("data", {}).duplicate(true)
