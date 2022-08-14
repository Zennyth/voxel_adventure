extends Node
class_name Stateful


func entity_ready() -> void:
	pass


func register_property(_property: Property) -> void:
	pass

func new_property(property, key: String, is_stable: bool = true, options: Dictionary = {}) -> Property:
	return NewProperty.new(property, key, self, is_stable, options)

func bind_property(owner_value: Object, key_value: String, key: String, is_stable: bool = true, options: Dictionary = {}) -> Property:
	return BindedProperty.new(owner_value, key_value, key, self, is_stable, options)


func update_unstable_state() -> void:
	pass

func update_stable_state() -> void:
	pass


func is_authoritative() -> bool:
	return false
