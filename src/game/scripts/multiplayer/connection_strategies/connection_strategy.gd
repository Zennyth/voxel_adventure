extends Node
class_name ConnectionStrategy

var _network: Network

func init_connection(network: Network, _args: Dictionary):
	_network = network
	_network._clock_synchronization.connect(_clock_synchronization)
	_network._update_entity_unreliable_state.connect(_update_entity_unreliable_state)
	_network._update_entity_reliable_state.connect(_update_entity_reliable_state)
	add_child(network)

func _clock_synchronization(_data: Dictionary):
	pass

func _update_entity_unreliable_state(_data: Dictionary):
	pass
func update_entity_unreliable_state(_data):
	pass

func _update_entity_reliable_state(_data: Dictionary):
	pass

func get_clock_unit() -> int:
	return Time.get_ticks_msec()

func spawn_player(id: int = _network.get_id()):
	var entity_manager := get_node("/root/World/EntityManager") as EntityManager
	entity_manager.spawn_entity(id)


###
# STATIC
###

enum ConnectionMode {
	CLIENT,
	SERVER
}

enum Destination {
	ALL = 0,
	SERVER = 1
}

const Channel = {
	CLOCK_SYNCHRONIZATION = "clock_synchronization",
	UPDATE_ENTITY_UNRELIABLE_STATE = "update_entity_unreliable_state",
	UPDATE_ENTITY_RELIABLE_STATE = "update_entity_reliable_state",
}

static func get_strategy(mode: ConnectionMode) -> ConnectionStrategy:
	match mode:
		ConnectionMode.SERVER:
			return ServerConnectionStrategy.new()
		_, ConnectionMode.CLIENT:
			return ClientConnectionStrategy.new()
