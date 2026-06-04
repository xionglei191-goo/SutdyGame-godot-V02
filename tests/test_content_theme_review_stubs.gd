extends SceneTree

const ContentPackLoaderScript := preload("res://scripts/systems/content_pack_loader.gd")
const ThemeSwitchServiceScript := preload("res://scripts/systems/theme_switch_service.gd")
const ContentReviewPipelineScript := preload("res://scripts/systems/content_review_pipeline.gd")

var failures: Array[String] = []


func _init() -> void:
	_check_content_pack_loader()
	_check_theme_switch()
	_check_review_pipeline()

	if failures.is_empty():
		print("HEADLESS TESTS PASSED: content/theme/review future stubs")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _check_content_pack_loader() -> void:
	var loader = ContentPackLoaderScript.new()
	var legal_pack := _legal_pack()
	var legal_validation: Dictionary = loader.validate_pack(legal_pack)
	_expect(legal_validation.get("ok", false), "legal content pack must validate: %s" % [legal_validation.get("errors", [])])

	var install: Dictionary = loader.install_pack(legal_pack)
	_expect(install.get("ok", false), "legal content pack must install: %s" % [install.get("errors", [])])
	_expect(loader.is_pack_installed("pack_local_garden_words_001"), "installed content pack must be visible locally")
	_expect(loader.get_installed_word("word_ant").get("story_memory", "") != "", "installed word must be queryable")

	var rollback: Dictionary = loader.rollback_pack("pack_local_garden_words_001")
	_expect(rollback.get("ok", false), "installed content pack must rollback: %s" % [rollback.get("errors", [])])
	_expect(not loader.is_pack_installed("pack_local_garden_words_001"), "rolled back content pack must be removed")
	_expect(loader.get_installed_word("word_ant").is_empty(), "rolled back word must be removed")

	var illegal_missing := _legal_pack()
	illegal_missing["new_words"][0].erase("story_memory")
	var missing_validation: Dictionary = loader.validate_pack(illegal_missing)
	_expect(not missing_validation.get("ok", true), "word without story_memory must be illegal")

	var illegal_anchor := _legal_pack()
	illegal_anchor["anchors"] = [{"anchor_id": "anchor_a_apple", "letter": "A"}]
	var anchor_validation: Dictionary = loader.validate_pack(illegal_anchor)
	_expect(not anchor_validation.get("ok", true), "content pack must reject A-Z core anchor override")


func _check_theme_switch() -> void:
	var service = ThemeSwitchServiceScript.new()
	var switched: Dictionary = service.switch_theme("theme_rainbow_garden_placeholder", [
		{"category": "tile_atlas", "asset_id": "world"},
		{"category": "npc_assets", "asset_id": "mina"},
	])
	_expect(switched.get("ok", false), "theme switch must resolve second placeholder theme: %s" % [switched.get("errors", [])])
	_expect(service.get_current_theme_id() == "theme_rainbow_garden_placeholder", "theme switch must update current theme id")
	var resolved: Dictionary = service.resolve_asset("theme_rainbow_garden_placeholder", "ui_skin", "primary_button")
	_expect(resolved.get("ok", false), "second theme must resolve logical UI asset")
	_expect(str(resolved.get("placeholder_path", "")).begins_with("placeholder://theme_rainbow_garden_placeholder/"), "second theme must return its placeholder path")


func _check_review_pipeline() -> void:
	var review = ContentReviewPipelineScript.new()
	var submitted: Dictionary = review.submit_candidate({
		"candidate_id": "candidate_pack_local_garden_words_001",
		"type": "content_pack",
		"payload": _legal_pack(),
	})
	_expect(submitted.get("ok", false), "review pipeline must store candidate")
	var blocked: Dictionary = review.publish_for_runtime("candidate_pack_local_garden_words_001")
	_expect(not blocked.get("ok", true), "unapproved content must be blocked from runtime publish")
	_expect(not review.is_runtime_published("candidate_pack_local_garden_words_001"), "blocked candidate must not become runtime published")
	var approved: Dictionary = review.set_manual_status("candidate_pack_local_garden_words_001", "approved", "local_parent_reviewer")
	_expect(approved.get("ok", false), "manual approval must be recorded")
	var published: Dictionary = review.publish_for_runtime("candidate_pack_local_garden_words_001")
	_expect(published.get("ok", false), "approved content may publish to runtime stub")
	_expect(review.is_runtime_published("candidate_pack_local_garden_words_001"), "approved candidate must become runtime published")


func _legal_pack() -> Dictionary:
	return {
		"pack_id": "pack_local_garden_words_001",
		"version": 1,
		"new_words": [
			{
				"word_id": "word_ant",
				"word": "ant",
				"letter": "A",
				"core_anchor_id": "anchor_a_apple",
				"world_place_id": "place_home",
				"story_memory": "An ant carries a tiny apple crumb beside the Home welcome box.",
				"visual_hook": "tiny ant trail under the red apple sign",
				"review_path": "Home welcome box -> Town Start flower path -> Home welcome box"
			}
		],
	}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
