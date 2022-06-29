extends Resource
class_name Inventory

enum InventoryCategory {
	CHARACTER_COSMETIC,
	CHARACTER_EQUIPMENTS
}

func get_slot(index) -> Slot:
	return null

func get_slot_number() -> int:
	return 0

func get_slots() -> Array:
	return []

func get_indexes() -> Array:
	return []


func set_stack(index: int, new_stack: Stack) -> Stack:
	var slot: Slot = get_slot(index)

	var previous_stack: Stack = slot.stack
	slot.set_stack(new_stack)
	return previous_stack

func remove_stack(index: int) -> Stack:
	var slot: Slot = get_slot(index)

	var previous_stack: Stack = slot.stack
	slot.set_stack(null)
	return previous_stack

func set_stack_quantity(index, amount: int) -> int:
	var slot: Slot = get_slot(index)
	return slot.stack.fill_to(amount)
