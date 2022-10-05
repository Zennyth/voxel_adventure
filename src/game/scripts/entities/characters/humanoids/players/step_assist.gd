extends Node3D

@onready var character_entity: Character = get_parent()
@onready var voxel_tool: VoxelTool = Game.Terrain.get_voxel_tool()

func _physics_process(_delta):	
	if not voxel_tool:
		return

	var direction := character_entity.controller.get_direction()
	var direction_position := Vector3(direction.x, 0, direction.z)

	if direction_position.length() == 0:
		return

	var lower = voxel_tool.raycast(global_position, direction_position, 0.75)
	if not lower or lower.position == Vector3i.ZERO:
		return


	var upper = voxel_tool.raycast(global_position + Vector3.UP, direction_position + Vector3.UP, 0.75)
	if upper and lower.position != Vector3i.ZERO:
		return

	character_entity.global_position += Vector3.UP
