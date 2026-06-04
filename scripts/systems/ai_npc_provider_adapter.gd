extends RefCounted
class_name AINPCProviderAdapter

const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")

const LOCAL_PROVIDER := "local_ai_npc_stub"

var memory_store
var llm_client
var provider_id := LOCAL_PROVIDER
var privacy_approved := false


func _init(store = null, client = null) -> void:
	memory_store = store if store != null else NPCMemoryStoreScript.new()
	llm_client = client if client != null else LLMClientScript.new(memory_store)


func is_stub() -> bool:
	return true


func network_enabled() -> bool:
	return false


func configure_provider(requested_provider_id: String, approved_by_parent: bool = false) -> Dictionary:
	if requested_provider_id != LOCAL_PROVIDER and not approved_by_parent:
		provider_id = LOCAL_PROVIDER
		privacy_approved = false
		return _result({
			"ok": false,
			"reason": "privacy_approval_required",
			"provider": provider_id,
			"fallback_provider": LOCAL_PROVIDER,
		})
	provider_id = LOCAL_PROVIDER
	privacy_approved = approved_by_parent
	return _result({
		"ok": true,
		"provider": provider_id,
		"requested_provider": requested_provider_id,
		"real_provider_enabled": false,
	})


func complete_npc_chat(npc_id: String, child_text: String, context: Dictionary = {}) -> Dictionary:
	var result: Dictionary = llm_client.complete_chat(npc_id, child_text, context)
	result["provider_adapter"] = LOCAL_PROVIDER
	result["fallback_used"] = true
	result["privacy_approved"] = privacy_approved
	result["network_used"] = false
	result["data_uploaded"] = false
	return result


func _result(values: Dictionary) -> Dictionary:
	var result := values.duplicate(true)
	result["is_stub"] = true
	result["network_used"] = false
	result["data_uploaded"] = false
	return result
