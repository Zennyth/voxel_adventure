extends Node3D
class_name Entity

####
## Init
####

var state: Dictionary = {}
var properties: Dictionary = {}

# Constructor in godot can't take parameters -> custom constructor init
func init(id: int, initial_position: Vector3) -> void:
	name = str(id)
	set_position(initial_position)


####
## Main
####

func get_position() -> Vector3:
	return position

func set_position(new_position: Vector3) -> void:
	position = new_position


####
## Network
####

# states are defined as Dictionary from the server as we can't send custom data via rpc
func set_state(new_state: Dictionary) -> void:
	set_position(new_state["P"])
	
	state = new_state

func get_state() -> Dictionary:
	# state["T"] = Server.client_clock
	return state


func update_properties(updated_properties: Dictionary) -> void:
	for key in updated_properties.keys():
		properties[key] = updated_properties[key]

func get_properties() -> Dictionary:
	return properties
