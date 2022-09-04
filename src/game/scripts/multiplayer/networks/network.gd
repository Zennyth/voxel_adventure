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
# SIGNALS RESPONSES
###
func connection_succeeded():
	_connection_succeeded.emit()
func connection_failed():
	_connection_failed.emit()
func peer_connected(peer_id: int) -> void:
	_peer_connected.emit(peer_id)
func peer_disconnected(peer_id: int) -> void:
	_peer_disconnected.emit(peer_id)


###
# BUILT-IN
###
var network: MultiplayerPeer

func _init():
	pass

func create_client(_args: Dictionary):
	multiplayer.set_multiplayer_peer(network)
	
	network.connection_succeeded.connect(connection_succeeded)
	network.connection_failed.connect(connection_failed)

func create_server(_args: Dictionary):
	multiplayer.set_multiplayer_peer(network)
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

func send(destination: int, channel: String, data):
	rpc_id(destination, channel, data)

func get_sender_id() -> int:
	return multiplayer.get_remote_sender_id()

func get_id() -> int:
	return multiplayer.get_unique_id()


###
# BUILT-IN
# Global
###
@rpc(any_peer)
func global_requests(data: Dictionary):
	_global_requests.emit(data)


###
# BUILT-IN
# State
###
@rpc(any_peer, unreliable)
func update_entity_unstable_state(data: Dictionary):
	_update_entity_unstable_state.emit(data)

@rpc(any_peer)
func update_entity_stable_state(data: Dictionary):
	_update_entity_stable_state.emit(data)

@rpc(any_peer)
func update_world_stable_state(data: Dictionary):
	_update_world_stable_state.emit(data)

###
# BUILT-IN
# Clock synchro
###
@rpc(any_peer)
func clock_synchronization(data: Dictionary):
	_clock_synchronization.emit(data)


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
