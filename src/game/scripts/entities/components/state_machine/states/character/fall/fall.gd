extends CharacterState
class_name FallState

@export var idle_node: NodePath
@export var walk_node: NodePath
# @export var hang_gliding_node: NodePath

@onready var idle_state: State = get_node(idle_node)
@onready var walk_state: State = get_node(walk_node)
# @onready var hang_gliding_state: State = get_node(hang_gliding_node)


#var gravity = null
#var speed = null


#var direction_before_falling: Vector3 = Vector3.ZERO
#
#func enter() -> void:
#	var input_dir := Input.get_vector("controls_left", "controls_right", "controls_forward", "controls_backward")
#	if input_dir.length_squared() > 1.0: input_dir = input_dir.normalized()
#
#	var direction = (character_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
#	direction_before_falling = direction.rotated(Vector3.UP, character_body.springArmPlayer.rotation.y)

func physics_process(delta: float) -> State:
	var direction := character_controller.get_direction()
	
	character_body.move(direction, delta)

	if character_body.is_on_floor():
		if direction.length_squared() == 0:
			return idle_state
		
		return walk_state
	
#	if hang_gliding_state.can_transition_to():
#		return hang_gliding_state

	return null
