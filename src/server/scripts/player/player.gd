extends Node3D

var id: int = -1

@onready
var _viewer: VoxelViewer = $VoxelViewer

func _ready():
	if id != -1: set_viewer_id(id)

func init(player_id: int, new_position: Vector3):
	id = player_id
	name = str(player_id)
	if _viewer: set_viewer_id(player_id)
	set_position(new_position)

func set_position(new_position: Vector3):
	position = new_position

func set_viewer_id(player_id: int):
	_viewer.set_network_peer_id(player_id)
