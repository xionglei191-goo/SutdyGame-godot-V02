extends Control
class_name MemoryAlbum

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const MemoryCardServiceScript := preload("res://scripts/systems/memory_card_service.gd")

const FIRST_BATCH_CORE_IDS: Array[String] = [
	"card_a_apple_core",
	"card_b_bear_core",
	"card_c_clock_core",
	"card_d_dog_core",
	"card_e_elephant_core",
	"card_g_gate_core",
	"card_k_kite_core",
	"card_n_net_core",
	"card_o_orange_core",
	"card_r_robot_core",
	"card_s_sun_core",
	"card_t_taxi_core",
	"card_u_umbrella_core",
	"card_w_watch_core",
	"card_y_yo_yo_core",
]
const BLOCKED_CHILD_TERMS: Array[String] = ["lesson", "test", "word list", "review", "failed"]
const BACKGROUND_COLOR := Color("#eef4f0")
const SURFACE_COLOR := Color("#ffffff")
const CARD_COLOR := Color("#fffaf0")
const CARD_LOCKED_COLOR := Color("#e8ece9")
const PRIMARY_COLOR := Color("#2f6f73")
const ACCENT_COLOR := Color("#f2b84b")
const TEXT_COLOR := Color("#1f2d2f")
const MUTED_TEXT_COLOR := Color("#5d6b6d")

@export var columns: int = 3

var save_service
var memory_card_service
var _ready_done := false
var _grid: GridContainer
var _summary_label: Label


func _ready() -> void:
	if _ready_done:
		return
	_ready_done = true
	if save_service == null:
		save_service = SaveServiceScript.new()
	if memory_card_service == null:
		memory_card_service = MemoryCardServiceScript.new(save_service)
	_build_album()
	refresh()


func set_save_service(service) -> void:
	save_service = service
	memory_card_service = MemoryCardServiceScript.new(save_service)
	if is_inside_tree():
		refresh()


func set_memory_card_service(service) -> void:
	memory_card_service = service
	if is_inside_tree():
		refresh()


func refresh() -> void:
	_ensure_services()
	if _grid == null:
		return
	for child in _grid.get_children():
		_grid.remove_child(child)
		child.queue_free()

	var album_cards := get_album_cards()
	var collected_count := 0
	for card in album_cards:
		var state: Dictionary = memory_card_service.get_card_state(str(card.get("card_id", "")))
		if bool(state.get("collected", false)):
			collected_count += 1
		_grid.add_child(_create_card_tile(card, state))

	if is_instance_valid(_summary_label):
		_summary_label.text = "%d 个发现亮起来" % collected_count


func get_album_cards() -> Array[Dictionary]:
	_ensure_services()
	var by_id: Dictionary = {}
	for card in memory_card_service.get_all_cards():
		by_id[str(card.get("card_id", ""))] = card

	var cards: Array[Dictionary] = []
	for card_id in FIRST_BATCH_CORE_IDS:
		if by_id.has(card_id):
			cards.append(by_id[card_id].duplicate(true))

	var extension_cards: Array[Dictionary] = []
	for card_id in by_id.keys():
		if not FIRST_BATCH_CORE_IDS.has(str(card_id)) and not str(card_id).ends_with("_core"):
			extension_cards.append(by_id[card_id].duplicate(true))
	extension_cards.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return str(a.get("card_id", "")) < str(b.get("card_id", ""))
	)
	cards.append_array(extension_cards)
	return cards


func get_visible_text() -> String:
	return _collect_text(self).strip_edges()


func has_blocked_child_terms() -> bool:
	var text := get_visible_text().to_lower()
	for term in BLOCKED_CHILD_TERMS:
		if text.contains(term):
			return true
	return false


func _build_album() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var background := ColorRect.new()
	background.name = "AlbumBackground"
	background.color = BACKGROUND_COLOR
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.name = "AlbumSafeArea"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 48)
	margin.add_theme_constant_override("margin_top", 32)
	margin.add_theme_constant_override("margin_right", 48)
	margin.add_theme_constant_override("margin_bottom", 32)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.name = "AlbumLayout"
	layout.add_theme_constant_override("separation", 18)
	margin.add_child(layout)

	var header := HBoxContainer.new()
	header.name = "AlbumHeader"
	header.custom_minimum_size = Vector2(0, 84)
	header.add_theme_constant_override("separation", 18)
	layout.add_child(header)

	var title_area := VBoxContainer.new()
	title_area.name = "AlbumTitleArea"
	title_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_area.add_theme_constant_override("separation", 4)
	header.add_child(title_area)

	var title := Label.new()
	title.name = "AlbumTitle"
	title.text = "小镇相册"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 36)
	title_area.add_child(title)

	var subtitle := Label.new()
	subtitle.name = "AlbumSubtitle"
	subtitle.text = "路过时发现的小物件"
	subtitle.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	subtitle.add_theme_font_size_override("font_size", 18)
	title_area.add_child(subtitle)

	_summary_label = Label.new()
	_summary_label.name = "AlbumSummary"
	_summary_label.custom_minimum_size = Vector2(280, 48)
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_summary_label.add_theme_color_override("font_color", Color.WHITE)
	_summary_label.add_theme_font_size_override("font_size", 18)
	_summary_label.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR, 8))
	header.add_child(_summary_label)

	var scroll := ScrollContainer.new()
	scroll.name = "AlbumScroll"
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)

	_grid = GridContainer.new()
	_grid.name = "CardGrid"
	_grid.columns = max(1, columns)
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_grid.add_theme_constant_override("h_separation", 16)
	_grid.add_theme_constant_override("v_separation", 16)
	scroll.add_child(_grid)


func _create_card_tile(card: Dictionary, state: Dictionary) -> Control:
	var collected := bool(state.get("collected", false))
	var played := bool(state.get("played", false))
	var seen := bool(state.get("seen", false))
	var shiny := bool(state.get("shiny", false))

	var tile := PanelContainer.new()
	tile.name = str(card.get("card_id", "card"))
	tile.custom_minimum_size = Vector2(270, 190)
	tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tile.add_theme_stylebox_override(
		"panel",
		_rounded_box(CARD_COLOR if seen or played or collected else CARD_LOCKED_COLOR, 8, ACCENT_COLOR if collected else Color("#cbd6d2"))
	)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 14)
	tile.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 10)
	stack.add_child(top)

	var sticker := Label.new()
	sticker.name = "Sticker"
	sticker.custom_minimum_size = Vector2(56, 56)
	sticker.text = str(card.get("letter", _fallback_sticker(card)))
	sticker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sticker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sticker.add_theme_color_override("font_color", TEXT_COLOR)
	sticker.add_theme_font_size_override("font_size", 28)
	sticker.add_theme_stylebox_override("normal", _rounded_box(ACCENT_COLOR.lightened(0.15) if seen else Color("#d5ddda"), 8))
	top.add_child(sticker)

	var title_stack := VBoxContainer.new()
	title_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_stack.add_theme_constant_override("separation", 2)
	top.add_child(title_stack)

	var name_label := Label.new()
	name_label.name = "CardName"
	name_label.text = _display_name(card)
	name_label.add_theme_color_override("font_color", TEXT_COLOR)
	name_label.add_theme_font_size_override("font_size", 22)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_stack.add_child(name_label)

	var state_label := Label.new()
	state_label.name = "StateLabel"
	state_label.text = _state_text(state)
	state_label.add_theme_color_override("font_color", PRIMARY_COLOR if collected or played else MUTED_TEXT_COLOR)
	state_label.add_theme_font_size_override("font_size", 16)
	title_stack.add_child(state_label)

	var story := Label.new()
	story.name = "StoryMemory"
	story.text = str(card.get("story_memory", "小镇里还有一个新发现等着你。"))
	story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	story.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	story.add_theme_font_size_override("font_size", 15)
	stack.add_child(story)

	var footer := HBoxContainer.new()
	footer.name = "CardFooter"
	footer.add_theme_constant_override("separation", 8)
	stack.add_child(footer)

	footer.add_child(_create_badge("亮点 %d" % int(state.get("spark", 0)), false))
	if shiny:
		footer.add_child(_create_badge("闪光", true))
	if played:
		footer.add_child(_create_badge("玩过", true))
	if collected:
		footer.add_child(_create_badge("已收藏", true))

	return tile


func _create_badge(text: String, active: bool) -> Label:
	var badge := Label.new()
	badge.text = text
	badge.custom_minimum_size = Vector2(78, 28)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_theme_color_override("font_color", Color.WHITE if active else MUTED_TEXT_COLOR)
	badge.add_theme_font_size_override("font_size", 13)
	badge.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR if active else Color("#edf2ef"), 8))
	return badge


func _state_text(state: Dictionary) -> String:
	if bool(state.get("collected", false)):
		return "已收藏"
	if bool(state.get("played", false)):
		return "玩过"
	if bool(state.get("seen", false)):
		return "见过"
	return "还没遇见"


func _display_name(card: Dictionary) -> String:
	var word := str(card.get("word", "keepsake"))
	if card.has("letter"):
		return "%s 小物件" % str(card.get("letter", ""))
	return "%s 收藏" % word.capitalize()


func _fallback_sticker(card: Dictionary) -> String:
	var word := str(card.get("word", "?"))
	return word.substr(0, 1).to_upper() if not word.is_empty() else "?"


func _ensure_services() -> void:
	if save_service == null:
		save_service = SaveServiceScript.new()
	if memory_card_service == null:
		memory_card_service = MemoryCardServiceScript.new(save_service)


func _collect_text(node: Node) -> String:
	var parts: Array[String] = []
	if node is Label:
		parts.append((node as Label).text)
	elif node is Button:
		parts.append((node as Button).text)
	for child in node.get_children():
		parts.append(_collect_text(child))
	return " ".join(parts)


func _rounded_box(fill: Color, radius: int, border: Color = Color.TRANSPARENT) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.corner_radius_top_left = radius
	box.corner_radius_top_right = radius
	box.corner_radius_bottom_left = radius
	box.corner_radius_bottom_right = radius
	if border.a > 0.0:
		box.border_color = border
		box.border_width_left = 1
		box.border_width_top = 1
		box.border_width_right = 1
		box.border_width_bottom = 1
	return box
