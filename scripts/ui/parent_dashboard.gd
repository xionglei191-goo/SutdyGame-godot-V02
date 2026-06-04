extends Control
class_name ParentDashboard

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const ParentDashboardStoreScript := preload("res://scripts/systems/parent_dashboard_store.gd")

const BACKGROUND_COLOR := Color("#f3f4f1")
const SURFACE_COLOR := Color("#ffffff")
const PRIMARY_COLOR := Color("#2f6f73")
const ACCENT_COLOR := Color("#f2b84b")
const TEXT_COLOR := Color("#1f2d2f")
const MUTED_TEXT_COLOR := Color("#5d6b6d")

var save_service
var dashboard_store
var _ready_done := false
var _content_stack: VBoxContainer
var _status_label: Label


func _ready() -> void:
	if _ready_done:
		return
	_ready_done = true
	if save_service == null:
		save_service = SaveServiceScript.new()
	if dashboard_store == null:
		dashboard_store = ParentDashboardStoreScript.new(save_service)
	_build_dashboard()
	refresh()


func set_save_service(service) -> void:
	save_service = service
	dashboard_store = ParentDashboardStoreScript.new(save_service)
	if is_inside_tree():
		refresh()


func get_dashboard_summary() -> Dictionary:
	_ensure_store()
	return dashboard_store.build_dashboard_summary()


func is_local_only() -> bool:
	var privacy: Dictionary = get_dashboard_summary().get("privacy", {})
	return (
		not bool(privacy.get("account_enabled", true))
		and not bool(privacy.get("network_enabled", true))
		and not bool(privacy.get("recording_enabled", true))
	)


func is_parent_only_scene() -> bool:
	return true


func refresh() -> void:
	_ensure_store()
	if _content_stack == null:
		return
	for child in _content_stack.get_children():
		_content_stack.remove_child(child)
		child.queue_free()

	var summary := get_dashboard_summary()
	_status_label.text = "Local only"
	_content_stack.add_child(_create_overview_panel(summary))
	_content_stack.add_child(_create_cards_panel(summary.get("cards", {})))
	_content_stack.add_child(_create_activity_panel(summary.get("minigames", {})))
	_content_stack.add_child(_create_npc_panel(summary.get("npc_summaries", {})))
	_content_stack.add_child(_create_settings_panel(summary))


func get_visible_text() -> String:
	return _collect_text(self).strip_edges()


func _build_dashboard() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	var background := ColorRect.new()
	background.name = "ParentDashboardBackground"
	background.color = BACKGROUND_COLOR
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var margin := MarginContainer.new()
	margin.name = "ParentDashboardSafeArea"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 48)
	margin.add_theme_constant_override("margin_top", 32)
	margin.add_theme_constant_override("margin_right", 48)
	margin.add_theme_constant_override("margin_bottom", 32)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.name = "ParentDashboardLayout"
	layout.add_theme_constant_override("separation", 18)
	margin.add_child(layout)

	var header := HBoxContainer.new()
	header.name = "ParentDashboardHeader"
	header.custom_minimum_size = Vector2(0, 84)
	header.add_theme_constant_override("separation", 18)
	layout.add_child(header)

	var title_area := VBoxContainer.new()
	title_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_area.add_theme_constant_override("separation", 4)
	header.add_child(title_area)

	var title := Label.new()
	title.name = "ParentDashboardTitle"
	title.text = "Parent Dashboard"
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 34)
	title_area.add_child(title)

	var subtitle := Label.new()
	subtitle.name = "ParentDashboardSubtitle"
	subtitle.text = "Local family summary"
	subtitle.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	subtitle.add_theme_font_size_override("font_size", 18)
	title_area.add_child(subtitle)

	_status_label = Label.new()
	_status_label.name = "ParentDashboardStatus"
	_status_label.custom_minimum_size = Vector2(180, 48)
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_status_label.add_theme_color_override("font_color", Color.WHITE)
	_status_label.add_theme_font_size_override("font_size", 18)
	_status_label.add_theme_stylebox_override("normal", _rounded_box(PRIMARY_COLOR, 8))
	header.add_child(_status_label)

	var scroll := ScrollContainer.new()
	scroll.name = "ParentDashboardScroll"
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)

	_content_stack = VBoxContainer.new()
	_content_stack.name = "ParentDashboardContent"
	_content_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_stack.add_theme_constant_override("separation", 14)
	scroll.add_child(_content_stack)


func _create_overview_panel(summary: Dictionary) -> Control:
	var profile: Dictionary = summary.get("profile", {})
	var time: Dictionary = summary.get("learning_time", {})
	return _create_panel("OverviewPanel", "Local Summary", [
		"Profile: %s" % str(profile.get("display_name", "Player")),
		"Save: %s" % str(profile.get("save_scope", "local_device")),
		"Time: %s min across %s sessions" % [int(time.get("minutes", 0)), int(time.get("sessions", 0))],
	])


func _create_cards_panel(cards: Dictionary) -> Control:
	return _create_panel("CardsSummaryPanel", "Cards", [
		"Contacted: %s" % int(cards.get("contacted_count", 0)),
		"Collected: %s" % int(cards.get("collected_count", 0)),
		"Played: %s" % int(cards.get("played_count", 0)),
		"Shiny: %s" % int(cards.get("shiny_count", 0)),
	])


func _create_activity_panel(minigames: Dictionary) -> Control:
	return _create_panel("ActivitySummaryPanel", "Activities", [
		"Minigames: %s" % int(minigames.get("result_count", 0)),
		"Coins earned: %s" % int(minigames.get("total_coins", 0)),
		"Best score: %s" % int(minigames.get("best_score", 0)),
	])


func _create_npc_panel(npc_summaries: Dictionary) -> Control:
	var latest: Dictionary = npc_summaries.get("latest_ref", {})
	return _create_panel("NpcSummaryPanel", "Neighbors", [
		"Summaries: %s" % int(npc_summaries.get("count", 0)),
		"Latest: %s" % str(latest.get("title", "No local note yet")),
	])


func _create_settings_panel(summary: Dictionary) -> Control:
	var local_settings: Dictionary = summary.get("local_settings", {}).get("settings", {})
	var privacy: Dictionary = summary.get("privacy", {})
	return _create_panel("PrivacySettingsPanel", "Privacy And Settings", [
		"Account: %s" % _off_on(privacy.get("account_enabled", false)),
		"Network: %s" % _off_on(privacy.get("network_enabled", false)),
		"Recording: %s" % _off_on(privacy.get("recording_enabled", false)),
		"Parent summary: %s" % _off_on(local_settings.get("parent_summary_enabled", false)),
	])


func _create_panel(panel_name: String, title_text: String, lines: Array[String]) -> Control:
	var panel := PanelContainer.new()
	panel.name = panel_name
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _rounded_box(SURFACE_COLOR, 8, Color("#d9e2df")))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	margin.add_child(stack)

	var title := Label.new()
	title.name = "%sTitle" % panel_name
	title.text = title_text
	title.add_theme_color_override("font_color", TEXT_COLOR)
	title.add_theme_font_size_override("font_size", 22)
	stack.add_child(title)

	for line in lines:
		var label := Label.new()
		label.text = line
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
		label.add_theme_font_size_override("font_size", 16)
		stack.add_child(label)

	return panel


func _ensure_store() -> void:
	if save_service == null:
		save_service = SaveServiceScript.new()
	if dashboard_store == null:
		dashboard_store = ParentDashboardStoreScript.new(save_service)


func _off_on(value: Variant) -> String:
	return "on" if bool(value) else "off"


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
