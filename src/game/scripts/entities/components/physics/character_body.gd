extends CharacterBody3D

@export var SPEED := 50.0
@export var JUMP_VELOCITY := 45.0
# Get the gravity from the project settings to be synced with CharacterBody3D nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var SpringArm: SpringArm3D = $SpringArm3D
	
func add_gravity(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta

func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func move(direction):
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
func update():
	if Multiplayer.is_entity_authoritative((get_parent() as Entity).id): 
		move_and_slide()

		Multiplayer.update_entity_unreliable_state((get_parent() as Entity).get_unreliable_state())
	
func get_unreliable_state(state: Dictionary):
	state['p'] = position
	state['r'] = rotation

func set_unreliable_state(state: Dictionary):
	for key in state.keys():
		match key:
			'r':
				set_rotation(state[key])
			'p':
				set_position(state[key])
