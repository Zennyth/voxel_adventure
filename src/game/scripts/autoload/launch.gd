extends Node

var network: Network
var connection_strategy: ConnectionStrategy

var loaded_character: DataManager

var is_previous_step: bool = false
var previous_step: PackedScene

#func _init():
#	network = NetworkFactory.get_by_arguments()
#	connection_strategy = ConnectionStrategyFactory.get_by_arguments()

	# MainMenu ?= connection_strategy is not null at init
	# CharacterPicker ?= connection_strategy.need_loaded_character()
	# ConnectionStrategyPicker
	# - Solo -> MapPicker -> Game
	# - NetworkPicker
	# 	- Server -> MapPicker -> Game
	# 	- Host -> MapPicker -> Game
	# 	- Client -> JoinServer ->  Game



#*( MainMenu ) -> *( CharacterPicker ) -> ConnectionStrategyPicker:
#													Solo -> MapPicker -> Game
#													NetworkPicker:
#														Server -> MapPicker -> Game
#														Host -> MapPicker -> Game
#														Client -> JoinServer ->  Game
