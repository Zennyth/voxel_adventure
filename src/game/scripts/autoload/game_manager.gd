extends Node

func _init():
	EventBus._world_ready.connect(_on_world_ready)
	EventBus._terrain_ready.connect(_on_terrain_ready)

func _ready():
	add_child(multiplayer_manager)

###
# BUILT-IN
# Multiplayer
###
var multiplayer_manager := MultiplayerManager.new()
func _on_world_ready(entity_manager: EntityManager):
	multiplayer_manager.init(entity_manager)
	
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
