extends Node3D
class_name EntityManager

####
## Init
####

func get_entity(entity_id: int) -> Entity:
	if not has_entity(entity_id): return null
	
	return get_node(str(entity_id))

func has_entity(entity_id: int) -> bool:
	return has_node(str(entity_id))
	
####
## Scenes
####
var scenes: Dictionary
const dont_load: Array = [
	"res://scenes/entities/characters/character.tscn"
]

func _init():
	fetch_scenes()

func fetch_scenes() -> void:
	scenes = {}
	
	for file in FilesUtils.get_files_from_folder("res://scenes/entities/"):
		var extension: String = "." + file.get_extension()
		if extension != ".tscn" or dont_load.has(file):
			continue
		
		var scene: PackedScene = load(file)
		var sceneName: String = file.get_file().replace(extension, "")
		scenes[sceneName] = scene


####
## Main
####
var random := RandomNumberGenerator.new()

func spawn_entity(entity_state: Dictionary, entity: Entity = null) -> Entity:
	random.randomize()
	
	if WorldState.STATE_KEYS.ID not in entity_state:
		entity_state[WorldState.STATE_KEYS.ID] = random.randi_range(0, 1000000)
	
	var entity_id: int = entity_state[WorldState.STATE_KEYS.ID]
	
	if has_entity(entity_id): 
		return get_entity(entity_id)
	
	if WorldState.STATE_KEYS.SCENE not in entity_state:
		return null
	
	var entity_scene: String = entity_state[WorldState.STATE_KEYS.SCENE]
	if entity_scene not in scenes:
		return null
	
	var new_entity: Entity = entity
	if not new_entity:
		new_entity = scenes[entity_scene].instantiate()
	
	new_entity.init(entity_state)
	add_child(new_entity)
	new_entity._destroyed.connect(destroy_entity)
	random.randomize()
	new_entity.position.x = random.randi_range(0, 10)
	new_entity.position.y = 150
	new_entity.position.z = random.randi_range(0, 10)
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
	
	if not entity.is_authoritative():
		entity.set_unstable_state(entity_state)


func update_entity_stable_state(entity_id: int, entity_state: Dictionary) -> void:
	if not has_entity(entity_id): return 
	
	var entity: Entity = get_entity(entity_id)
	
	if not entity.is_authoritative():
		entity.set_stable_state(entity_state)
