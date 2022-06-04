extends ConnectionStrategy
class_name ClientConnectionStrategy

###
# OVERRIDE
###

func _physics_process(delta):
	clock_synchronizer._physics_process(delta)

func init_connection(network: Network, args: Dictionary):
	super.init_connection(network, args)
	
	args['ip'] = ip
	network.create_client(args)
	
	_network.connection_failed.connect(_connection_failed)
	_network.connection_succeeded.connect(_connection_succeeded)

	world_state_buffer = WorldStateBuffer.new()
	world_state_buffer.init(get_node("/root/World/EntityManager") as EntityManager, clock_synchronizer)
	add_child(world_state_buffer)

func _connection_failed() -> void:
	print("Failed to connect")

func _connection_succeeded() -> void:
	print("Succefully connected")
	is_connected = true
	
	init_sync_clock()
	spawn_player()
	
	
###
# BUILT-IN
###
var ip = "127.0.0.1"
var is_connected = false
var world_state_buffer: WorldStateBuffer

###
# BUILT-IN
# Entities and WorldState
###
func update_entity_unreliable_state(entity_state: Dictionary):
	entity_state['t'] = clock_synchronizer.client_clock
	_network.send(Destination.SERVER, Channel.UPDATE_ENTITY_UNRELIABLE_STATE, entity_state)
func _update_entity_unreliable_state(world_state: Dictionary):	
	world_state_buffer.update_world_state_buffer(world_state)

###
# BUILT-IN
# Clock synchro
###
const ClockSynchronizer = preload("res://scripts/multiplayer/connection_strategies/client/clock_synchronizer.gd")
var clock_synchronizer := ClockSynchronizer.new()

func send_clock_synchronization_request(request: String):
	_network.send(Destination.SERVER, Channel.CLOCK_SYNCHRONIZATION, {
		'request': request, 
		'client': get_clock_unit()
	})
func fetch_server_time() -> void:
	send_clock_synchronization_request('server_time')

func determine_local_latency() -> void:
	send_clock_synchronization_request('determine_latency')

func init_sync_clock():
	fetch_server_time()
	var determine_local_latency_job = Timer.new()
	determine_local_latency_job.wait_time = .5
	determine_local_latency_job.autostart = true
	determine_local_latency_job.connect("timeout", determine_local_latency)
	add_child(determine_local_latency_job)

func _clock_synchronization(data: Dictionary):
	match data['request']:
		'server_time':
			clock_synchronizer.calc_client_clock(data['server'], data['client'])
		'determine_latency':
			clock_synchronizer.determine_latency(data['client'])
		_:
			print("[CLIENT] wrong request: ", data['request'])
