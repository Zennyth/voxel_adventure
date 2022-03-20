extends Node

var network = ENetMultiplayerPeer.new()
var port = 1909
var max_players = 100

var player_state_collection = {}

func _ready():
	start_server()
	

func start_server():
	network.create_server(port, max_players)
	# get_tree().set_network_peer(network)
	get_tree().multiplayer.multiplayer_peer = network
	print("[Server] start")
	
	network.peer_connected.connect(_peer_connected)
	network.peer_disconnected.connect(_peer_disconnected)

func _peer_connected(player_id):
	print("User " + str(player_id) + " is connected !")
	# rpc_id(0, "spawn_player", player_id, Vector3(0, 64, 0))

func _peer_disconnected(player_id):
	print("User " + str(player_id) + " is disconnected !")
	
	get_node("players").despawn_player(player_id)

	if player_state_collection.has(player_id):
		player_state_collection.erase(player_id)


### Clock syncho

@rpc(any_peer)
func fetch_server_time(client_time):
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	rpc_id(player_id, "return_server_time", Time.get_ticks_msec(), client_time)
@rpc
func return_server_time(_server_time, _client_time):
	pass
	

@rpc(any_peer)
func determine_latency(client_time):
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	rpc_id(player_id, "return_latency", client_time)
@rpc
func return_latency(_client_time):
	pass

### Game events

@rpc(any_peer, unreliable)
func receive_player_state(player_state):
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state
	else:
		# new player has connect
		player_state_collection[player_id] = player_state
		get_node("players").spawn_player(player_id, player_state)
		
func send_world_state(world_state):
	rpc_id(0, "receive_world_state", world_state)
	
	for player_id in world_state["players"].keys():
		get_node("players").update_player(player_id, world_state["players"][player_id])

# declare this function for the serevr to know how to call (unreliable)
@rpc(unreliable)
func receive_world_state(_world_state):
	pass
	
@rpc(any_peer)
func receive_fireball(direction):
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	rpc_id(0, "sync_fireball", direction, player_id)
@rpc
func sync_fireball(_direction, _player_id):
	pass
	

### Map events

func send_chunk(player_id: int, buffer: StreamPeerBuffer, size: int, voxels_position: Vector3i):
	if player_state_collection.has(player_id):
		rpc_id(player_id, "sync_chunk", buffer.data_array, size, voxels_position)
@rpc
func sync_chunk(_data_array: PackedByteArray, _size: int, _voxels_position: Vector3i):
	pass
