extends Node
class_name Network

###
# SIGNALS DEFINITION
###
signal _connection_failed
signal _connection_succeeded
signal _peer_connected
signal _peer_disconnected

signal _update_entity_unstable_state
signal _update_entity_stable_state
signal _update_world_stable_state
signal _clock_synchronization

signal _global_requests


###
# BUILT-IN
###
func create_client(_args: Dictionary):
	pass

func create_server(_args: Dictionary):
	pass

func send(_destination: int, _channel: String, _data):
	pass

func get_sender_id() -> int:
	return 0

func get_id() -> int:
	return 0


###
# STATIC
###
enum Destination {
	ALL = 0,
	SERVER = 1
}

const Channel = {
	CLOCK_SYNCHRONIZATION = "clock_synchronization",
	UPDATE_ENTITY_UNSTABLE_STATE = "update_entity_unstable_state",
	UPDATE_ENTITY_STABLE_STATE = "update_entity_stable_state",
	UPDATE_WORLD_STABLE_STATE = "update_world_stable_state",
	GLOBAL_REQUESTS = "global_requests",
}