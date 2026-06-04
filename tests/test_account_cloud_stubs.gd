extends SceneTree

const SaveServiceScript := preload("res://scripts/systems/save_service.gd")
const AccountAdapterScript := preload("res://scripts/systems/account_adapter.gd")
const CloudSaveAdapterScript := preload("res://scripts/systems/cloud_save_adapter.gd")

var failures: Array[String] = []


func _init() -> void:
	_check_account_guest_local_id()
	_check_migration_idempotency()
	_check_old_save_compatibility()
	_check_two_device_sync_and_conflict()
	_finish()


func _check_account_guest_local_id() -> void:
	var save_service = SaveServiceScript.new("user://test_account_stub_profile.json")
	_expect(save_service.clear_for_test(), "account save should clear")
	var account_adapter = AccountAdapterScript.new()
	var profile_before: Dictionary = save_service.load_profile()
	var account: Dictionary = account_adapter.get_current_account(save_service)
	_expect(account.get("ok", false), "AccountAdapter should return current account")
	_expect(account.get("profile_id", "") == "local_profile", "AccountAdapter should preserve default local profile id")
	_expect(account.get("account_id", "") == "guest:local_profile", "AccountAdapter should expose stable guest/local id")
	_expect(bool(account.get("is_guest", false)), "AccountAdapter should mark default account as guest")
	_expect(bool(account.get("is_local_only", false)), "AccountAdapter should mark default account as local-only")
	_expect(not bool(account.get("network_used", true)), "AccountAdapter should not use network")
	_expect(not bool(account.get("data_uploaded", true)), "AccountAdapter should not upload data")
	_expect(save_service.load_profile() == profile_before, "AccountAdapter should not mutate SaveService profile")
	_expect(save_service.clear_for_test(), "account save should clean up")


func _check_migration_idempotency() -> void:
	var save_service = SaveServiceScript.new("user://test_account_stub_migration.json")
	_expect(save_service.clear_for_test(), "migration save should clear")
	_expect(save_service.reset_for_test(), "migration save should reset")
	var account_adapter = AccountAdapterScript.new()
	var profile_before: Dictionary = save_service.load_profile()
	var first: Dictionary = account_adapter.migrate_local_profile(save_service)
	var second: Dictionary = account_adapter.migrate_local_profile(save_service)
	_expect(first.get("ok", false), "first local profile migration should succeed")
	_expect(second.get("ok", false), "second local profile migration should succeed")
	_expect(first.get("account_id", "") == second.get("account_id", ""), "migration should keep the same account id")
	_expect(first.get("profile_with_account_stub", {}) == second.get("profile_with_account_stub", {}), "migration output should be idempotent")
	_expect(not bool(first.get("changed_save_service", true)), "migration should not write through SaveService")
	_expect(save_service.load_profile() == profile_before, "migration should keep old SaveService profile compatible")
	_expect(save_service.clear_for_test(), "migration save should clean up")


func _check_old_save_compatibility() -> void:
	var save_service = SaveServiceScript.new("user://test_account_cloud_old_save.json")
	_expect(save_service.clear_for_test(), "old save should clear")
	_expect(save_service.save_profile({
		"profile_id": "local_profile",
		"display_name": "Old Save Child",
	}), "old profile shape should save")
	_expect(save_service.save_game_state({
		"coins": 3,
	}), "old game_state shape should save")
	var cloud = CloudSaveAdapterScript.new()
	var capture: Dictionary = cloud.capture_from_save_service(CloudSaveAdapterScript.DEVICE_A, save_service)
	_expect(capture.get("ok", false), "CloudSaveAdapter should capture old save shape")
	var sync: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_A)
	_expect(sync.get("ok", false), "CloudSaveAdapter should sync old save shape into local mirror")
	_expect(not bool(sync.get("network_used", true)), "old save sync should not use network")
	_expect(not bool(sync.get("data_uploaded", true)), "old save sync should not upload data")
	var cloud_snapshot: Dictionary = cloud.get_cloud_snapshot().get("snapshot", {})
	_expect(int(cloud_snapshot.get("game_state", {}).get("coins", -1)) == 3, "old save coins should remain readable")
	_expect(save_service.clear_for_test(), "old save should clean up")


func _check_two_device_sync_and_conflict() -> void:
	var save_a = SaveServiceScript.new("user://test_cloud_device_a.json")
	var save_b = SaveServiceScript.new("user://test_cloud_device_b.json")
	_expect(save_a.clear_for_test(), "device A save should clear")
	_expect(save_b.clear_for_test(), "device B save should clear")
	_expect(save_a.reset_for_test(), "device A save should reset")
	_expect(save_b.reset_for_test(), "device B save should reset")
	var cloud = CloudSaveAdapterScript.new()

	_set_coins(save_a, 10)
	_expect(cloud.capture_from_save_service(CloudSaveAdapterScript.DEVICE_A, save_a).get("ok", false), "device A should capture initial save")
	var initial_sync: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_A)
	_expect(initial_sync.get("status", "") == "local_mirror_created", "device A should create local cloud mirror")

	var pull_b: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_B)
	_expect(pull_b.get("status", "") == "downloaded", "device B should download device A local mirror")
	_expect(cloud.restore_to_save_service(CloudSaveAdapterScript.DEVICE_B, save_b).get("ok", false), "device B should restore downloaded save")
	_expect(int(save_b.load_game_state().get("coins", -1)) == 10, "device B should receive device A coins")

	_expect(cloud.set_device_online(CloudSaveAdapterScript.DEVICE_B, false).get("ok", false), "device B should go offline")
	_set_coins(save_b, 12)
	_expect(cloud.capture_from_save_service(CloudSaveAdapterScript.DEVICE_B, save_b).get("ok", false), "device B offline change should capture")
	var queued: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_B)
	_expect(queued.get("status", "") == "queued_offline", "device B offline sync should queue")
	_expect(not bool(queued.get("network_used", true)), "offline sync should not use network")

	_set_coins(save_a, 20)
	_expect(cloud.capture_from_save_service(CloudSaveAdapterScript.DEVICE_A, save_a).get("ok", false), "device A later save should capture")
	var save_a_sync: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_A)
	_expect(save_a_sync.get("status", "") == "last_write_saved", "device A should last-write local mirror")
	_expect(int(cloud.get_cloud_snapshot().get("snapshot", {}).get("game_state", {}).get("coins", -1)) == 20, "device A last write should be latest cloud coins")

	_expect(cloud.set_device_online(CloudSaveAdapterScript.DEVICE_B, true).get("ok", false), "device B should come back online")
	var conflict: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_B)
	_expect(conflict.get("status", "") == "conflict_downloaded_latest", "device B should resolve stale offline edit by downloading latest")
	_expect(bool(conflict.get("conflict_copy_created", false)), "device B conflict should create local conflict copy")
	_expect(cloud.get_conflict_copies(CloudSaveAdapterScript.DEVICE_B).size() == 1, "device B should keep one conflict copy")
	_expect(int(cloud.get_conflict_copies(CloudSaveAdapterScript.DEVICE_B)[0].get("snapshot", {}).get("game_state", {}).get("coins", -1)) == 12, "conflict copy should preserve offline coins")
	_expect(cloud.restore_to_save_service(CloudSaveAdapterScript.DEVICE_B, save_b).get("ok", false), "device B should restore latest after conflict")
	_expect(int(save_b.load_game_state().get("coins", -1)) == 20, "device B should now have latest cloud coins")

	_set_coins(save_b, 30)
	_expect(cloud.capture_from_save_service(CloudSaveAdapterScript.DEVICE_B, save_b).get("ok", false), "device B final save should capture")
	var final_sync: Dictionary = cloud.sync_device(CloudSaveAdapterScript.DEVICE_B)
	_expect(final_sync.get("status", "") == "last_write_saved", "device B should last-write after conflict recovery")
	_expect(int(cloud.get_cloud_snapshot().get("snapshot", {}).get("game_state", {}).get("coins", -1)) == 30, "device B last write should become latest")
	_expect(not bool(final_sync.get("network_used", true)), "last-write sync should not use network")
	_expect(not bool(final_sync.get("data_uploaded", true)), "last-write sync should not upload data")

	_expect(save_a.clear_for_test(), "device A save should clean up")
	_expect(save_b.clear_for_test(), "device B save should clean up")


func _set_coins(save_service, coins: int) -> void:
	var game_state: Dictionary = save_service.load_game_state()
	game_state["coins"] = coins
	_expect(save_service.save_game_state(game_state), "coin setup should save: %d" % coins)


func _finish() -> void:
	if failures.is_empty():
		print("ACCOUNT AND CLOUD STUB TESTS PASSED")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
