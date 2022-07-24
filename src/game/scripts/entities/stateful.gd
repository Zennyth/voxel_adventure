extends Node
class_name Stateful

func entity_ready() -> void:
	pass

func register_property(_property: SyncProperty) -> void:
	return null

func get_property(key: String, is_stable: bool) -> SyncProperty:
	return null

func create_property(property, key_: String, parse_function_ = null, dump_function_ = null, is_stable_: bool = true) -> SyncProperty:
	var prop = get_property(key_, is_stable_)
	
	if prop == null:
		prop = SyncProperty.new(property, key_, self, parse_function_, dump_function_, is_stable_)
	
	return prop

func update_unstable_state() -> void:
	pass

func update_stable_state() -> void:
	pass


func is_authoritative() -> bool:
	return false
