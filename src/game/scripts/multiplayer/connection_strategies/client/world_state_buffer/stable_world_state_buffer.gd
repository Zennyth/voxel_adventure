extends Node
class_name StableWorldStateBuffer

var entity_manager: EntityManager
const ClientClockSynchronizer = preload("res://scripts/multiplayer/connection_strategies/client/client_clock_synchronizer.gd")
var clock_synchronizer: ClientClockSynchronizer

var world_state_buffer = {}

func init(manager: EntityManager, clock: ClientClockSynchronizer):
	entity_manager = manager
	clock_synchronizer = clock


func update_world_state_buffer(world_state: Dictionary) -> void:
	print("Client: ", Multiplayer.network.get_id() ," has WorldState: ", world_state, " is being updated")
	
	for entity_id in world_state['e'].keys():
		world_state_buffer[entity_id] = world_state['e'][entity_id]
		update_entity_stable_state(entity_id, world_state['e'][entity_id])
	
#	for entity_id in world_state_buffer.keys():
#		if entity_id not in world_state:
#			entity_manager.despawn_entity(entity_id)

func update_entity_stable_state(entity_id: int, entity_state: Dictionary):
	print("Client: ", Multiplayer.network.get_id() ," has Entity: ", entity_id, " is being updated")
	
	if Multiplayer.is_entity_authoritative(entity_id):
		return

	if not entity_manager.has_entity(entity_id):
		entity_manager.spawn_entity(entity_id)
	
	world_state_buffer[entity_id] = entity_state
	entity_manager.update_entity_stable_state(entity_id, entity_state)
