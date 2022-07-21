extends Component
class_name StateManager

@export var starting_state: NodePath
@onready var current_state

@export var debug: bool = false
@onready var debug_label: LabelComponent = $Debug

func init(linked_entity: Entity) -> void:
	super.init(linked_entity)
	
	if not is_authoritative():
		process_mode = Node.PROCESS_MODE_DISABLED

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	
	if debug and debug_label != null:
		debug_label.set_text(current_state.name)

func check_change_state(new_state: State) -> void:
	if new_state:
		change_state(new_state)

func _ready() -> void:
	# Initialize with a default state
	change_state(get_node(starting_state))
	


func _physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	check_change_state(new_state)

func _input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	check_change_state(new_state)

func _process(delta: float) -> void:
	var new_state = current_state.process(delta)
	new_state = current_state.input(null)
	check_change_state(new_state)
