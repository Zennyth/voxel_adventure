extends MoveState
class_name WalkState

func input(event: InputEvent) -> State:
	# First run parent code and make sure we don't need to exit early
	# based on its logic
	var new_state = super.input(event)
	if new_state:
		return new_state

	return null

func can_transition_to() -> bool:
	return character_controller.is_moving()
