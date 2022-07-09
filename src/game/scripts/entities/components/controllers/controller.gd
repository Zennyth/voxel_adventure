extends Component
class_name Controller

func init(linked_entity: Entity) -> void:
	super.init(linked_entity)
	
	if not entity.is_authoritative():
		process_mode = Node.PROCESS_MODE_DISABLED

func get_direction() -> Vector3:
	return Vector3.ZERO
	
func get_controllable() -> Character:
	return null
	
func is_moving() -> bool:
	return get_direction().length_squared() != 0

func is_jumping() -> bool:
	return false
