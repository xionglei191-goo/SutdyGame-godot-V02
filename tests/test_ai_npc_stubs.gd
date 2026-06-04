extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const NPCMemoryStoreScript := preload("res://scripts/systems/npc_memory_store.gd")
const LLMClientScript := preload("res://scripts/systems/llm_client.gd")
const ConversationSummaryServiceScript := preload("res://scripts/systems/conversation_summary_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var save_service = SaveServiceScript.new("user://test_ai_npc_stubs.json")
	_expect(save_service.clear_for_test(), "test save should clear")
	_expect(save_service.reset_for_test(), "test save should reset")

	var memory_store = NPCMemoryStoreScript.new(save_service)
	var load_result: Dictionary = memory_store.load_all()
	_expect(load_result.get("ok", false), "NPC profiles and memory should load: %s" % [load_result.get("errors", [])])
	_check_profiles(memory_store)
	_check_stub_reply(memory_store)
	_check_memory_and_summary(save_service, memory_store)

	_expect(save_service.clear_for_test(), "test save should clean up")
	_finish()


func _check_profiles(memory_store) -> void:
	var required: Array[String] = ["mina", "shopkeeper", "pet_buddy", "bus_helper", "story_bear"]
	_expect(memory_store.get_all_profiles().size() == required.size(), "all required NPC profiles should load")
	for npc_id in required:
		_expect(memory_store.has_profile(npc_id), "profile should exist: %s" % npc_id)
		var profile: Dictionary = memory_store.get_profile(npc_id)
		var memory: Dictionary = memory_store.get_memory(npc_id)
		var safety: Dictionary = profile.get("safety_boundary", {})
		_expect(profile.get("npc_id", "") == npc_id, "profile npc_id should match: %s" % npc_id)
		_expect(not str(profile.get("fallback_reply", "")).is_empty(), "profile should include fallback reply: %s" % npc_id)
		_expect(not bool(safety.get("network_allowed", true)), "profile should disable network: %s" % npc_id)
		_expect(not bool(safety.get("collect_personal_data", true)), "profile should not collect personal data: %s" % npc_id)
		_expect(memory.get("npc_id", "") == npc_id, "memory npc_id should match: %s" % npc_id)
		_expect(bool(memory.get("parent_allowed_interaction", {}).get("parent_summary_visible", false)), "memory should allow parent summary: %s" % npc_id)


func _check_stub_reply(memory_store) -> void:
	var client = LLMClientScript.new(memory_store)
	_expect(client.is_stub(), "LLMClient should report stub mode")
	_expect(not client.network_enabled(), "LLMClient should not enable network")

	var reply: Dictionary = client.complete_chat("mina", "hello", {"event_id": "event_welcome_home", "place_id": "home"})
	_expect(reply.get("ok", false), "known NPC should return ok")
	_expect(bool(reply.get("is_stub", false)), "reply should be marked as stub")
	_expect(not bool(reply.get("network_used", true)), "reply should not use network")
	_expect(str(reply.get("model", "")) == "none", "reply should not name a real model")
	_expect(str(reply.get("text", "")).find("Good morning") != -1, "Mina reply should use fixed fallback")

	var blocked: Dictionary = client.complete_chat("shopkeeper", "my phone is 123", {})
	_expect(blocked.get("ok", false), "blocked input should still return a safe stub")
	_expect(bool(blocked.get("safety", {}).get("blocked_input", false)), "blocked input should be flagged")
	_expect(not bool(blocked.get("network_used", true)), "blocked input should not use network")

	var unknown: Dictionary = client.complete_chat("missing_npc", "hello", {})
	_expect(not unknown.get("ok", true), "unknown NPC should not return ok")
	_expect(not bool(unknown.get("network_used", true)), "unknown NPC should not use network")


func _check_memory_and_summary(save_service, memory_store) -> void:
	var summary_service = ConversationSummaryServiceScript.new(save_service, memory_store)
	_expect(summary_service.clear_summaries_for_test(), "summary test data should clear")
	_expect(memory_store.clear_saved_memory_for_test(), "memory test data should clear")

	var result: Dictionary = summary_service.record_interaction("pet_buddy", {
		"event_id": "event_feed_sunny",
		"title": "Feed Sunny",
		"summary": "Child fed Sunny after earning local coins in Letter Snake.",
		"words": ["feed", "food", "happy"],
		"card_ids": ["card_d_dog_core", "card_pet_food"],
		"created_at": "2026-06-04T00:00:00Z",
	})
	_expect(result.get("ok", false), "summary should record")

	var memory_events: Array = memory_store.get_recent_events("pet_buddy")
	_expect(memory_events.size() == 1, "memory store should keep recent NPC event")
	_expect(memory_events[0].get("event_id", "") == "event_feed_sunny", "memory event id should round-trip")

	var summaries: Array = summary_service.get_parent_summaries()
	_expect(summaries.size() == 1, "parent summaries should save")
	_expect(summaries[0].get("npc_id", "") == "pet_buddy", "parent summary npc id should round-trip")
	_expect(summaries[0].get("parent_visible", false), "parent summary should be parent visible")
	_expect(not bool(summaries[0].get("network_used", true)), "parent summary should record no network")

	var reloaded_store = NPCMemoryStoreScript.new(save_service)
	var reloaded_summary_service = ConversationSummaryServiceScript.new(save_service, reloaded_store)
	_expect(reloaded_store.get_recent_events("pet_buddy").size() == 1, "saved memory should reload")
	_expect(reloaded_summary_service.get_parent_summaries_for_npc("pet_buddy").size() == 1, "saved parent summary should reload")

	var learning_record: Dictionary = save_service.load_learning_record()
	_expect(learning_record.get("npc_summary_refs", []).size() == 1, "summary ref should be written to learning_record")
	_expect(learning_record.get("npc_parent_summaries", []).size() == 1, "parent summaries should be written to learning_record")


func _finish() -> void:
	if failures.is_empty():
		print("AI NPC STUB TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
