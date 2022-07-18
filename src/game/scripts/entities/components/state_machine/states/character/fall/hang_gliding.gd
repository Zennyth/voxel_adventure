extends FallState
class_name HangGlidingState

@export var fall_node: NodePath
@onready var fall_state: State = get_node(fall_node)

const inventory_key := Inventory.InventoryCategory.CHARACTER_EQUIPMENTS
var equipment_key := Travel.get_key(Travel.TravelCategory.HANG_GLIDING)

var slot: Slot = null
var hang_glider: Travel = null

var is_hang_glider_used: bool = false:
	get:
		return slot and slot.is_active and hang_glider != null

func enter() -> void:
	animation_state_machine.travel("Idle")

func _on_travel_stack_change(stack: Stack):
	if not stack:
		hang_glider = null
		return
	
	update_hang_glider(stack)


###
# BUILT-IN
###
func update_hang_glider(stack: Stack):
	hang_glider = stack.item.item_reference as Travel

	if hang_glider:
		speed = hang_glider.speed
		gravity = hang_glider.gravity


###
# OVERRIDE
###
func init_state(linked_character_controller: Controller):
	super.init_state(linked_character_controller)
	if not character_body or not character_body.get("data"):
		return
	
	slot = character_body.data.get_slot(inventory_key, equipment_key)
	if slot:
		slot._stack_changed.connect(_on_travel_stack_change)
		if not slot.is_empty():
			update_hang_glider(slot.stack)

func can_transition_to() -> bool:
	return is_hang_glider_used


func physics_process(delta: float):
	if not can_transition_to():
		return fall_state

	return super.physics_process(delta)
