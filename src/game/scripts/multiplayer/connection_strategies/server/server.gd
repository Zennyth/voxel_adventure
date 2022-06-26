extends ConnectionStrategy
class_name ServerConnectionStrategy

func _ready():
	super._ready()
	add_child(clock_synchronizer)


func init_connection(network: Network, args: Dictionary):
	super.init_connection(network, args)
	
	Engine.physics_ticks_per_second = 20
	
	args['MAX_PLAYERS'] = MAX_PLAYERS
	network.create_server(args)

	stable_world_state_manager.init(entity_manager, clock_synchronizer)
	add_child(stable_world_state_manager)
	unstable_world_state_manager.init(entity_manager, clock_synchronizer)
	add_child(unstable_world_state_manager)
	
#	entity_manager.spawn_entity({
#		WorldState.STATE_KEYS.SCENE: "enemy"
#	})
	
	_network._peer_connected.connect(_peer_connected)
	_network._peer_disconnected.connect(_peer_disconnected)

func is_entity_authoritative(entity_state: Dictionary) -> bool:
	return entity_state[WorldState.STATE_KEYS.SCENE] != "player"


func _peer_connected(player_id: int) -> void:
	print("User " + str(player_id) + " is connected !")


func _peer_disconnected(player_id: int) -> void:
	print("User " + str(player_id) + " is disconnected !")
	
	stable_world_state_manager.despawn_entity(player_id)
	unstable_world_state_manager.despawn_entity(player_id)
	update_world_stable_state()

###
# BUILT-IN
###
const MAX_PLAYERS = 4

###
# BUILT-IN
# Clock synchro
###
var clock_synchronizer := ClockSynchronizer.new()

###
# BUILT-IN
# Global requests
###
func _global_requests(data: Dictionary):
	match data['request']:
		'world_stable_state':
			_network.send(_network.get_sender_id(), Channel.GLOBAL_REQUESTS, {
				'request': 'world_stable_state',
				'state': stable_world_state_manager.get_clean_world_state()
			})
		_:
			print("[CLIENT] wrong global request: ", data['request'])

###
# BUILT-IN
# Entities and WorldState
###
var stable_world_state_manager := StableWorldStateManager.new()
var unstable_world_state_manager := UnstableWorldStateManager.new()

func _physics_process(_delta: float) -> void:
	_network.send(Destination.ALL, Channel.UPDATE_ENTITY_UNSTABLE_STATE, unstable_world_state_manager.get_clean_world_state())
	

func _update_entity_unstable_state(entity_state: Dictionary):
	unstable_world_state_manager.update_entity(entity_state)

func update_entity_unstable_state(entity_state: Dictionary):
	entity_state[WorldState.STATE_KEYS.TIME] = clock_synchronizer.get_unit()
	unstable_world_state_manager.update_entity(entity_state)

func _update_entity_stable_state(entity_state: Dictionary):
	stable_world_state_manager.update_entity(entity_state)
	_network.send(Destination.ALL, Channel.UPDATE_ENTITY_STABLE_STATE, entity_state)

func update_entity_stable_state(entity_state: Dictionary):
	stable_world_state_manager.update_entity(entity_state)
	_network.send(Destination.ALL, Channel.UPDATE_ENTITY_STABLE_STATE, entity_state)

func update_world_stable_state(destination: int = Destination.ALL):
	_network.send(destination, Channel.UPDATE_WORLD_STABLE_STATE, stable_world_state_manager.get_clean_world_state())
	



###
# BUILT-IN
# Clock synchro
###
func _clock_synchronization(data: Dictionary):
	match data['request']:
		'server_time':
			_network.send(_network.get_sender_id(), Channel.CLOCK_SYNCHRONIZATION, {
				'request': 'server_time',
				'client': data['client'],
				'server': clock_synchronizer.get_unit()
			})
		'determine_latency':
			_network.send(_network.get_sender_id(), Channel.CLOCK_SYNCHRONIZATION, {
				'request': 'determine_latency',
				'client': data['client']
			})
		_:
			print("[SERVER] wrong request: ", data['request'])
