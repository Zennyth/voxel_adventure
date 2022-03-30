extends Node3D
class_name Entity

####
## Signals
####
signal destroyed(entity_id: int)


####
## Init
####

var state: Dictionary = {}
var properties: Dictionary = {}
var id: int = 0

# Constructor in godot can't take parameters -> custom constructor init
func init(entity_id: int, initial_position: Vector3) -> void:
	set_id(entity_id)
	set_position(initial_position)


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

func set_id(entity_id: int):
	name = str(entity_id)
	id = entity_id


####
## Network
####

# states are defined as Dictionary from the server as we can't send custom data via rpc
func set_state(new_state: Dictionary) -> void:
	set_position(new_state["P"])
	rotation = new_state["R"]
	
	state = new_state

func get_state() -> Dictionary:
	state["T"] = Server.client_clock
	state["P"] = position
	state["R"] = rotation
	return state


func set_properties(new_properties: Dictionary) -> void:
	for key in new_properties.keys():
		properties[key] = new_properties[key]
		
		match key:
			"id":
				set_id(properties[key])
			"R":
				set_rotation(properties[key])
			"P":
				set_position(properties[key])

func get_properties() -> Dictionary:
	return properties
