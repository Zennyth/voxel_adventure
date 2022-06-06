extends Node
class_name WorldStateManager

###
# BUILT-IN
###

var entity_manager: EntityManager
var clock_synchronizer: ClockSynchronizer

func init(manager: EntityManager, clock: ClockSynchronizer):
	entity_manager = manager
	clock_synchronizer = clock

var world_state := {}

func update_entity(entity_state: Dictionary):
	pass

func despawn_entity(entity_id: int):
	world_state.erase(entity_id)

func get_world_state() -> Dictionary:
	return world_state

func get_clean_world_state() -> Dictionary:
	return {
		't': clock_synchronizer.get_unit(),
		'e': get_world_state()
	}
