extends RefCounted
class_name FriendVisitService

const PRESET_PHRASES: Array[String] = [
	"Hi!",
	"Nice town!",
	"Let's water flowers.",
	"Thank you!",
]
const PRESET_EMOTES: Array[String] = [
	"wave",
	"smile",
	"clap",
]
const COOP_EVENTS: Array[String] = [
	"water_flowers",
	"collect_branch_together",
	"decorate_corner",
]

var approved_friends: Dictionary = {}
var visit_log: Array[Dictionary] = []


func is_stub() -> bool:
	return true


func network_enabled() -> bool:
	return false


func approve_local_friend(friend_profile: Dictionary, approved_by_parent: bool) -> Dictionary:
	var friend_id := str(friend_profile.get("friend_id", ""))
	if friend_id.is_empty():
		return _result({"ok": false, "reason": "missing_friend_id"})
	if not approved_by_parent:
		return _result({"ok": false, "reason": "parent_approval_required", "friend_id": friend_id})
	approved_friends[friend_id] = {
		"friend_id": friend_id,
		"display_name": str(friend_profile.get("display_name", "Local Friend")),
		"approved_by_parent": true,
		"is_local_profile": true,
	}
	return _result({"ok": true, "friend_id": friend_id, "approved": true})


func can_visit(friend_id: String) -> bool:
	return approved_friends.has(friend_id)


func start_async_visit(friend_id: String) -> Dictionary:
	if not can_visit(friend_id):
		return _result({"ok": false, "reason": "friend_not_parent_approved", "friend_id": friend_id})
	var visit := {
		"visit_id": "local_visit:%s:%d" % [friend_id, visit_log.size() + 1],
		"friend_id": friend_id,
		"status": "active_stub",
		"allowed_actions": {
			"phrases": PRESET_PHRASES.duplicate(),
			"emotes": PRESET_EMOTES.duplicate(),
			"coop_events": COOP_EVENTS.duplicate(),
		},
	}
	visit_log.append(visit)
	return _result(visit.merged({"ok": true}, true))


func send_preset_phrase(friend_id: String, phrase: String) -> Dictionary:
	if not can_visit(friend_id):
		return _result({"ok": false, "reason": "friend_not_parent_approved", "friend_id": friend_id})
	if not PRESET_PHRASES.has(phrase):
		return _result({"ok": false, "reason": "free_text_blocked", "friend_id": friend_id, "phrase": phrase})
	return _result({"ok": true, "friend_id": friend_id, "message_type": "preset_phrase", "phrase": phrase})


func send_emote(friend_id: String, emote: String) -> Dictionary:
	if not can_visit(friend_id):
		return _result({"ok": false, "reason": "friend_not_parent_approved", "friend_id": friend_id})
	if not PRESET_EMOTES.has(emote):
		return _result({"ok": false, "reason": "unknown_emote", "friend_id": friend_id, "emote": emote})
	return _result({"ok": true, "friend_id": friend_id, "message_type": "emote", "emote": emote})


func start_coop_event(friend_id: String, event_id: String) -> Dictionary:
	if not can_visit(friend_id):
		return _result({"ok": false, "reason": "friend_not_parent_approved", "friend_id": friend_id})
	if not COOP_EVENTS.has(event_id):
		return _result({"ok": false, "reason": "unknown_coop_event", "friend_id": friend_id, "event_id": event_id})
	return _result({"ok": true, "friend_id": friend_id, "event_id": event_id, "status": "completed_stub"})


func _result(values: Dictionary) -> Dictionary:
	var result := values.duplicate(true)
	result["is_stub"] = true
	result["network_used"] = false
	result["data_uploaded"] = false
	result["open_stranger_social"] = false
	result["free_text_allowed"] = false
	return result
