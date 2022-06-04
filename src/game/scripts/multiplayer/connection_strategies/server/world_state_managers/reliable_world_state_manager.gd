extends WorldStateManager

func update_entity(entity_state: Dictionary) -> int:
	var entity_id: int = entity_state['id']
	world_state[entity_id] = entity_state
	return EntityUpdateResult.UPDATED_ENTITY

func get_clean_world_state() -> Dictionary:
	return world_state
