extends Node
class_name ConnectionStrategy

###
# BUILT-IN
###
var _network: Network

func init_connection(network: Network, _args: Dictionary):
	_network = network
	_network._clock_synchronization.connect(_clock_synchronization)
	_network._update_entity_unstable_state.connect(_update_entity_unstable_state)
	_network._update_entity_stable_state.connect(_update_entity_stable_state)
	_network._update_world_stable_state.connect(_update_world_stable_state)
	_network._global_requests.connect(_global_requests)
	add_child(network)

func is_entity_authoritative(_entity_state: Dictionary) -> bool:
	return false

func _clock_synchronization(_data: Dictionary):
	pass

func _update_entity_unstable_state(_data: Dictionary):
	pass
func update_entity_unstable_state(_data):
	pass

func _update_entity_stable_state(_data: Dictionary):
	pass
func update_entity_stable_state(_data):
	pass

func _update_world_stable_state(_data: Dictionary):
	pass
func update_world_stable_state(_data):
	pass


func _global_requests(_data: Dictionary):
	pass
func global_requests(_data: Dictionary):
	pass


func need_loaded_character() -> bool:
	return true

###
# BUILT-IN
# Entity management
###
var entity_manager: EntityManager

func init(entity_manager_reference):
	entity_manager = entity_manager_reference

func get_id() -> int:
	return _network.get_id() if _network else -1

func create_authoritative_entity_state(entity_state: Dictionary) -> Dictionary:
	entity_state[WorldState.STATE_KEYS.OWNER_ID] = _network.get_id() if _network else 0
	return entity_state
	

func spawn_player(id: int = _network.get_id()):
	if not entity_manager:
		return
		
	var player: Player = entity_manager.scenes["player"].instantiate()
	player.data = Game.character_save_manager.load_character()
	
	entity_manager.spawn_entity(
		create_authoritative_entity_state({
			WorldState.STATE_KEYS.ID: id,
			WorldState.STATE_KEYS.SCENE: "player"
		}), 
		player
	)

###
# STATIC
###
enum Destination {
	ALL = 0,
	SERVER = 1
}

const Channel = {
	CLOCK_SYNCHRONIZATION = "clock_synchronization",
	UPDATE_ENTITY_UNSTABLE_STATE = "update_entity_unstable_state",
	UPDATE_ENTITY_STABLE_STATE = "update_entity_stable_state",
	UPDATE_WORLD_STABLE_STATE = "update_world_stable_state",
	GLOBAL_REQUESTS = "global_requests",
}
