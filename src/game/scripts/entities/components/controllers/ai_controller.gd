extends Controller
class_name AIController

@export var character_path: NodePath
@onready var character: Character = get_node(character_path)
@onready var detection: Area3D = $Detection

var current_target: Character

func _ready():
	
	if not character.is_authoritative():
		detection.process_mode = Node.PROCESS_MODE_DISABLED 
		return
	
	detection.connect("body_entered", _on_detection_body_entered)
	detection.connect("body_exited", _on_detection_body_exited)

func get_direction() -> Vector3:
	if current_target == null:
		return super.get_direction()
	
	return character.position.direction_to(current_target.position) 

func get_controllable() -> Character:
	return character

func is_jumping() -> bool:
	return false


func _on_detection_body_entered(body):
	if body != character and body is Character and current_target == null:
		current_target = body as Character

func _on_detection_body_exited(body):
	if body is Character and current_target == body:
		current_target = null
