extends Node3D

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 1909
var is_connected = false

var decimal_collector: float = 0
var latency_array = []
var latency = 0
var delta_latency = 0
var client_clock = 0

func _physics_process(delta: float) -> void:
	client_clock += int(delta * 1000) + delta_latency
	delta_latency = 0
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00


func _ready() -> void:
	connect_to_server()

func connect_to_server() -> void:
	network.create_client(ip, port)
	get_tree().multiplayer.multiplayer_peer = network
	
	network.connection_failed.connect(_connection_failed)
	network.connection_succeeded.connect(_connection_succeeded)

func _connection_failed() -> void:
	print("Failed to connect")

func _connection_succeeded() -> void:
	print("Succefully connected")
	start_sync_clock()
	
	var entities_manager: EntitiesManager = get_node("../Main")._entities.get_entities_manager("players")
	var player = entities_manager.get_entity(multiplayer.get_unique_id())
	send_player_properties(player.get_properties())
	is_connected = true


### Clock synchro
func start_sync_clock() -> void:
	rpc_id(1, "fetch_server_time", Time.get_ticks_msec())
	var timer = Timer.new()
	timer.wait_time = .5
	timer.autostart = true
	timer.connect("timeout", determine_local_latency)
	self.add_child(timer)
@rpc
func fetch_server_time(_client_time: int) -> void:
	pass

func determine_local_latency() -> void:
	rpc_id(1, "determine_latency", Time.get_ticks_msec())
@rpc
func determine_latency(_client_time: int) -> void:
	pass

@rpc
func return_server_time(server_time: int, client_time: int) -> void:
	latency = (Time.get_ticks_msec() - client_time) / 2
	client_clock = server_time + latency

@rpc
func return_latency(client_time: int) -> void:
	latency_array.append((Time.get_ticks_msec() - client_time) / 2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		for i in range(latency_array.size() - 1, -1, -1):
			if latency_array[i] > (2 * mid_point) and latency_array[i] > 20:
				latency_array.remove_at(i)
			else:
				total_latency += latency_array[i]
		delta_latency = ( total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
#		print("latency: " + str(latency))
#		print("delta_latency: " + str(delta_latency))
		latency_array.clear()


### Game events
@rpc
func despawn_player(player_id: int) -> void:
	get_node("../Main").despawn_player(player_id)

func send_player_state(player_state: Dictionary) -> void:
	if is_connected: rpc_id(1, "receive_player_state", player_state)
# declare this function for the client to know how to call (any_peer, unreliable)
@rpc(any_peer, unreliable)
func receive_player_state(_player_state: Dictionary) -> void:
	pass

### Properties
@rpc
func sync_world_properties(world_properties: Dictionary):
	get_node("../Main").sync_world_properties(world_properties)

func send_player_properties(player_properties: Dictionary):
	print(player_properties)
	rpc_id(1, "receive_player_properties", player_properties)
@rpc(any_peer)
func receive_player_properties(_player_properties: Dictionary):
	pass

@rpc
func receive_entity_properties(entity_id: int, entity_type: String, entity_properties: Dictionary):
	var entities_manager: EntitiesManager = get_node("../Main")._entities.get_entities_manager(entity_type)
	entities_manager.update_or_spawn_entity_with_properties(entity_id, entity_properties)

@rpc(unreliable)
func receive_world_state(world_state: Dictionary) -> void:
	get_node("../Main").update_world_state(world_state)
	# print("world state clock: " + str(world_state["T"]) + ", client clock: " + str(client_clock))
	

func send_fireball(direction: Vector3) -> void:
	rpc_id(1, "receive_fireball", direction, client_clock)
@rpc(any_peer)
func receive_fireball(_direction: Vector3, _client_clock: int) -> void:
	pass

# TODO: change to entity_id
@rpc
func sync_fireball(direction: Vector3, player_id: int, spawn_time: int) -> void:
	if player_id != get_tree().multiplayer.get_unique_id():
		get_node("../Main").sync_fireball(direction, player_id, spawn_time)



### Map events

@rpc
func sync_chunk(data_array: PackedByteArray, size: int, voxels_position: Vector3i) -> void:
	get_node("../Main").sync_chunk(data_array, size, voxels_position)
