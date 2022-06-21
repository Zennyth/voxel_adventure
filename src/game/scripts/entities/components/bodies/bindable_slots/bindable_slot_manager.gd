extends Object
class_name BindableSlotManager

var slots: Dictionary = {}
var inventory: InventoryResource

func _init(inventory_reference: InventoryResource, slot_list: Array):
	inventory = inventory_reference
	inventory.connect("stack_changed", update_slot)

	for slot in slot_list:
		slots[slot.name] = slot
		inventory.set_stack(slot.name, StackResource.new(slot.item, 1))


func update_slot(stack: StackResource):
	if not stack.slot:
		return
	
	stack.slot.change_item(stack.item)
