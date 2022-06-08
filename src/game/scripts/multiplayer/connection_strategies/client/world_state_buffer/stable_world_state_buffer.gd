extends WorldState
class_name StableWorldStateBuffer

var world_state_buffer: Dictionary = {}

func update_world_state_buffer(world_state: Dictionary) -> void:
	var entities: Dictionary = world_state[STATE_KEYS.ENTITIES] 

	for entity_id in entities.keys():
		var entity_state: Dictionary = entities[entity_id]

		world_state_buffer[entity_id] = entity_state
		update_entity_stable_state(entity_id, entity_state)
	
	for entity_id in world_state_buffer.keys():
		if entity_id not in entities and world_state_buffer[entity_id][STATE_KEYS.TIME] < world_state[STATE_KEYS.TIME]:
			entity_manager.despawn_entity(entity_id)


func update_entity_stable_state(entity_id: int, entity_state: Dictionary):
	
	if Multiplayer.is_entity_authoritative(entity_state):
		return

	if is_entity_state_outdated(entity_id, entity_state):
		return

	if not entity_manager.has_entity(entity_id):
		entity_manager.spawn_entity(entity_state)
	
	world_state_buffer[entity_id] = entity_state
	entity_manager.update_entity_stable_state(entity_id, entity_state)


func is_entity_state_outdated(entity_id: int, entity_state: Dictionary):
	return entity_id in world_state_buffer and entity_state[STATE_KEYS.TIME] < world_state_buffer[entity_id][STATE_KEYS.TIME]
