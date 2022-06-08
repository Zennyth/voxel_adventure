extends WorldStateManager
class_name StableWorldStateManager

func update_entity(entity_state: Dictionary):
	var entity_id: int = entity_state[WorldState.STATE_KEYS.ID]

	entity_state[STATE_KEYS.TIME] = clock_synchronizer.get_unit()

	world_state[entity_id] = entity_state
	
	if not entity_manager.has_entity(entity_id):
		entity_manager.spawn_entity(entity_state)
	
	entity_manager.update_entity_stable_state(entity_id, entity_state)

func get_world_state() -> Dictionary:
	return world_state
