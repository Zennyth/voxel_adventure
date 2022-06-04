extends Node
class_name Network

###
# SIGNALS DEFINITION
###
signal _update_entity_unreliable_state
signal _update_entity_reliable_state
signal _clock_synchronization


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
