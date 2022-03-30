extends Character

@export var walk_speed: float = 8.0
@export var sprint_speed: float = 15.0
@export var accelaration: float = 6.0
@export var gravity: float = 9.8 / 5
@export var jump_force: float = 15

@export var head: NodePath
# Not used in this script, but might be useful for child nodes because
# this controller will most likely be on the root
@export var terrain: NodePath
@onready var _spring_arm: SpringArm3D = $SpringArm3D

var _velocity = Vector3()
var _vertical_velocity: float = 0
var _grounded = false
var _box_mover = VoxelBoxMover.new()
var _last_direction = Vector3.FORWARD


func _ready() -> void:
	super()
	name = str(Server.multiplayer.get_unique_id())
	_box_mover.set_collision_mask(1) # Excludes rails

func _physics_process(delta: float) -> void:
	movement_process(delta)
	define_state()


func movement_process(delta: float) -> void:
	var direction := Vector3.ZERO
	direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	direction.z = Input.get_action_strength("forward") - Input.get_action_strength("back")
	direction = - direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
	var speed := walk_speed
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	
	_velocity = _velocity.lerp(direction * speed, delta * accelaration)
	_velocity += Vector3.DOWN * _vertical_velocity

	if _grounded and Input.is_key_pressed(KEY_SPACE):
		_velocity.y = jump_force
		_grounded = false
	
	if not _grounded:
		_vertical_velocity += gravity * delta
	else:
		_vertical_velocity = gravity * delta

	var motion = _velocity * delta

	if has_node(terrain):
		var aabb = AABB(Vector3(-0.4, -0.9, -0.4), Vector3(0.8, 1.8, 0.8))
		var terrain_node = get_node(terrain)
		var prev_motion = motion
		motion = _box_mover.get_motion(position, motion, aabb, terrain_node)
		
		if abs(motion.y) < 0.001 and prev_motion.y < -0.001:
			if not _grounded: _vertical_velocity = gravity * delta
			
			_grounded = true
		if abs(motion.y) > 0.001:
			_grounded = false
		
		global_translate(motion)
	
	var look_direction = atan2(direction.x, - direction.z)
	if look_direction != 0:
		_last_direction = direction
		_model.rotation.y = lerp_angle(_model.rotation.y, - look_direction, delta * 7)
		# _model.rotation.z = lerp_angle(_model.rotation.z, - direction.x / 7, delta)
		# _model.rotation.x = lerp_angle(_model.rotation.x, direction.z / 7, delta)

	if Input.is_key_pressed(KEY_F):
		var direction_test: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, _spring_arm.rotation.y)
		direction_test = direction_test.rotated(Vector3.LEFT, - _spring_arm.rotation.x)
		_spells_manager.cast_fireball(direction_test)
		Server.send_fireball(direction_test)
#
	assert(delta > 0)
	_velocity = motion / delta

	
func define_state() -> void:
	var state = get_state()
	state["R"] = _model.rotation
	Server.send_player_state(state)

func _on_stats_hp_depleted():
	queue_free()
