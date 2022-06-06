extends Node3D
class_name EntityManager

####
## Init
####

@export var entity_scene: PackedScene

func get_entity(entity_id: int) -> Entity:
	if not has_entity(entity_id): return null
	
	return get_node(str(entity_id))

func has_entity(entity_id: int) -> bool:
	return has_node(str(entity_id))

####
## Main
####

func spawn_entity(entity_id: int) -> Entity:
	if has_entity(entity_id): return get_entity(entity_id)

		
	var new_entity: Entity = entity_scene.instantiate()
	add_child(new_entity)
	new_entity.init(entity_id)
	new_entity.connect("destroyed", destroy_entity)
	new_entity.position.y = 300
	return new_entity

func despawn_entity(entity_id: int) -> void:
	if not has_entity(entity_id): return
	
	get_entity(entity_id).queue_free()

func destroy_entity(entity_id: int) -> void:
	despawn_entity(entity_id)

####
## States
####

func update_entity_unstable_state(entity_id: int, entity_state: Dictionary) -> void:
	if not has_entity(entity_id): return 
	
	var entity: Entity = get_entity(entity_id)
	entity.set_unstable_state(entity_state)


func update_entity_stable_state(entity_id: int, entity_state: Dictionary) -> void:
	if not has_entity(entity_id): return 
	
	var entity: Entity = get_entity(entity_id)
	entity.set_stable_state(entity_state)
