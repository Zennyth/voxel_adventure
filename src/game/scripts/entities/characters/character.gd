extends Entity
class_name Character

var character: CharacterBody3D
	
func _init():
	character = $"." as CharacterBody3D


var inventories := {}



@export var SPEED := 10.0
@export var JUMP_VELOCITY := 8.0
# Get the gravity from the project settings to be synced with CharacterBody3D nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func jump():
	if character.is_on_floor():
		character.velocity.y = JUMP_VELOCITY

func move(direction, delta: float):
	if not character.is_on_floor():
		character.velocity.y -= gravity * delta

	if direction:
		character.velocity.x = direction.x * SPEED
		character.velocity.z = direction.z * SPEED
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, SPEED)
		character.velocity.z = move_toward(character.velocity.z, 0, SPEED)
	
	update()
		
func update():
	if is_authoritative(): 
		character.move_and_slide()
		update_unstable_state()
	
func get_unstable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	state[WorldState.STATE_KEYS.POSITION] = character.position
	state[WorldState.STATE_KEYS.ROTATION] = character.rotation
	
	return super.get_unstable_state(state, component)

func set_unstable_state(new_state: Dictionary, component: Node = self) -> void:
	for key in new_state.keys():
		match key:
			WorldState.STATE_KEYS.ROTATION:
				character.set_rotation(new_state[key])
			WorldState.STATE_KEYS.POSITION:
				character.set_position(new_state[key])
	
	super.set_unstable_state(new_state, component)
