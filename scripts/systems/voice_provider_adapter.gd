extends RefCounted
class_name VoiceProviderAdapter

const VoiceServiceScript := preload("res://scripts/systems/voice_service.gd")

const LOCAL_PROVIDER := "local_voice_stub"
const REAL_PROVIDER := "real_voice_provider_reserved"

var voice_service
var provider_id := LOCAL_PROVIDER
var privacy_approved := false


func _init(service = null) -> void:
	voice_service = service if service != null else VoiceServiceScript.new()


func is_stub() -> bool:
	return provider_id == LOCAL_PROVIDER


func network_enabled() -> bool:
	return false


func recording_permission_requested() -> bool:
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


func play_line(audio_id: String) -> Dictionary:
	var result: Dictionary = voice_service.mock_play(audio_id)
	result["provider_adapter"] = LOCAL_PROVIDER
	result["fallback_used"] = true
	result["privacy_approved"] = privacy_approved
	result["recording_permission_requested"] = false
	result["network_used"] = false
	return result


func synthesize_line(audio_id: String) -> Dictionary:
	var result: Dictionary = voice_service.mock_tts(audio_id)
	result["provider_adapter"] = LOCAL_PROVIDER
	result["fallback_used"] = true
	result["privacy_approved"] = privacy_approved
	result["recording_permission_requested"] = false
	result["network_used"] = false
	return result


func request_recording(audio_id: String) -> Dictionary:
	return _result({
		"ok": false,
		"reason": "recording_disabled_until_parent_privacy_approval",
		"audio_id": audio_id,
		"provider": LOCAL_PROVIDER,
		"permission_requested": false,
		"recording_permission_requested": false,
	})


func _result(values: Dictionary) -> Dictionary:
	var result := values.duplicate(true)
	result["is_stub"] = true
	result["network_used"] = false
	result["data_uploaded"] = false
	result["permission_requested"] = false
	return result
