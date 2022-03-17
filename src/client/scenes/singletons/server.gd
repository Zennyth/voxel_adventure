extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909


func _ready():
	connect_to_server()

func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_connection_failed")
	network.connect("connection_succeeded", self, "_connection_succeeded")

func _connection_failed():
	print("Failed to connect")

func _connection_succeeded():
	print("Succefully connected")


#remote func spawn_player(player_id, spawn_position):
#	get_node("../Main").spawn_player(player_id, spawn_position)
#
#remote func despawn_player(player_id):
#	get_node("../Main").despawn_player(player_id)
	
	
func send_player_state(player_state):
	rpc_unreliable_id(1, "receive_player_state", player_state)
	
remote func receive_world_state(world_state):
	get_node("../Main").update_world_state(world_state)
