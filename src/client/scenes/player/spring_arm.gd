extends SpringArm3D


@export
var mouse_sensibilty := 0.005

var lock: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not lock:
		rotation.x = clamp(rotation.x - event.relative.y * mouse_sensibilty, -90., 30.)
		rotation.y = wrapf(rotation.y - event.relative.x * mouse_sensibilty, .0, 360.)
	
	elif event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				# Get the mouse back
				lock = not lock
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if lock else Input.MOUSE_MODE_CAPTURED)
