extends Node3D

@onready var player: Player = get_parent()
var voxel_tool: VoxelTool

func _ready():
	EventBus._terrain_ready.connect(_on_terrain_ready)

func _on_terrain_ready(terrain: VoxelTerrain):
	voxel_tool = terrain.get_voxel_tool()

func _process(delta):
	if not voxel_tool:
		return
		
	var player_position = global_position
	var forward_direction = player.controller.get_direction()
	
	if forward_direction.length() == 0:
		return

	var lower = voxel_tool.raycast(player_position, forward_direction, 0.5)
	if not lower or lower.position == Vector3i.ZERO:
		return
	
	
	var upper = voxel_tool.raycast(player_position + Vector3.UP, forward_direction, 1)
	if upper and lower.position != Vector3i.ZERO:
		return
	
	player.global_position += Vector3.UP
