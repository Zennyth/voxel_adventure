extends Node
class_name StateManager

@export var starting_state: NodePath
@onready var current_state

@export var physics_component_node: NodePath
@onready var physics_component: Node = get_node(physics_component_node)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func _ready() -> void:
	for state in get_children():
		state.physics_component = physics_component
	
	# Initialize with a default state of idle
	change_state(get_node(starting_state))
	
# Pass through functions for the Player to call,
# handling state changes as needed
func _physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

func _input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

func _process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
