extends WorldStateManager
class_name UnstableWorldStateManager

func update_entity(entity_state: Dictionary):
	var entity_id: int = entity_state[WorldState.STATE_KEYS.ID]

	if world_state.has(entity_id) and world_state[entity_id][STATE_KEYS.TIME] >= entity_state[STATE_KEYS.TIME]:
		return
	
	world_state[entity_id] = entity_state
	entity_manager.update_entity_unstable_state(entity_id, entity_state)

func get_world_state() -> Dictionary:
	var world_state_duplicate: Dictionary = world_state.duplicate(true)
	
	for entity_id in world_state_duplicate.keys():
		world_state_duplicate[entity_id].erase(STATE_KEYS.TIME)
	
	return world_state_duplicate
