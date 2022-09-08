extends Node3D

@onready var character_entity: Character = get_parent()
var voxel_tool: VoxelTool

func _init():
	set_process(false)
	EventBus._terrain_ready.connect(_on_terrain_ready)
	Debug.draw.add_vector(character_entity, "character.velocity", 1.0, 1.0, Color(0, 1, 0))

func _on_terrain_ready(terrain: VoxelTerrain):
	voxel_tool = terrain.get_voxel_tool()
	set_process(true)


func _process(_delta):
	var character_position = character_entity.character.global_transform.origin
	var forward_direction = player.controller.get_direction()
	
	if forward_direction.length() == 0:
		return

	var lower = voxel_tool.raycast(character_position, forward_direction, 0.5)
	if not lower or lower.position == Vector3i.ZERO:
		return
	
	
	var upper = voxel_tool.raycast(character_position + Vector3.UP, forward_direction, 1)
	if upper and lower.position != Vector3i.ZERO:
		return
	
	character.global_position += Vector3.UP