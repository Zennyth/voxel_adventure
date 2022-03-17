extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

var player_state_collection = {}


func _ready():
	start_server()
	

func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("[Server] start")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")

func _peer_connected(player_id):
	print("User " + str(player_id) + " is connected !")
	# rpc_id(0, "spawn_player", player_id, Vector3(0, 64, 0))

func _peer_disconnected(player_id):
	print("User " + str(player_id) + " is disconnected !")
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()
		player_state_collection.erase(player_id)
		# rpc_id(0, "despawn_player", player_id)


remote func receive_player_state(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state
	else:
		player_state_collection[player_id] = player_state
		
func send_world_state(world_state):
	rpc_unreliable_id(0, "receive_world_state", world_state)
