extends Character

@onready
var _viewer: VoxelViewer = $VoxelViewer

func _ready() -> void:
	super()
	_spells_manager = $SpellsManager
	if id != -1: set_viewer_id(id)

func init(player_id: int, new_position: Vector3) -> void:
	super(player_id, new_position)
	name = str(player_id)
	if _viewer: set_viewer_id(player_id)

func set_viewer_id(player_id: int) -> void:
	_viewer.set_network_peer_id(player_id)
