extends Node
class_name Stateful

func get_unstable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	
	for child in component.get_children():
		if child.has_method("get_unstable_state"):
			child.get_unstable_state(state)
			
	return state

func set_unstable_state(new_state: Dictionary, component: Node = self) -> void:
	for child in component.get_children():
		if child.has_method("set_unstable_state"):
			child.set_unstable_state(new_state)

func update_unstable_state() -> void:
	pass


func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	for child in component.get_children():
		if child.has_method("get_stable_state"):
			child.get_stable_state(state)
	
	return state

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	for child in component.get_children():
		if child.has_method("set_stable_state"):
			child.set_stable_state(new_state)

func update_stable_state() -> void:
	pass


func is_authoritative() -> bool:
	return false
