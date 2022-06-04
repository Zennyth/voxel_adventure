extends Node3D
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
	
	if not Multiplayer.is_entity_authoritative(id):
		$CharacterBody3D/VoxelViewer.process_mode = Node.PROCESS_MODE_DISABLED

func get_unreliable_state() -> Dictionary:
	var state := { 'id': id }
	
	for component in get_children():
		if component.has_method("get_unreliable_state"):
			component.get_unreliable_state(state)
			
	return state

func set_unreliable_state(new_state: Dictionary) -> void:
	for component in get_children():
		if component.has_method("set_unreliable_state"):
			component.set_unreliable_state(new_state)
