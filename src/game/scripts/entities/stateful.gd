extends Node
class_name Stateful

func entity_ready() -> void:
	pass

func register_property(_property: SyncProperty) -> void:
	return null

func get_property(key: String, is_stable: bool) -> SyncProperty:
	return null

func create_property(property, key_: String, is_stable_: bool = true, options: Dictionary = {}) -> SyncProperty:
	var prop = get_property(key_, is_stable_)
	
	if prop == null:
		prop = SyncProperty.new(property, key_, self, is_stable_, options)
		register_property(prop)
	
	if "on_changed" in options:
		prop._property_changed.connect(options["on_changed"])
	
	
	return prop

func update_unstable_state() -> void:
	pass

func update_stable_state() -> void:
	pass


func is_authoritative() -> bool:
	return false
