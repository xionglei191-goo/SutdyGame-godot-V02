extends SceneTree

const DOC_PATH := "res://docs/collaboration/Round152_V02.37_STORYBATCH-002第二批story_prop与AZ回访内容包.md"
const REQUIRED_CANDIDATES: Array[Dictionary] = [
	{"candidate_id": "story_prop_candidate_home_clock_chair", "anchor_id": "anchor_c_clock", "place_id": "place_home"},
	{"candidate_id": "story_prop_candidate_home_sunny_towel_dog", "anchor_id": "anchor_d_dog", "place_id": "place_home"},
	{"candidate_id": "story_prop_candidate_home_watch_wall_charm", "anchor_id": "anchor_w_watch", "place_id": "place_home"},
	{"candidate_id": "story_prop_candidate_school_gate_bell", "anchor_id": "anchor_g_gate", "place_id": "place_school_gate"},
	{"candidate_id": "story_prop_candidate_walk_kite_leaf", "anchor_id": "anchor_k_kite", "place_id": "place_home_school_walk"},
	{"candidate_id": "story_prop_candidate_shop_orange_bowl", "anchor_id": "anchor_o_orange", "place_id": "place_supermarket"},
	{"candidate_id": "story_prop_candidate_sun_flower_patch", "anchor_id": "anchor_s_sun", "place_id": "place_sun_scene"},
]
const REQUIRED_DETAIL_FIELDS: Array[String] = [
	"planned story prop ID",
	"planned logical asset ID",
	"story memory",
	"visual hook",
	"review path",
	"child label",
	"child feedback",
	"asset note",
]
const FORBIDDEN_TEXT: Array[String] = [
	"课程",
	"测试",
	"测验",
	"考试",
	"背诵",
	"评分",
	"打卡",
	"倒计时",
	"作业",
	"分数",
	"迟到",
	"必须完成",
	"debug",
	"grid",
	"坐标",
	"格子",
]

var failures: Array[String] = []


func _init() -> void:
	var doc := _read_text(DOC_PATH)
	_check_required_candidates(doc)
	_check_detail_fields(doc)
	_check_anchor_uniqueness()
	_check_child_safe_text(doc)
	_check_boundary_statements(doc)
	_finish()


func _check_required_candidates(doc: String) -> void:
	for candidate in REQUIRED_CANDIDATES:
		var candidate_id := str(candidate.get("candidate_id", ""))
		_expect(doc.contains(candidate_id), "V02.37 STORYBATCH-002 doc should include candidate: %s" % candidate_id)
		_expect(doc.contains(str(candidate.get("anchor_id", ""))), "V02.37 STORYBATCH-002 doc should bind anchor for %s" % candidate_id)
		_expect(doc.contains(str(candidate.get("place_id", ""))), "V02.37 STORYBATCH-002 doc should bind place for %s" % candidate_id)


func _check_detail_fields(doc: String) -> void:
	for field in REQUIRED_DETAIL_FIELDS:
		_expect(doc.contains(field), "V02.37 STORYBATCH-002 doc should include detail field: %s" % field)
	for required_phrase in ["Environment Words", "Asset Need", "NPC context", "resource context", "后续交付要求"]:
		_expect(doc.contains(required_phrase), "V02.37 STORYBATCH-002 doc should include production handoff phrase: %s" % required_phrase)


func _check_anchor_uniqueness() -> void:
	var seen: Dictionary = {}
	for candidate in REQUIRED_CANDIDATES:
		var anchor_id := str(candidate.get("anchor_id", ""))
		_expect(not seen.has(anchor_id), "V02.37 STORYBATCH-002 candidates should not reuse core anchor: %s" % anchor_id)
		seen[anchor_id] = true
	_expect(seen.size() == REQUIRED_CANDIDATES.size(), "V02.37 STORYBATCH-002 should cover seven unique anchors")


func _check_child_safe_text(doc: String) -> void:
	var child_lines: Array[String] = []
	for line in doc.split("\n"):
		if line.contains("child label") or line.contains("child feedback") or line.begins_with("| child label |") or line.begins_with("| child feedback |"):
			child_lines.append(line)
	_expect(child_lines.size() >= REQUIRED_CANDIDATES.size() * 2, "V02.37 STORYBATCH-002 doc should include child label/feedback lines")
	var child_text := "\n".join(child_lines)
	for forbidden in FORBIDDEN_TEXT:
		_expect(not child_text.contains(forbidden), "V02.37 STORYBATCH-002 child-facing text should avoid forbidden text: %s" % forbidden)


func _check_boundary_statements(doc: String) -> void:
	for phrase in [
		"不生成图片",
		"不改 ThemeProfile / AssetResolver",
		"不改 runtime",
		"不写正式 JSON",
		"不重排、不覆盖 core anchors",
		"production` 提升为 `approved",
		"/home/xionglei/GameProject/tools/image_generator.js",
	]:
		_expect(doc.contains(phrase), "V02.37 STORYBATCH-002 doc should preserve boundary/provenance phrase: %s" % phrase)


func _read_text(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "V02.37 STORYBATCH-002 doc should open: %s" % path)
	if file == null:
		return ""
	return file.get_as_text()


func _finish() -> void:
	if failures.is_empty():
		print("V02.37 STORYBATCH-002 CONTENT PACK TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
