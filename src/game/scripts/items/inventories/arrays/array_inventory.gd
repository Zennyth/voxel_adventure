class_name ArrayInventory
extends Inventory

@export var slots := []

func _init(slot_number: int):
	for i in range(slot_number):
		slots.append(Slot.new(i))

func get_slot(index: int) -> Slot:
	return slots[index]

func get_slot_number() -> int:
	return len(slots)


func set_stack(index: int, new_stack: Stack) -> Stack:
	var slot: Slot = get_slot(index)

	var previous_stack: Stack = slot.stack
	slot.set_stack(new_stack)
	# emit_signal("stacks_changed", [index])
	return previous_stack

func remove_stack(index: int) -> Stack:
	var slot: Slot = get_slot(index)

	var previous_stack: Stack = slot.stack
	slot.set_stack(null)
	# emit_signal("stacks_changed", [index])
	return previous_stack

func set_stack_quantity(index: int, amount: int):
	var slot: Slot = get_slot(index)

	slot.stack.quantity += amount
	if slot.stack.quantity <= 0:
		remove_stack(index)
	else:
		pass
		# emit_signal("stacks_changed", [index])
