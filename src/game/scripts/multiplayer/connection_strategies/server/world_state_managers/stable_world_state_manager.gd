extends WorldStateManager
class_name StableWorldStateManager

func update_entity(entity_state: Dictionary):
	var entity_id: int = entity_state['id']
	world_state[entity_id] = entity_state

	entity_manager.update_entity_stable_state(entity_id, entity_state)

func get_world_state() -> Dictionary:
	return world_state
