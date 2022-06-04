extends State
class_name IdleState

@export var jump_node: NodePath
@export var fall_node: NodePath
@export var walk_node: NodePath

@onready var jump_state: State = get_node(jump_node)
@onready var fall_state: State = get_node(fall_node)
@onready var walk_state: State = get_node(walk_node)


func input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("controls_left") or Input.is_action_just_pressed("controls_right") or Input.is_action_just_pressed("controls_forward") or Input.is_action_just_pressed("controls_backward"):
		return walk_state
	elif Input.is_action_just_pressed("ui_accept"):
		return jump_state
	return null

func physics_process(delta: float) -> State:
	physics_component.add_gravity(delta)
	physics_component.update()

	if !physics_component.is_on_floor():
		return fall_state
	
	return null
