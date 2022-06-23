extends Object
class_name BindableSlotManager

var slots: Dictionary = {}
var inventory: DictionaryInventory

func _init(inventory_reference: DictionaryInventory, slot_list: Array):
	inventory = inventory_reference
	inventory.connect("stack_changed", update_slot)

	for slot in slot_list:
		slots[slot.name] = slot
		inventory.set_stack(slot.name, Stack.new(slot.item, 1))


func update_slot(stack: Stack):
	if not stack.slot:
		return
	
	stack.slot.change_item(stack.item)
