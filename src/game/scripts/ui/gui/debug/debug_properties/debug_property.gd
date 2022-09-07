extends Control
class_name DebugProperty

enum DebugPropertyKey {
	ALL,

	CONNECTION_STRATEGY_NETWORK,
	LATENCY_NETWORK,
	DELTA_LATENCY_NETWORK
}

@export var key: DebugPropertyKey = DebugPropertyKey.ALL

func _init():
	add_to_group("debug_property")

func update_value(_value):
	pass
