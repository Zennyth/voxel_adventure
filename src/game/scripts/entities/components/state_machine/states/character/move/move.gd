extends CharacterState
class_name MoveState

@export var idle_node: NodePath
@export var jump_node: NodePath
@export var fall_node: NodePath
@export var walk_node: NodePath

@onready var idle_state: State = get_node(idle_node)
@onready var jump_state: State = get_node(jump_node)
@onready var fall_state: State = get_node(fall_node)
@onready var walk_state: State = get_node(walk_node)

func input(_event: InputEvent) -> State:
	if jump_state.can_transition_to():
		return jump_state

	return null

func physics_process(delta: float) -> State:
	if !character_body.is_on_floor():
		return fall_state
	
	var direction := character_controller.get_direction()
	character_body.move(direction, delta)
	
	if direction.length_squared() == 0:
		return idle_state

	return null
