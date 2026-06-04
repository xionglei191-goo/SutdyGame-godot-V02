extends RefCounted
class_name LLMClient

const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")

const STUB_REPLY_ID := "local_safe_stub_reply"
const DEFAULT_STUB_REPLY := "Let's keep exploring Sunshine Town together."
const BLOCKED_INPUT_TERMS: Array[String] = [
	"address",
	"phone",
	"school name",
	"where do you live",
	"meet me",
	"password",
]

var memory_store


func _init(store = null) -> void:
	memory_store = store if store != null else NPCMemoryStoreScript.new()


func is_stub() -> bool:
	return true


func network_enabled() -> bool:
	return false


func complete_chat(npc_id: String, child_text: String, context: Dictionary = {}) -> Dictionary:
	var profile: Dictionary = memory_store.get_profile(npc_id)
	if profile.is_empty():
		return {
			"ok": false,
			"reason": "unknown_npc",
			"npc_id": npc_id,
			"is_stub": true,
			"network_used": false,
			"text": DEFAULT_STUB_REPLY,
		}

	var blocked := _contains_blocked_input(child_text)
	var text := str(profile.get("fallback_reply", DEFAULT_STUB_REPLY))
	if blocked:
		text = "Let's stay in Sunshine Town and use simple words together."

	return {
		"ok": true,
		"reply_id": STUB_REPLY_ID,
		"npc_id": npc_id,
		"display_name": profile.get("display_name", npc_id),
		"text": text,
		"is_stub": true,
		"network_used": false,
		"model": "none",
		"safety": {
			"blocked_input": blocked,
			"collect_personal_data": false,
			"child_safe_placeholder": true,
		},
		"context_echo": {
			"event_id": context.get("event_id", ""),
			"place_id": context.get("place_id", profile.get("home_place_id", "")),
		},
	}


func _contains_blocked_input(child_text: String) -> bool:
	var lower := child_text.to_lower()
	for term in BLOCKED_INPUT_TERMS:
		if lower.find(term) != -1:
			return true
	return false
