extends MoveState
class_name JumpState

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	physics_component.jump()

func physics_process(delta: float) -> State:
	var state = super.physics_process(delta)
	if state:
		return state

	if physics_component.is_on_floor():
		return idle_state
	
	return null
