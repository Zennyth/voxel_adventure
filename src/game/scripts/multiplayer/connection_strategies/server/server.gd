extends ConnectionStrategy
class_name ServerConnectionStrategy

func init_connection(network: Network, args: Dictionary):
	super.init_connection(network, args)
	
	Engine.physics_ticks_per_second = 20
	
	args['MAX_PLAYERS'] = MAX_PLAYERS
	network.create_server(args)
	
	_network.peer_connected.connect(_peer_connected)
	_network.peer_disconnected.connect(_peer_disconnected)



func _peer_connected(player_id: int) -> void:
	print("User " + str(player_id) + " is connected !")

func _peer_disconnected(player_id: int) -> void:
	print("User " + str(player_id) + " is disconnected !")


###
# BUILT-IN
###
const MAX_PLAYERS = 4

###
# BUILT-IN
# Entities and WorldState
###
const ReliableWorldStateManager = preload("res://scripts/multiplayer/connection_strategies/server/world_state_managers/reliable_world_state_manager.gd")
var reliable_world_state_manager := ReliableWorldStateManager.new()

const UnreliableWorldStateManager = preload("res://scripts/multiplayer/connection_strategies/server/world_state_managers/unreliable_world_state_manager.gd")
var unreliable_world_state_manager := UnreliableWorldStateManager.new()

func _physics_process(_delta: float) -> void:	
	_network.send(Destination.ALL, Channel.UPDATE_ENTITY_UNRELIABLE_STATE, {
		't': Time.get_ticks_msec(),
		'e': unreliable_world_state_manager.get_clean_world_state()
	})
	

func _update_entity_unreliable_state(entity: Dictionary):
	var result: WorldStateManager.EntityUpdateResult = unreliable_world_state_manager.update_entity(entity)

	if not unreliable_world_state_manager.has_entity_been_updated(result):
		return
	
	if result == ReliableWorldStateManager.EntityUpdateResult.NOT_PRESENT_ENTITY:
		spawn_player(entity['id'])
	
	var entity_manager := get_node("/root/World/EntityManager") as EntityManager
	entity_manager.update_entity_state(entity['id'], entity)
	



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
				'server': get_clock_unit()
			})
		'determine_latency':
			_network.send(_network.get_sender_id(), Channel.CLOCK_SYNCHRONIZATION, {
				'request': 'determine_latency',
				'client': data['client']
			})
		_:
			print("[SERVER] wrong request: ", data['request'])
