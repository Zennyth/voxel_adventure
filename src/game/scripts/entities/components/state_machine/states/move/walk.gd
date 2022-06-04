extends MoveState
class_name WalkState

func input(event: InputEvent) -> State:
	# First run parent code and make sure we don't need to exit early
	# based on its logic
	var new_state = super.input(event)
	if new_state:
		return new_state

	return null
