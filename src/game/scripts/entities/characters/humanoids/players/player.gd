extends Humanoid
class_name Player

@onready var springArmPlayer: SpringArmPlayer = $SpringArmPlayer
@onready var voxelViewer: VoxelViewer = $VoxelViewer
# @onready var label: LabelComponent = $Label3D

func _ready():
	super._ready()
	
	if not is_authoritative():
		voxelViewer.process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	EventBus._player_initialized.emit(self)


func _process(delta):
	if Game.Terrain == null:
		return
	
	Debug.update_debug_property(DebugProperty.DebugPropertyKey.BIOME, (Game.Terrain.generator as VoxelGeneratorWorld).get_biome_map().get_biome_by_position(Vector2(character.position.x, character.position.z)).biome_name)
