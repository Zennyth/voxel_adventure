extends Node

var network := ENet.new()
var port := 1909
var is_online := false

var connection_mode: ConnectionStrategy.ConnectionMode
var connection_strategy: ConnectionStrategy
func set_connection_mode():
	if "--server" in OS.get_cmdline_args():
		connection_mode = ConnectionStrategy.ConnectionMode.SERVER
	else:
		connection_mode = ConnectionStrategy.ConnectionMode.CLIENT

func _ready():
	set_connection_mode()
	connection_strategy = ConnectionStrategy.get_strategy(connection_mode)
	add_child(connection_strategy)
	
	connection_strategy.init_connection(network, {
		'port': port,
	})
	is_online = true

func is_entity_authoritative(entity_id: int):
	return not Multiplayer.is_online or network.get_id() == entity_id

func update_entity_unreliable_state(entity_state: Dictionary) -> void:
	connection_strategy.update_entity_unreliable_state(entity_state)
