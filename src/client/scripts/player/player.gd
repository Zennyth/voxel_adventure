extends Character

@export
var speed: float = 5.0
@export
var gravity: float = 9.8
@export
var jump_force: float = 5.0

@onready
var _spring_arm: SpringArm3D = $SpringArm3D

var _velocity = Vector3()
var _grounded = false


func _ready() -> void:
	_model = $Modular
	_spells_manager = $SpellsManager

func _physics_process(delta: float) -> void:
	movement_process(delta)
	define_state()


func movement_process(delta: float) -> void:
	var direction := Vector3.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
	_velocity.x = direction.x * speed
	_velocity.z = direction.z * speed
	_velocity.y -= gravity * delta 
	
	if _grounded and Input.is_key_pressed(KEY_SPACE):
		_velocity.y = jump_force
		_grounded = false
	
	var motion = _velocity * delta
	
	global_translate(motion)
	
	if Input.is_key_pressed(KEY_F):
		_spells_manager.cast_fireball(direction)
		Server.send_fireball(direction)
	
	if _velocity.length():
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()

	assert(delta > 0)
	_velocity = motion / delta
	
func define_state() -> void:
	Server.send_player_state(get_state())
