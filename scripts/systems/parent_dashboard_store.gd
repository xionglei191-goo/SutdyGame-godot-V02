extends RefCounted
class_name ParentDashboardStore

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

var save_service


func _init(service = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()


func build_dashboard_summary() -> Dictionary:
	var profile: Dictionary = save_service.load_profile()
	var game_state: Dictionary = save_service.load_game_state()
	var learning_record: Dictionary = save_service.load_learning_record()

	return {
		"source": "local_stub",
		"profile": _profile_summary(profile, learning_record),
		"learning_time": _learning_time_summary(game_state, learning_record),
		"cards": _card_summary(learning_record),
		"minigames": _minigame_summary(learning_record),
		"npc_summaries": _npc_summary_refs(learning_record),
		"local_settings": _local_settings_summary(profile, game_state, learning_record),
		"privacy": {
			"account_enabled": false,
			"network_enabled": false,
			"recording_enabled": false,
		},
	}


func _profile_summary(profile: Dictionary, learning_record: Dictionary) -> Dictionary:
	return {
		"profile_id": str(profile.get("profile_id", learning_record.get("profile_id", "local_profile"))),
		"display_name": str(profile.get("display_name", "")),
		"save_scope": "local_device",
	}


func _learning_time_summary(game_state: Dictionary, learning_record: Dictionary) -> Dictionary:
	var seconds: int = max(0, int(learning_record.get("learning_seconds", game_state.get("learning_seconds", 0))))
	var sessions: int = max(0, int(learning_record.get("session_count", game_state.get("session_count", 0))))
	return {
		"seconds": seconds,
		"minutes": int(ceil(float(seconds) / 60.0)) if seconds > 0 else 0,
		"sessions": sessions,
		"is_placeholder": seconds == 0 and sessions == 0,
	}


func _card_summary(learning_record: Dictionary) -> Dictionary:
	var card_states: Dictionary = learning_record.get("card_states", {})
	var contacted_ids: Array[String] = []
	var collected_ids: Array[String] = []
	var played_ids: Array[String] = []
	var shiny_ids: Array[String] = []

	for card_id in card_states.keys():
		var state: Dictionary = card_states.get(card_id, {})
		var id_text := str(card_id)
		if _card_was_contacted(state):
			contacted_ids.append(id_text)
		if bool(state.get("collected", false)):
			collected_ids.append(id_text)
		if bool(state.get("played", false)):
			played_ids.append(id_text)
		if bool(state.get("shiny", false)):
			shiny_ids.append(id_text)

	contacted_ids.sort()
	collected_ids.sort()
	played_ids.sort()
	shiny_ids.sort()

	return {
		"contacted_count": contacted_ids.size(),
		"collected_count": collected_ids.size(),
		"played_count": played_ids.size(),
		"shiny_count": shiny_ids.size(),
		"contacted_card_ids": contacted_ids,
		"collected_card_ids": collected_ids,
		"played_card_ids": played_ids,
		"shiny_card_ids": shiny_ids,
	}


func _minigame_summary(learning_record: Dictionary) -> Dictionary:
	var results: Array = learning_record.get("minigame_results", [])
	var total_duration_seconds := 0
	var total_coins := 0
	var best_score := 0
	var latest: Dictionary = {}
	var minigame_ids: Array[String] = []

	for item in results:
		if not item is Dictionary:
			continue
		var result: Dictionary = item
		latest = result.duplicate(true)
		total_duration_seconds += max(0, int(result.get("duration_seconds", 0)))
		total_coins += _coins_from_result(result)
		best_score = max(best_score, int(result.get("score", 0)))
		_add_unique(minigame_ids, str(result.get("minigame_id", "")))

	minigame_ids.sort()
	return {
		"result_count": results.size(),
		"total_duration_seconds": total_duration_seconds,
		"total_coins": total_coins,
		"best_score": best_score,
		"minigame_ids": minigame_ids,
		"latest_result": latest,
	}


func _npc_summary_refs(learning_record: Dictionary) -> Dictionary:
	var refs: Array = learning_record.get("npc_summary_refs", [])
	var normalized_refs: Array[Dictionary] = []

	for item in refs:
		if item is Dictionary:
			normalized_refs.append(item.duplicate(true))
		else:
			normalized_refs.append({"summary_ref": str(item)})

	var latest: Dictionary = normalized_refs[normalized_refs.size() - 1].duplicate(true) if not normalized_refs.is_empty() else {}
	return {
		"count": normalized_refs.size(),
		"refs": normalized_refs,
		"latest_ref": latest,
	}


func _local_settings_summary(profile: Dictionary, game_state: Dictionary, learning_record: Dictionary) -> Dictionary:
	var settings: Dictionary = {}
	_merge_dictionary(settings, profile.get("local_settings", {}))
	_merge_dictionary(settings, game_state.get("local_settings", {}))
	_merge_dictionary(settings, learning_record.get("local_settings", {}))
	return {
		"settings": settings,
		"has_settings": not settings.is_empty(),
	}


func _card_was_contacted(state: Dictionary) -> bool:
	for key in ["seen", "heard", "played", "collected", "shiny"]:
		if bool(state.get(key, false)):
			return true
	return int(state.get("spark", 0)) > 0 or int(state.get("card_progress", 0)) > 0


func _coins_from_result(result: Dictionary) -> int:
	if result.has("coins_earned"):
		return max(0, int(result.get("coins_earned", 0)))
	var reward: Dictionary = result.get("reward", {})
	return max(0, int(reward.get("coins", 0)))


func _merge_dictionary(target: Dictionary, value: Variant) -> void:
	if not value is Dictionary:
		return
	var source: Dictionary = value
	for key in source.keys():
		target[key] = source[key]


func _add_unique(values: Array[String], value: String) -> void:
	if not value.is_empty() and not values.has(value):
		values.append(value)
