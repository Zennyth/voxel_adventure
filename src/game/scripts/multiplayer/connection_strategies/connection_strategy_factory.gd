extends Node

###
# STATIC
###

enum ConnectionMode {
	CLIENT,
	SERVER
}

static func get_strategy(mode: ConnectionMode) -> ConnectionStrategy:
	match mode:
		ConnectionMode.SERVER:
			return ServerConnectionStrategy.new()
		_, ConnectionMode.CLIENT:
			return ClientConnectionStrategy.new()
