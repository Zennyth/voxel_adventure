extends VoxelTerrain

@onready var world_generator := generator as VoxelGeneratorWorld
var _player: Player

func get_biome_by_position(target_position: Vector2) -> Biome:
	if not world_generator:
		return null
	
	return world_generator.get_biome_map().get_biome_by_position(target_position)

func _on_player_position_changed(player_position: Vector3):
	Debug.update_debug_property(
		DebugProperty.DebugPropertyKey.BIOME, 
		get_biome_by_position(Vector2(player_position.x, player_position.z)).biome_name
	)

func _on_player_initialized(player: Player):
	_player = player
	set_process(true)

func _init():
	set_process(false)

func _process(_delta):
	if not _player:
		return
	
	_on_player_position_changed(_player.position)

func _ready():
	EventBus._terrain_ready.emit(self)
	EventBus._player_initialized.connect(_on_player_initialized)
