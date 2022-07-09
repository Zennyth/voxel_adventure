extends Node
class_name MultiplayerManager

var network := ENetNetwork.new()
var port := 1909
var is_ready := false

var connection_strategy: ConnectionStrategy
func get_strategy() -> ConnectionStrategy:
	if "--server" in OS.get_cmdline_args():
		return ServerConnectionStrategy.new()
	else:
		return ClientConnectionStrategy.new()
	
	return SoloConnectionStrategy.new()

func init(entity_manager: EntityManager):
	connection_strategy = get_strategy()
	connection_strategy.init(entity_manager)
	add_child(connection_strategy)

func _ready():
	is_ready = true
	connection_strategy.init_connection(network, {
		'port': port,
	})

func is_entity_authoritative(data) -> bool:
	if not is_ready:
		return false
	
	var entity_state: Dictionary
	
	if data is int:
		entity_state = connection_strategy.entity_manager.get_entity(data).get_stable_state()
	else:
		entity_state = data
	
	return connection_strategy.is_entity_authoritative(entity_state)

func update_entity_unstable_state(entity_state: Dictionary) -> void:
	if not is_ready:
		return
	
	connection_strategy.update_entity_unstable_state(entity_state)

func update_entity_stable_state(entity_state: Dictionary) -> void:
	if not is_ready:
		return
	
	connection_strategy.update_entity_stable_state(entity_state)
