extends MoveState
class_name JumpState

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	character_body.jump()

func physics_process(delta: float) -> State:
	var state = super.physics_process(delta)
	if state:
		return state

	if character_body.is_on_floor():
		return idle_state
	
	return null

func can_transition_to() -> bool:
	return character_controller.is_jumping()
