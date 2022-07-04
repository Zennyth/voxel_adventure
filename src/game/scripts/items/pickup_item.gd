extends Entity
class_name PickupItem

@onready var ItemInstance := $ItemInstance
var stack: Stack = null:
    set(_stack):      
        stack = _stack
        if not stack.is_empty():
            ItemInstance.mesh = stack.item.mesh

###
# OVERRIDE
###
var pickup_item: Node3D
func _init():
	pickup_item = $"." as Node3D

func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	state[WorldState.STATE_KEYS.ITEM_NAME] = stack.item.name if stack and not stack.is_empty() else ""
	state[WorldState.STATE_KEYS.STACK_QUANTITY] = stack.quantity

	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
    if WorldState.STATE_KEYS.ITEM_NAME in new_state:
        stack.item = Database.items.get_by_name(new_state[WorldState.STATE_KEYS.ITEM_NAME])
    
    if WorldState.STATE_KEYS.STACK_QUANTITY in new_state:
        stack.quantity = new_state[WorldState.STATE_KEYS.STACK_QUANTITY]
	
	super.set_stable_state(new_state, component)


func get_unstable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	state[WorldState.STATE_KEYS.POSITION] = pickup_item.position
	state[WorldState.STATE_KEYS.ROTATION] = pickup_item.rotation
	
	return super.get_unstable_state(state, component)

func set_unstable_state(new_state: Dictionary, component: Node = self) -> void:  
    if WorldState.STATE_KEYS.ROTATION in new_state:
        pickup_item.set_rotation(new_state[WorldState.STATE_KEYS.ROTATION])
    
    if WorldState.STATE_KEYS.POSITION in new_state:
        pickup_item.set_position(new_state[WorldState.STATE_KEYS.POSITION])
	
	super.set_unstable_state(new_state, component)