extends Node

@onready var Entities: EntityManager = $EntityManager

func _ready():
	EventBus._world_ready.emit(Entities)
	
#	print((Terrain.generator as VoxelGeneratorWorld).get_biome_map().get_biome_by_position()
