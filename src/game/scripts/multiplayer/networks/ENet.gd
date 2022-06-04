extends Network
class_name ENet

###
# SIGNALS DEFINITION
###
signal connection_failed
signal connection_succeeded
signal peer_connected
signal peer_disconnected


###
# SIGNALS RESPONSES
###
func _connection_succeeded():
	connection_succeeded.emit()
func _connection_failed():
	connection_failed.emit()
func _peer_connected(peer_id: int) -> void:
	peer_connected.emit(peer_id)
func _peer_disconnected(peer_id: int) -> void:
	peer_disconnected.emit(peer_id)


###
# OVERRIDE
###

func create_client(args: Dictionary):
	network.create_client(args['ip'], args['port'])
	multiplayer.set_multiplayer_peer(network)
	
	network.connection_succeeded.connect(_connection_succeeded)
	network.connection_failed.connect(_connection_failed)

func create_server(args: Dictionary):
	network.create_server(args['port'], args['MAX_PLAYERS'])
	multiplayer.set_multiplayer_peer(network)
	
	network.peer_connected.connect(_peer_connected)
	network.peer_disconnected.connect(_peer_disconnected)

func send(destination: int, channel: String, data):
	rpc_id(destination, channel, data)

func send_update(destination: int, state: Dictionary):
	send(destination, "receive_update", state)

func get_sender_id() -> int:
	return multiplayer.get_remote_sender_id()

func get_id() -> int:
	return multiplayer.get_unique_id()


###
# BUILT-IN
###

var network := ENetMultiplayerPeer.new()

###
# BUILT-IN
# State
###
@rpc(any_peer)
func update_entity_unreliable_state(data: Dictionary):
	_update_entity_unreliable_state.emit(data)

###
# BUILT-IN
# Clock synchro
###
@rpc(any_peer)
func clock_synchronization(data: Dictionary):
	_clock_synchronization.emit(data)
