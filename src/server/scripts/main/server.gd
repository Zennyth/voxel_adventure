extends Node

var network = ENetMultiplayerPeer.new()
var port = 1909
var max_players = 100

@onready var _entities = $Entities

func _ready() -> void:
	start_server()

func start_server() -> void:
	network.create_server(port, max_players)
	# get_tree().set_network_peer(network)
	get_tree().multiplayer.multiplayer_peer = network
	print("[Server] start")
	
	network.peer_connected.connect(_peer_connected)
	network.peer_disconnected.connect(_peer_disconnected)

func _peer_connected(player_id: int) -> void:
	print("User " + str(player_id) + " is connected !")
	
	await get_tree().create_timer(.3).timeout
	rpc_id(player_id, "sync_world_properties", _entities.get_world_properties())

func _peer_disconnected(player_id: int) -> void:
	print("User " + str(player_id) + " is disconnected !")
	_entities._players.despawn_player(player_id)
	rpc_id(0, "despawn_player", player_id)
@rpc
func despawn_player(_player_id: int) -> void:
	pass


### Clock synchro

@rpc(any_peer)
func fetch_server_time(client_time: int) -> void:
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	rpc_id(player_id, "return_server_time", Time.get_ticks_msec(), client_time)
@rpc
func return_server_time(_server_time: int, _client_time: int) -> void:
	pass
	

@rpc(any_peer)
func determine_latency(client_time: int) -> void:
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	rpc_id(player_id, "return_latency", client_time)
@rpc
func return_latency(_client_time: int) -> void:
	pass

### Game events

@rpc(any_peer, unreliable)
func receive_player_state(player_state: Dictionary) -> void:
	var player_id: int = get_tree().multiplayer.get_remote_sender_id()
	_entities._players.receive_player_state(player_id, player_state)
		
func send_world_state(world_state: Dictionary) -> void:
	rpc_id(0, "receive_world_state", world_state)

# declare this function for the server to know how to call (unreliable)
@rpc(unreliable)
func receive_world_state(_world_state: Dictionary):
	pass

### Properties
@rpc
func sync_world_properties(_world_properties: Dictionary):
	pass

@rpc(any_peer)
func receive_player_properties(player_properties: Dictionary) -> void:
	var player_id: int = get_tree().multiplayer.get_remote_sender_id()
	_entities._players.receive_player_properties(player_id, player_properties)
	send_entity_properties(player_id, "players", player_properties)

func send_entity_properties(entity_id: int, entity_type: String, entity_properties: Dictionary) -> void:
	print(entity_id, entity_type, entity_properties)
	rpc_id(0, "receive_entity_properties", entity_id, entity_type, entity_properties)
@rpc
func receive_entity_properties(_entity_id: int, _entity_type: String, _entity_properties: Dictionary):
	pass
### Fireball

@rpc(any_peer)
func receive_fireball(direction: Vector3, client_clock: int) -> void:
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	var player: Character = _entities._players.get_entity(player_id)
	if player:
		player._spells_manager.cast_fireball(direction)
	rpc_id(0, "sync_fireball", direction, player_id, client_clock)
@rpc
func sync_fireball(_direction: Vector3, _player_id: int, _spawn_time: int) -> void:
	pass
	

### Map events

func send_chunk(player_id: int, buffer: StreamPeerBuffer, size: int, voxels_position: Vector3i) -> void:
	if _entities._players.has_entity(player_id):
		rpc_id(player_id, "sync_chunk", buffer.data_array, size, voxels_position)
@rpc
func sync_chunk(_data_array: PackedByteArray, _size: int, _voxels_position: Vector3i) -> void:
	pass
