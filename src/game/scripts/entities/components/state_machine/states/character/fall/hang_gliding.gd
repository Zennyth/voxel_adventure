extends FallState
class_name HangGlidingState

@export var fall_node: NodePath
@onready var fall_state: State = get_node(fall_node)

const inventory_key := Inventory.InventoryCategory.CHARACTER_EQUIPMENTS
const equipment_key := Equipment.EquipmentCategory.TRAVEL

var hang_glider: Travel = null

func _ready():
	var slot: Slot = character_body.data.get_slot(inventory_key, equipment_key)
	if slot:
		slot.stack_changed.connect(_on_travel_stack_change)

func _on_travel_stack_change(stack: Stack):
	hang_glider = stack.item as Travel

#	if hang_glider:
#		speed = hang_glider.speed
#		gravity = hang_glider.gravity

func can_transition_to() -> bool:
	return hang_glider != null

func physics_process(delta: float):
	if not hang_glider:
		return fall_node
	
	super.physics_process(delta)
