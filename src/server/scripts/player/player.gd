extends Node3D

var viewer: VoxelViewer
var id: int = -1

func _ready():
	viewer = get_node("VoxelViewer")
	if id != -1: set_viewer_id(id)

func init(player_id: int, new_position: Vector3):
	id = player_id
	if viewer:
		set_viewer_id(player_id)
		pass
	set_position(new_position)

func set_position(new_position: Vector3):
	position = new_position

func set_viewer_id(id: int):
	# TODO: set the viewer's id
	pass

