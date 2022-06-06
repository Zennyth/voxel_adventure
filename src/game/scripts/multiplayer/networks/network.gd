extends Node
class_name Network

###
# SIGNALS DEFINITION
###
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
