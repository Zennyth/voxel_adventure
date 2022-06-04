class_name MoveState
extends State

@export var idle_node: NodePath
@export var jump_node: NodePath
@export var fall_node: NodePath
@export var walk_node: NodePath

@onready var idle_state: State = get_node(idle_node)
@onready var jump_state: State = get_node(jump_node)
@onready var fall_state: State = get_node(fall_node)
@onready var walk_state: State = get_node(walk_node)

func input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_accept"):
		return jump_state

	return null

func physics_process(delta: float) -> State:
	if !physics_component.is_on_floor():
		return fall_state
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("controls_left", "controls_right", "controls_forward", "controls_backward")
	if input_dir.length_squared() > 1.0: input_dir = input_dir.normalized()
	
	var direction = (physics_component.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, physics_component.SpringArm.rotation.y)
	
	physics_component.add_gravity(delta)
	physics_component.move(direction)
	physics_component.update()
	
	if direction.length_squared() == 0:
		return idle_state

	return null
