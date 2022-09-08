extends Node

@onready var Entities: EntityManager = $EntityManager
@onready var Terrain: VoxelTerrain = $VoxelTerrain

var network := ENetNetwork.new()
var connection_strategy: ConnectionStrategy
var args := {
	"ip": "127.0.0.1",
	"port": 9603,
}

func _init():
	if "--server" in OS.get_cmdline_args():
		connection_strategy = ServerConnectionStrategy.new()
	else:
		connection_strategy = ClientConnectionStrategy.new()
	
	Game.multiplayer_manager.set_connection(connection_strategy, network, args)

func _ready():
	EventBus._world_ready.emit(Entities)
	EventBus._terrain_ready.emit(Terrain)
	
	print((Terrain.generator as VoxelGeneratorWorld).biome_map)
