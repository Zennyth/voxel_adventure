extends Component
class_name Controller

func get_direction() -> Vector3:
	return Vector3.ZERO
	
func get_controllable() -> Character:
	return null
	
func is_moving() -> bool:
	return get_direction().length_squared() != 0

func is_jumping() -> bool:
	return false
