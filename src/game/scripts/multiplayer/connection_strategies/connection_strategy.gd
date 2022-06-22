extends Node
class_name ConnectionStrategy

###
# BUILT-IN
###

func _ready():
	entity_manager = get_node("/root/Test/EntityManager") as EntityManager

var _network: Network

func init_connection(network: Network, _args: Dictionary):
	_network = network
	_network._clock_synchronization.connect(_clock_synchronization)
	_network._update_entity_unstable_state.connect(_update_entity_unstable_state)
	_network._update_entity_stable_state.connect(_update_entity_stable_state)
	_network._update_world_stable_state.connect(_update_world_stable_state)
	_network._global_requests.connect(_global_requests)
	add_child(network)

func is_entity_authoritative(entity_state: Dictionary) -> bool:
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

###
# BUILT-IN
# Entity management
###
var entity_manager: EntityManager

func spawn_player(id: int = _network.get_id()):
	entity_manager.spawn_entity({
		WorldState.STATE_KEYS.ID: id,
		WorldState.STATE_KEYS.SCENE: "player"
	})
