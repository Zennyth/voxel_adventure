extends ConnectionStrategy
class_name ClientConnectionStrategy

func _ready():
	super._ready()
	add_child(clock_synchronizer)

###
# OVERRIDE
###
func init_connection(network: Network, args: Dictionary):
	super.init_connection(network, args)
	
	args['ip'] = ip
	network.create_client(args)
	
	_network.connection_failed.connect(_connection_failed)
	_network.connection_succeeded.connect(_connection_succeeded)

	unstable_world_state_buffer = UnstableWorldStateBuffer.new()
	unstable_world_state_buffer.init(entity_manager, clock_synchronizer)
	add_child(unstable_world_state_buffer)

	stable_world_state_buffer = StableWorldStateBuffer.new()
	stable_world_state_buffer.init(entity_manager, clock_synchronizer)
	add_child(stable_world_state_buffer)

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return _network.get_id() == entity_state[WorldState.STATE_KEYS.ID]


func _connection_failed() -> void:
	print("Failed to connect")

func _connection_succeeded() -> void:
	print("Succefully connected")
	is_connected = true
	
	init_sync_clock()
	request_world_stable_state()
	
	
###
# BUILT-IN
###
var ip = "127.0.0.1"
var is_connected = false


###
# BUILT-IN
# Global requests
###
func _global_requests(data: Dictionary):
	match data['request']:
		'world_stable_state':
			stable_world_state_buffer.update_world_state_buffer(data['state'])
			spawn_player()
		_:
			print("[CLIENT] wrong global request: ", data['request'])
func global_requests(data: Dictionary):
	_network.send(Destination.SERVER, Channel.GLOBAL_REQUESTS, data)

func request_world_stable_state():
	global_requests({
		'request': 'world_stable_state'
	})

###
# BUILT-IN
# Entities and WorldState
###

var unstable_world_state_buffer: UnstableWorldStateBuffer

func update_entity_unstable_state(entity_state: Dictionary):
	entity_state[WorldState.STATE_KEYS.TIME] = clock_synchronizer.client_clock
	_network.send(Destination.SERVER, Channel.UPDATE_ENTITY_UNSTABLE_STATE, entity_state)
	
func _update_entity_unstable_state(world_state: Dictionary):	
	unstable_world_state_buffer.update_world_state_buffer(world_state)


var stable_world_state_buffer: StableWorldStateBuffer

func update_entity_stable_state(entity_state: Dictionary):
	entity_state[WorldState.STATE_KEYS.TIME] = clock_synchronizer.client_clock
	_network.send(Destination.SERVER, Channel.UPDATE_ENTITY_STABLE_STATE, entity_state)

func _update_entity_stable_state(entity_state: Dictionary):	
	stable_world_state_buffer.update_entity_stable_state(entity_state[WorldState.STATE_KEYS.ID], entity_state)
	
func _update_world_stable_state(world_state: Dictionary):	
	stable_world_state_buffer.update_world_state_buffer(world_state)

###
# BUILT-IN
# Clock synchro
###
const ClientClockSynchronizer = preload("res://scripts/multiplayer/connection_strategies/client/client_clock_synchronizer.gd")
var clock_synchronizer := ClientClockSynchronizer.new()

func send_clock_synchronization_request(request: String):
	_network.send(Destination.SERVER, Channel.CLOCK_SYNCHRONIZATION, {
		'request': request, 
		'client': clock_synchronizer.get_unit()
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
