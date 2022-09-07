extends SpringArm3D
class_name SpringArmPlayer

@export
var mouse_sensibilty := 0.005

var lock: bool = false

var player: Entity

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not lock:
		rotation.x = clamp(rotation.x - event.relative.y * mouse_sensibilty, - PI / 2, PI / 2)
		rotation.y = wrapf(rotation.y - event.relative.x * mouse_sensibilty, - PI, PI)
	
	elif event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				Game.ui_manager.is_lock = !Game.ui_manager.is_lock

@onready 
var camera: Camera3D = $Camera3D

func init(linked_player: Entity) -> void:
	player = linked_player
	Game.ui_manager._is_lock_changed.connect(_on_is_lock_changed)
	set_camera_current()

func _on_is_lock_changed(is_lock: bool):
	lock = is_lock

func _ready():
	set_camera_current()

func set_camera_current():
	if not camera or not player:
		return
	
	camera.current = player.is_authoritative()
