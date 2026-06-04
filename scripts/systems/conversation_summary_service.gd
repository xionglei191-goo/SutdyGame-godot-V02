extends RefCounted
class_name ConversationSummaryService

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")

const MAX_PARENT_SUMMARIES := 20

var save_service
var memory_store


func _init(service = null, store = null) -> void:
	save_service = service if service != null else SaveServiceScript.new()
	memory_store = store if store != null and store.has_method("has_profile") else NPCMemoryStoreScript.new(save_service)


func record_interaction(npc_id: String, event: Dictionary) -> Dictionary:
	if not memory_store.has_profile(npc_id):
		return {
			"ok": false,
			"reason": "unknown_npc",
			"npc_id": npc_id,
			"network_used": false,
			"permission_requested": false,
		}

	var profile: Dictionary = memory_store.get_profile(npc_id)
	var summary := _build_parent_summary(profile, event)
	if not memory_store.record_event(npc_id, {
		"event_id": summary.get("event_id", ""),
		"title": summary.get("title", ""),
		"summary": summary.get("summary_text", ""),
		"created_at": summary.get("created_at", ""),
		"card_ids": summary.get("card_ids", []),
		"words": summary.get("words", []),
	}):
		return {
			"ok": false,
			"reason": "memory_write_failed",
			"npc_id": npc_id,
			"network_used": false,
			"permission_requested": false,
		}

	if not _append_parent_summary(summary):
		return {
			"ok": false,
			"reason": "summary_write_failed",
			"npc_id": npc_id,
			"network_used": false,
			"permission_requested": false,
		}

	return {
		"ok": true,
		"summary": summary,
		"network_used": false,
		"permission_requested": false,
	}


func summarize_interaction(npc_id: String, event_id: String = "", notes: Array[String] = []) -> Dictionary:
	var normalized_npc_id := npc_id.trim_prefix("npc_")
	var result: Dictionary = record_interaction(normalized_npc_id, {
		"event_id": event_id,
		"title": "Local NPC moment",
		"summary": "A fixed local NPC interaction was recorded.",
		"words": notes,
	})
	if not result.get("ok", false):
		return result

	var summary: Dictionary = result.get("summary", {})
	var compat := summary.duplicate(true)
	compat["ok"] = true
	compat["summary_id"] = summary.get("summary_id", "")
	compat["npc_id"] = normalized_npc_id
	compat["title"] = summary.get("title", "")
	compat["notes"] = notes.duplicate(true)
	compat["source"] = "conversation_summary_stub"
	return compat


func get_parent_summaries() -> Array:
	var learning_record: Dictionary = save_service.load_learning_record()
	return learning_record.get("npc_parent_summaries", []).duplicate(true)


func get_parent_summaries_for_npc(npc_id: String) -> Array:
	var filtered: Array = []
	for summary in get_parent_summaries():
		if summary is Dictionary and summary.get("npc_id", "") == npc_id:
			filtered.append(summary.duplicate(true))
	return filtered


func clear_summaries_for_test() -> bool:
	var learning_record: Dictionary = save_service.load_learning_record()
	learning_record["npc_parent_summaries"] = []
	learning_record["npc_summary_refs"] = []
	return save_service.save_learning_record(learning_record)


func _build_parent_summary(profile: Dictionary, event: Dictionary) -> Dictionary:
	var npc_id := str(profile.get("npc_id", ""))
	var event_id := str(event.get("event_id", "npc_interaction"))
	var title := str(event.get("title", "NPC interaction"))
	var words: Array[String] = _string_array(event.get("words", []))
	var card_ids: Array[String] = _string_array(event.get("card_ids", []))
	var summary_text := str(event.get("summary", ""))
	if summary_text.is_empty():
		summary_text = "%s shared a short local stub interaction." % str(profile.get("display_name", npc_id))

	return {
		"summary_id": "%s_%s_%03d" % [npc_id, event_id, _next_index()],
		"npc_id": npc_id,
		"display_name": profile.get("display_name", npc_id),
		"event_id": event_id,
		"title": title,
		"summary_text": summary_text,
		"words": words,
		"card_ids": card_ids,
		"created_at": str(event.get("created_at", "")),
		"source": "local_stub",
		"parent_visible": true,
		"network_used": false,
		"permission_requested": false,
	}


func _append_parent_summary(summary: Dictionary) -> bool:
	var learning_record: Dictionary = save_service.load_learning_record()
	var summaries: Array = learning_record.get("npc_parent_summaries", [])
	summaries.append(summary.duplicate(true))
	while summaries.size() > MAX_PARENT_SUMMARIES:
		summaries.pop_front()
	learning_record["npc_parent_summaries"] = summaries

	var refs: Array = learning_record.get("npc_summary_refs", [])
	refs.append({
		"summary_id": summary.get("summary_id", ""),
		"npc_id": summary.get("npc_id", ""),
		"title": summary.get("title", ""),
		"event_id": summary.get("event_id", ""),
		"source": "conversation_summary_stub",
		"parent_visible": summary.get("parent_visible", false),
		"network_used": false,
	})
	while refs.size() > MAX_PARENT_SUMMARIES:
		refs.pop_front()
	learning_record["npc_summary_refs"] = refs
	return save_service.save_learning_record(learning_record)


func _next_index() -> int:
	var learning_record: Dictionary = save_service.load_learning_record()
	var summaries: Array = learning_record.get("npc_parent_summaries", [])
	return summaries.size() + 1


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if not value is Array:
		return result
	for item in value:
		result.append(str(item))
	return result
