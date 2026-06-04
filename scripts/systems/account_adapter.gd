extends RefCounted
class_name AccountAdapter

const LOCAL_PROVIDER := "local_stub"
const GUEST_ACCOUNT_PREFIX := "guest:"


func is_stub() -> bool:
	return true


func network_enabled() -> bool:
	return false


func get_current_account(save_service = null) -> Dictionary:
	var profile := _load_profile(save_service)
	var profile_id := str(profile.get("profile_id", "local_profile"))
	return {
		"ok": true,
		"account_id": _guest_account_id(profile_id),
		"profile_id": profile_id,
		"display_name": str(profile.get("display_name", "Player")),
		"provider": LOCAL_PROVIDER,
		"is_guest": true,
		"is_local_only": true,
		"is_stub": true,
		"network_used": false,
		"data_uploaded": false,
	}


func get_local_guest_id(save_service = null) -> String:
	return str(get_current_account(save_service).get("account_id", _guest_account_id("local_profile")))


func migrate_local_profile(save_service) -> Dictionary:
	var before := _load_profile(save_service)
	var account := get_current_account(save_service)
	var after := before.duplicate(true)
	after["account_stub"] = {
		"account_id": account.get("account_id", ""),
		"provider": LOCAL_PROVIDER,
		"is_guest": true,
		"is_local_only": true,
	}
	return {
		"ok": true,
		"changed_save_service": false,
		"idempotent": true,
		"profile_id": before.get("profile_id", "local_profile"),
		"account_id": account.get("account_id", ""),
		"profile_before": before,
		"profile_with_account_stub": after,
		"network_used": false,
		"data_uploaded": false,
	}


func replace_backend_stub(account_id: String) -> Dictionary:
	return {
		"ok": true,
		"account_id": account_id,
		"provider": LOCAL_PROVIDER,
		"is_stub": true,
		"can_replace_backend_later": true,
		"network_used": false,
		"data_uploaded": false,
	}


func _load_profile(save_service) -> Dictionary:
	if save_service == null:
		return {
			"profile_id": "local_profile",
			"display_name": "Player",
		}
	return save_service.load_profile()


func _guest_account_id(profile_id: String) -> String:
	if profile_id.is_empty():
		return "%slocal_profile" % GUEST_ACCOUNT_PREFIX
	return "%s%s" % [GUEST_ACCOUNT_PREFIX, profile_id]
