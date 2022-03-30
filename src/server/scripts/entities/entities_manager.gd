extends Node
class_name EntitiesManager

####
## Init
####

@export var entity_scene: PackedScene
@export var type: String

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
	new_entity.init(entity_id, Vector3.ZERO)
	add_child(new_entity)
	return new_entity

func despawn_entity(entity_id: int) -> void:
	if not has_entity(entity_id): return
	
	get_entity(entity_id).queue_free()

####
## States
####

var entity_state_collection: Dictionary = {}

func get_entity_state_collection() -> Dictionary:
	return entity_state_collection

func update_entity_state(entity_id: int, entity_state: Dictionary) -> void:
	if not has_entity(entity_id): return 
	
	var entity: Entity = get_entity(entity_id)
	entity.set_state(entity_state)
####
## Properties
####

var entity_properties_collection: Dictionary = {}

func get_entity_properties_collection() -> Dictionary:
	var entity_properties_collection_clone: Dictionary = {}
	for node in get_children():
		if node is Entity:
			entity_properties_collection_clone[node.id] = node.properties
	return entity_properties_collection_clone

func update_entity_properties(entity_id: int, entity_properties: Dictionary) -> void:
	if not has_entity(entity_id): return 
	
	var entity: Entity = get_entity(entity_id)
	entity.set_properties(entity_properties)
