extends Node

func _init():
	EventBus._multipayer_setup.connect(_on_multipayer_setup)
	EventBus._world_ready.connect(_on_world_ready)
	EventBus._terrain_ready.connect(_on_terrain_ready)

func _ready():
	add_child(multiplayer_manager)


func _on_multipayer_setup(connection_strategy, network):
	if connection_strategy == null or network == null:
		return
	
	multiplayer_manager.set_connection(
		connection_strategy,
		network,
		CommandLineArguments.get_arguments()
	)
	
	get_tree().change_scene_to_file("res://scenes/terrain/test.tscn")

###
# BUILT-IN
# Multiplayer
###
var multiplayer_manager := MultiplayerManager.new()
func _on_world_ready(entity_manager: EntityManager):
	multiplayer_manager.init(entity_manager)

###
# BUILT-IN
# Terrain
###
var Terrain
func _on_terrain_ready(terrain):
	Terrain = terrain


###
# BUILT-IN
# SAVE_MANAGER
###
var character_save_manager := CharacterSaveManager.new()


###
# BUILT-IN
# UI
###
var ui_manager := UIManager.new()
