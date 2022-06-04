extends WorldStateManager

func update_entity(entity_state: Dictionary) -> int:
	var entity_id: int = entity_state['id']
	
	if world_state.has(entity_id):
		if world_state[entity_id]['t'] >= entity_state['t']:
			return EntityUpdateResult.OUTDATED_ENTITY
		
		world_state[entity_id] = entity_state
		return EntityUpdateResult.UPDATED_ENTITY
		
	else:
		world_state[entity_id] = entity_state
		return EntityUpdateResult.NOT_PRESENT_ENTITY

func get_clean_world_state() -> Dictionary:
	var world_state_duplicate: Dictionary = world_state.duplicate(true)
	
	for entity_id in world_state_duplicate.keys():
		world_state_duplicate[entity_id].erase('t')
	
	return world_state_duplicate
