extends Node3D

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 1909

var decimal_collector: float = 0
var latency_array = []
var latency = 0
var delta_latency = 0
var client_clock = 0

func _physics_process(delta):
	client_clock += int(delta * 1000) + delta_latency
	delta_latency = 0
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00


func _ready():
	connect_to_server()

func connect_to_server():
	network.create_client(ip, port)
	get_tree().multiplayer.multiplayer_peer = network
	
	network.connection_failed.connect(_connection_failed)
	network.connection_succeeded.connect(_connection_succeeded)

func _connection_failed():
	print("Failed to connect")

func _connection_succeeded():
	print("Succefully connected")
	start_sync_clock()



### Clock synchro
func start_sync_clock():
	rpc_id(1, "fetch_server_time", Time.get_ticks_msec())
	var timer = Timer.new()
	timer.wait_time = .5
	timer.autostart = true
	timer.connect("timeout", determine_local_latency)
	self.add_child(timer)
@rpc
func fetch_server_time(_client_time):
	pass

func determine_local_latency():
	rpc_id(1, "determine_latency", Time.get_ticks_msec())
@rpc
func determine_latency(_client_time):
	pass

@rpc
func return_server_time(server_time, client_time):
	latency = (Time.get_ticks_msec() - client_time) / 2
	client_clock = server_time + latency

@rpc
func return_latency(client_time):
	latency_array.append((Time.get_ticks_msec() - client_time) / 2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size() - 1, -1, -1):
			if latency_array[i] > (2 * mid_point):
				latency_array.remove_at(i)
			else:
				total_latency += latency_array[i]
		delta_latency = ( total_latency / latency_array.size())
		latency = total_latency * latency_array.size()
		# print("latency: " + str(latency))
		# print("delta_latency: " + str(delta_latency))
		latency_array.clear()


### Game events

func send_player_state(player_state):
	rpc_id(1, "receive_player_state", player_state)

# declare this function for the client to know how to call (any_peer, unreliable)
@rpc(any_peer, unreliable)
func receive_player_state(_player_state):
	pass

@rpc(unreliable)
func receive_world_state(world_state):
	get_node("../main").update_world_state(world_state)
	# print("world state clock: " + str(world_state["T"]) + ", client clock: " + str(client_clock))
	

func send_fireball(direction: Vector3):
	print(direction)
	rpc_id(1, "receive_fireball", direction)
@rpc(any_peer)
func receive_fireball(_direction):
	pass

@rpc
func sync_fireball(direction, player_id):
	get_node("../main").sync_fireball(direction, player_id)



### Map events

@rpc
func sync_chunk(buffer: StreamPeerBuffer, size: int, voxels_position: Vector3i):
	get_node("../main").sync_chunk(buffer, size, voxels_position)
