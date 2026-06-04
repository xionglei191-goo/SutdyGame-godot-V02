extends Control
class_name LetterSnakeScene

signal completed(completion: Dictionary)
signal return_requested(return_scene: String)

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MinigameServiceScript := preload("res://scripts/systems/minigame_service.gd")
const CONFIG_PATH := "res://data/minigames/letter_snake_config.json"
const DEFAULT_SET_ID := "home"

@export var config_set_id: String = DEFAULT_SET_ID
@export var score: int = 0
@export var return_scene: String = "world_overview"

var save_service
var minigame_service
var round_data: Dictionary = {}
var completion_result: Dictionary = {}
var _config: Dictionary = {}
var _ready_done := false

@onready var title_label: Label = %TitleLabel
@onready var group_label: Label = %GroupLabel
@onready var letter_label: Label = %LetterLabel
@onready var word_label: Label = %WordLabel
@onready var prompt_label: Label = %PromptLabel
@onready var score_spin_box: SpinBox = %ScoreSpinBox
@onready var complete_button: Button = %CompleteButton
@onready var return_button: Button = %ReturnButton
@onready var result_label: Label = %ResultLabel


func _ready() -> void:
	if _ready_done:
		return
	_ready_done = true
	_bind_ui()
	_config = _load_config()
	return_scene = str(_config.get("return_scene", return_scene))
	if save_service == null:
		save_service = SaveServiceScript.new()
	if minigame_service == null:
		minigame_service = MinigameServiceScript.new(save_service)
	if is_instance_valid(score_spin_box):
		score_spin_box.value = score
		if not score_spin_box.value_changed.is_connected(_on_score_changed):
			score_spin_box.value_changed.connect(_on_score_changed)
	if is_instance_valid(complete_button) and not complete_button.pressed.is_connected(complete_round):
		complete_button.pressed.connect(complete_round)
	if is_instance_valid(return_button) and not return_button.pressed.is_connected(request_return):
		return_button.pressed.connect(request_return)
	start_round(config_set_id)


func set_save_service(service) -> void:
	save_service = service
	minigame_service = MinigameServiceScript.new(save_service)


func start_round(set_id: String = DEFAULT_SET_ID) -> Dictionary:
	_ensure_service()
	var started: Dictionary = minigame_service.start_minigame(set_id)
	if not bool(started.get("ok", false)):
		round_data = {}
		_update_error("Trail is resting.")
		return started
	config_set_id = set_id
	round_data = started
	_update_target_display()
	return started


func set_score(value: int) -> void:
	score = max(0, value)
	_bind_ui()
	if is_instance_valid(score_spin_box):
		score_spin_box.value = score


func complete_round() -> Dictionary:
	_ensure_round_started()
	var completion: Dictionary = minigame_service.complete_minigame(_build_result())
	completion["return_scene"] = return_scene
	completion_result = completion.duplicate(true)
	_update_completion_display(completion)
	completed.emit(completion)
	return completion


func request_return() -> void:
	return_requested.emit(return_scene)


func get_target_letters() -> Array[String]:
	return _string_array(_current_set().get("target_letters", []))


func get_target_words() -> Array[String]:
	return _string_array(_current_set().get("target_words", []))


func _build_result() -> Dictionary:
	var target_set: Dictionary = _current_set()
	var target_letters: Array[String] = _string_array(target_set.get("target_letters", []))
	var target_words: Array[String] = _string_array(target_set.get("target_words", []))
	var defaults: Dictionary = round_data.get("round_defaults", {})
	return {
		"config_set_id": config_set_id,
		"score": score,
		"target_letters_seen": target_letters,
		"target_words_seen": target_words,
		"target_hits": max(1, int(ceil(float(score) / 10.0))),
		"distractor_touches": 0,
		"duration_seconds": int(defaults.get("duration_seconds", 60)),
	}


func _current_set() -> Dictionary:
	return round_data.get("set", {})


func _update_target_display() -> void:
	_bind_ui()
	var target_set: Dictionary = _current_set()
	var letters: Array[String] = get_target_letters()
	var words: Array[String] = get_target_words()
	if is_instance_valid(title_label):
		title_label.text = str(_config.get("display_name", "Letter Snake"))
	if is_instance_valid(group_label):
		group_label.text = str(target_set.get("child_title", "Trail"))
	if is_instance_valid(letter_label):
		letter_label.text = "Letters: %s" % ", ".join(letters)
	if is_instance_valid(word_label):
		word_label.text = "Words: %s" % ", ".join(words)
	var prompts: Array = target_set.get("prompt_templates", [])
	var lead_target := words[0] if not words.is_empty() else letters[0] if not letters.is_empty() else ""
	var prompt := str(prompts[0]) if not prompts.is_empty() else "Find {target}."
	if is_instance_valid(prompt_label):
		prompt_label.text = prompt.replace("{target}", lead_target)
	if is_instance_valid(result_label):
		result_label.text = ""


func _update_completion_display(completion: Dictionary) -> void:
	_bind_ui()
	if not is_instance_valid(result_label):
		return
	if not bool(completion.get("ok", false)):
		result_label.text = "Trail needs a restart."
		return
	var reward: Dictionary = completion.get("reward", {})
	result_label.text = "+%d coins  +%d card glow" % [
		int(reward.get("coins", 0)),
		int(reward.get("card_progress", 0)),
	]


func _update_error(message: String) -> void:
	_bind_ui()
	if is_instance_valid(title_label):
		title_label.text = str(_config.get("display_name", "Letter Snake"))
	if is_instance_valid(group_label):
		group_label.text = message
	if is_instance_valid(letter_label):
		letter_label.text = ""
	if is_instance_valid(word_label):
		word_label.text = ""
	if is_instance_valid(prompt_label):
		prompt_label.text = ""
	if is_instance_valid(result_label):
		result_label.text = ""


func _ensure_round_started() -> void:
	if round_data.is_empty():
		start_round(config_set_id)


func _ensure_service() -> void:
	if save_service == null:
		save_service = SaveServiceScript.new()
	if minigame_service == null:
		minigame_service = MinigameServiceScript.new(save_service)
	if _config.is_empty():
		_config = _load_config()
		return_scene = str(_config.get("return_scene", return_scene))


func _bind_ui() -> void:
	if not is_instance_valid(title_label):
		title_label = find_child("TitleLabel", true, false) as Label
	if not is_instance_valid(group_label):
		group_label = find_child("GroupLabel", true, false) as Label
	if not is_instance_valid(letter_label):
		letter_label = find_child("LetterLabel", true, false) as Label
	if not is_instance_valid(word_label):
		word_label = find_child("WordLabel", true, false) as Label
	if not is_instance_valid(prompt_label):
		prompt_label = find_child("PromptLabel", true, false) as Label
	if not is_instance_valid(score_spin_box):
		score_spin_box = find_child("ScoreSpinBox", true, false) as SpinBox
	if not is_instance_valid(complete_button):
		complete_button = find_child("CompleteButton", true, false) as Button
	if not is_instance_valid(return_button):
		return_button = find_child("ReturnButton", true, false) as Button
	if not is_instance_valid(result_label):
		result_label = find_child("ResultLabel", true, false) as Label


func _load_config() -> Dictionary:
	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file == null:
		push_warning("Unable to open Letter Snake config: %s" % CONFIG_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Letter Snake config must be a dictionary: %s" % CONFIG_PATH)
		return {}
	return parsed


func _string_array(value: Array) -> Array[String]:
	var output: Array[String] = []
	for item in value:
		output.append(str(item))
	return output


func _on_score_changed(value: float) -> void:
	score = max(0, int(value))
