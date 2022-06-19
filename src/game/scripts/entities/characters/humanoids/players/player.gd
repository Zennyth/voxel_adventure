extends Humanoid
class_name Player

@onready var springArmPlayer: SpringArmPlayer = $SpringArmPlayer
@onready var voxelViewer: VoxelViewer = $VoxelViewer
# @onready var label: LabelComponent = $Label3D

var equipement_inventory := InventoryResource.new(DictionaryInventoryStore.new())

func _ready():
	super._ready()
	
	if not is_authoritative():
		voxelViewer.process_mode = Node.PROCESS_MODE_DISABLED

	