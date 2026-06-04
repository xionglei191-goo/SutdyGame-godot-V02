extends RefCounted
class_name CloudSaveAdapter

const AccountAdapterScript := preload("res://scripts/systems/account_adapter.gd")

const DEVICE_A := "device_a"
const DEVICE_B := "device_b"

var account_adapter := AccountAdapterScript.new()
var logical_clock: int = 0
var cloud_revision: int = 0
var cloud_slot: Dictionary = {}
var device_slots: Dictionary = {}


func _init() -> void:
	reset_for_test()


func is_stub() -> bool:
	return true


func network_enabled() -> bool:
	return false


func reset_for_test() -> void:
	logical_clock = 0
	cloud_revision = 0
	cloud_slot = {}
	device_slots = {}
	_ensure_device(DEVICE_A)
	_ensure_device(DEVICE_B)


func register_device(device_id: String) -> Dictionary:
	_ensure_device(device_id)
	return _result({
		"ok": true,
		"device_id": device_id,
		"registered": true,
	})


func set_device_online(device_id: String, online: bool) -> Dictionary:
	var slot := _ensure_device(device_id)
	slot["online"] = online
	return _result({
		"ok": true,
		"device_id": device_id,
		"online": online,
	})


func capture_from_save_service(device_id: String, save_service) -> Dictionary:
	var slot := _ensure_device(device_id)
	logical_clock += 1
	slot["snapshot"] = _normalized_snapshot(save_service.load_all())
	slot["dirty"] = true
	slot["local_updated_at"] = logical_clock
	slot["account_id"] = account_adapter.get_local_guest_id(save_service)
	return _result({
		"ok": true,
		"device_id": device_id,
		"dirty": true,
		"local_updated_at": slot.get("local_updated_at", 0),
		"account_id": slot.get("account_id", ""),
	})


func restore_to_save_service(device_id: String, save_service) -> Dictionary:
	var slot := _ensure_device(device_id)
	if not slot.get("snapshot") is Dictionary:
		return _result({
			"ok": false,
			"reason": "no_device_snapshot",
			"device_id": device_id,
		})
	var snapshot: Dictionary = slot["snapshot"]
	return _result({
		"ok": save_service.save_all(
			snapshot.get("profile", {}),
			snapshot.get("game_state", {}),
			snapshot.get("learning_record", {})
		),
		"device_id": device_id,
		"restored": true,
	})


func sync_device(device_id: String) -> Dictionary:
	var slot := _ensure_device(device_id)
	if not bool(slot.get("online", true)):
		slot["pending_offline_sync"] = true
		return _result({
			"ok": true,
			"device_id": device_id,
			"status": "queued_offline",
			"pending_offline_sync": true,
		})

	if not slot.get("snapshot") is Dictionary:
		if cloud_slot.get("snapshot") is Dictionary:
			slot["snapshot"] = cloud_slot["snapshot"].duplicate(true)
			slot["base_cloud_revision"] = cloud_revision
			slot["dirty"] = false
			slot["pending_offline_sync"] = false
			return _result({
				"ok": true,
				"device_id": device_id,
				"status": "downloaded",
				"cloud_revision": cloud_revision,
			})
		return _result({
			"ok": false,
			"device_id": device_id,
			"reason": "no_local_or_cloud_snapshot",
		})

	if cloud_slot.is_empty():
		_publish_to_local_cloud(slot)
		return _result({
			"ok": true,
			"device_id": device_id,
			"status": "local_mirror_created",
			"cloud_revision": cloud_revision,
			"local_mirror_updated": true,
		})

	if not bool(slot.get("dirty", false)):
		slot["snapshot"] = cloud_slot.get("snapshot", {}).duplicate(true)
		slot["base_cloud_revision"] = cloud_revision
		slot["pending_offline_sync"] = false
		return _result({
			"ok": true,
			"device_id": device_id,
			"status": "downloaded",
			"cloud_revision": cloud_revision,
		})

	if int(slot.get("base_cloud_revision", 0)) == cloud_revision:
		_publish_to_local_cloud(slot)
		return _result({
			"ok": true,
			"device_id": device_id,
			"status": "last_write_saved",
			"cloud_revision": cloud_revision,
			"local_mirror_updated": true,
		})

	return _resolve_conflict(device_id, slot)


func get_cloud_snapshot() -> Dictionary:
	return cloud_slot.duplicate(true)


func get_device_snapshot(device_id: String) -> Dictionary:
	return _ensure_device(device_id).duplicate(true)


func get_conflict_copies(device_id: String) -> Array:
	return _ensure_device(device_id).get("conflict_copies", []).duplicate(true)


func _resolve_conflict(device_id: String, slot: Dictionary) -> Dictionary:
	var conflict_copy := {
		"device_id": device_id,
		"local_updated_at": int(slot.get("local_updated_at", 0)),
		"base_cloud_revision": int(slot.get("base_cloud_revision", 0)),
		"cloud_revision": cloud_revision,
		"snapshot": slot.get("snapshot", {}).duplicate(true),
	}
	slot["conflict_copies"].append(conflict_copy)

	if int(slot.get("local_updated_at", 0)) > int(cloud_slot.get("updated_at", 0)):
		_publish_to_local_cloud(slot)
		return _result({
			"ok": true,
			"device_id": device_id,
			"status": "conflict_last_write_saved",
			"conflict_copy_created": true,
			"cloud_revision": cloud_revision,
			"local_mirror_updated": true,
		})

	slot["snapshot"] = cloud_slot.get("snapshot", {}).duplicate(true)
	slot["base_cloud_revision"] = cloud_revision
	slot["dirty"] = false
	slot["pending_offline_sync"] = false
	return _result({
		"ok": true,
		"device_id": device_id,
		"status": "conflict_downloaded_latest",
		"conflict_copy_created": true,
		"cloud_revision": cloud_revision,
	})


func _publish_to_local_cloud(slot: Dictionary) -> void:
	logical_clock += 1
	cloud_revision += 1
	cloud_slot = {
		"revision": cloud_revision,
		"updated_at": logical_clock,
		"account_id": slot.get("account_id", ""),
		"snapshot": slot.get("snapshot", {}).duplicate(true),
	}
	slot["base_cloud_revision"] = cloud_revision
	slot["dirty"] = false
	slot["pending_offline_sync"] = false


func _ensure_device(device_id: String) -> Dictionary:
	if device_id.is_empty():
		device_id = DEVICE_A
	if not device_slots.has(device_id):
		device_slots[device_id] = {
			"device_id": device_id,
			"online": true,
			"dirty": false,
			"pending_offline_sync": false,
			"base_cloud_revision": 0,
			"local_updated_at": 0,
			"account_id": "",
			"snapshot": {},
			"conflict_copies": [],
		}
	return device_slots[device_id]


func _normalized_snapshot(snapshot: Dictionary) -> Dictionary:
	var normalized := {
		"profile": {},
		"game_state": {},
		"learning_record": {},
	}
	for bucket_name in normalized.keys():
		if snapshot.get(bucket_name) is Dictionary:
			normalized[bucket_name] = snapshot[bucket_name].duplicate(true)
	return normalized


func _result(values: Dictionary) -> Dictionary:
	var result := values.duplicate(true)
	result["is_stub"] = true
	result["network_used"] = false
	result["data_uploaded"] = false
	return result
