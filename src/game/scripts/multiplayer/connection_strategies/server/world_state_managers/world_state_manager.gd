extends Node
class_name WorldStateManager

###
# STATIC
###
enum EntityUpdateResult {
	OUTDATED_ENTITY = 0,
	NOT_PRESENT_ENTITY = 1,
	UPDATED_ENTITY = 2,
}
func has_entity_been_updated(result: EntityUpdateResult) -> bool:
	return result > 0

###
# BUILT-IN
###

var world_state := {}

func update_entity(entity_state: Dictionary) -> int:
	return EntityUpdateResult.OUTDATED_ENTITY

func get_clean_world_state() -> Dictionary:
	return world_state

func is_entity_updated(entity_state: Dictionary) -> bool:
	return has_entity_been_updated(update_entity(entity_state))
