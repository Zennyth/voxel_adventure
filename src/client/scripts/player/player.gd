extends Character

@export var speed: float = 5.0
@export var gravity: float = 9.8
@export var jump_force: float = 5.0

@export var head: NodePath
# Not used in this script, but might be useful for child nodes because
# this controller will most likely be on the root
@export var terrain: NodePath
@onready var _spring_arm: SpringArm3D = $SpringArm3D

var _velocity = Vector3()
var _grounded = false
var _head = null
var _box_mover = VoxelBoxMover.new()


func _ready() -> void:
	_box_mover.set_collision_mask(1) # Excludes rails
	_head = get_node(head)

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
	
	if _velocity.length() > .2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()
	
	if Input.is_key_pressed(KEY_F):
		_spells_manager.cast_fireball(direction)
		Server.send_fireball(direction)

	assert(delta > 0)
	_velocity = motion / delta

	
func define_state() -> void:
	var state = get_state()
	state["R"] = _model.rotation
	Server.send_player_state(state)
