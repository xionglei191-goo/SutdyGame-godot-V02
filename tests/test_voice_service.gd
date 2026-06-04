extends SceneTree

const VoiceServiceScript := preload("res://scripts/systems/voice_service.gd")

var failures: Array[String] = []


func _init() -> void:
	var service = VoiceServiceScript.new()
	_expect(service.is_loaded(), "voice lines should load: %s" % [service.load_errors])
	_expect(service.list_voice_lines().size() == 10, "first batch should contain 10 voice lines")

	var expected_texts := [
		"Good morning.",
		"How are you?",
		"Sunny is hungry.",
		"Let's feed Sunny.",
		"Here you are.",
		"Thank you.",
		"Let's go.",
		"I go by bus.",
		"Find apple.",
		"You found a memory card.",
	]
	for text in expected_texts:
		_expect(_has_text(service, text), "voice line text should exist: %s" % text)

	var greeting: Dictionary = service.get_voice_line("voice_home_good_morning")
	_expect(greeting.get("ok", false), "Good morning should resolve by audio_id")
	_expect(greeting.get("audio_id", "") == "voice_home_good_morning", "resolved line should preserve audio_id")
	_expect(greeting.get("speaker_id", "") == "npc_mina", "Good morning should keep speaker_id")
	_expect(greeting.has("tts_voice_id"), "voice line should expose tts_voice_id")
	_expect(greeting.has("recording_enabled"), "voice line should expose recording_enabled")
	_expect(greeting.has("repeat_after_me_enabled"), "voice line should expose repeat_after_me_enabled")
	_expect(greeting.has("speech_eval_enabled"), "voice line should expose speech_eval_enabled")

	var missing: Dictionary = service.get_voice_line("missing_audio")
	_expect(not missing.get("ok", true), "unknown audio_id should fail cleanly")

	var play: Dictionary = service.mock_play("voice_home_good_morning")
	_expect(play.get("ok", false), "mock play should succeed")
	_expect(play.get("played", false), "mock play should mark played")
	_expect(play.get("provider", "") == "mock_tts", "mock play should use mock TTS")
	_expect(play.get("audio_stream") == null, "mock play should not require a real audio stream")
	_expect(not bool(play.get("network_used", true)), "mock play should not use network")
	_expect(not bool(play.get("permission_requested", true)), "mock play should not request permissions")

	var recording: Dictionary = service.mock_recording("voice_home_good_morning", 1.5)
	_expect(recording.get("ok", false), "mock recording should succeed for recording-enabled line")
	_expect(recording.get("provider", "") == "mock_recording", "mock recording should use placeholder provider")
	_expect(recording.get("recording_id", "") == "mock_recording:voice_home_good_morning", "mock recording should return placeholder id")
	_expect(not bool(recording.get("network_used", true)), "mock recording should not use network")
	_expect(not bool(recording.get("permission_requested", true)), "mock recording should not request permissions")

	var disabled_recording: Dictionary = service.mock_recording("voice_minigame_find_apple")
	_expect(not disabled_recording.get("ok", true), "recording-disabled line should not start recording")
	_expect(disabled_recording.get("reason", "") == "recording_disabled", "disabled recording should explain reason")
	_expect(not bool(disabled_recording.get("permission_requested", true)), "disabled recording should not request permissions")

	_finish()


func _has_text(service, text: String) -> bool:
	for line in service.list_voice_lines():
		if line is Dictionary and line.get("text", "") == text:
			return true
	return false


func _finish() -> void:
	if failures.is_empty():
		print("VOICE SERVICE TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
