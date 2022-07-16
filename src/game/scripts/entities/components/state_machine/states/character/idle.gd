extends CharacterState
class_name IdleState

@export var jump_node: NodePath
@export var fall_node: NodePath
@export var walk_node: NodePath

@onready var jump_state: State = get_node(jump_node)
@onready var fall_state: State = get_node(fall_node)
@onready var walk_state: State = get_node(walk_node)

func enter() -> void:
	animation_state_machine.travel("Idle")

func input(_event: InputEvent) -> State:
	if walk_state.can_transition_to():
		return walk_state
	elif jump_state.can_transition_to():
		return jump_state
	return null

func physics_process(delta: float) -> State:
	character_body.move(null, delta)

	if !character_body.is_on_floor():
		return fall_state
	
	return null
