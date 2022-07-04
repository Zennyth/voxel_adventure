extends Controller
class_name PlayerController

@export var player_path: NodePath
@onready var player: Player = get_node(player_path)

func get_direction() -> Vector3:
	var input_dir := Input.get_vector("controls_left", "controls_right", "controls_forward", "controls_backward")
	if input_dir.length_squared() > 1.0: input_dir = input_dir.normalized()
	
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, player.springArmPlayer.rotation.y)
	
	return direction

func get_controllable() -> Character:
	return player as Character

func is_jumping() -> bool:
	return Input.is_action_just_pressed("ui_accept")

func is_traveling() -> bool:
    return Input.is_action_just_pressed("ui_traveling")
