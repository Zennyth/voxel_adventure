extends Node

@onready var Entities: EntityManager = $EntityManager
@onready var Terrain: VoxelTerrain = $VoxelTerrain


func _ready():
	EventBus._world_ready.emit(Entities)
	EventBus._terrain_ready.emit(Terrain)
	
#	print((Terrain.generator as VoxelGeneratorWorld).get_biome_map().get_biome_by_position()
