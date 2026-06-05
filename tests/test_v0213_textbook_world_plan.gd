extends SceneTree

const TextbookWorldContractScript := preload("res://scripts/data/textbook_world_contract.gd")

var failures: Array[String] = []


func _init() -> void:
	var loaded: Dictionary = TextbookWorldContractScript.load_plan()
	_expect(loaded.get("ok", false), "V02.13 textbook world plan should pass contract: %s" % [loaded.get("errors", [])])
	var data: Dictionary = loaded.get("data", {})
	_check_sources(data)
	_check_curriculum_items(data)
	_check_p0_mappings(data)
	_check_mainline_segments(data)
	_check_invalid_plan_rejected(data)
	_finish()


func _check_sources(data: Dictionary) -> void:
	var sources := _records_by_id(data.get("textbook_sources", []), "source_id")
	_expect(sources.size() == 8, "V02.13 should cover 8 primary volumes")
	_expect(sources.has("src_grade_3a"), "V02.13 should add Grade 3A source")
	_expect(str(sources.get("src_grade_3a", {}).get("source_status", "")) == "web_summarized", "Grade 3A should keep web summarized status")
	_expect(int(sources.get("src_grade_6b", {}).get("unit_count", 0)) == 9, "Grade 6B should keep 9-unit source count")


func _check_curriculum_items(data: Dictionary) -> void:
	var counts: Dictionary = {}
	for item in data.get("curriculum_items", []):
		if item is Dictionary:
			var source_id := str((item as Dictionary).get("source_id", ""))
			counts[source_id] = int(counts.get(source_id, 0)) + 1
	_expect(int(counts.get("src_grade_3a", 0)) == 10, "Grade 3A should include 10 unit summaries")
	_expect(int(counts.get("src_grade_5a", 0)) == 12, "Grade 5A should include 12 unit summaries")
	_expect(int(counts.get("src_grade_6b", 0)) == 9, "Grade 6B should include 9 unit summaries")
	_expect(data.get("curriculum_items", []).size() == 85, "V02.13 should summarize all 85 known unit slots")


func _check_p0_mappings(data: Dictionary) -> void:
	var p0_count := 0
	var p0_places: Dictionary = {}
	for mapping in data.get("world_mappings", []):
		if mapping is Dictionary and str((mapping as Dictionary).get("tier", "")) == "P0":
			p0_count += 1
			p0_places[str((mapping as Dictionary).get("world_place_id", ""))] = true
			_expect(not ["anchor_x_x_mark_box", "anchor_z_zebra"].has(str((mapping as Dictionary).get("anchor_id", ""))), "P0 mapping should not use far edge anchors")
	_expect(p0_count >= 12, "V02.13 should include at least 12 P0 world mappings")
	_expect(p0_places.has("place_home"), "P0 mappings should include Home")
	_expect(p0_places.has("place_school_gate"), "P0 mappings should include School Gate")
	_expect(p0_places.has("place_home_school_walk"), "P0 mappings should include Home-School Walk")


func _check_mainline_segments(data: Dictionary) -> void:
	var by_segment := _records_by_id(data.get("mainline_segments", []), "segment_id")
	_expect(by_segment.has("seg_p0_home_morning_foundation"), "V02.13 should define Home morning P0 segment")
	_expect(by_segment.has("seg_p0_home_school_walk"), "V02.13 should define Home-School Walk P0 segment")
	_expect(by_segment.has("seg_p1_first_ring_expansion"), "V02.13 should define P1 first ring segment")
	_expect(by_segment.has("seg_p2_future_reserve"), "V02.13 should define P2 future reserve segment")
	for segment in data.get("mainline_segments", []):
		if segment is Dictionary:
			_expect(not bool((segment as Dictionary).get("blocks_current_daily_loop", true)), "V02.13 data segments should not block current daily loop")


func _check_invalid_plan_rejected(data: Dictionary) -> void:
	var invalid_missing_source: Dictionary = data.duplicate(true)
	invalid_missing_source["textbook_sources"].remove_at(0)
	var source_errors: Array[String] = TextbookWorldContractScript.validate_plan(invalid_missing_source)
	_expect(not source_errors.is_empty(), "contract should reject missing textbook source")

	var invalid_far_p0: Dictionary = data.duplicate(true)
	invalid_far_p0["world_mappings"][0]["anchor_id"] = "anchor_z_zebra"
	invalid_far_p0["world_mappings"][0]["world_place_id"] = "place_zoo_edge"
	var far_errors: Array[String] = TextbookWorldContractScript.validate_plan(invalid_far_p0)
	_expect(not far_errors.is_empty(), "contract should reject P0 far-edge mapping")

	var invalid_pressure: Dictionary = data.duplicate(true)
	invalid_pressure["world_mappings"][0]["child_facing_line"] = "必须完成测试。"
	var pressure_errors: Array[String] = TextbookWorldContractScript.validate_plan(invalid_pressure)
	_expect(not pressure_errors.is_empty(), "contract should reject pressure wording")


func _records_by_id(records: Array, id_key: String) -> Dictionary:
	var mapped: Dictionary = {}
	for record in records:
		if record is Dictionary:
			mapped[str((record as Dictionary).get(id_key, ""))] = record
	return mapped


func _finish() -> void:
	if failures.is_empty():
		print("V02.13 TEXTBOOK WORLD PLAN TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
