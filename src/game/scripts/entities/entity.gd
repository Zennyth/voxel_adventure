extends Node
class_name Entity

####
## Signals
####
signal destroyed(entity_id: int)


####
## BUILT-IN
####

var id: int = 0

# Constructor in godot can't take parameters -> custom constructor init
func init(entity_id: int) -> void:
	id = entity_id
	name = str(id)
	
	for component in get_children():
		if component.has_method("init"):
			component.init(self)


func get_unstable_state(component: Node = self, state: Dictionary = { 'id': id }) -> Dictionary:
	for child in component.get_children():
		if child.has_method("get_unstable_state"):
			child.get_unstable_state(state)
		
		get_unstable_state(child, state)
			
	return state

func set_unstable_state(new_state: Dictionary, component: Node = self) -> void:
	for child in component.get_children():
		if child.has_method("set_unstable_state"):
			child.set_unstable_state(new_state)
		
		set_unstable_state(new_state, child)


func get_stable_state(component: Node = self, state: Dictionary = { 'id': id }) -> Dictionary:
	for child in component.get_children():
		if child.has_method("get_stable_state"):
			child.get_stable_state(state)
		
		get_stable_state(child, state)
			
	return state

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	for child in component.get_children():
		if child.has_method("set_unstable_state"):
			child.set_unstable_state(new_state)
		
		set_unstable_state(new_state, child)
