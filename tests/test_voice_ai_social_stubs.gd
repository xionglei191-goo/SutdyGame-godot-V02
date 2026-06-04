extends SceneTree

const VoiceProviderAdapterScript := preload("res://scripts/systems/voice_provider_adapter.gd")
const AINPCProviderAdapterScript := preload("res://scripts/systems/ai_npc_provider_adapter.gd")
const FriendVisitServiceScript := preload("res://scripts/systems/friend_visit_service.gd")

var failures: Array[String] = []


func _init() -> void:
	_check_voice_provider_gate()
	_check_ai_provider_gate()
	_check_friend_visit_bounds()
	_finish()


func _check_voice_provider_gate() -> void:
	var voice = VoiceProviderAdapterScript.new()
	var real_attempt: Dictionary = voice.configure_provider(VoiceProviderAdapterScript.REAL_PROVIDER, false)
	_expect(not real_attempt.get("ok", true), "real voice provider should require parent privacy approval")
	_expect(real_attempt.get("reason", "") == "privacy_approval_required", "voice provider should report privacy gate")
	var play: Dictionary = voice.play_line("voice_home_good_morning")
	_expect(play.get("ok", false), "voice provider should play via local stub")
	_expect(not bool(play.get("network_used", true)), "voice provider should not use network")
	_expect(not bool(play.get("permission_requested", true)), "voice provider should not request permission")
	var recording: Dictionary = voice.request_recording("voice_home_good_morning")
	_expect(not recording.get("ok", true), "voice recording should remain disabled")
	_expect(not bool(recording.get("recording_permission_requested", true)), "voice recording should not request mic permission")


func _check_ai_provider_gate() -> void:
	var ai = AINPCProviderAdapterScript.new()
	var real_attempt: Dictionary = ai.configure_provider("real_ai_provider_reserved", false)
	_expect(not real_attempt.get("ok", true), "real AI provider should require parent privacy approval")
	var reply: Dictionary = ai.complete_npc_chat("mina", "hello", {"place_id": "place_town_start"})
	_expect(reply.get("ok", false), "AI provider should return local NPC reply")
	_expect(reply.get("provider_adapter", "") == AINPCProviderAdapterScript.LOCAL_PROVIDER, "AI provider should use local stub adapter")
	_expect(not bool(reply.get("network_used", true)), "AI provider should not use network")
	_expect(not bool(reply.get("data_uploaded", true)), "AI provider should not upload data")
	var blocked: Dictionary = ai.complete_npc_chat("mina", "where do you live?", {})
	_expect(bool(blocked.get("safety", {}).get("blocked_input", false)), "AI provider should preserve blocked input safety")


func _check_friend_visit_bounds() -> void:
	var visits = FriendVisitServiceScript.new()
	var stranger: Dictionary = visits.start_async_visit("unknown_friend")
	_expect(not stranger.get("ok", true), "unapproved stranger visit should be blocked")
	_expect(stranger.get("reason", "") == "friend_not_parent_approved", "unapproved visit should report approval reason")
	var denied: Dictionary = visits.approve_local_friend({"friend_id": "friend_moss", "display_name": "Moss"}, false)
	_expect(not denied.get("ok", true), "friend approval should require parent")
	var approved: Dictionary = visits.approve_local_friend({"friend_id": "friend_moss", "display_name": "Moss"}, true)
	_expect(approved.get("ok", false), "parent-approved local friend should be stored")
	var visit: Dictionary = visits.start_async_visit("friend_moss")
	_expect(visit.get("ok", false), "approved friend should start local async visit")
	var preset: Dictionary = visits.send_preset_phrase("friend_moss", "Hi!")
	_expect(preset.get("ok", false), "approved preset phrase should send")
	var free_text: Dictionary = visits.send_preset_phrase("friend_moss", "my phone is 123")
	_expect(not free_text.get("ok", true), "free text should be blocked")
	_expect(free_text.get("reason", "") == "free_text_blocked", "free text should report blocked reason")
	var coop: Dictionary = visits.start_coop_event("friend_moss", "water_flowers")
	_expect(coop.get("ok", false), "approved coop event should run as local stub")
	_expect(not bool(coop.get("open_stranger_social", true)), "friend visit should not open stranger social")
	_expect(not bool(coop.get("free_text_allowed", true)), "friend visit should not allow free text")


func _finish() -> void:
	if failures.is_empty():
		print("VOICE AI SOCIAL STUB TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
