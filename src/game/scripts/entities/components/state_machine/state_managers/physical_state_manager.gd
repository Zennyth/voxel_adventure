extends StateManager
class_name PhysicalStateManager

@export var character_controller_path: NodePath
@onready var character_controller: Controller = get_node(character_controller_path)

func _ready() -> void:
	super._ready()
	
	for state in get_children():
		if state is CharacterState:
			state.init_state(character_controller)
