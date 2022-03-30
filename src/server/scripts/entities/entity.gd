extends Node3D
class_name Entity


####
## Signals
####
signal destroyed(entity_id: int)


####
## Init
####

# Dynamic state that changes several times a second and have priority over properties
var state: Dictionary = {}
# Semi-Static properties that don't change often
var properties: Dictionary = {}

var id: int = 0

# Constructor in godot can't take parameters -> custom constructor init
func init(entity_id: int, initial_position: Vector3) -> void:
	name = str(entity_id)
	id = entity_id
	set_position(initial_position)
	
func init_with_properties(entity_id: int, new_properties: Dictionary) -> void:
	name = str(entity_id)
	id = entity_id
	set_properties(new_properties)


####
## Main
####

func get_position() -> Vector3:
	return position

func set_position(new_position: Vector3) -> void:
	position = new_position

func get_rotation() -> Vector3:
	return rotation

func set_rotation(new_rotation: Vector3) -> void:
	rotation = new_rotation


####
## Network
####

# states are defined as Dictionary from the server as we can't send custom data via rpc
func set_state(new_state: Dictionary) -> void:
	set_position(new_state["P"])
	rotation = new_state["R"]
	
	state = new_state

func get_state() -> Dictionary:
	state["P"] = position
	state["R"] = rotation
	return state


func set_properties(updated_properties: Dictionary) -> void:
	for key in updated_properties.keys():
		properties[key] = updated_properties[key]

func get_properties() -> Dictionary:
	return properties

func update_properties() -> void:
	get_node("/root/Server").send_entity_properties(id, get_parent().type, get_properties())
