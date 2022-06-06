extends Entity
class_name Character

var character: CharacterBody3D

func init(entity_id: int) -> void:
	super.init(entity_id)
	
	var this = $"."
	if this is CharacterBody3D:
		character = this as CharacterBody3D

	if not Multiplayer.is_entity_authoritative(id):
		$VoxelViewer.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		# Spawn the character
		Multiplayer.update_entity_stable_state(get_stable_state())
	
	get_node("Label3D").init(self)
	get_node("SpringArm3D/Camera3D").current = Multiplayer.is_entity_authoritative(id)



@export var SPEED := 10.0
@export var JUMP_VELOCITY := 8.0
# Get the gravity from the project settings to be synced with CharacterBody3D nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var SpringArm: SpringArm3D = $SpringArm3D
	
func add_gravity(delta: float):
	if not character.is_on_floor():
		character.velocity.y -= gravity * delta

func jump():
	if character.is_on_floor():
		character.velocity.y = JUMP_VELOCITY

func move(direction):
	if direction:
		character.velocity.x = direction.x * SPEED
		character.velocity.z = direction.z * SPEED
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, SPEED)
		character.velocity.z = move_toward(character.velocity.z, 0, SPEED)
		
func update():
	if Multiplayer.is_entity_authoritative(id): 
		character.move_and_slide()

		Multiplayer.update_entity_unstable_state(get_unstable_state())
	
func get_unstable_state(component: Node = self, state: Dictionary = { 'id': id }) -> Dictionary:
	state['p'] = character.position
	state['r'] = character.rotation
	
	return super.get_unstable_state(component, state)

func set_unstable_state(new_state: Dictionary, component: Node = self) -> void:
	for key in new_state.keys():
		match key:
			'r':
				character.set_rotation(new_state[key])
			'p':
				character.set_position(new_state[key])
	
	super.set_unstable_state(new_state, component)
