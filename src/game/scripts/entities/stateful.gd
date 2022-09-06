extends Node
class_name Stateful

signal _entity_initialized


func entity_ready() -> void:
	for component in get_children():
		if component.has_method("entity_ready"):
			component.entity_ready()


func register_property(_property: Property) -> bool:
	return false

func new_property(property, key, is_stable: bool = true, options: Dictionary = {}) -> Property:
	return NewProperty.new(property, key, self, is_stable, options)

func bind_property(path_value: String, key, is_stable: bool = true, options: Dictionary = {}) -> Property:
	return BindedProperty.new(path_value, key, self, is_stable, options)


func update_unstable_state() -> void:
	pass

func update_stable_state() -> void:
	pass


func is_authoritative() -> bool:
	return false

func get_owner() -> int:
	return -1