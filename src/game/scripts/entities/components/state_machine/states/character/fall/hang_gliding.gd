extends FallState
class_name HangGlidingState

@export var fall_node: NodePath
@onready var fall_state: State = get_node(fall_node)

const inventory_key := Inventory.InventoryCategory.CHARACTER_EQUIPMENTS
const equipment_key := Travel.TravelCategory.HANG_GLIDING

var hang_glider: Travel = null

func init_state(linked_character_controller: Controller):
	super.init_state(linked_character_controller)
	if not character_body or not character_body.get("data"):
		return
	
	var slot: Slot = character_body.data.get_slot(inventory_key, equipment_key)
	if slot:
		slot._stack_changed.connect(_on_travel_stack_change)
		if not slot.is_empty():
			update_hang_glider(stack)

func _on_travel_stack_change(stack: Stack):
	if not stack:
		hang_glider = null
		return
	
    update_hang_glider(stack)

func update_hang_glider(stack: Stack):
    hang_glider = stack.item as Travel

    if hang_glider:
        speed = hang_glider.speed
        gravity = hang_glider.gravity


func can_transition_to() -> bool:
	return hang_glider != null and character_controller.is_traveling()


func physics_process(delta: float):
	if not can_transition_to():
		return fall_state

	return super.physics_process(delta)
