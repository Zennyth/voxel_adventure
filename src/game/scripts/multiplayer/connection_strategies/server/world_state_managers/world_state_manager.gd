extends WorldState
class_name WorldStateManager

###
# BUILT-IN
###

var world_state := {}

func update_entity(_entity_state: Dictionary):
	pass

func despawn_entity(entity_id: int):
	world_state.erase(entity_id)

func get_world_state() -> Dictionary:
	return world_state

func get_clean_world_state() -> Dictionary:
	return {
		STATE_KEYS.TIME: clock_synchronizer.get_unit(),
		STATE_KEYS.ENTITIES: get_world_state()
	}
