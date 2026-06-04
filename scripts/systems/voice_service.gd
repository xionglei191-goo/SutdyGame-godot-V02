extends RefCounted
class_name VoiceService

const VOICE_LINES_PATH := "res://data/voice/voice_lines.json"
const REQUIRED_FIELDS: Array[String] = [
	"audio_id",
	"text",
	"tts_voice_id",
	"speaker_id",
	"recording_enabled",
	"repeat_after_me_enabled",
	"speech_eval_enabled",
]

var data_path: String = VOICE_LINES_PATH
var load_errors: Array[String] = []
var voice_lines_by_id: Dictionary = {}


func _init(path: String = VOICE_LINES_PATH) -> void:
	data_path = path
	_reload()


func is_loaded() -> bool:
	return load_errors.is_empty()


func list_voice_lines() -> Array:
	return voice_lines_by_id.values()


func get_voice_line(audio_id: String) -> Dictionary:
	if not voice_lines_by_id.has(audio_id):
		return {"ok": false, "reason": "unknown_audio_id", "audio_id": audio_id}
	var line: Dictionary = voice_lines_by_id[audio_id]
	var result := line.duplicate(true)
	result["ok"] = true
	return result


func mock_tts(audio_id: String) -> Dictionary:
	var line: Dictionary = get_voice_line(audio_id)
	if not line.get("ok", false):
		return line
	return {
		"ok": true,
		"audio_id": audio_id,
		"text": line.get("text", ""),
		"speaker_id": line.get("speaker_id", ""),
		"tts_voice_id": line.get("tts_voice_id", ""),
		"provider": "mock_tts",
		"audio_stream": null,
		"network_used": false,
		"permission_requested": false,
	}


func mock_play(audio_id: String) -> Dictionary:
	var tts_result: Dictionary = mock_tts(audio_id)
	if not tts_result.get("ok", false):
		return tts_result
	return {
		"ok": true,
		"audio_id": audio_id,
		"text": tts_result.get("text", ""),
		"speaker_id": tts_result.get("speaker_id", ""),
		"tts_voice_id": tts_result.get("tts_voice_id", ""),
		"provider": tts_result.get("provider", "mock_tts"),
		"played": true,
		"audio_stream": null,
		"network_used": false,
		"permission_requested": false,
	}


func mock_recording(audio_id: String, duration_seconds: float = 0.0) -> Dictionary:
	var line: Dictionary = get_voice_line(audio_id)
	if not line.get("ok", false):
		return line
	if not bool(line.get("recording_enabled", false)):
		return {
			"ok": false,
			"reason": "recording_disabled",
			"audio_id": audio_id,
			"permission_requested": false,
			"network_used": false,
		}
	return {
		"ok": true,
		"audio_id": audio_id,
		"text": line.get("text", ""),
		"recording_id": "mock_recording:%s" % audio_id,
		"duration_seconds": maxf(duration_seconds, 0.0),
		"recording_path": "",
		"transcript": "",
		"speech_eval": {},
		"provider": "mock_recording",
		"permission_requested": false,
		"network_used": false,
	}


func _reload() -> void:
	load_errors.clear()
	voice_lines_by_id.clear()

	var file := FileAccess.open(data_path, FileAccess.READ)
	if file == null:
		load_errors.append("Unable to open voice lines: %s" % data_path)
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		load_errors.append("Voice lines file must be a JSON object: %s" % data_path)
		return

	var data: Dictionary = parsed
	var lines: Array = data.get("voice_lines", [])
	if lines.is_empty():
		load_errors.append("voice_lines must not be empty")
		return

	for index in lines.size():
		var item = lines[index]
		if not item is Dictionary:
			load_errors.append("voice_lines[%d] must be an object" % index)
			continue
		_validate_and_add_line(item, index)


func _validate_and_add_line(line: Dictionary, index: int) -> void:
	for field in REQUIRED_FIELDS:
		if not line.has(field):
			load_errors.append("voice_lines[%d] missing field: %s" % [index, field])

	var audio_id := str(line.get("audio_id", ""))
	if audio_id.is_empty():
		load_errors.append("voice_lines[%d] audio_id must not be empty" % index)
		return
	if voice_lines_by_id.has(audio_id):
		load_errors.append("duplicate audio_id: %s" % audio_id)
		return

	for field in ["text", "tts_voice_id", "speaker_id"]:
		if str(line.get(field, "")).is_empty():
			load_errors.append("%s field must not be empty: %s" % [field, audio_id])

	for field in ["recording_enabled", "repeat_after_me_enabled", "speech_eval_enabled"]:
		if not line.get(field) is bool:
			load_errors.append("%s field must be bool: %s" % [field, audio_id])

	voice_lines_by_id[audio_id] = line.duplicate(true)
