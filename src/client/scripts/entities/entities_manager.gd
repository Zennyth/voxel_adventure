extends Node
class_name EntitiesManager

####
## Init
####

@export
var entity_scene: PackedScene

func get_entity(entity_id: int) -> Entity:
	if not has_entity(entity_id): return null
		
	return get_node(str(entity_id))

func has_entity(entity_id: int) -> bool:
	return has_node(str(entity_id))

####
## Main
####

func update_entity(entity_id: int, entity_state: Dictionary) -> void:
	if not has_entity(entity_id): return 
	
	var entity: Entity = get_entity(entity_id)
	entity.set_state(entity_state)

func spawn_entity(entity_id: int, entity_state: Dictionary) -> Entity:
	if has_entity(entity_id): return null
	
	var new_entity: Entity = entity_scene.instantiate()
	new_entity.init(entity_id, entity_state["P"])
	add_child(new_entity)
	return new_entity

func update_or_spawn_entity_with_properties(entity_id: int, entity_properties: Dictionary) -> void:
	var entity: Entity
	if has_entity(entity_id):
		entity = get_entity(entity_id)
	else:
		entity = entity_scene.instantiate()
	
	entity.set_properties(entity_properties)



func despawn_entity(entity_id: int) -> void:
	if not has_entity(entity_id): return
	
	get_entity(entity_id).queue_free()

