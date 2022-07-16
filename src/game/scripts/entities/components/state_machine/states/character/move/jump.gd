extends MoveState
class_name JumpState

func enter() -> void:
	super.enter()
	animation_state_machine.travel("Idle")
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
