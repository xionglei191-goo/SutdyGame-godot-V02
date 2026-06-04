extends RefCounted
class_name NPCMemoryStore

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")

const NPC_ROOT_PATH := "res://data/npcs"
const REQUIRED_NPC_IDS: Array[String] = [
	"mina",
	"shopkeeper",
	"pet_buddy",
	"bus_helper",
	"story_bear",
]
const MAX_RECENT_EVENTS := 12

var save_service
var profiles_by_id: Dictionary = {}
var base_memory_by_id: Dictionary = {}
var load_errors: Array[String] = []
var load_warnings: Array[String] = []


func _init(service = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	load_all()


func load_all() -> Dictionary:
	profiles_by_id.clear()
	base_memory_by_id.clear()
	load_errors.clear()
	load_warnings.clear()

	for npc_id in REQUIRED_NPC_IDS:
		_load_profile(npc_id)
		_load_memory(npc_id)

	return {
		"ok": load_errors.is_empty(),
		"errors": load_errors.duplicate(),
		"warnings": load_warnings.duplicate(),
		"profiles": profiles_by_id.duplicate(true),
		"memory": base_memory_by_id.duplicate(true),
	}


func get_required_npc_ids() -> Array[String]:
	return REQUIRED_NPC_IDS.duplicate()


func has_profile(npc_id: String) -> bool:
	return profiles_by_id.has(npc_id)


func get_profile(npc_id: String) -> Dictionary:
	return profiles_by_id.get(npc_id, {}).duplicate(true)


func get_all_profiles() -> Array[Dictionary]:
	var profiles: Array[Dictionary] = []
	for npc_id in REQUIRED_NPC_IDS:
		if profiles_by_id.has(npc_id):
			profiles.append(profiles_by_id[npc_id].duplicate(true))
	return profiles


func get_memory(npc_id: String) -> Dictionary:
	var memory: Dictionary = base_memory_by_id.get(npc_id, {}).duplicate(true)
	var learning_record: Dictionary = save_service.load_learning_record()
	var npc_memory: Dictionary = learning_record.get("npc_memory", {})
	if npc_memory.get(npc_id) is Dictionary:
		var saved_memory: Dictionary = npc_memory[npc_id]
		for key in saved_memory.keys():
			memory[key] = saved_memory[key]
	return memory


func record_event(npc_id: String, event: Dictionary) -> bool:
	if not has_profile(npc_id):
		push_warning("Cannot record NPC event for unknown npc_id: %s" % npc_id)
		return false

	var learning_record: Dictionary = save_service.load_learning_record()
	var npc_memory: Dictionary = learning_record.get("npc_memory", {})
	var memory: Dictionary = get_memory(npc_id)
	var events: Array = memory.get("recent_events", [])
	var normalized := _normalized_event(npc_id, event)
	events.append(normalized)
	while events.size() > MAX_RECENT_EVENTS:
		events.pop_front()
	memory["recent_events"] = events
	npc_memory[npc_id] = memory
	learning_record["npc_memory"] = npc_memory
	return save_service.save_learning_record(learning_record)


func get_recent_events(npc_id: String) -> Array:
	return get_memory(npc_id).get("recent_events", []).duplicate(true)


func clear_saved_memory_for_test() -> bool:
	var learning_record: Dictionary = save_service.load_learning_record()
	learning_record["npc_memory"] = {}
	return save_service.save_learning_record(learning_record)


func _load_profile(npc_id: String) -> void:
	var profile: Dictionary = _load_json("%s/%s/profile.json" % [NPC_ROOT_PATH, npc_id])
	if profile.is_empty():
		return
	var loaded_id := str(profile.get("npc_id", ""))
	if loaded_id != npc_id:
		load_errors.append("NPC profile id mismatch: %s" % npc_id)
		return
	var safety: Dictionary = profile.get("safety_boundary", {})
	if bool(safety.get("network_allowed", true)):
		load_errors.append("NPC profile must disable network: %s" % npc_id)
	if bool(safety.get("collect_personal_data", true)):
		load_errors.append("NPC profile must not collect personal data: %s" % npc_id)
	if str(profile.get("fallback_reply", "")).is_empty():
		load_errors.append("NPC profile missing fallback_reply: %s" % npc_id)
	profiles_by_id[npc_id] = profile


func _load_memory(npc_id: String) -> void:
	var memory: Dictionary = _load_json("%s/%s/memory.json" % [NPC_ROOT_PATH, npc_id])
	if memory.is_empty():
		return
	if str(memory.get("npc_id", "")) != npc_id:
		load_errors.append("NPC memory id mismatch: %s" % npc_id)
		return
	base_memory_by_id[npc_id] = memory


func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		load_errors.append("Missing NPC data file: %s" % path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open NPC data file: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("NPC data root must be a dictionary: %s" % path)
		return {}
	return parsed


func _normalized_event(npc_id: String, event: Dictionary) -> Dictionary:
	var normalized := {
		"npc_id": npc_id,
		"event_id": str(event.get("event_id", "npc_stub_event")),
		"title": str(event.get("title", "NPC moment")),
		"summary": str(event.get("summary", "")),
		"created_at": str(event.get("created_at", "")),
		"card_ids": [],
		"words": [],
	}
	for card_id in event.get("card_ids", []):
		normalized["card_ids"].append(str(card_id))
	for word in event.get("words", []):
		normalized["words"].append(str(word))
	return normalized
