extends Node3D

@export
var speed: float = 5.0
@export
var gravity: float = 9.8
@export
var jump_force: float = 5.0
@export
var head: NodePath
@export
var terrain: NodePath

@onready
var _spring_arm: SpringArm3D = $SpringArm3D
@onready
var _spells = $Spells

var _velocity = Vector3()
var _grounded = false
var _head = null
var _box_mover = VoxelBoxMover.new()

# networking
var player_state


func _ready() -> void:
	_box_mover.set_collision_mask(1) # Excludes rails
	_head = get_node(head)

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
	
	if has_node(terrain):
		var aabb = AABB(Vector3(-0.4, -0.9, -0.4), Vector3(0.8, 1.8, 0.8))
		var terrain_node = get_node(terrain)
		var prev_motion = motion
		motion = _box_mover.get_motion(position, motion, aabb, terrain_node)
		if abs(motion.y) < 0.001 and prev_motion.y < -0.001:
			_grounded = true
		if abs(motion.y) > 0.001:
			_grounded = false
	
	global_translate(motion)
	
	if Input.is_key_pressed(KEY_F):
		_spells.cast_fireball(direction)
		Server.send_fireball(direction)
	
	if _velocity.length():
		var look_direction = Vector2(_velocity.z, _velocity.x)
		$Modular.rotation.y = look_direction.angle()

	assert(delta > 0)
	_velocity = motion / delta
	
func define_state() -> void:
	player_state = {
		"T": Server.client_clock,
		"P": position
	}
	
	Server.send_player_state(player_state)
