extends Node

var network := ENet.new()
var port := 1909
var is_online := false

enum ConnectionMode {
	SOLO,
	CLIENT,
	SERVER
}
func get_strategy(mode: ConnectionMode) -> ConnectionStrategy:
	match mode:
		ConnectionMode.SERVER:
			return ServerConnectionStrategy.new()
		ConnectionMode.CLIENT:
			return ClientConnectionStrategy.new()
		_, ConnectionMode.SOLO:
			return SoloConnectionStrategy.new()

var connection_mode: ConnectionMode
var connection_strategy: ConnectionStrategy
func set_connection_mode():
	# connection_mode = ConnectionMode.SOLO
	if "--server" in OS.get_cmdline_args():
		connection_mode = ConnectionMode.SERVER
	else:
		connection_mode = ConnectionMode.CLIENT

func _ready():
	set_connection_mode()
	connection_strategy = get_strategy(connection_mode)
	add_child(connection_strategy)
	
	connection_strategy.init_connection(network, {
		'port': port,
	})
	is_online = connection_mode != ConnectionMode.SOLO

func is_entity_authoritative(data):
	var entity_state: Dictionary
	
	if data is int:
		entity_state = connection_strategy.entity_manager.get_entity(data).get_stable_state()
	else:
		entity_state = data
	
	return connection_strategy.is_entity_authoritative(entity_state)

func update_entity_unstable_state(entity_state: Dictionary) -> void:
	connection_strategy.update_entity_unstable_state(entity_state)

func update_entity_stable_state(entity_state: Dictionary) -> void:
	connection_strategy.update_entity_stable_state(entity_state)
