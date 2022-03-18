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
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()

	if player_state_collection.has(player_id):
		player_state_collection.erase(player_id)


### Clock syncho

@rpc(any_peer)
func fetch_server_time(client_time):
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	rpc_id(player_id, "return_server_time", Time.get_ticks_msec(), client_time)
@rpc
func return_server_time(server_time, client_time):
	pass
	

@rpc(any_peer)
func determine_latency(client_time):
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	rpc_id(player_id, "return_latency", client_time)
@rpc
func return_latency(client_time):
	pass

### Game events

@rpc(any_peer, unreliable)
func receive_player_state(player_state):
	var player_id = get_tree().multiplayer.get_remote_sender_id()
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state
	else:
		player_state_collection[player_id] = player_state
		
func send_world_state(world_state):
	rpc_id(0, "receive_world_state", world_state)

# declare this function for the serevr to know how to call (unreliable)
@rpc(unreliable)
func receive_world_state(world_state):
	pass
