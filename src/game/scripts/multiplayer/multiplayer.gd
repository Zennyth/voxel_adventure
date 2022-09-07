extends Node
class_name MultiplayerManager

var network: Network
var args: Dictionary
var port := 1909
var is_ready := false

var connection_strategy: ConnectionStrategy
func get_strategy() -> ConnectionStrategy:
#	if "--server" in OS.get_cmdline_args():
#		return ServerConnectionStrategy.new()
#	elif "--host" in OS.get_cmdline_args():
#		return HostConnectionStrategy.new()
#	else:
#		return ClientConnectionStrategy.new()
	
	return SoloConnectionStrategy.new()

func init(entity_manager: EntityManager):
	connection_strategy.init(entity_manager)
	add_child(connection_strategy)
	is_ready = true
	connection_strategy.init_connection(network, args)

func set_connection(_connection_strategy: ConnectionStrategy, _network: Network, _args: Dictionary):
	network = _network
	connection_strategy = _connection_strategy
	args = _args

func is_entity_authoritative(data) -> bool:
	if not is_ready:
		return false

	var entity_id: int = data if data is int else data[WorldState.STATE_KEYS.ID]
	var entity: Entity = connection_strategy.entity_manager.get_entity(entity_id)
	
	if not entity:
		return false
	
	return entity.is_authoritative()

func update_entity_unstable_state(entity_state: Dictionary) -> void:
	if not is_ready:
		return
	
	connection_strategy.update_entity_unstable_state(entity_state)

func update_entity_stable_state(entity_state: Dictionary) -> void:
	if not is_ready:
		return
	
	connection_strategy.update_entity_stable_state(entity_state)
