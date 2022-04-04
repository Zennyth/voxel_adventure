extends Node

var _player

@onready var _terrain = $VoxelTerrain2
@onready var _camera = $Camera3D
@onready var initial_position = _camera.position
	
func _process(delta):
	_player = get_parent().get_parent().get_node("Player")
	if _player:
		_terrain.rotation.y = _player._spring_arm.rotation.y
		_camera.position = initial_position + _player.position 
