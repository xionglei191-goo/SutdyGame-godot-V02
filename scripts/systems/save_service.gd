extends RefCounted
class_name SaveService

const DEFAULT_SAVE_PATH := "user://study_game_v02_save_stub.json"

const DEFAULT_PROFILE: Dictionary = {
	"profile_id": "local_profile",
	"display_name": "Player",
	"created_at": "",
	"updated_at": "",
}

const DEFAULT_GAME_STATE: Dictionary = {
	"coins": 0,
	"current_place_id": "home",
	"pet": {
		"pet_id": "sunny_dog",
		"hunger": 0,
		"food_count": 0,
	},
	"inventory": {},
	"flags": {},
}

const DEFAULT_LEARNING_RECORD: Dictionary = {
	"profile_id": "local_profile",
	"card_states": {},
	"word_exposures": {},
	"voice_attempts": [],
	"minigame_results": [],
	"npc_summary_refs": [],
}

var save_path: String = DEFAULT_SAVE_PATH


func _init(path: String = DEFAULT_SAVE_PATH) -> void:
	save_path = path


func load_profile() -> Dictionary:
	return _load_bucket("profile", DEFAULT_PROFILE)


func save_profile(profile: Dictionary) -> bool:
	return _save_bucket("profile", profile)


func load_game_state() -> Dictionary:
	return _load_bucket("game_state", DEFAULT_GAME_STATE)


func save_game_state(game_state: Dictionary) -> bool:
	return _save_bucket("game_state", game_state)


func load_learning_record() -> Dictionary:
	return _load_bucket("learning_record", DEFAULT_LEARNING_RECORD)


func save_learning_record(learning_record: Dictionary) -> bool:
	return _save_bucket("learning_record", learning_record)


func load_all() -> Dictionary:
	return _read_save_data()


func save_all(profile: Dictionary, game_state: Dictionary, learning_record: Dictionary) -> bool:
	var data := _default_save_data()
	data["profile"] = profile.duplicate(true)
	data["game_state"] = game_state.duplicate(true)
	data["learning_record"] = learning_record.duplicate(true)
	return _write_save_data(data)


func clear_for_test() -> bool:
	if not FileAccess.file_exists(save_path):
		return true
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path)) == OK


func reset_for_test() -> bool:
	return _write_save_data(_default_save_data())


func get_save_path() -> String:
	return save_path


func _load_bucket(bucket_name: String, default_value: Dictionary) -> Dictionary:
	var data := _read_save_data()
	return data.get(bucket_name, default_value).duplicate(true)


func _save_bucket(bucket_name: String, value: Dictionary) -> bool:
	var data := _read_save_data()
	data[bucket_name] = value.duplicate(true)
	return _write_save_data(data)


func _read_save_data() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return _default_save_data()

	var file := FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		push_warning("Unable to read local save file: %s" % save_path)
		return _default_save_data()

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Local save file is not valid JSON: %s" % save_path)
		return _default_save_data()

	var data: Dictionary = _default_save_data()
	var parsed_data: Dictionary = parsed
	for bucket_name in data.keys():
		if parsed_data.get(bucket_name) is Dictionary:
			data[bucket_name] = parsed_data[bucket_name].duplicate(true)
	return data


func _write_save_data(data: Dictionary) -> bool:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_warning("Unable to write local save file: %s" % save_path)
		return false

	file.store_string(JSON.stringify(data, "\t", true))
	return true


func _default_save_data() -> Dictionary:
	return {
		"profile": DEFAULT_PROFILE.duplicate(true),
		"game_state": DEFAULT_GAME_STATE.duplicate(true),
		"learning_record": DEFAULT_LEARNING_RECORD.duplicate(true),
	}
