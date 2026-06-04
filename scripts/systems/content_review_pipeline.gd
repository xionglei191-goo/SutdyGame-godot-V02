extends RefCounted
class_name ContentReviewPipeline

const STATUS_DRAFT := "draft"
const STATUS_APPROVED := "approved"
const STATUS_REJECTED := "rejected"
const RUNTIME_PUBLISHABLE_TYPE := "content_pack"

var candidates: Dictionary = {}
var runtime_published: Dictionary = {}


func submit_candidate(candidate: Dictionary) -> Dictionary:
	var candidate_id := str(candidate.get("candidate_id", ""))
	if candidate_id.is_empty():
		return {"ok": false, "errors": ["Review candidate requires candidate_id."], "candidate_id": candidate_id}

	var stored: Dictionary = candidate.duplicate(true)
	stored["status"] = STATUS_DRAFT
	stored["runtime_published"] = false
	candidates[candidate_id] = stored
	return {"ok": true, "errors": [], "candidate_id": candidate_id, "status": STATUS_DRAFT}


func set_manual_status(candidate_id: String, status: String, reviewer_id: String = "local_reviewer") -> Dictionary:
	if not candidates.has(candidate_id):
		return {"ok": false, "errors": ["Unknown review candidate: %s" % candidate_id], "candidate_id": candidate_id}
	if not [STATUS_APPROVED, STATUS_REJECTED, STATUS_DRAFT].has(status):
		return {"ok": false, "errors": ["Unsupported review status: %s" % status], "candidate_id": candidate_id}

	var candidate: Dictionary = candidates[candidate_id]
	candidate["status"] = status
	candidate["manual_reviewer_id"] = reviewer_id
	candidates[candidate_id] = candidate
	return {"ok": true, "errors": [], "candidate_id": candidate_id, "status": status}


func publish_for_runtime(candidate_id: String) -> Dictionary:
	if not candidates.has(candidate_id):
		return {"ok": false, "errors": ["Unknown review candidate: %s" % candidate_id], "published": false}

	var candidate: Dictionary = candidates[candidate_id]
	if str(candidate.get("status", "")) != STATUS_APPROVED:
		return {
			"ok": false,
			"errors": ["Review candidate must be manually approved before runtime publish: %s" % candidate_id],
			"candidate_id": candidate_id,
			"published": false,
			"status": str(candidate.get("status", "")),
		}

	candidate["runtime_published"] = true
	candidates[candidate_id] = candidate
	runtime_published[candidate_id] = candidate.duplicate(true)
	return {"ok": true, "errors": [], "candidate_id": candidate_id, "published": true, "status": STATUS_APPROVED}


func get_candidate(candidate_id: String) -> Dictionary:
	return candidates.get(candidate_id, {}).duplicate(true)


func is_runtime_published(candidate_id: String) -> bool:
	return runtime_published.has(candidate_id)
